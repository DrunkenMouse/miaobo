//
//  ADWebViewController.m
//  仿喵播
//
//  Created by 王奥东 on 16/7/24.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "ADWebViewController.h"

@interface ADWebViewController ()
/** webView */
@property(nonatomic, weak) UIWebView *webView;
@end

/**
 webView通过点语法设置，在initWithUrl的时候就创建出了webView并设置了内容
 */
@implementation ADWebViewController

-(UIWebView *)webView{
    if (!_webView) {
        UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:web];
        _webView = web;
    }
    return _webView;
}

-(instancetype)initWithUrlStr:(NSString *)url{
    
    if (self = [self init]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    return self;
}



@end
