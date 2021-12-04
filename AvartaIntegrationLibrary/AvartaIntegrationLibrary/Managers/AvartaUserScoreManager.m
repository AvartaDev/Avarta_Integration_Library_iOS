//
//  AvartaUserScoreManager.m
//  AvartaIntegrationLibrary
//
//  Created by Dmitrii Babii on 11.10.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaUserScoreManager.h"
#import "AvartaUserScoreModel.h"
#import "AvartaErrorManager.h"
#import "ECEncryption.h"
#import <Bugsnag/Bugsnag.h>

@interface AvartaUserScoreManager ()

@property (nonatomic, strong, nonnull) AvartaNetworkRequestManager *requestManager;
@property (nonatomic, strong, nonnull) AvartaCryptModel *cryptModel;
@end

@implementation AvartaUserScoreManager

- (nullable instancetype)initWithRequestManager:(nonnull AvartaNetworkRequestManager*)requestManager AvartaCryptModel:(AvartaCryptModel*)cryptModel
{
    self = [super init];
    if (self) {
        self.requestManager = requestManager;
        self.cryptModel = cryptModel;
    }
    return self;
}

-(void)calculateScoresWithSessionKey:(NSString*)sessionKey andCompletion:(nullable void (^)(NSError * _Nullable error, AvartaUserScoreModel * _Nullable result))completionBlock
{
    ECEncryption *encryption = [ECEncryption defaultInstance];
    NSString *cryptedKey = [self.cryptModel encryptStringWithoutSalt:sessionKey with:encryption.sharedSecret];
    [self.requestManager calculateScoresRequestWithParams:@{@"sessionkey":cryptedKey,@"PublicKey":encryption.strPublicKey} andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if(!error){
            AvartaUserScoreModel *score = [BaseMappingObject mapSimpleObject:result toClass:[AvartaUserScoreModel class]];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(nil, score);
            });
        }else{
           [Bugsnag notifyError:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error.code == kBadRequestCode){
                    NSError *internal = [AvartaErrorManager resolveError:error];
                    completionBlock(internal,nil);
                }else{
                    completionBlock(error,nil);
                }
            });
        }
    }];
}

@end
