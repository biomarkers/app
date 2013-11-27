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
    self.session = [AVCaptureSession new];
}

- (void)initializeDevice {
    NSError *error;
    
    //hessk: define the device for the sessions: using default device here
    NSLog(@"Setting device for session...");
    AVCaptureDevice *newDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSLog(@"Device set.");
    
    
    NSLog(@"Changing camera settings...");
    //hessk: change various camera settings
    //white balance
    
    if ([newDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeLocked]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Error setting white balance");
        }
    }
    
    //exposure
    if ([newDevice isExposureModeSupported:AVCaptureExposureModeLocked]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.exposureMode = AVCaptureExposureModeLocked;
            [newDevice unlockForConfiguration];
        } else {
            //TODO: handle error
            NSLog(@"Error setting exposure mode");
        }
    }
    
    //focus
    if ([newDevice isFocusModeSupported:AVCaptureFocusModeLocked]) {
        if ([newDevice lockForConfiguration:&error]) {
            newDevice.focusMode = AVCaptureFocusModeLocked;
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

- (void)captureImage {
    //hessk: TODO: saving image files
}

- (void)toggleAutoExposure {
    NSError *error;
    
    [self.device lockForConfiguration:&error];
    
    if (self.device.exposureMode != AVCaptureExposureModeContinuousAutoExposure) {
        self.device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    } else {
        self.device.exposureMode = AVCaptureExposureModeLocked;
    }
    
    [self.device unlockForConfiguration];
}

- (void)toggleAutoWB {
    NSError *error;
    
    [self.device lockForConfiguration:&error];
    
    if (self.device.whiteBalanceMode != AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance) {
        self.device.whiteBalanceMode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    } else {
        self.device.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
    }
    
    [self.device unlockForConfiguration];
}

- (void)toggleAutoFocus {
    NSError *error;
    
    [self.device lockForConfiguration:&error];
    
    if (self.device.focusMode != AVCaptureFocusModeContinuousAutoFocus) {
        self.device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    } else {
        self.device.focusMode = AVCaptureFocusModeLocked;
    }
    
    [self.device unlockForConfiguration];
}

@end

/*
hessk:
 This function returns an array of available devices on the system - may be useful.

 [AVCaptureDevice devices]
*/