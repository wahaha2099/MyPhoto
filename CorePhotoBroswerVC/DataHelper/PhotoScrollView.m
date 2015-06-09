//
//  PhotoScrollView.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoScrollView.h"


@interface PhotoScrollView()<UIScrollViewDelegate>

@property (nonatomic) ViewController * controller;

@end

@implementation PhotoScrollView


int last_idx;       //最后的图片的index
int layout_count;     //layoutSubviews处理了的长度



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
    [self performSelectorInBackground:@selector(loadNextWebData) withObject:nil];
    
    cachePage = [[NSMutableSet alloc]init];
    _controller = cont;
}

//add subview 后,UIView调用此方法进行布局管理
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //int finish_idx = layout_count;
    //if(layout_count == last_idx)return;//只有新加入的subview才需要进行布局修改
    //layout_count = last_idx;
    
    CGRect myFrame = [[UIScreen mainScreen] bounds];

    NSUInteger maxCol = 3;
    //NSUInteger maxRow = 3;
    //CGFloat width = myFrame.size.width / maxRow;
    
    CGFloat height = myFrame.size.height / maxCol;
    //设置content size
    //int newHeight = height * ([self.subviews count] / maxCol );
    
    int newHeight = height * (pageOnScrollView + 2) * 4;//页数*4行
    
    if( newHeight > myFrame.size.height ){
        if([self.subviews count] % maxCol > 0){//不足3条多一行
            newHeight += height;
        }
    }
    newHeight = newHeight + height / 2 ;//默认加大一点,避免拖拉不生效
    
    self.contentSize =  CGSizeMake(myFrame.size.width , newHeight);
    //NSLog(@"content height %i" , newHeight);
}

-(void)layoutImageView:(UIImageView*)view pin:(Pin*)pin{
    CGRect myFrame = [[UIScreen mainScreen] bounds];
    
    NSUInteger maxCol = 3;
    NSUInteger maxRow = 3;
    
    CGFloat width = myFrame.size.width / maxRow;
    CGFloat height = myFrame.size.height / maxCol;

    __weak UIImageView * subView = view;
    
    int imgIndex =  (int) (subView.tag);
    
    NSUInteger row = imgIndex % maxRow;
    
    NSUInteger col = imgIndex / maxCol;
        
    CGFloat x = width * row;
        
    CGFloat y = height * col;
        
    //NSLog(@"i , x , y = %i ,%f , %f " , imgIndex , x , y  );

    CGRect frame = CGRectMake(x, y, width, height);
        
    subView.frame = frame;
        
    //添加手势
    [subView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
    [subView setHidden:NO];
}
/*
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
}*/

-(void)touchImage:(UITapGestureRecognizer *)tap{
    if([tap.view isKindOfClass:[UIImageView class]]){
        UIImageView * view = (UIImageView*)tap.view;
        if(_ClickImageBlock != nil) _ClickImageBlock(view.tag);
        [self removePrevious:(pageOnScrollView - 2)];
        [self removeNewest:(pageOnScrollView + 3)];
    }else{
        NSLog(@"touch img %@" , tap.view);
    }
}


-(void)showImages:(Pin *)pin {
    //pin.url320 = @"http://imgt8.bdstatic.com/it/u=2,971217956&fm=25&gp=0.jpg";
    
    UIImageView * imageV = [[UIImageView alloc]init];
    
    if( pin.is_local ){//9张默认的本地图片
        imageV.image = pin.image;
    }else if( pin.is_cache ){
        __weak UIImageView * _weakImageV = imageV;
        __weak Pin * _weakPin = pin;
        
        //[self loadCacheImage:[NSArray arrayWithObjects:_weakImageV,_weakPin, nil]];
        [self performSelectorInBackground:@selector(loadCacheImage:) withObject:[NSArray arrayWithObjects:_weakImageV,_weakPin, nil]];
        
    }else{//其他网络图片
        /* 同步方式
        NSURL *imageURL = [NSURL URLWithString:pin.url320];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *im = [UIImage imageWithData:imageData];
        imageV.image = im;
         */
        //异步方式
     // [imageV imageWithUrlStr: pin.url_320 phImage:nil];
        [imageV imageWithUrlStr: pin.url_658 phImage:nil];
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
    
    //NSLog(@"add tag %i , %@" , (int)imageV.tag , pin.url320 );
    
    last_idx = (int)pin.idx ;
    
    //NSLog(@"adding image %i" , (int)pin.idx);
    //默认隐藏
    [imageV setHidden:YES];
    [self addSubview:imageV];
    
    [self layoutImageView:imageV pin:pin];
}

//异步读取本地图片
-(void) loadCacheImage:(NSArray*)array{
    __weak UIImageView* imageV = array[0];
    __weak Pin * pin = array[1];
    __weak UIImage * img = [pin loadSmallImage];
    imageV.image = img;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //UIView *view = [touch view];
    //NSLog(@"is hit %@" , view);
    return YES;
}

int page_num = 9;//页数

//往上拉,删除最新的数据
-(void)removeNewest:(int)page{
    [cachePage removeObject:[NSNumber numberWithInt:page]];
    //NSLog(@"remove newest %i" , page);
    int start = page * page_num;
    
    [[self subviews]enumerateObjectsUsingBlock:^( UIView * v , NSUInteger idx, BOOL *stop) {
        if(v.tag >= start){
            if ([v isKindOfClass:UIImageView.class]) {
                [self removeImageView:v];
            }
        }
    }];
}

//往下拉,删除上面的数据
-(void)removePrevious:(int)page{
    [self removePage:page];
}

//往下拉,删除上面的数据
-(void)removePage:(int)page{
    [cachePage removeObject:[NSNumber numberWithInt:page]];
    //NSLog(@"remove previous %i" , page);

    int end = (page + 1)* page_num;
    
    [[self subviews]enumerateObjectsUsingBlock:^( UIView * v , NSUInteger idx, BOOL *stop) {
        
        if(v.tag < end){
            [self removeImageView:v];
        }
    }];
}

-(void)removeImageView:(UIView*)v{
    if ([v isKindOfClass:UIImageView.class]) {
        //NSLog(@"remove tag %i " , (int)v.tag);
        UIImageView * iv = (UIImageView*) v;
        iv.image = nil;
        for (UIGestureRecognizer *recognizer in v.gestureRecognizers) {
            [v removeGestureRecognizer:recognizer];
        }
        [v.layer removeAllAnimations];//remove git 动画?
        [v removeFromSuperview];
        v = nil;
    }
}

//滑到最后,读取其他界面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if(distanceFromBottom <= height){
        //[self loadNextWebData];
    }
    
    //[self scrollViewDidScroll_end:scrollView];
}

