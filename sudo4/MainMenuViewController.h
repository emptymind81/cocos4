//
//  MainMenuViewController.h
//  MaskedCal
//
//  Created by Ray Wenderlich on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController {
    UIViewController *_rootViewController;
    UIViewController *_aboutViewController;
}

@property (retain) UIViewController *aboutViewController;
@property (retain) UIViewController *rootViewController;

- (IBAction)aboutTapped:(id)sender;
- (IBAction)viewTapped:(id)sender;

@end
