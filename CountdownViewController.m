//
//  CountdownViewController.m
//  MyNextBus
//
//  Created by Ryan Burke on 09/01/2014.
//  Copyright (c) 2014 Ryan Burke. All rights reserved.
//

#import "CountdownViewController.h"

@interface CountdownViewController ()

@end

@implementation CountdownViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear");
    [self.countdownView pauseLayer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.countdownView resumeLayer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
