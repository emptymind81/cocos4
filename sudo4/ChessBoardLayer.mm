//
//  ChessBoardLayer.m
//  sudo4
//
//  Created by Alun You on 7/3/13.
//  Copyright (c) 2013 Alun You. All rights reserved.
//

#import "ChessBoardLayer.h"
#import "HelloWorldLayer.h"
#import "SimpleAudioEngine.h"
#import "SudoKu.h"

@implementation ChessBoardLayer
{
    CSudoku* m_sudo;
    
    int m_menubar_height;
    int m_numberbar_height;
    int m_margin_height;
    int m_margin_width;
    int m_board_width;
    int m_board_height;
    int m_cell_width;
    int m_cell_height;
    CGPoint m_topleft;
    
    int m_current_cell_i;
    int m_current_cell_j;
    int m_current_cell_value;
    
    CGPoint m_number_bar_topleft;
    int m_current_number_bar_i;
    int m_current_number_bar_value;
    
    NSObject* label_map[9][9];
    NSObject* label_number_barmap[10];
    
    NSString* m_result_str;
    
    bool m_try_mode;
    
    TextMethod m_text_method;
    
    CCSprite* m_bg_sprite;
};

-(id) initWithLevel:(GameLevel)gameLevel
{
	if( (self=[super init]) ) {
        m_sudo = new CSudoku(gameLevel);
        //m_sudo->display();
        //m_sudo->resolve();
        
        [self setTouchEnabled:YES];
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        m_menubar_height = 50;
        m_numberbar_height = 50;
        m_margin_height = 5;
        m_margin_width = 15;
        m_board_width = s.width - 2 * m_margin_width;
        m_board_height = s.height - m_menubar_height - m_numberbar_height - 4 * m_margin_height;
        m_cell_width = min(m_board_width, m_board_height) / 9;
        m_cell_height = m_cell_width;
        
        m_board_width = 9 * m_cell_width;
        m_board_height = m_board_width;
        m_margin_width = (s.width - m_board_width) / 2;
        m_topleft = ccp(m_margin_width, s.height - m_menubar_height - 2 * m_margin_height);
        
        m_current_cell_i = -1;
        m_current_cell_j = -1;
        m_current_cell_value = -1;
        
        m_number_bar_topleft = ccp(m_margin_width, s.height - m_menubar_height - 9 * m_cell_height - 3 * m_margin_height);
        m_current_number_bar_i = -1;
        m_current_number_bar_value = -1;
        
        for(int i=0; i<9; i++)
        {
            for(int j=0; j<9; j++)
            {
                label_map[i][j] = NULL;
            }
            label_number_barmap[i] = NULL;
        }
        for(int i=0; i<=9; i++)
        {
            label_number_barmap[i] = NULL;
        }
        
        m_result_str = @"Sudo";
        
        m_try_mode = false;
        
        m_text_method = kTextBMFont;
        
        m_bg_sprite = [CCSprite spriteWithFile:@"Calendar1-hd.png"];
        m_bg_sprite.position = ccp(s.width/2 , s.height/2);
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background-music-aac.caf"];
    }
    return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[HelloWorldLayer scene] ]];
}

- (void)clickHomeButton
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.0 scene:[HelloWorldLayer scene] ]];
}

- (void)clickBoardCellAtI:(int)i AtJ:(int)j
{
    //i is the col index
    m_current_cell_i = i;
    m_current_cell_j = j;
    m_current_cell_value = abs(m_sudo->GetValue(m_current_cell_j, m_current_cell_i));
}

- (void)clickNumberBarCellAtI:(int)number_bar_i
{
    m_current_number_bar_i = number_bar_i;
    m_current_number_bar_value = m_current_number_bar_i + 1;
    if(m_try_mode)
    {
        m_current_number_bar_value = -m_current_number_bar_value;
    }
    
    if(m_current_cell_i >= 0 && m_current_cell_i < 9 && !m_sudo->IsReadonlyCell(m_current_cell_j, m_current_cell_i))
    {
        m_sudo->SetValue(m_current_cell_j, m_current_cell_i, m_current_number_bar_value);
        m_current_cell_value = abs(m_current_number_bar_value);
        
        if(m_sudo->IsCorrectFilled())
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"You Win!"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil];
            [alert addButtonWithTitle:@"OK"];
            [alert show];
        }
    }
}

