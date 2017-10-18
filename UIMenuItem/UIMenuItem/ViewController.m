//
//  ViewController.m
//  UIMenuItem
//
//  Created by HHL on 16/6/27.
//  Copyright © 2016年 HHL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
{
    CGPoint menuPoint;
}
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
    [longPressGesture setDelegate:self];
    [self.label addGestureRecognizer:longPressGesture];
}
-(void)longTap:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self.contentView resignFirstResponder];
    NSLog(@"[%s]",__FUNCTION__);
    if ([gestureRecognizer state]==UIGestureRecognizerStateEnded)
    {
        menuPoint = [gestureRecognizer locationInView:self.view];
        [self showMenu:menuPoint];
    }
}
-(void)showMenu:(CGPoint)point
{
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO];
    
    UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuItem:)];
    UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"备注" action:@selector(menuItem1:)];
    UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"更多" action:@selector(menuItem2:)];
    [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,nil]];
    
    [menuController setTargetRect:CGRectMake(point.x, point.y, 0, 0) inView:self.view];
    [menuController setMenuVisible:YES animated:YES];
    
}
-(void)menuItem:(id)sender
{
    UIPasteboard *pasteBoard=[UIPasteboard generalPasteboard];
    pasteBoard.string=self.label.text;
    NSLog(@"%@",pasteBoard.string);
}
-(void)menuItem1:(id)sender
{
    NSLog(@"%@--备注事件",sender);
}
-(void)menuItem2:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setMenuVisible:NO];
    
    UIMenuItem *menuItem1 = [[UIMenuItem alloc] initWithTitle:@"<<" action:@selector(menuItem3:)];
    UIMenuItem *menuItem2 = [[UIMenuItem alloc] initWithTitle:@"撤销" action:@selector(menuItem:)];
    UIMenuItem *menuItem3 = [[UIMenuItem alloc] initWithTitle:@"标记" action:@selector(menuItem:)];
    [menuController setMenuItems:[NSArray arrayWithObjects:menuItem1,menuItem2,menuItem3,nil]];
    
    [menuController setTargetRect:CGRectMake(menuPoint.x, menuPoint.y, 0, 0) inView:self.view];
    [menuController setMenuVisible:YES animated:YES];
}
-(void)menuItem3:(id)sender
{
    [self showMenu:menuPoint];
}
-(void)noteMenuAct:(UIMenuController *)controller{
    NSLog(@"------[%s]",__FUNCTION__);
}

// 用于UIMenuController显示，缺一不可
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
/**
 判断下textview 或者textfield是不是响应了
 不响应时候 并且是定义的方法 返回YES 其他返回NO
 NO
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (!self.contentView.isFirstResponder)
    {
        if (action == @selector(menuItem:) ||
            action == @selector(menuItem1:) ||
            action == @selector(menuItem3:)||
            action == @selector(menuItem2:)
               )
        {
            return YES;
        }
        return NO;
    }else
    {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
