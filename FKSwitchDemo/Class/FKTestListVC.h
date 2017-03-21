//
//  FKTestListVC.h
//  FKSwitchDemo
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FKTestListVCDelegate <NSObject>

- (void)fk_testListTableViewDidClickAt:(NSIndexPath *) indexPath;

@end

@interface FKTestListVC : UIViewController

@property (nonatomic, weak) id<FKTestListVCDelegate>delegate;

@end
