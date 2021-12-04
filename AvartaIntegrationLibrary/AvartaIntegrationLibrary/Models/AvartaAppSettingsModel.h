//
//  AvartaAppSettingsModel.h
//  Avarta
//
//  Created by Dmitrii Babii on 16.06.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMappingObject.h"
#import "AvartaDeviceConfigurationModel.h"
#import "IntegrationLibrary.h"
#import "AvartaSettingsWorkflowItem.h"

@interface AvartaAppSettingsModel : BaseMappingObject

@property (nonatomic, strong, nullable) NSString *code;
@property (nonatomic, strong, nullable) NSString *name;
@property (nonatomic, strong, nullable) NSNumber *isDeviceBased;
@property (nonatomic, strong, nullable) NSArray *workflows;
@property (nonatomic, strong, nullable) NSArray *licences;
@property (nonatomic, strong, nullable) AvartaDeviceConfigurationModel *deviceConfiguration;

-(nullable AvartaSettingsWorkflowItem*)itemForWorkflowType:(AvartaWorkflowType)type;
-(nullable NSString*)keyForWorkflowType:(AvartaWorkflowType)type;

@end
