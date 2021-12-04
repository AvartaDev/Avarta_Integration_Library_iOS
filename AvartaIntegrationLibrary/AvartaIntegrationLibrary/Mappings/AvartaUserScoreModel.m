//
//  AvartaUserScore.m
//  AvartaIntegrationLibrary
//
//  Created by Dmitrii Babii on 11.10.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaUserScoreModel.h"

@implementation AvartaUserScoreModel

+(NSDictionary *)mapProperties
{
    return @{
             @"behaviosecScore": @"BehaviosecScore",
             @"behaviosecConfidence" : @"BehaviosecConfidence",
             @"behaviosecAverageScore" : @"BehaviosecAverageScore",
             @"behaviosecProfile" : @"BehaviosecProfile" ,
             @"behaviosecScoreAge" : @"BehaviosecScoreAge",
             @"inAuthScore" : @"InAuthScore",
             @"inAuthScoreAge" : @"InAuthScoreAge",
             @"workflowScore" : @"WorkflowScore",
             @"combinedScore" : @"CombinedScore",
             @"dateCaptured" : @"DateCaptured"
             };
}

@end
