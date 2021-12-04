//
//  AvartaBehaviosecMappingTest.m
//  Avarta
//
//  Created by Dmitrii Babii on 08.08.17.
//  Copyright © 2017 Avarta Password Solutions. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AvartaBehaviosecMapping.h"

@interface AvartaBehaviosecMappingTest : XCTestCase

@property (nonatomic, strong) NSDictionary *testJSON;

@end

@implementation AvartaBehaviosecMappingTest

- (void)setUp {
    [super setUp];
    NSBundle *testBundle = [NSBundle bundleForClass:[AvartaBehaviosecMappingTest class]];
    NSString *filePath = [testBundle pathForResource:@"BehaviosecJSON" ofType:@"json"];
    XCTAssertNotNil(filePath);
    NSURL *localFileURL = [NSURL fileURLWithPath:filePath];
    NSData *contentOfLocalFile = [NSData dataWithContentsOfURL:localFileURL];
    NSError *deserializingError;
    self.testJSON = [NSJSONSerialization JSONObjectWithData:contentOfLocalFile
                                                    options:NSJSONReadingAllowFragments
                                                      error:&deserializingError];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBehaviosecMapping {
    
    XCTAssertNotNil(self.testJSON);
    id testMapping = [AvartaBehaviosecMapping mapSimpleObject:self.testJSON toClass:[AvartaBehaviosecMapping class]];
    XCTAssertTrue([testMapping isKindOfClass:[AvartaBehaviosecMapping class]]);
    AvartaBehaviosecMapping *mapping = (AvartaBehaviosecMapping*)testMapping;
    
}



@end
