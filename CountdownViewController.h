//
//  CountdownViewController.h
//  MyNextBus
//
//  Created by Ryan Burke on 09/01/2014.
//  Copyright (c) 2014 Ryan Burke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountdownView.h"

@interface CountdownViewController : UIViewController

@property (weak, nonatomic) CountdownView *countdownView;
@property (assign, nonatomic) NSInteger index;


@end
