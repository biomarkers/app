//
//  JKKCvVideoCamera.m
//  CameraControl
//
//  Created by Kevin on 1/10/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKCvVideoCamera.h"

@implementation JKKCvVideoCamera

- (id)init {
    self = [super init];
    if (self) {
        [self unlockBalance];
        [self unlockExposure];
        [self unlockFocus];
        
        self.wbLocked = NO;
        self.focusLocked = NO;
        self.exposureLocked = NO;
    }
   
    return self;
}

- (void)toggleWhiteBalance {
    if (self.wbLocked) {
        [self unlockBalance];
        self.wbLocked = NO;
    } else {
        [self lockBalance];
        self.wbLocked = YES;
    }
}

- (void)toggleFocus {
    if (self.focusLocked) {
        [self unlockFocus];
        self.focusLocked = NO;
    } else {
        [self lockFocus];
        self.focusLocked = YES;
    }
}

- (void)toggleExposure {
    if (self.exposureLocked) {
        [self unlockExposure];
        self.exposureLocked = NO;
    } else {
        [self lockExposure];
        self.exposureLocked = YES;
    }
}
@end
