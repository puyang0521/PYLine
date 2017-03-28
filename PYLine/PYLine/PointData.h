//
//  PointData.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointData : NSObject

@property(nonatomic)        CGFloat     x;
@property(nonatomic)        CGFloat     y;
@property(nonatomic,strong) NSNumber    *value;
@property(nonatomic,strong) NSString    *date;
@property(nonatomic,strong) NSString    *time;
@property(nonatomic)        NSInteger   index;

@end
