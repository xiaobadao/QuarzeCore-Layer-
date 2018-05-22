//
//  ViewController.m
//  ocdemo
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ocdemo-Swift.h"
#import <QuartzCore/QuartzCore.h>
#import "ReflectionView.h"
#import "ScrollerView.h"
#import <GLKit/GLKit.h>

@interface ViewController ()<CALayerDelegate>
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) EAGLContext *glContext;
@property (nonatomic, strong) CAEAGLLayer *glLayer;
@property (nonatomic, assign) GLint frameBuffer;
@property (nonatomic, assign) GLint colorRenderBuffer;
@property (nonatomic, assign) GLint frameBufferWidth;
@property (nonatomic, assign) GLint frameBufferHeight;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

@implementation ViewController
- (void) printOc{
    NSLog(@"print oc method");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self systemCAGradientLayer];
//    [self systemCAReplicatiorLayer];
//    [self systemReflector];
//    [self systemScrollView];
//    [self systemCATiledLayer];
//    [self systemCAEmiterLayer];
    [self systemCAEAGLLayer];
}
#pragma
- (void)systemCAEAGLLayer{
    self.glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:self.glContext];
    
    self.glLayer = [CAEAGLLayer layer];
    self.glLayer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:self.glLayer];
    
    self.glLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking:@NO,
                                        kEAGLDrawablePropertyColorFormat:kEAGLColorFormatRGBA8
                                        };
    self.effect = [[GLKBaseEffect alloc] init];
    [self setupBuffers];
    [self drawFrame];
}
- (void)setupBuffers{
   
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    [self.glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:self.glLayer];
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &_frameBufferWidth);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &_frameBufferHeight);
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failture");
    }
}
- (void)tearDownBuffers{
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    if (_colorRenderBuffer) {
        glDeleteRenderbuffers(1, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
}
- (void)drawFrame{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, _frameBufferWidth, _frameBufferHeight);
    [self.effect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    glClearColor(0.0, 0.0, 0.0, 1.0);
    
    GLfloat vertices[] = {
      -0.5f,-0.5f,-1.0f,0.0f,0.5f,-1.0f,0.5f,-0.5f,-1.0f,
    };
    CGFloat colors[] = {
      0.0f,0.0f,1.0f,1.0f,0.0f,1.0f,0.0f,1.0f,1.0f,0.0f,0.0f,1.0f,
    };
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, colors);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [self.glContext presentRenderbuffer:GL_RENDERBUFFER];
}
-(void)dealloc{
    [self tearDownBuffers];
    [EAGLContext setCurrentContext:nil];
}
- (void)viewDidUnload{
    [self tearDownBuffers];
    [super viewDidUnload];
}
#pragma
- (void)systemCAEmiterLayer{
    CAEmitterLayer *layer = [CAEmitterLayer layer];
    layer.frame = self.contentView.bounds;
    [self.contentView.layer addSublayer:layer];
    
    layer.renderMode = kCAEmitterLayerAdditive;
    layer.emitterMode = kCAEmitterLayerCircle ;
    layer.emitterPosition = CGPointMake(layer.frame.size.width/2.0, layer.frame.size.height/2.0);
    
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"spark.png"].CGImage;
    cell.birthRate = 100;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.1 blue:0.5 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI*2.0;
    
    layer.emitterCells = @[cell];
}
- (void)systemCATiledLayer{
    CATiledLayer *titleLayer = [CATiledLayer layer];
    titleLayer.frame = CGRectMake(0, 0, 2048, 2048);
    titleLayer.delegate = self;
    titleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.scrollView.layer addSublayer:titleLayer];
    
    self.scrollView.contentSize = titleLayer.frame.size;
    [titleLayer setNeedsDisplay];
}
- (void)drawLayer:(CATiledLayer *)layer inContext:(CGContextRef)ctx{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGRect bounds = CGContextGetClipBoundingBox(ctx);
    NSInteger x = floor(bounds.origin.x/layer.tileSize.width *scale);
    NSInteger y = floor(bounds.origin.y/layer.tileSize.height *scale);
    
    NSString *imageName = [NSString stringWithFormat:@"qw_%02i_%02i",x,y];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    UIGraphicsPushContext(ctx);
    [image drawInRect:bounds];
    UIGraphicsPopContext();
}
- (void)systemScrollView{
    ScrollerView *view =[[NSBundle mainBundle] loadNibNamed:@"ScrollerView" owner:self options:nil].firstObject;
//    [[ScrollerView alloc] initWithFrame:CGRectMake(50, 100, [UIScreen mainScreen].bounds.size.width-100, 300)];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
}
- (void)systemReflector{
    ReflectionView *view = [[NSBundle mainBundle] loadNibNamed:@"ReflectionView" owner:self options:nil].firstObject;
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
}
- (void)systemCAReplicatiorLayer{
    CAReplicatorLayer *replicatiorLayer = [CAReplicatorLayer layer];
    replicatiorLayer.frame = self.view.bounds;
//    replicatiorLayer.backgroundColor = [UIColor yellowColor].CGColor;
    [self.view.layer addSublayer:replicatiorLayer];
    
    replicatiorLayer.instanceCount = 10;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI/5.0, 0, 0, 1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicatiorLayer.instanceTransform = transform;
    
    replicatiorLayer.instanceRedOffset = -0.1f;
    replicatiorLayer.instanceBlueOffset = -0.1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100, 100, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [replicatiorLayer addSublayer:layer];
}
- (void)systemCAGradientLayer{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(100, 100, 100, 100);
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor,(__bridge id)[UIColor greenColor].CGColor];
    gradientLayer.locations = @[@0.3,@0.5,@0.7];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    [self.view.layer addSublayer:gradientLayer];
}
- (void)systemCATransformLayer{
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0/500.0;
    self.view.layer.sublayerTransform = pt;
    
    CATransform3D c1t = CATransform3DIdentity;
    c1t = CATransform3DTranslate(c1t, -100, 0, 0);
    c1t = CATransform3DRotate(c1t, -M_PI_4, 1, 0, 0);
    c1t = CATransform3DRotate(c1t, M_PI_4, 0, 0, 1);
    CALayer *cube1 = [self cubeWithTransform:c1t];
    [self.view.layer addSublayer:cube1];
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 100, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_2, 0, 1, 0);
    CALayer *cub2 = [self cubeWithTransform:c2t];
    [self.view.layer addSublayer:cub2];
}
- (CALayer *)faceWithTransform:(CATransform3D)transform{
    
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(-50, -50, 100, 100);
    face.backgroundColor = [UIColor colorWithRed:(rand()/(double)INT_MAX) green:(rand()/(double)INT_MAX) blue:(rand()/(double)INT_MAX) alpha:1.0].CGColor;
    face.transform = transform;
    return face;
}
- (CALayer *)cubeWithTransform:(CATransform3D)transform{
    
    CATransformLayer *cube = [CATransformLayer layer];
//    add face 1
    CATransform3D ct = CATransform3DMakeTranslation(0, 0, 50);
    [cube addSublayer:[self faceWithTransform:ct]];
//    add face 2
    ct = CATransform3DMakeTranslation(50, 0, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
//    add face 3
    ct = CATransform3DMakeTranslation(0, -50, 0);
    ct = CATransform3DRotate(ct, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
//    add face 4
    ct = CATransform3DMakeTranslation(0, 50, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
//    add face 5
    ct = CATransform3DMakeTranslation(-50, 0, 0);
    ct = CATransform3DRotate(ct, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
//    add face 6
    ct = CATransform3DMakeTranslation(0, 0, -50);
    ct = CATransform3DRotate(ct, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:ct]];
    
    cube.position = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    cube.transform = transform;
    return cube;
}

- (void)animation{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 50)];
    lable.text = @"中华好伟大";
    lable.textColor = [UIColor blueColor];
    lable.backgroundColor = [UIColor grayColor];
    [UIView transitionWithView:lable duration:1 options:UIViewAnimationOptionAutoreverse animations:^{
        
        lable.frame = CGRectMake(10, 380, 200, 50);
    } completion:^(BOOL finished) {
        lable.frame = CGRectMake(100, 200, 200, 50);
    }];
    [self.view addSubview:lable];
}
- (void)systemTextLayer{
    CATextLayer *textLayer =  [CATextLayer layer];
    textLayer.fontSize = 20;
    textLayer.backgroundColor = [UIColor grayColor].CGColor;
    //    textLayer.affineTransform = CGAffineTransformMakeRotation(10);
    textLayer.anchorPoint = CGPointMake(0.2, 0.5);
    //    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsGravity = kCAGravityCenter;
    //    textLayer.contentsScale = .9f;
    
    textLayer.frame = CGRectMake(10, 50, 200, 50);
    textLayer.string = @"中华好伟大,中华好伟大,中华好伟大";
    textLayer.foregroundColor = [UIColor blueColor].CGColor;
    [self.view.layer addSublayer:textLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
