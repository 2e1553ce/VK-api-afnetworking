//
//  AVUser.h
//  Pods
//
//  Created by aiuar on 11.05.16.
//
//

#import <Foundation/Foundation.h>

@interface AVUser : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSURL *photo100URL;
@property (nonatomic, strong) NSURL *photo400URL;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *birthday;

- (id)initWithServerResponse:(NSDictionary *)responseObject;

@end
