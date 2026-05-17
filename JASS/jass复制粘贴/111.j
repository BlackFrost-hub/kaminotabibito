

#ifndef StarUI2Included
#define StarUI2Included

//引用基本库
#include "Star\\StarBase.j"

#include "Star\\BlizzardAPI.j"
//导入资源文件

#include "Star\\insert.j"
#include "Star/StarUnit.j"
    //! zinc    

    library StarUI2 requires StarUnit
    {
        //回城读条
        //
        private{
            integer frames[];
            real time[];
            real timemax[];
            trigger cbtrig[];
            boolean TimerIsRun = false;
            timer maintimer = CreateTimer();
            integer counts = 4;
            real dealtTime = 0.02;
            //回调的玩家
            player cbplayer;
            //回调的事件ID 1 ==吟唱完成 2 == 吟唱中断
            integer cbeid;
            real timed = 0;
            //
            real uix = 0;
            real uiy = 0.375;
            //hpbar loc
            real hpbarx = 0;
            real hpbary = 0;
            unit targetunit[];

            //施法进度条风格
            integer uistyle = 1;

            integer hpbarstyle =1;
        }
        //获取触发玩家
        public function SUI2_GetPlayer()->player
        {
            return cbplayer;
        }
        //获取触发的事件ID
        public function SUI2_GetEventID()->integer
        {
            return cbeid;
        }
        //获取已经吟唱时间
        public function SUI2_GetTimedOnStop()->real
        {
            return timed;
        }
        //被打断
        public function SUI2_GetIsStopd()->boolean
        {
            return cbeid==2;
        }
        //初始化玩家数量
        public function SUI2_SetPlayers(integer count)
        {
            counts = count;
        }
        //是否隐藏血条
        public function SUI2_HideHpbar(integer id,boolean b)
        {
            //显示血条
            if(b)
            {
                //Print("隐藏Player("+I2S(id)+")的血条显示！");
                targetunit[id] = null;
                //为玩家:id 隐藏UI
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameShow( frames[4], false );
                    DzFrameShow( frames[5], false );
                    DzFrameShow( frames[6], false );
                    DzFrameShow( frames[7], false );
                    DzFrameShow( frames[8], false );
                }
            }
            else
            {
                //显示UI
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameShow( frames[4], true );
                    DzFrameShow( frames[5], true );
                    DzFrameShow( frames[6], true );
                    DzFrameShow( frames[7], true );
                    DzFrameShow( frames[8], true );
                }
            }
        }
        //设置血条模型
        public function SUI2_SetHpBarModel(integer pid,string s1,string s2)
        {
            if(GetLocalPlayer()==Player(pid))
            {
                DzFrameSetModel( frames[4], s1, 0, 0 );
                DzFrameSetModel( frames[5], s2, 0, 0 );
                DzFrameSetAnimate( frames[4], 0, false );
                DzFrameSetAnimateOffset( frames[4], 0.90 );
                DzFrameSetAbsolutePoint( frames[4], 7, 0.4-hpbarx, 0.525-hpbary );
                DzFrameSetSize( frames[4], 0.01, 0.01 ); 
                DzFrameSetPoint( frames[5], 4, frames[4], 4, 0, 0.0 );
            }
        }
        //设置血条风格
        public function SUI2_SetHpBarStyle(integer pid,integer id)
        {
            if(id==1)
            {
                SUI2_SetHpBarModel(pid,"UI_shengmingzhi_g2.mdl","UI_shengmingzhi-beijing_g2.mdl");
            }
            else if(id==2)
            {
                SUI2_SetHpBarModel(pid,"UI_shengmingzhi_gb2.mdl","UI_shengmingzhi-beijing_gb2.mdl");
            }
            else if(id==3)
            {
                SUI2_SetHpBarModel(pid,"UI_shengmingzhi_o2.mdl","UI_shengmingzhi-beijing_o2.mdl");
            }
            else if(id==4)
            {
                SUI2_SetHpBarModel(pid, "UI_shengmingzhi_r2.mdl","UI_shengmingzhi-beijing_r2.mdl");
            }
            else if(id==5)
            {
                SUI2_SetHpBarModel(pid,"UI_shengmingzhi_p2.mdl","UI_shengmingzhi-beijing_p2.mdl");
            }
        }
        //隐藏UI
        public function SUI2_HideUI(integer id,boolean b)
        {   
            if(b)
            {
                //为玩家:id 隐藏UI
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameShow( frames[0], false );
                    DzFrameShow( frames[1], false );
                    DzFrameShow( frames[2], false );
                    DzFrameShow( frames[3], false );
                }
            }
            else
            {
                //显示UI
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameShow( frames[0], true );
                    DzFrameShow( frames[1], true );
                    DzFrameShow( frames[2], true );
                    DzFrameShow( frames[3], true );
                }
            }
        }
        //刷新血条显示
        public function SUI2_BrushHpbar(integer id)
        {
            real hp = GetUnitState(targetunit[id],UNIT_STATE_LIFE);
            real hpmax = GetUnitState(targetunit[id],UNIT_STATE_MAX_LIFE);
            real s = hp/hpmax;
            // string str = R2SW(hp,1,1);
            // str = str + "/";
            // str = str + R2SW(hpmax,1,1);
            string str = "|c0074fa27["+R2SW(s * 100,1,1)+"%]|r";
            if(GetLocalPlayer()==Player(id))
            {
                //设置血条进度
                DzFrameSetAnimateOffset( frames[4], s);
                DzFrameSetText(frames[6],str);
            }
            if(hp<0)
            {
                SUI2_HideHpbar(id,true);
            }

        }
        //刷新UI
        public function SUI2_BrushUI(integer id)
        {
            real s = time[id]/timemax[id];
            string str = R2SW(timemax[id]-time[id],1,1);
            if(uistyle!=7)
            {
                str = str + "/";
                str = str + R2SW(timemax[id],1,1);
            }
            else
            {
                str = "|c00cefafa" + str +"|r";
            }
            if(GetLocalPlayer()==Player(id))
            {
                DzFrameSetAnimateOffset( frames[0], 1-s);
                DzFrameSetText(frames[2],str);
            }
        }
