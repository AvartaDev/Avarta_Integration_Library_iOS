//
//  AvartaAppSettingsModel+AvartaLibrarySettings.m
//  Avarta
//
//  Created by Dmitrii Babii on 07.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaAppSettingsModel+AvartaLibrarySettings.h"
#import "AvartaLibrarySettings.h"
#import "AvartaSettingLicenseItem.h"

@implementation AvartaAppSettingsModel (AvartaLibrarySettings)

-(AvartaLibrarySettings*)librarySettings
{
    AvartaLibrarySettings *settings = [AvartaLibrarySettings new];
    settings.pinLength = self.deviceConfiguration.pinLength;
    settings.appUpdateLocation = self.deviceConfiguration.location;
    settings.version = self.deviceConfiguration.version.stringValue;
    AvartaSettingLicenseItem *item = [self.licences firstObject];
    if(item){
        settings.operatingSystem = item.operatingSystem.code;
    }
    settings.licenseKey = item.key;
    return settings;
}

@end
