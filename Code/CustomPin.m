//
//  CustomPin.m
//  Bicicletitas
//
//  Created by Roberto Hidalgo on 7/2/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import "CustomPin.h"

@implementation CustomPin

- (id)initWithAnnotation:(id <MKAnnotation>)annotation
{
    self = [super initWithAnnotation:annotation reuseIdentifier:@"EstacionEB"];
    if (self)        
    {
        UIImage* theImage = [UIImage imageNamed:@"sepa.png"];
        if (!theImage)
            return nil;
        
        self.image = theImage;
    }    
    return self;
}


- (void)cambiaImagen:(NSString *)imagenString
{
    NSLog(@"cambiando imagen");
    UIImage * image;
    image = [UIImage imageNamed:imagenString];
    self.image = image;
}

@end