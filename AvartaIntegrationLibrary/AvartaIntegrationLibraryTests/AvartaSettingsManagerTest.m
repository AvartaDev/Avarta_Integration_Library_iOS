//
//  AvartaCodeSettingsManager.m
//  AvartaCode
//
//  Created by Dmitrii Babii on 08.09.17.
//  Copyright © 2017 AvartaCode Password Solutions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AvartaNetworkRequestManager.h"
#import "AvartaSettingsManager.h"
#import <OCMock.h>
#import "AvartaAppSettingsModel.h"
#import "AvartaSettingsWorkflowItem.h"
#import "AvartaSettingLicenseItem.h"
#import "AvartaDeviceConfigurationModel.h"
#import "AvartaLicenseProvider.h"
#import "AvartaLicenseOperatingSystem.h"

@interface AvartaSettingsManagerTest : XCTestCase

@property (nonatomic, strong) NSDictionary *testJSON;

@end

@implementation AvartaSettingsManagerTest

- (void)setUp {
    [super setUp];
    NSBundle *testBundle = [NSBundle bundleForClass:[AvartaSettingsManagerTest class]];
    NSString *filePath = [testBundle pathForResource:@"AppSettingsJSON" ofType:@"json"];
    XCTAssertNotNil(filePath);
    NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
    NSError *deserializingError;
    self.testJSON = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                    options:NSJSONReadingAllowFragments
                                                      error:&deserializingError];
}

- (void)testGetAppSettings {
    id requestManagerMock = OCMClassMock([AvartaNetworkRequestManager class]);
    AvartaSettingsManager *sutManager = [[AvartaSettingsManager alloc] initWithNetworkManager:requestManagerMock];
    OCMStub([requestManagerMock appConfigRequestWithApplicationCode:@"VIPER" Completion:([OCMArg invokeBlockWithArgs:[NSNull null], self.testJSON, nil])]);
    [sutManager getApplicationSettingsWithApplicationCode:@"VIPER" Completion:^(NSError * _Nullable error, AvartaAppSettingsModel * _Nullable model) {
        XCTAssertNil(error);
        XCTAssertNotNil(model);
    }];
    OCMVerifyAll(requestManagerMock);
}

- (void)testGetAppSettingsError
{
    id requestManagerMock = OCMClassMock([AvartaCodeNetworkRequestManager class]);
    AvartaCodeSettingsManager *sutManager = [[AvartaCodeSettingsManager alloc] initWithNetworkManager:requestManagerMock];
    OCMStub([requestManagerMock appConfigRequestWithApplicationCode:@"VIPER" Completion:([OCMArg invokeBlockWithArgs:[NSError errorWithDomain:@"TestDomain" code:400 userInfo:@{NSLocalizedDescriptionKey:@"TestError"}], [NSNull null], nil])]);
    [sutManager getApplicationSettingsWithApplicationCode:@"VIPER" Completion:^(NSError * _Nullable error, AvartaAppSettingsModel * _Nullable model) {
        XCTAssertNotNil(error);
        XCTAssertNil(model);
        XCTAssertTrue([error.domain isEqualToString:@"TestDomain"]);
        XCTAssertEqual(error.code, 400);
        XCTAssertTrue([error.localizedDescription isEqualToString:@"TestError"]);
    }];
    OCMVerifyAll(requestManagerMock);
}

-(void)testModelNotNil
{
    AvartaCodeAppSettingsModel *model = [AvartaCodeAppSettingsModel mapSimpleObject:self.testJSON toClass:[AvartaCodeAppSettingsModel class]];
    XCTAssertNotNil(model);
}

-(void)testModelFieldsVaildation
{
    AvartaAppSettingsModel *model = [AvartaAppSettingsModel mapSimpleObject:self.testJSON toClass:[AvartaCodeAppSettingsModel class]];
    XCTAssertTrue([model.code isEqualToString:@"VIPER"]);
    XCTAssertTrue([model.name isEqualToString:@"Viper"]);
    XCTAssertTrue(model.isDeviceBased.boolValue);
    XCTAssertNotNil(model.workflows);
    XCTAssertEqual(model.workflows.count, 3);
    XCTAssertNotNil(model.licences);
    XCTAssertEqual(model.licences.count, 1);
    XCTAssertNotNil(model.deviceConfiguration);
    
    AvartaSettingsWorkflowItem *workflowItem = [model.workflows firstObject];
    XCTAssertNotNil(workflowItem);
    XCTAssertTrue([workflowItem.code isEqualToString:@"ENROL"]);
    XCTAssertTrue([workflowItem.key isEqualToString:@"9b6f98e5-8309-40e8-98da-9fc5b296353e"]);
    
    workflowItem = model.workflows[1];
    XCTAssertNotNil(workflowItem);
    XCTAssertTrue([workflowItem.code isEqualToString:@"AUTH"]);
    XCTAssertTrue([workflowItem.key isEqualToString:@"cbc2c58d-88e2-4084-b444-387fd1aa4761"]);
    
    workflowItem = [model.workflows lastObject];
    XCTAssertNotNil(workflowItem);
    XCTAssertTrue([workflowItem.code isEqualToString:@"DE-ENROL"]);
    XCTAssertTrue([workflowItem.key isEqualToString:@"9d8abc00-0e11-4c14-83bc-7c8075c7f6a7"]);
    
    AvartaSettingLicenseItem *license = [model.licences firstObject];
    XCTAssertNotNil(license);
    XCTAssertNotNil(license.provider);
    XCTAssertNotNil(license.operatingSystem);
    XCTAssertTrue([license.key isEqualToString:@"SOLUS1"]);
    XCTAssertTrue([license.startDate isEqualToString:@"2017-09-11T10:04:37.797"]);
    XCTAssertTrue([license.endDate isEqualToString:@"2017-12-31T23:59:59"]);
    
    AvartaLicenseProvider *provider = license.provider;
    XCTAssertNotNil(provider);
    XCTAssertTrue([provider.name isEqualToString:@"Eye Verify"]);
    XCTAssertTrue([provider.code isEqualToString:@"EYEVERIFY"]);
    
    AvartaLicenseOperatingSystem *os = license.operatingSystem;
    XCTAssertNotNil(os);
    XCTAssertTrue([os.name isEqualToString:@"Android"]);
    XCTAssertTrue([os.code isEqualToString:@"ANDROID"]);
}

@end
