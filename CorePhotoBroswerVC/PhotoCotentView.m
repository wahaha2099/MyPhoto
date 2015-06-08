//
//  PhotoCotentView.m
//  CorePhotoBroswerVC
//
//  Created by 冯成林 on 15/5/15.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoCotentView.h"
#import "PhotoScrollView.h"

@implementation PhotoCotentView

//当前显示第几行


//add subview 后,UIView调用此方法进行布局管理
-(void)layoutSubviews2{
    
    [super layoutSubviews];
    
    CGRect myFrame = [[UIScreen mainScreen] bounds];
    
    //CGRect myFrame = self.bounds;
    
    NSUInteger maxCol = 3;
    NSUInteger maxRow = 3;
    
    CGFloat width = myFrame.size.width / maxRow;
    CGFloat height = myFrame.size.height / maxCol;

    //遍历
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        
        NSUInteger row = idx % maxRow;
        
        NSUInteger col = idx / maxCol;
        
        CGFloat x = width * row;
        
        CGFloat y = height * col;
        
        CGRect frame = CGRectMake(x, y, width, height);
        
        subView.frame = frame;
    }];
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
        
        //PhotoScrollView * view = (PhotoScrollView*)[[self superview]superview];
        //view.delegate = imageV;
        singleTap.delegate = self;
        //singleTap.delegate = imageV;
        [imageV addGestureRecognizer:singleTap];
        
        singleTap.enabled = YES;
        [singleTap setCancelsTouchesInView:NO];

        [imageV setClipsToBounds:YES];
        [imageV setUserInteractionEnabled:YES];
        //设置tag
        imageV.tag = idx;
        
        [self addSubview:imageV];
        

    }];

    [self setUserInteractionEnabled:YES];
}

-(void)touchImage:(UITapGestureRecognizer *)tap{
    if([tap.view isKindOfClass:[UIImageView class]]){
        
        if(_ClickImageBlock != nil) _ClickImageBlock(tap.view.tag);
    }else{
        NSLog(@"touch img %@" , tap.view);
    }
}

//int idx;
-(void)showImages:(UIImage *)image {

        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        
        //开启事件
        imageV.userInteractionEnabled = YES;
        
        //模式
        imageV.contentMode=UIViewContentModeScaleAspectFill;
        
        imageV.clipsToBounds = YES;
        
        //添加手势
        [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
    
        [imageV setUserInteractionEnabled:YES];
        //设置tag
        //imageV.tag = (idx++);
        
        [self addSubview:imageV];
    
            [self setUserInteractionEnabled:YES];
   
}

ViewController* topView;
//传入父类的controller
-(void)setParentViewController:(ViewController*)viewController{
    topView = viewController;
}

//
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    NSLog(@"content tap is %@" , otherGestureRecognizer.view);
    if([otherGestureRecognizer.view isKindOfClass:[UIImageView class]]){
        return YES;
    }
    if([otherGestureRecognizer.view isKindOfClass:[PhotoScrollView class]]){
        return NO;
    }
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    printf("myView touchesBegan \n");
    self.backgroundColor = [UIColor grayColor];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    printf("myView touchesMoved \n");
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    printf("myView touchesEnded \n");
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    printf("myView touchesCancelled \n");
    self.backgroundColor = [UIColor yellowColor];
}

@end
