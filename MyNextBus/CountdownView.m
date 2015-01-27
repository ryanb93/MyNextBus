//
//  CountdownView.m
//  MyNextBus
//
//  Created by Ryan Burke on 08/01/2014.
//  Copyright (c) 2014 Ryan Burke. All rights reserved.
//

#import "CountdownView.h"

@interface CountdownView () {
}

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *minutesLabel;
@property (strong, nonatomic) UILabel *routeLabel;
@property (strong, nonatomic) CAShapeLayer *whiteCircle;
@property (strong, nonatomic) CAShapeLayer *progressCircle;

@end

@implementation CountdownView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    //Init properties
    [self setWhiteCircle:[CAShapeLayer layer]];
    [self setProgressCircle:[CAShapeLayer layer]];
    
    //Set background color.
    [self setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    //Set up our circles
    _progressCircle.fillColor = [UIColor clearColor].CGColor;
    _progressCircle.strokeColor = [UIColor greenColor].CGColor;
    _progressCircle.lineWidth = 25;
    _whiteCircle.fillColor = [UIColor clearColor].CGColor;
    _whiteCircle.strokeColor = [UIColor whiteColor].CGColor;
    _whiteCircle.lineWidth = 25;

    
    //Create UILabel and center it.
    [self setMinutesLabel:[[UILabel alloc] initWithFrame:self.bounds]];
    [_minutesLabel setFont:[UIFont systemFontOfSize:40]];
    
    _minutesLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    _minutesLabel.textAlignment = NSTextAlignmentCenter;
    
    //Create UILabel and center it.
    [self setRouteLabel:[[UILabel alloc] initWithFrame:self.bounds]];
    [_routeLabel setFont:[UIFont systemFontOfSize:32]];
    _routeLabel.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + 40);
    _routeLabel.textAlignment = NSTextAlignmentCenter;
    [_minutesLabel addSubview:_routeLabel];
    [self addSubview:_minutesLabel];
    
}

/**
 * Method which gets called when the device is rotated.
 * Resize our circles.
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    //Get the bounds of the new view.
    CGRect rect = self.bounds;
    //Center the minutes label.
    _minutesLabel.center = CGPointMake(rect.size.width/2, rect.size.height/2 - 10);
    
    //Get the two radius values for the height at width.
    int hRadius = rect.size.height/2.5;
    int radius = rect.size.width/2.5;
    //If the height is smaller than width, use smaller radius.
    if(hRadius < radius) {
        radius = hRadius;
    }
    
    //Resize the cirlces.
    _progressCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                              cornerRadius:radius].CGPath;
    _progressCircle.position = CGPointMake(CGRectGetMidX(rect)-radius,
                                   CGRectGetMidY(rect)-radius);
    _whiteCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                      cornerRadius:radius].CGPath;
    _whiteCircle.position = CGPointMake(CGRectGetMidX(rect)-radius,
                                           CGRectGetMidY(rect)-radius);
}

- (void)drawRect:(CGRect)rect
{
    // Set up the shape of the circle
    int radius = rect.size.width/2.5;
    // Make a circular shape TODO: put this into a method?
    _progressCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                      cornerRadius:radius].CGPath;
    _progressCircle.position = CGPointMake(CGRectGetMidX(rect)-radius,
                                           CGRectGetMidY(rect)-radius);
    _whiteCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                                   cornerRadius:radius].CGPath;
    _whiteCircle.position = CGPointMake(CGRectGetMidX(rect)-radius,
                                        CGRectGetMidY(rect)-radius);

    [self.layer insertSublayer:_whiteCircle atIndex:0];
}

-(void)pauseLayer
{
    CALayer *layer = _progressCircle;
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

-(void)resumeLayer
{
    CALayer *layer = _progressCircle;
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}

-(BOOL)startCountdown:(NSUInteger)minutes forRoute:(NSString *)route
{
    [self.layer insertSublayer:_progressCircle atIndex:1];

    [_minutesLabel setText:[NSString stringWithFormat:@"%d mins", minutes]];
    [_routeLabel setText:[route copy]];

    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = minutes * 60; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    drawAnimation.removedOnCompletion = YES;   // Remain stroked after the animation..
    
    drawAnimation.delegate = self;
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:)];
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add the animation to the circle
    [_progressCircle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    return YES;
}


@end
