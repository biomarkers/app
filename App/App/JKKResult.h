//
//  JKKResult.h
//  OccuChrome
//
//  Created by Kevin Hess on 1/26/14.
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
