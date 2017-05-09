//
//  DataManager.h
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@protocol WeatherDataProtocol <NSObject>

-(void)weatherInfo:(NSDictionary*)json;
-(void)onError:(NSError*)error message:(NSString*)msg;

@end

@interface DataManager : NSObject


@property (weak, nonatomic) id<WeatherDataProtocol> delegate;

+ (instancetype)instance;
-(void)downloadDataWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon andUnits:(NSString*)units;

@end
