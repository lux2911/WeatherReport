//
//  HelpViewController.m
//  Weather
//
//  Created by Tomislav Luketic on 5/6/17.
//  Copyright © 2017 Tomislav Luketic. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) WKWebView* webView;
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration * conf = [[WKWebViewConfiguration alloc] init];
    
    CGRect rect = self.view.frame;
    rect.origin.y = 40;
    rect.origin.x = 10;
    rect.size.width -= (10*2);

    
    self.webView = [[WKWebView alloc] initWithFrame:rect configuration:conf];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = NO;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    UIWindow* aWindow = self.view.window;
        
    [aWindow addSubview:self.progressView];
        
    [self loadHtml];
   
    
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"])
    {
        self.progressView.progress = [change[NSKeyValueChangeNewKey] floatValue];
        
        if (self.progressView.progress == 1.0)
            self.progressView.hidden = YES;
    }
}

-(void)loadHtml
{
    NSBundle* bundle = [NSBundle mainBundle];
    
    NSString *aPath = [bundle pathForResource:@"Help" ofType:@"plist"];
    
    if (aPath)
    {
        NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:aPath];
        [self.webView loadHTMLString:dict[@"html"] baseURL:nil];
    }

}

#pragma -WKNavigationDelegate

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated)
    {
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
        decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark


@end
