//
//  Favoritas.m
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import "Favoritas.h"
#import "Estacion.h"
#import "ASIHTTPRequest.h"
#import "EstacionEB.h"
#import "SBJson.h"
#import "BicicletitasAppDelegate.h"

@implementation Favoritas

@synthesize context = _context;
@synthesize estaciones = _estaciones;
@synthesize lasFavoritas = _lasFavoritas;
@synthesize tableView = tableView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    BicicletitasAppDelegate *appDelegate = (BicicletitasAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];    
    NSMutableDictionary *estaciones = [appDelegate estaciones];
    self.estaciones = estaciones;
    self.context = context;
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:) name:@"DeviceShaken" object:nil];
    self.lasFavoritas = [self listaFavoritas];
    [tableView reloadData];
	tableView.backgroundColor = [UIColor clearColor];
}


- (ASIHTTPRequest *)request:(NSString *)endpoint
{
    NSString *base = [[NSUserDefaults standardUserDefaults] valueForKey:@"endpoint"];
    NSString *elURL = [NSString stringWithFormat:@"%@/%@", base, endpoint];
    //NSLog(@"Requesting: %@", elURL);
    NSURL *url = [NSURL URLWithString:elURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    return request;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.lasFavoritas count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.lasFavoritas count] > 0 ) {
        return 2;
    } else {
        return 0;
    }
}


-(UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cid = @"Cell";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cid];
    
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cid] autorelease];
    }
        
    NSUInteger estacion = [indexPath section];
    if([self.lasFavoritas count] > 0 ) {
        NSDictionary *estaFavorita = [self.lasFavoritas objectAtIndex:estacion];
        
        
        if( indexPath.row == 0 ){
            cell.textLabel.text = [NSString stringWithFormat:@"%@ bicicletas libres", 
                                   [[estaFavorita valueForKey:@"detalles"] valueForKey:@"libres"]];//[estaEstacion subtitle];
        } else {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ estacionamientos", 
                                   [[estaFavorita valueForKey:@"detalles"] valueForKey:@"espacios"]];// [estaFavorita valueForKey:@"espacios"];
        }
        cell.userInteractionEnabled = NO;
    } else {
        cell.textLabel.text = @"No tienes favoritas todavía";
    }
    return cell;
}


-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return  30.0;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 60)] autorelease];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 3, self.tableView.bounds.size.width - 10, 30)] autorelease];
    label.textColor = [UIColor colorWithWhite:0.40 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    label.shadowOffset = CGSizeMake(-1.0, -1.0);
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    [headerView addSubview:label];
    if([self.lasFavoritas count] > 0 ) {
        label.text = [[self.lasFavoritas objectAtIndex:section] valueForKey:@"nombre"];
    } else {
        label.text = @"No tiene estaciones favoritas todavía";
    }
    
    return headerView;
}


- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if([self.lasFavoritas count] > 0 ) {
        NSString *last = [[self.lasFavoritas objectAtIndex:section] valueForKey:@"timestamp"];
        return [NSString stringWithFormat:@"Actualizada: %@", [self fechaRelativa:last]];
    } else {
        return @"";
    }
}


-(NSString *)fechaRelativa:(NSString *)timestamp {
    NSDate *ts = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSDate *todayDate = [NSDate date];
    double ti = [ts timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"no disponible";
    } else if (ti < 60) {
        return @"hace menos de un minuto";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"hace %d minutos", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"hace %d horas", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"hace %d diás", diff];
    } else {
        return @"no disponible";
    }   
}


- (NSMutableArray *)listaFavoritas {
    
    NSArray *resultados = [[self.estaciones allValues]
                             filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"favorita == 1"]];
    
    NSMutableArray *favs = [[NSMutableArray alloc] init];
    
    for( Estacion *estacion in resultados ){
        NSString *eid = [estacion valueForKey:@"id"];
        ASIHTTPRequest *request = [self request:[NSString stringWithFormat:@"%@/%@", @"status", eid]];
        request.requestMethod = @"GET";    
        [request startSynchronous];
        NSError *error = [request error];
        
        if (!error) {
            NSString *response = [request responseString];
            NSDictionary * root = [response JSONValue];
            
            NSDictionary * datos = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [root valueForKey:@"detalles"], @"detalles",
                                    [root valueForKey:@"timestamp"], @"timestamp",
                                    [estacion valueForKey:@"nombre"], @"nombre",
                                    nil];
            [favs addObject:datos];
        }
    }
    return favs;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.view resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.lasFavoritas = [self listaFavoritas];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [_context release];
    [_estaciones release];
    [_lasFavoritas release];
    [tableView release];
    [super dealloc];
}

@end
