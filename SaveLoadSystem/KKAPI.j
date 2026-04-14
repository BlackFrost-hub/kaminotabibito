#ifndef KKAPIINCLUDE
#define KKAPIINCLUDE

library LBKKAPI
        globals
                // string MOVE_TYPE_NONE="none"//没有（无视碰撞）
                // string MOVE_TYPE_FOOT="foot"//步行
                // string MOVE_TYPE_HORSE="horse"//骑马
                // string MOVE_TYPE_FLY="fly"//飞行（还具有空中视野，也可以设置飞行高度）
                // string MOVE_TYPE_HOVER="hover"//浮空（不会踩中地雷）
                // string MOVE_TYPE_FLOAT="float"//漂浮（只能在深水里活动）
                // string MOVE_TYPE_AMPH="amph"//两栖
                // string MOVE_TYPE_UNBUILD="unbuild"//不可建造
                constant integer DEFENSE_TYPE_LIGHT=0
		constant integer DEFENSE_TYPE_MEDIUM=1
		constant integer DEFENSE_TYPE_LARGE=2
		constant integer DEFENSE_TYPE_FORT=3
		constant integer DEFENSE_TYPE_NORMAL=4
		constant integer DEFENSE_TYPE_HERO=5
		constant integer DEFENSE_TYPE_DIVINE=6
		constant integer DEFENSE_TYPE_NONE=7
        endglobals

        native DzGetSelectedLeaderUnit takes nothing returns unit
        native DzIsChatBoxOpen takes nothing returns boolean
        native DzSetUnitPreselectUIVisible takes unit whichUnit, boolean visible returns nothing
        native DzSetEffectAnimation takes effect whichEffect, integer index, integer flag returns nothing
        native DzSetEffectPos takes effect whichEffect, real x, real y, real z returns nothing
        native DzSetEffectVertexColor takes effect whichEffect, integer color returns nothing
        native DzSetEffectVertexAlpha takes effect whichEffect, integer alpha returns nothing
        native DzFrameSetClip takes integer whichframe, boolean enable returns nothing
        native DzChangeWindowSize takes integer width, integer height returns boolean
        native DzPlayEffectAnimation takes effect whichEffect, string anim, string link returns nothing
        native DzBindEffect takes widget parent, string attachPoint, effect whichEffect returns nothing
        native DzUnbindEffect takes effect whichEffect returns nothing
        native DzSetWidgetSpriteScale takes widget whichUnit, real scale returns nothing
        native DzSetEffectScale takes effect whichHandle, real scale returns nothing
        native DzGetEffectVertexColor takes effect whichEffect returns integer
        native DzGetEffectVertexAlpha takes effect whichEffect returns integer
        native DzGetItemAbility takes item whichEffect, integer index returns ability
        native DzFrameGetChildrenCount takes integer whichframe returns integer  
        native DzFrameGetChild takes integer whichframe, integer index returns integer
        native DzUnlockBlpSizeLimit takes boolean enable returns nothing
        native DzGetActivePatron takes unit store, player p returns unit
        native DzGetLocalSelectUnitCount takes nothing returns integer 
        native DzGetLocalSelectUnit takes integer index returns unit
        native DzGetJassStringTableCount takes nothing returns integer
        native DzModelRemoveFromCache takes string path returns nothing
        native DzModelRemoveAllFromCache takes nothing returns nothing
        native DzFrameGetInfoPanelSelectButton takes integer index returns integer
        native DzFrameGetInfoPanelBuffButton takes integer index returns integer
        native DzFrameGetPeonBar takes nothing returns integer
        native DzFrameGetCommandBarButtonNumberText takes integer whichframe returns integer
        native DzFrameGetCommandBarButtonNumberOverlay takes integer whichframe returns integer
        native DzFrameGetCommandBarButtonCooldownIndicator takes integer whichframe returns integer
        native DzFrameGetCommandBarButtonAutoCastIndicator takes integer whichframe returns integer
        native DzToggleFPS takes boolean show returns nothing
        native DzGetFPS takes nothing returns integer
        native DzFrameWorldToMinimapPosX takes real x, real y returns real
        native DzFrameWorldToMinimapPosY takes real x, real y returns real
        native DzWidgetSetMinimapIcon takes unit whichunit, string path returns nothing
        native DzWidgetSetMinimapIconEnable takes unit whichunit, boolean enable returns nothing   
        native DzFrameGetWorldFrameMessage takes nothing returns integer
        native DzSimpleMessageFrameAddMessage takes integer whichframe, string text, integer color, real duration, boolean permanent returns nothing
        native DzSimpleMessageFrameClear takes integer whichframe returns nothing
        native DzConvertWorldPositionX takes real x, real y, real z returns real
        native DzConvertWorldPositionY takes real x, real y, real z returns real
        native DzConvertWorldPositionDepth takes real x, real y, real z returns real
        //转换屏幕坐标到世界坐标
        native DzConvertScreenPositionX takes real x, real y returns real
        native DzConvertScreenPositionY takes real x, real y returns real
        
        //监听建筑选位置
        native DzRegisterOnBuildLocal takes code func returns nothing
        //等于0时是结束事件
        native DzGetOnBuildOrderId takes nothing returns integer
        native DzGetOnBuildOrderType takes nothing returns integer
        native DzGetOnBuildAgent takes nothing returns widget
        
        //监听技能选目标
        native DzRegisterOnTargetLocal takes code func returns nothing
        //等于0时是结束事件
        native DzGetOnTargetAbilId takes nothing returns integer
        native DzGetOnTargetOrderId takes nothing returns integer
        native DzGetOnTargetOrderType takes nothing returns integer
        native DzGetOnTargetAgent takes nothing returns widget
        native DzGetOnTargetInstantTarget takes nothing returns widget  
         // 打开QQ群链接
        native DzOpenQQGroupUrl takes string url returns boolean
        native DzFrameEnableClipRect takes boolean enable returns nothing
        native DzSetUnitName takes unit whichUnit, string name returns nothing
        native DzSetUnitPortrait takes unit whichUnit, string modelFile returns nothing
        native DzSetUnitDescription takes unit whichUnit, string value returns nothing
        native DzSetUnitMissileArc takes unit whichUnit, real arc returns nothing
        native DzSetUnitMissileModel takes unit whichUnit, string modelFile returns nothing
        native DzSetUnitProperName takes unit whichUnit, string name returns nothing
        native DzSetUnitMissileHoming takes unit whichUnit, boolean enable returns nothing
        native DzSetUnitMissileSpeed takes unit whichUnit, real speed returns nothing
        native DzSetEffectVisible takes effect whichHandle, boolean enable returns nothing
        native DzReviveUnit takes unit whichUnit, player whichPlayer, real hp, real mp, real x, real y returns nothing
        native DzGetAttackAbility takes unit whichUnit returns ability
        native DzAttackAbilityEndCooldown takes ability whichHandle returns nothing

        function DzIsUnitAttackType takes unit whichUnit,integer index,attacktype attackType returns boolean
	    return ConvertAttackType(R2I(GetUnitState(whichUnit, ConvertUnitState(16 + 19 * index)))) == attackType
	endfunction
        function DzSetUnitAttackType takes unit whichUnit,integer index,attacktype attackType returns nothing
	    call SetUnitState(whichUnit, ConvertUnitState(16 + 19 * index), GetHandleId(attackType))
	endfunction
        function DzIsUnitDefenseType takes unit whichUnit,integer defenseType returns boolean
	    return R2I(GetUnitState(whichUnit, ConvertUnitState(0x50))) == defenseType
	endfunction
        function DzSetUnitDefenseType takes unit whichUnit,integer defenseType returns nothing
	    call SetUnitState(whichUnit, ConvertUnitState(0x50), defenseType)
	endfunction
        function DzGetColor2 takes integer a,integer r ,integer g,integer b returns integer 
            return 0x1000000 * a + 0x10000 * (r) + 0x100 * (g) + (b)
        endfunction
endlibrary


// [DzSetUnitMoveType]
// title = "设置单位移动类型[NEW]"
// description = "设置 ${单位} 的移动类型：${movetype} "
// comment = ""
// category = TC_KKPRE
// [[.args]]
// type = unit
// [[.args]]
// type = MoveTypeName
// default = MoveTypeName01


#endif

