//
//  AvartaLicenseProvider.h
//  Avarta
//
//  Created by Dmitrii Babii on 13.09.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "BaseMappingObject.h"

@interface AvartaLicenseProvider : BaseMappingObject

@property (nonatomic, strong, nullable) NSString *code;
@property (nonatomic, strong, nullable) NSString *name;

@end
