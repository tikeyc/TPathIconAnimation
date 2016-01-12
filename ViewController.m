//
//  ViewController.m
//  TPathIconAnimation
//
//  Created by tikeyc on 16/1/12.
//  Copyright © 2016年 tikeyc. All rights reserved.
//

#import "ViewController.h"

#import "ESPathIconAnimationView.h"
#import "ESPathIcon.h"

@interface ViewController ()<ESPathIconAnimationViewDelegate>

{
    ESPathIconAnimationView *_pathIconBusicessView;
    ESPathIconAnimationView *_pathIconShopView;
    ESPathIconAnimationView *_pathIconBuildView;
    ESPathIconAnimationView *_pathIconWorkShopView;
    
    UIView *_bgView;
    UITapGestureRecognizer *_tap;
    
    ShopType _shopType;
}

@end

#define XGap 5

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions Method

- (IBAction)typeButtonActions:(UIButton *)sender {

    if (_bgView != nil) {
        return;
    }
    if (_bgView == nil) {
        //
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _bgView.backgroundColor = RGBColorA(0, 0, 0, 0.7);
        [self.view addSubview:_bgView];
        //
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBgView:)];
        _tap.enabled = NO;//先禁用掉，防止多次点击，特别是动画还没结束
        [_bgView addGestureRecognizer:_tap];
        [self performSelector:@selector(setTapEnabled:) withObject:_tap afterDelay:animation_Time + animation_Time_Gap*3];
    }
    _bgView.hidden = NO;
    
    if (sender.tag == 0) {
        _shopType = BUSINESS;
        if (_pathIconBusicessView == nil) {
            _pathIconBusicessView = [[ESPathIconAnimationView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, _bgView.height) withShowType:_shopType];

            _pathIconBusicessView.delegate = self;
            [_bgView addSubview:_pathIconBusicessView];
        }else{
            _pathIconBusicessView.hidden = NO;
            _pathIconShopView.hidden = YES;
            _pathIconBuildView.hidden = YES;
            _pathIconWorkShopView.hidden = YES;
            [_pathIconShopView addAnimationToIcon];
        }
        
    }else {
        
        if (sender.tag == 1) {
            _shopType = SHOP;
            if (_pathIconShopView == nil) {
                _pathIconShopView = [[ESPathIconAnimationView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, _bgView.height) withShowType:_shopType];
               
                _pathIconShopView.delegate = self;
                [_bgView addSubview:_pathIconShopView];
            }else{
                _pathIconBusicessView.hidden = YES;
                _pathIconShopView.hidden = NO;
                _pathIconBuildView.hidden = YES;
                _pathIconWorkShopView.hidden = YES;
                [_pathIconShopView addAnimationToIcon];
            }
        }
        if (sender.tag == 2) {
            _shopType = BUILDING;
            if (_pathIconBuildView == nil) {
                _pathIconBuildView = [[ESPathIconAnimationView alloc] initWithFrame:_bgView.bounds withShowType:_shopType];
                _pathIconBuildView.delegate = self;
                [_bgView addSubview:_pathIconBuildView];
            }else{
                _pathIconBusicessView.hidden = YES;
                _pathIconShopView.hidden = YES;
                _pathIconBuildView.hidden = NO;
                _pathIconWorkShopView.hidden = YES;
                [_pathIconBuildView addAnimationToIcon];
            }
            
        }
        if (sender.tag == 3) {
            _shopType = WORKSHOP;
            if (_pathIconWorkShopView == nil) {
                _pathIconWorkShopView = [[ESPathIconAnimationView alloc] initWithFrame:_bgView.bounds withShowType:_shopType];
                _pathIconWorkShopView.delegate = self;
                [_bgView addSubview:_pathIconWorkShopView];
            }else{
                _pathIconBusicessView.hidden = YES;
                _pathIconShopView.hidden = YES;
                _pathIconBuildView.hidden = YES;
                _pathIconWorkShopView.hidden = NO;
                [_pathIconWorkShopView addAnimationToIcon];
            }
        }
    }
    
}
/**
 *  Description 先禁用掉，防止多次点击，特别是动画还没结束
 *
 *  @param tap
 */
