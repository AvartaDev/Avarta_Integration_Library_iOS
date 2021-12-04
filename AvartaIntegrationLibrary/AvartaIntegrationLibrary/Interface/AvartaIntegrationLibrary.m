//
//  AvartaIntegrationLibrary.m
//  Avarta
//
//  Created by Dmitrii Babii on 28.07.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import "AvartaIntegrationLibrary.h"
#import "AvartaFlowModel.h"
#import "AvartaCryptModel.h"
#import "AvartaAppSettingsModel.h"
#import "AvartaNetworkRequestManager.h"
#import "AvartaSettingsManager.h"
#import "AvartaInternalConstants.h"
#import "AvartaLibrarySettings.h"
#import "AvartaAppVersionManager.h"
#import "AvartaBehaviosecMapping.h"
#import "AvartaBehaviosecData.h"
#import "AvartaUserScoreManager.h"
#import "AvartaUserScoreModel.h"
#import "AvartaWorkflow.h"
#import "AvartaErrorManager.h"
#import "AvartaInAuthIntegrationManager.h"
#import "AvartaAppSettingsModel+AvartaLibrarySettings.h"
#import <Bugsnag/Bugsnag.h>
@interface AvartaIntegrationLibrary()<AvartaFlowModelDelegate>

@property (nonatomic, nonnull, strong) NSString *organizationId;
@property (nonatomic, nonnull, strong) NSString *applicationCode;
@property (nonatomic, nonnull, strong) AvartaFlowModel *model;
@property (nonatomic, strong, nonnull) AvartaNetworkRequestManager *requestManager;
@property (nonatomic, strong, nonnull) AvartaCryptModel *cryptModel;
@property (nonnull, strong, nonatomic) AvartaInAuthIntegrationManager *inauthManager;
@end

@implementation AvartaIntegrationLibrary

-(nullable instancetype)initWithOrganizationId:(nonnull NSString*)organizationId andBaseUrl:(NSURL*)url andApplicationCode:(nonnull NSString*)applicationCode
{
    self = [super init];
    if(self){
        self.organizationId = organizationId;
        self.requestManager = [[AvartaNetworkRequestManager alloc] initWithBaseURL:url.absoluteString andOrganizationId:organizationId];
        self.requestManager.userAgent = [AvartaAppVersionManager currentUserAgent];
        self.requestManager.doCompressedRequests = self.doCompressRequests;
        self.applicationCode = applicationCode;
        self.cryptModel = [[AvartaCryptModel alloc] initWithVector:AvartaCryptVector key: AvartaCryptKey cipher:AvartaCipher];
        self.model = [[AvartaFlowModel alloc] initWithRequestManager:self.requestManager cryptModel:self.cryptModel andOrganizationId:organizationId applicationCode:applicationCode];
        self.model.delegate = self;
        self.inauthManager = [[AvartaInAuthIntegrationManager alloc] initWithRequestManager:self.requestManager];
        
    }
    return self;
}

-(void)initialize
{
    __weak AvartaIntegrationLibrary *weakSelf = self;
    AvartaSettingsManager *settingsManager = [[AvartaSettingsManager alloc] initWithNetworkManager:self.requestManager];
    [settingsManager getApplicationSettingsWithApplicationCode:self.applicationCode Completion:^(NSError * _Nullable error, AvartaAppSettingsModel * _Nullable model) {
        if(!error){
            weakSelf.model.appSettings = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                if([weakSelf.delegate respondsToSelector:@selector(AvartaIntegrationLibrary:loadedWithSettings:)])
                {
                    [weakSelf.delegate AvartaIntegrationLibrary:weakSelf loadedWithSettings:model.librarySettings];
                }
            });
        }else{
           [Bugsnag notifyError:error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if([weakSelf.delegate respondsToSelector:@selector(AvartaIntegrationLibrary:failedWithError:)]){
                    [weakSelf.delegate AvartaIntegrationLibrary:weakSelf failedWithError:error];
                }
            });
        }
    }];
}

-(void)startWorkflowWithUserName:(nonnull NSString*)userName checkStatus:(BOOL)status andType:(AvartaWorkflowType)type workflowKey:(NSString*)workflowKey
{
    if(workflowKey)
    {
        if(type != AvartaDeleteWorkflow)
        {
            [self.model.appSettings itemForWorkflowType:type].key = workflowKey;
        }
    }
    [self.model startFlowWithType:type checkStatus:status userName:userName];
}

-(void)processStringData:(nullable NSString*)data forActivity:(AvartaActivitiesE)activity
{
    [self.model processItemWithActivity:activity itemData:data];
}

-(void)cancelFlow
{
    [self.model cancelFlow];
}

-(void)flowModel:(nonnull AvartaFlowModel*)flowModel flowCanceledWithType:(AvartaWorkflowType)type
{
    dispatch_async(dispatch_get_main_queue(), ^{
    if([self.delegate respondsToSelector:@selector(AvartaIntegrationLibrary:workflowCanceled:)]){
        [self.delegate AvartaIntegrationLibrary:self workflowCanceled:type];
    }
    });
}
-(void)flowModel:(nonnull AvartaFlowModel*)flowModel userDataRequiredForActivity:(AvartaActivitiesE)activity
{
    dispatch_async(dispatch_get_main_queue(), ^{
    if([self.delegate respondsToSelector:@selector(AvartaIntegrationLibrary:requredUserDataForActivity:)]){
        [self.delegate AvartaIntegrationLibrary:self requredUserDataForActivity:activity];
    }
    });
}
-(void)flowModel:(nonnull AvartaFlowModel*)flowModel failedWithError:(nonnull NSError*)error
{
   [Bugsnag notifyError:error];
    dispatch_async(dispatch_get_main_queue(), ^{
        if([self.delegate respondsToSelector:@selector(AvartaIntegrationLibrary:failedWithError:)]){
            [self.delegate AvartaIntegrationLibrary:self failedWithError:error];
        }
    });
}
-(void)flowModel:(nonnull AvartaFlowModel*)flowModel flowCompletedWithType:(AvartaWorkflowType)type deviceBased:(BOOL)deviceBased andFullName:(nullable NSString*)fullName
{
    dispatch_async(dispatch_get_main_queue(), ^{
    if([self.delegate respondsToSelector:@selector(AvartaIntegrationLibrary:workflowCompleted:deviceBased:withFullName:)]){
        [self.delegate AvartaIntegrationLibrary:self workflowCompleted:type deviceBased:deviceBased withFullName:fullName];
    }
    });
}

