//
//  MovieDetailViewController.m
//  RottenTomatoesDemo
//
//  Created by Alan McConnell on 10/13/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieDescription;
@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIView *foreground;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation MovieDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureMoveAround:)];
    [self.panGestureRecognizer setMaximumNumberOfTouches:1];
    [self.panGestureRecognizer setDelegate:self];
    [self.foreground addGestureRecognizer:self.panGestureRecognizer];
    
    // Do any additional setup after loading the view from its nib.
    self.title = self.movie[@"title"];
    self.movieTitle.text = self.title;
    self.movieRatingLabel.text = [NSString stringWithFormat:@"Critics Score: %ld, Audience Score: %ld", (long)[self.movie[@"ratings"][@"critics_score"] integerValue], (long)[self.movie[@"ratings"][@"audience_score"] integerValue]];
    self.movieDescription.text = self.movie[@"synopsis"];
    [self.movieDescription sizeToFit];
    
    [self resizeToFitSubviews:self.foreground];
    float y = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.foreground.frame.size.height - 80;
    [self.foreground setFrame:CGRectMake(0, y, self.foreground.frame.size.width, self.foreground.frame.size.height)];
    
    // Grab a thumbnail to use as the placeholder while the larger image loads
    NSString *posterURL = self.movie[@"posters"][@"original"];
    UIImageView *thumbnail = [[UIImageView alloc] init];
    [thumbnail setImageWithURL: [NSURL URLWithString:posterURL]];
    
    // Need a string replace to get the large format image.
    NSString* origPosterURL = [posterURL stringByReplacingOccurrencesOfString:@"_tmb." withString:@"_ori."];

    
    [self.background setImageWithURL:[NSURL URLWithString:origPosterURL]
                     placeholderImage:[thumbnail image]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)panGestureMoveAround:(UIPanGestureRecognizer *)gesture;
{
    UIView *piece = [gesture view];
    
    if ([gesture state] == UIGestureRecognizerStateBegan || [gesture state] == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x, [piece center].y+translation.y*0.5)];
        [gesture setTranslation:CGPointZero inView:[piece superview]];
    }
}

-(void)resizeToFitSubviews:(UIView *)view;
{
    float w = 0;
    float h = 0;
    
    for (UIView *v in [view subviews]) {
        float fw = v.frame.origin.x + v.frame.size.width;
        float fh = v.frame.origin.y + v.frame.size.height;
        w = MAX(fw, w);
        h = MAX(fh, h);
    }
    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, w, h + 10)];
}
@end
