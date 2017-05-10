//
//  SessionMock.m
//  WeatherReport
//
//  Created by Tomislav Luketic on 5/10/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "SessionMock.h"
// typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

typedef void(^CompletionHandler)(NSData*,NSURLResponse*,NSError*);

@interface DataTaskMock : NSURLSessionDataTask


@property (nonatomic,copy) CompletionHandler completionHandler;

@property (nonatomic,strong) NSData* data;
@property (nonatomic, strong) NSHTTPURLResponse*  responseM;
@property (nonatomic,strong) NSError* errorM;
@end

@implementation DataTaskMock




-(void)resume
{
    dispatch_async(dispatch_get_main_queue(),^{
      
        self.completionHandler(self.data, self.responseM, self.errorM);
    
    });
}

@end




@implementation SessionMock
{
   
     DataTaskMock* _dataTaskMock;
    
   
}


-(instancetype)initWithData:(NSData*)data andResponse:(NSHTTPURLResponse*)response andError:(NSError*)error
{
    self = [super init];
    if (self)
    {
        _dataTaskMock = [DataTaskMock new];
        _dataTaskMock.data = data;
        _dataTaskMock.responseM = response;
        _dataTaskMock.errorM = error;
        
        
    }
    
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler
{
   
    _dataTaskMock.completionHandler = completionHandler;
    
    return _dataTaskMock;
}

@end



@implementation NSURLSession (SessionCategory)



@end

