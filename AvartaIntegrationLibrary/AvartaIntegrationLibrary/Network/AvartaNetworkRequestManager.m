//
//  AvartaNetworkRequestManager.m
//  Avarta
//
//  Created by Dmitrii Babii on 19.08.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import "AvartaNetworkRequestManager.h"
#import "HTTPSessionManager.h"
#import "AvartaInternalConstants.h"
#import "AvartaErrorManager.h"
#import "ECEncryption.h"
#import <Bugsnag/Bugsnag.h>

@interface AvartaNetworkRequestManager ()

@property (nonatomic, strong) HTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSString *workflowEnrollKey;
@property (nonatomic, strong) NSString *workflowVerifyKey;
@property (nonatomic, strong) NSString *organizationId;

@end

@implementation AvartaNetworkRequestManager



- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (nonnull instancetype)initWithBaseURL:(nonnull NSString*)baseUrl andOrganizationId:(nonnull NSString *)organizationId
{
    self = [super init];
    if (self) {
        self.organizationId = organizationId;
        self.baseUrl = baseUrl;
    }
    return self;
}

-(void)setBaseUrl:(NSString *)baseUrl{
    _sessionManager = [[HTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:baseUrl] andOrganizationId:self.organizationId] ; //darshana
    _sessionManager.isComressionRequired = self.doCompressedRequests;
}

-(void)statusCheckRequestWithUsername:(NSString*)userName organizationKey:(NSString*)organizationKey typeCode:(NSString*)typeCode andCompletion:(void (^)(NSError *error, NSDictionary* result))completionBlock
{
    ECEncryption *encryption = [ECEncryption defaultInstance];
    NSDictionary *params = @{@"userName" : userName, @"workflowtypecode" : typeCode, @"PublicKey" : encryption.strPublicKey};
    [self.sessionManager postRequest:kStatusTypeCheck params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)verificationCheckRequestWithUsername:(NSString*)userName organizationKey:(NSString*)organizationKey typeCode:(NSString*)typeCode andCompletion:(void (^)(NSError *error, NSDictionary* result))completionBlock
{
     ECEncryption *encryption = [ECEncryption defaultInstance];
    NSDictionary *params = @{@"organisationKey" : organizationKey, @"userName" : userName, @"workflowTypeCode" : typeCode , @"PublicKey" : encryption.strPublicKey};
    [self.sessionManager postRequest:kStatusTypeCheck params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)postRequestWithKey:(NSString *)instKey Data:(NSString*)data OperationName:(NSString*)opName andCompletion:(void (^)(NSError *error, NSDictionary* result))completionBlock;
{
    ECEncryption *encryption = [ECEncryption defaultInstance];
    
    NSDictionary *params = @{@"WorkflowInstanceKey" : instKey, @"ItemCode": opName, @"ItemData" : data , @"PublicKey" : encryption.strPublicKey};
   
 
    [self.sessionManager postRequest:kProcessItem params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)startSessionWithWorkFlowKey:(NSString*)workflowKey userName:(NSString*)userName sourceKey:(nonnull NSString*)sourceKey Completion:(void (^)(NSError *error, NSDictionary* result))completionBlock{
    
    
    
    NSString *sourceName = [NSString stringWithFormat:@"%@ iOS", [sourceKey capitalizedString]];
    
    ECEncryption *encryption = [ECEncryption defaultInstance];
    
    NSDictionary *params = @{@"forceWorkflowRestart":@"true", @"userName":userName, @"workflowKey":workflowKey, @"Source" : sourceName,@"PublicKey" : encryption.strPublicKey};
    
    //NSString *publicKey = [ECEncryption ]
//    let publicKey1 = SecKeyCopyPublicKey(privateKey1)
    [self.sessionManager postRequest:kStartWorkFlow params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
    
}

-(void)sessionCompleteRequest:(NSString*)workflowKey createSession:(BOOL)session updateSessionScore:(BOOL)updateSessionScore completion:(void (^)(NSError *error, NSDictionary* result))completionBlock{
    NSMutableDictionary *params = [@{@"WorkflowInstanceKey":workflowKey} mutableCopy];
    if (session){
        [params setObject:@"True" forKey:@"CreateSession"];
    } else {
        [params setObject:@"False" forKey:@"CreateSession"];
    }
    
    if(updateSessionScore){
        [params setObject:@"True" forKey:@"UpdateSessionScore"];
    }else{
        [params setObject:@"False" forKey:@"UpdateSessionScore"];
    }
    
    [self.sessionManager postRequest:kCompleteWorkFlow params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
    
}

-(void)sessionCheckWithKey:(NSString*)sessionKey Completion:(void (^)(NSError *error, NSDictionary* result))completionBlock{
    NSDictionary *params = @{@"sessionKey":sessionKey};
    [self.sessionManager postRequest:kSessionCheck params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)abortVerificationWithKey:(NSString*)key andCompletion:(void (^)(NSError *error, NSDictionary* result))completionBlock
{
    NSDictionary *params = @{@"workflowInstanceKey" : key};
    [self.sessionManager postRequest:kAbortEnrollment params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)abortEnrollmentWithKey:(NSString*)key andCompletion:(void (^)(NSError *error, NSDictionary* result))completionBlock
{
    NSDictionary *params = @{@"WorkflowInstanceKey" : key};
    [self.sessionManager postRequest:kAbortEnrollment params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)appConfigRequestWithApplicationCode:(NSString*)applicationCode Completion:(void (^)(NSError *error, NSDictionary* result))completionBlock
{
    NSDictionary *params = @{@"OperatingSystemCode" : @"IOS", @"ApplicationCode":applicationCode};
    [self.sessionManager postRequest:kApplicationConfig params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)behaviourDaraRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock
{
    [self.sessionManager postRequest:kBehaviorEndpoint params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
    
}

-(void)calculateScoresRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock
{
    [self.sessionManager postRequest:kCalculateUserScores params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
    }];
}

-(void)inauthRegisterRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock
{
    NSLog(@"InAuthRegister Reqyest %@",params);
    [self.sessionManager postRequest:kInauthRegister params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        completionBlock(error, result);
        NSLog(@"InAuthRegister result %@" , result);
    }];
}

-(void)changePasswordRequest:(nonnull NSString*)username currentPassword:(nonnull NSString*)currentPassword newPassword:(nonnull NSString*)newPassword andCompletion:(nullable void (^)(NSError * _Nullable error))completionBlock
{
    [self.sessionManager postRequest:kChangePassword params:@{@"username" : username, @"currentpassword" : currentPassword, @"newpassword" : newPassword}  andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if(error){
            if(error.code == kBadRequestCode){
                NSString *code = [AvartaErrorManager AvartaCodeFromError:error];
                if(code && [code integerValue] == 11){
                    error = [NSError errorWithDomain:AvartaErrorDomain code:kBadRequestCode userInfo:@{NSLocalizedDescriptionKey:MyLocalizedString(@"Avarta.pass.change.err", @"The password change process failed.")}];
                   [Bugsnag notifyError:error];
                }else{
                    error = [AvartaErrorManager checkBadRequestAndReturnError:error];
                }
            }
        }
        completionBlock(error);
    }];
}

-(void)inauthLogRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock
{
    [self.sessionManager postRequest:kInauthSendLogs params:params andCompletion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
        if(completionBlock){
            completionBlock(error, result);
        }
    }];
}

-(void)setUserAgent:(NSString *)userAgent{
    self.sessionManager.userAgent = userAgent;
}

-(NSString *)userAgent{
    return self.sessionManager.userAgent;
}

@end
