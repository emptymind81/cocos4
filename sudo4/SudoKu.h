#ifndef SUDOKU_RICK_0701_
#define SUDOKU_RICK_0701_

#import "Define.h"

class CSudoku
{
public:
    
   CSudoku(int n=40);
   CSudoku(GameLevel level);
   CSudoku(int *data);
   virtual ~CSudoku();
    
    
    
   void display();   
    
    int GetFullValue(int i, int j){return full_map[i][j];}
    
    bool IsReadonlyCell(int i, int j)
    {
        if(map[i][j] == 0)
        {
            return false;
        }
        return true;
    }
    
    int GetValue(int i, int j)
    {
        if(map[i][j] == 0)
        {
            return bak_map[i][j];
        }
        return map[i][j];
    }
    
    void SetValue(int i, int j, int value)
    {
        if(map[i][j] == 0)
        {
            bak_map[i][j] = value;
        }        
    }
    
    bool IsCorrectFilled();
    
private:
    int check(int,int,int*);
    void dfs();
    int resolve(int mod=ALL);
    
    void genFull();
    void digHoles(int n);
    
private:
    int map[9][9];
    int smod;
    int solves;
    
    int bak_map[9][9];
    int full_map[9][9];
    
    GameLevel game_level;
    
    enum{ANY=0,ALL=1,CHECKUNIQUE=2};
};
#endif