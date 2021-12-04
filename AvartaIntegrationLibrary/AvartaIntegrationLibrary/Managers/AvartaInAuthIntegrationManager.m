//
//  AvartaInAuthIntegrationManager.m
//  AvartaIntegrationLibrary
//
//  Created by Dmitrii Babii on 18.10.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaInAuthIntegrationManager.h"
#import "AvartaNetworkRequestManager.h"
#import "AvartaLibraryHelper.h"

@interface AvartaInAuthIntegrationManager ()

@property (nonatomic, nonnull, strong) AvartaNetworkRequestManager *requestManager;

@end

@implementation AvartaInAuthIntegrationManager

- (instancetype)initWithRequestManager:(AvartaNetworkRequestManager*)requestManager;
{
    self = [super init];
    if (self) {
        self.requestManager = requestManager;
    }
    return self;
}

-(void)registerInAuthWithUsername:(nonnull NSString*)username permID:(nonnull NSString*)permId andCompletionBlock:(nullable void (^)( NSError * _Nullable error, NSDictionary  * _Nullable  result))completionBlock
{
    [self.requestManager inauthRegisterRequestWithParams:@{@"username" : username, @"permanentId": permId} andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if(completionBlock){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(error, result);
            });
        }
    }];
}

-(void)sendInAuthLogs:(nonnull NSDictionary*)logs withCompletionBlock:(nullable void (^)( NSError * _Nullable error, NSDictionary  * _Nullable  result))completionBlock
{
    [self.requestManager inauthLogRequestWithParams:logs andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if(completionBlock){
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(error, result);
            });
        }
    }];
}

@end
