//
//  LineData.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineData : NSObject

@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSNumber *value;
@property(nonatomic)        BOOL      isRaise;
@property(nonatomic,strong) id       data;

@end
