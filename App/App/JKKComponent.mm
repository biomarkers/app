//
//  JKKComponent.m
//  App
//
//  Created by Kevin on 2/8/14.
//  Copyright (c) 2014 Koalas. All rights reserved.
//

#import "JKKComponent.h"

@implementation JKKComponent

- (id)initWithVarType:(ModelComponent::VariableType)varType withModelType:(ModelComponent::ModelType)modelType withStartTime:(float)startTime withEndTime:(float)endTime {
    self = [super init];
    
    if (self) {
        self.varType = varType;
        self.modelType = modelType;
        self.startTime = startTime;
        self.endTime = endTime;
    }
    
    return self;
}

- (NSString *)getVarTypeString {
    NSString* returnString;
    
    switch (self.varType) {
        case ModelComponent::RED:
            returnString = @"R";
            break;
        case ModelComponent::GREEN:
            returnString = @"G";
            break;
        case ModelComponent::BLUE:
            returnString = @"B";
            break;
        case ModelComponent::HUE:
            returnString = @"H";
            break;
        case ModelComponent::INVALID_VAR:
        default:
            returnString = @"INVALID_VAR_TYPE";
            NSLog(@"Error getting variable type string; invalid variable type found");
            break;
    }
    
    return returnString;
}

- (NSString *)getModelTypeString {
    NSString* returnString;
    
    switch (self.modelType) {
        case ModelComponent::LINEAR:
            returnString = @"Linear";
            break;
        case ModelComponent::EXPONENTIAL:
            returnString = @"Exponential";
            break;
        case ModelComponent::POINT:
            returnString = @"Point";
            break;
        case ModelComponent::INVALID_TYPE:
        default:
            returnString = @"INVALID_MODEL_TYPE";
            NSLog(@"Error getting model type string; invalid model type found");
            break;
    }
    
    return returnString;
}

@end
