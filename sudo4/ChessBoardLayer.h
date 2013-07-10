//
//  ChessBoardLayer.h
//  sudo4
//
//  Created by Alun You on 7/3/13.
//  Copyright (c) 2013 Alun You. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCLayer.h"
//#import "SudoKu.h"
#import "Define.h"

typedef enum
{
	kTextTTF,
	kTextBMFont,
	kTextAtlas,
} TextMethod;

@interface ChessBoardLayer : CCLayer<UIAlertViewDelegate>
{
    UITapGestureRecognizer * _tapRecognizer;
    UITapGestureRecognizer * _doubleTapRecognizer;
    UISwipeGestureRecognizer * _swipeLeftRecognizer;
    UISwipeGestureRecognizer * _swipeRightRecognizer;
}

@property (retain) UITapGestureRecognizer * tapRecognizer;
@property (retain) UITapGestureRecognizer * doubleTapRecognizer;
@property (retain) UISwipeGestureRecognizer * swipeLeftRecognizer;
@property (retain) UISwipeGestureRecognizer * swipeRightRecognizer;

-(id) initWithLevel:(GameLevel)gameLevel;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene:(GameLevel)game_level;



@end
