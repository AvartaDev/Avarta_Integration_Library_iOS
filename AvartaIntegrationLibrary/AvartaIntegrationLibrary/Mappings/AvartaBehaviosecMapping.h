//
//  AvartaBehaviosecMapping.h
//  Avarta
//
//  Created by Dmitrii Babii on 08.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "BaseMappingObject.h"

@interface AvartaBehaviosecMapping : BaseMappingObject

@property (nonatomic, strong, nullable) NSString* botDesc;
@property (nonatomic, strong, nullable) NSArray *data;
@property (nonatomic, strong, nullable) NSNumber* confidence;
@property (nonatomic, strong, nullable) NSNumber* deviceChanged;
@property (nonatomic, strong, nullable) NSString* deviceDesc;
@property (nonatomic, strong, nullable) NSNumber* deviceScore;
@property (nonatomic, strong, nullable) NSArray *diDesc;
@property (nonatomic, strong, nullable) NSNumber* diError;
@property (nonatomic, strong, nullable) NSString* endDate;
@property (nonatomic, strong, nullable) NSString* endTimestamp;
@property (nonatomic, strong, nullable) NSNumber* finalizeNotes;
@property (nonatomic, strong, nullable) NSNumber* finalizeTimestamp;
@property (nonatomic, strong, nullable) NSNumber* finalized;
@property (nonatomic, strong, nullable) NSNumber* ipChanged;
@property (nonatomic, strong, nullable) NSNumber* ipSeverity;
@property (nonatomic, strong, nullable) NSNumber* isBot;
@property (nonatomic, strong, nullable) NSNumber* isDataCorrupted;
@property (nonatomic, strong, nullable) NSNumber* isReplay;
@property (nonatomic, strong, nullable) NSNumber* isSessionCorrupted;
@property (nonatomic, strong, nullable) NSString* isSessionCorruptedDesc;
@property (nonatomic, strong, nullable) NSNumber* isTrained;
@property (nonatomic, strong, nullable) NSNumber* isWhitelisted;
@property (nonatomic, strong, nullable) NSNumber* numpadAnomaly;
@property (nonatomic, strong, nullable) NSArray* pdDesc;
@property (nonatomic, strong, nullable) NSNumber* pdError;
@property (nonatomic, strong, nullable) NSNumber* pocAnomaly;
@property (nonatomic, strong, nullable) NSString* policy;
@property (nonatomic, strong, nullable) NSNumber* policyId;
@property (nonatomic, strong, nullable) NSNumber* recognitionRatio;
@property (nonatomic, strong, nullable) NSNumber* score;
@property (nonatomic, strong, nullable) NSNumber* sessionId;
@property (nonatomic, strong, nullable) NSString* startDate;
@property (nonatomic, strong, nullable) NSString* startTimestamp;
@property (nonatomic, strong, nullable) NSNumber* tabAnomaly;
@property (nonatomic, strong, nullable) NSNumber* uiConfidence;
@property (nonatomic, strong, nullable) NSNumber* uiScore;
@property (nonatomic, strong, nullable) NSString* userid;

@end
