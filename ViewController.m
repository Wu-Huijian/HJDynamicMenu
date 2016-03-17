//
//  ViewController.m
//  HJDynamicMenu
//
//  Created by WHJ on 16/3/15.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import "ViewController.h"
#import "HJDynamicMenu.h"
@interface ViewController ()




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSArray *colors = @[[UIColor yellowColor],[UIColor greenColor],[UIColor grayColor],[UIColor blueColor]];
    NSArray *texts = @[@"概要",@"收益",@"详情",@"更多"];
    NSArray *positons = @[[NSValue valueWithCGPoint:CGPointMake(self.view.center.x-100, self.view.center.y)],
                          [NSValue valueWithCGPoint:CGPointMake(self.view.center.x+100, self.view.center.y)],[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y-100)],[NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y+100)]];

    HJDynamicMenu *menu = [[HJDynamicMenu alloc]initWithPoint:self.view.center width:40 optionColors:nil optionBackgroundImages:nil texts:texts];
    menu.positions = positons;
    [self.view addSubview:menu];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
