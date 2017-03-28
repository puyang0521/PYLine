//
//  GradientColorView.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "GradientColorView.h"

@interface GradientColorView ()

@property (nonatomic, strong) CAGradientLayer  *gradientLayer;

@end

@implementation GradientColorView

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.startPoint = CGPointMake(0, 0);
        self.endPoint   = CGPointMake(1, 0);
        
        self.colors     = @[(__bridge id)[UIColor redColor].CGColor,
                            (__bridge id)[UIColor greenColor].CGColor,
                            (__bridge id)[UIColor blueColor].CGColor];
        
        self.locations  = @[@(0.25), @(0.5), @(0.75)];
        
        _gradientLayer = (CAGradientLayer *)self.layer;
    }
    
    return self;
}

- (void)becomeEffective {
    
    self.gradientLayer.startPoint = self.startPoint;
    self.gradientLayer.endPoint   = self.endPoint;
    self.gradientLayer.colors     = self.colors;
    self.gradientLayer.locations  = self.locations;
}

@end
