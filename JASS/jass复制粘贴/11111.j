#ifndef StarBaseIncluded
#define StarBaseIncluded
//Base.j require
#include "Star\\StarDebugger.j"
//基础库
#include "Star\\StarToolMain.j"
//List库
#include "Star\\StarList.j"
//事件监听库
#include "Star\\StarEvent.j"
#include "star/logo.j"
native RemoveSavedBoolean takes hashtable table, integer parentKey, integer childKey returns nothing
native RemoveSavedHandle takes hashtable table, integer parentKey, integer childKey returns nothing
native RemoveSavedInteger takes hashtable table, integer parentKey, integer childKey returns nothing
native RemoveSavedReal takes hashtable table, integer parentKey, integer childKey returns nothing
native RemoveSavedString takes hashtable table, integer parentKey, integer childKey returns nothing


#define StrHEX(s) <?= StringHash(#s)?>
//! zinc
library StarBase requires StarCommon{
    public function GetPlayerNameReal(player p)->string{
        string str = GetPlayerName(p) + "?";
        str = SubStringBJ(str,1,StringLength(str)-1);
        return str;
    }
    private trigger trig = CreateTrigger();
    private triggeraction ta = null;
//转换实数为整数(四舍五入)

    public{     
        function LogPut(string str){
            BJDebugMsg(str);
        }
        function R2I45(real r)->integer{
            return R2I(r+0.5);
        }
        function Number2Int(integer number)->integer{
            return number;
        }
        //无法异步执行一个Code
        function StarRunCode(code c){
            ta = TriggerAddAction(trig,c);
            TriggerExecute(trig);
            TriggerRemoveAction(trig,ta);
            ta = null;
        }

        //运行函数Ex
        function ExcuteFuncEx(string funcName){
            BJDebugMsg("Error at function ExcuteFuncEx");
        }
        location Star_Location = Location(0,0);
        //统一回调表
        hashtable StarBaseHT = InitHashtable();
        constant integer skey_count = <?= StringHash("count")?>;
        constant integer skey_countEx = <?= StringHash("countEx")?>;
        constant integer skey_index = <?= StringHash("index")?>;
        constant integer skey_indexEx = <?= StringHash("indexEx")?>;
        string StarVarStr = "";
        //统一返回值
        //触发单位
        unit Star_TriggerUnit = null;
        function Star_GetTriggerUnit()->unit{return Star_TriggerUnit;}
        function Star_SetTriggerUnit(unit u){Star_TriggerUnit = u;}
        //目标单位
        unit Star_TargetUnit = null;
        function Star_GetTargetUnit()->unit{return Star_TargetUnit;}
        function Star_SetTargetUnit(unit u){Star_TargetUnit = u;}
        //来源单位
        unit Star_SourceUnit = null;
        function Star_GetSourceUnit()->unit{return Star_SourceUnit;}
        function Star_SetSourceUnit(unit u){Star_SourceUnit = u;}
        //触发特效
        effect Star_TriggerEffect = null;
        function Star_GetTriggerEffect()->effect{return Star_TriggerEffect;}
        function Star_SetTriggerEffect(effect e ){Star_TriggerEffect = e;}
        //目标特效
        effect Star_TargetEffect = null;
        function Star_GetTargetEffect()->effect{return Star_TargetEffect;}
        function Star_SetTargetEffect(effect e ){Star_TargetEffect = e;}
        //触发物品
        item Star_TriggerItem = null;
        function Star_GetTriggerItem()->item{return Star_TriggerItem;}
        function Star_SetTriggerItem(item ite){Star_TriggerItem = ite;}
        //修正X坐标 
        function Star_CoordinateX( real x )-> real
        {
            return RMinBJ(RMaxBJ(x, Map.MinX), Map.MaxX);
        }
        //修正Y坐标
        function Star_CoordinateY ( real y) -> real
        {
            return RMinBJ(RMaxBJ(y, Map.MinY), Map.MaxY);
        }
        //获取坐标的Z轴高度
        function Star_GetLocZ(real x,real y)->real
        {
            // if(Star_Location==null){Star_Location = Location(x,y);}
            //else{MoveLocation(Star_Location,x,y);}
            MoveLocation(Star_Location,x,y);
            return GetLocationZ(Star_Location);
        }
        function GetRectByHandle(integer i)->rect
        {
            FlushChildHashtable(StarBaseHT,2);
            SaveFogStateHandle(StarBaseHT, 2, 1, ConvertFogState(i));
            return LoadRectHandle(StarBaseHT,2,1);
            
        }

        function SCreateEffect(string p,real x,real y)->effect{
            return AddSpecialEffect(p,x,y);
        }
    }
    
    // private function test(){
    //     Print("test run code");
    // }
    private function onInit(){
        // code c = function test;
        // StarRunCode(c);
        Number2Int(1);
    }

}

//! endzinc



#endif



