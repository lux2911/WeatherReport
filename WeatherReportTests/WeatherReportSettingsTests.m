//
//  WeatherReportSettingsTests.m
//  WeatherReport
//
//  Created by Tomislav Luketic on 5/10/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Settings.h"

@interface WeatherReportSettingsTests : XCTestCase
@property (strong, nonatomic) Settings* settings;
@end

@implementation WeatherReportSettingsTests

- (void)setUp {
    
      [super setUp];
  }

- (void)tearDown {
   
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSettings];
    [[Settings instance] releaseSettings];
   
    [super tearDown];
}

- (void)testSettingsList {
    
    XCTAssert( [[Settings instance].settingsList count]>0,@"Settings list cannot be empty!");
}


- (void)testMakeOfCurrentSettings {
    
    XCTAssert( [[[Settings instance] currentSettings] count]>0,@"Settings failed to initialize!");
}

- (void)testSaveSettings {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kSettings];
  
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[kMode] = kDrop;
    
    [[Settings instance] saveSettings:dict];
    
    XCTAssert( [[[Settings instance] currentSettings][kMode] isEqualToString:kDrop] ,@"Settings not saved properly!");
}


@end
