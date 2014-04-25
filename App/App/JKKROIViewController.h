//
//  JKKROIViewController.h
//  App
//
//  Created by Kevin on 4/23/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JKKCaptureManager.h"
#import "JKKCameraOverlayView.h"

@interface JKKROIViewController : UIViewController
@property (strong, nonatomic) IBOutlet JKKCameraOverlayView *cameraOverlayView;
@property (strong, nonatomic) IBOutlet UIImageView *cameraView;

@end
