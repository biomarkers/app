//
//  JKKCameraViewController.h
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JKKTest.h"
#import "JKKCaptureManager.h"

@interface JKKCameraViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property JKKTest* test;
@property CameraState state;
@property (getter=isTakingCalibrationPoint) BOOL takingCalibrationPoint;

@property (strong, nonatomic) IBOutlet UIImageView *cameraView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;


@end
