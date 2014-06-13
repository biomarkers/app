//
//  JKKCaptureManager.h
//  CameraControl
//
//  Created by Kevin Hess on 11/15/13.
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
- (void)initializeVideoOutWithFPS: (int)fps usingDelegate: (id)delegate;
- (void)initializePreviewLayerUsingView: (UIImageView*)cameraView withLayer: (AVCaptureVideoPreviewLayer*)layer;

- (void)startSession;
- (void)stopSession;

- (void)toggleAutoExposure;
- (void)toggleAutoWB;
- (void)toggleAutoFocus;

+ (UIImage *)imageFromSampleBuffer: (CMSampleBufferRef)sampleBuffer;
+ (cv::Mat)cvMatFromUIImage: (UIImage *)image;
+ (UIImage *)UIImageFromCVMat: (cv::Mat)cvMat;

@end
