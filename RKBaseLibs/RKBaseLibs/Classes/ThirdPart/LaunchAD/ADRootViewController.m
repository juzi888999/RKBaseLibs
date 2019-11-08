//
//  ADRootViewController.m
//  RKBaseLibs
//
//  Created by rk on 2017/12/25.
//  Copyright © 2017年 rk. All rights reserved.
//

#import "ADRootViewController.h"

@interface ADRootViewController ()

@end

@implementation ADRootViewController

//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
-(BOOL)bNavigationBarIsTransparent
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [UIGlobal showLogoHUDForView:self.view];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [UIGlobal hideHudForView:self.view animated:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.ad_viewDidAppearBlock) {
        self.ad_viewDidAppearBlock();
    }
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
