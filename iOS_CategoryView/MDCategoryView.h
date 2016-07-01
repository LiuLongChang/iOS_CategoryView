//
//  MDCategoryView.h
//  iOS_CategoryView
//
//  Created by langyue on 16/7/1.
//  Copyright © 2016年 langyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDCategoryView : UIView




/*
 *点击展开 编辑栏目 View的 Btn
 */
@property(nonatomic,strong)UIButton* openButton;
/*
 *向外部传出去 点击的信息 点击了第几个 index从1开始
 */
@property(nonatomic,copy)void(^clickIndex)(NSUInteger index);
/*
 *根据title去加载Button
 */
-(void)loadBtn_Title:(NSString*)title;
/*
 *初始化 加载完Button之后 去做相应的设置
 */
-(void)loadBtnEnd;
/*
 *尽可能使 相应的分类 标签 显示到最中间 ， index从1开始
 */
-(void)scrollToCategory_Index:(NSUInteger)index;
/*
 *列表 scrollView滑动时 调用
 */
-(void)mainScrollViewDidScroll:(UIScrollView*)scrollView;
/*
 *index 从 1开始，通过代码让该button 执行点击方法
 */
-(void)clickBtnOfIndex:(NSUInteger)index;
/*
 *根据index (从1 开始) 删除对应的Button
 */
-(void)deleteBtnOfIndex:(NSUInteger)index;



@end
