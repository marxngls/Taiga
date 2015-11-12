//
//  APIManager.m
//  DotaTime
//
//  Created by Джонни Диксон on 11.07.15.
//  Copyright (c) 2015 Lavskiy Peter. All rights reserved.
//

#import "APIManager.h"
#import <AFNetworking/AFNetworking.h>



@implementation APIManager

+ (APIManager*) managerWithDelegate: (id<APIManagerDelegate>) aDelegate{
    
    return [[APIManager alloc] initWithDelegate:aDelegate];
}

-(id) initWithDelegate:(id<APIManagerDelegate>) aDelegate
{
    self = [super init];
    if (self) {
        self.delegate = aDelegate;
    }
    return self;
}

- (void) postDataFromURL:(NSString*) url withParams:(NSDictionary *)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        if ([self.delegate respondsToSelector:@selector(response:Answer:)]){
            [self.delegate response:self Answer:responseObject];
        }
        
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        
        if ([self.delegate respondsToSelector:@selector(responseError:Error:)]){
            [self.delegate responseError:self Error:error];
        }
        
    }];

}

- (void) getDataFromURL:(NSString*) url withParams:(NSDictionary *)params andToken:(NSString*) usertoken{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",usertoken] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        if ([self.delegate respondsToSelector:@selector(response:Answer:)]){
            [self.delegate response:self Answer:responseObject];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(responseError:Error:)]){
            [self.delegate responseError:self Error:error];
        }
    }];
}

@end
