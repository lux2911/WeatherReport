//
//  Place.m
//  Weather
//
//  Created by Tomislav Luketic on 5/6/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "Place.h"

@interface Place ()
{
    CLLocationDegrees latitude;
    CLLocationDegrees longitude;
    BOOL isEncoding;
}

@end

@implementation Place

@synthesize title;

#define kLatitude @"latitude"
#define kLongitude @"longitude"
#define kTitle @"title"

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    isEncoding = YES;
     [aCoder encodeDouble:latitude forKey:kLatitude];
     [aCoder encodeDouble:longitude forKey:kLongitude];
     [aCoder encodeObject:title forKey:kTitle];
    
    isEncoding = NO;
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initWithLatitude:[aDecoder decodeDoubleForKey:kLatitude] andLongitude:[aDecoder decodeDoubleForKey:kLongitude] andTitle:[aDecoder decodeObjectForKey:kTitle]];
    
    return self;
}


-(id)initWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon andTitle:(NSString*)aTitle
{
    self = [super init];
    
    if (self)
    {
        latitude = lat;
        longitude = lon;
        
        title = aTitle;
        _title2 = title;
        _coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
    
    return self;
}


- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    
}

-(NSString *)title
{
    if (!isEncoding)
     return @" ";
    
    return title;
}

-(void)setTitle2:(NSString *)title2
{
    _title2 = title2;
    
}




@end
