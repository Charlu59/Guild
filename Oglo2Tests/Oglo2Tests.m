//
//  Oglo2Tests.m
//  Oglo2Tests
//
//  Created by Charles-Hubert Basuiau on 11/05/2016.
//  Copyright © 2016 Appiway. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Oglo2Tests : XCTestCase

@end

@implementation Oglo2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssert(NO,@"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
