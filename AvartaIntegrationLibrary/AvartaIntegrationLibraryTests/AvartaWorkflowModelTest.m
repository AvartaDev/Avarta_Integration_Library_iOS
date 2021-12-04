//
//  AvartaWorkflowTest.m
//  Avarta
//
//  Created by Dmitrii Babii on 07.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AvartaWorkflow.h"
#import "AvartaActivities.h"
#import "AvartaActivityType.h"
#import "AvartaLibraryHelper.h"


@interface AvartaWorkflowModelTest : XCTestCase

@property (nonatomic, strong) NSDictionary *testJSON;

@end

@implementation AvartaWorkflowModelTest

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

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testWorkflowModelParsing {
    
    XCTAssertNotNil(self.testJSON);
    id workflow = [AvartaWorkflow mapSimpleObject:self.testJSON toClass:[AvartaWorkflow class]];
    XCTAssertTrue([workflow isKindOfClass:[AvartaWorkflow class]]);
    AvartaWorkflow *parsedWorkflow = (AvartaWorkflow*)workflow;
    XCTAssertNotNil(parsedWorkflow.key);
    XCTAssertNotNil(parsedWorkflow.deviceBasedFlag);
    XCTAssertNotNil(parsedWorkflow.pendingActivities);
    XCTAssertNotNil(parsedWorkflow.score);
    XCTAssertNotNil(parsedWorkflow.source);
    XCTAssertNotNil(parsedWorkflow.salt);
    XCTAssertNotNil(parsedWorkflow.status);
    XCTAssertNotNil(parsedWorkflow.dateCreated);
    XCTAssertNotNil(parsedWorkflow.dateUpdated);
    
    id pendingActivity = [parsedWorkflow.pendingActivities firstObject];
    XCTAssertTrue([pendingActivity isKindOfClass:[AvartaActivities class]]);
    
    AvartaActivities *activity = (AvartaActivities*)pendingActivity;
    XCTAssertNotNil(activity.type);
    XCTAssertTrue([activity.type isKindOfClass:[AvartaActivityType class]]);
    
    XCTAssertNotNil(activity.type.code);
    XCTAssertNotNil(activity.type.name);
}

-(void)testWorkflowActivityWithCode{
    XCTAssertNotNil(self.testJSON);
    id workflow = [AvartaWorkflow mapSimpleObject:self.testJSON toClass:[AvartaWorkflow class]];
    XCTAssertTrue([workflow isKindOfClass:[AvartaWorkflow class]]);
    AvartaWorkflow *parsedWorkflow = (AvartaWorkflow*)workflow;
    AvartaActivities *activiy = [parsedWorkflow activityWithCode:@"PASSWORD"];
    XCTAssertNotNil(activiy);
    XCTAssertTrue([activiy.code isEqualToString:@"PASSWORD"]);
    XCTAssertTrue([activiy.name isEqualToString:@"Authentication Password Request"]);
    XCTAssertTrue([activiy.type.code isEqualToString:@"AUTH"]);
    XCTAssertTrue([activiy.type.name isEqualToString:@"Authentication Activity Type"]);
    XCTAssertEqual(activiy.activityType, ActivityPassword);
}

-(void)testActivityTypeCode
{
    NSString *activityType = [AvartaLibraryHelper codeForActivity:ActivityPassword];
    XCTAssertNotNil(activityType);
    XCTAssertTrue([activityType isEqualToString:@"PASSWORD"]);
    activityType = [AvartaLibraryHelper codeForActivity:ActivityEyeVerify];
    XCTAssertNotNil(activityType);
    XCTAssertTrue([activityType isEqualToString:@"EYEVERIFY"]);
    activityType = [AvartaLibraryHelper codeForActivity:ActivityUndefined];
    XCTAssertNil(activityType);
}


@end
