//
//  JKKCameraViewController.h
//  App
//
//  Created by Kevin on 1/27/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/cap_ios.h>
#import "BiomarkerImageProcessor.h"
#import "RegressionFactory.h"

@interface JKKCameraViewController : UIViewController <CvVideoCameraDelegate>



@property CameraState state;
@property BiomarkerImageProcessor processor;
@property (nonatomic, retain) CvVideoCamera* cvCamera;
@property RegressionFactory factory;
@property RegressionModel* model;

@property (strong, nonatomic) IBOutlet UIImageView *cameraView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;


@end
