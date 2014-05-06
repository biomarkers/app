//
//  JKKCameraOverlayView.m
//  App
//
//  Created by Kevin on 3/2/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKCameraOverlayView.h"

@implementation JKKCameraOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [self.tintColor CGColor]);
    CGContextSetLineWidth(context, 2);
    CGContextStrokeEllipseInRect(context, self.circleBounds);
}

- (void)updateCircleWithCenterX:(float)x centerY:(float)y radius:(float)r scaleX:(float)sx scaleY:(float)sy {
    float max = MAX(sx, sy);
    float min = MIN(sx, sy);
    
    float offset = ((max - min) * x);
    CGRect boundingRectangle = CGRectMake(((x - r) * max) - offset, (y - r) * max, (r * 2) * max, (r * 2) * max);
    self.circleBounds = boundingRectangle;
    [self setNeedsDisplay];
}

@end
