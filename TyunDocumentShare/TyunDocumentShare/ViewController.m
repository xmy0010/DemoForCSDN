//
//  ViewController.m
//  TyunDocumentShare
//
//  Created by T_yun on 2018/12/13.
//  Copyright © 2018年 tangyun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileNotification:) name:@"FileNotification" object:nil];

}


- (void)fileNotification:(NSNotification *)notifcation {
    NSDictionary *info = notifcation.userInfo;
    // fileName是文件名称、filePath是文件存储在本地的路径
    // jfkdfj123a.pdf
    NSString *fileName = [info objectForKey:@"fileName"];
    // /private/var/mobile/Containers/Data/Application/83643509-E90E-40A6-92EA-47A44B40CBBF/Documents/Inbox/jfkdfj123a.pdf
    NSString *filePath = [info objectForKey:@"filePath"];
    
    
    //本地文件的绝对路径
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:url];
    interactionController.delegate = self;
    
    //预览有其他软件打开按钮
    [interactionController presentPreviewAnimated:NO];
    
    CGRect navRect = self.navigationController.navigationBar.frame;
    navRect.size =CGSizeMake(1500.0f,40.0f);
    
    //直接显示包含预览的菜单项
    [interactionController presentOpenInMenuFromRect:navRect inView:self.view animated:YES];
    
}


-(UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller{
    return self;
}
-(UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller{
    return self.view;
}
-(CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller{
    return  self.view.frame;
}


@end
