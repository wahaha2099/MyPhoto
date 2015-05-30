//
//  ViewController.m
//  CorePhotoBroswerVC
//
//  Created by 成林 on 15/5/4.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "ViewController.h"
#import "PhotoBroswerVC.h"
#import "PhotoCotentView.h"
#import "DataMagic.h"
#import "PhotoScrollView.h"
#import "UIImage+ReMake.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet PhotoScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *pins;

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = false;

    [_scrollView initScrollView];
    _scrollView.delegate = self;
    /*
    [_scrollView setScrollEnabled:YES];
    [_scrollView setCanCancelContentTouches:YES];
    _scrollView.delaysContentTouches = NO;
  CGRect myFrame = [[UIScreen mainScreen] bounds];
    [ _scrollView setContentSize:myFrame.size];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
*/
       
    _pins = [[NSMutableArray alloc]init];
    
    
    //展示数据
    [self contentViewDataPrepare];
    
    //请求远程图片
    [self performSelectorInBackground:@selector(loadWebData) withObject:nil];
    
    //测试
    //[self mockTest];
    
    //事件
    [self event];
}

//请求远程图片
-(void)loadWebData{
    //添加远程数据
    NSString * notify = [[DataMagic Instance]NOTIFY_FINISH_PIC_PARSE];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWebPhoto:) name:notify object:nil];
    [[DataMagic Instance]requestPic];
}

//直接加入pin测试
-(void)mockTest{
    Pin * pin = [[Pin alloc]init];
    pin.idx = 10;
    [_pins addObject:pin];
    [_scrollView showImages:pin];
}

/** 展示本地9张图片 */
-(void)contentViewDataPrepare{
    for (NSUInteger i=0; i<9; i++) {
        UIImage *imagae =[UIImage imageNamed:[NSString stringWithFormat:@"%@",@(i+1)]];

        Pin * pin = [[Pin alloc]init];
        pin.image = imagae;
        pin.is_local = true;
        pin.idx = i;
        [_pins addObject:pin];
        [_scrollView showImages:pin];
    }
}

/** 事件 */
-(void)event{
    
    _scrollView.ClickImageBlock = ^(NSUInteger index){
        
        //本地图片展示
//        [self localImageShow:index];
        
        //展示网络图片
        [self networkImageShow:index];
    };
}


- (IBAction)showAction:(id)sender {
    

}

/*
 *  本地图片展示
 */
-(void)localImageShow:(NSUInteger)index{
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        NSArray *localImages = weakSelf.pins;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:localImages.count];
        for (NSUInteger i = 0; i< localImages.count; i++) {
            Pin * pin = _pins[i];
            if(!pin.is_local){
                break;
            }
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = [NSString stringWithFormat:@"这是标题%@",@(i+1)];
            pbModel.desc = [NSString stringWithFormat:@"我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字我是一段很长的描述文字%@",@(i+1)];
            pbModel.image = localImages[i];
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}


/*
 *  展示网络图片
 */
-(void)networkImageShow:(NSUInteger)index{
    
    
    __weak typeof(self) weakSelf=self;
    
    [PhotoBroswerVC show:self type:PhotoBroswerVCTypeZoom index:index photoModelBlock:^NSArray *{
        
        NSArray * networkImages = _pins;;
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:networkImages.count];
        for (NSUInteger i = 0; i< networkImages.count; i++) {
            
            Pin * pin = _pins[i];
            
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            pbModel.title = pin.raw_text;
            pbModel.desc = pin.raw_text;
            
            if(pin.is_local)
                pbModel.image = pin.image;
            else
                pbModel.image_HD_U = pin.url_658;
            
            //源frame
            UIImageView *imageV =(UIImageView *) weakSelf.scrollView.subviews[i];
            pbModel.sourceImageView = imageV;
            
            [modelsM addObject:pbModel];
        }
        
        return modelsM;
    }];
}

//远程查询数据结束
-(void)showWebPhoto: (NSNotification*) aNotification{
    NSNumber * board_id = [aNotification object];
    
    if(board_id == nil){
        [[DataMagic Instance]finishShowPage];
        return ;
    }
    NSDictionary * Boards = [[DataMagic Instance]Boards];
    BoardInfo * board = [Boards objectForKey:board_id];
    [self performSelectorInBackground:@selector(addPin2UI:) withObject:board ];
}

//异步添加图片到ui
-(void)addPin2UI:(BoardInfo*)board{
    [board.pins enumerateObjectsUsingBlock:^(Pin * pin, NSUInteger idx, BOOL *stop) {
        pin.idx = [_pins count];
        
        [_pins addObject:pin];
        
        [_scrollView showImages:pin];
    }];
    [[DataMagic Instance]finishShowPage];
}

//滑到最后,读取其他界面
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if(distanceFromBottom <= height){
        if([[DataMagic Instance] isFinishShow]){
            [[DataMagic Instance] requestPic];
        }
    }
    
    
}

@end
