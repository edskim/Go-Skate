//
//  GaugeView.m
//  goskate
//
//  Created by Edward Kim on 9/8/12.
//  Copyright (c) 2012 shoddie. All rights reserved.
//

#import "GaugeView.h"
#import <QuartzCore/QuartzCore.h>

@interface GaugeView ()
//@property double percent;
@property (strong) UIView *greenSlice;
@property (strong) UIView *yellowSlice;
@property (strong) UIView *redSlice;
@property CGRect sliceRect;
@property CGPoint slicePoint;
@property CGFloat angle;
@end

@implementation GaugeView
@synthesize percent;
@synthesize greenSlice, yellowSlice, redSlice;
@synthesize sliceRect, slicePoint;
@synthesize angle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGSize sliceSize = [[UIImage imageNamed:@"whitepie.png"] size];
        self.sliceRect = CGRectMake(0, 0, sliceSize.width, sliceSize.height);
        self.slicePoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + (sliceSize.height/2));
        
        self.greenSlice = [[UIView alloc] initWithFrame:self.bounds];
        self.greenSlice.backgroundColor = [UIColor clearColor];
        self.yellowSlice = [[UIView alloc] initWithFrame:self.bounds];
        self.yellowSlice.backgroundColor = [UIColor clearColor];
        self.redSlice = [[UIView alloc] initWithFrame:self.bounds];
        self.redSlice.backgroundColor = [UIColor clearColor];
        
        CALayer *whiteSliceLayer = [[CALayer alloc] init];
        whiteSliceLayer.bounds = self.sliceRect;
        whiteSliceLayer.position = self.slicePoint;
        CALayer *greenSliceLayer = [[CALayer alloc] init];
        greenSliceLayer.bounds = self.sliceRect;
        greenSliceLayer.position = self.slicePoint;
        CALayer *yellowSliceLayer = [[CALayer alloc] init];
        yellowSliceLayer.bounds = self.sliceRect;
        yellowSliceLayer.position = self.slicePoint;
        CALayer *redSliceLayer = [[CALayer alloc] init];
        redSliceLayer.bounds = self.sliceRect;
        redSliceLayer.position = self.slicePoint;
        
        self.layer.zPosition = -1.0;
        self.greenSlice.layer.zPosition = -2.0;
        self.yellowSlice.layer.zPosition = -3.0;
        self.redSlice.layer.zPosition = -4.0;
        
        whiteSliceLayer.contents = (__bridge id)[[UIImage imageNamed:@"whitepie.png"] CGImage];
        greenSliceLayer.contents = (__bridge id)[[UIImage imageNamed:@"greenpie.png"] CGImage];
        yellowSliceLayer.contents = (__bridge id)[[UIImage imageNamed:@"yellowpie.png"] CGImage];
        redSliceLayer.contents = (__bridge id)[[UIImage imageNamed:@"redpie.png"] CGImage];
        
        [self.layer addSublayer:whiteSliceLayer];
        [self.greenSlice.layer addSublayer:greenSliceLayer];
        [self.yellowSlice.layer addSublayer:yellowSliceLayer];
        [self.redSlice.layer addSublayer:redSliceLayer];
        
        [self addSubview:self.greenSlice];
        [self addSubview:self.yellowSlice];
        [self addSubview:self.redSlice];
        
        self.angle = 0.0;
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [[UIColor greenColor] set];
//    CGContextSetLineWidth(context, 20.0);
//    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, (self.bounds.size.width/2)-20, 3*M_PI/4, (3*M_PI/4)+((self.percent/100.0)*3*M_PI/2), NO);
//    CGContextStrokePath(context);
}

- (void)changePosition:(double)per {
    
    self.percent = fmod(per, 100.0);
    
    self.angle = (self.percent/100.0)*M_PI;
    CGFloat greenAngle = MIN(self.angle, M_PI/2.0);
    CGFloat yellowAngle = MIN(self.angle, 3.0*M_PI/4.0);
    CGFloat redAngle = MIN(self.angle, M_PI);
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.removedOnCompletion = NO;
    rotate.fillMode = kCAFillModeForwards;
    
    rotate.duration = 1.0;
    rotate.fromValue = @([[((CALayer*)self.greenSlice.layer.presentationLayer) valueForKeyPath:@"transform.rotation.z"] floatValue]);
    rotate.toValue = @(greenAngle);
    [self.greenSlice.layer addAnimation:rotate forKey:@"green"];
    
    rotate.duration = 1.0;
    rotate.fromValue = @([[((CALayer*)self.yellowSlice.layer.presentationLayer) valueForKeyPath:@"transform.rotation.z"] floatValue]);
    rotate.toValue = @(yellowAngle);
    [self.yellowSlice.layer addAnimation:rotate forKey:@"yellow"];
    
    rotate.duration = 1.0;
    rotate.fromValue = @([[((CALayer*)self.redSlice.layer.presentationLayer) valueForKeyPath:@"transform.rotation.z"] floatValue]);
    rotate.toValue = @(redAngle);
    rotate.delegate = self;
    [self.redSlice.layer addAnimation:rotate forKey:@"red"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"Current red angle: %f", [[self.redSlice.layer valueForKeyPath:@"transform.rotation.z"] floatValue]);    
    self.greenSlice.layer.transform = ((CALayer*)self.greenSlice.layer.presentationLayer).transform;
    self.yellowSlice.layer.transform = ((CALayer*)self.yellowSlice.layer.presentationLayer).transform;
    self.redSlice.layer.transform = ((CALayer*)self.redSlice.layer.presentationLayer).transform;
    NSLog(@"New red angle: %f", [[self.redSlice.layer valueForKeyPath:@"transform.rotation.z"] floatValue]);

}

@end
