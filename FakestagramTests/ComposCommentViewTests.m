//
//  ComposCommentViewTests.m
//  Fakestagram
//
//  Created by Brian Douglas on 9/5/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ComposeCommentView.h"

@interface ComposCommentViewTests : XCTestCase

@end

@implementation ComposCommentViewTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- testThatComposeCommentsSetText {
    ComposeCommentView *testCommentView = [[ComposeCommentView alloc] init];
    [testCommentView setText:@"Yo this is text"];
    
    XCTAssertEqual(testCommentView.isWritingComment, (BOOL)YES, "Setting text successfully sets isWriting to True");
}

- testThatComposeCommentsSetTextToNO {
    ComposeCommentView *testCommentView = [[ComposeCommentView alloc] init];
    
    XCTAssertEqual(testCommentView.isWritingComment, (BOOL)NO, "Not setting text returns isWriting as false");
}
@end
