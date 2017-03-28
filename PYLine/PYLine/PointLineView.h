//
//  PointLineView.h
//  PYLine
//
//  Created by zpy-pc on 17/3/28.
//  Copyright © 2017年 puyang. All rights reserved.
//

#import "BaseBottomView.h"
typedef enum : NSUInteger {
    PointLineViewGroupByDate,       //按日期分类
    PointLineViewGroupByTime,       //按时间分类
} PointLineViewGroupType;

@interface PointLineView : BaseBottomView

/**一组里有多少数据*/
@property(nonatomic)    int   numberOfGroup;
/**X坐标一组里的数据 即时间标签数组*/
@property(nonatomic,strong) NSArray *groupDataArray;
/**x坐标分组类型 即横坐标是日期 还是时间*/
@property(nonatomic)    PointLineViewGroupType  groupType;
/**一页最大数量*/
@property(nonatomic)    int         xMaxCount;

- (id)initWithFrame:(CGRect)frame xCount:(int)x yCount:(int)y;

@end
