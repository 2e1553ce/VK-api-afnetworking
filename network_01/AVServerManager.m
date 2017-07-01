 //
//  AVServerManager.m
//  network_01
//
//  Created by aiuar on 10.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import "AVServerManager.h"

#import <AFNetworking.h>

#import "AVUser.h"
#import "AVLoginViewController.h"
#import "AVAccessToken.h"

@interface AVServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@property (strong, nonatomic) AVAccessToken *accessToken;

@end

@implementation AVServerManager

+ (AVServerManager *)sharedManager{
    static AVServerManager *manager = nil;
    
    if(!manager){
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            manager = [[AVServerManager alloc] init];
        });
    }
    
    return manager;
}

- (id)init{
    self = [super init];
    
    if(self){
        
        NSURL *baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    
    return self;
}

- (void) authorizeUser:(void(^)(AVUser* user)) completion {

    AVLoginViewController* vc =
    [[AVLoginViewController alloc] initWithCompletionBlock:^(AVAccessToken *token) {
        
        self.accessToken = token;
        
        if (token) {
            
            [self getUser:self.accessToken.userID
            
                onSuccess:^(AVUser *user) {
                    if (completion) {
                        completion(user);
                    }
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    if (completion) {
                        completion(nil);
                    }
                }];
            
        } else if (completion) {
            completion(nil);
        }
        
    }];
    
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    UIViewController* mainVC = [[[[UIApplication sharedApplication] windows] firstObject] rootViewController];
    
    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];
}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(AVUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_ids",
     @"photo_50",   @"fields",
     @"nom",        @"name_case", nil];
    
    [self.sessionManager  GET:@"users.get"
                   parameters:params
                     progress:^(NSProgress * _Nonnull downloadProgress) {
                         
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          NSLog(@"JSON: %@", responseObject);
                          
                          NSArray* dictsArray = [responseObject objectForKey:@"response"];
                          
                          if ([dictsArray count] > 0) {
                              AVUser* user = [[AVUser alloc] initWithServerResponse:[dictsArray firstObject]];
                              if (success) {
                                  success(user);
                              }
                          } else {
                              if (failure) {
                                  NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                                  
                                  failure(nil, resp.statusCode);
                              }
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                          
                          NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                          
                          failure(error, resp.statusCode);
                      }];

}

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray *friends))success
                    onFailure:(void(^)(NSError *error, NSInteger  statusCode))failure{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"27319311",     @"user_id",
                            @"name",        @"order",
                            @(count),       @"count",
                            @(offset),      @"offset",
                            @"photo_100,online",   @"fields",
                            @"nom",         @"name_case",
                            nil];

// ***************************************************************************************************
    [self.sessionManager  GET:@"friends.get"
                   parameters:params
                     progress:^(NSProgress * _Nonnull downloadProgress) {
                         
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           
                          //NSLog(@"JSON: %@", responseObject);
                          
                          NSArray *dictArray = [responseObject objectForKey:@"response"];
                          
                          NSMutableArray *arrayOfUsers = [NSMutableArray array];
                          
                          for(NSDictionary *dict in dictArray){
                              
                              AVUser *user = [[AVUser alloc] initWithServerResponse:dict];
                              [arrayOfUsers addObject:user];
                          }
                          
                          if(success){
                              success(arrayOfUsers);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          if(failure){
                              
                              NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                              
                              failure(error, resp.statusCode);
                          }
                      }];
// ***************************************************************************************************
}

- (void) getUserById:(NSString *)userId
           onSuccess:(void(^)(AVUser *user))success
           onFailure:(void(^)(NSError *error, NSInteger statusCode))failure{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId,                                                 @"user_ids",
                            @"photo_400_orig,photo_100,city,sex,bdate,city,country,online,counters",@"fields",
                            @"nom",                                                 @"name_case",
                            @"5.52",                                                @"v",
                            nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {
        
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSArray *dictArray = [responseObject objectForKey:@"response"];
                         
                         NSDictionary *userInfo = [dictArray objectAtIndex:0];
                         
                         AVUser *user = [[AVUser alloc] initWithServerResponse:userInfo];
                         
                         if(success){
                             success(user);
                         }
                         
                         //NSLog(@"%@", responseObject);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         NSHTTPURLResponse* resp = (NSHTTPURLResponse*)task.response;
                         
                         failure(error, resp.statusCode);
                     }];
}

- (void)getWallByUserId:(NSString *)userId
             withOffset:(NSInteger)offset
               andCount:(NSInteger)count
              onSuccess:(void (^)(NSArray *arrayOfWallPosts))success
              onFailure:(void (^)(NSError *error, NSInteger statusCode))failure{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            userId, @"owner_id",
                            @(offset), @"offset",
                            @(count), @"count",
                            @"all", @"filter",
                            @"5.52", @"v",
                            nil];
        
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {
        
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSMutableArray *array = [[NSMutableArray alloc] init];
                         
                         NSLog(@"JSON: %@", responseObject);
                         
                         if(success){
                             success(array);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                     }];
}

@end
