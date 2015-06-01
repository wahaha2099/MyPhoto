//
//  PhotoScrollView.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoScrollView.h"
#import "UIImageView+SD.h"
#import "DataMagic.h"

@interface PhotoScrollView()<UIScrollViewDelegate>

@end

@implementation PhotoScrollView


int last_idx;       //最后的图片的index
int layout_count;     //layoutSubviews处理了的长度


ViewController * controller;
//初始化scrollview
-(void)initScrollView:(ViewController* )cont{
    [self setScrollEnabled:YES];
    [self setCanCancelContentTouches:YES];
    self.delaysContentTouches = NO;
    CGRect myFrame = [[UIScreen mainScreen] bounds];
    [ self setContentSize:myFrame.size];
    self.showsHorizontalScrollIndicator=NO;
    self.showsVerticalScrollIndicator=NO;
    self.delegate =self;
    [self performSelectorInBackground:@selector(loadWebData) withObject:nil];
    
    controller = cont;
}

//请求远程图片
-(void)loadWebData{
    //添加远程数据
    [[DataMagic Instance]requestPic];
}

//add subview 后,UIView调用此方法进行布局管理
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //int finish_idx = layout_count;
    //if(layout_count == last_idx)return;//只有新加入的subview才需要进行布局修改
    //layout_count = last_idx;
    
    CGRect myFrame = [[UIScreen mainScreen] bounds];

    NSUInteger maxCol = 3;
    NSUInteger maxRow = 3;
    
    CGFloat width = myFrame.size.width / maxRow;
    CGFloat height = myFrame.size.height / maxCol;
    /*
//    for(int idx = finish_idx ; idx < last_idx ; idx++){
      for(int idx = 0 ; idx <  [self.subviews count] ; idx++){
   
        UIView * subView = [self.subviews objectAtIndex:idx];
        int imgIndex =  (int) subView.tag % [self.subviews count];
          
        //NSLog(@"subview %@ " , subView);
        NSUInteger row = imgIndex % maxRow;
        
        NSUInteger col = imgIndex / maxCol;
        
        CGFloat x = width * row;
        
        CGFloat y = height * col;
        
        //NSLog(@"i , x , y = %ld ,%f , %f " , idx , x , y  );
        
        CGRect frame = CGRectMake(x, y, width, height);
        
        subView.frame = frame;
        
        //添加手势
        [subView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
        [subView setHidden:NO];
    }
    */
    //设置content size
    int newHeight = height * ([self.subviews count] / maxCol );
    if( newHeight > myFrame.size.height ){
        if([self.subviews count] % maxCol > 0){//不足3条多一行
            newHeight += height;
        }
    }
    newHeight = newHeight + height / 2 ;//默认加大一点,避免拖拉不生效
    self.contentSize =  CGSizeMake(myFrame.size.width , newHeight);
}

-(void)layoutImageView:(UIImageView*)view pin:(Pin*)pin{
    CGRect myFrame = [[UIScreen mainScreen] bounds];
    
    NSUInteger maxCol = 3;
    NSUInteger maxRow = 3;
    
    CGFloat width = myFrame.size.width / maxRow;
    CGFloat height = myFrame.size.height / maxCol;
    
    //    for(int idx = finish_idx ; idx < last_idx ; idx++){
    UIImageView * subView = view;
    
    int imgIndex =  (int) (subView.tag);
    
    if(imgIndex > [self.subviews count])
        imgIndex = (int)(subView.tag - [self.subviews count]);
        
    //NSLog(@"subview %@ " , subView);
    NSUInteger row = imgIndex % maxRow;
    
    NSUInteger col = imgIndex / maxCol;
        
    CGFloat x = width * row;
        
    CGFloat y = height * col;
        
    //NSLog(@"i , x , y = %ld ,%f , %f " , idx , x , y  );
        
    CGRect frame = CGRectMake(x, y, width, height);
        
    subView.frame = frame;
        
    //添加手势
    [subView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
    [subView setHidden:NO];
}

-(void)setImages:(NSArray *)images{
    
    _images = images;
    
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        
        //开启事件
        imageV.userInteractionEnabled = YES;
        
        //模式
        imageV.contentMode=UIViewContentModeScaleAspectFill;
        
        imageV.clipsToBounds = YES;
        
        //添加手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)];
        singleTap.numberOfTapsRequired = 1;
        [imageV addGestureRecognizer:singleTap];
        
        singleTap.enabled = YES;
        [singleTap setCancelsTouchesInView:NO];
        
        [imageV setClipsToBounds:YES];
        [imageV setUserInteractionEnabled:YES];
        //设置tag
        imageV.tag = idx;
        
        
        last_idx++;
        [self addSubview:imageV];
    }];
}

