//
//  JKKModel.m
//  App
//
//  Created by Kevin on 1/30/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKModel.h"

@implementation JKKModel

- (id)initWithModel:(ModelPtr)model {
    self = [super init];
    
    if (self) {
        self.model = model;
    }
    
    return self;
}

- (NSString *)getModelName {
    NSStringEncoding asciiEncoding  = NSASCIIStringEncoding;
    return [NSString stringWithCString: self.model->GetModelName().c_str() encoding:asciiEncoding];
}

- (NSString *)getTestName {
    NSStringEncoding asciiEncoding  = NSASCIIStringEncoding;
    return [NSString stringWithCString: self.model->GetTestName().c_str() encoding:asciiEncoding];
}
@end
