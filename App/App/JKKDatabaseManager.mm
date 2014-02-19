//
//  JKKDatabaseManager.m
//  App
//
//  Created by Kevin on 2/18/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKDatabaseManager.h"

@implementation JKKDatabaseManager


- (id)init {
    self = [super init];
    
    if (self) {
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        self.databasePath = [documentsPath stringByAppendingPathComponent:@"/taterbase.sqlite"];
        
        DataStore db = DataStore::open([self.databasePath UTF8String]);
        db.createTables();
        db.close();
    }
    
    return self;
}


+ (JKKDatabaseManager *)sharedInstance {
    static JKKDatabaseManager* instance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        instance = [[JKKDatabaseManager alloc] init];
    });
    
    return instance;
}

- (DataStore)openDatabase {
    DataStore db = DataStore::open([self.databasePath UTF8String]);
    return db;
}

@end
