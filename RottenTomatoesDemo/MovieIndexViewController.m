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
#import "SVProgressHUD.h"

@interface MovieIndexViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) int currentPage;
@property (strong) NSMutableArray* movieData;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorView;

@end

@implementation MovieIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"Movies";
    self.currentPage = 1;
    self.networkErrorView.hidden = YES;

    [self.tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"MovieTableViewCell"];

    // Configure Refresh Control
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.movieData = [[NSMutableArray alloc] init];
    [self reloadMovieData];
}

- (void)reloadMovieData {
    [SVProgressHUD show];
    NSString *requestStr = [NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?apikey=ytw6t5hxujfxnrd7sgtwgjaa&page=%d", self.currentPage];

    NSURL *requestURL = [NSURL URLWithString:requestStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:requestURL
                                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                            timeoutInterval:10.0];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               [SVProgressHUD dismiss];

                               if (!data) {
                                   self.networkErrorView.hidden = NO;
                                   return;
                               }
                               self.networkErrorView.hidden = YES;

                               NSDictionary* json = [NSJSONSerialization
                                                     JSONObjectWithData: data
                                                     options: NSJSONReadingMutableContainers
                                                     error: nil];
                               [self.movieData addObjectsFromArray:json[@"movies"]];

                               [self.tableView reloadData];
                           }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadMovieData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailViewController* dvc = [[MovieDetailViewController alloc] init];
    dvc.movie = self.movieData[indexPath.row];
    [self.navigationController pushViewController:dvc animated:YES];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* movie = self.movieData[indexPath.row];

    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    cell.titleLabel.text = movie[@"title"];
    [cell.posterImage setImageWithURL:[NSURL URLWithString: movie[@"posters"][@"thumbnail"]]];
    cell.posterImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.posterImage.clipsToBounds=YES;

    if (indexPath.row == self.movieData.count - 1) {
        [self loadNextPage];
    }
    
    return cell;
}


- (void)refresh {
    self.movieData = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    [self reloadMovieData];
    [self.refreshControl endRefreshing];
}

- (void)loadNextPage {
    self.currentPage++;
    [self reloadMovieData];
}

@end
