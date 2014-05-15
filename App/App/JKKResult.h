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
@property NSString* date;
@property float value;
@property NSString* subject;
@property NSString* notes;
@property NSString* stats;
@property int resultID;

- (id)initNewResultWithName:(NSString*)name subject:(NSString*)subject notes:(NSString*)notes;
- (id)initResultFromDatabaseWithID:(int)resultID date:(NSString *)date name:(NSString *)name subject:(NSString *)subject notes:(NSString *)notes value:(float)value stats:(NSString *)statsString;

@end
