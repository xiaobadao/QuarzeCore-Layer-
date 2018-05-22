//
//  ReflectionView.m
//  ocdemo
//
//  Created by apple on 2018/5/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ReflectionView.h"
#import <QuartzCore/QuartzCore.h>
@implementation ReflectionView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}
+ (Class)layerClass{
    return [CAReplicatorLayer class];
}
- (void)setup{
    CAReplicatorLayer *layer = (CAReplicatorLayer *)self.layer;
    layer.instanceCount = 2;
    
    CATransform3D ct = CATransform3DIdentity;
    CGFloat verticaloffset = self.bounds.size.height +2;
    ct = CATransform3DTranslate(ct, 0, verticaloffset, 0);
    ct = CATransform3DScale(ct, 1, -1, 0);
    layer.instanceTransform = ct;
    layer.instanceAlphaOffset = -0.6;
}

@end
