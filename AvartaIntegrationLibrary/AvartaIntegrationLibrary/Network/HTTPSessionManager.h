//
//  HTTPSessionManager.h
//  TestInterstitialsApp
//
//  Created by Dmitrii Babii on 12.04.17.
//  Copyright © 2017 Onix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPSessionManager : NSObject

extern NSString * _Nonnull const kErrorJsonDataKey;

@property (nonnull, nonatomic, strong) NSString *userAgent;
@property (nonatomic) bool isComressionRequired;
@property (nullable, nonatomic, strong) NSString *certificateName;

- (nullable instancetype)initWithBaseURL:(nonnull NSURL*)baseURL andOrganizationId:(nonnull NSString*)organizationId;
- (void)getRequest:(nonnull NSString *)urlString params:(nullable NSDictionary *)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock;
- (void)postRequest:(nonnull NSString *)urlString params:(nullable NSDictionary *)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock;


@end
