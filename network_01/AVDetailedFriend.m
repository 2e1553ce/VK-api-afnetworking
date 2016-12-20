//
//  AVDetailedFriend.m
//  network_01
//
//  Created by aiuar on 12.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import "AVDetailedFriend.h"

#import "AVServerManager.h"

#import "AVUser.h"

#import "DetailedUserCell.h"

#import <UIImageView+AFNetworking.h>

@interface AVDetailedFriend ()

@property (strong, nonatomic) AVUser *user;

@property (strong, nonatomic) NSMutableArray *arrayOfWallPosts;

@end

@implementation AVDetailedFriend

static NSInteger countOfWallPosts = 5;

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.arrayOfWallPosts = [NSMutableArray array];
    
    [self getUserFromServerById];
}

- (void)getUserFromServerById{
    
    [[AVServerManager sharedManager] getUserById:self.friendId
                                       onSuccess:^(AVUser *user){
                                           
                                           self.user = user;
                                           
                                           [self.tableView beginUpdates];
                                           
                                           NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                           NSArray *arrayOfIndex = @[indexPath];
                                           
                                           [self.tableView insertRowsAtIndexPaths:arrayOfIndex withRowAnimation:UITableViewRowAnimationFade];
                                           
                                           [self.tableView endUpdates];
                                       }
                                       onFailure:^(NSError *error, NSInteger statusCode) {
                                           NSLog(@"Error = %@, code = %ld",[error localizedDescription], statusCode);
                                       }];
    
    [[AVServerManager sharedManager] getWallByUserId:self.friendId
                                          withOffset:[self.arrayOfWallPosts count]
                                            andCount:countOfWallPosts onSuccess:^(NSArray *arrayOfWallPosts) {
                                                
                                            }
                                           onFailure:^(NSError *error, NSInteger statusCode) {
        
                                           }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(self.user){
        return 1;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if(indexPath.section == 0){
        
        static NSString *identifier = @"Cell";
        
        DetailedUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.firstNameLabel.text = self.user.firstName;
        cell.lastNameLabel.text = self.user.lastName;
        
        
        
        cell.countryLabel.text = self.user.country;
        cell.cityLabel.text = self.user.city;
        
        if(self.user.isOnline){
            cell.onlineLabel.text = @"онлайн";
            cell.onlineLabel.textColor = [UIColor greenColor];
        }
        else{
            cell.onlineLabel.text = @"оффлайн";
            cell.onlineLabel.textColor = [UIColor redColor];
        }
        NSLog(@"%f 1", cell.imageView.frame.size.height);
        cell.imageView.image = nil;
        
        
        //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        __weak DetailedUserCell *weakCell = cell;
        
        //NSURL *photoURL = [NSURL alloc] initWithString:self.user.photo100URL;
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.user.photo400URL];
        
        [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
            
            CGSize itemSize = CGSizeMake(150, 150);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [image drawInRect:imageRect];
            weakCell.userImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            
            //weakCell.imageView.image = image;
            [weakCell layoutSubviews];
            
            NSLog(@"%f 2", weakCell.imageView.frame.size.height);
        } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
            
        }];
        
        //NSLog(@"%f", cell.frame.size.height);
        
        return cell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

@end
