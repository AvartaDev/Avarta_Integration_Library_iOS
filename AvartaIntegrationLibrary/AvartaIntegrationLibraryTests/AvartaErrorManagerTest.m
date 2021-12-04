//
//  AvartaErrorManagerTest.m
//  Avarta
//
//  Created by Dmitrii Babii on 30.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AvartaErrorManager.h"
#import "HTTPSessionManager.h"
#import "Constants.h"
#import "AvartaIntergrationLibrary.h"

@interface AvartaErrorManagerTest : XCTestCase

@end

@implementation AvartaErrorManagerTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


-(void)testCheckNoWebInstance
{
    NSError *testError = [NSError errorWithDomain:@"AvartaTest" code:400 userInfo:@{kErrorJsonDataKey:@{@"Message" : @"4"}}];
    XCTAssertTrue([AvartaErrorManager checkNoWebInstance:testError]);
    
    NSError *failError = [NSError errorWithDomain:@"AvartaTest" code:400 userInfo:@{kErrorJsonDataKey:@{@"Message" : @"2"}}];
    XCTAssertFalse([AvartaErrorManager checkNoWebInstance:failError]);
    
    NSError *noJsonError = [NSError errorWithDomain:@"AvartaTest" code:400 userInfo:@{NSLocalizedDescriptionKey:@"Bad request"}];
    XCTAssertFalse([AvartaErrorManager checkNoWebInstance:noJsonError]);
}

-(void)testAvartaCodeFromError
{
    NSError *testError = [NSError errorWithDomain:@"AvartaTest" code:400 userInfo:@{kErrorJsonDataKey:@{@"Message" : @"4"}}];
    NSString * AvartaCode = [AvartaErrorManager AvartaCodeFromError:testError];
    XCTAssertNotNil(AvartaCode);
    XCTAssertTrue([AvartaCode isEqualToString:@"4"]);
}

-(void)testAvartaCodeFromErrorNil
{
    NSError *noJsonError = [NSError errorWithDomain:@"AvartaTest" code:400 userInfo:@{NSLocalizedDescriptionKey:@"Bad request"}];
    NSString *AvartaCode = [AvartaErrorManager AvartaCodeFromError:noJsonError];
    XCTAssertNil(AvartaCode);
}

-(void)testErrorFromAvartaCodeWrongCode
{
    NSError *wrongCodeError = [AvartaErrorManager errorFromAvartaCode:@"Wrong code"];
    XCTAssertNil(wrongCodeError);
}

-(void)testErrorFromAvartaCodeNil
{
    NSError *wrongCodeError = [AvartaErrorManager errorFromAvartaCode:nil];
    XCTAssertNil(wrongCodeError);
}

-(void)testErrorFromAvartaCodeValidate
{
    for(int i = 0; i <= 11; i++){
        NSError *wrongCodeError = [AvartaErrorManager errorFromAvartaCode:[NSString stringWithFormat:@"%d", i]];
        XCTAssertNotNil(wrongCodeError);
        XCTAssertEqual(wrongCodeError.code, kBadRequestCode);
    }
    
    NSError *wrongCodeError = [AvartaErrorManager errorFromAvartaCode:@"14"];
    XCTAssertNotNil(wrongCodeError);
    XCTAssertEqual(wrongCodeError.code, kBadRequestCode);
    
    wrongCodeError = [AvartaErrorManager errorFromAvartaCode:@"17"];
    XCTAssertNotNil(wrongCodeError);
    XCTAssertEqual(wrongCodeError.code, kBadRequestCode);
    
    wrongCodeError = [AvartaErrorManager errorFromAvartaCode:@"18"];
    XCTAssertNotNil(wrongCodeError);
    XCTAssertEqual(wrongCodeError.code, ERR_USER_NOT_ENROLLED_ON_SERVER);
    
    wrongCodeError = [AvartaErrorManager errorFromAvartaCode:@"19"];
    XCTAssertNotNil(wrongCodeError);
    XCTAssertEqual(wrongCodeError.code, ERR_USER_NOT_ENROLLED_ON_DEVICE);
}



@end
