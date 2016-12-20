//
//  AVUser.m
//  Pods
//
//  Created by aiuar on 11.05.16.
//
//

#import "AVUser.h"

@implementation AVUser

- (id)initWithServerResponse:(NSDictionary *)responseObject
{
    
    self = [super init];
    
    if(self){
        
        self.firstName =        [responseObject objectForKey:@"first_name"];
        self.lastName =         [responseObject objectForKey:@"last_name"];
        self.id =               [responseObject objectForKey:@"user_id"];
        self.isOnline =         [[responseObject objectForKey:@"online"] boolValue];
        
        if([responseObject objectForKey:@"country"])
        {
            NSDictionary *countryDict = [responseObject objectForKey:@"country"];
            self.country = [countryDict objectForKey:@"title"];
        }
        
        if([responseObject objectForKey:@"city"])
        {
            NSDictionary *cityDict = [responseObject objectForKey:@"city"];
            self.city = [cityDict objectForKey:@"title"];
        }
        
        
        NSString *urlString = [responseObject objectForKey:@"photo_100"];
        
        if(urlString){
         
            self.photo100URL = [NSURL URLWithString:urlString];
        }
        
        if([responseObject objectForKey:@"photo_400_orig"]){
            NSString *urlString = [responseObject objectForKey:@"photo_400_orig"];
            
            if(urlString){
                
                self.photo400URL = [NSURL URLWithString:urlString];
            }
        }
        
        self.birthday = [responseObject objectForKey:@"bdate"];
    }
    
    return self;
}

@end
