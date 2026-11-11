//
//  ViewController.m
//  __NAME__
//
//  Created on __DATE__.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) NSInteger tapCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.greetingLabel.text = @"Hello, __NAME__!";
}

- (IBAction)buttonTapped:(UIButton *)sender {
    self.tapCount += 1;
    self.greetingLabel.text = [NSString stringWithFormat:@"Tapped %ld time%@", (long)self.tapCount, self.tapCount == 1 ? @"" : @"s"];
}

@end
