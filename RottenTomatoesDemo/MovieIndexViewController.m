//
//  MovieIndexViewController.m
//  RottenTomatoesDemo
//
//  Created by Alan McConnell on 10/13/14.
//  Copyright (c) 2014 Alan McConnell. All rights reserved.
//

#import "MovieIndexViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieIndexViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MovieIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 100;
    self.title = @"RT";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil]
                    forCellReuseIdentifier:@"MovieTableViewCell"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
                                    [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=ytw6t5hxujfxnrd7sgtwgjaa"]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSDictionary *JSON = [NSJSONSerialization
                                                     JSONObjectWithData: data
                                                     options: NSJSONReadingMutableContainers
                                                     error: nil];
                               NSLog(@"%@", JSON);

                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadData];
    MovieDetailViewController* dvc = [[MovieDetailViewController alloc] init];
    [self.navigationController pushViewController:dvc animated:YES];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    cell.synopsisLabel.text = @"Synopsis";
    cell.titleLabel.text = @"Movie Title";

    UIImageView *iv = [[UIImageView alloc] init];
    [iv setImageWithURL:[NSURL URLWithString:@"https://pbs.twimg.com/profile_images/464460229300600832/esZd6eQp.jpeg"]];
    cell.posterImage = iv;
    return cell;
}

@end
