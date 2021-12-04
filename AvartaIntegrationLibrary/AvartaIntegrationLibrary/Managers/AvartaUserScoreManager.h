//
//  AvartaUserScoreManager.h
//  AvartaIntegrationLibrary
//
//  Created by Dmitrii Babii on 11.10.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvartaNetworkRequestManager.h"
#import "AvartaCryptModel.h"

@class AvartaUserScoreModel;

@interface AvartaUserScoreManager : NSObject

- (nullable instancetype)initWithRequestManager:(nonnull AvartaNetworkRequestManager*)requestManager AvartaCryptModel:(AvartaCryptModel*_Nullable)cryptModel;
-(void)calculateScoresWithSessionKey:(nonnull NSString*)sessionKey andCompletion:(nullable void (^)(NSError * _Nullable error, AvartaUserScoreModel * _Nullable result))completionBlock;

@end
