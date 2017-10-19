//
//  HeartEmitterView.m
//  Heart-Emitter-View-iOS
//
//  Created by Ngo Than Phong on 3/11/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import "HeartEmitterView.h"

@interface HeartEmitterView ()

@property (nonatomic, assign) NSInteger amplitudeRange;

@property (nonatomic, assign) NSInteger amplitude;

@property (nonatomic, assign) CFTimeInterval duration;

@property (nonatomic, assign) CFTimeInterval durationRange;

@property (nonatomic, assign) NSInteger maximumCount;

@property (nonatomic, assign) NSInteger currentCount;

@property (nonatomic, strong) NSMutableArray * unusedLayers;

@end

@implementation HeartEmitterView

#pragma mark ---- < Init >

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.amplitudeRange = 3;
    self.amplitude = 12;
    
    self.duration = 4;
    self.durationRange = 1;
    
    self.maximumCount = 100;
    self.currentCount = 0;
    self.unusedLayers = [NSMutableArray array];
}

#pragma mark ---- < Deinit >

- (void)dealloc {
    [self.unusedLayers removeAllObjects];
    self.unusedLayers = nil;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (UIBezierPath *)getPathInRect:(CGRect)rect {
    CGFloat centerX = CGRectGetMidX(rect);
    CGFloat height = CGRectGetHeight(rect);
    UIBezierPath * path = [[UIBezierPath alloc] init];
    CGFloat offset = arc4random() % 1000;
    CGFloat finalAmplitude = self.amplitude + arc4random() % self.amplitudeRange * 2 - self.amplitudeRange;
    CGFloat delta = 0.0;
    CGFloat y = height;
    while (y >= 0) {
        CGFloat x = finalAmplitude * sinf((y + offset) * ((float)M_PI)/180.0);
        if (y == height) {
            delta = x;
            [path moveToPoint:CGPointMake(centerX, y)];
        } else {
            [path addLineToPoint:CGPointMake(x + centerX - delta, y)];
        }
        y -= 1;
    }
    return path;
}

- (void)emitImage:(UIImage *)image {
    if (self.currentCount >= self.maximumCount) {
        return;
    }
    
    self.currentCount += 1;
    
    const CGFloat height = CGRectGetHeight(self.bounds);
    const CGFloat percen = (float)(arc4random() % 100) / 100.0;
    const CGFloat duration = self.duration + percen * self.durationRange * 2 - self.durationRange;
    CALayer * layer;
    if (self.unusedLayers.count > 0) {
        layer = self.unusedLayers.lastObject;
        [self.unusedLayers removeLastObject];
    } else {
        layer = [[CALayer alloc] init];
    }
    
    layer.contents = (__bridge id _Nullable)(image.CGImage);
    layer.opacity = 1;
    layer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    layer.position = CGPointMake(CGRectGetMidX(self.bounds), height);
    [self.layer addSublayer:layer];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [layer removeFromSuperlayer];
        [self.unusedLayers addObject:layer];
        self.currentCount -= 1;
    }];
    
    CAKeyframeAnimation * position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    position.path = [self getPathInRect:self.bounds].CGPath;
    position.duration = duration;
    [layer addAnimation:position forKey:@"position"];
    
    const CGFloat delay = duration / 2;
    CABasicAnimation * opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = [NSNumber numberWithInt:1];
    opacity.toValue = [NSNumber numberWithInt:0];
    opacity.beginTime = CACurrentMediaTime() + delay;
    opacity.fillMode = kCAFillModeForwards;
    opacity.removedOnCompletion = NO;
    opacity.duration = duration - delay - 0.1;
    [layer addAnimation:opacity forKey:@"opacity"];
    
    [CATransaction commit];
}

@end