//显示/隐藏BOSS施法条
public function SUI2_HideUI_Boss(boolean b)
{   
    if(b)
    {
        DzFrameShow( frames[100], false );
        DzFrameShow( frames[101], false );
        DzFrameShow( frames[102], false );
        DzFrameShow( frames[103], false );
    }
    else
    {
        DzFrameShow( frames[100], true );
        DzFrameShow( frames[101], true );
        DzFrameShow( frames[102], true );
        DzFrameShow( frames[103], true );
    }
}
        //BOSS的施法条刷新
        public function SUI2_BrushUI_Boss()
        {
            integer nid = 100;
            real s = time[nid]/timemax[nid];
            string str = R2SW(timemax[nid]-time[nid],1,1);
            if(uistyle!=7)
            {
                str = str + "/";
                str = str + R2SW(timemax[nid],1,1);
            }
            else
            {
                str = "|c00cefafa" + str +"|r";
            }
            DzFrameSetAnimateOffset( frames[100], 1-s);
            DzFrameSetText(frames[102],str);
        }
        //计时器事件
        private function te()
        {
            integer i =0;
            boolean b=true;
            //BOSS施法条部分
            if(time[100]<timemax[100])
            {
                time[100]+=dealtTime;
                SUI2_BrushUI_Boss();
                b = false;
                if(time[100]>=timemax[100])
                {
                    SUI2_HideUI_Boss(true);
                }
            }
            while(i<counts)
            {
                if(time[i] <timemax[i])
                {
                    //BJDebugMsg("123");
                    //施法条部分
                    b = false;
                    time[i]+=dealtTime;
                    SUI2_BrushUI(i);
                    if(time[i] >=timemax[i])
                    {
                        //结束读条
                        //调用触发回调
                        cbplayer = Player(i);
                        cbeid = 1;
                        timed = timemax[i];
                        if(TriggerEvaluate(cbtrig[i]))
                        {
                            TriggerExecute(cbtrig[i]);
                        }
                        timemax[i] = 0;
                        time[i] = 0;
                        SUI2_HideUI(i,true);
                    }
                }
                //BJDebugMsg(GetUnitName(targetunit[i]));
                if(targetunit[i] != null)
                {
                    if(!SU_IsUnitDie(targetunit[i]))
                    {
                        //BJDebugMsg("brush");
                        //血条部分
                        b = false;

                        SUI2_BrushHpbar(i);
                    }else{
                        //Print("隐藏血条");
                        SUI2_HideHpbar(i,true);
                    }
                }
                
                i+=1;
            }
            if(b)
            {
                //BJDebugMsg("stopd");
                TimerIsRun = false;
                PauseTimer(maintimer);
            }
        }
                //显示BOSS施法条 时间 颜色
                public function SUI2_SetTime_Boss(real t,string text)
                {
                    integer id = 100;
                    if(t>0)
                    {
                        time[id] = 0;
                        timemax[id] = t;
                        SUI2_HideUI_Boss(false);
                        if(!TimerIsRun)
                        {
                            TimerIsRun = true;
                            TimerStart(maintimer,dealtTime,true,function te);
                        }
                        DzFrameSetText(frames[103],text);
                    }
                }
        
                
        //中断读条
        public function SUI2_Stop(integer id)->real
        {
            real cbreal = time[id];
            if(timemax[id]>0)
            {
                cbplayer = Player(id);
                cbeid = 2;
                timed  = cbreal;
                if(TriggerEvaluate(cbtrig[id]))
                {
                    TriggerExecute(cbtrig[id]);
                }
                SUI2_HideUI(id,true);
                time[id] = 0;
                timemax[id] = 0;
            }

            return cbreal;
        }
        //unui 设置自定义模型
        public function SUI2_SetModel(integer id,string s1,string s2)
        {
            if(GetLocalPlayer()==Player(id))
            {
                DzFrameSetModel( frames[0], s1, 0, 0 );
                DzFrameSetModel( frames[1], s2, 0, 0 );
                DzFrameSetAnimate( frames[0], 0, false );
                DzFrameSetAnimateOffset( frames[0], 0.90 );
            }
        }
        //设置样式（颜色）
        public function SUI2_SetColor(integer id,integer color)
        {
            uistyle = color;
            if(color==1)
            {
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_gb2.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_gb2.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy );
                    //DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
                }
            }
            else if(color==2)
            {
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_o2.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_o2.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy );
                    //DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
                }
            }
            else if(color==3)
            {
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_r2.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_r2.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
                }
            }
            else if(color==4)
            {
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_p2.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_p2.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
                }
            }
            else if(color==5)
            {
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_g2.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_g2.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
                }
            }
            else if(color==6)
            {
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_t1.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_t1.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
                }
            }
            else if(color==7)
            {
                if(GetLocalPlayer()==Player(id))
                {   
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_lo4.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_lo4.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy+0.02 );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, -0.0025 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.02 );
                }
            }
            else if(color==8)
            {
                if(GetLocalPlayer()==Player(id))
                {   
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_bl4.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_bl4.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy+0.02 );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, -0.0025 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.02 );
                }
            }
            else if(color==9)
            {
                if(GetLocalPlayer()==Player(id))
                {   
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_pop4.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_pop4.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy+0.02 );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, -0.0025 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.02 );
                }
            }
            else
            {
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetModel( frames[0], "UI_shengmingzhi_b2.mdl", 0, 0 );
                    DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_b2.mdl", 0, 0 );
                    DzFrameSetAnimate( frames[0], 0, false );
                    DzFrameSetAnimateOffset( frames[0], 0.90 );
                    //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, 0-uiy );
                    DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
                    DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
                    DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
                }
            }
        }
        //让玩家[i]显示吟唱条并开始读条 会打断
        public function SUI2_SetTime(integer id,real t,string text,trigger callback)
        {
            if(timemax[id]!=0)
            {
                SUI2_Stop(id);
            }
            if(t>0)
            {
                time[id] = 0;
                timemax[id] = t;
                cbtrig[id] = callback;

                SUI2_HideUI(id,false);

                if(!TimerIsRun)
                {
                    TimerIsRun = true;
                    TimerStart(maintimer,dealtTime,true,function te);
                }
                
                if(GetLocalPlayer()==Player(id))
                {
                    DzFrameSetText(frames[3],text);
                }
            }
            else
            {
                SUI2_Stop(id);
            }
        }
        //使玩家显示读条
        public function SUI2_ShowHpbar(integer id,unit u)
        {
            targetunit[id] = u;

            if(targetunit[id] != null)
            {
                SUI2_HideHpbar(id,false);
                DzFrameSetText(frames[7],GetUnitName(u));
            }
            else
            {
                SUI2_HideHpbar(id,true);
            }
            if(TimerIsRun!=true)
            {
                //BJDebugMsg("rund");
                TimerIsRun = true;
                TimerStart(maintimer,dealtTime,true,function te);
            }

        }
        //设置相对于顶部的位置
        public function SUI2_SetLoc(real x,real y)
        {
            //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, x, y*-1 );
            DzFrameSetPoint( frames[0], 1, frames[4], 7, x, y*-1);
            DzFrameSetSize( frames[1], 0.01, 0.01 );    
            DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
            DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
            uix = x;
            uiy = y;
        }
        //设置血条的相对位置
        public function SUI2_SetHpbarLoc(real x,real y)
        {
            //DzFrameSetPoint( frames[3], 1, DzFrameGetTopMessage(), 7, , y*-1 );
            DzFrameSetAbsolutePoint( frames[4], 7, 0.4 - x, 0.525+y*-1 );
            DzFrameSetSize( frames[4], 0.01, 0.01 ); 
            // if(false)
            // {
            //     DzFrameSetPoint( frames[5], 4, frames[0], 4, 0, 0.015 );
            //     DzFrameSetPoint( frames[6], 4, frames[0], 4, 0, 0.03 );
            // }
            hpbarx = x;
            hpbary = y;
        }
        public function SUI2_E2I(integer i)->integer
        {
            return i;
        }
        //系统初始化
        function onInit()
        {
            //加载文件列表
            DzLoadToc( "Starcustom.toc" );
            //初始化UI栏  - 血条
            //血条遮罩
            frames[4] = DzCreateFrameByTagName("SPRITE", "name", DzGetGameUI(), "template", 0);
            // DzFrameSetModel( frames[4], "UI_shengmingzhi_r2.mdl", 0, 0 );
            DzFrameSetModel( frames[4], "UI_HpBar_new.mdx", 0, 0 );
            //DzFrameSetPoint( frames[4], 1, DzFrameGetTopMessage(), 7, 0, -0.0 );
            DzFrameSetAbsolutePoint( frames[4], 7, 0.4, 0.525 );
            DzFrameSetSize( frames[4], 0.01, 0.01 );
            DzFrameSetAnimate( frames[4], 0, false );
            DzFrameSetAnimateOffset( frames[4], 0.90 );
            DzFrameShow( frames[4], false );
            //血条底框
            frames[5] = DzCreateFrameByTagName("SPRITE", "name", DzGetGameUI(), "template", 0);
            // DzFrameSetModel( frames[5], "UI_shengmingzhi-beijing_r2.mdl", 0, 0 );
            DzFrameSetModel( frames[5], "UI_HpBar_BG_new.mdx", 0, 0 );
            DzFrameSetPoint( frames[5], 4, frames[4], 4, 0, 0 );
            DzFrameSetSize( frames[5], 0.01, 0.01 );    
            DzFrameShow( frames[5], false );
            //生命值
            frames[6] = DzCreateFrame("GameTextBG", DzGetGameUI(), 12347);
            //frames[2] = DzCreateFrameByTagName("GameTextBGs", "name", DzGetGameUI(), "template", 0);
            
            DzFrameSetPoint( frames[6], 4, frames[4], 4, 0.0, 0.015 );
            
            DzFrameShow( frames[6], false );
            //DzFrameSetFont(frames[2],"宋体",0.08,0);
            //单位名字
            frames[7] = DzCreateFrameByTagName("TEXT", "name", DzGetGameUI(), "template", 0);
            //frames[3] = DzCreateFrame("GameText", DzGetGameUI(), 12348);
            DzFrameSetPoint( frames[7], 3, frames[4], 4, -0.13, 0.015 );
            //DzFrameSetFont(frames[3],"宋体",0.04,0);
            DzFrameShow( frames[7], false );
            
            //血条左框
            frames[8] = DzCreateFrame("GameUI", DzGetGameUI(), 12349);
            DzFrameSetPoint( frames[8], 5, frames[4], 3, -0.117, 0.0056 );
            DzFrameSetTexture(frames[8],"boss_logo.blp",0);
            DzFrameSetSize(frames[8],0.07,0.07);
            DzFrameShow( frames[8], false );
            //初始化UI栏  - 施法条
            frames[0] = DzCreateFrameByTagName("SPRITE", "name", DzGetGameUI(), "template", 0);
            DzFrameSetModel( frames[0], "UI_shengmingzhi_gb2.mdl", 0, 0 );
            DzFrameSetPoint( frames[0], 1, frames[4], 7, 0, -0.375 );
            //DzFrameSetPoint( frames[0], 1, DzFrameGetTopMessage(), 7, 0, -0.375 );
            //DzFrameSetAbsolutePoint( frames[0], 7, 0.4, 0.525-0.375  );
            DzFrameSetSize( frames[0], 0.01, 0.01 );
            DzFrameSetAnimate( frames[0], 0, false );
            DzFrameSetAnimateOffset( frames[0], 0.90 );
            DzFrameShow( frames[0], false );
            frames[1] = DzCreateFrameByTagName("SPRITE", "name", DzGetGameUI(), "template", 0);
            DzFrameSetModel( frames[1], "UI_shengmingzhi-beijing_gb2.mdl", 0, 0 );
            DzFrameSetPoint( frames[1], 4, frames[0], 4, 0, 0 );
            DzFrameSetSize( frames[1], 0.01, 0.01 );    
            DzFrameShow( frames[1], false );
            frames[2] = DzCreateFrame("GameTextBG", DzGetGameUI(), 12345);
            //frames[2] = DzCreateFrameByTagName("GameTextBGs", "name", DzGetGameUI(), "template", 0);
            DzFrameSetPoint( frames[2], 4, frames[0], 4, 0, 0.015 );
            DzFrameShow( frames[2], false );
            //DzFrameSetFont(frames[2],"宋体",0.08,0);
            frames[3] = DzCreateFrameByTagName("TEXT", "name", DzGetGameUI(), "template", 0);
            //frames[3] = DzCreateFrame("GameText", DzGetGameUI(), 12346);
            DzFrameSetPoint( frames[3], 4, frames[0], 4, 0, 0.03 );
            //DzFrameSetFont(frames[3],"宋体",0.04,0);
            DzFrameShow( frames[3], false );


            //初始化UI栏  - 施法条--BOSS 旅行者2

            frames[100] = DzCreateFrameByTagName("SPRITE", "name", DzGetGameUI(), "template", 0);
            DzFrameSetModel( frames[100], "UI_shengmingzhi_pop4.mdl", 0, 0 );
            DzFrameSetPoint( frames[100], 1, frames[4], 7, 0, -0.015 );
            DzFrameSetSize( frames[100], 0.01, 0.01 );
            DzFrameSetAnimate( frames[100], 0, false );
            DzFrameSetAnimateOffset( frames[100], 0.90 );
            DzFrameShow( frames[100], false );
            frames[101] = DzCreateFrameByTagName("SPRITE", "name", DzGetGameUI(), "template", 0);
            DzFrameSetModel( frames[101], "UI_shengmingzhi-beijing_pop4.mdl", 0, 0 );
            DzFrameSetPoint( frames[101], 4, frames[100], 4, 0, 0 );
            DzFrameSetSize( frames[101], 0.01, 0.01 ); 
            DzFrameShow( frames[101], false );
            frames[102] = DzCreateFrame("GameTextBG", DzGetGameUI(), 12444);
            DzFrameSetPoint( frames[102], 4, frames[100], 4, 0,  0.015 );
            DzFrameShow( frames[102], false );
            frames[103] = DzCreateFrameByTagName("TEXT", "name", DzGetGameUI(), "template", 0);
            DzFrameSetPoint( frames[103], 4, frames[100], 4, 0,  0 );
            DzFrameShow( frames[103], false );

        }
    }
    
    //! endzinc
    library OriginGameFrame

        //获取物品名称
        function GetFrameItemNameFrame takes nothing returns integer
        return DzSimpleFontStringFindByName("SimpleItemNameValue",3)
        endfunction
        //获取物品说明
        function GetFrameItemTipsFrame takes nothing returns integer
        return DzSimpleFontStringFindByName("SimpleItemDescriptionValue",3)
        endfunction
        
        //英雄面板父对象
        function GetFrameHeroStatePanelFrame takes nothing returns integer
        return DzSimpleFrameFindByName("SimpleInfoPanelIconDamage", 0)
        endfunction
        //英雄主属性父对象
        function GetFrameHeroPanel takes nothing returns integer
        return DzSimpleFrameFindByName("SimpleInfoPanelIconHero", 6)
        endfunction
        
        
        //获取单位名称
        function GetFrameUnitNameFrame takes nothing returns integer
        return DzSimpleFontStringFindByName("SimpleNameValue",0)
        endfunction
        //获取英雄称谓
        function GetFrameUnitClassFrame takes nothing returns integer
        return DzSimpleFontStringFindByName("SimpleClassValue",0)
        endfunction
        
        
        
        //获取单位攻击图标
        function GetFrameUnitAttackIcon takes integer index returns integer
        return DzSimpleTextureFindByName("InfoPanelIconBackdrop",index)
        endfunction
        //单位攻击标签
        function GetFrameUnitAttackLabel takes integer index returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconLabel",index)
        endfunction
        //单位攻击数值
        function GetFrameUnitAttackValue takes integer index returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconValue",index)
        endfunction
        
        //获取单位护甲图标
        function GetFrameUnitArmorIcon takes nothing returns integer
        return DzSimpleTextureFindByName("InfoPanelIconBackdrop",2)
        endfunction
        //单位护甲标签
        function GetFrameUnitArmorLabel takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconLabel",2)
        endfunction
        //单位护甲数值
        function GetFrameUnitArmorValue takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconValue",2)
        endfunction
        
        //获取金矿黄金图标
        function GetFrameUnitAttack2Icon takes nothing returns integer
        return DzSimpleTextureFindByName("InfoPanelIconBackdrop",5)
        endfunction
        
        
        //英雄主属性图标
        function GetFrameHeroPanelIcon takes nothing returns integer
        return DzSimpleTextureFindByName("InfoPanelIconHeroIcon", 6)
        endfunction
        
        
        //获取生命周期条
        function GetFrameProgressBar takes nothing returns integer
        return DzSimpleFrameFindByName("SimpleProgressIndicator", 0)
        endfunction
        //获取英雄经验条
        function GetFrameHeroLevelBar takes nothing returns integer
        return DzSimpleFrameFindByName("SimpleHeroLevelBar", 0)
        endfunction
        
        //英雄属性数值
        function GetFrameHeroStrValue takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconHeroStrengthValue",6)
        endfunction
        function GetFrameHeroAgiValue takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconHeroAgilityValue",6)
        endfunction
        function GetFrameHeroIntValue takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconHeroIntellectValue",6)
        endfunction
        
        //英雄属性标签
        function GetFrameHeroStrLabel takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconHeroStrengthLabel",6)
        endfunction
        function GetFrameHeroAgiLabel takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconHeroAgilityLabel",6)
        endfunction
        function GetFrameHeroIntLabel takes nothing returns integer
        return DzSimpleFontStringFindByName("InfoPanelIconHeroIntellectLabel",6)
        endfunction
        
        //英雄属性标签 带参数
        function GetFrameHeroStateLabel takes integer index returns integer
        if index == 1 then
        return GetFrameHeroStrLabel()
        elseif index == 2 then
        return GetFrameHeroAgiLabel()
        elseif index == 3 then
        return GetFrameHeroIntLabel()
        endif
        return 0
        endfunction
        //英雄属性数值 带参数
        function GetFrameHeroStateValue takes integer index returns integer
        if index == 1 then
        return GetFrameHeroStrValue()
        elseif index == 2 then
        return GetFrameHeroAgiValue()
        elseif index == 3 then
        return GetFrameHeroIntValue()
        endif
        return 0
        endfunction
        
        
        function GetFrameUnitStatePanelFrame takes nothing returns integer
        return DzSimpleFrameFindByName("SimpleInfoPanelIconHeroText", 6)
        endfunction
        function GetFrameUnitDetail takes nothing returns integer
        return DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0)
        endfunction
        
        endlibrary
        
    
    #endif
    
    
    
    