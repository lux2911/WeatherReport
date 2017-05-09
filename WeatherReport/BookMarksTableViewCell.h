//
//  BookMarksTableViewCell.h
//  Weather
//
//  Created by Tomislav Luketic on 5/8/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookMarksTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong , nonatomic) NSString* gps;


@end
