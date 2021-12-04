//
//  AvartaModel.m
//  Avarta
//
//  Created by Dmitrii Babii on 17.12.15.
//  Copyright © 2015 Avarta Password Solutions. All rights reserved.
//

#import "AvartaFlowModel.h"
#import "AvartaAppVersionManager.h"
#import "AvartaNetworkRequestManager.h"
#import "AvartaErrorManager.h"
#import "AvartaLocationManager.h"
#import "AvartaAppSettingsModel.h"
#import "AvartaCryptModel.h"
#import "AvartaSettingsManager.h"
#import "AvartaIntegrationLibrary.h"
#import "AvartaWorkflow.h"
#import "AvartaActivities.h"
#import "AvartaLibrarySettings.h"
#import "AvartaLibraryHelper.h"
#import "ECEncryption.h"
#import <Bugsnag/Bugsnag.h>

@interface AvartaFlowModel ()

@property (nonatomic, nonnull, strong) AvartaNetworkRequestManager *manager;
@property (nonnull, nonatomic, strong) AvartaCryptModel *cryptModel;
@property (nonatomic, strong, nullable) NSString *currentUserName;
@property (nonnull, nonatomic, strong) NSString *organizationId;
@property (nonatomic, assign) AvartaWorkflowType workflowType;
@property (nonnull, nonatomic, strong) NSString *applicationCode;

@end

#define vendorUUID @"vendorUUID"


@implementation AvartaFlowModel

-(instancetype)initWithRequestManager:(AvartaNetworkRequestManager*)requestManager cryptModel:(AvartaCryptModel*)cryptModel andOrganizationId:(NSString*)organizationId applicationCode:(nonnull NSString*)applicationCode
{
    self = [super init];
    if(self)
    {
        self.manager = requestManager;
        self.organizationId = organizationId;
        self.cryptModel = cryptModel;
        self.applicationCode = applicationCode;
    }
    return self;
}


-(void)startFlowWithType:(AvartaWorkflowType)type checkStatus:(BOOL)status userName:(nonnull NSString*)userName
{
    self.workflowType = type;
     [self startFlow:userName checkStatus:status withType:type];
}
-(void)processItemWithActivity:(AvartaActivitiesE)activity itemData:(nullable id)data
{
    if(!data ) {
        if(self.workflowType == AvartaVerifyWorkflow || self.workflowType ==     AvartaStepUpWorkflow || self.workflowType == AvartaStepUpElevatedWorkflow){
            if(activity == ActivityDynamicPin){
                [self wrongPin];
                return;
            }
        }
        data = @"";
    }
    __weak AvartaFlowModel *weakSelf = self;
    ECEncryption *encryption = [ECEncryption defaultInstance];
    
    NSString *encrypted = [self.cryptModel encryptString:data withKey:encryption.sharedSecret];

    [_manager postRequestWithKey:weakSelf.workflowModel.key Data:encrypted OperationName:[AvartaLibraryHelper codeForActivity:activity] andCompletion:^(NSError *error, NSDictionary *result) {
        if(!error)
        {
            weakSelf.workflowModel = (AvartaWorkflow*)[AvartaWorkflow mapSimpleObject:result toClass:[AvartaWorkflow class]];
            NSData *dtSharedSecret = [[ECEncryption defaultInstance] getSharedSecret:[result objectForKey:@"PublicKey"]];
            [weakSelf.cryptModel decryptSalt:weakSelf.workflowModel.salt withkey:dtSharedSecret];
            if(weakSelf.workflowModel.status.integerValue == AvartaStatusCompleted){
                if(weakSelf.workflowType == AvartaStepUpWorkflow || self.workflowType == AvartaStepUpElevatedWorkflow){
                    [weakSelf completeFlowCreateSession:NO UpdateSessionScore:YES];
                }else{
                    [weakSelf completeFlowCreateSession:YES UpdateSessionScore:NO];
                }
            }else if(weakSelf.workflowModel.status.integerValue ==     AvartaStatusFailed){
                if(weakSelf.workflowType == AvartaEnrollWorkflow){
                    error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_ENROLLED userName:nil];
                }else {
                    error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_VERIFIED userName:nil];
                }
                                
               [Bugsnag notifyError:error];
                [weakSelf failFlowUpdateSessionScore:YES withError:error];
            }else{
                [weakSelf flowProcess];
            }
        }else
        {
            [Bugsnag notifyError:error];
            [weakSelf errorForCurrentFlow:error];
        }
    }];
}

