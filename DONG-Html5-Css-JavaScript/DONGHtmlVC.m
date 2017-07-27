//
//  DONGHtmlVC.m
//  DONG-Html5-Css-JavaScript
//
//  Created by yesdgq on 2017/7/24.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import "DONGHtmlVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "UIColor+Addition.h"

#define WebViewNav_TintColor [UIColor colorWithHex:@"#16a7d1"]
#define kMainScreenWidth [UIScreen mainScreen].bounds.size.width
#define kMainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface DONGHtmlVC () <UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *webView;

@property (assign, nonatomic) NSUInteger loadCount; // 进度条进度
@property (strong, nonatomic) UIProgressView *progressView; // 进度条
@property (strong, nonatomic) UIButton *closeButton; // 导航栏关闭按钮

@property (nonatomic,strong) NSArray *threeItemsArray;
@property (nonatomic,strong) NSArray *twoItemsArray;

@end

@implementation DONGHtmlVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    
    [self setNavigationBarItem];
    
    
    if (_urlString) {
        [self webViewLoadUrlData];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addGoBackButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(50, 29, 50, 30);
    [btn setTitle:@"关闭" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:@"#4c4c4c"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)popView
{
    UITabBarController *tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVC.selectedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)setNavigationBarItem
{
    // 返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 22);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickBackBBI:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    
    // 关闭按钮
    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = CGRectMake(0, 0, 35, 22);
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc]initWithCustomView:_closeButton];
    [_closeButton addTarget:self action:@selector(closeController:) forControlEvents:UIControlEventTouchUpInside];
    [_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    _closeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *leftNegativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
    leftNegativeSpacer.width = -6;
    
    _threeItemsArray = [NSArray arrayWithObjects:leftNegativeSpacer,item,closeItem, nil]; // 有关闭
    _twoItemsArray = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil]; // 没有关闭
    
    self.navigationItem.leftBarButtonItems = _twoItemsArray;
    
    // 右侧item
    // 关闭按钮
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 22);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [rightBtn addTarget:self action:@selector(ocNativeCallJs) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"OC调用JS" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItems = @[leftNegativeSpacer, rightItem];

    
    
}

// webView如果有多层页面，点击返回回到上一页面。返回到首页再点击关闭当前控制器
- (void)clickBackBBI:(UIButton *)sender
{
    if (self.notificationPresentH5) {
        if (_webView.canGoBack) {
            [_webView goBack];
        } else {
            [self dismissViewControllerAnimated:YES completion:NULL];
        }
    } else {
        if (_webView.canGoBack) {
            [_webView goBack];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    return;
}

// 关闭当前控制器
- (void)closeController:(UIButton *)sender
{
    if (self.notificationPresentH5) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 加载webView */
- (void)webViewLoadUrlData
{
    // 读取本地xml
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index1"
                                                          ofType:@"html"];
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    // 进度条
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0)];
    [_webView addSubview:progressView];
    progressView.tintColor = WebViewNav_TintColor;
    progressView.trackTintColor = [UIColor whiteColor];
    self.progressView = progressView;
    
//    NSURL *url = [NSURL URLWithString:_urlString]; // 加载http
        NSURL *url = [NSURL URLWithString:htmlPath]; // 加载本地html
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

// 计算webView进度条
- (void)setLoadCount:(NSUInteger)loadCount
{
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    } else {
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
}


#pragma mark - webView delegate


- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* url = [request URL];
    NSString* urlstring = [NSString stringWithFormat:@"%@",url];
    NSLog(@"url = %@",urlstring);
    
    if (_webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = _threeItemsArray;
    } else {
        self.navigationItem.leftBarButtonItems = _twoItemsArray;
    }
    
    return TRUE;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    self.progressView.hidden = NO;
    self.loadCount ++;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 获取当前页面的title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (_webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = _threeItemsArray;
    }
    
    // 获取当前网页的html
    // NSString *indexHtml = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    
    self.loadCount --;
    self.progressView.hidden = YES;
    NSLog(@"webViewDidFinishLoad");
    // [Dialog dismissSVHUD];
    // JS调用OC方法
    [self jsCallOcNative];

}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error
{
    self.loadCount --;
    self.progressView.hidden = YES;
    //    NSLog(@"DidFailLoadWithError");
    
    NSLog(@"加载失败");
    
    self.title = @"呀！页面走丢啦~";
    // 本地加载html
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"erro" ofType:@"html"];
    NSURL *localURL = [[NSURL alloc]initFileURLWithPath:htmlPath];
    [_webView loadRequest:[NSURLRequest requestWithURL:localURL]];
}


#pragma mark - 网络请求

//- (void)requestData {
//    NSDictionary *parameters = @{
//                                 @"token":UserInfoManager.token.length > 0 ? UserInfoManager.token : @"",
//                                 @"serviceCode":_H5Type
//                                 };
//    [requestDataManager postRequestDataWithUrl:@"www.baidu.com" parameters:parameters success:^(id  _Nullable responseObject) {
//        [CommonFunc dismiss];
//        if (responseObject) {
//            NSDictionary *dic = responseObject;
//            NSDictionary *data = [dic objectForKey:@"data"];
//
//            _urlString = data[@"serviceUrl"];
//            [self webViewLoadUrlData];
//        }
//
//    } failure:^(id  _Nullable errorObject) {
//
//        [CommonFunc dismiss];
//        [MBProgressHUD showError:@"获取数据失败!"];
//
//    }];
//
//}

- (void)share
{
    NSLog(@"share被调用了");
}

#pragma mark - JS调用OC方法

- (void)jsCallOcNative
{
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    // 定义好JS要调用的方法, share就是调用的share方法名
    context[@"share"] = ^() {
        NSLog(@"+++++++Begin Log+++++++");
        NSArray *args = [JSContext currentArguments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"JS调用OC方法" message:@"这是OC原生的弹出窗" delegate:self cancelButtonTitle:@"收到" otherButtonTitles:nil];
            [alertView show];
        });
        
        for (JSValue *jsVal in args) {
            NSLog(@"%@", jsVal.toString);
        }
        
        NSLog(@"-------End Log-------");
    };
}


#pragma mark - OC调用JS方法

// 方式一
- (void)ocNativeCallJs
{
    NSString *jsStr = [NSString stringWithFormat:@"showAlert('%@')",@"这里是JS中alert弹出的message"];
    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
    
}

// 方式二  使用JavaScriptCore库来做JS交互

- (void)ocNativeCallJs2
{
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *textJS = @"showAlert('这里是JS中alert弹出的message')";
    [context evaluateScript:textJS];
}

@end
