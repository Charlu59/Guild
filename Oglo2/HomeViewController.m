//
//  HomeViewController.m
//  Oglo
//
//  Created by Charles-Hubert Basuiau on 04/05/2016.
//  Copyright © 2016 Appiway. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
    NSMutableArray *services;
}

@end

@implementation HomeViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor greenColor]];
    services = [[NSMutableArray alloc] init];
}

@end
