//
//  AVLoginViewController.h
//  network_01
//
//  Created by aiuar on 16.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVAccessToken;

typedef void(^AVLoginCompletionBlock)(AVAccessToken *token);

@interface AVLoginViewController : UIViewController

- (id)initWithCompletionBlock:(AVLoginCompletionBlock )completionBlock;

@end
