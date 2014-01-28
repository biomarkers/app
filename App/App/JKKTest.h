//
//  JKKTest.h
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKKTest : NSObject

@property NSString* name;
@property ModelType type;
@property NSTimeInterval runtime;

// hessk: TODO: continue adding test properties here

- (id)initWithName:(NSString *)name Runtime:(NSTimeInterval)time ModelType:(ModelType)type;
- (id)initWithName:(NSString *)name;

@end
