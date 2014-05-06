//
//  JKKROIViewController.h
//  App
//
//  Created by Kevin on 4/23/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JKKCaptureManager.h"
#import "JKKModel.h"
#import "JKKCameraOverlayView.h"

@interface JKKROIViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) IBOutlet JKKCameraOverlayView *cameraOverlayView;
@property (retain, nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong, nonatomic) IBOutlet UIImageView *cameraView;

@property (strong, nonatomic) JKKCaptureManager *captureManager;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinchRecognizer;

@property float x;
@property float y;
@property float r;
@property float scaleX;
@property float scaleY;

@property (strong, nonatomic) IBOutlet UILabel *xLabel;
@property (strong, nonatomic) IBOutlet UILabel *yLabel;
@property (strong, nonatomic) IBOutlet UILabel *rLabel;

@property (strong, nonatomic) IBOutlet UISwitch *autoSwitch;

@end
