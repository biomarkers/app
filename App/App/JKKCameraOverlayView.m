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
    float ms = MIN(sx, sy);
    CGRect boundingRectangle = CGRectMake((x - r) * sx, (y - r) * sy, (r * 2) * ms, (r * 2) * ms);
    self.circleBounds = boundingRectangle;
    [self setNeedsDisplay];
}

@end
