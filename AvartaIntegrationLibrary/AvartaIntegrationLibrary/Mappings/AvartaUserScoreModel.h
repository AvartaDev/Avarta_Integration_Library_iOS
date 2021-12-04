//
//  AvartaUserScore.h
//  AvartaIntegrationLibrary
//
//  Created by Dmitrii Babii on 11.10.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "BaseMappingObject.h"

@interface AvartaUserScoreModel : BaseMappingObject

@property (nonatomic, strong, nullable) NSNumber *behaviosecScore;
@property (nonatomic, strong, nullable) NSNumber *behaviosecConfidence;
@property (nonatomic, strong, nullable) NSNumber *behaviosecAverageScore;
@property (nonatomic, strong, nullable) NSString *behaviosecProfile;
@property (nonatomic, strong, nullable) NSNumber *behaviosecScoreAge;
@property (nonatomic, strong, nullable) NSNumber *inAuthScore;
@property (nonatomic, strong, nullable) NSNumber *inAuthScoreAge;
@property (nonatomic, strong, nullable) NSNumber *workflowScore;
@property (nonatomic, strong, nullable) NSNumber *combinedScore;
@property (nonatomic, strong, nullable) NSString *dateCaptured;

@end
