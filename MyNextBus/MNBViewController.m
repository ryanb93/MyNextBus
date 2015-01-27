//
//  MNBViewController.m
//  MyNextBus
//
//  Created by Ryan Burke on 08/01/2014.
//  Copyright (c) 2014 Ryan Burke. All rights reserved.
//

#import "MNBViewController.h"

@interface MNBViewController () {
    NSString *currentStop;
    NSString *currentRoute;
    BOOL busStopIsVisisble;
    TableType tableType;
    CLLocationManager *locationManager;

}

@end

@implementation MNBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //Set the navigation bar title.
        [self setTitle:@"Next Bus"];

        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        
        busStopIsVisisble = NO;
        
            
        _busStops = [NSMutableArray arrayWithObjects:@"Warlingham Green", @"Church Road", @"Hamsey Green", @"Sanderstead", nil];
        
        _busRoutes = [NSMutableArray arrayWithObjects:@"403", @"412", @"407", @"409", nil];
                
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        screenRect.origin.y = screenRect.size.height;
        screenRect.size.height = 200;
        
        _busStopTable = [[UITableView alloc] initWithFrame:screenRect style:UITableViewStylePlain];
        [_busStopTable setDelegate:self];
        [_busStopTable setDataSource:self];
        [_busStopTable setUserInteractionEnabled:YES];
        [_busStopTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        
        [self.view addSubview:_busStopTable];
    }
    return self;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_countdownView pauseLayer];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_countdownView resumeLayer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Fetching times"].showNetworkActivityIndicator = YES;
    [self performSelector:@selector(stopSpinner) withObject:self afterDelay:3.0];
}

-(void)stopSpinner
{
    [DejalBezelActivityView removeViewAnimated:YES];
}

-(IBAction)showBusStops:(id)sender {
    if(!busStopIsVisisble) {
        tableType = stops;
        [self.busStopTable reloadData];
        [self busStopViewShouldBeVisisble:YES];
    }
    else {
        if(tableType == stops) {
            [self busStopViewShouldBeVisisble:NO];
        }
        tableType = stops;
        [self.busStopTable reloadData];
    }
}

-(IBAction)showBusRoutes:(id)sender {
    if(!busStopIsVisisble) {
        tableType = routes;
        [self.busStopTable reloadData];
        [self busStopViewShouldBeVisisble:YES];
    }
    else {
        if(tableType == routes) {
            [self busStopViewShouldBeVisisble:NO];
        }
        tableType = routes;
        [self.busStopTable reloadData];
    }
}

-(IBAction)dismissListView:(id)sender
{
    if(busStopIsVisisble) {
        [self busStopViewShouldBeVisisble:NO];
    }
}

-(void)busStopViewShouldBeVisisble:(BOOL)visisble
{
    int slideDistance = 200;
    if(!visisble) slideDistance = -200;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setBounds:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + slideDistance, self.view.bounds.size.width, self.view.bounds.size.height)];
    [UIView commitAnimations];
    busStopIsVisisble = visisble;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableType == stops)
        return [_busStops count];
    
    return [_busRoutes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSString *text = [_busStops objectAtIndex:[indexPath row]];
    if(tableType == routes)
        text = [_busRoutes objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:text];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If the stop has changed.
    if(tableType == stops) {
        NSString *selected = [_busStops objectAtIndex:[indexPath row]];
        [_busStopButton setTitle:selected];
        if(currentStop != selected) {
            currentStop = selected;
            //Get the time for the next bus from this bus stop.
            //Set the countdown view.
            NSUInteger minutes = rand() % 9 + 1;
            [_countdownView startCountdown:minutes forRoute:currentRoute];
        }
        [self showBusStops:tableView];
    }
    else if(tableType == routes) {
        NSString *selected = [_busRoutes objectAtIndex:[indexPath row]];
        [_busRouteButton setTitle:selected];
        if(currentRoute != selected) {
            currentRoute = selected;
            //Get the time for the next bus from this bus stop.
            //Set the countdown view.
            NSUInteger minutes = rand() % 9 + 1;
            [_countdownView startCountdown:minutes forRoute:currentRoute];
        }
        [self showBusRoutes:tableView];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(CountdownViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(CountdownViewController *)viewController index];
    
    
    index++;
    
    if (index == 5) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (CountdownViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    CountdownViewController *childViewController = [[CountdownViewController alloc] init];
    childViewController.index = index;
    
    return childViewController;
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *lastest = [locations lastObject];
    [manager stopUpdatingLocation];
}

@end