-(void)changePasswordForUsername:(nonnull NSString*)username currentPassword:(nonnull NSString*)currentPassword newPassword:(nonnull NSString*)newPassword andCompletionBlock:(nullable void (^)(NSError * _Nullable error))completionBlock
{
    
    [self.requestManager changePasswordRequest:username currentPassword:currentPassword newPassword:newPassword andCompletion:completionBlock];
}

-(void)behaviosecRegisterWithUsername:(NSString*)userName workflowType:(AvartaWorkflowType)type summary:(nullable NSString*)summary andCompletion:(void(^ _Nullable)(NSError* _Nullable error, AvartaBehavioSecModel* _Nullable model))completionBlock
{
    
    
    
    
    NSString *currentTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    NSString *processType = nil;
    switch (type) {
        case AvartaEnrollWorkflow:
            processType =  @"enroll";
            break;
        case AvartaVerifyWorkflow:
            processType =  @"auth";
            break;
        case AvartaDeleteWorkflow:
            processType =  @"auth";
            break;
        default:
            break;
    }
    
    NSDictionary *params  = @{@"UserName" :userName,
                              @"BehaviourData" : summary,
                              @"UserAgent" :[AvartaAppVersionManager currentUserAgent],
                              @"SessionId" : [currentTime substringWithRange:NSMakeRange(currentTime.length - 9, 8)],
                              @"TimeStamp" : currentTime,
                              @"Notes" : processType,
                              @"ReportFlags":@"0",
                              @"OperatorFlags":@"0",
                              @"UserIPAddress":@"::1"
                              };
    
    
    
    [self.requestManager behaviourDaraRequestWithParams:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if(!error){
            AvartaBehaviosecMapping *mapping = [AvartaBehaviosecMapping mapSimpleObject:result toClass:[AvartaBehaviosecMapping class]];
            AvartaBehavioSecModel *model = [[AvartaBehavioSecModel alloc] init];
            model.behaviorConfidence = mapping.confidence;
            model.behaviorScore = mapping.score;
            model.behaviorPolicy = mapping.policy;
            completionBlock(nil, model);
        }else{
           [Bugsnag notifyError:error];
            completionBlock(error, nil);
        }
    }];
}

-(void)calculateUserScoresWithCompletion:(void(^ _Nullable)(NSError* _Nullable error, AvartaUserScore* _Nullable model))completionBlock
{
    if(self.model.workflowModel.key){
        AvartaUserScoreManager *manager = [[AvartaUserScoreManager alloc] initWithRequestManager:self.requestManager AvartaCryptModel:self.cryptModel];
        __weak AvartaIntegrationLibrary *weakSelf = self;
        NSLog(@"REQUEST FROM CALCULATE SCORE %@", self.model.workflowModel.key);
        [manager calculateScoresWithSessionKey:self.model.workflowModel.key andCompletion:^(NSError * _Nullable error, AvartaUserScoreModel * _Nullable result) {
            AvartaUserScore *score = [weakSelf scoreFromScoreModel:result];
            NSLog(@"RESULT FROM CALCULATE SCORE %@", result);
            completionBlock(error, score);
        }];
    }else{
        if([self.delegate respondsToSelector:@selector(AvartaIntegrationLibrary:failedWithError:)]){
            [self.delegate AvartaIntegrationLibrary:self failedWithError:[AvartaErrorManager errorFromCode:kNoStartedWorkflow userName:nil]];
        }
    }
}

-(AvartaUserScore*)scoreFromScoreModel:(AvartaUserScoreModel*)model
{
    AvartaUserScore *userScore = [[AvartaUserScore alloc] init];
    userScore.behaviosecScore = model.behaviosecScore;
    userScore.behaviosecConfidence = model.behaviosecConfidence;
    userScore.behaviosecAverageScore = model.behaviosecAverageScore;
    userScore.behaviosecProfile = model.behaviosecProfile;
    userScore.behaviosecScoreAge = model.behaviosecScoreAge;
    userScore.inAuthScore = model.inAuthScore;
    userScore.inAuthScoreAge = model.inAuthScoreAge;
    userScore.workflowScore = model.workflowScore;
    userScore.combinedScore = model.combinedScore;
    userScore.dateCaptured = model.dateCaptured;
    return userScore;
}

-(void)registerInAuthWithUsername:(nonnull NSString*)username permanentID:(nonnull NSString*)permanentId andCompletionBlock:(nullable void (^)( NSError * _Nullable error, NSDictionary  * _Nullable  result))completionBlock
{
    [self.inauthManager registerInAuthWithUsername:username permID:permanentId andCompletionBlock:completionBlock];
}

-(void)sendInAuthLogs:(nonnull NSDictionary*)logs withCompletionBlock:(nullable void (^)( NSError * _Nullable error, NSDictionary  * _Nullable  result))completionBlock
{
    [self.inauthManager sendInAuthLogs:logs withCompletionBlock:completionBlock];
}

@end

@implementation AvartaBehavioSecModel



@end

@implementation AvartaUserScore



@end
