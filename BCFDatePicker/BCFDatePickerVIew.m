//
//  GYDatePickerVIew.m
//  BCFDatePickerDemo
//
//  Created by chenhao on 2019/1/21.
//  Copyright © 2019 wuhangongyou. All rights reserved.
//

#import "BCFDatePickerView.h"

static NSInteger const kYearCount = 10000;
static NSInteger const kMonthCount = 12;
static CGFloat const kRowHeight = 32;

static inline BOOL isCustomPickerView(GYDatePickerMode mode) {
    BOOL isCustom = NO;
    switch (mode) {
        case GYDatePickerModeDateYM:
        case GYDatePickerModeDateY:
            isCustom = YES;
            break;
        default:
            break;
    }
    return isCustom;
}


@interface BCFDatePickerView () <UIPickerViewDataSource, UIPickerViewDelegate>
/** 日期选择器 */
@property (nonatomic, strong) UIDatePicker *datePicker;
/** 自定义的选择器 */
@property (nonatomic, strong) UIPickerView *pickerView;
/** 当前内容视图*/
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) NSDateFormatter *dateFormatterYMD;
@end


@implementation BCFDatePickerView

@synthesize date = _date;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.date = NSDate.date;
        self.minuteInterval = 1;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    if (!date) { return; }
    
    _date = date;
    switch (_datePickerMode) {
        case GYDatePickerModeTime:
        case GYDatePickerModeDate:
        case GYDatePickerModeDateAndTime:
        case GYDatePickerModeCountDownTimer:
            [self.datePicker setDate:date animated:animated];
            break;
        case GYDatePickerModeDateYM: {
            NSInteger year = [self.datePicker.calendar component:NSCalendarUnitYear fromDate:date];
            NSInteger month = [self.datePicker.calendar component:NSCalendarUnitMonth fromDate:date];
            [self.pickerView reloadAllComponents]; // 刷新ui颜色等
            [self.pickerView selectRow:year - 1 inComponent:0 animated:animated];
            [self.pickerView selectRow:month - 1 inComponent:1 animated:animated];
        }
            break;
        case GYDatePickerModeDateY: {
            NSInteger year = [self.datePicker.calendar component:NSCalendarUnitYear fromDate:date];
            [self.pickerView reloadAllComponents]; // 刷新ui颜色等
            [self.pickerView selectRow:year - 1 inComponent:0 animated:animated];
        }
            break;
        default:
            break;
    }
}

- (NSDate *)date {
    if (isCustomPickerView(_datePickerMode)) {
        return _date;
    }
    return self.datePicker.date;
}

- (void)setMinuteInterval:(NSInteger)minuteInterval {
    _minuteInterval = minuteInterval;
    self.datePicker.minuteInterval = minuteInterval;
}

- (void)setCountDownDuration:(NSTimeInterval)countDownDuration {
    _countDownDuration = countDownDuration;
    self.datePicker.countDownDuration = countDownDuration;
}

- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    self.datePicker.minimumDate = minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.datePicker.maximumDate = maximumDate;
}

- (void)setDate:(NSDate *)date {
    [self setDate:date animated:NO];
}

