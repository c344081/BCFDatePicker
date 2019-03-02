//
//  CHDatePickerMenu.h
//  BCFDatePickerDemo
//
//  Created by chenhao on 2018/11/12.
//  Copyright © 2018 chenhao. All rights reserved.
//

#import "PopoverMenuFromSheet.h"
#import "CHDatePickerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CHDatePickerCancelHandler)(void);
typedef void(^CHDatePickerConfirmHandler)(NSDate *date);


@interface CHDatePickerMenu : PopoverMenuFromSheet

+ (instancetype)menuWithCancelHandler:(nullable CHDatePickerCancelHandler)onCancel
                         onSelectDate:(nullable CHDatePickerConfirmHandler)onSelectDate;

+ (instancetype)menuWithSelectDateBlock:(nullable CHDatePickerConfirmHandler)onSelectDate;

+ (instancetype)menuWithMode:(CHDatePickerMode)mode onSelectDate:(nullable CHDatePickerConfirmHandler)onSelectDate;

/** 日期选择器, 方便修改日期选择模式 */
@property (nonatomic, strong, readonly) CHDatePickerView *datePickerView;

/** 日期选择模式*/
@property (nonatomic, assign) CHDatePickerMode datePickerMode;

/** 选择时间后调用*/
@property(nullable, nonatomic, copy) CHDatePickerConfirmHandler onSelectDate;
/** 取消选择*/
@property(nullable, nonatomic, copy) CHDatePickerCancelHandler onCancel;

@end

NS_ASSUME_NONNULL_END
