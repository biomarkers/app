//
//  JKKModel.h
//  App
//
//  Created by Kevin on 1/30/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

/*
 Objective-C adapter class for C++ RegressionModel objects
*/

#import <Foundation/Foundation.h>
#import "RegressionModel.h"

@interface JKKModel : NSObject

@property ModelPtr model;

- (id)initWithModel: (ModelPtr)model;

- (NSString *)getModelName;
- (NSString *)getTestName;

@end
