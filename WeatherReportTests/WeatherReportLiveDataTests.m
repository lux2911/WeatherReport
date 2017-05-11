//
//  WeatherReportLiveDataTests.m
//  WeatherReport
//
//  Created by Tomislav Luketic on 5/11/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataManager.h"

@interface WeatherReportLiveDataTests : XCTestCase<WeatherDataProtocol>
{
    XCTestExpectation* _promise,*_promise2;
}
@end

@implementation WeatherReportLiveDataTests

- (void)setUp {
    [super setUp];
    
    [DataManager instance].delegate = self;
}

- (void)tearDown {
   
    [[DataManager instance] releaseDataManager];
   
    [super tearDown];
}

- (void)testDownloadLiveData {
    
    _promise = [self expectationWithDescription:@"JSON contains key:'cod' "];
    
    [[DataManager instance] downloadDataWithLatitude:52.3687452 andLongitude:4.8931795 andUnits:@"metric"];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void)weatherInfo:(NSDictionary*)json
{
    if (json[@"cod"])
        [_promise fulfill];
    
    if ([json[@"cod"] isEqualToString:@"200"])
        [_promise2 fulfill];
}
-(void)onError:(NSError*)error message:(NSString*)msg
{
    
}



@end
