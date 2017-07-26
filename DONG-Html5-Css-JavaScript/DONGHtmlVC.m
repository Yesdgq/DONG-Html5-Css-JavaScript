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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHex:@"dddddd"];
    
    [self setNavigationBarItem];
    
    
    
    if (_urlString) {
        [self webViewLoadUrlData];
    }
    [self addGoBackButton];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)addGoBackButton {
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 22, 22);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    [btn addTarget:self action:@selector(clickBackBBI:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"Back_Arrow"] forState:UIControlStateNormal];
    
    
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
    
    _threeItemsArray = [NSArray arrayWithObjects:leftNegativeSpacer,item,closeItem, nil];
    _twoItemsArray = [NSArray arrayWithObjects:leftNegativeSpacer,item, nil];
    
    self.navigationItem.leftBarButtonItems = _twoItemsArray;
    
}

//webView如果有多层页面，点击返回回到上一页面。返回到首页再点击关闭当前控制器
- (void)clickBackBBI:(UIButton *)sender {
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

//关闭当前控制器
- (void)closeController:(UIButton *)sender {
    if (self.notificationPresentH5) {
        [self dismissViewControllerAnimated:YES completion:NULL];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/** 加载webView */
- (void)webViewLoadUrlData
{
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"index1"
                                                          ofType:@"html"];
    
    
    
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kMainScreenWidth, kMainScreenHeight -20)];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    //-1.进度条
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
- (void)setLoadCount:(NSUInteger)loadCount {
    _loadCount = loadCount;
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else {
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
}

-(void)webView:(UIWebView*)webView DidFailLoadWithError:(NSError*)error
{
    self.loadCount --;
    self.progressView.hidden = YES;
    //    NSLog(@"DidFailLoadWithError");
    
    NSLog(@"加载失败");
    
    self.title = @"呀！页面走丢啦~";
    // 本地加载html
    NSString *htmlPath=[[NSBundle mainBundle] pathForResource:@"erro" ofType:@"html"];
    NSURL *localURL=[[NSURL alloc]initFileURLWithPath:htmlPath];
    [_webView loadRequest:[NSURLRequest requestWithURL:localURL]];
}


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

#pragma mark - js 调用 oc方法
- (void)goToLogin {
    
    JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"goToLogin"] = ^() {//这使用block的方式来实现的
        //        NSArray *argsContent = [JSContext currentArguments];//获取JS给OC传的值
        //
        //        //<处理数据方法1.得到指定的某个数据>判断是否有数据(有数据的处理)
        //        if (argsContent.count) {
        //            id dataValue = [[NSString stringWithFormat:@"%@",argsContent[0]] mj_JSONObject];
        //            NSLog(@"%@",dataValue);
        //        }
        //
        //        NSArray *args = [JSContext currentArguments];//获取JS给OC传的值
        //        NSDictionary *dic;
        //        //<处理数据方法2>返回的json数据解析处理
        //        for (JSValue *jsVal in args) {
        //            dic = [jsVal toDictionary];
        //            NSLog(@"%@",dic);
        //            NSString *str = [NSString stringWithFormat:@"%@",jsVal];
        //            id dataValue = [str mj_JSONObject];
        //            NSLog(@"%@", dataValue);
        //        }
        //
        //        JSValue *this = [JSContext currentThis];
        //        NSLog(@"%@",this.context.description);
        //        NSLog(@"-------End Log-------");
        //        return dic;//这很重要。这是给JS调用此方法后的返回值<自己控制返回什么>
        
        //打开以下注释
        /*
         CPLoginViewController *login = TL_INSTANT_VC_WITH_ID(@"Main", @"CPLoginViewController");
         UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
         [self presentViewController:nav animated:YES completion:nil];
         */
    };
}




@end
