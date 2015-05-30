//
//  PhotoScrollView.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/5/29.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "PhotoScrollView.h"
#import "UIImageView+SD.h"

@implementation PhotoScrollView


int last_idx;       //最后的图片的index
int layout_count;     //layoutSubviews处理了的长度

//add subview 后,UIView调用此方法进行布局管理
-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    int finish_idx = layout_count;
    if(layout_count >= last_idx)return;//只有新加入的subview才需要进行布局修改
    layout_count = last_idx;
    
    CGRect myFrame = [[UIScreen mainScreen] bounds];

    NSUInteger maxCol = 3;
    NSUInteger maxRow = 3;
    
    CGFloat width = myFrame.size.width / maxRow;
    CGFloat height = myFrame.size.height / maxCol;
    
    for(int idx = finish_idx ; idx < last_idx ; idx++){
        UIView * subView = [self.subviews objectAtIndex:idx];
        //NSLog(@"subview %@ " , subView);
        NSUInteger row = idx % maxRow;
        
        NSUInteger col = idx / maxCol;
        
        CGFloat x = width * row;
        
        CGFloat y = height * col;
        
        //NSLog(@"i , x , y = %ld ,%f , %f " , idx , x , y  );
        
        CGRect frame = CGRectMake(x, y, width, height);
        
        subView.frame = frame;
        
        //添加手势
        [subView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
        [subView setHidden:NO];
    }
    
    //设置content size
    int newHeight = height * ([self.subviews count] / maxCol );
    if( newHeight > myFrame.size.height ){
        if([self.subviews count] % maxCol > 0){//不足3条多一行
            newHeight += height;
        }
        self.contentSize =  CGSizeMake(myFrame.size.width , newHeight);
    }
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
    
    UIImage *placehold = [UIImage phImageWithSize:[UIScreen mainScreen].bounds.size zoom:.3f];
    pin.placehold = placehold;
    
    imageV.image = pin.placehold;
    [imageV imageWithUrlStr: pin.url_320 phImage:pin.placehold];

    //开启事件
    imageV.userInteractionEnabled = YES;
    
    //模式
    imageV.contentMode=UIViewContentModeScaleAspectFill;
    
    imageV.clipsToBounds = YES;
    
    //添加手势
    //[imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchImage:)]];
    
    [imageV setUserInteractionEnabled:YES];
    //设置tag
    imageV.tag = (last_idx++);
    
    //默认隐藏
    [imageV setHidden:YES];
    [self addSubview:imageV];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    //UIView *view = [touch view];
    //NSLog(@"is hit %@" , view);
    return YES;
}



@end
