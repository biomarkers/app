//
//  JKKTest.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKTest.h"

@implementation JKKTest

- (id)initWithName:(NSString *)name Runtime:(NSTimeInterval)time ModelType:(ModelType)type {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.runtime = time;
        self.type = type;
    }
    
    return self;
}

- (id)initWithName:(NSString *)name {
    self = [super init];
    
    if (self) {
        self.name = name;
        self.runtime = 0;
        self.type = LINEAR;
    }
    
    return self;
}

@end
