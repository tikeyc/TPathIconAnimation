//
//  ESPathIconAnimationView.m
//  Estate
//
//  Created by tikeyc on 14-5-23.
//  Copyright (c) 2014年 tikeyc. All rights reserved.
//

#import "ESPathIconAnimationView.h"
#import "ESPathIcon.h"
#import <AVFoundation/AVFoundation.h>
#define bigIcon_R 176
#define nearbyIcon_R 40
#define farIcon_R 20
#define xGap 5

@implementation ESPathIconAnimationView

{
    SystemSoundID soundID;
    
    ShopType _shopType;
    
    UIButton *_bigIcon;
    ESPathIcon *_pathIcon1;
    ESPathIcon *_pathIcon2;
    ESPathIcon *_pathIcon3;
    ESPathIcon *_pathIcon4;
    
    BOOL _isDoubleClickIcon;//解决同时点击多个icon的BUG
    
    NSMutableArray *_pathIcons;
    BOOL _isOpenIcon;
    
    CAKeyframeAnimation *animationOpen;
    CAKeyframeAnimation *animationClose;
}

- (id)initWithFrame:(CGRect)frame withShowType:(ShopType)shopType
{
    self = [super initWithFrame:frame];
    if (self) {
        _shopType = shopType;
        _isOpenIcon = YES;
        //注册一个系统声音
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"get_notification" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        //播放系统声音提示用户
        AudioServicesPlaySystemSound(soundID);
        //震动
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //
    _bigIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = nil;
    if (_shopType == SHOP) {
        image = [UIImage imageNamed:@"main_path_shop.png"];
    }else if (_shopType == BUILDING) {
        image = [UIImage imageNamed:@"main_path_building.png"];
    }else if (_shopType == WORKSHOP) {
        image = [UIImage imageNamed:@"main_Path_workshop.png"];
    }else if (_shopType == BUSINESS){
        image = [UIImage imageNamed:@"main_path_business.png"];
    }
    [_bigIcon setImage:image forState:UIControlStateNormal];
    _bigIcon.userInteractionEnabled = NO;
    [_bigIcon addTarget:self action:@selector(bigIconClick:) forControlEvents:UIControlEventTouchUpInside];
    _bigIcon.showsTouchWhenHighlighted = YES;
    if (_shopType == SHOP) {
        _bigIcon.frame = CGRectMake(self.width - 170/2 - xGap, xGap, 170/2, 170/2);
    }else if (_shopType == BUILDING){
        _bigIcon.frame = CGRectMake(xGap, self.height - 170/2 - xGap, 170/2, 170/2);
    }else if (_shopType == WORKSHOP){
        _bigIcon.frame = CGRectMake(self.width - 170/2 - xGap, self.height - 170/2 - xGap, 170/2, 170/2);
    }else if (_shopType == BUSINESS){
        _bigIcon.frame = CGRectMake(xGap, xGap, 170/2, 170/2);
    }
    
    [self addSubview:_bigIcon];

    //
    NSMutableArray *imgName,*titles;
    if (_shopType == BUSINESS) {
        imgName = [NSMutableArray arrayWithObjects:@"main_zhuan.png",@"main_overllsell.png",@"main_letOut.png",@"main_buy.png", nil];
        titles = [NSMutableArray arrayWithObjects:@"转让",@"出售",@"求租",@"求购", nil];
    }else{
         imgName = [NSMutableArray arrayWithObjects:@"main_rent.png",@"main_overllsell.png",@"main_letOut.png",@"main_buy.png", nil];
         titles = [NSMutableArray arrayWithObjects:@"出租",@"出售",@"求租",@"求购", nil];
    }
    
    if (_shopType != SHOP && _shopType != BUSINESS) {
        imgName = [THelper exchangeArrayItem:imgName];
        titles = [THelper exchangeArrayItem:titles];
    }
    __weak ESPathIconAnimationView *this = self;
    long int count = imgName.count - 1;
    _pathIcons = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        __block ESPathIcon *pathIcon = [[ESPathIcon alloc] initWithImageName:imgName[i] withLabelTitle:titles[i]];
        float offx = [THelper cos:(90/count)*i];
        float offy = [THelper sin:(90/count)*i];
        if (_shopType == SHOP) {
            pathIcon.endPoint = CGPointMake(_bigIcon.center.x - bigIcon_R*offx, _bigIcon.center.y + bigIcon_R*offy);
            //动画中间 较远点
            pathIcon.farPoint = CGPointMake(pathIcon.endPoint.x - farIcon_R*offx, pathIcon.endPoint.y + farIcon_R*offy);
            //动画中间较近点
            pathIcon.nearbyPoint = CGPointMake(pathIcon.endPoint.x + nearbyIcon_R*offx, pathIcon.endPoint.y - nearbyIcon_R*offy);
        }else if (_shopType == BUILDING){
            pathIcon.endPoint = CGPointMake(_bigIcon.center.x + bigIcon_R*offx, _bigIcon.center.y - bigIcon_R*offy);
            //动画中间 较远点
            pathIcon.farPoint = CGPointMake(pathIcon.endPoint.x + farIcon_R*offx, pathIcon.endPoint.y - farIcon_R*offy);
            //动画中间较近点
            pathIcon.nearbyPoint = CGPointMake(pathIcon.endPoint.x - nearbyIcon_R*offx, pathIcon.endPoint.y + nearbyIcon_R*offy);
        }else if (_shopType == WORKSHOP){
            pathIcon.endPoint = CGPointMake(_bigIcon.center.x - bigIcon_R*offx, _bigIcon.center.y - bigIcon_R*offy);
            //动画中间 较远点
            pathIcon.farPoint = CGPointMake(pathIcon.endPoint.x - farIcon_R*offx, pathIcon.endPoint.y - farIcon_R*offy);
            //动画中间较近点
            pathIcon.nearbyPoint = CGPointMake(pathIcon.endPoint.x + nearbyIcon_R*offx, pathIcon.endPoint.y + nearbyIcon_R*offy);
        }else if (_shopType == BUSINESS){
            pathIcon.endPoint = CGPointMake(_bigIcon.center.x + bigIcon_R*offx, _bigIcon.center.y + bigIcon_R*offy);
            //动画中间 较远点
            pathIcon.farPoint = CGPointMake(pathIcon.endPoint.x + farIcon_R*offx, pathIcon.endPoint.y + farIcon_R*offy);
            //动画中间较近点
            pathIcon.nearbyPoint = CGPointMake(pathIcon.endPoint.x - nearbyIcon_R*offx, pathIcon.endPoint.y - nearbyIcon_R*offy);
        }
        pathIcon.center = _bigIcon.center;
        [_pathIcons addObject:pathIcon];
        //动画起始点
        pathIcon.startPoint = _bigIcon.center;
        //
        if (_shopType == BUSINESS) {
            if (i == 1 || i == 3) {
                pathIcon.hidden = YES;
                [_pathIcons removeObject:pathIcon];
            }
        }
        if (i == 0) {
            _pathIcon1 = pathIcon;
        }else if (i == 1){
            _pathIcon2 = pathIcon;
        }else if (i == 2){
            _pathIcon3 = pathIcon;
        }else if (i == 3){
            _pathIcon4 = pathIcon;
        }
        
        pathIcon.block = ^(id result){
            if (_isDoubleClickIcon) {//解决同时点击多个icon的BUG
                return;
            }//不重置_isDoubleClickIcon是因为动画完后，视图已近销毁
            _isDoubleClickIcon = YES;
            //
            [UIView animateWithDuration:0.2 animations:^{
                _bigIcon.transform = CGAffineTransformMakeScale(0.2, 0.2);
                _bigIcon.alpha = 0.3;
            } completion:^(BOOL finished) {
                _bigIcon.hidden = YES;
            }];
            //
            for (ESPathIcon *pathIcons in _pathIcons) {
                if (pathIcons == result) {
                    [UIView animateWithDuration:0.2 animations:^{
                        pathIcons.transform = CGAffineTransformMakeScale(1.8, 1.8);
                        pathIcons.alpha = 0.3;
                    } completion:^(BOOL finished) {
                        pathIcons.hidden = YES;
                    }];
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        pathIcons.transform = CGAffineTransformMakeScale(0.2, 0.2);
                        pathIcons.alpha = 0.3;
                    } completion:^(BOOL finished) {
                        pathIcons.hidden = YES;
                    }];
                }
            }
            NSString *indexString = [NSString stringWithFormat:@"%d",i+10];
            if (_shopType != SHOP && _shopType != BUSINESS) {
                indexString = [NSString stringWithFormat:@"%lu",_pathIcons.count - 1 - i + 10];
            }
            [this performSelector:@selector(afteDelayRespodsToSelectorDelegate:) withObject:indexString afterDelay:0.3];
        };
        [self insertSubview:pathIcon belowSubview:_bigIcon];
    }
    [self addAnimationToIcon];
}
//延迟 等动画结束后 在调用其它方法（如：push）
- (void)afteDelayRespodsToSelectorDelegate:(NSString *)index{
    if ([self.delegate respondsToSelector:@selector(selectedIconIndex:withType:)]) {
        [self.delegate selectedIconIndex:[index intValue] withType:_shopType];
    }

}

