//
//  MediaTests.m
//  Fakestagram
//
//  Created by Brian Douglas on 9/5/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "User.h"
#import "Media.h"

@interface MediaTests : XCTestCase

@end

@implementation MediaTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatInitializationWorks {
    NSDictionary *mediaDictionary = @{@"id" : @"8675309",
                                      @"mediaUrl" : @"http://google.com?puppies"};
    
    Media *testMedia = [[Media alloc] initWithDictionary:mediaDictionary];
    
    XCTAssertEqual(testMedia.idNumber, mediaDictionary[@"id"], @"Media should match");
    XCTAssertEqualObjects(testMedia.mediaURL, [NSURL URLWithString:mediaDictionary[@"images"][@"standard_resolution"][@"url"]], @"Media URL should match");
}

@end
