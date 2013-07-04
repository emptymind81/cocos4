#ifndef SUDOKU_RICK_0701_
#define SUDOKU_RICK_0701_
class CSudoku
{
   int map[9][9];
   int smod;
   int solves;
   int check(int,int,int*);
   void dfs();

   int bak_map[9][9];
    int full_map[9][9];
public:
   enum{ANY=0,ALL=1,CHECKUNIQUE=2};
   CSudoku(int n=40);
   CSudoku(int *data);
   virtual ~CSudoku();
   void display();
   int resolve(int mod=ALL);
    
    int GetValue(int i, int j){return map[i][j];}
    int GetFullValue(int i, int j){return full_map[i][j];}
    
    void SetValue(int i, int j, int value){map[i][j] = value;}
    
    bool IsCorrectFilled();
};
#endif