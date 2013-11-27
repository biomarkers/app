//
//  JKKCameraInputViewController.h
//  CameraControl
//
//  Created by Kevin on 11/14/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKKCaptureManager.h"

@interface JKKCameraInputViewController : UIViewController <UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *wbButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *expButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *focButton;

- (IBAction)wbPress:(id)sender;
- (IBAction)expPress:(id)sender;
- (IBAction)focPress:(id)sender;
- (IBAction)takePicture:(id)sender;

@property JKKCaptureManager *captureManager;


@end
