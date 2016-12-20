//
//  GroupWallViewController.m
//  network_01
//
//  Created by aiuar on 13.07.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import "GroupWallViewController.h"

#import "AVServerManager.h"
#import "AVUser.h"

@interface GroupWallViewController ()

@property (strong, nonatomic) NSMutableArray *postArray;
@property (assign, nonatomic) BOOL firstLaunch;

@end

@implementation GroupWallViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.firstLaunch = YES;
    
    self.postArray = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.firstLaunch){
        self.firstLaunch = NO;
        
        [[AVServerManager sharedManager] authorizeUser:^(AVUser *user) {
            
            NSLog(@"AUTHORIZED!");
            NSLog(@"%@ %@", user.firstName, user.lastName);
        }];
    }
}

@end
