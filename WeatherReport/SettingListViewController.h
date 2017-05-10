//
//  SettingListViewController.h
//  Weather
//
//  Created by Tomislav Luketic on 5/10/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsProtocol <NSObject>

-(void)didChangeSettingForKey:(NSString*)aKey value:(NSString*)value;

@end

@interface SettingListViewController : UIViewController

@property (strong, nonatomic) NSString* selectedTitle;
@property (strong, nonatomic) NSString* key;
@property (strong, nonatomic) NSArray* tableData;
@property (weak, nonatomic) id<SettingsProtocol> delegate;

@end
