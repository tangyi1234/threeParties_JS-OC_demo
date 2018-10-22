//
//  TYWebViewController.m
//  threeParties_JS&OC_demo
//
//  Created by 汤义 on 2018/10/16.
//  Copyright © 2018年 汤义. All rights reserved.
//

#import "TYWebViewController.h"
#import "WebViewJavascriptBridge.h"
#define H [UIScreen mainScreen].bounds.size.height
#define W [UIScreen mainScreen].bounds.size.width
@interface TYWebViewController ()
@property (nonatomic, strong) WebViewJavascriptBridge *bridge;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation TYWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self registeredInteraction];
    [self loadExamplePage:_webView];
    [self addButView];
}

- (UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _webView;
}

//注册交互
- (void)registeredInteraction{
    //判断是否存在对象
    if(_bridge){
        return;
    }
    //首先获取报文
    [WebViewJavascriptBridge enableLogging];
    //实例化
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    //设代理(这个可以不设置)
    [_bridge setWebViewDelegate:self];
    [self interactiveMethod];
}

- (void)addButView{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, H - 40, 100, 30);
    but.backgroundColor = [UIColor redColor];
    [but setTitle:@"oc调js" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    
}

//注册js调oc
- (void)interactiveMethod{
    [self.bridge registerHandler:@"jsGoOc" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"触发了js调oc");
        responseCallback(@{@"名称":@"执行成功"});
    }];
}
//oc调js
- (void)selectorBut{
    __weak typeof(self) weakSelf = self;
    id data = @{ @"greetingFromObjC": @"Hi there, JS!" };
    [self.bridge callHandler:@"testJavascriptHandler" data:data responseCallback:^(id responseData) {
        NSLog(@"这个方法能调用吗:%@",responseData);
    }];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
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
