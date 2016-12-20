//
//  AVLoginViewController.m
//  network_01
//
//  Created by aiuar on 16.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import "AVLoginViewController.h"

#import "AVAccessToken.h"

@interface AVLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) AVLoginCompletionBlock  completionBlock;

@property (weak, nonatomic) UIWebView *webView;

@end

@implementation AVLoginViewController

- (id)initWithCompletionBlock:(AVLoginCompletionBlock )completionBlock{
    
    self = [super init];
    
    if(self){
        self.completionBlock = completionBlock;
    }

    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    CGRect frame = self.view.bounds;
    frame.origin = CGPointZero;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    self.webView.delegate = self;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
 
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    self.navigationItem.title = @"Login";
    
    NSString *urlString =
        @"https://oauth.vk.com/authorize"
        "?client_id=5472315"
        "&display=mobile"
        "&redirect_uri=https://oauth.vk.com/blank.html"
        //"&redirect_uri=hello.there"
        "&scope=139286"
        "&response_type=token"
        "&v=5.52";
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // NSLog(@"LoginVC viewDidLoad");
    [webView loadRequest:request];
}

- (void)dealloc{
    
    self.webView.delegate = nil;
}

#pragma mark - Actions 

- (void)actionCancel:(UIBarButtonItem *)sender{
    
    if(self.completionBlock){
        self.completionBlock(nil);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSLog(@"%@", request);
    
    if([  [[request URL] description] rangeOfString:@"access_token="].location != NSNotFound){
        
        AVAccessToken *accsessToken = [[AVAccessToken alloc] init];
        
        NSString *query = [[request URL] description];
        
        NSArray *array = [query componentsSeparatedByString:@"#"];
        
        if([array count] > 1){
            query = [array lastObject];
        }
        
        NSArray *pairs = [query componentsSeparatedByString:@"&"];
        
        for(NSString *pair in pairs){
            
            NSArray *comp = [pair componentsSeparatedByString:@"="];
            
            if([[comp firstObject] isEqualToString:@"access_token"]){
                
                accsessToken.token = [comp lastObject];
            }else if([[comp firstObject] isEqualToString:@"user_id"]){
                
                accsessToken.userID = [comp lastObject];
            }else if([[comp firstObject] isEqualToString:@"expires_in"]){
                
                NSTimeInterval interval = [[comp lastObject] doubleValue];
                
                accsessToken.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
            }
        }
        
        self.webView.delegate = nil;
        
        if(self.completionBlock){
            self.completionBlock(accsessToken);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}

@end
