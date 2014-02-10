//
//  JKKComponent.h
//  App
//
//  Created by Kevin on 2/8/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelComponent.h"

@interface JKKComponent : NSObject

@property ModelComponent::VariableType varType;
@property ModelComponent::ModelType modelType;

@property float startTime;
@property float endTime;

- (id)initWithVarType:(ModelComponent::VariableType)varType withModelType:(ModelComponent::ModelType)modelType withStartTime:(float)startTime withEndTime:(float)endTime;

- (NSString *)getVarTypeString;
- (NSString *)getModelTypeString;

@end
