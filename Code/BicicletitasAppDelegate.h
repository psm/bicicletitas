//
//  testAppDelegate.h
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BicicletitasAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSMutableDictionary *estaciones;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly) NSURL *applicationDocumentsDirectory;


@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSMutableDictionary *estaciones;


- (void)populaEstaciones;

@end
