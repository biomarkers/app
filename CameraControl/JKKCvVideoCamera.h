//
//  JKKCvVideoCamera.h
//  CameraControl
//
//  Created by Kevin on 1/10/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <opencv2/highgui/cap_ios.h>

@interface JKKCvVideoCamera : CvVideoCamera
@property bool wbLocked;
@property bool focusLocked;
@property bool exposureLocked;

- (void)toggleWhiteBalance;
- (void)toggleFocus;
- (void)toggleExposure;


@end
