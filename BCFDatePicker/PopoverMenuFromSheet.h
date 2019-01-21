//
//  PopoverMenuFromSheet.h
//  PopoverMenuDemo
//
//  Created by chenhao on 15/12/14.
//  Copyright © 2015年 chenhao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PopoverMenuFromSheet;

UIKIT_EXTERN CGFloat const POP_MENU_AUTO_HEIGHT;

@protocol PopoverMenuFromSheetDelegate <NSObject>

/**
 弹出菜单隐藏时调用

 @param menu 菜单
 */
- (void)popoverMenuDidHide:(PopoverMenuFromSheet *)menu;

/**
 弹出菜单显示后调用
 
 @param menu 菜单
 */
- (void)popoverMenuDidShow:(PopoverMenuFromSheet *)menu;

@end

@interface PopoverMenuFromSheet : UIView

/**
 初始化
 */
+ (instancetype)menu;

/**
 显示菜单, 根据内容自适应
 
 @note 注意, contentView需要其子视图正确设置y轴约束, 
 即能够从顶部到底部完整确定其高度
 */
- (void)show;

/**
 *  在某个视图上添加弹出菜单, 根据内容自适应
 *
 *  @note 需要自动高度请指定高度为`POP_MENU_AUTO_HEIGHT`
 *
 *  @param view 添加到的视图
 */
- (void)showInView:(UIView *)view;

/**
 *  在某个视图上添加弹出菜单
 *
 *  @note 需要自动高度请指定高度为`POP_MENU_AUTO_HEIGHT`
 *
 *  @param view 添加到的视图
 *  @param height 弹出菜单整体高度
 */
- (void)showInView:(UIView *)view height:(CGFloat)height;

/**
 隐藏菜单
 */
- (void)hide;

/**
 *  是否在内容区域内(包含标题条)
 *
 *  @param point 转换到屏幕坐标系的点
 */
- (BOOL)isInVisibleRect:(CGPoint)point;

/** 代理*/
@property(nonatomic, weak) id<PopoverMenuFromSheetDelegate> delegate;
/** 菜单容器视图*/
@property(nonatomic, weak, readonly) UIView *contentView;

/**
 显示动画完成后调用
 */
- (void)onShowFinished;

@end

//////////////////////////////////////
/////        frame改变的通知        ////
//////////////////////////////////////

UIKIT_EXTERN NSString * const PopoverMenuWillChangeFrameNotification;
UIKIT_EXTERN NSString * const PopoverMenuFrameBeginUserInfoKey;
UIKIT_EXTERN NSString * const PopoverMenuFrameEndUserInfoKey;