//查询远程数据
-(void)loadNextWebData{
    if(_isCacheMode)return;
    
    if([[DataMagic Instance] isFinishShow]){
        [[DataMagic Instance] requestPic];
    }
}

//第几页显示
int pageOnScrollView = -1;

//显示中的cachePage,用于判断是否需要重新load
NSMutableSet * cachePage ;

//拉取下面2页的同步器
bool loadingNext2Page = false;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIScrollView * scroll = scrollView;
    CGPoint scrollOffset=scrollView.contentOffset;
    
    int pagAtual = scrollOffset.y/scroll.superview.frame.size.height;
    
    if(pagAtual == pageOnScrollView) return ;
    
    //NSLog(@"current %i " ,pagAtual);
    
    if(pageOnScrollView < ((int)scrollOffset.y/scroll.frame.size.height))
    {
        if(loadingNext2Page)return ;
        
        if(pagAtual - 2 > -1 ){
            [self removePrevious:pagAtual - 2];
        }
        
        loadingNext2Page = true;
        //load the next page
        //[self loadNextPage:(pagAtual)];
        [self loadNextPage:(pagAtual + 1)];
        //[self loadNextPage:(pagAtual + 2)];
        
        pageOnScrollView=scrollOffset.y/scroll.frame.size.height;
        
        loadingNext2Page = false;
        
        //[_controller showADBanner];
    }
    else if(pageOnScrollView > ((int)scrollOffset.y/scroll.frame.size.height))//避免回弹回来导致数据错误
    {
        [self removeNewest:pagAtual + 3 ];
        
        [self loadNextPage: pagAtual - 1 ];
        
        pageOnScrollView=scrollOffset.y/scroll.frame.size.height;
        
        //[_controller hideADBanner];
    }
}

bool needFillToPage = false;
-(void)loadNextPage:(int)page{

    if([cachePage containsObject:[NSNumber numberWithInt:page]])
        return ;
    
    //NSLog(@"loading page %i" , page);
    
    if(page < 0 )return ;

    for (int i =page * page_num; i < ( page+1) * page_num; i++) {
        if([_controller.pins count] <= i){
            needFillToPage = true;
            break;
        }
        
        if([self viewWithTag:i] == nil){
            Pin * pin = [_controller.pins objectAtIndex:i];
            [self showImages:pin];
        }
    }
    if( page == 0 ){
        Pin * pin = [_controller.pins objectAtIndex:0];//0的在viewWithTag中返回不为空,需要手动加
        [self showImages:pin];
    }
    
    if( [_controller.pins count] >= (page + 1 ) * page_num )
        [cachePage addObject:[NSNumber numberWithInt:page]];
    
    if([_controller.pins count] <=  ( page + 3 ) * page_num){ //保证后面2页是有数据的
        [self loadNextWebData];
    }
}

//数据到了的通知
-(void)pinsRefresh{
    if(needFillToPage){
        [self loadNextPage: pageOnScrollView + 1];
        needFillToPage = false;
    }
}

@end
