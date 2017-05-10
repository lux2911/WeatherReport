//
//  Settings.m
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@property (strong, nonatomic) NSMutableDictionary* currentSettings;


@end

static dispatch_once_t onceToken;
static Settings *sharedInstance = nil;

@implementation Settings


+ (instancetype)instance {
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [self loadSettingsList];
        
        _currentSettings = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] valueForKey:kSettings]];
        
        if ([_currentSettings count] == 0)
            [self makeDefaultSettings];
        
        
    }
    
    return self;
}

-(void)loadSettingsList
{
    NSBundle* bundle = [NSBundle mainBundle];
    
    NSString *aPath = [bundle pathForResource:kSettings ofType:@"plist"];
    
    if (aPath)
    {
        _settingsList = [[NSMutableArray alloc] initWithContentsOfFile:aPath];
    }

}

-(void)makeDefaultSettings
{
    _currentSettings = [NSMutableDictionary dictionary];
    
    for (NSDictionary* dict in self.settingsList) {
        
        NSString* aKey = dict[kKey];
        NSArray* arr = dict[kContent];
        
        if ([arr count]>0)
        {
            _currentSettings[aKey] = arr[0];
        }
        
        
    }
    
    [self saveSettings:_currentSettings];
}




-(NSMutableDictionary *)currentSettings
{
    return  _currentSettings;
}

-(void)saveSettings:(NSMutableDictionary*)aSettings
{
    _currentSettings = aSettings;
   [[NSUserDefaults standardUserDefaults] setObject:aSettings forKey:kSettings];
}

-(void)releaseSettings
{
    onceToken = 0;
    sharedInstance = nil;
    
}


@end
