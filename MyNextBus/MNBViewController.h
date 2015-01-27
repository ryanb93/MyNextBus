//
//  MNBViewController.h
//  MyNextBus
//
//  Created by Ryan Burke on 08/01/2014.
//  Copyright (c) 2014 Ryan Burke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CountdownViewController.h"
#import "DejalActivityView.h"

@interface MNBViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate> {
    
}

typedef enum {
    stops,
    routes
} TableType;

//IBOutlets
@property (weak, nonatomic) IBOutlet UIBarButtonItem *busIcon;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *busRouteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *busStopButton;
@property (weak, nonatomic) IBOutlet CountdownView *countdownView;

@property (strong, nonatomic) NSMutableArray *busStops;
@property (strong, nonatomic) NSMutableArray *busRoutes;

//Views
@property (strong, nonatomic) UITableView *busStopTable;

-(IBAction)showBusStops:(id)sender;
-(IBAction)showBusRoutes:(id)sender;
-(IBAction)dismissListView:(id)sender;

@end
