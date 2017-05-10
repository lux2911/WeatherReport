//
//  DataManager.m
//  Weather
//
//  Created by Tomislav Luketic on 5/9/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "DataManager.h"

@interface DataManager ()


@property (strong, nonatomic) NSURLSessionDataTask* dataTask;

@end

@implementation DataManager

static NSString* baseAddress = @"http://api.openweathermap.org/data/2.5/forecast?lat=%.7f&lon=%.7f&units=%@&appid=%@";

static NSString* apiKey = @"c6e381d8c7ff98f0fee43775817cf6ad";

static NSErrorDomain OpenWeatherMapApiErrorDomain = @"OpenWeatherMapApiErrorDomain";

static DataManager *sharedInstance = nil;

static dispatch_once_t onceToken;

+ (instancetype)instance {
    
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}


-(id)init
{
    self = [super init];
    
    if (self)
    {
        self.urlSession= [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        
    }
    
    return self;
}

-(void)downloadDataWithLatitude:(CLLocationDegrees)lat andLongitude:(CLLocationDegrees)lon andUnits:(NSString*)units
{
    
    NSURL* aURL=[NSURL URLWithString:[NSString stringWithFormat:baseAddress,lat,lon,units,apiKey]];
    
    self.dataTask = [self.urlSession dataTaskWithURL:aURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (!error)
        {
            
            NSError * jsonErr;
            NSDictionary* dict=	[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonErr];
            
            if (!jsonErr)
            {
                if ([dict[@"cod"] isEqualToString:@"200"])
                {
                    if ([self.delegate respondsToSelector:@selector(weatherInfo:)])
                        [self.delegate weatherInfo:dict];
                }
                else
                {
                    if ([self.delegate respondsToSelector:@selector(onError:message:)])
                    {
                        NSError* err = [NSError errorWithDomain:OpenWeatherMapApiErrorDomain code:[dict[@"cod"] integerValue] userInfo:nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate onError:err message:dict[@"message"]];
                            
                        });
                        
                    }
                }
            }
            else
            {
               if ([self.delegate respondsToSelector:@selector(onError:message:)])
               {
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self.delegate onError:jsonErr message:nil];
                  });
               }
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(onError:message:)])
            {
                 dispatch_async(dispatch_get_main_queue(), ^{
                
                     [self.delegate onError:error message:nil];
                 });
            }
  
        }

        
    }];
    
    [self.dataTask resume];
    
    
    
}

-(void)releaseDataManager
{
    onceToken = 0;
    sharedInstance = nil;
    
}


@end
