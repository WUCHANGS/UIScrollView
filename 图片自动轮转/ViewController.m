
//  ViewController.m
//  图片自动轮转
//
//  Created by dc0061 on 15/12/21.
//  Copyright © 2015年 dc0061. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollview;
    UIImageView *_imgae;
    
    //NSTimer时间间隔比较大（几秒）   CADisplayLink时间间隔比较小（0.0几秒）
    NSTimer *_timer;
    UIPageControl *_page;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollview =[[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, 375, 250)];
    _scrollview.delegate=self;
    [self.view addSubview:_scrollview];
    for (int i=1; i<7; i++) {
        _imgae =[[UIImageView alloc]initWithFrame:CGRectMake(375*(i-1), 10, 375*i, 250)];
        _imgae.image=[UIImage imageNamed:[NSString stringWithFormat:@"%i",i]];
        [_scrollview addSubview:_imgae];
    }
    //设置偏移量,不需要竖着偏移,所以不需要设置数据
    _scrollview.contentSize=CGSizeMake(375*6, 0);
    //实现scrollview的分页显示,当允许分页时，scrollview会按照自身宽度作为一页来开始分页
    _scrollview.pagingEnabled=YES;
    //隐藏水平滚动指示器
    _scrollview.showsHorizontalScrollIndicator=NO;
    //添加分页显示点
    _page=[[UIPageControl alloc]initWithFrame:CGRectMake(200, 270, 150, 20)];
    _page.numberOfPages=6;//设置页码的总数
    _page.currentPage=0;//设置当前页，从0开始
    
    _page.currentPageIndicatorTintColor=[UIColor redColor];//设置当前页点的颜色
    _page.pageIndicatorTintColor=[UIColor blueColor];//设置点的颜色
    [self.view addSubview:_page];
    //创建一个计时器
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(jishi) userInfo:nil repeats:YES];
}
//scrollview代理滚动事件
- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    //设置UIPageControl当前位置
    CGFloat x=scrollView.contentOffset.x+375.0/2.0;//当图片滚动一半之后，就修改UIPageControl的值
    _page.currentPage= x/375.0;
}
- (void) jishi{
    NSInteger page=_page.currentPage;//得到pagecontrol的当前页码
    //判断是否是最后一页
    if (page==5) {
        page=0;
    }else{
        page++;
    }
    //设置新的偏移值
    CGFloat offsetX=page*_scrollview.frame.size.width;
    [_scrollview setContentOffset:CGPointMake (offsetX,0) animated:YES];
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //方法一
//    [_timer invalidate];//停止计时器:这个方法停止的计时器，就不可以在重用下次必须创建新的
//    _timer=nil;//上面方法调用后，这个计时器已经废掉了，所有可以直接设置成nil
    //方法二    : 关闭计时器
    [_timer setFireDate:[NSDate distantFuture]];
}
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //方法一
//    _timer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(jishi) userInfo:nil repeats:YES];
    //方法二    : 开启计时器
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
