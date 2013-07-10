//
//  HelloWorldLayer.m
//  sudo4
//
//  Created by Alun You on 7/3/13.
//  Copyright Alun You 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "ChessBoardLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(void) enterGameScene:(GameLevel)gameLevel
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[ChessBoardLayer scene:gameLevel] ]];
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *bg = [CCSprite spriteWithFile:@"Cosmos01.jpg"];
        bg.position = ccp(size.width /2 , size.height/2);
        [self addChild:bg];
        
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Welcome to Sudo" fontName:@"Marker Felt" fontSize:64];		
		label.position =  ccp( size.width /2 , size.height/2 + 100 );
		[self addChild: label];
        

		[CCMenuItemFont setFontSize:28];		
		CCMenuItem *item_simple = [CCMenuItemFont itemWithString:@"Simple" block:^(id sender) {
			
            [self enterGameScene:kSimple];
		}];
        [item_simple setColor:ccRED];
		CCMenuItem *item_hard = [CCMenuItemFont itemWithString:@"Hard" block:^(id sender) {
			
            [self enterGameScene:kHard];
		}];
        [item_hard setColor:ccGREEN];
        CCMenuItem *item_Master = [CCMenuItemFont itemWithString:@"Master" block:^(id sender) {
			
            [self enterGameScene:kMaster];
		}];
        [item_Master setColor:ccBLUE];
        /*CCMenuItem *item_Quit = [CCMenuItemFont itemWithString:@"Quit" block:^(id sender) {
			
            CC_DIRECTOR_END();
		}];*/
		
		CCMenu *menu = [CCMenu menuWithItems:item_simple, item_hard, item_Master, /*item_Quit,*/ nil];
        [menu alignItemsVertically];
        
        // elastic effect
		CGSize s = [[CCDirector sharedDirector] winSize];
		int i=0;
		for( CCNode *child in [menu children] ) {
			CGPoint dstPoint = child.position;
			int offset = s.width/2 + 50;
			if( i % 2 == 0)
				offset = -offset;
			child.position = ccp( dstPoint.x + offset, dstPoint.y);
			[child runAction:
			 [CCEaseElasticOut actionWithAction:
			  [CCMoveBy actionWithDuration:2 position:ccp(dstPoint.x - offset,0)]
										 period: 0.35f]
             ];
			i++;
		}

		[self addChild:menu];
        [menu setPosition:ccp( size.width/2, size.height/2 - 50)];

	}
	return self;
}

// on "dealloc" you need to release all your retained objects

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
