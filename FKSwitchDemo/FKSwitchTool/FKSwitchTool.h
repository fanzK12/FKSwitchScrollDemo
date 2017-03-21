//
//  FKSwitchTool.h
//  FKSwitchDemo
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FKSwitchDelegate <NSObject>

@optional
/**
 切换位置
 */
- (void)fk_slideSwitchDidSelectedTab:(NSInteger)index;

/*
 滑动到左边界时调用
 */
- (void)fk_slideSwitchPanLeftEdge:(UIPanGestureRecognizer *)panParam;

/**
 滑动到右边界时调用
 */
- (void)fk_slideSwitchPanRightEdge:(UIPanGestureRecognizer *)panParam;
@end

@interface FKSwitchTool : UIView
/**
 代理
 */
@property (nonatomic, weak) id<FKSwitchDelegate>delegate;
/**
 顶部scroll
 */
@property (nonatomic, strong,readonly) UIScrollView * topScrollView;
/**
 需要显示的viewController集合
 */
@property (nonatomic, strong) NSMutableArray * viewControllers;
/**
 是否隐藏选中效果
 */
@property (assign,nonatomic) BOOL hideShadow;
/**
 当前选中位置
 */
@property (assign,nonatomic) NSInteger selectedIndex;
/**
 按钮正常时的颜色
 */
@property (strong,nonatomic) UIColor *btnNormalColor;
/**
 按钮选中时的颜色
 */
@property (strong,nonatomic) UIColor *btnSelectedColor;
/**
 是否需要自动分配按钮宽度
 */
@property (assign,nonatomic) BOOL adjustBtnSize2Screen;
/**
 显示在某个VC的navbar上
 */
- (void) showInNavBarOf:(UIViewController *)vc;
@end
