//
//  APIManager.h
//  DotaTime
//
//  Created by Джонни Диксон on 11.07.15.
//  Copyright (c) 2015 Lavskiy Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol APIManagerDelegate;

@interface APIManager : NSObject

@property (nonatomic, strong) id<APIManagerDelegate> delegate;

- (void) postDataFromURL:(NSString*) url withParams:(NSDictionary*) params;

- (void) getDataFromURL:(NSString*) url withParams:(NSDictionary *)params andToken:(NSString*) usertoken;

+ (APIManager*) managerWithDelegate: (id<APIManagerDelegate>) aDelegate;

    -(id) initWithDelegate:(id<APIManagerDelegate>) aDelegate;


@end


@protocol APIManagerDelegate <NSObject>
@required
- (void) response: (APIManager* ) manager Answer:(id) respObject;
- (void) responseError: (APIManager* ) manager Error:(NSError*) error;

@end