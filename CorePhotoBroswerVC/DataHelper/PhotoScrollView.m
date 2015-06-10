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
@property int last_idx;       //最后的图片的index
@property int layout_count;     //layoutSubviews处理了的长度
//第几页显示
@property int pageOnScrollView ;//= -1;

//显示中的cachePage,用于判断是否需要重新load
@property NSMutableSet * cachePage ;

//拉取下面2页的同步器
@property bool loadingNext2Page ;//= false;

//不够图片显示,有数据来通知界面更新
@property bool needFillToPage ;//

@end

@implementation PhotoScrollView






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
    
    _pageOnScrollView = -1;
    _cachePage = [[NSMutableSet alloc]init];
    _controller = cont;
}

//add subview 后,UIView调用此方法进行布局管理
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    //int finish_idx = layout_count;
    //if(layout_count == last_idx)return;//只有新加入的subview才需要进行布局修改
    //layout_count = last_idx;
    
    CGRect myFrame = [[UIScreen mainScreen] bounds];

    NSUInteger maxCol = 2;
    //NSUInteger maxRow = 3;
    //CGFloat width = myFrame.size.width / maxRow;
    
    CGFloat height = myFrame.size.height / maxCol;
    //设置content size
    //int newHeight = height * ([self.subviews count] / maxCol );
    
    int newHeight = height * (_pageOnScrollView + 2) * 3;//页数*4行
    
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
    
    NSUInteger maxCol = 2;
    NSUInteger maxRow = 2;
    
    CGFloat width = myFrame.size.width / maxRow;
    CGFloat height = myFrame.size.height / maxCol;

    __weak UIImageView * subView = view;
    
    int imgIndex =  (int) (subView.tag);
    
    NSUInteger row = imgIndex % maxRow;
    
    NSUInteger col = imgIndex / maxCol;
        
    CGFloat x = width * row;

    CGFloat y = height * col + 10;

    //NSLog(@"i , x , y = %i ,%f , %f " , imgIndex , x , y  );

    CGRect frame = CGRectMake(x, y, width, height);
        
    subView.frame = frame;
    
    CALayer *paddingLayer = subView.layer;
    //subView.layer.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    //CALayer *paddingLayer = [CALayer layer];
    //paddingLayer.frame=CGRectMake(0, height - 3.0f, width, 100.f);
    paddingLayer.frame = CGRectInset(subView.layer.frame, 0.5, 0.5);
    paddingLayer.borderColor=[UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
    paddingLayer.borderWidth=1.0;
    //[subView.layer addSublayer:paddingLayer];
    
    
    //添加手势
    [subView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
    [subView setHidden:NO];
}

-(void)touchImage:(UITapGestureRecognizer *)tap{
    if([tap.view isKindOfClass:[UIImageView class]]){
        UIImageView * view = (UIImageView*)tap.view;
        if(_ClickImageBlock != nil) _ClickImageBlock(view.tag);
        [self removePrevious:(_pageOnScrollView - 2)];
        [self removeNewest:(_pageOnScrollView + 3)];
    }else{
        NSLog(@"touch img %@" , tap.view);
    }
}


-(void)showImages:(Pin *)pin {
    //pin.url320 = @"http://imgt8.bdstatic.com/it/u=2,971217956&fm=25&gp=0.jpg";
    
    UIImageView * imageV = [[UIImageView alloc]init];
    
    __weak UIImageView * _weakImageV = imageV;
    __weak Pin * _weakPin = pin;
    
    if( pin.is_local ){//9张默认的本地图片
        imageV.image = pin.image;
    }else if( pin.is_cache ){

        
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
        
        [self performSelectorInBackground:@selector(loadWebImage:) withObject:[NSArray arrayWithObjects:_weakImageV,_weakPin, nil]];
        
//        [imageV imageWithUrlStr: pin.url_658 phImage:nil];
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
    
    self.last_idx = (int)pin.idx ;
    
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
    
//    UIImage *img =[UIImage imageNamed:@"1"];
    imageV.image = img;
}

//下载网络图片,参考UIImageView (SD).h
-(void)loadWebImage:(NSArray*)array{//(NSString*)urlStr (UIImageView*):view{

    __weak UIImageView* imageV = array[0];
    __weak Pin * pin = array[1];
    NSString * urlStr = pin.url_658;
    
    if(urlStr==nil) return;
    
    NSURL *url=[NSURL URLWithString:urlStr];
    
    SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed;

    //id <SDWebImageOperation> operation =
    [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
       if (!imageV || !pin) return;
        //dispatch_main_sync_safe(^{
            if (!imageV || !pin) return;
            if (image && pin) {
                //set the key to url658
                //imageV.image = image;
                
                //pin.url320 = pin.url658 = [SDWebImageManager.sharedManager cacheKeyForURL:imageURL];
                NSData *imageData = UIImagePNGRepresentation(image);
                UIImage * pngImage = [UIImage imageWithData:imageData];
                
                imageV.image = [Pin fixSmallPic:pngImage];
            } else {
 //              imagev.image =
            }
            
       // });
    }];
/**
 __weak UIImageView* imageV = array[0];
 __weak Pin * pin = array[1];
 NSString * urlStr = pin.url_658;
 
 if(urlStr==nil) return;
 
 NSURL *url=[NSURL URLWithString:urlStr];
 
 SDWebImageOptions options = SDWebImageLowPriority | SDWebImageRetryFailed;
 
 id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
 if (!imageV) return;
 dispatch_main_sync_safe(^{
 if (!imageV) return;
 if (image) {
 imageV.image = image;
 imageV.image = [pin loadSmallImage];
 } else {
 //              imagev.image =
 }
 
 });
 }];

 */
}

/*
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}*/

int page_num = 4;//页数

//往上拉,删除最新的数据
-(void)removeNewest:(int)page{
    [_cachePage removeObject:[NSNumber numberWithInt:page]];
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
    [_cachePage removeObject:[NSNumber numberWithInt:page]];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIScrollView * scroll = scrollView;
    CGPoint scrollOffset=scrollView.contentOffset;
    CGRect frame = scroll.superview.frame;
    int pagAtual = scrollOffset.y/frame.size.height;
    
    if(pagAtual == _pageOnScrollView) return ;
    
    //NSLog(@"current %i " ,pagAtual);
    
    if(_pageOnScrollView < ((int)scrollOffset.y/frame.size.height))
    {
        if(_loadingNext2Page)return ;
        
        if(pagAtual - 2 > -1 ){
            [self removePrevious:pagAtual - 2];
        }
        
        _loadingNext2Page = true;
        //load the next page
        //[self loadNextPage:(pagAtual)];
        [self loadNextPage:(pagAtual + 1)];
        //[self loadNextPage:(pagAtual + 2)];
        
       _pageOnScrollView=scrollOffset.y/frame.size.height;
        
        _loadingNext2Page = false;
        
        //[_controller showADBanner];
    }
    else if(_pageOnScrollView > ((int)scrollOffset.y/frame.size.height))//避免回弹回来导致数据错误
    {
        [self removeNewest:pagAtual + 3 ];
        
        [self loadNextPage: pagAtual - 1 ];
        
        _pageOnScrollView=scrollOffset.y/frame.size.height;
        
        //[_controller hideADBanner];
    }
}


-(void)loadNextPage:(int)page{

    if([_cachePage containsObject:[NSNumber numberWithInt:page]])
        return ;
    
    //NSLog(@"loading page %i" , page);
    
    if(page < 0 )return ;

    for (int i =page * page_num; i < ( page+1) * page_num; i++) {
        if([_controller.pins count] <= i){
            _needFillToPage = true;
            break;
        }
        
        if([self viewWithTag:i] == nil){
            Pin * pin = [_controller.pins objectAtIndex:i];
            [self showImages:pin];
        }
    }
    if( page == 0 && [_controller.pins count] > 0 ){
        
        Pin * pin = [_controller.pins objectAtIndex:0];//0的在viewWithTag中返回不为空,需要手动加
        [self showImages:pin];
    }
    
    if( [_controller.pins count] >= (page + 1 ) * page_num )
        [_cachePage addObject:[NSNumber numberWithInt:page]];
    
    if([_controller.pins count] <=  ( page + 3 ) * page_num){ //保证后面2页是有数据的
        [self loadNextWebData];
    }
}

//数据到了的通知
-(void)pinsRefresh{
    if(_needFillToPage){
        [self loadNextPage: _pageOnScrollView + 1];
        _needFillToPage = false;
    }
}

#pragma mark ========切换tab时,删除和重新显示======
//回收全部imageView
-(void)removeAllPage{
    [self removePrevious:_pageOnScrollView + 3];
    [_cachePage removeAllObjects];
}
//显示当前page的imageView
-(void)addCurrentPage{
    if (_pageOnScrollView == -1 ) {
        _pageOnScrollView = 0;
    }
    [self loadNextPage:_pageOnScrollView - 1];
    [self loadNextPage:_pageOnScrollView];
    [self loadNextPage:_pageOnScrollView + 1];
}
#pragma mark ========切换tab时,删除和重新显示======

@end
