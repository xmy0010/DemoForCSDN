//
//  ViewController.m
//  littleFunctions
//
//  Created by zwzh_14 on 2021/9/23.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@interface ViewController ()<MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - 调用系统短信
- (IBAction)createMessage:(id)sender {
    //模拟电信查话费
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = @[@"10000"];
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = @"108";
        controller.messageComposeDelegate = self;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"查话费"];
    } else {
        NSLog(@"该设备不支持短信功能");
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"用户取消发送");
            break;
        default:
            break;
    }
}

@end
