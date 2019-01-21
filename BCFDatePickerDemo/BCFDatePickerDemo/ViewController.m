//
//  ViewController.m
//  BCFDatePickerDemo
//
//  Created by chenhao on 2019/1/21.
//  Copyright © 2019 c344081. All rights reserved.
//

#import "ViewController.h"
#import "BCFDatePickerMenu.h"

@interface ViewController ()

@property (nonatomic, weak) UILabel *selectedDateLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *selectedDateLabel = [[UILabel alloc] init];
    [self.view addSubview:selectedDateLabel];
    self.selectedDateLabel = selectedDateLabel;
    selectedDateLabel.textColor = UIColor.blackColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"显示日期选择器" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [button.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    
    selectedDateLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [selectedDateLabel.bottomAnchor constraintEqualToAnchor:button.topAnchor constant:-15].active = YES;
    [selectedDateLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
}

#pragma mark - action

- (void)showDatePicker:(id)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    __auto_type datePicker = [BCFDatePickerMenu menuWithMode:GYDatePickerModeDateYM onSelectDate:^(NSDate * _Nonnull date) {
        self.selectedDateLabel.text = [formatter stringFromDate:date];
    }];
    
    datePicker.datePickerView.maximumDate = NSDate.date;
    
    [datePicker show];
}


@end