-(void)touchImage:(UITapGestureRecognizer *)tap{
    if([tap.view isKindOfClass:[UIImageView class]]){
        UIImageView * view = (UIImageView*)tap.view;
        if(_ClickImageBlock != nil) _ClickImageBlock(view.tag);
    }else{
        NSLog(@"touch img %@" , tap.view);
    }
}


-(void)showImages:(Pin *)pin {
    
    UIImageView * imageV = [[UIImageView alloc]init];
    
    if( pin.is_local ){//9张默认的本地图片
        imageV.image = pin.image;
    }else{//其他网络图片
        UIImage *placehold = [UIImage phImageWithSize:[UIScreen mainScreen].bounds.size zoom:.3f];
        pin.placehold = placehold;
        imageV.image = pin.placehold;
        [imageV imageWithUrlStr: pin.url_320 phImage:pin.placehold];
    }
    
    //开启事件
    imageV.userInteractionEnabled = YES;
    
    //模式
    imageV.contentMode=UIViewContentModeScaleAspectFill;
    
    imageV.clipsToBounds = YES;
    
    //添加手势
    //[imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
    
    [imageV setUserInteractionEnabled:YES];
    //设置tag
    imageV.tag = pin.idx ;//(last_idx++);
    
    last_idx = (int)pin.idx ;
    
    //默认隐藏
    [imageV setHidden:YES];
    [self addSubview:imageV];
    
    [self layoutImageView:imageV pin:pin];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //UIView *view = [touch view];
    //NSLog(@"is hit %@" , view);
    return YES;
}

int page_num = 9;//页数

//往上拉,删除最新的数据
-(void)removeNewest:(int)page{
    NSLog(@"remove page >%i" , page);

    //int start = page *num;
    int end = (int)[self.subviews count];
    for(int iCnt = end; iCnt > end; iCnt--) {
        UIView *viewLiberar = [self.subviews objectAtIndex:iCnt];
        if ([viewLiberar isKindOfClass:UIImageView.class]) {
            [viewLiberar removeFromSuperview];
            viewLiberar = nil;
        }
    }
}

//往下拉,删除上面的数据
-(void)removePrevious:(int)page{
    for (int i = 0 ; i< page ; i++) {
        [self removePage:i];
    }
}

//往下拉,删除上面的数据
-(void)removePage:(int)page{
    NSLog(@"remove previous %i" , page);
    int start = page * page_num;
    int end = start + page_num;
    for(int iCnt = start; iCnt < end; iCnt++) {
        if([self.subviews count] <= iCnt)break;
        
        UIView *viewLiberar = [self.subviews objectAtIndex:iCnt];
        if ([viewLiberar isKindOfClass:UIImageView.class]) {
            [viewLiberar removeFromSuperview];
            viewLiberar = nil;
        }
    }
}

//滑到最后,读取其他界面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if(distanceFromBottom <= height){
        if([[DataMagic Instance] isFinishShow]){
            [self loadNextWebData];
        }
    }
    
    [self scrollViewDidScroll_end:scrollView];
}

//查询远程数据
-(void)loadNextWebData{
    if([[DataMagic Instance] isFinishShow]){
        //if((pageOnScrollView+1) * 9 >= [_pins count])//每页数据需要请求
        [[DataMagic Instance] requestPic];
    }
}

//第几页显示
int pageOnScrollView = -1;
- (void)scrollViewDidScroll_end:(UIScrollView *)scrollView
{
    UIScrollView * scroll = scrollView;
    CGPoint scrollOffset=scrollView.contentOffset;
    int pagAtual = scrollOffset.y/scroll.frame.size.height;
    
    if(pagAtual == pageOnScrollView) return ;
    
    if(pageOnScrollView < ((int)scrollOffset.y/scroll.frame.size.height))
    {
        if(pagAtual - 2 > -1 ){
            [self removePrevious:pagAtual - 2];
        }
        
        //load the next page
        [self loadNextPage:(pagAtual)];
        [self loadNextPage:(pagAtual + 1)];
    }
    else if(pageOnScrollView > ((int)scrollOffset.y/scroll.frame.size.height))
    {
        [self removeNewest:pagAtual + 3 ];
        
        for (int i = 0 ; i< pagAtual; i++) {
            [self loadNextPage:i];
        }
    }
    
    pageOnScrollView=scrollOffset.y/scroll.frame.size.height;
}

-(void)loadNextPage:(int)page{
    NSLog(@"loading page %i" , page);
    //if(page == 0 )return ;
    int num = 9;//每页显示9条

    for (int i =page *num;( page+1) * num; i++) {
        if([controller.pins count] <= i){
            break;
        }
        Pin * pin = [controller.pins objectAtIndex:i];
        [self showImages:pin];
    }
}

@end