-(void)cancelFlow
{
    [self abortFlowWithType:self.workflowType];
}

-(void)errorForCurrentFlow:(NSError*)error  {

    if([self.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
        [self.delegate flowModel:self failedWithError:error];
    }
}


-(void)abortFlowWithType:(AvartaWorkflowType)type
{
    __weak AvartaFlowModel *weakSelf = self;
    [_manager abortEnrollmentWithKey:self.workflowModel.key andCompletion:^(NSError *error, NSDictionary *result) {
        if (!error){
            if([weakSelf.delegate respondsToSelector:@selector(flowModel:flowCanceledWithType:)]){
                [weakSelf.delegate flowModel:weakSelf flowCanceledWithType:type];
            }
        }else{
           [Bugsnag notifyError:error];
            error = [AvartaErrorManager checkBadRequestAndReturnError:error];
            if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                [weakSelf.delegate flowModel:weakSelf failedWithError:error];
            }
        }
    }];
}

-(void)startFlow:(NSString*)userName checkStatus:(BOOL)status withType:(AvartaWorkflowType)type
{
    __weak AvartaFlowModel *weakSelf = self;
    if(status){
        [_manager statusCheckRequestWithUsername:userName organizationKey:self.organizationId typeCode:[AvartaLibraryHelper typeCodeForAvartaWorkflowtype:type] andCompletion:^(NSError *error, NSDictionary *result) {
            if(!error)
            {
                weakSelf.workflowModel = (AvartaWorkflow*)[AvartaWorkflow mapSimpleObject:result toClass:[AvartaWorkflow class]];
                
                 NSData *dtSharedSecret = [[ECEncryption defaultInstance] getSharedSecret:[result objectForKey:@"PublicKey"]];
                
                [weakSelf.cryptModel decryptSalt:weakSelf.workflowModel.salt withkey:dtSharedSecret];
                if(weakSelf.workflowModel.status.integerValue ==     AvartaStatusCompleted){
                    if(weakSelf.workflowType == AvartaStepUpWorkflow || self.workflowType == AvartaStepUpElevatedWorkflow){
                        [weakSelf completeFlowCreateSession:NO UpdateSessionScore:YES];
                    }else{
                        [weakSelf completeFlowCreateSession:YES UpdateSessionScore:NO];
                    }
                }else if(weakSelf.workflowModel.status.integerValue ==     AvartaStatusFailed){
                    if(weakSelf.workflowType == AvartaEnrollWorkflow){
                        error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_ENROLLED userName:nil];
                    }else {
                        error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_VERIFIED userName:nil];
                    }
                   [Bugsnag notifyError:error];
                    [weakSelf failFlowUpdateSessionScore:YES withError:error];
                }else{
                    [weakSelf flowProcess];
                }
            }
            else
            {
               [Bugsnag notifyError:error];
                if([AvartaErrorManager checkNoWebInstance:error]){
                    [weakSelf startSessionWithUserName:userName andWorkflowType:type];
                }else{
                    error = [AvartaErrorManager checkBadRequestAndReturnError:error];
                    if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                        [weakSelf.delegate flowModel:weakSelf failedWithError:error];
                    }
                }
            }
        }];
    }else{
        [self startSessionWithUserName:userName andWorkflowType:type];
    }
}

