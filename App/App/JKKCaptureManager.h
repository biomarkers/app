//
//  JKKCaptureManager.h
//  CameraControl
//
//  Created by Kevin on 11/15/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//
#pragma once
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JKKCaptureManager : NSObject 

@property AVCaptureSession *session;
@property AVCaptureDevice *device;

- (void)initializeSession;
- (void)initializeDevice: (BOOL) useFront;
- (void)captureImage;
- (void)toggleAutoExposure;
- (void)toggleAutoWB;
- (void)toggleAutoFocus;

@end
