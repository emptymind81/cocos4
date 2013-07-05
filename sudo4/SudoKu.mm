
#import "SudoKu.h"
#include "stdio.h"
#include "stdlib.h"
#include "time.h"
CSudoku::CSudoku(int n)
{
   int i,j;
   srand(time(0));
   do
   {
      for(i=0;i<9;++i)
      {
         for(j=0;j<9;++j)
            map[i][j]=0;
         j=rand()%9;
         map[i][j]=i+1;
      }
   }
   while(!resolve(ANY));
    
    for(int m=0; m<9; m++)
    {
        for(int n=0; n<9; n++)
        {
            full_map[m][n] = map[m][n];
        }
    }
    
    
   // 挖窟窿,因为有的窟窿没挖成功，因此设置最多尝试2n次，不管实际挖了几个窟窿，都结束
   int tried = 0;
   for(int k=0;k<n&&tried<2*n;)
   {
      i=rand()%81;
      j=i%9;
      i=i/9;
      if(map[i][j]>0)
      {
         int old = map[i][j];
         map[i][j]=0;

         //bak the map because resolve will change it
         for(int m=0; m<9; m++)
         {
            for(int n=0; n<9; n++)
            {
               bak_map[m][n] = map[m][n];
            }
         }
         int is_unique = resolve(CHECKUNIQUE);
         for(int m=0; m<9; m++)
         {
            for(int n=0; n<9; n++)
            {
               map[m][n] = bak_map[m][n];
            }
         }
         //set back the map

         if(is_unique == 0)//not unique, so need to set back
         {
            map[i][j] = old;
            ++tried;
         }
         else
         {
            ++k;
         }
      }
   }
    
    for(int m=0; m<9; m++)
    {
        for(int n=0; n<9; n++)
        {
            bak_map[m][n] = 0;
        }
    }
    
    
   //printf("(randomized sudoku created with %d blanks.)\n",blanks);
}
CSudoku::CSudoku(int *data)
{
   int *pm=(int*)map;
   for(int i=0;i<81;++i)
      pm[i]=data[i];
}
CSudoku::~CSudoku()
{
   return;
}
void CSudoku::display()
{
   for(int i=0;i<9;++i)
   {
      for(int j=0;j<9;++j)
      {
         if(map[i][j]>0)
            printf("< %d >  ",map[i][j]);
         else
            printf("[   ]  ");
      }
      printf("\n");
   }
}
int CSudoku::resolve(int mod)
{
   smod=mod;
   if(mod==ALL)
   {
      solves=0;
      try
      {
         dfs();
      }
      catch(int)
      {
         int mm=0;
      }
      return solves;
   }
   else if(mod==ANY)
   {
      try
      {
         dfs();
         return 0;
      }
      catch(int)
      {
         return 1;
      }
   }
   else if(mod==CHECKUNIQUE)
   {
      try
      {
         solves=0;
         dfs();
         return 1;
      }
      catch(int)
      {
         return 0;//If catch a throw, then it's not unique, so return 0.
      }
   }
   return 0;
}
int CSudoku::check(int y,int x,int *mark)
{
   int i,j,is,js,count=0;
   for(i=1;i<=9;++i)
      mark[i]=0;
   for(i=0;i<9;++i)
      mark[map[y][i]]=1;
   for(i=0;i<9;++i)
      mark[map[i][x]]=1;
   is=y/3*3;
   js=x/3*3;
   for(i=0;i<3;++i)
   {
      for(j=0;j<3;++j)
         mark[map[is+i][js+j]]=1;
   }
   for(i=1;i<=9;++i)
      if(mark[i]==0)
         count++;
   return count;
}
void CSudoku::dfs()
{
   int i,j,im=-1,jm,min=10;
   int mark[10];
   for(i=0;i<9;++i)
   {
      for(j=0;j<9;++j)
      {
         if(map[i][j])
            continue;
         int c=check(i,j,mark);
         if(c==0)
            return;
         if(c<min)
         {
            im=i;
            jm=j;
            min=c;
         }
      }
   }
   if(im==-1)
   {
      if(smod==ALL)
      {
         printf("No. %d:\n",++solves);
         display();
         return;
      }
      else if(smod==ANY)
      {
         throw(1);
      }
      else if(smod == CHECKUNIQUE)
      {
         ++solves;
         if(solves > 1)
         {
            throw(1);
         }
         else
         {
            return;
         }
      }
   }
   check(im,jm,mark);
   for(i=1;i<=9;++i)
   {
      if(mark[i]==0)
      {
         map[im][jm]=i;
         dfs();
      }
   }
   map[im][jm]=0;
   //throw(1);
}

bool CSudoku::IsCorrectFilled()
{
    for(int i=0; i<9; i++)
    {
        for(int j=0; j<9; j++)
        {
            int value = map[i][j];
            if(value == 0)
            {
                value = bak_map[i][j];
            }
            if(value != full_map[i][j])
            {
                return false;
            }
        }
    }
    return true;
}
/*#include <iostream>
#include "sudoku.h"
using namespace std;
int _tmain(int argc, _TCHAR* argv[])
{
   int data1[]=
   {4,9,0,0,0,6,0,2,7,
   5,0,0,0,1,0,0,0,4,
   6,0,0,0,0,8,0,0,3,
   1,0,4,0,0,0,0,0,0,
   0,6,0,0,0,0,0,5,0,
   0,0,0,0,0,0,2,0,8,
   7,0,0,2,0,0,0,0,5,
   8,0,0,0,9,0,0,0,1,
   3,4,0,5,0,0,0,6,2
   };
   int data2[]=
   {7,4,0,0,8,0,0,1,6,
   9,0,0,0,3,5,0,0,4,
   0,0,0,7,0,0,0,0,0,
   0,7,0,0,0,9,5,0,0,
   6,1,0,0,5,0,0,8,7,
   0,0,2,6,0,0,0,4,0,
   0,0,0,0,0,4,0,0,0,
   3,0,0,5,6,0,0,0,2,
   5,6,0,0,1,0,0,3,9
   };
   int blanks;
   cout<<"随机生成一个数独,输入空格数";
   cin>>blanks;
   CSudoku s(blanks);
   s.display();
   cout<<"开始解数独:"<<endl;
   s.resolve();
   cin>>blanks;
   return 0;
}*/
