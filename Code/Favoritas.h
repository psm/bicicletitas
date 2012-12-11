//
//  Favoritas.h
//  test
//
//  Created by Roberto Hidalgo on 6/27/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AutoRotate.h"

@interface Favoritas : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    NSManagedObjectContext *_context;    
    NSMutableDictionary *_estaciones;
    NSMutableArray *_lasFavoritas;
    UITableView *tableView;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSMutableDictionary *estaciones;
@property (nonatomic, retain) NSMutableArray *lasFavoritas;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (NSMutableArray *)listaFavoritas;
-(NSString *)fechaRelativa:(NSString *)timestamp;


@end
