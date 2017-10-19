//
//  ViewController.m
//  Heart-Emitter-View-iOS
//
//  Created by Ngo Than Phong on 3/11/17.
//  Copyright © 2017 kthangtd. All rights reserved.
//

#import "ViewController.h"
#import "HeartEmitterView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet HeartEmitterView * emitterView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(emitHeart)
                                   userInfo:nil
                                    repeats:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max {
    return min + arc4random_uniform(max - min + 1);
}

- (IBAction)emitButtonClicked:(UIButton *)sender {
    [self emitHeart];
}

- (void)emitHeart {
    NSInteger idx = [self randomNumberBetween:1 maxNumber:5];
    UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"heart%d", (int)idx]];
    [self.emitterView emitImage:image];
}

@end
