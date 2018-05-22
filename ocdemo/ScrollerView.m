//
//  ScrollerView.m
//  ocdemo
//
//  Created by apple on 2018/5/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ScrollerView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ScrollerView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
+(Class)layerClass{
    return [CAScrollLayer class];
}
- (void)setupUI{
    self.layer.masksToBounds = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
}
- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint offset = self.bounds.origin;
    offset.x -= [pan translationInView:self].x;
    offset.y -= [pan translationInView:self].y;
    
    [(CAScrollLayer *)self.layer scrollToPoint:offset];
    
    [pan setTranslation:CGPointZero inView:self];
}
@end
