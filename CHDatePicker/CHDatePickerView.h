//
//  CHDatePickerView.h
//  CHDatePickerDemo
//
//  Created by chenhao on 2019/1/21.
//  Copyright © 2019 c344081. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 日期选择模式
 */
typedef NS_ENUM(NSUInteger, CHDatePickerMode) {
    CHDatePickerModeTime,
    /**
     选择日期, 年月日
     */
    CHDatePickerModeDate,
    CHDatePickerModeDateAndTime,
    CHDatePickerModeCountDownTimer,
    
    /**
     选择日期, 且仅显示年月
     */
    CHDatePickerModeDateYM          = 12,
    /**
     选择日期, 且仅显示年
     */
    CHDatePickerModeDateY           = 13,
};


@interface CHDatePickerView : UIView

@property (nonatomic) CHDatePickerMode datePickerMode;
/** 当前日期, 请务必用getter方法获取*/
@property (nonatomic, strong) NSDate *date;
@property (nullable, nonatomic, strong) NSDate *minimumDate;
@property (nullable, nonatomic, strong) NSDate *maximumDate;

@property (nonatomic) NSTimeInterval countDownDuration;
@property (nonatomic) NSInteger      minuteInterval;

- (void)setDate:(NSDate *)date animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
