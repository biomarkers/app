//
//  JKKCameraInputViewController.h
//  CameraControl
//
//  Created by Kevin on 11/14/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKCaptureManager.h"
#import <opencv2/highgui/cap_ios.h>
#import "regression.cpp"
#import "vision.cpp"
using namespace cv;

//@interface JKKCameraInputViewController : UIViewController <UINavigationControllerDelegate>

@interface JKKCameraInputViewController : UIViewController <CvVideoCameraDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *button;

@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *wbButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *expButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *focButton;

- (IBAction)wbPress:(id)sender;
- (IBAction)expPress:(id)sender;
- (IBAction)focPress:(id)sender;
//- (IBAction)takePicture:(id)sender;

- (IBAction)actionStart:(id)sender;

@property JKKCaptureManager *captureManager;
@property (nonatomic, retain) CvVideoCamera* videoCamera;

@end
