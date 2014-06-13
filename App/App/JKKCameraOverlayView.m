//
//  JKKCameraOverlayView.m
//  OccuChrome
//
//  Created by Kevin Hess on 3/2/14.
//  Copyright 2014 Kyle Cesare, Kevin Hess, Joe Runde
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
