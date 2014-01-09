//
//  MNBViewController.h
//  MyNextBus
//
//  Created by Ryan Burke on 08/01/2014.
//  Copyright (c) 2014 Ryan Burke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountdownViewController.h"

@interface MNBViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIPageViewControllerDataSource> {
    
}

//IBOutlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *busIcon;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *busStopButton;

@property (strong, nonatomic) NSMutableArray *busStops;

//Views
@property (strong, nonatomic) UITableView *busStopTable;
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) CountdownViewController *countdownViewController;

-(IBAction)showBusStops:(id)sender;
-(IBAction)hideBusStops:(id)sender;

@end
