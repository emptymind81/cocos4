//
//  GameViewController.h
//  sudo4
//
//  Created by Alun You on 7/11/13.
//  Copyright (c) 2013 Alun You. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface GameViewController : UIViewController <CCDirectorDelegate>
{
    CCDirectorIOS	*__unsafe_unretained director_;	
}

@property (unsafe_unretained, readonly) CCDirectorIOS *director;

-(id) setupGame;

@end
