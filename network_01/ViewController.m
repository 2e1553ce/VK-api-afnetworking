//
//  ViewController.m
//  network_01
//
//  Created by aiuar on 10.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import "ViewController.h"

#import "AVServerManager.h"

#import "AVUser.h"

#import <UIImageView+AFNetworking.h>

#import "AVDetailedFriend.h"



@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *arrayOfFriends;

@property (assign, nonatomic) BOOL loadingData;

@property (assign, nonatomic) BOOL firstLaunch;

@end

@implementation ViewController

static NSInteger friendsInRequest = 15;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.firstLaunch = YES;
    
    self.arrayOfFriends = [[NSMutableArray alloc] init];
    
    self.loadingData = YES;
    [self getFriendsFromServer];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(self.firstLaunch){
        self.firstLaunch = NO;
        
        [[AVServerManager sharedManager] authorizeUser:^(AVUser *user) {
            NSLog(@"AUTHORIZED! ");
            NSLog(@"%@ %@", user.firstName, user.lastName);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getFriendsFromServer];
        }
    }
}



#pragma mark - API

- (void)getFriendsFromServer{
    
    [[AVServerManager sharedManager] getFriendsWithOffset:[self.arrayOfFriends count]
                                                    count:friendsInRequest
                                                onSuccess:^(NSArray *friends) {
                                                    
                                                    if([friends count] == 0)
                                                        return;
                                                    
                                                    [self.arrayOfFriends addObjectsFromArray:friends];
                                                    
                                      
                                                    NSMutableArray *arrayOfIndexPathes = [[NSMutableArray alloc] init];
                                                    
                                                    for(int i = (int)[self.arrayOfFriends count] - (int)[friends count]; i < [self.arrayOfFriends count]; ++i){
                                                        
                                                        [arrayOfIndexPathes addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                                    }
                                                    
                                                    [self.tableView beginUpdates];
                                                    [self.tableView insertRowsAtIndexPaths:arrayOfIndexPathes withRowAnimation:UITableViewRowAnimationFade];
                                                    [self.tableView endUpdates];
                                                    
                                                    self.loadingData = NO;
                                                }
                                                onFailure:^(NSError *error, NSInteger statusCode) {
                                                    
                                                    NSLog(@"Error = %@, code = %ld", [error localizedDescription], statusCode);
                                                }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.arrayOfFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdetifier = @"friendCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdetifier];
    }
    
    AVUser *friend = [self.arrayOfFriends objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName ];
    
    if(friend.isOnline){
        cell.detailTextLabel.textColor = [UIColor greenColor];
        cell.detailTextLabel.text = @"online";
    }
    else{
        cell.detailTextLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = @"offline";
    }
    
    cell.imageView.image = nil;
    
    __weak UITableViewCell *weakCell = cell;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:friend.photo100URL];
    
    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        weakCell.imageView.image = image;
        [weakCell layoutSubviews];
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100.f;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"detailedFriendSegue"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        AVUser *user = [self.arrayOfFriends objectAtIndex:indexPath.row];
        
        AVDetailedFriend *destViewController = segue.destinationViewController;
        destViewController.friendId = user.id;
    }
}

@end
