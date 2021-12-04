//
//  AvartaBehaviosecTarget.h
//  Avarta
//
//  Created by Dmitrii Babii on 08.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "BaseMappingObject.h"

@interface AvartaBehaviosecTarget : BaseMappingObject

@property (nonatomic, strong, nullable) NSString* botDesc;
@property (nonatomic, strong, nullable) NSNumber* confidence;
@property (nonatomic, strong, nullable) NSArray* diDesc;
@property (nonatomic, strong, nullable) NSNumber* diError;
@property (nonatomic, strong, nullable) NSNumber* isBot;
@property (nonatomic, strong, nullable) NSNumber* isTrained;
@property (nonatomic, strong, nullable) NSNumber* numpadAnomaly;
@property (nonatomic, strong, nullable) NSNumber* numpadRatio;
@property (nonatomic, strong, nullable) NSNumber* numpadUsed;
@property (nonatomic, strong, nullable) NSArray* pdDesc;
@property (nonatomic, strong, nullable) NSNumber* pdError;
@property (nonatomic, strong, nullable) NSNumber* pocAnomaly;
@property (nonatomic, strong, nullable) NSNumber* pocRatio;
@property (nonatomic, strong, nullable) NSNumber* pocUsed;
@property (nonatomic, strong, nullable) NSNumber* recognitionRatio;
@property (nonatomic, strong, nullable) NSNumber* score;
@property (nonatomic, strong, nullable) NSNumber* tabAnomaly;
@property (nonatomic, strong, nullable) NSNumber* tabRatio;
@property (nonatomic, strong, nullable) NSNumber* tabUsed;
@property (nonatomic, strong, nullable) NSString* target;
@property (nonatomic, strong, nullable) NSNumber* training;
@property (nonatomic, strong, nullable) NSString* type;
@property (nonatomic, strong, nullable) NSNumber* updates;

@end
