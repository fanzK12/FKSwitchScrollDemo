//
//  FKNextVC.m
//  FKSwitchDemo
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "FKNextVC.h"

@interface FKNextVC ()

@end

@implementation FKNextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x35a8fc);
    self.view.backgroundColor =  [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    self.title = @"NextVC";


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
