//
//  AutoRotate.h
//  Bicicletitas
//
//  Created by Roberto Hidalgo on 6/28/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AutoRotate : UITabBarController {
    
}

@property (retain, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