- (void)setTapEnabled:(UITapGestureRecognizer *)tap{
    tap.enabled = YES;
}

- (void)hiddenBgView:(UITapGestureRecognizer *)tap{
    tap.enabled = NO;//先禁用掉，防止多次点击，特别是动画还没结束
    float delayTime = animation_Time+animation_Time_Gap*3;
    if (_shopType == SHOP) {
        [_pathIconShopView addAnimationToIcon];
        //        _pathIconShopView.hidden = !_pathIconShopView.hidden;
    }else if (_shopType == BUILDING){
        [_pathIconBuildView addAnimationToIcon];
        //        _pathIconBuildView.hidden = !_pathIconBuildView.hidden;
    }else if (_shopType == WORKSHOP){
        [_pathIconWorkShopView addAnimationToIcon];
        //        _pathIconWorkShopView.hidden = !_pathIconWorkShopView.hidden;
    }else if (_shopType == BUSINESS){
        [_pathIconBusicessView addAnimationToIcon];
        delayTime = animation_Time+animation_Time_Gap;
    }
    [self performSelector:@selector(afterDelayHiddenBgView:) withObject:tap afterDelay:delayTime];
}
/**
 *  Description 延迟隐藏 动画介绍需要时间
 *
 *  @param tap <#tap description#>
 */
- (void)afterDelayHiddenBgView:(UITapGestureRecognizer *)tap{
    if (_shopType == SHOP) {
        for (int i = 0; i < _pathIconShopView.subviews.count; i++) {
            UIView *view = _pathIconShopView.subviews[i];
            if (view.superview) {
                [view removeFromSuperview];
                view = nil;
            }
        }
        _pathIconShopView.hidden = !_pathIconShopView.hidden;
        if (_pathIconShopView.superview) {
            [_pathIconShopView removeFromSuperview];
            _pathIconShopView = nil;
        }
    }else if (_shopType == BUILDING){
        for (int i = 0; i < _pathIconBuildView.subviews.count; i++) {
            UIView *view = _pathIconBuildView.subviews[i];
            if (view.superview) {
                [view removeFromSuperview];
                view = nil;
            }
        }
        _pathIconBuildView.hidden = !_pathIconBuildView.hidden;
        if (_pathIconBuildView.superview) {
            [_pathIconBuildView removeFromSuperview];
            _pathIconBuildView = nil;
        }
    }else if (_shopType == WORKSHOP){
        for (int i = 0; i < _pathIconWorkShopView.subviews.count; i++) {
            UIView *view = _pathIconWorkShopView.subviews[i];
            if (view.superview) {
                [view removeFromSuperview];
                view = nil;
            }
        }
        _pathIconWorkShopView.hidden = !_pathIconWorkShopView.hidden;
        if (_pathIconWorkShopView.superview) {
            [_pathIconWorkShopView removeFromSuperview];
            _pathIconWorkShopView = nil;
        }
    }else if (_shopType == BUSINESS){
        for (int i = 0; i < _pathIconBusicessView.subviews.count; i++) {
            UIView *view = _pathIconBusicessView.subviews[i];
            if (view.superview) {
                [view removeFromSuperview];
                view = nil;
            }
        }
        _pathIconBusicessView.hidden = !_pathIconBusicessView.hidden;
        if (_pathIconBusicessView.superview) {
            [_pathIconBusicessView removeFromSuperview];
            _pathIconBusicessView = nil;
        }
        
    }
    _bgView.hidden = !_bgView.hidden;
    if (_bgView.superview) {
        [_bgView removeGestureRecognizer:_tap];
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
}



#pragma mark - ESPathIconAnimationViewDelegate

- (void)selectedIconIndex:(int)index withType:(ShopType)shopType{
    [self hiddenBgView:_tap];
    
    switch (shopType) {
        case BUSINESS:
            
            break;
        case SHOP:
            
            break;
        case BUILDING:
            
            break;
        case WORKSHOP:
            
            break;
        default:
            break;
    }
}




@end







