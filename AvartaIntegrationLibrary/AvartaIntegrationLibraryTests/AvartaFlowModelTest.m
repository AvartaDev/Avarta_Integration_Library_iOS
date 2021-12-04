//
//  AvartaFlowModelTest.m
//  AvartaIntegrationLibraryTests
//
//  Created by Dmitrii Babii on 21.11.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock.h>
#import "AvartaNetworkRequestManager.h"
#import "AvartaFlowModel.h"
#import "AvartaSettingsManager.h"
#import "AvartaCryptModel.h"

@interface AvartaFlowModelTest : XCTestCase

@property (nonatomic, strong) NSDictionary *testJSON;

@end

@implementation AvartaFlowModelTest

- (void)setUp {
    [super setUp];
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [testBundle pathForResource:@"WorkflowJSON" ofType:@"json"];
    NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
    NSError *deserializingError;
    self.testJSON = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                    options:NSJSONReadingAllowFragments
                                                      error:&deserializingError];
}

-(void)flowModelStartTest
{
    id requestManagerMock = OCMClassMock([AvartaCodeNetworkRequestManager class]);
    id settingsManagerMock = OCMClassMock([AvartaCodeSettingsManager class]);
    id cryptModel = OCMClassMock([AvartaCodeCryptModel class]);
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}



@end