- (void)bigIconClick:(UIButton *)button{
    NSLog(@"bigIconClick");
    if ([self.delegate respondsToSelector:@selector(selectedIconIndex:withType:)]) {
        [self.delegate selectedIconIndex:0 withType:0];
    }
}
//运行动画
- (void)addAnimationToIcon{
    //_bigIcon animation
    _bigIcon.userInteractionEnabled = NO;
    /*
    float angle = 0.0;
    if (_shopType == SHOP) {
        if (_isOpenIcon) {
            angle = -(90+45);
            [UIView animateWithDuration:animation_Time animations:^{
                _bigIcon.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
            }];
        }else{
            [UIView animateWithDuration:animation_Time animations:^{
                _bigIcon.transform = CGAffineTransformIdentity;
            }];
        }
        
    }else if (_shopType == BUILDING){
        if (_isOpenIcon) {
            angle = 45;
            [UIView animateWithDuration:animation_Time animations:^{
                _bigIcon.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
            }];
        }else{
            [UIView animateWithDuration:animation_Time animations:^{
                _bigIcon.transform = CGAffineTransformIdentity;
            }];
        }
        
    }else if (_shopType == WORKSHOP){
        if (_isOpenIcon) {
            angle = -45;
            [UIView animateWithDuration:animation_Time animations:^{
                _bigIcon.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
            }];
        }else{
            [UIView animateWithDuration:animation_Time animations:^{
                _bigIcon.transform = CGAffineTransformIdentity;
            }];
        }
        
    }
     */
    if (_isOpenIcon) {
//        [ESHelper exchangeArrayItem:_pathIcons];
    }else{//交换icon，使的收起时按（后——>先）顺序收起
        [THelper exchangeArrayItem:_pathIcons];
    }
    //_pathIcon animation
    for (int i = 0; i < _pathIcons.count; i++) {
        ESPathIcon *pathIcon = _pathIcons[i];
        if (_isOpenIcon) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path,NULL,pathIcon.startPoint.x,pathIcon.startPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.farPoint.x, pathIcon.farPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.nearbyPoint.x, pathIcon.nearbyPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.endPoint.x, pathIcon.endPoint.y);
            
            //创建 实例
            animationOpen = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animationOpen.delegate = self;
            //设置path属性
            animationOpen.path = path;
            CGPathRelease(path);
            [animationOpen setDuration:animation_Time];
            animationOpen.fillMode = kCAFillModeForwards;
            animationOpen.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            pathIcon.animation = animationOpen;
            [self performSelector:@selector(afterDelayAddAnimation:) withObject:pathIcon afterDelay:i*animation_Time_Gap];
        }else{
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, pathIcon.endPoint.x, pathIcon.endPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.nearbyPoint.x, pathIcon.nearbyPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.farPoint.x, pathIcon.farPoint.y);
            CGPathAddLineToPoint(path,NULL,pathIcon.startPoint.x,pathIcon.startPoint.y);
            
            //创建 实例
            animationClose = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animationClose.delegate = self;
            //设置path属性
            animationClose.path = path;
            CGPathRelease(path);
            [animationClose setDuration:animation_Time];
            animationClose.fillMode = kCAFillModeForwards;
            animationClose.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            pathIcon.animation = animationClose;
            [self performSelector:@selector(afterDelayAddAnimation:) withObject:pathIcon afterDelay:i*animation_Time_Gap];
            
        }
    }
    //延迟 等动画结束后在设置_isOpenIcon
    [self performSelector:@selector(setIsOpen) withObject:nil afterDelay:animation_Time + animation_Time_Gap*(_pathIcons.count - 1)];
}

- (void)setIsOpen{
    _isOpenIcon = !_isOpenIcon;
    _bigIcon.userInteractionEnabled = YES;
}
//一次先——>后顺序展开icon
- (void)afterDelayAddAnimation:(ESPathIcon *)pathIcon{
    if (_isOpenIcon) {
        [pathIcon.layer addAnimation:pathIcon.animation forKey:NULL];
        pathIcon.center = pathIcon.endPoint;
    }else{
        [pathIcon.layer addAnimation:pathIcon.animation forKey:NULL];
        pathIcon.center = pathIcon.startPoint;
    }
    
}

@end