- (void)switchTryMode
{
    m_try_mode = !m_try_mode;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    bool play_effect = false;
    int index_i = (location.x - m_topleft.x) / m_cell_width;
    int index_j = (-location.y + m_topleft.y) / m_cell_height;
    if(-location.y + m_topleft.y < 0)
    {
        index_j = -1;
    }
    if(location.x - m_topleft.x < 0)
    {
        index_i = -1;
    }
    if(index_i >= 0 && index_i < 9 && index_j >= 0 && index_j < 9)
    {
        [self clickBoardCellAtI:index_i AtJ:index_j];
        play_effect = true;
    }
    else if(index_i == 0 && index_j == -1)
    {
        [self clickHomeButton];
        play_effect = true;
    }
    else//click on number bar
    {
        int number_bar_i = (location.x - m_number_bar_topleft.x) / m_cell_width;
        int number_bar_j = (-location.y + m_number_bar_topleft.y) / m_cell_height;
        if(-location.y + m_number_bar_topleft.y < 0)
        {
            number_bar_j = -1;
        }
        if(location.x - m_number_bar_topleft.x < 0)
        {
            number_bar_i = -1;
        }
        if(number_bar_i >= 0 && number_bar_i < 9 && number_bar_j >= 0 && number_bar_j < 1)
        {
            [self clickNumberBarCellAtI:number_bar_i];
            play_effect = true;
        }
        else if(number_bar_i == 9 && number_bar_j >= 0 && number_bar_j < 1)
        {
            [self switchTryMode];
            play_effect = true;
        }
    }
    if(play_effect)
    {
        [[SimpleAudioEngine sharedEngine] playEffect:@"pew-pew-lei.caf"];
    }
}

-(NSObject*) drawText:(NSObject*)labelAddr withText:(NSString*)text withColor:(ccColor3B)color withPosition:(CGPoint)cell_center fontSize:(bool)isBig
{
    switch (m_text_method)
    {
        case kTextBMFont:
        {
            double scale = 2.0;
            if(!isBig)
            {
                scale = 1.4;
            }
            CCLabelBMFont* label = (CCLabelBMFont*)(labelAddr);
            if(label)
            {
                [label setString:text];
            }
            else
            {
                label =[CCLabelBMFont labelWithString:text   fntFile:@"arial16.fnt"];
                [label setAlignment:kCCTextAlignmentCenter];
                [label setPosition: cell_center];
                [self addChild: label z:1];
            }
            [label setColor:color];
            [label setScale:scale];
            return label;
        }
            break;
        case kTextTTF:
        {
            int font_size = 32;
            if(!isBig)
            {
                font_size = 22;
            }
           
            CCLabelTTF* label = (CCLabelTTF*)(labelAddr);
            if(label)
            {
                [label setFontSize:font_size];
                [label setString:text];
            }
            else
            {
                label = [CCLabelTTF labelWithString:text fontName:@"Arial" fontSize:font_size ];
                [label setPosition: cell_center];
                [self addChild: label z:1];
            }
            [label setColor:color];
            return label;
        }
            break;
        case kTextAtlas:
        {
            int font_width=24;
            int font_height = 64;
            NSString* char_map_file = @"fps_images-hd.png";
            if(!isBig)
            {
                font_width=12;
                font_height = 32;
                char_map_file = @"fps_images.png";
            }
            CGPoint text_center = ccp(cell_center.x - font_width*0.4, cell_center.y - font_height/4);
            
            static NSMapTable *dict = [[NSMapTable alloc] init];
            CCLabelAtlas* label = (CCLabelAtlas*)(labelAddr);
            if(label)
            {
                CCLabelAtlas* oppo_label = [dict objectForKey:label];//find in dict
                
                if(label.tag == isBig)//is exactly we want
                {
                    [label setString:text];
                    [label setColor:color];
                    [label setVisible:true];
                    [oppo_label setVisible:false];
                }
                else
                {
                    [label setVisible:false];
                    [oppo_label setVisible:true];
                    
                    if(oppo_label)
                    {
                        [oppo_label setString:text];
                        [oppo_label setColor:color];
                    }
                    else
                    {
                        oppo_label = [CCLabelAtlas labelWithString:text charMapFile:char_map_file itemWidth:font_width itemHeight:font_height startCharMap:'.'];
                        [oppo_label setPosition: text_center];
                        [self addChild: oppo_label z:1];
                        [dict setObject:(id)oppo_label forKey:label];
                        oppo_label.tag = isBig;
                    }                    
                }
            }
            else
            {
                label = [CCLabelAtlas labelWithString:text charMapFile:char_map_file itemWidth:font_width itemHeight:font_height startCharMap:'.'];
                [label setPosition: text_center];
                [self addChild: label z:1];
                label.tag = isBig;
            }                
            
            return label;
        }
            break;
            
        default:
            break;
    }
    
}

