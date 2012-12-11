//
//  Estaciones.m
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import "Estaciones.h"
#import "ASIHTTPRequest.h"
#import "EstacionEB.h"
#import "SBJson.h"
#import "Estacion.h"
#import "BicicletitasAppDelegate.h"
#import "CustomPin.h"
#import "infoPane.h"


@implementation Estaciones
@synthesize _mapita;
@synthesize context = _context;
@synthesize estaciones = _estaciones;
@synthesize marcadores = _marcadores;
@synthesize ip = _ip;
@synthesize timer = _timer;


- (void)viewDidLoad
{
    [super viewDidLoad];
    BicicletitasAppDelegate *appDelegate = (BicicletitasAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];    
    NSMutableDictionary *estaciones = [appDelegate estaciones];
    self.estaciones = estaciones;
    self.context = context;
    self.ip = [[infoPane alloc] init];
    [self.view addSubview:[self.ip getView]];
    
    NSMutableDictionary *marcadores = [[NSMutableDictionary alloc] init];
    self.marcadores = marcadores;
    [self ping];
    //NSLog(@"%@", self.marcadores);
    
}


- (ASIHTTPRequest *)request:(NSString *)endpoint {
    NSString *base = [[NSUserDefaults standardUserDefaults] valueForKey:@"endpoint"];
    NSString *elURL = [NSString stringWithFormat:@"%@/%@", base, endpoint];
    //NSLog(@"Requesting: %@", elURL);
    NSURL *url = [NSURL URLWithString:elURL];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.timeOutSeconds = 20;
    return request;
}


- (void)ping{
    
    ASIHTTPRequest *request = [self request:[NSString stringWithFormat:@"%@/%@", @"ping",[[NSUserDefaults standardUserDefaults] objectForKey:@"version"]]];
    //ASIHTTPRequest *request = [self request:[NSString stringWithFormat:@"%@/%@", @"ping", @"0"]];
    request.requestMethod = @"GET";
    
    [self.ip showInfo:@"Buscando actualizaciones..."];
    
    [request startSynchronous];
    NSError *error = [request error];
        
    if (!error) {
        NSString *response = [request responseString];
        NSDictionary * root = [response JSONValue];
        NSString * ping = [root valueForKey:@"status"];
        if( ![ping isEqualToString:@"pong"] ){
            //hay que actualizar estaciones
            
            //guardamos la version nueva en los defaults
            NSString * version = [root valueForKey:@"version"];
            NSLog(@"Nueva version: %@", version);
            self.ip.labelView.text = @"Actualizando estaciones...";
            [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"version"];
            
            NSDictionary * nuevasEstaciones = [root objectForKey:@"estaciones"];
            // iteramos por cada una de las nuevas estacione
            // si no existen, las creamos
            // si existen, las actualizamos en base a su id
            for(NSString * eid in nuevasEstaciones){
                
                if(![nuevasEstaciones objectForKey:eid]){
                    NSLog(@"Ingestando estación nueva con id %@", eid);
                }
                                
                Estacion *nueva;
                NSNumber *favorita;
                if ([self.estaciones objectForKey:eid]) {
                    //existe la estacion en coredata
                    nueva = [self.estaciones valueForKey:eid];
                    favorita = nueva.favorita;
                } else {
                    // no existe la estación en core data, la voy a crear
                    //NSLog(@"Creando %@", eid);
                    nueva = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Estacion"
                            inManagedObjectContext:self.context];
                    favorita = NO;
                }
                NSLog(@"%@", eid);
                NSDictionary *estaEstacion = [nuevasEstaciones objectForKey:eid];
                [nueva setNombre:[estaEstacion valueForKey:@"nombre"]];
                [nueva setId:eid];
                [nueva setLatitude: [estaEstacion valueForKey:@"lat"]];
                [nueva setLongitude: [estaEstacion valueForKey:@"long"]];
                [nueva setFavorita: favorita];
             }
             NSError * saveError;
             [self.context save:&saveError];
            
            BicicletitasAppDelegate *appDelegate = (BicicletitasAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate populaEstaciones];
            
        } else {
            [self.ip slideOut];
            //NSLog(@"No había nada que actualizar");
        }
    } else {
        [self.ip showError:@"No pude actualizar las estaciones!"];
        NSLog(@"Error: %@", error.localizedDescription);
    }
        
    //[ip slideOut];
    [self ponEstaciones];    
}