-(void)parseAvartaErrorWithCode:(NSError*)error{
    NSError *formattedError = [AvartaErrorManager formattedErrorForError:error forLogIn:self.workflowType == AvartaVerifyWorkflow enableWorkflowKey:self.appSettings.isDeviceBased.boolValue andCurrentUserName:self.currentUserName];
    [Bugsnag notifyError:formattedError];
    if([self.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
        [self.delegate flowModel:self failedWithError:formattedError];
    }
}

//decrypt darshana
-(void)startSessionWithUserName:(NSString*)userName andWorkflowType:(AvartaWorkflowType)type{
    __weak AvartaFlowModel *weakSelf = self;
    NSString *key = [self.appSettings keyForWorkflowType:type];
    if(key){
        [_manager startSessionWithWorkFlowKey:key userName:userName sourceKey:self.applicationCode Completion:^(NSError *error, NSDictionary *result) {
            if(!error){
                weakSelf.workflowModel = (AvartaWorkflow*)[AvartaWorkflow mapSimpleObject:result toClass:[AvartaWorkflow class]];
                
                NSData *dtSharedSecret = [[ECEncryption defaultInstance] getSharedSecret:[result objectForKey:@"PublicKey"]];
                
                [weakSelf.cryptModel decryptSalt:weakSelf.workflowModel.salt withkey:dtSharedSecret];
                if(weakSelf.workflowModel.key)
                {
                    [weakSelf flowProcess];
                }
            }else{
                
                error = [AvartaErrorManager checkBadRequestAndReturnError:error];
               [Bugsnag notifyError:error];
                if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                    [weakSelf.delegate flowModel:weakSelf failedWithError:error];
                }
            }
        }];
    }else{
        NSError *error = [NSError errorWithDomain:AvartaErrorDomain code:ERR_WORKFLOW_INSTANCE_NOT_FOUND userInfo:@{NSLocalizedDescriptionKey:@"Unknown workflow"}];
       [Bugsnag notifyError:error];
        
        if([self.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
            [self.delegate flowModel:self failedWithError:error];
        }
    }
}

-(void)flowProcess
{
    __weak AvartaFlowModel *weakSelf = self;
    if(self.workflowModel.pendingActivities && self.workflowModel.pendingActivities.count > 0)
    {
        AvartaActivities *activity = [self.workflowModel.pendingActivities firstObject];
        if([self.delegate respondsToSelector:@selector(flowModel:userDataRequiredForActivity:)])
        {
            [self.delegate flowModel:weakSelf userDataRequiredForActivity:activity.activityType] ;
        }
    }else 
    {
        if(self.workflowType == AvartaStepUpWorkflow || self.workflowType ==     AvartaStepUpElevatedWorkflow){
            [self completeFlowCreateSession:NO UpdateSessionScore:YES];
        }else{
            [self completeFlowCreateSession:YES UpdateSessionScore:NO];
        }
        
    }
}


-(void)failFlowUpdateSessionScore:(BOOL)updateSessionScore withError:(NSError*)flowError{
    if(!self.workflowModel.deviceBasedFlag.boolValue){
        if([self.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
            [self.delegate flowModel:self failedWithError:flowError];
        }
    }else{
        __weak AvartaFlowModel *weakSelf = self;
        [_manager sessionCompleteRequest:self.workflowModel.key createSession:NO updateSessionScore:YES completion:^(NSError *error, NSDictionary *result) {
            if(!error){
                if([self.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                    [self.delegate flowModel:self failedWithError:flowError];
                }
            }else{
               [Bugsnag notifyError:error];
                error = [AvartaErrorManager checkBadRequestAndReturnError:error];
                if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                    [weakSelf.delegate flowModel:weakSelf failedWithError:error];
                }
            }
        }];
    }
}


-(void)completeFlowCreateSession:(BOOL)createSession UpdateSessionScore:(BOOL)updateSessionScore {
    if(!self.workflowModel.deviceBasedFlag.boolValue){
        if([self.delegate respondsToSelector:@selector(flowModel:flowCompletedWithType:deviceBased:andFullName:)]){
            [self.delegate flowModel:self flowCompletedWithType:self.workflowType deviceBased:self.workflowModel.deviceBasedFlag.boolValue andFullName:nil];
        }
    }else{
        __weak AvartaFlowModel *weakSelf = self;
        [_manager sessionCompleteRequest:self.workflowModel.key createSession:createSession updateSessionScore:updateSessionScore completion:^(NSError *error, NSDictionary *result) {
            if(!error){
                NSDictionary *user = result[@"User"];
                NSString *fullName = @"";
                if(user){
                    fullName = user[@"FullName"];
                }
                weakSelf.workflowModel = (AvartaWorkflow*)[AvartaWorkflow mapSimpleObject:result toClass:[AvartaWorkflow class]];
                if([self.delegate respondsToSelector:@selector(flowModel:flowCompletedWithType:deviceBased:andFullName:)]){
                    [self.delegate flowModel:self flowCompletedWithType:self.workflowType deviceBased:YES andFullName:fullName];
                }
            }else{
               [Bugsnag notifyError:error];
                error = [AvartaErrorManager checkBadRequestAndReturnError:error];
                if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                    [weakSelf.delegate flowModel:weakSelf failedWithError:error];
                }
            }
        }];
    }

}

-(void)wrongPin
{
    ECEncryption *encryption = [ECEncryption defaultInstance];
    
    
    NSString *result = [self.cryptModel encryptString:@"111" withKey:encryption.sharedSecret];
    __weak AvartaFlowModel *weakSelf = self;
    [_manager postRequestWithKey:self.workflowModel.key Data:result OperationName:ACTIVITY_DYNAMICPIN andCompletion:^(NSError *error, NSDictionary *result) {
        if(!error){
            if(weakSelf.workflowModel.deviceBasedFlag.boolValue){
                error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_VERIFIED userName:self.currentUserName];
               [Bugsnag notifyError:error];
                [weakSelf failFlowUpdateSessionScore:YES withError:error];
            }else{
                error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_VERIFIED userName:self.currentUserName];
               [Bugsnag notifyError:error];
                if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                    [weakSelf.delegate flowModel:weakSelf failedWithError:error];
                }
                
            }
        }else{
           [Bugsnag notifyError:error];
            if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                [weakSelf.delegate flowModel:weakSelf failedWithError:error];
            }
        }
    }];
}

