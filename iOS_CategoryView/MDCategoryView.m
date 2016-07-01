//
//  MDCategoryView.m
//  iOS_CategoryView
//
//  Created by langyue on 16/7/1.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import "MDCategoryView.h"
#define RGB_MD(r,g,b) [UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:1.0]



@interface MDCategoryView()

/*
 *记录 选中Button
 */
@property(nonatomic,strong)UIButton *selectButton;


@end


@implementation MDCategoryView
{
//    水平的X 坐标
    CGFloat _horX;
    UIScrollView *_scrollView;
//分类Button数组
    NSMutableArray *_categoryButtonsArray;
//    圆点 View
    UIView *_circleDotView;
//    button 水平方向 的间距
    CGFloat _horSpacingOfButtons;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        //buttons水平间距
        _horSpacingOfButtons = 20.f;
        //初始化
        _categoryButtonsArray = [[NSMutableArray alloc] init];

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-50, self.frame.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        //去掉水平滑动条
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];


        self.openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.openButton.frame = CGRectMake(_scrollView.frame.size.width, 0, self.frame.size.width - _scrollView.frame.size.width, self.frame.size.height);
//        正常 图片
        [self.openButton setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
        [self addSubview:self.openButton];

        //竖直方向的分割线
        UIImageView * vLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width - 1, 0, 2, self.frame.size.height)];
        [vLineImageView setImage:[UIImage imageNamed:@"vLine.png"]];
        [self addSubview:vLineImageView];



        _circleDotView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 5, 5)];
        _circleDotView.backgroundColor = RGB_MD(17.0, 129.0, 1.0);
        //圆角
        _circleDotView.layer.cornerRadius = 2.5f;
        _circleDotView.layer.masksToBounds = YES;
        [_scrollView addSubview:_circleDotView];

    }
    return self;
}

/*
*根据title去加载Button
*/
-(void)loadBtn_Title:(NSString*)title{

    UIFont * font = [UIFont systemFontOfSize:17.];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(1000, self.frame.size.height) options:0 attributes:@{NSFontAttributeName:font} context:NULL];
    // button 的宽度
    CGFloat buttonWidth = rect.size.width;

    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (_horX == 0) {
        _horX += 15;
    }else{
        _horX += _horSpacingOfButtons;
    }
    //Frame
    [button setFrame:CGRectMake(_horX, 0, buttonWidth, self.frame.size.height)];
    //title
    [button setTitle:title forState:UIControlStateNormal];
    //Font
    [button.titleLabel setFont:font];
    //titleColor
    [button setTitleColor:RGB_MD(153, 153, 153) forState:UIControlStateNormal];
    //选中状态的 字体颜色
    [button setTitleColor:RGB_MD(51., 153., 51.) forState:UIControlStateSelected];

    [button addTarget:self action:@selector(clickCategoryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    //数组记录 Button
    [_categoryButtonsArray addObject:button];
    //记录 水平方向 最后 的坐标
    _horX += buttonWidth;

}
/*
 *初始化 加载完Button之后 去做相应的设置
 */
-(void)loadBtnEnd{

    //scrollView 的显示范围
    [_scrollView setContentSize:CGSizeMake(_horX + 15, _scrollView.frame.size.height)];
    //默认 选中第一个
    self.selectButton = _categoryButtonsArray[0];

}
/*
 *尽可能使 相应的分类 标签 显示到最中间 ， index从1开始
 */
-(void)scrollToCategory_Index:(NSUInteger)index{

    //数组 没有越界
    if (_categoryButtonsArray.count > index - 1) {
        UIButton * button = [_categoryButtonsArray objectAtIndex:index-1];
        //设置 选中Button
        self.selectButton = button;

        CGFloat contentOffsetX = button.center.x -_scrollView.frame.size.width / 2.;
        if (contentOffsetX < 0) {
            contentOffsetX = 0.f;
        }else if (contentOffsetX > _scrollView.contentSize.width -_scrollView.frame.size.width){
        }
        [_scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:true];

    }else{
        NSLog(@"%s in %@,数组越界index=:%lu",__PRETTY_FUNCTION__,[self class],index-1)
    }


}
/*
 *列表 scrollView滑动时 调用
 */
-(void)mainScrollViewDidScroll:(UIScrollView*)scrollView{

    if (scrollView.contentOffset.x < 0 || scrollView.contentOffset.x > scrollView.contentSize.width - scrollView.frame.size.width) {
        return;
    }
    NSLog(@"滑动的偏移量:%f",scrollView.contentOffset.x);

    NSUInteger index = (NSUInteger)scrollView.contentOffset.x / (NSUInteger)scrollView.frame.size.width;
    CGFloat contentOffsetWidth = scrollView.contentOffset.x - scrollView.frame.size.width * index;
    CGFloat scale = contentOffsetWidth / scrollView.frame.size.width;
    NSLog(@"contentOffsetWidth====:%f",contentOffsetWidth);
    NSLog(@"比例====:%f",scale);
//    scale * Button的间距 == 是 圆点View 在左边最近一个Button中心点偏移的距离

    if (_categoryButtonsArray.count > index +1) {

        //圆点 左边Button
        UIButton *leftButton = _categoryButtonsArray[index];
        //圆点 右边Button
        UIButton *rightButton = _categoryButtonsArray[index + 1];
        //两个Button 中心点 间的距离
        CGFloat horSpacing = rightButton.center.x - leftButton.center.x;
        //中心点 偏移的距离
        CGFloat offsetOfCircleDotView = horSpacing *scale;
        //设置 圆点 的 位置
        _circleDotView.center = CGPointMake(leftButton.center.x + offsetOfCircleDotView, _circleDotView.center.y);


    }

}
/*
 *index 从 1开始，通过代码让该button 执行点击方法
 */
-(void)clickBtnOfIndex:(NSUInteger)index{



}
/*
 *根据index (从1 开始) 删除对应的Button
 */
-(void)deleteBtnOfIndex:(NSUInteger)index{




}



@end
