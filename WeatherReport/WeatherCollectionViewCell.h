//
//  WeatherCollectionViewCell.h
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgWeather;

@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblTemp;
@property (weak, nonatomic) IBOutlet UILabel *lblWind;
@property (weak, nonatomic) IBOutlet UILabel *lblHum;

@end
