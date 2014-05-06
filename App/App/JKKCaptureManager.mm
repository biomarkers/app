//
//  JKKCaptureManager.m
//  CameraControl
//
//  Created by Kevin on 11/15/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//

#import "JKKCaptureManager.h"

@implementation JKKCaptureManager

- (void)initializeSession {
    self.session = [[AVCaptureSession alloc] init];
    
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset640x480]) {
        self.session.sessionPreset = AVCaptureSessionPreset640x480;
    } else {
        throw [NSException exceptionWithName:@"SessionInitializationException" reason:@"640x480 session preset not available" userInfo:nil];
    }
}

- (void)initializeDevice:(BOOL) useFront {
    NSError *error;
    
    //hessk: define the device for the sessions: using default device here
    NSLog(@"Capture manager: setting device for session...");
    
    AVCaptureDevice* newDevice;
    
    if (useFront) {
        newDevice = [self getFrontCamera];
    } else {
        newDevice = [self getBackCamera];
    }
    
    if (!newDevice) {
        throw [NSException exceptionWithName:@"CameraInitializationException" reason:nil userInfo:nil];
    }
    
    NSLog(@"Capture manager: changing camera settings...");
    //hessk: change various camera settings
    //white balance
    if ([newDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Capture manager: lock error occurred while trying to set white balance.");
        }
    }
    
    //exposure
    if ([newDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Capture manager: lock error occurred while trying to set exposure mode");
        }
    }
    
    //focus
    if ([newDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Capture manager: lock error occurred while trying to set focus mode");
        }
    }
    
    self.device = newDevice;
    
    NSLog(@"Capture manager: initializing session video input...");
    //hessk: initialize inputs for sessions
    AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:&error];
    [self.session addInput:videoIn];
}

- (void)initializeVideoOutWithFPS:(int)fps usingDelegate:(id)delegate{
    NSLog(@"Capture manager: initializing session video output...");
    //hessk: apple code stuffs
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [self.session addOutput:videoOut];
    videoOut.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    [self setFrameRate:fps];
    
    dispatch_queue_t queue = dispatch_queue_create("VideoOutQueue", NULL);
    [videoOut setSampleBufferDelegate:delegate queue:queue];
}

- (void)initializePreviewLayerUsingView:(UIImageView *)cameraView withLayer:(AVCaptureVideoPreviewLayer *)layer {
    NSLog(@"Capture manager: initializing camera preview layer...");
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    
    UIView *view = cameraView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    CGRect bounds = [view bounds];
    
    [newCaptureVideoPreviewLayer setFrame:bounds];
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [viewLayer addSublayer:newCaptureVideoPreviewLayer];
    
    layer = newCaptureVideoPreviewLayer;
}

- (void)startSession {
    NSLog(@"Capture manager: starting camera...");
    [self.session startRunning];
}

- (void)stopSession {
    NSLog(@"Capture manager: stopping camera");
    [self.session stopRunning];
}

- (NSError*)setFrameRate: (int)fps {
    NSError *error;
    
    /* 
     * hessk: CMTimeMake creates a time interval with the first parameter as the numerator and the second
     * parameter as the denominator. So: 1, 25 -> minumum frame duration is 1/25 of a second.
     */
    
    [self.device lockForConfiguration:&error];
    self.device.activeVideoMinFrameDuration = CMTimeMake(1, fps);
    self.device.activeVideoMaxFrameDuration = CMTimeMake(1, fps);
    [self.device unlockForConfiguration];
    
    return error;
}

- (void)toggleAutoExposure {
    NSError *error;
    
    if ((self.device.exposureMode != AVCaptureExposureModeContinuousAutoExposure) && [self.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        [self.device lockForConfiguration:&error];
        self.device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
        [self.device unlockForConfiguration];
    } else if ([self.device isExposureModeSupported:AVCaptureExposureModeLocked]) {
        [self.device lockForConfiguration:&error];
        self.device.exposureMode = AVCaptureExposureModeLocked;
        [self.device unlockForConfiguration];
    } else {
        NSLog(@"Error toggling exposure mode; exposure mode not supported for this camera.");
    }
    
}

- (void)toggleAutoWB {
    NSError *error;
    
    if (self.device.whiteBalanceMode != AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance && [self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        [self.device lockForConfiguration:&error];
        self.device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
        [self.device unlockForConfiguration];
    } else if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
        [self.device lockForConfiguration:&error];
        self.device.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
        [self.device unlockForConfiguration];
    } else {
        NSLog(@"Error toggling white balance mode; white balance mode not supported for this camera.");
    }
    
    
}

- (void)toggleAutoFocus {
    NSError *error;
    
    if (self.device.focusMode != AVCaptureFocusModeContinuousAutoFocus && [self.device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [self.device lockForConfiguration:&error];
        self.device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
        [self.device unlockForConfiguration];
    } else if ([self.device isFocusModeSupported:AVCaptureFocusModeLocked]) {
        [self.device lockForConfiguration:&error];
        self.device.focusMode = AVCaptureFocusModeLocked;
        [self.device unlockForConfiguration];
    } else {
        NSLog(@"Error toggling white balance mode; white balance mode not supported for this camera.");
    }
}

- (AVCaptureDevice *)getFrontCamera {
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice* device in devices) {
        if ([device position] == AVCaptureDevicePositionFront) {
            return device;
        }
    }
    
    return nil;
}

- (AVCaptureDevice *)getBackCamera {
    NSArray* devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice* device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            return device;
        }
    }
    
    return nil;
}

/* Apple's image conversion function */
+ (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    
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

/* OpenCV tutorial code **************************************************************************************** */
+ (cv::Mat)cvMatFromUIImage:(UIImage *)image
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

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
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



/*
hessk:
 This function returns an array of available devices on the system - may be useful.

 [AVCaptureDevice devices]
*/