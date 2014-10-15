//
//  MovieDetailViewController.h
//  RottenTomatoesDemo
//
//  Created by Alan McConnell on 10/13/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController <UIGestureRecognizerDelegate>

@property(weak, nonatomic) NSDictionary *movie;
@end
