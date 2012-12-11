//
//  Plotter.m
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import "EstacionEB.h"

@implementation EstacionEB

@synthesize nombre = _nombre;
@synthesize detalles = _detalles;
@synthesize coordinate = _coordinate;
@synthesize status = _status;
@synthesize eid = _eid;


- (id)crearConNombre:(NSString *)nombre 
            detalles:(NSString *)detalles
         coordenadas:(CLLocationCoordinate2D)coordinate
              status:(NSString *)status
                 eid:(NSString *)eid {
    if ((self = [super init])) {
        _nombre = [nombre copy];
        _detalles = [detalles copy];
        _coordinate = coordinate;
        _status = [status copy];
        _eid = [eid copy];
    }
    return self;
}

- (NSString *)elStatus {
    return _status;
}

- (NSString *)title {
    return _nombre;
}


- (void)cambiaStatus:(NSInteger)libres espacios:(NSInteger)espacios
{
    NSString *status;
    if( libres==0 ){
        status = @"vacia";
    } else if( (libres>0) && (espacios<=3)  ){
        status = @"nies";
    } else {
        status = @"disponible";
    }
    [_status release];
    _status = [status copy];
}


- (void)detalla:(NSString *) nuevoDetalle
{
    [self willChangeValueForKey:@"subtitle"];
    [_detalles release];
    _detalles = [nuevoDetalle copy];
    [self didChangeValueForKey:@"subtitle"];
}

- (NSString *)subtitle {
    
    NSString *dets;
    NSString *plural;
    if( [[NSString stringWithFormat:@"%@", _detalles] length] != 0 ){
        plural = [[NSString stringWithFormat:@"%@", _detalles] isEqualToString:@"1"]? @"" : @"s";
        dets = [NSString stringWithFormat:@"%@ bicicleta%@", _detalles, plural];
        //NSLog(@"%@", _detalles);
    } else {
        dets =@"Sin información";
    }
    return dets;
}

- (void)dealloc
{
    [_nombre release];
    _nombre = nil;
    [_detalles release];
    _detalles = nil;    
    [super dealloc];
}

@end