-(void)wrongEyes
{
    NSDictionary *zoom = @{@"ZOOM" : @{@"Secret": @"00000000-0000-0000-0000-000000000000" }};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:zoom options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    ECEncryption *encryption = [ECEncryption defaultInstance];
    NSString *result = [self.cryptModel encryptString:jsonString withKey:encryption.sharedSecret];
    __weak AvartaFlowModel *weakSelf = self;
    [_manager postRequestWithKey:self.workflowModel.key Data:result OperationName:ACTIVITY_VALIDATEZOOMSECRET andCompletion:^(NSError *error, NSDictionary *result) {
        if(!error){
            if(weakSelf.workflowModel.deviceBasedFlag.boolValue){
                error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_VERIFIED userName:self.currentUserName];
               [Bugsnag notifyError:error];
                [weakSelf failFlowUpdateSessionScore:YES withError:error];
            }else{
                error = [AvartaErrorManager errorFromCode:ERR_USER_NOT_VERIFIED userName:self.currentUserName];
               [Bugsnag notifyError:error];
                if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                    [weakSelf.delegate flowModel:weakSelf failedWithError:error];
                }
            }
        }else{
           [Bugsnag notifyError:error];
            error = [AvartaErrorManager checkBadRequestAndReturnError:error];
            if([weakSelf.delegate respondsToSelector:@selector(flowModel:failedWithError:)]){
                [weakSelf.delegate flowModel:weakSelf failedWithError:error];
            }
        }
    }];
}



@end
