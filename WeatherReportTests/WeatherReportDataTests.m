//
//  WeatherReportDataTests.m
//  WeatherReport
//
//  Created by Tomislav Luketic on 5/10/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DataManager.h"
#import "SessionMock.h"

@interface WeatherReportDataTests : XCTestCase<WeatherDataProtocol>
{
    XCTestExpectation* _promise;
}
@end

@implementation WeatherReportDataTests

- (void)setUp {
    [super setUp];
    
    NSBundle* aBundle = [NSBundle bundleForClass:[self class]];
    NSString* aPath = [aBundle pathForResource:@"data" ofType:@"json"];
    NSData* aData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:aPath]];
    
    NSURL* aURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast?lat=52.3687452&lon=4.8931795&units=metric&appid=c6e381d8c7ff98f0fee43775817cf6ad"];
    
    NSHTTPURLResponse* aResponse = [[NSHTTPURLResponse alloc] initWithURL:aURL statusCode:200 HTTPVersion:nil headerFields:nil];
    
    SessionMock* aSession = [[SessionMock alloc] initWithData:aData andResponse:aResponse andError:nil];
    
    [DataManager instance].urlSession = aSession;
    [DataManager instance].delegate = self;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetingData {

    XCTestExpectation* promise = [self expectationWithDescription:@"Status code: 200"];
    
    NSURL* aURL = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/forecast?lat=52.3687452&lon=4.8931795&units=metric&appid=c6e381d8c7ff98f0fee43775817cf6ad"];
    
    NSURLSessionDataTask* aDataTask = [[DataManager instance].urlSession dataTaskWithURL:aURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      
        if (((NSHTTPURLResponse*)response).statusCode==200)
          [promise fulfill];
        
    }];
    
    [aDataTask resume];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

-(void)testDownloadData
{
   
    _promise = [self expectationWithDescription:@"Status code: 200"];
    
    [[DataManager instance] downloadDataWithLatitude:52.3687452 andLongitude:4.8931795 andUnits:@"metric"];
    
    [self waitForExpectationsWithTimeout:5 handler:^(NSError * _Nullable error) {
        
        if (!error)
        {
            
        }
    }];

}

-(void)weatherInfo:(NSDictionary*)json
{
   
    [_promise fulfill];
}
-(void)onError:(NSError*)error message:(NSString*)msg
{
    
}


@end
