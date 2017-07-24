//
//  DONGHtmlVC.h
//  DONG-Html5-Css-JavaScript
//
//  Created by yesdgq on 2017/7/24.
//  Copyright © 2017年 yesdgq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DONGHtmlVC : UIViewController

@property (nonatomic, copy) NSString *urlString;
/** 通知情况下跳转到H5页面 */
@property (nonatomic, assign) BOOL notificationPresentH5;
/** H5进入请求的类型 */
@property (nonatomic, copy) NSString *H5Type;

@end
