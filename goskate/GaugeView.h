//
//  GaugeView.h
//  goskate
//
//  Created by Edward Kim on 9/8/12.
//  Copyright (c) 2012 shoddie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GaugeView : UIView
@property double percent;
- (void)changePosition:(double)per;
@end
