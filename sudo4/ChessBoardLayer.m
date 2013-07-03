//
//  ChessBoardLayer.m
//  sudo4
//
//  Created by Alun You on 7/3/13.
//  Copyright (c) 2013 Alun You. All rights reserved.
//

#import "ChessBoardLayer.h"

@implementation ChessBoardLayer

-(void) draw
{
	CGSize s = [[CCDirector sharedDirector] winSize];
    
    // filled poly
	glLineWidth(1);
	CGPoint filledVertices1[] = { ccp(0,0), ccp(s.width,0), ccp(s.width,s.height), ccp(0,s.height), ccp(0,0) };
	ccDrawSolidPoly(filledVertices1, 5, ccc4f(1.0f, 0.5f, 1, 1 ) );
    
	CHECK_GL_ERROR_DEBUG();
    
    CCLabelTTF* label = [CCLabelTTF labelWithString:@"Main Label" fontName:@"Arial" fontSize:32];
    [self addChild: label z:1];
    [label setPosition: ccp(s.width/2, s.height-50)];

    
	// draw a simple line
	// The default state is:
	// Line Width: 1
	// color: 255,255,255,255 (white, non-transparent)
	// Anti-Aliased
    //	glEnable(GL_LINE_SMOOTH);
	ccDrawLine( ccp(0, 0), ccp(s.width, s.height) );
    
	CHECK_GL_ERROR_DEBUG();
    
	// line: color, width, aliased
	// glLineWidth > 1 and GL_LINE_SMOOTH are not compatible
	// GL_SMOOTH_LINE_WIDTH_RANGE = (1,1) on iPhone
    //	glDisable(GL_LINE_SMOOTH);
	glLineWidth( 5.0f );
	ccDrawColor4B(255,0,0,255);
	ccDrawLine( ccp(0, s.height), ccp(s.width, 0) );
    
	CHECK_GL_ERROR_DEBUG();
    
	// TIP:
	// If you are going to use always the same color or width, you don't
	// need to call it before every draw
	//
	// Remember: OpenGL is a state-machine.
    
	// draw big point in the center
	ccPointSize(64);
	ccDrawColor4B(0,0,255,128);
	ccDrawPoint( ccp(s.width / 2, s.height / 2) );
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw 4 small points
	CGPoint points[] = { ccp(60,60), ccp(70,70), ccp(60,70), ccp(70,60) };
	ccPointSize(4);
	ccDrawColor4B(0,255,255,255);
	ccDrawPoints( points, 4);
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw a green circle with 10 segments
	glLineWidth(16);
	ccDrawColor4B(0, 255, 0, 255);
	ccDrawCircle( ccp(s.width/2,  s.height/2), 100, 0, 10, NO);
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw a green circle with 50 segments with line to center
	glLineWidth(2);
	ccDrawColor4B(0, 255, 255, 255);
	ccDrawCircle( ccp(s.width/2, s.height/2), 50, CC_DEGREES_TO_RADIANS(90), 50, YES);
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw a green Arc with 50 segments without line to center
	glLineWidth(2);
	ccDrawColor4B(0, 255, 255, 255);
	ccDrawArc( ccp(s.width-105, s.height/2-105), 100, CC_DEGREES_TO_RADIANS(90), CC_DEGREES_TO_RADIANS(90), 50, NO);
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw a green solid Arc with 50 segments without line to center
	glLineWidth(2);
	ccDrawColor4B(0, 255, 255, 255);
	ccDrawSolidArc( ccp(s.width-105, s.height/2+105), 100, CC_DEGREES_TO_RADIANS(90), CC_DEGREES_TO_RADIANS(90), 50);
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw a green solid circle with 50 segments with line to center
	glLineWidth(1);
	ccDrawColor4B(0, 255, 255, 255);
	ccDrawSolidCircle( ccp(105, s.height/2), 100, 50);
    
	CHECK_GL_ERROR_DEBUG();
    
	// open yellow poly
	ccDrawColor4B(255, 255, 0, 255);
	glLineWidth(10);
	CGPoint vertices[] = { ccp(0,0), ccp(50,50), ccp(100,50), ccp(100,100), ccp(50,100) };
	ccDrawPoly( vertices, 5, NO);
    
	CHECK_GL_ERROR_DEBUG();
	
	// filled poly
	glLineWidth(1);
	CGPoint filledVertices[] = { ccp(0,120), ccp(50,120), ccp(50,170), ccp(25,200), ccp(0,170) };
	ccDrawSolidPoly(filledVertices, 5, ccc4f(0.5f, 0.5f, 1, 1 ) );
    
    
	// closed purble poly
	ccDrawColor4B(255, 0, 255, 255);
	glLineWidth(2);
	CGPoint vertices2[] = { ccp(30,130), ccp(30,230), ccp(50,200) };
	ccDrawPoly( vertices2, 3, YES);
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw quad bezier path
	ccDrawQuadBezier(ccp(0,s.height), ccp(s.width/2,s.height/2), ccp(s.width,s.height), 50);
    
	CHECK_GL_ERROR_DEBUG();
    
	// draw cubic bezier path
	ccDrawCubicBezier(ccp(s.width/2, s.height/2), ccp(s.width/2+30,s.height/2+50), ccp(s.width/2+60,s.height/2-50),ccp(s.width, s.height/2),100);
    
	CHECK_GL_ERROR_DEBUG();
    
    //draw a solid polygon
	CGPoint vertices3[] = {ccp(60,160), ccp(70,190), ccp(100,190), ccp(90,160)};
    ccDrawSolidPoly( vertices3, 4, ccc4f(1,1,0,1) );
    
	// restore original values
	glLineWidth(1);
	ccDrawColor4B(255,255,255,255);
	ccPointSize(1);
    
	CHECK_GL_ERROR_DEBUG();
}


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChessBoardLayer *layer = [ChessBoardLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
