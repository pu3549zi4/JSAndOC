//
//  ViewController.m
//  JSAndOC
//
//  Created by dongqiangfei on 16/7/21.
//  Copyright © 2016年 dongqiangfei. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface ViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeBtn];
    [self makeWeb];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)makeBtn {
    UIButton *thisBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    thisBtn.frame = CGRectMake(100, 100, 140, 40);
    [thisBtn addTarget:self action:@selector(ocCallJS) forControlEvents:UIControlEventTouchUpInside];
    [thisBtn setTitle:@"点击oc调用js" forState:UIControlStateNormal];
    [self.view addSubview:thisBtn];
}

-(void)ocCallJS {
//    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"showTitleMessage('%@')",@"oc调用了js的内容"]];
    //btnClick()调用JS中的方法
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"btnClick()"]];
}

-(void)makeWeb {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height - 200)];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    
    NSString *webPath = [[NSBundle mainBundle] pathForResource:@"ocandjs" ofType:@"html"];
    NSURL *webURL = [NSURL fileURLWithPath:webPath];
    NSURLRequest *URLRequest = [[NSURLRequest alloc] initWithURL:webURL];
    [self.webView loadRequest:URLRequest];
    [self.view addSubview:self.webView];
    
    JSContext *content = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    content[@"bdgt"] = ^() {
        NSLog(@"js调用oc---------begin--------");
        NSArray *thisArr = [JSContext currentArguments];
        for (JSValue *jsValue in thisArr) {
            NSLog(@"jsValue =======%@",jsValue);
            NSString *strValue = [jsValue toString];
            NSLog(@"strValue =======%@",strValue);
            if ([strValue isEqualToString:@"hello world"]) {
                if ([self.view.backgroundColor isEqual:[UIColor redColor]]) {
                    self.view.backgroundColor = [UIColor greenColor];
                }else{
                    self.view.backgroundColor = [UIColor redColor];
                }
            }
        }
        //JSValue *this = [JSContext currentThis];
        //NSLog(@"this: %@",this);
        NSLog(@"js调用oc---------The End-------");
//        [self.webView stringByEvaluatingJavaScriptFromString:@"show();"];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
