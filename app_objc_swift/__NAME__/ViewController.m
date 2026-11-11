//
//  ViewController.m
//  __NAME__
//
//  Created on __DATE__.
//

#import "ViewController.h"
// Swift classes marked @objc are exposed to Objective-C through the generated
// <ProductModuleName>-Swift.h header.
#import "__NAME__-Swift.h"

@interface ViewController ()

@property (nonatomic) NSInteger tapCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Greeter *greeter = [[Greeter alloc] init];
    self.greetingLabel.text = [greeter greetingFor:@"__NAME__"];
}

- (IBAction)buttonTapped:(UIButton *)sender {
    self.tapCount += 1;
    Greeter *greeter = [[Greeter alloc] init];
    self.greetingLabel.text = [greeter tappedMessage:self.tapCount];
}

@end
