//
//  CHDatePickerMenu.m
//  BCFDatePickerDemo
//
//  Created by chenhao on 2018/11/12.
//  Copyright © 2018 chenhao. All rights reserved.
//

#import "CHDatePickerMenu.h"

#define kDatePickerH 172
#define kTitleViewH 44

@interface CHDatePickerMenu ()
/** 标题栏 */
@property (nonatomic, strong) UIToolbar *titleView;
/** 日期选择器 */
@property (nonatomic, strong, readwrite) CHDatePickerView *datePickerView;
@end


@implementation CHDatePickerMenu

+ (instancetype)menuWithCancelHandler:(CHDatePickerCancelHandler)onCancel
                         onSelectDate:(CHDatePickerConfirmHandler)onSelectDate {
    return [self menuWithMode:CHDatePickerModeDate onCancel:onCancel onSelectDate:onSelectDate];
}

+ (instancetype)menuWithSelectDateBlock:(CHDatePickerConfirmHandler)onSelectDate {
    return [self menuWithCancelHandler:nil onSelectDate:onSelectDate];
}

+ (instancetype)menuWithMode:(CHDatePickerMode)mode onSelectDate:(CHDatePickerConfirmHandler)onSelectDate {
    return [self menuWithMode:mode onCancel:nil onSelectDate:onSelectDate];
}

+ (instancetype)menuWithMode:(CHDatePickerMode)mode
                    onCancel:(CHDatePickerCancelHandler)onCancel
                onSelectDate:(CHDatePickerConfirmHandler)onSelectDate {
    CHDatePickerMenu *menu = [self.class menu];
    menu.onSelectDate = onSelectDate;
    menu.onCancel = onCancel;
    menu.datePickerMode = mode;
    return menu;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置默认高度
        [self.contentView addSubview:self.titleView];
        [self.contentView addSubview:self.datePickerView];
        self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
        self.datePickerView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    // 适配底部安全区域
    NSMutableArray *constraints = [NSMutableArray array];
    
    [constraints addObject:[self.titleView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor]];
    [constraints addObject:[self.titleView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor]];
    [constraints addObject:[self.titleView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor]];
    [constraints addObject:[self.titleView.heightAnchor constraintEqualToConstant:kTitleViewH]];

    [constraints addObject:[self.datePickerView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor]];
    [constraints addObject:[self.datePickerView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor]];
    [constraints addObject:[self.datePickerView.topAnchor constraintEqualToAnchor:self.titleView.bottomAnchor]];
    [constraints addObject:[self.datePickerView.heightAnchor constraintEqualToConstant:kDatePickerH]];
    [constraints addObject:[self.datePickerView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor]];
    
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark - action

- (void)cancelAction:(id)sender {
    [self hide];
    !_onCancel ?: _onCancel();
}

- (void)confirmAction:(id)sender {
    [self hide];
    !_onSelectDate ?: _onSelectDate(_datePickerView.date);
}

#pragma mark - setter

- (void)setDatePickerMode:(CHDatePickerMode)datePickerMode {
    _datePickerMode = datePickerMode;
    self.datePickerView.datePickerMode = datePickerMode;
}

#pragma mark - getter

- (UIView *)titleView {
    if (!_titleView) {
        CGFloat screenW = UIScreen.mainScreen.bounds.size.height;
        _titleView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, screenW, kTitleViewH)];
        NSMutableArray *arrayM = [NSMutableArray array];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        item.width = 10;
        [arrayM addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                style:UIBarButtonItemStylePlain
                                               target:self action:@selector(cancelAction:)];
        item.tintColor = UIColor.blackColor;
        [arrayM addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        item.tintColor = UIColor.blackColor;
        [arrayM addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                style:UIBarButtonItemStylePlain
                                               target:self action:@selector(confirmAction:)];
        item.tintColor = UIColor.blackColor;
        [arrayM addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        item.width = 10;
        [arrayM addObject:item];
        
        _titleView.items = arrayM.copy;
    }
    return _titleView;
}

- (CHDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[CHDatePickerView alloc] init];
        _datePickerView.datePickerMode = CHDatePickerModeDate;
    }
    return _datePickerView;
}

@end
