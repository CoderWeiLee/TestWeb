//
//  ViewController.m
//  TestWeb
//
//  Created by 李伟 on 2021/1/9.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <AlipaySDK/AlipaySDK.h>
@protocol OCJSExport <JSExport>

//! 为OC的-jsToOC:params:方法起个JS认识的别名jsToOc
JSExportAs(aliPay, - (void)aliPay:(NSString *)action);
JSExportAs(alipay, - (void)alipay:(NSString *)action);

@end
@interface ViewController ()<WKScriptMessageHandler, WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *webView;

//@property (nonatomic, strong) UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSURLCache sharedURLCache] setDiskCapacity:0];
        [[NSURLCache sharedURLCache] setMemoryCapacity:0];
    self.view.backgroundColor = [UIColor greenColor];
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    [config.userContentController addScriptMessageHandler:self name:@"aliPay"];
    [config.userContentController addScriptMessageHandler:self name:@"alipay"];
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.hnywhs.com"]]];
    [self.view addSubview:self.webView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pay) name:@"111" object:nil];
}


- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [[AlipaySDK defaultService] processOrderWithPaymentResult:nil standbyCallback:nil];
    [[AlipaySDK defaultService] payOrder:message.body fromScheme:@"com.liweilove.TestWeb" callback:^(NSDictionary *resultDic) {
        NSString *result = [NSString stringWithFormat:@"getResult(%d)",1];
        [self.webView evaluateJavaScript:result completionHandler:^(id object, NSError * _Nullable error) {
               NSLog(@"obj:%@---error:%@", object, error);
           }];
    }];
}

- (void)pay {
    NSString *result = [NSString stringWithFormat:@"getResult(%d)",1];
    [self.webView evaluateJavaScript:result completionHandler:^(id object, NSError * _Nullable error) {
           NSLog(@"obj:%@---error:%@", object, error);
       }];
}
@end
