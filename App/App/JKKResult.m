//
//  JKKResult.m
//  App
//
//  Created by Kevin on 1/26/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKResult.h"

@implementation JKKResult

// hessk: initializer for a result which we will add a value to later
- (id)initNewResultWithName:(NSString*)name subject:(NSString *)subject notes:(NSString *)notes {
    self = [super init];
    
    if (self) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        
        self.date = [formatter stringFromDate:[NSDate date]];
        self.name = name;
        self.subject = subject;
        self.notes = notes;
        
        self.resultID = -1;
    }
    
    return self;
}

- (id)initResultFromDatabaseWithID:(int)resultID date:(NSString *)date name:(NSString *)name subject:(NSString *)subject notes:(NSString *)notes value:(float)value stats:(NSString *)statsString{
    self = [self initNewResultWithName:name subject:subject notes:notes];
    
    if (self) {
        self.resultID = resultID;
        self.value = value;
        self.date = date;
        self.stats = statsString;
    }
    
    return self;
}

@end
