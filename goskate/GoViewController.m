//
//  GoViewController.m
//  goskate
//
//  Created by Edward Kim on 9/8/12.
//  Copyright (c) 2012 shoddie. All rights reserved.
//

#import "DialViewController.h"
#import "GoViewController.h"
#import "LocationManagerStore.h"

@interface GoViewController ()
@property (strong) UIButton *goButton;
@end

@implementation GoViewController
@synthesize goButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goButton.frame = CGRectMake(self.view.center.x-125.0, self.view.center.y-125.0, 250, 250);
    [self.goButton addTarget:self action:@selector(goButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.goButton.backgroundColor = [UIColor clearColor];
    [self.goButton setImage:[UIImage imageNamed:@"goButton.png"] forState:UIControlStateNormal];
    [self.view addSubview:self.goButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)goButtonPressed {
    [self.navigationController pushViewController:[DialViewController new] animated:NO];
    [[LocationManagerStore sharedStore] startLocationUpdates];
}

@end
