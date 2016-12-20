//
//  AVServerManager.h
//  network_01
//
//  Created by aiuar on 10.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVUser;

@interface AVServerManager : NSObject

@property (strong, nonatomic, readonly) AVUser *currentUser;

+ (AVServerManager *)sharedManager;

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(AVUser* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void)authorizeUser:(void(^)(AVUser *user))completition;

- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void(^)(NSArray *friends))success
                    onFailure:(void(^)(NSError *error, NSInteger  statusCode))failure;

- (void) getUserById:(NSString *)userId
           onSuccess:(void(^)(AVUser *))success
           onFailure:(void(^)(NSError *error, NSInteger statusCode))failure;

- (void)getWallByUserId:(NSString *)userId
             withOffset:(NSInteger)offset
               andCount:(NSInteger)count
              onSuccess:(void (^)(NSArray *arrayOfWallPosts))success
              onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
