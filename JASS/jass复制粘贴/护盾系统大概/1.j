#ifndef InitShaodwShieldIncluded
#define InitShaodwShieldIncluded
#include "Star/ShaodwShieldinit.j"
#include "Star/TableEX.j"
#include "Star\\StarBase.j"

//! zinc
library ShaodwShield  requires TableEX,StarBase{
  private integer unitcode='iSSI';
  public struct ShieldData{
    public{
      static HandleTableEX ShieldTable;
      unit TakeUnit ;
      unit ProBar ;
      real Vaule;
      real Current;
      real BarTime;
      timer Timer;
    
      method DeleteData(){
          RemoveSavedInteger(StarBaseHT,GetHandleId(this.Timer),5555);
          DestroyTimer(this.Timer);
        // ReleaseTimer(this.Timer);
        this.Timer = null;
        this.TakeUnit = null;
        this.Vaule=0;
        this.Current=0;
        RemoveUnit(this.ProBar);
        this.ProBar= null;
        this.deallocate();
      }

      static method ShieldTime(){
        integer dz,dz2,Anima;
        //location d;
        ShieldData data = ShieldData(LoadInteger(StarBaseHT,GetHandleId(GetExpiredTimer()),5555));
        dz=thistype.ShieldTable[data.TakeUnit];
        dz2=integer(data);
        Anima=R2I(data.Current*100/data.Vaule);
        if(Anima==100) Anima=99;
        SetUnitX(data.ProBar,GetUnitX(data.TakeUnit));
        SetUnitY(data.ProBar,GetUnitY(data.TakeUnit));
        //d=Location(GetUnitX(data.TakeUnit),GetUnitY(data.TakeUnit));
        SetUnitAnimationByIndex( data.ProBar,Anima);
        SetUnitFlyHeight( data.ProBar,0/*Star_GetLocZ(GetUnitX(data.TakeUnit),GetUnitY(data.TakeUnit))-25*/, 1000000.00 );
        data.BarTime -=0.01;
        //RemoveLocation(d);
        //d=null;
        if(data.Current<=0 || data.BarTime<0  || dz!=dz2 ){
          data.DeleteData();
        }
      }

      static method create(unit u, real v,real t)-> ShieldData{                   
        ShieldData data = ShieldData.allocate();
        data.TakeUnit=u;
        data.ProBar=CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), unitcode, GetUnitX(u), GetUnitY(u), 0);
        data.Vaule=v;
        data.Current=v;
        data.BarTime=t;
        data.Timer=CreateTimer();
        SaveInteger(StarBaseHT,GetHandleId(data.Timer),5555,data);             
        //SetTimerData(data.Timer,integer(data));
        TimerStart(data.Timer ,0.01,true,function ShieldData.ShieldTime);
        thistype.ShieldTable[data.TakeUnit] = integer(data);
        UnitAddAbility( data.ProBar, 'Amrf' );
        UnitRemoveAbility( data.ProBar, 'Amrf' );
        //Print("获得新的护盾at->"+GetUnitName(u)+"value"+R2S(v)+"/"+R2S(v)+",持续"+R2S(t)+"秒");
        return data ;
      }

      static method onInit() {
        thistype.ShieldTable = HandleTableEX.create();
      }
    }  
  }
  private function HaveUintCode()->boolean {
    if(unitcode>0) return(true);
    BJDebugMsg("请先设置好护盾单位类型");
    return (false);
  }
  public function ShieldTake(unit u,real value,real t ){
    if(HaveUintCode()){
      ShieldData.create(u,value,t);
    }  
  }

  public function ShieldHave(unit u)->integer{
    if(HaveUintCode()){
      return (ShieldData.ShieldTable[u]);
    }else{
      return 0;
    }
  }

  public function SetShieldPorBar(integer uc){
    if(uc!=0)  unitcode=uc;
  }

  public function SetShieldVaule(unit u,real Vaule){
    ShieldData data = ShieldHave(u);
      if(data>0) data.Vaule=Vaule;
  }
  
  public function SetShieldCurrent(unit u,real Current){
    ShieldData data = ShieldHave(u);
      if(data>0) data.Current=Current;
  }

  public function SetShieldBarTime(unit u,real BarTime){
    ShieldData data = ShieldHave(u);
      if(data>0) data.BarTime=BarTime;
  }

  public function GetShieldBarTime(unit u)->real{
    ShieldData data = ShieldHave(u);
    if(data>0) return (data.BarTime);
    return 0;
  }
  
  public function GetShieldCurrent(unit u)->real{
    ShieldData data = ShieldHave(u);
    if(data>0) return (data.Current);
    return 0;
  }

  public function GetShieldVaule(unit u)->real{
    ShieldData data = ShieldHave(u);
    if(data>0) return (data.Vaule);
    return 0;
  }
  

}

//! endzinc
#endif