- (void)status
{
    [self.ip showInfo:@"Actualizando status..."];
    ASIHTTPRequest *request = [self request:@"status"];
    request.requestMethod = @"GET";
    [self.timer invalidate];
    
    [request setDelegate:self];
    [request setCompletionBlock:^{        
        NSString *responseString = [request responseString];
        NSDictionary * root = [responseString JSONValue];
        NSDictionary * estaciones = [root valueForKey:@"estaciones"];
        for(NSDictionary *estacion in estaciones){
            [self actualizaEstacion:[estacion objectForKey:@"id"] conDetalles:[estacion objectForKey:@"detalles"]];
        }
        [self.ip slideOutWithTimer:1];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:60*5
                                                            target:self
                                                          selector:@selector(status)
                                                          userInfo:nil
                                                           repeats:NO];
        //NSLog(@"Reload completo");
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        [self.ip showError:@"No pude actualizar el status!"];
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    [request startAsynchronous];
}


- (void)ponEstaciones
{    
    NSLog(@"Poniendo estaciones: %d", [self.estaciones count]);
    
    for (id<MKAnnotation> annotation in _mapita.annotations) {
        [_mapita removeAnnotation:annotation];
    }
        
    for (NSString * eid in self.estaciones) {
        CLLocationCoordinate2D coords;
        Estacion *estacion = [self.estaciones objectForKey:eid];
        coords.latitude = [estacion.latitude doubleValue];
        coords.longitude = [estacion.longitude doubleValue];  
        EstacionEB *marcador = [[[EstacionEB alloc] crearConNombre:estacion.nombre
                                                          detalles:@""
                                                       coordenadas:coords
                                                            status:@"sepa"
                                                               eid:estacion.id]
                                autorelease];
        [_mapita addAnnotation:marcador];
    }
    [self status];
}


- (void)actualizaEstacion:(NSString *)eid conDetalles:(NSDictionary *)detalles
{
    NSString * esteEID = [NSString stringWithFormat:@"%@", eid];
    //NSLog(@"Actualizando %@", esteEID);
    for (id annotation in _mapita.annotations) {
        if ([annotation isKindOfClass:[EstacionEB class]]) {
            EstacionEB *location = (EstacionEB *) annotation;
            NSString * otroEID = [NSString stringWithFormat:@"%@", location.eid];
            if ( [esteEID isEqualToString:otroEID] ) {
                
                NSInteger libres = [[detalles objectForKey:@"libres"] intValue];
                //NSInteger espacios = [[detalles objectForKey:@"espacios"] intValue];
                NSString *status;
                
                if( libres==0 ){
                    status = @"vacia";
                } else if( (libres<=3) ){
                    status = @"nies";
                } else {
                    status = @"disponible";
                }
                
                [location setDetalles:[detalles objectForKey:@"libres"]];
                [location setStatus:status];
                
                MKAnnotationView *av = [_mapita viewForAnnotation:location];
                av.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", status]];
                
                [_mapita viewForAnnotation:location];
                //[_mapita performSelectorOnMainThread:@selector(viewForAnnotation:) withObject:location waitUntilDone:true];
                //NSLog(@"Te encontré, %@ ahora con stauts: %@", eid, status);
                return;
            } else {
                //NSLog(@"eid %@ != %@ location.eid", eid, location.eid);
            }
        } else {
            NSLog(@"anotacion no es de clase EstacionEB");
        }
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    static NSString *identifier = @"EstacionEB";   
    if ([annotation isKindOfClass:[EstacionEB class]]) {
        EstacionEB *location = (EstacionEB *) annotation;
        
        CustomPin *annotationView = (CustomPin *) [_mapita dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[CustomPin alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [location elStatus]]];
        
        annotationView.enabled = YES;
        //annotationView.animatesDrop = NO;
        annotationView.canShowCallout = YES;
        annotationView.image = image;
        
        CGRect BtnFrame = CGRectMake(0, 0, 24, 24);
        UIButton *favea = [UIButton buttonWithType:UIButtonTypeCustom];
        favea.frame = BtnFrame;
        
        UIImage *noFav = [UIImage imageNamed:@"favea.png"];
        UIImage *siFav = [UIImage imageNamed:@"faveaTapped.png"];
        
        Estacion *esta = [self.estaciones valueForKey:location.eid];
        //NSLog(@"%@ - %@", esta.id, [esta.favorita class]);
        if( [esta.favorita intValue] == 1 ){
            favea.selected = YES;
        } else {
            favea.selected = NO;
        }
        
        [favea setBackgroundImage:noFav forState:UIControlStateNormal];
        [favea setBackgroundImage:siFav forState:UIControlStateSelected];
        //[favea setBackgroundImage:siFav forState:UIControlStateHighlighted];
        
        annotationView.leftCalloutAccessoryView = favea;
        NSDictionary *temp = [[NSDictionary alloc] 
                              initWithObjects:[NSArray arrayWithObjects:annotationView, location, nil]
                              forKeys:[NSArray arrayWithObjects:@"vista", @"anotacion", nil]
                              ];
        [self.marcadores setObject:temp forKey:location.eid];
        return annotationView;
    } else {
        //NSLog(@"WTF? %@", annotation);
    }
    
    return nil;    
}


//click en favea
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIButton *)control
{
    EstacionEB *laEstacion = [mapView.selectedAnnotations objectAtIndex:0];
    Estacion *esta = [self.estaciones valueForKey:laEstacion.eid];

    if( [esta.favorita intValue] == 1 ){
        esta.favorita = [NSNumber numberWithBool:NO];
        control.selected = NO;
    } else {
        esta.favorita = [NSNumber numberWithBool:YES];
        control.selected = YES;
    }
    
    NSError * saveError = nil;
    [self.context save:&saveError];
    if( saveError ){
        NSLog(@"%@", [saveError localizedDescription]);
    } else {
        //NSLog(@"Estación: %@, status: %@", laEstacion.eid, esta.favorita);
    }
            
}

//dibuja el mapa y ajá
- (void)viewWillAppear:(BOOL)animated
{
    [self.view becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(status) name:@"DeviceShaken" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(status) name:@"regresamos" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self
                                             //selector:@selector(status) name:@"laUltimaYNosVamos" object:nil];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 19.42033742447410000;
    zoomLocation.longitude = -99.1727042198181000;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [_mapita regionThatFits:viewRegion];                
    [_mapita setRegion:adjustedRegion animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.view resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    [self set_mapita:nil];
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    //[managedObjectContext release];
    [self.ip release];
    [_mapita release];
    [_context release];
    [_estaciones release];
    [_marcadores release];
    [_ip release];
    [_timer release];
    [super dealloc];
}

@end
