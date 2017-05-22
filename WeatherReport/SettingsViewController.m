//
//  SecondViewController.m
//  Weather
//
//  Created by Tomislav Luketic on 5/10/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsButtonTableViewCell.h"
#import "Settings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* tableData;
@property (strong, nonatomic) NSMutableDictionary* settingsValues;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight=UITableViewAutomaticDimension;
    
    self.navigationItem.title = @"Settings";
    
    
    self.tableView.tableHeaderView = nil;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.sectionHeaderHeight = 20;
    
    [self loadSettings];
    [self loadSettingsValues];
    
    [self.tableView reloadData];

}

-(void)loadSettings
{
    
    self.tableData = [Settings instance].settingsList;
   
}

-(void)loadSettingsValues
{
    self.settingsValues = [[Settings instance] currentSettings];
}

-(void)saveSettings
{
    [[NSUserDefaults standardUserDefaults] setValue:self.settingsValues forKey:kSettings];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark -UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.tableData count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#define kTextInset 10

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSDictionary* dict = self.tableData[section];
    NSString* footerText = dict[kFooter];
    
    if ([footerText length]>0)
    {
        CGFloat aWidth = self.view.frame.size.width - (kTextInset*2);
        
        CGRect aFrame = [footerText boundingRectWithSize:CGSizeMake(aWidth,CGRectGetHeight(self.view.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10]} context:nil];
        
        return aFrame.size.height + (kTextInset*2);
    }
    
    return 0.0;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary* dict = self.tableData[indexPath.section];
    
    NSString* aKey = dict[kKey];
    NSArray* arr = dict[kContent];
    NSString* aTitle = dict[kTitle];
    NSNumber* isButton = dict[kIsButton];
    
    NSString* reuseIdentifier = nil;
    
    if ([isButton boolValue])
        reuseIdentifier = @"SettingsButtonCell";
    else
        reuseIdentifier = @"SettingsCell";
    
    UITableViewCell* aCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
    if ([reuseIdentifier isEqualToString:@"SettingsButtonCell"])
    {
        SettingsButtonTableViewCell * btnCell = (SettingsButtonTableViewCell*)aCell;
        [btnCell.btnSetting setTitle:aTitle forState:UIControlStateNormal];
        [btnCell.btnSetting setTitle:aTitle forState:UIControlStateSelected];
        [btnCell.btnSetting addTarget:self action:NSSelectorFromString(aKey) forControlEvents:UIControlEventTouchDown];
        
    }
    else
    {
        
        aCell.textLabel.text = aTitle;
        
        if (aKey)
        {
            if ([self.settingsValues[aKey] length]>0)
                aCell.detailTextLabel.text = self.settingsValues[aKey];
            else
                if ([arr count]>0)
                    aCell.detailTextLabel.text = arr[0];
        }
        else
            if ([arr count]>0)
                aCell.detailTextLabel.text = arr[0];
        
    }
    
    return aCell;
    
}


#pragma mark


#pragma mark -UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSDictionary* dict = self.tableData[section];
    NSString* footerText = dict[kFooter];
    
    if ([footerText length]>0)
    {
        UIView* aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        aView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        CGFloat aWidth = self.view.frame.size.width - (kTextInset*2);
        
        UILabel* lbl = [[UILabel alloc] initWithFrame:CGRectMake(kTextInset, kTextInset, aWidth, 0)];
        lbl.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        lbl.textColor = [UIColor darkGrayColor];
        lbl.text = footerText;
        lbl.numberOfLines = 0;
        
        CGRect aFrame = [footerText boundingRectWithSize:CGSizeMake(aWidth,CGRectGetHeight(self.view.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10]} context:nil];
       
        lbl.frame = CGRectMake(kTextInset, kTextInset, CGRectGetWidth(aFrame), CGRectGetHeight(aFrame));
        
        aView.frame = CGRectMake(0, 0, CGRectGetWidth(lbl.frame), aFrame.size.height + (kTextInset*2));
        
        [aView addSubview:lbl];
        
        return aView;
       
       
    }
    
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* aCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([aCell.reuseIdentifier isEqualToString:@"SettingsCell"])
    {
        NSDictionary* dict = self.tableData[indexPath.section];
        NSArray* arr = dict[kContent];
        NSString* aKey = dict[kKey];
        
        UIStoryboard* sb =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SettingListViewController* vc = [sb instantiateViewControllerWithIdentifier:@"SettingListViewController"];
        
        if ([self.settingsValues count]>0)
        {
            vc.selectedTitle = self.settingsValues[aKey];
        }
        
        vc.tableData = arr;
        vc.key = aKey;
        vc.delegate = self;
        
        UITabBarController* tb = (UITabBarController*)[[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        UINavigationController* nc = tb.selectedViewController;
        
        [nc pushViewController:vc animated:YES];
        
        
        
    }
}

#pragma mark


-(void)clear_bookmarks
{
    
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Bookmarks"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bookmarksDeleted" object:self];
        
        
        UIAlertController* ac2 = [UIAlertController alertControllerWithTitle:@"Done" message:@"Bookmarks deleted !" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* action3 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [ac2 addAction:action3];
        
        [self presentViewController:ac2 animated:YES completion:nil];
        
    }];

    
    
    [ac addAction:action];
    [ac addAction:action2];
    
    
    
    [self presentViewController:ac animated:YES completion:nil];
    
    
   
}


-(void)didChangeSettingForKey:(NSString*)aKey value:(NSString*)value
{
    self.settingsValues[aKey] = value;
    [[Settings instance] saveSettings:self.settingsValues];
    [self.tableView reloadData];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
   
      [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
       [self.tableView reloadData];
    
   
}



@end
