//
//  infoPane.m
//  Bicicletitas
//
//  Created by Roberto Hidalgo on 8/19/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import "infoPane.h"

@implementation infoPane

@synthesize labelView = labelView;
@synthesize imageView = imageView;
@synthesize activityView = activityView;
@synthesize timer, shown;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}


- (void) showInfo:(NSString *)mensaje {
    self.labelView.text = mensaje;
    self.activityView.alpha = 1;
    self.imageView.image = [UIImage imageNamed:@"infoPane.png"];
    [self slideIn];
}

- (void) showError:(NSString *)error
{
    self.labelView.text = error;
    self.imageView.image = [UIImage imageNamed:@"errorPane.png"];
    self.activityView.alpha = 0;
    [self slideIn];
    [self slideOutWithTimer:7];
}


- (UIView *) getView
{
    return self.view;
}


- (void) slideIn
{
    [self slideOut];
    [self.view setFrame:CGRectMake(0.0, -40.0, 320.0, 40.0)];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [self.view setFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
    [UIView commitAnimations];
    [self.timer invalidate];
}

- (void) slideOut
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [self.view setFrame:CGRectMake(0.0, -40.0, 320.0, 40.0)];
    [UIView commitAnimations];
    [self.timer invalidate];
}


- (void) slideOutWithTimer:(int) segundos
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:segundos
                                     target:self
                                   selector:@selector(slideOut)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
