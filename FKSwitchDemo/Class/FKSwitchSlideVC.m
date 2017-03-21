//
//  FKSwitchSlideVC.m
//  FKSwitchDemo
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "FKSwitchSlideVC.h"
#import "FKSwitchTool.h"
#import "FKTestListVC.h"
#import "FKNextVC.h"
@interface FKSwitchSlideVC ()<FKSwitchDelegate,FKTestListVCDelegate>
{
    FKSwitchTool * _slideSwitch;
}
@end

@implementation FKSwitchSlideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x35a8fc);
    self.title = @"FKSwitch";
    [self buildUI];
    
}

-(void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *viewControllers = [NSMutableArray new];
    NSArray *titles = @[@"海贼王",@"龙珠",@"盘龙",@"星辰变",@"完美世界",@"遮天",@"明天",@"阴阳师",@"斩赤魂之瞳",@"葫芦娃",@"火影忍者",@"+++"];
    for (int i = 0 ; i<titles.count; i++) {
        FKTestListVC *vc = [FKTestListVC new];
        vc.title = titles[i];
        vc.delegate = self;
        [viewControllers addObject:vc];
    }
    _slideSwitch = [[FKSwitchTool alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    _slideSwitch.delegate = self;
    _slideSwitch.btnSelectedColor = UIColorFromRGB(0xFF0F34);
    _slideSwitch.btnNormalColor = GrayColor;
    _slideSwitch.viewControllers = viewControllers;
    //显示在viewcontroller的navigationBar上
    //[_slideSwitch showInNavBarOf:self];
    //设置隐藏阴影
    //_slideSwitch.hideShadow = true;

    [self.view addSubview:_slideSwitch];
}

#pragma mark -
#pragma mark FKSwitchDelegate
- (void)fk_slideSwitchDidSelectedTab:(NSInteger)index{
    //可以通过viewWillAppear方法加载数据
    UIViewController * vc = _slideSwitch.viewControllers[index];
    [vc viewWillAppear:YES];
}

- (void)fk_slideSwitchPanLeftEdge:(UIPanGestureRecognizer *)panParam{
    NSLog(@"滑动到左边缘，可以处理滑动返回等一些问题");

}

#pragma mark -
#pragma mark FKTestListDelegate
- (void)fk_testListTableViewDidClickAt:(NSIndexPath *)indexPath{
    FKNextVC *pushVC = [[FKNextVC alloc] init];
    [self.navigationController pushViewController:pushVC animated:true];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
