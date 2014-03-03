//
//  JKKCameraViewController.h
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//
#pragma once
#import <UIKit/UIKit.h>

#import "JKKModel.h"
#import "JKKResult.h"
#import "JKKCaptureManager.h"
#import "JKKCameraOverlayView.h"

#import "RegressionFactory.h"

@interface JKKCameraViewController : UIViewController <UIAlertViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property JKKModel* test;
@property JKKResult* result;
@property float calibrationValue;

@property CameraState state;
@property (getter=isTakingCalibrationPoint) BOOL takingCalibrationPoint;

@property (strong, nonatomic) IBOutlet UIImageView *cameraView;
@property (strong, nonatomic) IBOutlet JKKCameraOverlayView *cameraOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;


@end
