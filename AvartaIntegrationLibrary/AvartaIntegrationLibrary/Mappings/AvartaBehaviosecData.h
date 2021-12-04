//
//  AvartaBehaviosecData.h
//  Avarta
//
//  Created by Dmitrii Babii on 08.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "BaseMappingObject.h"
#import "AvartaBehaviosecTarget.h"

@interface AvartaBehaviosecData : BaseMappingObject

@property (nonnull, nonatomic, strong) NSString* botDesc;
@property (nonnull, nonatomic, strong) NSNumber* confidence;
@property (nonnull, nonatomic, strong) NSNumber* date;
@property (nonnull, nonatomic, strong) NSString* device;
@property (nonnull, nonatomic, strong) NSNumber* deviceChanged;
@property (nonnull, nonatomic, strong) NSString* deviceDesc;
@property (nonnull, nonatomic, strong) NSNumber* deviceScore;
@property (nonnull, nonatomic, strong) NSArray* diDesc;
@property (nonnull, nonatomic, strong) NSNumber* diError;
@property (nonnull, nonatomic, strong) NSNumber* finalizeTimestamp;
@property (nonnull, nonatomic, strong) NSNumber* finalized;
@property (nonnull, nonatomic, strong) NSString* ip;
@property (nonnull, nonatomic, strong) NSNumber* isBot;
@property (nonnull, nonatomic, strong) NSNumber* isDataCorrupted;
@property (nonnull, nonatomic, strong) NSNumber* isReplay;
@property (nonnull, nonatomic, strong) NSNumber* isTrained;
@property (nonnull, nonatomic, strong) NSString* notes;
@property (nonnull, nonatomic, strong) NSNumber* numpadAnomaly;
@property (nonnull, nonatomic, strong) NSArray* pdDesc;
@property (nonnull, nonatomic, strong) NSNumber* pdError;
@property (nonnull, nonatomic, strong) NSNumber* pocAnomaly;
@property (nonnull, nonatomic, strong) NSString* policy;
@property (nonnull, nonatomic, strong) NSNumber* policyId;
@property (nonnull, nonatomic, strong) NSNumber* recognitionRatio;
@property (nonnull, nonatomic, strong) NSNumber* score;
@property (nonnull, nonatomic, strong) NSNumber* tabAnomaly;
@property (nonnull, nonatomic, strong) NSArray* targets;
@property (nonnull, nonatomic, strong) NSString* useragent;

@end
