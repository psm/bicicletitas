//
//  Acerca.m
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import "Acerca.h"


@implementation Acerca
@synthesize scrollView;

 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)safari:(id)sender
{
    NSURL *target = [[NSURL alloc] initWithString:@"http://partidosurrealista.com"];
    [[UIApplication sharedApplication] openURL:target];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [scrollView release];
    scrollView = nil;
    [self setScrollView:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [scrollView release];
    [super dealloc];
}

@end
