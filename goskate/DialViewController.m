//
//  DialViewController.m
//  goskate
//
//  Created by Edward Kim on 9/8/12.
//  Copyright (c) 2012 shoddie. All rights reserved.
//

#import "DialViewController.h"
#import "GaugeView.h"
#import <QuartzCore/QuartzCore.h>

@interface DialViewController ()
@property (strong) UIButton *stopButton;
@property (strong) GaugeView *gaugeView;
@end

@implementation DialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.stopButton.backgroundColor = [UIColor clearColor];
    [self.stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.stopButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.stopButton.frame = CGRectMake(0, 400.0, self.view.bounds.size.width, 40.0);
    [self.stopButton addTarget:self action:@selector(stopPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stopButton];
    
    self.gaugeView = [[GaugeView alloc] initWithFrame:CGRectMake(self.view.center.x-140.0, self.view.center.y-140.0,
                                                                   280, 280)];
    NSLog(@"origin: %f,%f",self.view.center.x, self.view.center.y);
    [self.view addSubview:self.gaugeView];
    
    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-125.0, self.view.center.y-125.0, 250, 250)];
    centerImage.image = [UIImage imageNamed:@"gobutton.png"];
    [self.view addSubview:centerImage];
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

- (void)changeGauge {
    double change = (((double)arc4random()/UINT_MAX)*10.0)-5.0;
    [self.gaugeView changePosition:(self.gaugeView.percent+change)];
}

- (void)stopPressed {
    static double position = 50.0;
    [self.gaugeView changePosition:position];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeGauge) userInfo:nil repeats:YES];
    
    //[self.navigationController popToRootViewControllerAnimated:NO];
    
    
}

@end
