#ifndef StarGameDialogIncluded
#define StarGameDialogIncluded

//引用基本库
//#include "Star\\StarBase.j"

#include "Star\\BlizzardAPI.j"
//导入资源文件

#include "Star\\insert.j"

//! zinc
library StarGameDialog requires StarBase{
public integer SGD_Frames[];
private{
    timer t = CreateTimer();
    timer st = CreateTimer();
    string titleList[];
    string textList[];
    string leftTexPath[];
    string midTexPath[];
    string rightTexPath[];
    real waitTimeList[];
    boolean showList[];
    boolean isDisplay = true;//是否显示
    integer index = 0;//队列尾部
    integer now = 0;//队列顶部
    integer strlen;//字符串总长
    integer strnow;//字符串当前位置
    integer steplen = 2;//步长
}
//隐藏对话框 显示结束
private function show(boolean b){
    integer i = 0;
    if(isDisplay){
        while(i<4){
            DzFrameShow( SGD_Frames[i], b);
            i+=1;
        }
        if(b){
            DzFrameSetAlpha( SGD_Frames[0], 155);
        }
        i = 101;
        while(i<104){
            DzFrameShow( SGD_Frames[i], b);
            i+=1;
        }
    }else{
        while(i<4){
            DzFrameShow( SGD_Frames[i], false);
            i+=1;
        }
        i = 101;
        while(i<104){
            DzFrameShow( SGD_Frames[i], false);
            i+=1;
        }
    }

}
//插入一句对话框 //在末尾插入
private function insert(string t,string s,real r,string l,string m,string right){
    titleList[index] = t;
    textList[index] = s;
    waitTimeList[index] = r;
    leftTexPath[index] = l;
    midTexPath[index] = m;
    rightTexPath[index] = right;
    index += 1;
    if(index==1){
        play.execute();//调用显示
    }
}
//清空对话框队列
private function clear(){
    PauseTimer(t);
    now = 0;index = 0;   
    show(false);
}
//删除一句话 //首部删除
private function delete()->boolean{
    now = now + 1;
    if(now == index){//判断头尾相遇
        clear();//重置队列
        return true;
    }
    return false;
}
//显示一句
private function showLine(){
    TimerStart(t,0.03,true,function(){
        string str;strnow+=steplen;
        if(strnow>strlen){
            str = textList[now];
            DzFrameSetText( SGD_Frames[3], str);
            TimerStart(st,waitTimeList[now],false,function (){
                if(!delete()){
                    DzFrameSetText( SGD_Frames[2], titleList[now]);
                    strnow = 0 ;
                    strlen = StringLength(textList[now]);
                    showLine.execute();//显示下一段
                }
            });
            PauseTimer(t);
        }else{
            str = SubString(textList[now],0,strnow);
            DzFrameSetText( SGD_Frames[3], str);
        }
    });
}
//开始为玩家显示对话框
private function play(){
    show(true);
    //显示文本
    DzFrameSetText( SGD_Frames[2], titleList[now]);
    DzFrameSetText( SGD_Frames[3], "");

    //显示立绘
    if(leftTexPath[now]!=""){
        DzFrameSetTexture( SGD_Frames[101], leftTexPath[now], 0);
        DzFrameShow( SGD_Frames[101], true);
    }else{
        DzFrameShow( SGD_Frames[101], false);
    }
    if(midTexPath[now]!=""){
        DzFrameSetTexture( SGD_Frames[102], midTexPath[now], 0);
        DzFrameShow( SGD_Frames[102], true);
    }else{
        DzFrameShow( SGD_Frames[102], false);
    }
    if(rightTexPath[now]!=""){
        DzFrameSetTexture( SGD_Frames[103], rightTexPath[now], 0);
        DzFrameShow( SGD_Frames[103], true);
    }else{
        DzFrameShow( SGD_Frames[103], false);
    }
    //开始播放文本渐入
    strnow = 0 ;
    strlen = StringLength(textList[now]);
    showLine();
}
//对话框队列显示 标题,文本,显示时间
public function SDG_DisplayText(string title,string text,real time){
    if(time<=0){
        time = 1;
    }
    insert(title,text,time,"","","");
}
public function SDG_DisplayTextEx(string title,string text,real time,string left,string mid,string right){
    if(time<=0){
        time = 1;
    }
    insert(title,text,time,left,mid,right);
}
//清除对话框队列并隐藏对话框 用于跳过
public function SDG_Clear(){
    clear();
}
//设置玩家是否显示
public function SDG_SetShowable(player p,boolean b){
    if(GetLocalPlayer()==p){
        isDisplay =b;
    }
}
public function SDG_SetDialogTitleTexture(string path){
    DzFrameSetTexture( SGD_Frames[1], path, 0);
}
public function SDG_SetDialogBGTexture(string path){
    DzFrameSetTexture( SGD_Frames[0], path, 0);
}
//初始化生成控件
private function onLoad(){
    integer i = 101;
    integer tag=1125;
    DzLoadToc( "ui\\custom.toc");



    SGD_Frames[i] = DzCreateFrame( "GameUI", DzGetGameUI(), tag);
    printsi("SGD_Frames->",i);
    DzFrameShow( SGD_Frames[i], false);
    DzFrameClearAllPoints( SGD_Frames[i]);
    DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.24, 0.1421+0.2);
	DzFrameSetSize( SGD_Frames[i], 0.367/3, 0.231);
	DzFrameSetAlpha( SGD_Frames[i], 255);
	DzFrameSetTexture( SGD_Frames[i], "", 0);
    i+=1;tag+=1;

    SGD_Frames[i] = DzCreateFrame( "GameUI", DzGetGameUI(), tag);
    printsi("SGD_Frames->",i);
    DzFrameShow( SGD_Frames[i], false);
    DzFrameClearAllPoints( SGD_Frames[i]);
    DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.24+0.377/3, 0.1421+0.2);
	DzFrameSetSize( SGD_Frames[i], 0.367/3, 0.231);
	DzFrameSetAlpha( SGD_Frames[i], 255);
	DzFrameSetTexture( SGD_Frames[i], "", 0);

    i+=1;tag+=1;
    SGD_Frames[i] = DzCreateFrame( "GameUI", DzGetGameUI(), tag);
    printsi("SGD_Frames->",i);
    DzFrameShow( SGD_Frames[i], false);
    DzFrameClearAllPoints( SGD_Frames[i]);
    DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.24+0.377/1.5, 0.1421+0.2);
	DzFrameSetSize( SGD_Frames[i], 0.367/3, 0.231);
	DzFrameSetAlpha( SGD_Frames[i], 255);
	DzFrameSetTexture( SGD_Frames[i], "", 0);



    i = 0;tag = 1024;

    tag+=1;
    SGD_Frames[i] = DzCreateFrame( "GameUI", DzGetGameUI(), tag);
    DzFrameShow( SGD_Frames[i], true);
    DzFrameClearAllPoints( SGD_Frames[i]);
    // #ifdef Map_traveller
	//     DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.23, 0.2021);
    // #else
    //     DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.23, 0.2421);
    // #endif
    DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.23, 0.2421);
	DzFrameSetSize( SGD_Frames[i], 0.377, 0.131);
	DzFrameSetAlpha( SGD_Frames[i], 255);
	DzFrameSetTexture( SGD_Frames[i], "war3mapImported\\Star_Dialog_BG.blp", 0);
    //DzFrameSetEnable(SGD_Frames[i],false);//点击穿透

    i+=1;tag+=1;
	//文本框——名字——背景
    SGD_Frames[i] = DzCreateFrame( "GameUI", DzGetGameUI(), tag);
    DzFrameShow( SGD_Frames[i], true);
    DzFrameClearAllPoints( SGD_Frames[i]);
    // #ifdef Map_traveller
    //     DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.24, 0.2683);
    // #else
    //     DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.24, 0.3083);
    // #endif
    DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.24, 0.3083);
    DzFrameSetSize( SGD_Frames[i], 0.107, 0.0328);
    DzFrameSetAlpha( SGD_Frames[i], 255);
    DzFrameSetTexture( SGD_Frames[i], "war3mapImported\\Star_Dialog_Title.blp", 0);
    //DzFrameSetEnable(SGD_Frames[i],false);//点击穿透
	i+=1;tag+=1;
    //文字-名字
    SGD_Frames[i] = DzCreateFrame( "GameText", DzGetGameUI(), tag);
    DzFrameShow( SGD_Frames[i], true);
    DzFrameClearAllPoints( SGD_Frames[i]);
    // #ifdef Map_traveller
    //     DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.2425, 0.26);
    // #else
    //     DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.2425, 0.3);
    // #endif
    DzFrameSetAbsolutePoint( SGD_Frames[i], 3, 0.2425, 0.3);
    DzFrameSetSize( SGD_Frames[i], 0.1, 0.02);
    DzFrameSetText( SGD_Frames[i], "");
    DzFrameSetEnable(SGD_Frames[i],false);//点击穿透
	i+=1;tag+=1;
    //文字-说明
    SGD_Frames[i] = DzCreateFrame( "GameTextpxL", DzGetGameUI(), tag);
    DzFrameShow( SGD_Frames[i], true);
    DzFrameClearAllPoints( SGD_Frames[i]);
    // #ifdef Map_traveller
    //     DzFrameSetAbsolutePoint( SGD_Frames[i], 0, 0.24, 0.24);
    // #else
    //     DzFrameSetAbsolutePoint( SGD_Frames[i], 0, 0.24, 0.28);
    // #endif
    DzFrameSetAbsolutePoint( SGD_Frames[i], 0, 0.24, 0.28);
    DzFrameSetSize( SGD_Frames[i], 0.35, 0.22);
    DzFrameSetText( SGD_Frames[i], "");
    DzFrameSetEnable(SGD_Frames[i],false);//点击穿透
    i+=1;
    show(false);
}
private function onInit(){
    onLoad();
}
}
//! endzinc

#endif

