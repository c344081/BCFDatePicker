//
//  GYDatePickerMenu.h
//  BCFDatePickerDemo
//
//  Created by chenhao on 2018/11/12.
//  Copyright © 2018 chenhao. All rights reserved.
//

#import "PopoverMenuFromSheet.h"
#import "BCFDatePickerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GYDatePickerCancelHandler)(void);
typedef void(^GYDatePickerConfirmHandler)(NSDate *date);


@interface BCFDatePickerMenu : PopoverMenuFromSheet

+ (instancetype)menuWithCancelHandler:(nullable GYDatePickerCancelHandler)onCancel
                         onSelectDate:(nullable GYDatePickerConfirmHandler)onSelectDate;

+ (instancetype)menuWithSelectDateBlock:(nullable GYDatePickerConfirmHandler)onSelectDate;

+ (instancetype)menuWithMode:(GYDatePickerMode)mode onSelectDate:(nullable GYDatePickerConfirmHandler)onSelectDate;

/** 日期选择器, 方便修改日期选择模式 */
@property (nonatomic, strong, readonly) BCFDatePickerView *datePickerView;

/** 日期选择模式*/
@property (nonatomic, assign) GYDatePickerMode datePickerMode;

/** 选择时间后调用*/
@property(nullable, nonatomic, copy) GYDatePickerConfirmHandler onSelectDate;
/** 取消选择*/
@property(nullable, nonatomic, copy) GYDatePickerCancelHandler onCancel;

@end

NS_ASSUME_NONNULL_END
