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
    BOOL busStopIsVisisble;
}

@end

@implementation MNBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        //Set the navigation bar title.
        [self setTitle:@"Next Bus"];
        //Init the bus stops array.
        
        busStopIsVisisble = NO;
        
        _busStops = [NSMutableArray arrayWithObjects:@"Warlingham Green", @"Church Road", @"Hamsey Green", @"Sanderstead", nil];
                
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Move to the bottom row.
    //    int row = [_busStopPickerView numberOfRowsInComponent:0] - 1;
    //    [_busStopPickerView selectRow:row inComponent:0 animated:NO];
    //    [self pickerView:_busStopPickerView didSelectRow:row inComponent:0];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(IBAction)showBusStops:(id)sender {
    if(!busStopIsVisisble) {
        [self busStopViewShouldBeVisisble:YES];
    }
    else if([sender isKindOfClass:[UIBarButtonItem class]] || [sender isKindOfClass:[UITableView class]]) {
        if(busStopIsVisisble) {
            [self busStopViewShouldBeVisisble:NO];
        }
    }
    
}

-(IBAction)hideBusStops:(id)sender {
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
    return [_busStops count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    
    [[cell textLabel] setText:[_busStops objectAtIndex:[indexPath row]]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedStop = [_busStops objectAtIndex:[indexPath row]];
    [_busStopButton setTitle:selectedStop];
    [self showBusStops:tableView];
    //If the stop has changed.
    if(currentStop != selectedStop) {
        currentStop = selectedStop;
        //Get the time for the next bus from this bus stop.
        //Set the countdown view.
        NSUInteger minutes = rand() % 9 + 1;
        NSString *route = @"403";
        [_countdownView startCountdown:minutes forRoute:route];
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

@end
