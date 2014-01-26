//
//  JKKResult.h
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKKTest.h"

@interface JKKResult : NSObject

@property JKKTest* test;
@property NSDate* date;

// hessk: placeholder member
@property NSNumber* value;

// hessk: TODO: continue adding result properties here

- (id)initWithTest:(JKKTest *)test;

@end
