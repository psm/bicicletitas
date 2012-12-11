//
//  Estacion.h
//  Bicicletitas
//
//  Created by Roberto Hidalgo on 7/2/11.
//  Copyright (c) 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Estacion : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSNumber * favorita;
@property (nonatomic, retain) NSString * id;

@end
