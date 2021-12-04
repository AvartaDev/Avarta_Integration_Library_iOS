//
//  AvartaModel.h
//  Avarta
//
//  Created by Dmitrii Babii on 17.12.15.
//  Copyright © 2015 Avarta Password Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AvartaInternalConstants.h"
#import "AvartaIntegrationLibrary.h"


typedef enum {
    FORMFACTOR_INTEGRATION = 1,
    FORMFACTOR_DEVICE = 2
} FORM_FACTORS;


@class AvartaAppSettingsModel;
@class AvartaFlowModel;
@class AvartaCryptModel;
@class AvartaNetworkRequestManager;
@class AvartaSettingsManager;
@class AvartaLibrarySettings;
@class AvartaWorkflow;

@protocol AvartaFlowModelDelegate <NSObject>
-(void)flowModel:(nonnull AvartaFlowModel*)flowModel flowCanceledWithType:(AvartaWorkflowType)type;
-(void)flowModel:(nonnull AvartaFlowModel*)flowModel userDataRequiredForActivity:(AvartaActivitiesE)activity;
-(void)flowModel:(nonnull AvartaFlowModel*)flowModel failedWithError:(nonnull NSError*)error;
-(void)flowModel:(nonnull AvartaFlowModel*)flowModel flowCompletedWithType:(AvartaWorkflowType)type deviceBased:(BOOL)deviceBased andFullName:(nullable NSString*)fullName;
@end

@interface AvartaFlowModel : NSObject

@property (nonatomic, weak, nullable) id<AvartaFlowModelDelegate> delegate;
@property (nonatomic, strong, nullable) AvartaWorkflow *workflowModel;
@property (nonnull, nonatomic, strong) AvartaAppSettingsModel *appSettings;

-(nullable instancetype)initWithRequestManager:(nonnull AvartaNetworkRequestManager*)requestManager cryptModel:(nonnull AvartaCryptModel*)cryptModel andOrganizationId:(nonnull NSString*)organizationId applicationCode:(nonnull NSString*)applicationCode;
-(void)startFlowWithType:(AvartaWorkflowType)type checkStatus:(BOOL)status userName:(nonnull NSString*)userName;
-(void)processItemWithActivity:(AvartaActivitiesE)activity itemData:(nullable NSString*)data;
-(void)cancelFlow;

@end
