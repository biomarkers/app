//
//  JKKCaptureManager.m
//  CameraControl
//
//  Created by Kevin on 11/15/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//

#import "JKKCaptureManager.h"

@implementation JKKCaptureManager
- (void)captureImage {
    //hessk: not sure what goes here
}

- (void)initializeSession {
    self.session = [[AVCaptureSession alloc] init];
}

- (void)initializeDevice:(BOOL) useFront {
    NSError *error;
    
    //hessk: define the device for the sessions: using default device here
    NSLog(@"Setting device for session...");
    
    AVCaptureDevice* newDevice;
    
    if (useFront) {
        newDevice = [self getFrontCamera];
    } else {
        newDevice = [self getBackCamera];
    }
    
    NSLog(@"Device set.");
    
    NSLog(@"Changing camera settings...");
    //hessk: change various camera settings
    //white balance
    if ([newDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Error setting white balance");
        }
    }
    
    //exposure
    if ([newDevice isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Error setting exposure mode");
        }
    }
    
    //focus
    if ([newDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Error setting focus mode");
        }
    }
    
    NSLog(@"Settings set.");
    self.device = newDevice;
    
    NSLog(@"Initializing session video input...");
    //hessk: initialize inputs for sessions
    AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:&error];
    [self.session addInput:videoIn];
    NSLog(@"Input initialized.");
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

@end



/*
hessk:
 This function returns an array of available devices on the system - may be useful.

 [AVCaptureDevice devices]
*/