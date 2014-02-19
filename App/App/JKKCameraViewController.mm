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

@end

NSUserDefaults* defaults;
BiomarkerImageProcessor processor;

const float TIMER_STEP = 0.01;

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
    
    /* hessk: Timer setup */
    self.timeElapsed = 0.0;
    [self.timer invalidate];
    self.timer = [NSTimer timerWithTimeInterval:TIMER_STEP target:self selector:@selector(updateProgress:) userInfo:NULL repeats:YES];
    self.timerCount = 0;
    
    /* hessk: AVFoundation camera setup */
    self.captureManager = [JKKCaptureManager new];
    [self.captureManager initializeSession];
    
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
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureManager.session];
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
    
    [self.statusLabel setText:@"Analyzing..."];
    NSLog(@"Camera state set to RUNNING");
    
    /* adds delay before calling endProcessing */
    [self performSelector:@selector(endProcessing) withObject:nil afterDelay: (self.test.model->getModelRunTime())];
}

- (void)updateProgress:(NSTimer *)timer {
    if ([self state] == RUNNING) {
        self.timerCount++;
        
        [self.progressBar setProgress:(self.timerCount * TIMER_STEP) / (self.test.model->getModelRunTime()) animated:YES];
        
        if (self.timerCount * TIMER_STEP >= self.test.model->getModelRunTime()) {
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
    
    if ([self isTakingCalibrationPoint]) {
        self.test.model->calibrate(processor.getSamples(), self.calibrationValue);
        
        [self performSegueWithIdentifier:@"returnToTestView" sender:self];
    } else /* if (there are results) */ {

        self.result.value = self.test.model->evaluate(processor.getSamples());

        // write results to database
        DataStore p = [[JKKDatabaseManager sharedInstance] openDatabase];
        ResultEntry entry(-1, [self.result.name UTF8String], [self.result.subject UTF8String], [self.result.subject UTF8String], self.result.value);
        p.insertResultEntry(entry);
        p.close();
        
        [self performSegueWithIdentifier:@"showResultsFromCamera" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showResultsFromCamera"]) {
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
    
    /* hessk: Kevin's code here ***************************************** */

    
    /******************************************************************** */
    
    CGDataProviderRelease(dataProvider);
    
    // Create and return an image object to represent the Quartz image.
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    return image;
}

#pragma mark - Protocol AVCaptureVideoDataOutputSampleBufferDelegate
- (void) captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if ([self state] == RUNNING) {
        IplImage *image = [self CreateIplImageFromUIImage:[self imageFromSampleBuffer:sampleBuffer]];
        cv::Scalar rgb = processor.process((cv::Mat)image);
        cvReleaseImage(&image);
        
        std::stringstream ss;
        ss << rgb;
        NSLog([NSString stringWithCString:ss.str().c_str()]);
    }
}

// hessk: TODO: read this license agreement
/* author: YOSHIMASA NIWA under MIT LICENSE ******************************************************************** */

// NOTE you SHOULD cvReleaseImage() for the return value when end of the code.
- (IplImage *)CreateIplImageFromUIImage:(UIImage *)image {
    // Getting CGImage from UIImage
    CGImageRef imageRef = image.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Creating temporal IplImage for drawing
    IplImage *iplimage = cvCreateImage(
                                       cvSize(image.size.width,image.size.height), IPL_DEPTH_8U, 4
                                       );
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage->imageData, iplimage->width, iplimage->height,
                                                    iplimage->depth, iplimage->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(
                       contextRef,
                       CGRectMake(0, 0, image.size.width, image.size.height),
                       imageRef
                       );
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *ret = cvCreateImage(cvGetSize(iplimage), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage, ret, CV_RGBA2BGR);
    cvReleaseImage(&iplimage);
    
    return ret;
}

// NOTE You should convert color mode as RGB before passing to this function
- (UIImage *)UIImageFromIplImage:(IplImage *)image {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data =
    [NSData dataWithBytes:image->imageData length:image->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        image->width, image->height,
                                        image->depth, image->depth * image->nChannels, image->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

/* ************************************************************************************************************* */

@end
