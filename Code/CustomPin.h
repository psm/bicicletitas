//
//  CustomPin.h
//  Bicicletitas
//
//  Created by Roberto Hidalgo on 7/2/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//
#import <Mapkit/Mapkit.h>


@interface CustomPin : MKAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>) annotation;
- (void)cambiaImagen:(NSString *)imagenString;

@end