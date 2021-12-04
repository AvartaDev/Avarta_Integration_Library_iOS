//
//  AvartaActivities.h
//  Avarta
//
//  Created by Dmitrii Babii on 30.06.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMappingObject.h"
#import "AvartaActivityType.h"
#import "AvartaIntegrationLibrary.h"

@interface AvartaActivities : BaseMappingObject

@property (nonatomic, strong, nonnull) AvartaActivityType *type;
@property (nonnull, strong, nonatomic) NSString *code;
@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, readonly, assign) AvartaActivitiesE activityType;



@end
