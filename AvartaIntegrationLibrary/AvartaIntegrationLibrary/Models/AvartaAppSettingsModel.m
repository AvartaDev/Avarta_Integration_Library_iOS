//
//  AvartaAppSettingsModel.m
//  Avarta
//
//  Created by Dmitrii Babii on 16.06.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaAppSettingsModel.h"
#import "AvartaSettingLicenseItem.h"
#import "AvartaLibraryHelper.h"

@implementation AvartaAppSettingsModel

+ (NSDictionary *)mapProperties
{
    return @{@"code" : @"Code",
             @"name" : @"Name",
             @"isDeviceBased" : @"IsDeviceBased",
             @"Workflows" : [AvartaSettingsWorkflowItem class],
             @"Licences" : [AvartaSettingLicenseItem class],
             @"DeviceConfiguration" : [AvartaDeviceConfigurationModel class]
             };
}

-(nullable AvartaSettingsWorkflowItem*)itemForWorkflowType:(AvartaWorkflowType)type
{
    return [self workflowItemForCode:[AvartaLibraryHelper typeCodeForAvartaWorkflowtype:type]];
}

-(AvartaSettingsWorkflowItem*)workflowItemForCode:(NSString*)code
{
    for (AvartaSettingsWorkflowItem *item in self.workflows)
    {
        if([item.code isEqualToString:code])
        {
            return item;
        }
    }
    return nil;
}

-(nullable NSString*)keyForWorkflowType:(AvartaWorkflowType)type
{
    AvartaSettingsWorkflowItem* item = [self workflowItemForCode:[AvartaLibraryHelper typeCodeForAvartaWorkflowtype:type]];
    return item.key;
}

@end
