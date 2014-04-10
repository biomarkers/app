//
//  JKKCameraViewController.m
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKCameraViewController.h"

#import "JKKResultsViewController.h"

#import "BiomarkerImageProcessor.h"
#import "RegressionFactory.h"
#import "DataStore.h"
#import "ResultEntry.h"
#import "JKKDatabaseManager.h"

@interface JKKCameraViewController ()


//@property RegressionFactory factory;
//@property RegressionModel* model;

@property float timeElapsed;
@property (strong, nonatomic) JKKCaptureManager* captureManager;

@property NSTimer* timer;
@property int timerCount;
@property AVAudioPlayer* alertSound;
@property NSDate* timerStartDate;

@property ROIMode roiMode;
@property int roiX;
@property int roiY;
@property int roiR;

@end

NSUserDefaults* defaults;
BiomarkerImageProcessor processor;
bool overlayScaled = NO;
UIImage* outputImage;

const float TIMER_STEP = 0.1;

@implementation JKKCameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    if (!self.test) NSLog(@"No test loaded.");

    [self setState: POSITIONING];
    
    // hessk: Timer setup
    self.timeElapsed = 0.0;
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:TIMER_STEP target:self selector:@selector(updateProgress:) userInfo:NULL repeats:YES];
    self.timerCount = 0;
    
    // hessk: AVFoundation camera setup
    self.captureManager = [JKKCaptureManager new];
    [self.captureManager initializeSession];
    
    // hessk: region of interest setup
    self.roiMode = (ROIMode)[defaults integerForKey:@"kROIMode"];
    self.roiX = [defaults integerForKey:@"kROIX"];
    self.roiY = [defaults integerForKey:@"kROIY"];
    self.roiR = [defaults integerForKey:@"kROIR"];
    
    if (self.roiMode == AUTOMATIC) {
        processor.setCircleDetectionEnabled(true);
    } else if (self.roiMode == MANUAL) {
        processor.setCircleDetectionEnabled(false);
        
        processor.setCircleCenterX(self.roiX);
        processor.setCircleCenterY(self.roiY);
        
        processor.setCircleRadius(self.roiR);
    }
    
    // hessk: camera location setup
    CameraLocation location = (CameraLocation)[defaults integerForKey:@"kCameraLocation"];
    switch (location) {
        case FRONT:
            [self.captureManager initializeDevice:YES];
            break;
        case BACK:
        default:
            [self.captureManager initializeDevice:NO];
            break;
    }
    
    /* init video out *******************************************************************************************/
    NSLog(@"Initializing session video output...");
    //hessk: apple code stuffs
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [self.captureManager.session addOutput:videoOut];
    videoOut.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    videoOut.minFrameDuration = CMTimeMake(1, [defaults integerForKey:@"kFPS"]);
    
    dispatch_queue_t queue = dispatch_queue_create("VideoOutQueue", NULL);
    [videoOut setSampleBufferDelegate:self queue:queue];
    /* finish video out init ************************************************************************************/
    
    /* init preview layer ***************************************************************************************/
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureManager.session];
    self.cameraView.backgroundColor = [UIColor clearColor];
    UIView *view = self.cameraView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    CGRect bounds = [view bounds];
    [newCaptureVideoPreviewLayer setFrame:bounds];
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [viewLayer addSublayer:newCaptureVideoPreviewLayer];
    self.captureVideoPreviewLayer = newCaptureVideoPreviewLayer;
    /* finish init preview layer ********************************************************************************/
    
    [self.captureManager.session startRunning];
    NSLog(@"Camera started");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (IBAction)startProcessing:(id)sender {
    if (self.timer != nil) {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }

    [self.captureManager toggleAutoExposure];
    [self.captureManager toggleAutoFocus];
    [self.captureManager toggleAutoWB];

    [self.startButton setEnabled:NO];
    [self.startButton setHidden:YES];
    [self setState:RUNNING];
    
    processor.reset();
    
    [self.statusLabel setText:@"Analyzing"];
    NSLog(@"Camera state set to RUNNING");
    
    // adds delay before calling endProcessing and sets the start date for the countdown label
    [self setTimerStartDate:[NSDate date]];
    [self performSelector:@selector(endProcessing) withObject:nil afterDelay: (self.test.model->getModelRunTime())];
}

