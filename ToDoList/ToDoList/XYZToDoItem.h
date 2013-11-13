//
//  XYZToDoItem.h
//  ToDoList
//
//  Created by Kevin on 11/12/13.
//  Copyright (c) 2013 Koalas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;

@end
