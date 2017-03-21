//
//  FKSwitchTool.m
//  FKSwitchDemo
//
//  Created by apple on 17/3/21.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "FKSwitchTool.h"

//button间隔
static const CGFloat ButtonMargin = 10.0f;
//button标题正常大小
static const CGFloat ButtonFontNormalSize = 17.0f;
//button标题选中大小
static const CGFloat ButtonFontSelectedSize = 18.0f;
//顶部scrollView高度
static const CGFloat TopScrollViewHeight = 40.0f;

@interface FKSwitchTool ()<UIScrollViewDelegate>
{
    //界面滑动的ScrollView
    UIScrollView * _mainScrollView;
    //阴影效果
    UIImageView * _shadowImgView;
    //按钮与下半部分的分割线
    UIView * _lineView;
    
    //存放按钮
    NSMutableArray * _buttonsArr;
    //存放view
    NSMutableArray * _viewsArr;
    //显示在navbar上
    BOOL _showInNavBar;
}

@end

@implementation FKSwitchTool

#pragma mark -
#pragma mark 初始化方法
- (instancetype)init{
    if(self = [super init]){
        [self setUI];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUI];
    }
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setUI];
    }
    return self;
}

- (void)setUI{
    _buttonsArr = [NSMutableArray new];
    _viewsArr = [NSMutableArray new];
    _selectedIndex = 0;
    
    //防止navigationbar对scrollView的布局产生影响
    [self addSubview:[UIView new]];
    
    //创建顶部scrollView
    _topScrollView = [UIScrollView new];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.backgroundColor = UIColorFromRGB(0xFFEDDD);
    _topScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, TopScrollViewHeight);
    [self addSubview:_topScrollView];
    
    //创建展示视图控制器的scrollView
    _mainScrollView = [UIScrollView new];
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.userInteractionEnabled = YES;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    [_mainScrollView.panGestureRecognizer addTarget:self action:@selector(scrollHandelPan:)];
    [self addSubview:_mainScrollView];
    
    //创建分割线
    _lineView = [UIView new];
    _lineView.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    _lineView.frame = CGRectMake(0, _topScrollView.bounds.size.height, self.bounds.size.width, 0.5);
    [self addSubview:_lineView];
    
    //创建阴影view
    _shadowImgView = [[UIImageView alloc]init];
    _shadowImgView.backgroundColor = _btnSelectedColor;
    [_topScrollView addSubview:_shadowImgView];
}

#pragma mark -
#pragma mark LayoutSubViews
//更新View
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //上半部分
    [self updateButtons];
    
    //更新shadow的位置
    [self updataShadowView];
    
    //分割线
    _lineView.hidden = _showInNavBar;
    //下半部分
    _mainScrollView.frame = CGRectMake(0, TopScrollViewHeight, self.bounds.size.width, self.bounds.size.height - TopScrollViewHeight);
    if (_showInNavBar){
        _mainScrollView.frame = self.bounds;
    }
    _mainScrollView.contentSize = CGSizeMake(self.bounds.size.width * [_viewControllers count], 0);
    
    //分配子view的frame
    for (NSInteger i = 0; i<_viewsArr.count; i++) {
        UIView * view = _viewsArr[i];
        view.frame = CGRectMake(i*_mainScrollView.bounds.size.width, 0, _mainScrollView.bounds.size.width, _mainScrollView.bounds.size.height);
    }
    
}

- (void)updateButtons{
    
    CGFloat btnXOffset = ButtonMargin;
    for (NSInteger i = 0; i<_buttonsArr.count; i++) {
        UIButton * button = _buttonsArr[i];
        CGSize textSize = [self buttonSizeOfTitle:button.currentTitle];
        button.frame = CGRectMake(btnXOffset, 0, textSize.width, _topScrollView.bounds.size.height);
        [button setTitleColor:_btnNormalColor forState:UIControlStateNormal];
        [button setTitleColor:_btnSelectedColor forState:UIControlStateSelected];
        btnXOffset += textSize.width + ButtonMargin;
        if (i == _selectedIndex){
            button.titleLabel.font = [UIFont boldSystemFontOfSize:ButtonFontSelectedSize];
            button.selected = true;
        }
        else{
            button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontNormalSize];
            button.selected = false;
        }
        
    }
    
    //如果需要平分宽度的话，重新设置范围
    if (_adjustBtnSize2Screen){
        for (NSInteger i = 0; i<_buttonsArr.count; i++) {
            UIButton * button = _buttonsArr[i];
            CGFloat margin = 0.1*_topScrollView.bounds.size.width;
            float btnWidth = (_topScrollView.bounds.size.width - 2*margin)/_viewControllers.count;
            [button setFrame:CGRectMake(i*btnWidth + margin, 0, btnWidth, TopScrollViewHeight)];
        }
    }
    
    //更新顶部scrollView的滚动范围
    UIButton * button = _buttonsArr.lastObject;
    _topScrollView.contentSize = CGSizeMake(CGRectGetMaxX(button.frame) + ButtonMargin, 0);
    
}

