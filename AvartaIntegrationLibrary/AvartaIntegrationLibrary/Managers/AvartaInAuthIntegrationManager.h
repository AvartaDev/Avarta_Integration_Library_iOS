//
//  AvartaInAuthIntegrationManager.h
//  AvartaIntegrationLibrary
//
//  Created by Dmitrii Babii on 18.10.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AvartaNetworkRequestManager;

@interface AvartaInAuthIntegrationManager : NSObject

- (nullable instancetype)initWithRequestManager:(nonnull AvartaNetworkRequestManager*)requestManager;

-(void)registerInAuthWithUsername:(nonnull NSString*)username permID:(nonnull NSString*)permId andCompletionBlock:(nullable void (^)( NSError * _Nullable error, NSDictionary  * _Nullable  result))completionBlock;
-(void)sendInAuthLogs:(nonnull NSDictionary*)logs withCompletionBlock:(nullable void (^)( NSError * _Nullable error, NSDictionary  * _Nullable  result))completionBlock;

@end
