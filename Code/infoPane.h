//
//  infoPane.h
//  Bicicletitas
//
//  Created by Roberto Hidalgo on 8/19/11.
//  Copyright 2011 Partido Surrealista Mexicano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoPane : UIViewController {
    UILabel * labelView;
    UIImageView * imageView;
    UIActivityIndicatorView * activityView;
    NSTimer *timer;
    Boolean shown;
}

@property (nonatomic, retain) IBOutlet UILabel *labelView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityView;
@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, readwrite) Boolean shown;

- (void) showInfo:(NSString *)mensaje;
- (void) showError:(NSString *)error;
- (UIView *) getView;
- (void) slideOut;
- (void) slideOutWithTimer:(int) segundos;
- (void) slideIn;

@end
