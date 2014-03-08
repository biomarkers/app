//
//  JKKCameraOverlayView.h
//  App
//
//  Created by Kevin on 3/2/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKKCameraOverlayView : UIView

@property (nonatomic, assign) CGRect circleBounds;

- (void)updateCircleWithCenterX:(float)x centerY:(float)y radius:(float)r;

@end
