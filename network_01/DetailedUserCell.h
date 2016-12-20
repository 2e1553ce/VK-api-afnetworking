//
//  DetailedUserCell.h
//  network_01
//
//  Created by aiuar on 13.05.16.
//  Copyright © 2016 I.T. Pulse. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;

@end
