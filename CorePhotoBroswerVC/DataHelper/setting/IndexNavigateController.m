//
//  IndexNavigateController.m
//  CorePhotoBroswerVC
//
//  Created by Apple on 15/7/8.
//
//

#import "IndexNavigateController.h"

@interface IndexNavigateController ()

@end

@implementation IndexNavigateController

//设置tabItem名称
-(void)initTabItem{
    UITabBarItem * tempBarItem =  [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:3];
    
    /**/
    self.tabBarItem.title=@"最新";
    self.tabBarItem.image= tempBarItem.selectedImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
