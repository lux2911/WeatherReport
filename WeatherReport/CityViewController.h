//
//  CityViewController.h
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "DataManager.h"

@interface CityViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,WeatherDataProtocol>


@property (weak, nonatomic) Place* place;

-(void)downloadData;

@end
