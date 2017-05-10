//
//  SettingListViewController.m
//  Weather
//
//  Created by Tomislav Luketic on 5/10/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "SettingListViewController.h"

@interface SettingListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableHeaderView = nil;
    self.tableView.tableFooterView=[UIView new];
    
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 20;
    
  
}


-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell* aCell = [self.tableView dequeueReusableCellWithIdentifier:@"SettingItemCell"];
    
     aCell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    
    
     NSString* aTitle = self.tableData[indexPath.row];
    
     if ([aTitle isEqualToString:self.selectedTitle])
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
         });
         
         aCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        
     }
      else
          aCell.accessoryType = UITableViewCellAccessoryNone;
    
     aCell.textLabel.text = aTitle;
    
    
     return aCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* aCell = [tableView cellForRowAtIndexPath:indexPath];
    aCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSString* aTitle = self.tableData[indexPath.row];
    self.selectedTitle = aTitle;
   
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* aCell = [tableView cellForRowAtIndexPath:indexPath];
    aCell.accessoryType = UITableViewCellAccessoryNone;
}

-(void)setSelectedTitle:(NSString *)selectedTitle
{
    if (_selectedTitle && ![selectedTitle isEqualToString:_selectedTitle])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"modeSwitched" object:self userInfo:@{ @"mode" : selectedTitle}];
        
        if ([self.delegate respondsToSelector:@selector(didChangeSettingForKey:value:)])
            [self.delegate didChangeSettingForKey:self.key value:selectedTitle];
        
    }
    
    _selectedTitle = selectedTitle;
}


@end
