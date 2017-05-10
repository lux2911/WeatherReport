//
//  Settings.h
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUnit @"unit"
#define kSettings @"Settings"
#define kKey @"key"
#define kContent @"content"
#define kFooter @"footer"
#define kIsButton @"isButton"
#define kTitle @"title"
#define kMode @"mode"
#define kDrop @"drop"
#define kDrag @"drag"
#define kMetric @"metric"

@interface Settings : NSObject

@property (strong, nonatomic, readonly) NSMutableArray* settingsList;

+ (instancetype)instance;
-(NSMutableDictionary *)currentSettings;
-(void)saveSettings:(NSMutableDictionary*)aSettings;

-(void)releaseSettings;

@end
