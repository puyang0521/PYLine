//
//  LongPressDataDelegate.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LongPressDataDelegate <NSObject>

@optional
/**
 *  通知更新
 *
 *  @param data 传参  可为nil
 */
-(void)notifyDataChange:(id)data withView:(UIView*)view;

@end
