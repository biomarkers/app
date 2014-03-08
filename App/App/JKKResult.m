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
- (id)initNewResultWithName:(NSString*)name subject:(NSString *)subject notes:(NSString *)notes{
    self = [super init];
    
    if (self) {
        //self.date = [NSDate date];
        self.name = name;
        self.subject = subject;
        self.notes = notes;
    }
    
    return self;
}

// hessk: initializer for a previously evaluated result for historical display
- (id)initResultWithName:(NSString *)name subject:(NSString *)subject notes:(NSString *)notes date:(NSString*)date value:(float)value {
    self = [self initNewResultWithName:name subject:subject notes:notes];
    
    if (self) {
        self.date = date;
        self.value = value;
    }
    
    return self;
}


@end
