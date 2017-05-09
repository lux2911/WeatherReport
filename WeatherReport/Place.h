//
//  Place.h
//  Weather
//
//  Created by Tomislav Luketic on 5/6/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Place : NSObject<MKAnnotation,NSCoding>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy , readonly) NSString* title;
@property (nonatomic, strong , readonly) NSString* title2;


-(id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon andTitle:(NSString*)title;


@end
