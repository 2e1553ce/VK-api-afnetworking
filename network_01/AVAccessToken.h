//
//  AVAccessToken.h
//  network_01
//
//  Created by aiuar on 16.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAccessToken : NSObject

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSDate *expirationDate;

@end
