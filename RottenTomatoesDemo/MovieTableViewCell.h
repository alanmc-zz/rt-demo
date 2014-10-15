//
//  MovieTableViewCell.h
//  RottenTomatoesDemo
//
//  Created by Alan McConnell on 10/13/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong) IBOutlet UIImageView *posterImage;

@end
