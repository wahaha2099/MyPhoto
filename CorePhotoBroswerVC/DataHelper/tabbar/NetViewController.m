//
//  NetViewController.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/6/9.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "NetViewController.h"

@interface NetViewController ()

@property (weak, nonatomic) IBOutlet PhotoScrollView *scrollView;

@end

@implementation NetViewController

-(void)initTabItem{
    UITabBarItem * tempBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:1];
    
    self.tabBarItem.title=@"下载";
    self.tabBarItem.image= tempBarItem.selectedImage;
    //self.tabBarItem.badgeValue=@"10";
    
    [self tabSelected];
}

-(void)initTab{
    [self initNetMode];
    [[self getScrollView] initScrollView:self];
    
    NSArray * files = [[SDImageCache sharedImageCache]getDiskKeys];

    for (int i = 0; i < 9; i++) {
        Pin * pin = [[Pin alloc]init];
        if([files count] > i){
            NSURL * url = [files objectAtIndex:[files count] - 1 - i];
            pin.url658 = [url path];
            pin.url320 = [url path];
            //pin.image = [pin loadLocalImage];
            pin.is_cache = true;
            pin.idx = [super.pins count];
            
        }else{
            UIImage *imagae =[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpeg",@(i+1)]];
            pin.idx = i;
            pin.image = imagae;
            pin.is_local = true;
        }
        [_scrollView showImages:pin];
        
        [super.pins addObject:pin];
    }
    [self addCurrentPage];
    
}

//删除按钮后的通知
-(void) removeCachePinNotify:(NSNotification*) aNotification{
    [super removePinNotify:aNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PhotoScrollView*) getScrollView{
    return self.scrollView;
}

#pragma mark ====tab切换操作======
//选中当前controller
-(void)tabSelected{
    //子类实现
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REMOVE_PIN"  object:nil ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCachePinNotify:) name:@"REMOVE_PIN" object:nil];
    
    [_scrollView addCurrentPage];
}
//没选中当前controller
-(void)tabNotSelected{
    //子类实现
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"REMOVE_PIN"  object:nil ];
    
    [_scrollView removeAllPage];
}
#pragma mark ====tab切换操作======


@end
