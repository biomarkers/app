//
//  JKKDatabaseManager.h
//  App
//
//  Created by Kevin on 2/18/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//
//  Singleton style class for initializing and interacting with the sqlite database
//

#import <Foundation/Foundation.h>

#import "DataStore.h"

@interface JKKDatabaseManager : NSObject

// return a reference to a single instance of this class, initializing only the first time it's called in the app
+ (JKKDatabaseManager *)sharedInstance;

@property NSString* databasePath;
- (DataStore)openDatabase;

@end
