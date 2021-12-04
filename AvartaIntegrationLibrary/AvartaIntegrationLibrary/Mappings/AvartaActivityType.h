//
//  AvartaActivityType.h
//  Avarta
//
//  Created by Dmitrii Babii on 03.07.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMappingObject.h"
#import "IntegrationLibrary.h"

@interface AvartaActivityType : BaseMappingObject

@property (nonnull, nonatomic, strong) NSString *code;
@property (nonnull, nonatomic, strong) NSString *name;



@end
