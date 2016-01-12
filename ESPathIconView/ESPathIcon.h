//
//  ESPathIconView.h
//  Estate
//
//  Created by tikeyc on 14-5-23.
//  Copyright (c) 2014年 Andy li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CliciIconBlock) (id result);

@interface ESPathIcon : UIView

{
    CGPoint _startPoint;
    CGPoint _nearbyPoint;
    CGPoint _farPoint;
    CGPoint _endPoint;
    CAKeyframeAnimation *_animation;
}
@property (nonatomic,assign)CGPoint startPoint;
@property (nonatomic,assign)CGPoint nearbyPoint;
@property (nonatomic,assign)CGPoint farPoint;
@property (nonatomic,assign)CGPoint endPoint;
@property (nonatomic,strong)CAKeyframeAnimation *animation;
@property (nonatomic,copy)CliciIconBlock block;

- (id)initWithImageName:(NSString *)imageName withLabelTitle:(NSString *)title;

@end
