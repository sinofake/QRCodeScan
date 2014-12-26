//
//  QRCodeUserHelpViewController.m
//  ElongClient
//
//  Created by zhucuirong on 14/12/15.
//  Copyright (c) 2014年 elong. All rights reserved.
//

#import "QRCodeUserHelpViewController.h"
#import "SSUtilityFunc.h"

@interface QRCodeUserHelpViewController ()
@property (nonatomic, strong) UIView *navBar;

@end

@implementation QRCodeUserHelpViewController

- (void)createNavBar {
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IOSVersion_7 ? 64.f : 44.f)];
    [self.view addSubview:_navBar];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.navBar.bounds];
    imageView.image = [UIImage imageNamed:@"sysNavBarBg"];
    [self.navBar addSubview:imageView];
    
    CGFloat height = 44.f;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, CGRectGetHeight(self.navBar.frame) - height, SCREEN_WIDTH - 100 * 2, height)];
    titleLabel.font = FONT_B18;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"使用帮助";
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.navBar addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, CGRectGetMinY(titleLabel.frame), 80, height);
    UIImage *backImg = [UIImage imageNamed:@"btn_navback_normal"];
    [backBtn setImage:backImg forState:UIControlStateNormal];
    backBtn.imageEdgeInsets = [SSUtilityFunc edgeInsetsWithType:SSEdgeInsetsTypeLeft viewSize:backBtn.frame.size subsidiaryViewSize:backImg.size margin:SS_VERTICAL_LENGTH(30) - 2];

    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBar addSubview:backBtn];
}

- (void)backButtonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createContent {
    UILabel *supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.navBar.frame.size.height + 20, SCREEN_WIDTH - 20, 20)];
    supportLabel.text = @"1.支持哪些二维码";
    supportLabel.font = FONT_16;
    supportLabel.textColor = [UIColor colorWithHexStr:@"0xe65749"];
    supportLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:supportLabel];
    
    UILabel *supportContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, supportLabel.frame.origin.y + supportLabel.frame.size.height, SCREEN_WIDTH - 20, 40)];
    supportContentLabel.text = @"    仅支持扫描艺龙网及其旗下网站火车网发布的二维码。";
    supportContentLabel.font = FONT_15;
    supportContentLabel.numberOfLines = 2;
    supportContentLabel.textColor = [UIColor colorWithHexStr:@"0x343434"];
    supportContentLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:supportContentLabel];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, supportContentLabel.frame.origin.y + supportContentLabel.frame.size.height + 20, SCREEN_WIDTH - 20, 20)];
    payLabel.font = supportLabel.font;
    payLabel.textColor = supportLabel.textColor;
    payLabel.text = @"2.网站扫码功能";
    payLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payLabel];
    
    UILabel *payCotentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,payLabel.frame.origin.y + payLabel.frame.size.height ,SCREEN_WIDTH - 20 ,60)];
    payCotentLabel.font = supportContentLabel.font;
    payCotentLabel.textColor = supportContentLabel.textColor;
    payCotentLabel.numberOfLines = 3;
    payCotentLabel.text = @"    使用电脑登录艺龙网或者火车网的指定页面，用户可通过扫码下载APP或直接打开APP对应的页面，获享相应优惠。";
    payCotentLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:payCotentLabel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexStr:@"0xf5f5f5"];
    
    [self createNavBar];
    
    [self createContent];
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
