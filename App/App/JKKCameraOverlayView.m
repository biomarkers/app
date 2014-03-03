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
    
    CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 2);
    CGContextStrokeEllipseInRect(context, self.circleBounds);
}

- (void)updateCircle:(CGRect)boundingRectangle {
    self.circleBounds = boundingRectangle;
    [self setNeedsDisplay];
}

@end
