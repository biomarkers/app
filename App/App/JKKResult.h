//
//  JKKResult.h
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKKResult : NSObject

@property NSString* name;
@property NSDate* date;
@property float value;
@property NSString* subject;
@property NSString* notes;

- (id)initNewResultWithName:(NSString*)name subject:(NSString*)subject notes:(NSString*)notes;
- (id)initResultWithName:(NSString*)name subject:(NSString*)subject notes:(NSString*)notes date:(NSDate*)date value:(float)value;

@end
