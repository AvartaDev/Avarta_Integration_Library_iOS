//
//  AvartaDeviceConfigurationModel.h
//  Avarta
//
//  Created by Dmitrii Babii on 13.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "BaseMappingObject.h"

@interface AvartaDeviceConfigurationModel : BaseMappingObject

@property (nonatomic, nonnull, strong) NSNumber *version;
@property (nonatomic, nonnull, strong) NSString *location;
@property (nonatomic, nonnull, strong) NSNumber *pinLength;

@end