- (void)updataShadowView{
    //更新阴影的范围
    UIButton * button = _buttonsArr[_selectedIndex];
    _shadowImgView.frame = CGRectMake(button.frame.origin.x, CGRectGetMaxY(button.frame) - 1.5, button.bounds.size.width, 1.5);
    _shadowImgView.center = CGPointMake(button.center.x, _shadowImgView.center.y);
    _shadowImgView.backgroundColor = _btnSelectedColor;
    
    //shadow是否隐藏
    _shadowImgView.hidden = _hideShadow;
}

#pragma mark -
#pragma mark Setter方法
//设置要显示的视图控制器
- (void)setViewControllers:(NSMutableArray *)viewControllers{
    _viewControllers = viewControllers;
    
    //添加子view
    for (NSInteger i = 0; i<viewControllers.count; i++) {
        UIViewController * vc = _viewControllers[i];
        [_mainScrollView addSubview:vc.view];
        [_viewsArr addObject:vc.view];
    }
    
    //添加buttons
    for (NSInteger i = 0; i<[_viewControllers count]; i++) {
        UIViewController * vc = _viewControllers[i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:vc.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontNormalSize];
        [button setTitleColor:self.btnNormalColor forState:UIControlStateNormal];
        [button setTitleColor:self.btnSelectedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonSelectedMethod:) forControlEvents:UIControlEventTouchUpInside];
        [_topScrollView addSubview:button];
        [_buttonsArr addObject:button];
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    //更新frame
    [self updataUIWithSelectedIndex:selectedIndex byButton:true];
}

#pragma mark -
#pragma mark 视图逻辑方法
/**
 更新UI方法 如果是通过button点击造成的话则需要更新MainScrollView范围
 如果通过ScrollView滚动后更新UI则不需要更新MainScrollView的frame
 */
- (void)updataUIWithSelectedIndex:(NSInteger)index byButton:(BOOL)byButton{
    _selectedIndex = index;
    for (UIButton * button in _buttonsArr) {
        if ([_buttonsArr indexOfObject:button] == _selectedIndex){
            button.titleLabel.font = [UIFont boldSystemFontOfSize:ButtonFontSelectedSize];
            button.selected = true;
        }
        else{
            button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontNormalSize];
            button.selected = false;
        }
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        //更新TopScrollView的frame
        [self adjustTopScrollView:_buttonsArr[index]];
        //更新shadow的frame
        [self updataShadowView];
    } completion:^(BOOL finished) {
        
        if([_delegate respondsToSelector:@selector(fk_slideSwitchDidSelectedTab:)]){
            [_delegate fk_slideSwitchDidSelectedTab:index];
        }
        if(byButton){
            //更新主scrollView的范围
            [UIView animateWithDuration:0.3 animations:^{
                [_mainScrollView setContentOffset:CGPointMake(index * self.bounds.size.width, 0)];
            }];
        }
    }];
}

//按钮点击方法
- (void)buttonSelectedMethod:(UIButton *)sender{
    [self updataUIWithSelectedIndex:[_buttonsArr indexOfObject:sender] byButton:true];
}

//选中button显示在屏幕中间适配
- (void)adjustTopScrollView:(UIButton *)sender{
    //如果是自动适配的话就不需要
    if (_adjustBtnSize2Screen == true){return;}
    CGFloat targetX = CGRectGetMidX(sender.frame) - _topScrollView.bounds.size.width/2.0f;
    //左边缘适配
    if (targetX <= 0){
        targetX = 0;
    }
    //右边缘适配
    if (targetX >= _topScrollView.contentSize.width - _topScrollView.bounds.size.width){
        targetX = _topScrollView.contentSize.width - _topScrollView.bounds.size.width;
    }
    [_topScrollView setContentOffset:CGPointMake(targetX, 0)];
}

#pragma mark -
#pragma mark ScrollView delegate 
//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _mainScrollView) {
        NSInteger index = (NSInteger)scrollView.contentOffset.x/self.bounds.size.width;
        [self updataUIWithSelectedIndex:index byButton:false];
    }
}

//滚动到左右边缘的范围
- (void)scrollHandelPan:(UIPanGestureRecognizer *)panParam{
    //当滑到左边界时，传递滑动事件给代理
    if (_mainScrollView.contentOffset.x <= 0){
        if (_delegate && [_delegate respondsToSelector:@selector(fk_slideSwitchPanLeftEdge:)]){
            [_delegate fk_slideSwitchPanLeftEdge:panParam];
        }
    }
    else if (_mainScrollView.contentOffset.x >= _mainScrollView.contentSize.width - _mainScrollView.bounds.size.width){
        if(_delegate && [_delegate respondsToSelector:@selector(fk_slideSwitchPanRightEdge:)]){
            [_delegate fk_slideSwitchPanRightEdge:panParam];
        }
    }
}


#pragma mark -
#pragma mark  附加方法
/**
 按钮宽度
 */
- (CGSize)buttonSizeOfTitle:(NSString *)title{
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary * attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:ButtonFontSelectedSize]};
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(_topScrollView.bounds.size.width, TopScrollViewHeight) options:options attributes:attributes context:nil].size;
    return textSize;
}

#pragma mark -
#pragma mark 功能方法
- (void) showInNavBarOf:(UIViewController *)vc{
    _showInNavBar = true;
    _topScrollView.frame = CGRectMake(0, 0, self.bounds.size.width, TopScrollViewHeight);
    vc.navigationItem.titleView = _topScrollView;
    _topScrollView.backgroundColor = [UIColor clearColor];
}



@end
