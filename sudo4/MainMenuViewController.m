//
//  MainMenuViewController.m
//  MaskedCal
//
//  Created by Ray Wenderlich on 8/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "GameViewController.h"
#import "AboutViewController.h"
#import "TestViewController.h"
#import "MBProgressHUD.h"

@implementation MainMenuViewController
@synthesize rootViewController = _rootViewController;
@synthesize aboutViewController = _aboutViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWallpapers:(id)arg {
    if (_rootViewController == nil) {
        GameViewController* game_view_controller = [[GameViewController alloc] initWithNibName:nil bundle:nil];
        //[GameViewController alloc] initWithRootViewController:director_];
        //game_view_controller.navigationBarHidden = YES;
        UIViewController* director = [game_view_controller setupGame];
        self.rootViewController  = game_view_controller;
    }
    [self.navigationController pushViewController:_rootViewController animated:YES];
}

- (IBAction)aboutTapped:(id)sender {
    if (_aboutViewController == nil) {
        self.aboutViewController = [[TestViewController alloc] initWithNibName:nil bundle:nil];
    }
    [self.navigationController pushViewController:_aboutViewController animated:NO];
}

- (IBAction)viewTapped:(id)sender {
    
    if (_rootViewController == nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading...";
        [self performSelector:@selector(viewWallpapers:) withObject:nil afterDelay:0.1];
    } else {
        [self viewWallpapers:nil];
    }
    
}

@end
