//
//  AvartaNetworkRequestManager.h
//  Avarta
//
//  Created by Dmitrii Babii on 19.08.16.
//  Copyright © 2016 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AvartaNetworkRequestManager : NSObject

@property (nonatomic, strong, nonnull) NSString *baseUrl;

- (nonnull instancetype)initWithBaseURL:(nonnull NSString*)baseUrl andOrganizationId:(nonnull NSString *)organizationId;

-(void)statusCheckRequestWithUsername:(nonnull NSString*)userName organizationKey:(nonnull NSString*)organizationKey typeCode:(nonnull NSString*)typeCode andCompletion:(nullable void (^)( NSError * _Nullable error, NSDictionary  * _Nullable  result))completionBlock;
-(void)verificationCheckRequestWithUsername:(nonnull NSString*)userName organizationKey:(nonnull NSString*)organizationKey typeCode:(nonnull NSString*)typeCode andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)postRequestWithKey:(nonnull NSString *)instKey Data:(nonnull NSString*)data OperationName:(nonnull NSString*)opName andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)startSessionWithWorkFlowKey:(nonnull NSString*)workflowKey userName:(nonnull NSString*)userName sourceKey:(nonnull NSString*)sourceKey Completion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)sessionCompleteRequest:(nonnull NSString*)workflowKey createSession:(BOOL)session updateSessionScore:(BOOL)updateSessionScore completion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)sessionCheckWithKey:(nonnull NSString*)sessionKey Completion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)abortVerificationWithKey:(nonnull NSString*)key andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)abortEnrollmentWithKey:(nonnull NSString*)key andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)appConfigRequestWithApplicationCode:(nonnull NSString*)applicationCode Completion:(nullable void (^)(NSError * _Nullable error, NSDictionary* _Nullable result))completionBlock;
-(void)behaviourDaraRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock;
-(void)calculateScoresRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock;
-(void)inauthRegisterRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock;
-(void)inauthLogRequestWithParams:(nonnull NSDictionary*)params andCompletion:(nullable void (^)(NSError * _Nullable error, NSDictionary * _Nullable result))completionBlock;
-(void)changePasswordRequest:(nonnull NSString*)username currentPassword:(nonnull NSString*)currentPassword newPassword:(nonnull NSString*)newPassword andCompletion:(nullable void (^)(NSError * _Nullable error))completionBlock;

@property (nonnull, nonatomic, strong) NSString *userAgent;
@property (nonatomic) bool doCompressedRequests;
@end
