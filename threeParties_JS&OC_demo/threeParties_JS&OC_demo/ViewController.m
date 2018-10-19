//
//  ViewController.m
//  threeParties_JS&OC_demo
//
//  Created by 汤义 on 2018/10/16.
//  Copyright © 2018年 汤义. All rights reserved.
//

#import "ViewController.h"
#import "TYWebViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addView];
}

- (void)addView{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 80, 150, 30);
    but.backgroundColor = [UIColor redColor];
    [but setTitle:@"跳转" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    UIButton *but1 = [UIButton buttonWithType:UIButtonTypeCustom];
    but1.frame = CGRectMake(10, 140, 150, 30);
    but1.backgroundColor = [UIColor yellowColor];
    [but1 setTitle:@"跳转1" forState:UIControlStateNormal];
    [but1 addTarget:self action:@selector(selectorBut1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but1];
}

- (void)selectorBut{
    TYWebViewController *vc = [[TYWebViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectorBut1{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
