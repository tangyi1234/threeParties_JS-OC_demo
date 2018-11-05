//
//  TYGenericViewController.m
//  threeParties_JS&OC_demo
//
//  Created by 汤义 on 2018/11/2.
//  Copyright © 2018年 汤义. All rights reserved.
//

#import "TYGenericViewController.h"
#import "TYImitationWeb_js.h"

#define kOldProtocolScheme @"wvjbscheme"
#define kNewProtocolScheme @"https"
#define kQueueHasMessage   @"__wvjb_queue_message__"
#define kBridgeLoaded      @"__bridge_loaded__"
@interface TYGenericViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation TYGenericViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self loadExamplePage:self.webView];
    [self addButView];
}

- (UIWebView *)webView{
    if(_webView == nil){
        _webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)addButView{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, [UIScreen mainScreen].bounds.size.height - 40, 100, 30);
    but.backgroundColor = [UIColor redColor];
    [but setTitle:@"发送" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}

- (void)selectorBut{
    NSString *handlerName = @"testJavascriptHandler";
    NSMutableDictionary* message = [NSMutableDictionary dictionary];
    
    //将识别的标识的名称储存到message中，用固定的字符串handlerName为key存储到message中。
    if (handlerName) {
        message[@"handlerName"] = handlerName;
    }
    [self _dispatchMessage:message];
}

- (void)_dispatchMessage:(NSDictionary *)message {
    NSString *messageJSON = [self _serializeMessage:message pretty:NO];
//    [self _log:@"SEND" json:messageJSON];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    NSLog(@"这里json数据转化成什么样子了:%@",messageJSON);
    NSString* javascriptCommand = [NSString stringWithFormat:@"TYImitationWebMeson._handleMessageFromObjC('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self sendJs:javascriptCommand];
        
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self sendJs:javascriptCommand];
        });
    }
}

- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"获取数据:%@",[request URL]);
    NSURL *url = [request URL];
    if ([self isWebViewJavascriptBridgeURL:url]) {
        if ([self isBridgeLoadedURL:url]) {
            [self createConnectionc];
        }
    }
    return YES;
}

//实现关联
- (void)createConnectionc{
    NSString *js = TYImitationWebMeson_js();
    NSLog(@"我们自己写的js:%@",js);
    [self sendJs:js];
}
//具体的操作
- (void)sendJs:(NSString *)javascriptCommand{
    [_webView stringByEvaluatingJavaScriptFromString:javascriptCommand];
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"GenericApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

#pragma mark -- 判断url
- (BOOL)isWebViewJavascriptBridgeURL:(NSURL*)url {
    if (![self isSchemeMatch:url]) {
        return NO;
    }
    return [self isBridgeLoadedURL:url] || [self isQueueMessageURL:url];
}

- (BOOL)isSchemeMatch:(NSURL*)url {
    NSString* scheme = url.scheme.lowercaseString;
    return [scheme isEqualToString:kNewProtocolScheme] || [scheme isEqualToString:kOldProtocolScheme];
}

- (BOOL)isQueueMessageURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kQueueHasMessage];
}

- (BOOL)isBridgeLoadedURL:(NSURL*)url {
    NSString* host = url.host.lowercaseString;
    return [self isSchemeMatch:url] && [host isEqualToString:kBridgeLoaded];
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
