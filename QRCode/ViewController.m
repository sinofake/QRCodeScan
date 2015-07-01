//
//  ViewController.m
//  SSQRCodeScan
//
//  Created by zhucuirong on 14/12/22.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "ViewController.h"
#import "QRCodeScanViewController.h"

@interface ViewController ()<QRCodeScanViewControllerDelegate>

@end

@implementation ViewController

- (void)createScanButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = (CGRect){CGPointZero, 44, 100};
    button.center = self.view.center;
    [button setTitle:@"扫描" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(scanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)scanButtonClick:(UIButton *)sender {
    QRCodeScanViewController *vc = [[QRCodeScanViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createScanButton];
}

#pragma mark -o QRCodeScanViewControllerDelegate
- (void)QRCodeScanViewController:(QRCodeScanViewController *)viewController didScanContent:(NSString *)content {
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:content delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [av show];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
