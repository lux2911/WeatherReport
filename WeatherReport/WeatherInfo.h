//
//  WatherInfo.h
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfo : NSObject

@property (assign, nonatomic) float temperature;
@property (assign, nonatomic) float humidity;
@property (assign, nonatomic) float wind;
@property (strong, nonatomic) NSString* rainChances;
@property (strong, nonatomic) NSString* iconID;
@property (strong, nonatomic) NSString* desc;



@end
