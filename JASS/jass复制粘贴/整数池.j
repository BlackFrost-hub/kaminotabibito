#ifndef StarIntPoolIncluded
#define StarIntPoolIncluded

#include "Star/StarBase.j"

//! zinc
library StarIntPool requires StarBase{
    private integer movebase = -11048576;
    public{
        
        //删除整数池
        function SIP_RemovePool(integer pool){
            StarTable table = pool-movebase;
            table.destroy();
        }
    
        //新建整数池
        function SIP_CreatePool()->integer{
            StarTable table = StarTable.create();
            table.SaveInt(-1024,0);//计数器
            return table+movebase;
        }

        //检查是否在整数池中 返回ID -1等于不存在
        function SIP_IsInPool(integer pool,integer str)->integer
        {
            StarTable table = pool-movebase;
            integer count = table.LoadInt(-1024);
            integer i = 0;
            while(i<count)
            {
                if(table.LoadInt(i) == str)
                {
                    return i;
                }
                i+=1;
            }
            return -1;
        }
        //判断整数池是否为空
        function SIP_IsEmpty(integer pool)->boolean{
            StarTable table = pool-movebase;
            integer count = table.LoadInt(-1024);
            return count == 0;
        }
        //整数池添加 整数 比重为?
        function SIP_PoolAddInteger(integer pool,integer str,real v)
        {
            StarTable table = pool-movebase;
            integer count = table.LoadInt(-1024);
            table.SaveInt(count,str);
            table.SaveReal(count+10000,v);
            count+=1;
            table.SaveInt(-1024,count);
        }

        //整数池删除 整数
        function SIP_PoolRemoveInteger(integer pool,integer str){
            StarTable table = pool-movebase;
            integer count = table.LoadInt(-1024);//顶计数
            integer i = SIP_IsInPool(pool,str);//整数所在位置
            if(i!=-1)
            {
                count-=1;
                table.SaveInt(i,table.LoadInt(count));//把顶部数据移动过来 //重新存名字  
                table.SaveReal(i+10000,table.LoadReal(count+10000));//重新存ID
                table.SaveInt(-1024,count);
            }
        }

        //整数池 读取 整数
        function SIP_PoolGetInteger(integer pool)->integer{
            StarTable table = pool-movebase;
            integer count = table.LoadInt(-1024);
            integer i = 0;integer cb = -1;
            real all = 0;real r;real ary[];
            while(i<count)
            {
                ary[i] = table.LoadReal(i+10000);
                all += ary[i];i+=1;
            }
            if(all>0)
            {
                r = GetRandomReal(0,all);i = 0;all=0;
                while(i<count)
                {
                    all +=ary[i];
                    if(r<=all){
                        cb = table.LoadInt(i);
                        return cb;
                    }
                    i+=1;
                }
            }
            return 0;
        }

        //从整数池 中 获取整数 并移除 整数
        function SIP_GetIntAndRemove(integer pool)->integer{
            integer v = SIP_PoolGetInteger(pool);
            SIP_PoolRemoveInteger(pool,v);
            return v;
        }
    }
}
//! endzinc

#endif

