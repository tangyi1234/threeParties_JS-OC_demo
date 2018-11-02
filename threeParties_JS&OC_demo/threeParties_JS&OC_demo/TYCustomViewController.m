//
//  TYCustomViewController.m
//  threeParties_JS&OC_demo
//
//  Created by 汤义 on 2018/11/1.
//  Copyright © 2018年 汤义. All rights reserved.
//

#import "TYCustomViewController.h"
#import "TYCustomObject.h"
#import <objc/runtime.h>
@interface TYCustomViewController ()

@end

@implementation TYCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addButView];
}

- (void)addButView{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.frame = CGRectMake(10, 100, 100, 30);
    but.backgroundColor = [UIColor redColor];
    [but setTitle:@"查看" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(selectorBut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}

- (void)selectorBut{
    //Person *p = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));
    //Method oriMethod = class_getInstanceMethod([TYCustomObject class], s);
    SEL s = NSSelectorFromString(@"customObject");
    [[objc_getClass("TYCustomObject") class] performSelector:s];
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
