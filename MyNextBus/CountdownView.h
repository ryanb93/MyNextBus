//
//  CountdownView.h
//  MyNextBus
//
//  Created by Ryan Burke on 08/01/2014.
//  Copyright (c) 2014 Ryan Burke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownView : UIView

@property (assign, nonatomic) NSUInteger minutesLeft;
@property (strong, nonatomic) NSString *route;

-(BOOL)startCountdown:(NSUInteger)minutes forRoute:(NSString *)route;

-(void)pauseLayer;
-(void)resumeLayer;

@end