-(void) visit
{
    //m_bg_sprite is not added to this layer, because as children it'll be drawed after [self draw]
    [m_bg_sprite visit];
    [super visit];    
}

-(void) draw
{
	CGSize s = [[CCDirector sharedDirector] winSize];
    
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //background color
    ccColor4F background_color = ccc4f(1.0f, 0.5f, 1, 1 );
    ccColor4F grid_back_color1 = ccc4f(0.5f, 0.5f, 1, 1 );
    ccColor4F grid_back_color2 = ccc4f(0.5f, 0.8f, 1, 1 );
    ccColor4F highlight_back_color = ccc4f(0.5f, 1, 0.3f, 1 );
    ccDrawColor4F(1.0, 1.0, 1.0, 1);
    
    // fill full canvas
	glLineWidth(1);
	/*CGPoint filledVertices1[] = { ccp(0,0), ccp(s.width,0), ccp(s.width,s.height), ccp(0,s.height), ccp(0,0) };
	ccDrawSolidPoly(filledVertices1, 5, background_color);*/
    /*m_bg_sprite = [CCSprite spriteWithFile:@"Calendar1-hd.png"];
    m_bg_sprite.position = ccp(s.width/2 , s.height/2);
    [self addChild:m_bg_sprite];*/
    //m_bg_sprite.offsetPosition = ccp(s.width/2 , s.height/2);
    //[m_bg_sprite draw];
    
    // fill board color1
    CGPoint board_area[] = { m_topleft, ccp(m_topleft.x+m_cell_width*9,m_topleft.y),
        ccp(m_topleft.x+m_cell_width*9,m_topleft.y-m_cell_height*9), ccp(m_topleft.x,m_topleft.y-m_cell_height*9), m_topleft };
	ccDrawSolidPoly(board_area, 5, grid_back_color1);
    
    //fill board color2
    for(int i=0; i<9; i++)
    {
        if(i % 2 == 0)
            continue;
        int sub_board_row = i / 3;
        int sub_board_col = i % 3;
        CGPoint topleft = ccp(m_topleft.x+(sub_board_col*3)*m_cell_width, m_topleft.y - (sub_board_row*3)*m_cell_height);
        CGPoint sub_board_area[] = { topleft, ccp(topleft.x+m_cell_width*3,topleft.y),
            ccp(topleft.x+m_cell_width*3,topleft.y-m_cell_height*3), ccp(topleft.x,topleft.y-m_cell_height*3), topleft };
        ccDrawSolidPoly(sub_board_area, 5, grid_back_color2);
    }
    
    //draw line with background color to split into 9*9
    for(int i=0; i<=9; i++)
    {
        CGPoint top = ccp(m_topleft.x+i*m_cell_width, m_topleft.y);
        CGPoint bot = ccp(m_topleft.x+i*m_cell_width, m_topleft.y-9*m_cell_height);
        glLineWidth((i%3==0)?3:1);
        ccDrawLine(top, bot);
    }
    for(int i=0; i<=9; i++)
    {
        CGPoint left  = ccp(m_topleft.x, m_topleft.y-i*m_cell_height);
        CGPoint right = ccp(m_topleft.x+9*m_cell_width, m_topleft.y-i*m_cell_height);
        glLineWidth((i%3==0)?3:1);
        ccDrawLine(left, right);
    }
    
	CHECK_GL_ERROR_DEBUG();
    
    //draw known numbers
    for(int i=0; i<9; i++)
    {
        for (int j=0; j<9; j++)
        {
            int value = m_sudo->GetValue(j, i);//i is col index
            if(-1 == m_current_cell_i && -1 == m_current_cell_j && value == 0)
            {
                m_current_cell_i = i;
                m_current_cell_j = j;
            }
            
            CGPoint cell_center = ccp(m_topleft.x+(i+0.5)*m_cell_width, m_topleft.y - (j+0.5)*m_cell_height);
            if((abs(value) == m_current_cell_value && value != 0) || (i == m_current_cell_i && j == m_current_cell_j))
            {
                ccDrawColor4F(highlight_back_color.r, highlight_back_color.g, highlight_back_color.b, highlight_back_color.a);
                ccDrawSolidCircle(cell_center, m_cell_width*0.4, m_cell_width*0.4);
            }
            
            if(i == m_current_cell_i && j == m_current_cell_j)
            {
                glLineWidth( 6.0f );
                ccDrawColor4F(1.0, 0, 0, 1);
                ccDrawCircle(cell_center, m_cell_width*0.4+2, 0, 10, NO);
            }
            
            if(value != 0)
            {
                NSString* text = [NSString stringWithFormat:@"%i", abs(value)];
                ccColor3B color = ccc3(255, 255, 0);
                if(m_sudo->IsReadonlyCell(j,i))
                {
                    color = ccc3(255, 255, 255);
                }
                bool is_big = value>0 ? true:false;
                
                NSObject* label = [self drawText:label_map[i][j] withText:text withColor:color withPosition:cell_center fontSize:is_big];
                label_map[i][j] = label;
            }
            
        }
    }
    
    CCLabelTTF* main_label = [CCLabelTTF labelWithString:m_result_str fontName:@"Arial" fontSize:32];
    [self addChild: main_label z:1];
    [main_label setPosition: ccp(s.width/2, s.height-20)];
    
    CCLabelTTF* main_menu_label = [CCLabelTTF labelWithString:@"<" fontName:@"Arial" fontSize:32];
    [self addChild: main_menu_label z:1];
    [main_menu_label setPosition: ccp(m_topleft.x + m_cell_width/2, s.height-20)];
    
    
    //draw number bar
    for (int i=0; i<=9; i++)
    {
        int value = i+1;
        
        CGPoint cell_center = ccp(m_number_bar_topleft.x+(i+0.5)*m_cell_width, m_number_bar_topleft.y - 0.5*m_cell_height);
        CGPoint topleft = ccp(m_number_bar_topleft.x+(i)*m_cell_width, m_number_bar_topleft.y);
        CGPoint cell_area[] = { topleft, ccp(topleft.x+m_cell_width,topleft.y),
            ccp(topleft.x+m_cell_width,topleft.y-m_cell_height), ccp(topleft.x,topleft.y-m_cell_height), topleft};
        ccDrawSolidPoly(cell_area, 5, highlight_back_color);
        
        NSString* text;
        if(i < 9)
        {
            text = [NSString stringWithFormat:@"%i", value];
        }
        else
        {
            text = @"E";
        }
        ccColor3B color = ccc3(255, 255, 255);
        bool is_big = m_try_mode ? false:true;
        
        NSObject* label = [self drawText:label_number_barmap[i] withText:text withColor:color withPosition:cell_center fontSize:is_big];
        label_number_barmap[i] = label;
    }
    
	CHECK_GL_ERROR_DEBUG();
}


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene:(GameLevel)game_level
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ChessBoardLayer *layer = [[ChessBoardLayer alloc] initWithLevel:game_level];//[ChessBoardLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

@end
