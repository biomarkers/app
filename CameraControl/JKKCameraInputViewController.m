//
//  JKKCameraInputViewController.m
//  CameraControl
//
//  Created by Kevin on 11/14/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//

#import "JKKCameraInputViewController.h"

@interface JKKCameraInputViewController ()

@end

@implementation JKKCameraInputViewController

- (IBAction)unwindToCameraInput:(UIStoryboardSegue *)segue
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.wbButton.tintColor = [UIColor blueColor];
    self.expButton.tintColor = [UIColor blueColor];
    self.focButton.tintColor = [UIColor blueColor];
    
    self.captureManager = [JKKCaptureManager new];
    [self.captureManager initializeSession];
    [self.captureManager initializeDevice];
    
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureManager.session];
    self.previewView.backgroundColor = [UIColor clearColor];
    UIView *view = self.previewView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    CGRect bounds = [view bounds];
    [newCaptureVideoPreviewLayer setFrame:bounds];
    [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //[viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
    [viewLayer addSublayer:newCaptureVideoPreviewLayer];
    self.captureVideoPreviewLayer = newCaptureVideoPreviewLayer;
    [self.captureManager.session startRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)wbPress:(id)sender {
    [self.captureManager toggleAutoWB];
    
    if (self.wbButton.tintColor != [UIColor redColor])
        self.wbButton.tintColor = [UIColor redColor];
    else
        self.wbButton.tintColor = [UIColor blueColor];
    NSLog(@"WB Pressed");
}

- (IBAction)expPress:(id)sender {
    [self.captureManager toggleAutoExposure];
    
    if (self.expButton.tintColor != [UIColor redColor])
        self.expButton.tintColor = [UIColor redColor];
    else
        self.expButton.tintColor = [UIColor blueColor];
    NSLog(@"Exp Pressed");
}

- (IBAction)focPress:(id)sender {
    [self.captureManager toggleAutoFocus];
    
    if (self.focButton.tintColor != [UIColor redColor])
        self.focButton.tintColor = [UIColor redColor];
    else
        self.focButton.tintColor = [UIColor blueColor];
    NSLog(@"Focus Pressed");
}

- (IBAction)takePicture:(id)sender {
    NSLog(@"Take Picture Pressed");
}
@end
