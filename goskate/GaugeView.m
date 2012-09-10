//
//  GaugeView.m
//  goskate
//
//  Created by Edward Kim on 9/8/12.
//  Copyright (c) 2012 shoddie. All rights reserved.
//

#import "GaugeView.h"
#import <QuartzCore/QuartzCore.h>

#define GREEN_SLICE_MAX (M_PI/2.0)
#define GREEN_SLICE_MIN 0.0
#define YELLOW_SLICE_MAX (3.0*M_PI/4.0)
#define YELLOW_SLICE_MIN (M_PI/2.0)
#define RED_SLICE_MAX M_PI
#define RED_SLICE_MIN (3.0*M_PI/4.0)
#define ANGLE_THRESHOLD 0.001

@interface GaugeView ()
@property (strong) NSMutableArray *animationQueue;
@property (strong) NSMutableArray *viewQueue;
@property (strong) UIView *greenSlice;
@property (strong) UIView *yellowSlice;
@property (strong) UIView *redSlice;
@property CGRect sliceRect;
@property CGPoint slicePoint;
@property CGFloat angle;
@end

@implementation GaugeView
@synthesize percent;
@synthesize animationQueue, viewQueue;
@synthesize greenSlice, yellowSlice, redSlice;
@synthesize sliceRect, slicePoint;
@synthesize angle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.animationQueue = [NSMutableArray new];
        self.viewQueue = [NSMutableArray new];
        
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
        
        whiteSliceLayer.zPosition = -1.0;
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
        
        self.angle = 0.0;
        
    }
    return self;
}

- (void)addView:(UIView*)view {
    if (!view.superview) {
        [self addSubview:view];
    }
}

- (void)drawRect:(CGRect)rect
{
}

- (void)changePosition:(double)per {
    self.animationQueue = [NSMutableArray new];
    self.viewQueue = [NSMutableArray new];
    
    self.percent = fmod(per, 100.0);
    self.angle = (self.percent/100.0)*M_PI;
    
    CGFloat greenAngle = MAX(MIN(self.angle, GREEN_SLICE_MAX),GREEN_SLICE_MIN);
    CGFloat yellowAngle = MAX(MIN(self.angle, YELLOW_SLICE_MAX),YELLOW_SLICE_MIN);
    CGFloat redAngle = MAX(MIN(self.angle, RED_SLICE_MAX),RED_SLICE_MIN);
    
    CGFloat currentGreenRotation = [[((CALayer*)self.greenSlice.layer.presentationLayer)
                                    valueForKeyPath:@"transform.rotation.z"] floatValue];
    CGFloat currentYellowRotation = MAX([[((CALayer*)self.yellowSlice.layer.presentationLayer)
                                    valueForKeyPath:@"transform.rotation.z"] floatValue],YELLOW_SLICE_MIN);
    CGFloat currentRedRotation = MAX([[((CALayer*)self.redSlice.layer.presentationLayer)
                                    valueForKeyPath:@"transform.rotation.z"] floatValue],RED_SLICE_MIN);
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotation.removedOnCompletion = NO;
    rotation.fillMode = kCAFillModeForwards;
    rotation.delegate = self;
    
    if (ABS(greenAngle-currentGreenRotation) > ANGLE_THRESHOLD) {
        CABasicAnimation *rotateGreen = [rotation copy];
        rotateGreen.duration = ABS(greenAngle-currentGreenRotation)*2.0/M_PI;
        rotateGreen.fromValue = @(currentGreenRotation);
        rotateGreen.toValue = @(greenAngle);
        [self.animationQueue addObject:rotateGreen];
        [self.viewQueue addObject:self.greenSlice];
    }
    
    if (ABS(yellowAngle-currentYellowRotation) > ANGLE_THRESHOLD) {
        CABasicAnimation *rotateYellow = [rotation copy];
        rotateYellow.duration = ABS(yellowAngle-currentYellowRotation)*2.0/M_PI;
        rotateYellow.fromValue = @(currentYellowRotation);
        rotateYellow.toValue = @(yellowAngle);
        if (currentYellowRotation < yellowAngle) {
            [self.animationQueue addObject:rotateYellow];
            [self.viewQueue addObject:self.yellowSlice];
        } else {
            [self.animationQueue insertObject:rotateYellow atIndex:0];
            [self.viewQueue insertObject:self.yellowSlice atIndex:0];
        }
    }
    
    if (ABS(redAngle-currentRedRotation) > ANGLE_THRESHOLD) {
        CABasicAnimation *rotateRed = [rotation copy];
        rotateRed.duration = ABS(redAngle-currentRedRotation)*2.0/M_PI;
        rotateRed.fromValue = @(currentRedRotation);
        rotateRed.toValue = @(redAngle);
        if (currentRedRotation < redAngle) {
            [self.animationQueue addObject:rotateRed];
            [self.viewQueue addObject:self.redSlice];
        } else {
            [self.animationQueue insertObject:rotateRed atIndex:0];
            [self.viewQueue insertObject:self.redSlice atIndex:0];
        }
    }
    
    if ([self.animationQueue count] > 0 && [self.viewQueue count] > 0)
        [[[self.viewQueue objectAtIndex:0] layer] addAnimation:[self.animationQueue objectAtIndex:0] forKey:@"rotate"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.greenSlice.layer.transform = ((CALayer*)self.greenSlice.layer.presentationLayer).transform;
    if (self.yellowSlice.superview) {
        self.yellowSlice.layer.transform = ((CALayer*)self.yellowSlice.layer.presentationLayer).transform;
        if (self.redSlice.superview)
            self.redSlice.layer.transform = ((CALayer*)self.redSlice.layer.presentationLayer).transform;
    }

    CGFloat currentYellowRotation = [[((CALayer*)self.yellowSlice.layer.presentationLayer) valueForKeyPath:@"transform.rotation.z"] floatValue];
    CGFloat currentRedRotation = [[((CALayer*)self.redSlice.layer.presentationLayer) valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    if (ABS(currentYellowRotation-YELLOW_SLICE_MIN) < ANGLE_THRESHOLD) {
        [self.yellowSlice removeFromSuperview]; 
    }
    if (ABS(currentRedRotation-RED_SLICE_MIN) < ANGLE_THRESHOLD) {
        [self.redSlice removeFromSuperview];
    }
    
    if (flag) {
        if ([self.animationQueue count] > 1 && [self.viewQueue count] > 1) {
            [self.animationQueue removeObjectAtIndex:0];
            [self.viewQueue removeObjectAtIndex:0];
            
            [self addView:[self.viewQueue objectAtIndex:0]];
            [[[self.viewQueue objectAtIndex:0] layer] addAnimation:[self.animationQueue objectAtIndex:0] forKey:@"rotate"];
        }
    }
}

@end
