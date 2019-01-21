//
//  GYDatePickerVIew.h
//  BCFDatePickerDemo
//
//  Created by chenhao on 2019/1/21.
//  Copyright © 2019 wuhangongyou. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 日期选择模式
 */
typedef NS_ENUM(NSUInteger, GYDatePickerMode) {
    GYDatePickerModeTime,
    /**
     选择日期, 年月日
     */
    GYDatePickerModeDate,
    GYDatePickerModeDateAndTime,
    GYDatePickerModeCountDownTimer,
    
    /**
     选择日期, 且仅显示年月
     */
    GYDatePickerModeDateYM          = 12,
    /**
     选择日期, 且仅显示年
     */
    GYDatePickerModeDateY           = 13,
};


@interface BCFDatePickerView : UIView

@property (nonatomic) GYDatePickerMode datePickerMode;
/** 当前日期, 请务必用getter方法获取*/
@property (nonatomic, strong) NSDate *date;
@property (nullable, nonatomic, strong) NSDate *minimumDate;
@property (nullable, nonatomic, strong) NSDate *maximumDate;

@property (nonatomic) NSTimeInterval countDownDuration;
@property (nonatomic) NSInteger      minuteInterval;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
