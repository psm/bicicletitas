//
//  Estaciones.h
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import "AutoRotate.h"
#import "infoPane.h"

@interface Estaciones : UIViewController <MKMapViewDelegate>{
    NSManagedObjectContext *_context;    
    NSMutableDictionary *_estaciones;
    NSMutableDictionary *_marcadores;
    MKMapView *_mapita;
    infoPane *_ip;
    NSTimer *_timer;
}
@property (nonatomic, retain) IBOutlet MKMapView *_mapita;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableDictionary *estaciones;
@property (nonatomic, retain) NSMutableDictionary *marcadores;
@property (nonatomic, retain) infoPane *ip;
@property (nonatomic, retain) NSTimer *timer;

- (void)ponEstaciones;
- (void)actualizaEstacion:(NSString *)eid conDetalles:(NSDictionary *)detalles;
- (void)ping;

@end