- (void)updateProgress:(NSTimer *)timer {
    if ([self state] == RUNNING) {
        NSTimeInterval timeSinceStart = [[NSDate date] timeIntervalSinceDate:self.timerStartDate];
        NSTimeInterval timeLeft = self.test.model->getModelRunTime() - timeSinceStart;
        double minutesLeft = floor(timeLeft / 60);
        double secondsLeft = trunc(timeLeft - (minutesLeft * 60));
        
        [self.progressBar setProgress: (timeSinceStart / self.test.model->getModelRunTime()) animated:YES];
        [self.statusLabel setText:[NSString stringWithFormat:@"Analyzing [%02.0f:%02.0f]", minutesLeft, secondsLeft]];
        
        if (timeLeft <= 0.0) {
            NSLog(@"Camera state set to DONE");
            [self setState:DONE];
            
            [self.timer invalidate];
            self.timer = nil;
        }
    }
}

- (void)endProcessing {
    /* Camera shutdown */
    [self.captureManager.session stopRunning];
    [self.captureManager setSession: nil];
    
    [self.statusLabel setText:@"Done."];

    /*
    // notification w/sound
    NSError* error;
#warning untested alert message
    NSURL *soundFile = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] URLForResource:@"Tock" withExtension:@"aiff"];
    self.alertSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFile error:&error];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Analysis completed."  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    
    [self.alertSound play];
    [alert show];
     */
    
    if ([self isTakingCalibrationPoint]) {
        self.test.model->calibrate(processor.getSamples(), self.calibrationValue);
        
        //[self performSegueWithIdentifier:@"returnToTestView" sender:self];
        [self performSegueWithIdentifier:@"showCalibrationResults" sender:self];
    } else /* if (there are results) */ {
        self.result.value = self.test.model->evaluate(processor.getSamples());
        
        [self performSegueWithIdentifier:@"showResultsFromCamera" sender:self];
    }
}

#pragma mark UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.alertSound stop];
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showCalibrationResults"]) {
        [[segue destinationViewController] setTest:self.test];
    } else if ([[segue identifier] isEqualToString:@"showResultsFromCamera"]) {
        [[segue destinationViewController] setResult:self.result];
        [[segue destinationViewController] setSourceView:self];
    }
}

/* Apple's image conversion function */
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    
    // This example assumes the sample buffer came from an AVCaptureOutput,
    // so its image buffer is known to be a pixel buffer.
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer.
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    
    // Get the number of bytes per row for the pixel buffer.
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height.
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space.
    static CGColorSpaceRef colorSpace = NULL;
    if (colorSpace == NULL) {
        colorSpace = CGColorSpaceCreateDeviceRGB();
        if (colorSpace == NULL) {
            // Handle the error appropriately.
            return nil;
        }
    }
    
    // Get the base address of the pixel buffer.
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // Get the data size for contiguous planes of the pixel buffer.
    size_t bufferSize = CVPixelBufferGetDataSize(imageBuffer);
    
    // Create a Quartz direct-access data provider that uses data we supply.
    CGDataProviderRef dataProvider =
    CGDataProviderCreateWithData(NULL, baseAddress, bufferSize, NULL);
    // Create a bitmap image from data supplied by the data provider.
    CGImageRef cgImage =
    CGImageCreate(width, height, 8, 32, bytesPerRow,
                  colorSpace, kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little,
                  dataProvider, NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    // Create and return an image object to represent the Quartz image.
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

#pragma mark - Protocol AVCaptureVideoDataOutputSampleBufferDelegate
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    outputImage = [self imageFromSampleBuffer:sampleBuffer];
    
    /* reverse x and y to account for difference between portrait/landscape discrepancy between camera view and preview view */
    float scaleX = self.cameraOverlayView.frame.size.width / outputImage.size.height;
    float scaleY = self.cameraOverlayView.frame.size.height / outputImage.size.width;
    
    @autoreleasepool {
        if ([self state] == RUNNING) {
            cv::Mat mat = [self cvMatFromUIImage:outputImage];
            cv::Scalar rgb = processor.process(mat);
            
            std::stringstream ss;
            ss << rgb;
            NSLog([NSString stringWithCString:ss.str().c_str()]);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cameraOverlayView updateCircleWithCenterX:processor.getCircleCenterY() centerY:processor.getCircleCenterX() radius:processor.getCircleRadius() scaleX:scaleX scaleY:scaleY];
    });
    
    outputImage = nil;
}

/* OpenCV tutorial code **************************************************************************************** */
- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    
    
    cv::cvtColor(cvMat, cvMat, CV_RGBA2BGR);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
