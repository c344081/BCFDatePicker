//
//  PopoverMenuFromSheet.m
//  PopoverMenuDemo
//
//  Created by chenhao on 15/12/14.
//  Copyright © 2015年 chenhao. All rights reserved.
//

#import "PopoverMenuFromSheet.h"

#define kDefaultAlpha 0.2

CGFloat const POP_MENU_AUTO_HEIGHT = -1000.0187f;

//////////////////////////////////////
/////        frame改变的通知        ////
//////////////////////////////////////
NSString * const PopoverMenuWillChangeFrameNotification = @"PopoverMenuWillChangeFrameNotification";
NSString * const PopoverMenuFrameBeginUserInfoKey = @"beginFrame";
NSString * const PopoverMenuFrameEndUserInfoKey = @"endFrame";

#define KEYWINDOW [[UIApplication sharedApplication].delegate window]

@interface PopoverMenuFromSheet ()
/** 菜单容器视图*/
@property(nonatomic, weak, readwrite) UIView *contentView;
/** 是否自适应contentView高度*/
@property (nonatomic, assign) BOOL shouldAdaptContentHeight;
/** y值约束 */
@property (nonatomic, strong) NSLayoutConstraint *topConstraint;
@end

@implementation PopoverMenuFromSheet

+ (instancetype)menu {
    return [[self.class alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kDefaultAlpha];
        
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
        contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - 显示菜单
- (void)show {
    [self showInView:KEYWINDOW height:POP_MENU_AUTO_HEIGHT];
}

- (void)showInView:(UIView *)view {
    [self showInView:view height:POP_MENU_AUTO_HEIGHT];
}

#pragma mark - 显示菜单,指定高度

/**
 *  显示菜单,需要手动指定整体frame,忽略底部被遮挡的情况
 *
 *  @param view 添加到的视图
 *  @param height 菜单高度
 */
- (void)showInView:(UIView *)view height:(CGFloat)height {
    [view addSubview:self];
    self.frame = view.bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    // 开始设置约束
    [self removeConstraints:self.constraints];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
    [constraints addObject:[self.contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor]];
    [constraints addObject:[self.contentView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]];
    
    self.topConstraint = [self.contentView.topAnchor constraintEqualToAnchor:self.bottomAnchor];
    [constraints addObject:self.topConstraint];
    
    BOOL useAutoHeight = height == POP_MENU_AUTO_HEIGHT;
    if (!useAutoHeight) { // 使用指定高度
        [constraints addObject:[self.contentView.heightAnchor constraintEqualToConstant:height]];
    }
    [NSLayoutConstraint activateConstraints:constraints];
    
    [self layoutIfNeeded];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = CGRectGetHeight(view.frame) - CGRectGetHeight(self.contentView.frame);
    // 发送改变frame的通知
    [self sendNote:frame];
    
    self.topConstraint.constant = -CGRectGetHeight(self.contentView.frame);
    
    // 开始显示
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:kDefaultAlpha];
    } completion:^(BOOL finished) {
        [self onShowFinished];
        if ([self.delegate respondsToSelector:@selector(popoverMenuDidHide:)]) {
            [self.delegate popoverMenuDidShow:self];
        }
    }];
}

- (void)onShowFinished { }

/**
 *  发送改变Frame的通知
 *
 *  @param frame 改变后的frame
 */
- (void)sendNote:(CGRect)frame {
    // 发送改变frame的通知
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[PopoverMenuFrameBeginUserInfoKey] = [NSValue valueWithCGRect:_contentView.frame];
    dict[PopoverMenuFrameEndUserInfoKey] = [NSValue valueWithCGRect:frame];
    [[NSNotificationCenter defaultCenter] postNotificationName:PopoverMenuWillChangeFrameNotification object:nil userInfo:dict];
}

- (void)hide {
    CGRect frame = _contentView.frame;
    frame.origin.y = CGRectGetHeight(self.superview.frame);
    // 发送改变frame的通知
    [self sendNote:frame];
    
    self.topConstraint.constant = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.hidden = YES;
        
        if ([self.delegate respondsToSelector:@selector(popoverMenuDidHide:)]) {
            [self.delegate popoverMenuDidHide:self];
        }
    }];
}

- (BOOL)isInVisibleRect:(CGPoint)point {
    CGFloat contentHeight = CGRectGetHeight(self.contentView.frame);
    CGRect rect = CGRectMake(0, CGRectGetHeight(self.frame) - contentHeight, CGRectGetWidth(self.frame), contentHeight);
    return CGRectContainsPoint(rect, point);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];
    CGPoint covertedP = [_contentView convertPoint:currentP fromView:self];
    if (![_contentView pointInside:covertedP withEvent:event]) { // 不在菜单视图内,即点击屏幕
        [self hide];
    }
}

@end
