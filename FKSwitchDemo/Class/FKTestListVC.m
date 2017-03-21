//
//  FKTestListVC.m
//  FKSwitchDemo
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "FKTestListVC.h"

@interface FKTestListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}


@end

@implementation FKTestListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];

}
-(void)buildUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self buildTable];
}

-(void)buildTable
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _tableView.frame = self.view.bounds;
}

#pragma mark -
#pragma mark TableViewDelegate&DataSource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellIdentifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.title;
    cell.textLabel.textColor = UIColorFromRGB(0x74F1FF);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_delegate respondsToSelector:@selector(fk_testListTableViewDidClickAt:)]){
        [_delegate performSelector:@selector(fk_testListTableViewDidClickAt:) withObject:indexPath];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
