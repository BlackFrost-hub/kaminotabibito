#ifndef StarStringRandomPool
#define StarStringRandomPool
#include "Star\\StarBase.j"
//! zinc
library StarStrRPool requires StarBase
{
public{

    //删除字符串随机池
    function SSRP_RemovePool(integer pool){
        StarTable table = pool;
        table.destroy();
    }

    //新建字符串随机池
    function SSRP_CreatePool()->integer{
        StarTable table = StarTable.create();
        table.SaveInt(-1024,0);//计数器
        return table;
    }

    //检查是否在字符串随机池中 返回ID -1等于不存在
    function SSRP_IsInPool(integer pool,string str)->integer
    {
        StarTable table = pool;
        integer count = table.LoadInt(-1024);
        integer i = 0;
        while(i<count)
        {
            if(table.LoadString(i) == str)
            {
                return i;
            }
            i+=1;
        }
        return -1;
    }

    //字符串随机池添加 字符串 比重为?
    function SSRP_PoolAddString(integer pool,string str,real v)
    {
        StarTable table = pool;
        integer count = table.LoadInt(-1024);
        //存字符串
        table.SaveString(count,str);
        //存ID
        table.SaveReal(count+10000,v);

        count+=1;
        table.SaveInt(-1024,count);
    }

    //字符串随机池删除 字符串 
    function SSRP_PoolRemoveString(integer pool,string str){
        StarTable table = pool;
        integer count = table.LoadInt(-1024);
        integer i = SSRP_IsInPool(pool,str);
        if(i!=-1)
        {
            count-=1;
            //重新存名字    
            table.SaveString(i,table.LoadString(count));
            //重新存ID
            table.SaveReal(i+10000,table.LoadReal(count+10000));
            table.SaveInt(-1024,count);
        }
    }

    //字符串随机池取出随机字符串
    function SSRP_PoolGetString(integer pool)->string{
        StarTable table = pool;
        string result;
        integer count = table.LoadInt(-1024);
        integer i = 0;
        real all = 0;
        real r;
        real ary[];
        while(i<count)
        {
            ary[i] = table.LoadReal(i+10000);
            all += ary[i];
            i+=1;
        }
        if(all>0)
        {
            r = GetRandomReal(0,all);
            i = 0;
            all=0;
            while(i<count)
            {
                all +=ary[i];
                if(r<=all){
                    result = table.LoadString(i);
                    SSRP_PoolRemoveString(pool,result);
                    return result;
                }
                i+=1;
            }
        }
        return "";
    }
}
function onInit(){

}
}
//! endzinc

#endif

