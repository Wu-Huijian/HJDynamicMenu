//
//  HJDynamicMenu.h
//  HJDynamicMenu
//
//  Created by WHJ on 16/3/15.
//  Copyright © 2016年 WHJ. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HJDynamicMenuDelegate<NSObject>



@end


@interface HJDynamicMenu : UIButton
@property (nonatomic, strong) NSArray * positions;//position of options
@property (nonatomic ,strong) NSMutableArray *items;//customview of options

-(instancetype)initWithPoint:(CGPoint)point width:(CGFloat)width
                optionColors:(NSArray *)colors
      optionBackgroundImages:(NSArray *)images
                       texts:(NSArray *)texts;


-(instancetype)initWithPoint:(CGPoint)point width:(CGFloat)width
                 customItems:(NSArray *)items;
@end
