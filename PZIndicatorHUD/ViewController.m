//
//  ViewController.m
//  PZIndicatorHUD
//
//  Created by lipzh7 on 2022/2/15.
//

#import "ViewController.h"
#import "PZToast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(100, 300, 100, 100);
        [button setTitle:@"Button" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
    [self.view addSubview:({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(250, 200, 100, 100);
        [button setTitle:@"imageButton" forState:UIControlStateNormal];
        [button setTitleColor:UIColor.labelColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showImageToast:) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
}

-(void) buttonClicked:(UIButton *) sender {
    NSLog(@"clicked");
    [PZToast showMessage:@"button Clicked"];
}

-(void) showImageToast:(UIButton *) sender {
//    NSLog(@"clicked");
//    [PZToast showMessage:@"button Clicked" withImage:@"sign" duration:5];
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"Please xxx" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"choose 1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"1");
//    }];
//    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"choose 2" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"2");
//    }];
//    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"choose 3" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"3");
//    }];
//    [alert addAction:firstAction];
//    [alert addAction:secondAction];
//    [alert addAction:thirdAction];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.placeholder = @"账户";
//    }];
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.placeholder = @"密码";
//        textField.secureTextEntry = YES;
//    }];
//    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
