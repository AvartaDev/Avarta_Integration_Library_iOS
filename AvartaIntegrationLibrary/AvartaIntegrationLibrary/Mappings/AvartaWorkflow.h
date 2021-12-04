//
//  AvartaWorkflow.h
//  Avarta
//
//  Created by Dmitrii Babii on 30.06.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMappingObject.h"
#import "AvartaActivities.h"

@interface AvartaWorkflow : BaseMappingObject

@property (nonatomic, strong, nonnull) NSString *key;
@property (nonatomic, strong, nonnull) NSNumber *deviceBasedFlag;
@property (nonatomic, strong, nonnull) NSArray *pendingActivities;
@property (nonatomic, strong, nonnull) NSNumber *score;
@property (nonatomic, strong, nonnull) NSString *source;
@property (nonatomic, strong, nonnull) NSString *salt;
@property (nonatomic, strong, nonnull) NSNumber *status;
@property (nonatomic, strong, nonnull) NSDate *dateCreated;
@property (nonatomic, strong, nonnull) NSDate *dateUpdated;

-(nullable AvartaActivities*)activityWithCode:(nonnull NSString*)activityCode;


@end
