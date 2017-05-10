//
//  SessionMock.h
//  WeatherReport
//
//  Created by Tomislav Luketic on 5/10/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataTaskMockProtocol <NSObject>

- (NSURLSessionDataTask *)dataTaskWithURL:(NSURL *)url completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;



@end

@interface SessionMock : NSObject<DataTaskMockProtocol>

-(instancetype)initWithData:(NSData*)data andResponse:(NSHTTPURLResponse*)response andError:(NSError*)error;

@end

@interface NSURLSession (SessionCategory)<DataTaskMockProtocol>

@end

