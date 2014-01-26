//
//  JKKResult.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKResult.h"

@implementation JKKResult

/* hessk: Initializer with given test and current date */
- (id)initWithTest:(JKKTest *)test {
    self = [super init];
    
    if (self) {
        self.test = test;
        self.date = [NSDate date];
    }
    
    return self;
}

@end
