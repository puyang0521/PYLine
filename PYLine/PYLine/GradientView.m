//
//  GradientView.m
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "GradientView.h"

@interface GradientView()
@property (nonatomic, strong) GradientColorView  *gradientView;
@property (nonatomic, strong) CAShapeLayer       *areaLayer;
@property (nonatomic, strong) CAShapeLayer       *lineLayer;
@property (nonatomic, strong) UIView             *circleView;

@end

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color {
    
    if (self = [super initWithFrame:frame]) {
        
        {
            self.color = color;
            
            GradientColorView *gradientColorView = [[GradientColorView alloc] initWithFrame:self.bounds];
            gradientColorView.endPoint           = CGPointMake(0, 1);
            gradientColorView.colors             = @[(__bridge id)self.color.CGColor,
                                                     (__bridge id)[@"ffffff" hexColor].CGColor];
            gradientColorView.locations          = @[@(0), @(1)];
            gradientColorView.alpha              = 0.35f;
            [gradientColorView becomeEffective];
            [self addSubview:gradientColorView];
            
            self.gradientView = gradientColorView;
        }
        
        
        {
            CAShapeLayer *shapelayer     = [CAShapeLayer layer];
            shapelayer.frame             = self.bounds;
            
            self.areaLayer       = shapelayer;
            self.gradientView.layer.mask = shapelayer;
        }
        
        
        {
            CAShapeLayer *shapelayer = [CAShapeLayer layer];
            shapelayer.frame         = self.bounds;
            shapelayer.fillColor     = [UIColor clearColor].CGColor;
            shapelayer.strokeColor   = self.color.CGColor;
            shapelayer.lineWidth     = 0.5f;
            [self.layer addSublayer:shapelayer];
            
            self.lineLayer = shapelayer;
        }
        
        {
            UIView *blueCircleView            = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
            blueCircleView.backgroundColor    = [UIColor blueColor];
            blueCircleView.layer.cornerRadius = 2.f;
            self.circleView               = blueCircleView;
            [self addSubview:blueCircleView];
        }
        
        
        self.circleView.hidden  = YES;
    }
    
    return self;
}
- (void)drawContent {
    
    self.areaLayer.path = self.areaPath.CGPath;
}

@end
