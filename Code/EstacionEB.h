//
//  EstacionEB.h
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EstacionEB : NSObject <MKAnnotation> {
    NSString *_nombre;
    NSString *_detalles;
    NSString *_status;
    NSString *_eid;
    CLLocationCoordinate2D _coordenadas;
}

@property (copy) NSString *nombre;
@property (copy) NSString *detalles;
@property (copy) NSString *status;
@property (copy) NSString *eid;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (void)cambiaStatus:(NSInteger)libres espacios:(NSInteger)espacios;
- (void)detalla:(NSString *) nuevoDetalle;
- (id)crearConNombre:(NSString*)nombre detalles:(NSString*)detalles coordenadas:(CLLocationCoordinate2D)coordenadas status:(NSString *)status eid:(NSString *)eid;
- (NSString *)elStatus;

@end