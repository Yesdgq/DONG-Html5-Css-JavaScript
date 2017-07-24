//
//  ViewController.m
//  DONG-Html5-Css-JavaScript
//
//  Created by yesdgq on 2017/7/24.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "ViewController.h"
#import "DONGHtmlVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)buttonClick:(id)sender
{
    DONGHtmlVC *htmlVC = [[DONGHtmlVC alloc] init];
    htmlVC.urlString = @"https://www.baidu.com";
    [self.navigationController pushViewController:htmlVC animated:YES];
}

@end
