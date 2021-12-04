//
//  AvartaSettingLicenseItem.h
//  Avarta
//
//  Created by Dmitrii Babii on 13.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "BaseMappingObject.h"
#import "AvartaLicenseProvider.h"
#import "AvartaLicenseOperatingSystem.h"

@interface AvartaSettingLicenseItem : BaseMappingObject

@property (nonnull, nonatomic, strong) AvartaLicenseProvider *provider;
@property (nonnull, nonatomic, strong) AvartaLicenseOperatingSystem *operatingSystem;
@property (nonnull, nonatomic, strong) NSString *key;
@property (nonnull, nonatomic, strong) NSString *startDate;
@property (nonnull, nonatomic, strong) NSString *endDate;

@end
