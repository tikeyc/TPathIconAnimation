//
//  THelper.m
//  THomeIconAnimation
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "THelper.h"

@implementation THelper


+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (UIButton *)buttonsetIamgeWithFrame:(CGRect)frame
                                nfile:(NSString *)nfileName
                                sfile:(NSString *)sfileName
                                  tag:(NSInteger)buttonTag
                               action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setImage:[UIImage imageNamed:nfileName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:sfileName] forState:UIControlStateHighlighted];
    [button setTag:buttonTag];
    [button addTarget:nil action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

+ (NSMutableArray *)exchangeArrayItem:(NSMutableArray *)array{
    for (int i = 0; i < array.count/2; i++) {
        [array exchangeObjectAtIndex:i withObjectAtIndex:array.count -1 - i];
    }
    return array;
}

#pragma mark 度转弧度
+ (float)huDuFromdu:(float)du
{
    return M_PI/(180/du);
}

#pragma mark 计算sin
+ (float)sin:(float)du
{
    return sinf(M_PI/(180/du));
}

#pragma mark 计算cos
+ (float)cos:(float)du
{
    return cosf(M_PI/(180/du));
}

@end