- (void)setDatePickerMode:(GYDatePickerMode)datePickerMode {
     // 获取当前date, UIDatePicker更改日期时不会直接更改`_date`变量
    NSDate *date = self.date;
    _datePickerMode = datePickerMode;
    [_contentView removeFromSuperview];
    BOOL isNowCustom = isCustomPickerView(datePickerMode);
    if (isNowCustom) {
        self.contentView = self.pickerView;
    } else {
        self.contentView = self.datePicker;
        self.datePicker.datePickerMode = (NSInteger)datePickerMode;
    }
    self.date = date;
    [self addSubview:self.contentView];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    NSInteger components = 0;
    switch (_datePickerMode) {
        case GYDatePickerModeDateYM:
            components = 2;
            break;
        case GYDatePickerModeDateY:
            components = 1;
            break;
        default:
            break;
    }
    return components;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger rowCount = 0;
    switch (_datePickerMode) {
        case GYDatePickerModeDateYM:
            if (component == 0) { // year
                rowCount = kYearCount;
            } else if (component == 1) { // month
                rowCount = kMonthCount;
            }
            break;
        case GYDatePickerModeDateY:
            rowCount = kYearCount;
            break;
        default:
            break;
    }
    return rowCount;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:23.5];
        label.textAlignment = NSTextAlignmentCenter;
    }
    NSString *title = nil;
    NSString *yearFormat = @"%ld年";
    NSString *monthFormat = @"%ld月";
    
    BOOL disabled = NO;
    UIColor *textColor = UIColor.blackColor;
    UIColor *grayTextColor = UIColor.lightGrayColor;
    
    // 检查最小和最大值
    NSDate *minimumDate = nil;
    NSDate *maximumDate = nil;
    NSInteger minimumYear = 0;
    NSInteger minimumMonth = 0;
    NSInteger maximumYear = 0;
    NSInteger maximumMonth = 0;
    
    if (self.minimumDate) {
        minimumDate = self.minimumDate;
        minimumYear = [self.datePicker.calendar component:NSCalendarUnitYear fromDate:self.minimumDate];
        minimumMonth = [self.datePicker.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate];
    }
    if (self.maximumDate) {
        maximumDate = self.maximumDate;
        maximumYear = [self.datePicker.calendar component:NSCalendarUnitYear fromDate:self.maximumDate];
        maximumMonth = [self.datePicker.calendar component:NSCalendarUnitMonth fromDate:self.maximumDate];
    }
    
    switch (_datePickerMode) {
        case GYDatePickerModeDateYM: {
            NSString *format = component == 0 ? yearFormat : monthFormat;
            title = [NSString stringWithFormat:format , row + 1];
            
            NSInteger year = (component == 0 ? row : [pickerView selectedRowInComponent:0]) + 1;
            NSInteger month = (component == 1 ? row : [pickerView selectedRowInComponent:1]) + 1;
            
            if (component == 0) {
                disabled = maximumDate && year > maximumYear;
                disabled |= minimumDate && year < minimumYear;
            } else if (component == 1) {
                disabled = maximumDate && year == maximumYear &&  month > maximumMonth;
                disabled |= minimumDate && year == minimumYear && month < minimumMonth;
            }
        }
            break;
        case GYDatePickerModeDateY:
            title = [NSString stringWithFormat:yearFormat, row + 1];
            disabled = maximumDate && row + 1 > maximumYear;
            disabled |= minimumDate && row + 1 < minimumYear;
            break;
        default:
            break;
    }
    
    label.textColor = disabled ? grayTextColor : textColor;
    label.text = title;
    return label;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kRowHeight;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    // 检查最小和最大值
    NSDate *minimumDate = nil;
    NSDate *maximumDate = nil;
    NSInteger minimumYear = 0;
    NSInteger minimumMonth = 0;
    NSInteger maximumYear = 0;
    NSInteger maximumMonth = 0;
    
    if (self.minimumDate) {
        minimumDate = self.minimumDate;
        minimumYear = [self.datePicker.calendar component:NSCalendarUnitYear fromDate:self.minimumDate];
        minimumMonth = [self.datePicker.calendar component:NSCalendarUnitMonth fromDate:self.minimumDate];
    }
    if (self.maximumDate) {
        maximumDate = self.maximumDate;
        maximumYear = [self.datePicker.calendar component:NSCalendarUnitYear fromDate:self.maximumDate];
        maximumMonth = [self.datePicker.calendar component:NSCalendarUnitMonth fromDate:self.maximumDate];
    }
    
    NSDateFormatter *formatter = self.dateFormatterYMD;
    
    switch (_datePickerMode) {
        case GYDatePickerModeDateYM: {
            if (component == 0 || component == 1) {
                NSInteger year = [pickerView selectedRowInComponent:0] + 1;
                NSInteger month = [pickerView selectedRowInComponent:1] + 1;
                NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-1", year, month]];
                if (maximumDate) {
                    if (NSOrderedDescending == [date compare:maximumDate]) {
                        date = maximumDate;
                    }
                }
                if (minimumDate) {
                    if (NSOrderedAscending == [date compare:minimumDate]) {
                        date = minimumDate;
                    }
                }
                [self setDate:date animated:YES];
            }
        }
            break;
        case GYDatePickerModeDateY: {
                NSInteger year = row + 1;
                if (maximumDate && year > maximumYear) {
                    year = maximumYear;
                } else if (minimumDate && year < minimumYear) {
                    year = minimumYear;
                }
                NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%ld-1-1", year]];
                [self setDate:date animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - getter


- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
    }
    return _datePicker;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (NSDateFormatter *)dateFormatterYMD {
    if (!_dateFormatterYMD) {
        _dateFormatterYMD = [[NSDateFormatter alloc] init];
        _dateFormatterYMD.dateFormat = @"yyyy-M-d";
    }
    return _dateFormatterYMD;
}

@end
