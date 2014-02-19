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
- (id)init {
    self = [super init];
    
    if (self) {
        self.date = [NSDate date];
    }
    
    return self;
}

- (id)initWithName: (NSString*)name value: (float)value {
    self = [super init];
    
    if (self) {
        self.date = 0;
        self.name = name;
        self.value = value;
    }
    
    return self;
}

@end
