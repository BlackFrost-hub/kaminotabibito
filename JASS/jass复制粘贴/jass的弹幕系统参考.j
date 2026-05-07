//===========================================================================
// Trigger: 弹幕系统DMXT
//===========================================================================
function Trig_____________DMXTFunc001Func002Func030Func006Func002Func002A takes nothing returns nothing
	call GroupRemoveUnit( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group), GetEnumUnit())
endfunction

function Trig_____________DMXTFunc001Func002Func036Func002Func001Func001003003 takes nothing returns boolean
	return ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( YDLocal2Get(unit, "弹幕"))) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and ((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and (IsUnitInGroup( GetFilterUnit(), YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group)) == false))))
endfunction

function Trig_____________DMXTFunc001Func002Func036Func002Func001Func002A takes nothing returns nothing
	call GroupAddUnit( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group), GetEnumUnit())
endfunction

function Trig_____________DMXTFunc001Func002Func036Func002Func001Func003003003 takes nothing returns boolean
	return ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( YDLocal2Get(unit, "弹幕"))) == true) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and (IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false)))
endfunction

function Trig_____________DMXTFunc001Func002Func036Func002Func002Func002A takes nothing returns nothing
	call GroupAddUnit( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group), GetEnumUnit())
	call SFB_setBuff( GetEnumUnit(), 0, YDLocal2Get(real, "时间"))
endfunction

function Trig_____________DMXTFunc001Func002Func036Func009003003 takes nothing returns boolean
	return ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( YDLocal2Get(unit, "弹幕"))) == true) and (GetFilterUnit() == YDLocal2Get(unit, "指定敌人")))
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func001Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func002Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func003Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func004Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func005Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ACID, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func006Func001Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func006Func001Func002A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func006Func002A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func007Func002A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), true, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func001Func007Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), true, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func003Func001Func002Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002Func039Func005Func003Func001Func003Func001A takes nothing returns nothing
	call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
endfunction

function Trig_____________DMXTFunc001Func002A takes nothing returns nothing
	local group ydl_group
	local unit ydl_unit
	call YDLocal2Set(unit, "弹幕", GetEnumUnit())
	//设置弹幕属性
	//弹幕主人
	call YDLocal2Set(unit, "弹幕主人", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"主人", unit))
	//弹幕移动速度
	call YDLocal2Set(real, "飞行速度", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"飞行速度", real))
	call YDLocal2Set(real, "飞行速度", OperatorRealMultiply( YDLocal2Get(real, "飞行速度"), 0.66))
	//弹幕最大移动距离
	//没有最远飞行距离则代表用生命周期计算最远飞行距离（最远飞行距离=生命周期/0.06×飞行速度）
	if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"最远飞行距离", real) == true)) then
		call YDLocal2Set(real, "最远飞行距离", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"最远飞行距离", real))
	else
	endif
	//弹幕索敌半径
	call YDLocal2Set(real, "伤害半径", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"伤害半径", real))
	//弹幕伤害系数
	call YDLocal2Set(real, "伤害系数", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"伤害系数", real))
	//弹幕伤害固定值
	if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"伤害绑定", real) == true)) then
		call YDLocal2Set(real, "伤害绑定", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"伤害绑定", real))
	else
	endif
	//弹幕是否弹射，是则设置弹射角度
	if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"弹射", boolean) == true)) then
		call YDLocal2Set(boolean, "弹射", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射", boolean))
	else
	endif
	//弹幕是否是碰撞消失
	call YDLocal2Set(boolean, "碰撞消失", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"碰撞消失", boolean))
	if ((YDLocal2Get(boolean, "碰撞消失") == true)) then
	else
		//不为指定敌人为目标的弹幕和只移动的弹幕（伤害半径0为判定）创建单位组
		if (((YDLocal2Get(real, "伤害半径") <= 0.00) or (YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"指定敌人", unit) == true))) then
		else
			if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group) == true)) then
			else
				call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group, CreateGroup())
			endif
		endif
	endif
	//弹幕是否是攻击效果
	if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"攻击效果", boolean) == true)) then
		call YDLocal2Set(boolean, "攻击效果", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"攻击效果", boolean))
	else
	endif
	if ((YDLocal2Get(boolean, "弹射") == true)) then
		if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"随机弹射", boolean) == true)) then
			call YDLocal2Set(degree, "弹射角度", OperatorDegreeAdd( GetUnitFacing( YDLocal2Get(unit, "弹幕")), YDWER2Deg( GetRandomReal( 1.00, 180.00))))
		else
			call YDLocal2Set(degree, "弹射角度", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射角度", degree))
		endif
	else
	endif
	//弹幕移动
	call YDLocal2Set(location, "弹幕点", GetUnitLoc( YDLocal2Get(unit, "弹幕")))
	call YDLocal2Set(location, "弹幕移动点", PolarProjectionBJ( YDLocal2Get(location, "弹幕点"), YDLocal2Get(real, "飞行速度"), GetUnitFacing( YDLocal2Get(unit, "弹幕"))))
	if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"移动状态", boolean) == false)) then
		call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"移动状态", boolean, true)
		call SetUnitPosition( YDLocal2Get(unit, "弹幕"), GetLocationX( YDLocal2Get(location, "弹幕移动点")), GetLocationY( YDLocal2Get(location, "弹幕移动点")))
	else
	endif
	//设置弹射弹幕的弹射
	if ((YDLocal2Get(boolean, "弹射") == true) and (IsTerrainPathableBJ( YDLocal2Get(location, "弹幕移动点"), PATHING_TYPE_WALKABILITY) == true)) then
		call YDLocal2Set(boolean, "YFD", true)
		call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"反弹", boolean, true)
		//弹射过后则记弹射次数+1
		call YDLocal2Set(degree, "转向角度", OperatorDegreeAdd( GetUnitFacing( YDLocal2Get(unit, "弹幕")), YDLocal2Get(degree, "弹射角度")))
		if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射次数", real) >= YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射次数上限", real))) then
			call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"弹射", boolean, false)
		else
			call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"弹射次数", real, OperatorRealAdd( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射次数", real), 1.00))
			if ((YDLocal2Get(boolean, "碰撞消失") == true)) then
			else
				//弹射过后将敌人移除重复单位组，能对敌人造成第二次伤害
				call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func030Func006Func002Func002A)
			endif
		endif
		call EXSetUnitFacing( YDLocal2Get(unit, "弹幕"), YDLocal2Get(degree, "转向角度"))
		call SetUnitFacing( YDLocal2Get(unit, "弹幕"), YDLocal2Get(degree, "转向角度"))
		if ((GetUnitTypeId( YDLocal2Get(unit, "弹幕")) == 'e05X')) then
			call StopSoundBJ( gg_snd_feidaoYX, false)
			call PlaySoundOnUnitBJ( gg_snd_feidaoYX, 100, YDLocal2Get(unit, "弹幕"))
		else
		endif
		//弹射衰减
		if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射衰减", real) > 0.00)) then
			call YDLocal2Set(real, "衰减", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射衰减", real))
			call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"伤害系数", real, OperatorRealMultiply( YDLocal2Get(real, "伤害系数"), OperatorRealSubtract( 1.00, YDLocal2Get(real, "衰减"))))
			call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"飞行速度", real, OperatorRealMultiply( YDLocal2Get(real, "飞行速度"), OperatorRealSubtract( 1.00, YDLocal2Get(real, "衰减"))))
		else
		endif
	else
	endif
	//弹射成功后强化的伤害
	if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"反弹", boolean) == true)) then
		call YDLocal2Set(real, "伤害系数", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"强化伤害系数", real))
	else
	endif
	//处于暂停状态则为时停状态，无法移动
	if ((IsUnitPausedBJ( YDLocal2Get(unit, "弹幕")) == false)) then
		//避免可以多次反弹的弹幕卡在一个地点
		if ((YDLocal2Get(boolean, "YFD") == true)) then
		else
			call SetUnitX( YDLocal2Get(unit, "弹幕"), GetLocationX( YDLocal2Get(location, "弹幕移动点")))
			call SetUnitY( YDLocal2Get(unit, "弹幕"), GetLocationY( YDLocal2Get(location, "弹幕移动点")))
		endif
		//八云紫Q技能
		if ((GetUnitFlyHeight( YDLocal2Get(unit, "弹幕")) < 135.00) and (YDLocal2Get(unit, "弹幕主人") == YDUserDataGet(string, "八云紫","单位", unit))) then
			set ydl_group = CreateGroup()
			call GroupEnumUnitsInRange(ydl_group, GetUnitX( YDLocal2Get(unit, "弹幕")), GetUnitY( YDLocal2Get(unit, "弹幕")), 300.00, null)
			loop
				set ydl_unit = FirstOfGroup(ydl_group)
				exitwhen ydl_unit == null
				call GroupRemoveUnit(ydl_group, ydl_unit)
				if ((IsUnitAliveBJ( ydl_unit) == true) and (GetUnitTypeId( ydl_unit) == 'e07I')) then
					call YDLocal2Set(unit, "间隙", ydl_unit)
					if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"xiyin", boolean) == false)) then
						call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"xiyin", boolean, true)
						call YDLocal2Set(degree, "角度", YDWEAngleBetweenUnits( YDLocal2Get(unit, "弹幕"), YDLocal2Get(unit, "间隙")))
						call SetUnitFacing( YDLocal2Get(unit, "弹幕"), YDLocal2Get(degree, "角度"))
						call EXSetUnitFacing( YDLocal2Get(unit, "弹幕"), YDLocal2Get(degree, "角度"))
					else
					endif
				else
				endif
			endloop
			call DestroyGroup(ydl_group)
		else
		endif
		//没有最远飞行距离则代表用生命周期计算最远飞行距离
		if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"最远飞行距离", real) == true)) then
			call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"飞行距离", real, OperatorRealAdd( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"飞行距离", real), YDLocal2Get(real, "飞行速度")))
			if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"飞行距离", real) >= YDLocal2Get(real, "最远飞行距离"))) then
				call KillUnit( YDLocal2Get(unit, "弹幕"))
				call GroupRemoveUnit( YDUserDataGet(string, "弹幕系统","单位组", group), YDLocal2Get(unit, "弹幕"))
			else
			endif
		else
		endif
	else
	endif
	//弹幕是否是只锁定指定敌人
	if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"指定敌人", unit) == true)) then
		call YDLocal2Set(unit, "指定敌人", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"指定敌人", unit))
		call YDLocal2Set(degree, "追踪角度", YDWEAngleBetweenUnits( YDLocal2Get(unit, "弹幕"), YDLocal2Get(unit, "指定敌人")))
		call EXSetUnitFacing( YDLocal2Get(unit, "弹幕"), YDLocal2Get(degree, "追踪角度"))
		call SetUnitFacing( YDLocal2Get(unit, "弹幕"), YDLocal2Get(degree, "追踪角度"))
		//指定敌人的在弹幕那边的触发检测死亡造成伤害
		call YDLocal2Set(group, "伤害单位组", GetUnitsInRangeOfLocMatching( YDLocal2Get(real, "伤害半径"), YDLocal2Get(location, "弹幕点"), Condition(function Trig_____________DMXTFunc001Func002Func036Func009003003)))
		if (((IsUnitDeadBJ( YDLocal2Get(unit, "指定敌人")) == true) or (IsUnitInRange( YDLocal2Get(unit, "弹幕"), YDLocal2Get(unit, "指定敌人"), 50.00) == true))) then
			call GroupRemoveUnit( YDUserDataGet(string, "弹幕系统","单位组", group), YDLocal2Get(unit, "弹幕"))
			//可被摧毁的弹道作特殊处理，只被删除弹幕系统
			if ((GetUnitTypeId( YDLocal2Get(unit, "弹幕")) == 'e08K')) then
			else
				call KillUnit( YDLocal2Get(unit, "弹幕"))
			endif
		else
		endif
	else
		//不为只移动的弹幕（伤害半径0为判定）进行下面的动作
		if ((YDLocal2Get(real, "伤害半径") <= 0.00)) then
		else
			if ((YDLocal2Get(boolean, "碰撞消失") == true)) then
				call YDLocal2Set(group, "伤害单位组", GetUnitsInRangeOfLocMatching( YDLocal2Get(real, "伤害半径"), YDLocal2Get(location, "弹幕点"), Condition(function Trig_____________DMXTFunc001Func002Func036Func002Func001Func003003003)))
			else
				call YDLocal2Set(group, "伤害单位组", GetUnitsInRangeOfLocMatching( YDLocal2Get(real, "伤害半径"), YDLocal2Get(location, "弹幕点"), Condition(function Trig_____________DMXTFunc001Func002Func036Func002Func001Func001003003)))
				call ForGroupBJ( YDLocal2Get(group, "伤害单位组"),function Trig_____________DMXTFunc001Func002Func036Func002Func001Func002A)
			endif
			if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"控制效果", real) == true)) then
				call YDLocal2Set(real, "时间", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"控制效果", real))
				call ForGroupBJ( YDLocal2Get(group, "伤害单位组"),function Trig_____________DMXTFunc001Func002Func036Func002Func002Func002A)
			else
			endif
		endif
		if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"命中效果", boolean) == true)) then
			call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"命中目标", unit, FirstOfGroup( YDLocal2Get(group, "伤害单位组")))
		else
		endif
	endif
	call RemoveLocation( YDLocal2Get(location, "弹幕点"))
	call RemoveLocation( YDLocal2Get(location, "弹幕移动点"))
	if ((IsUnitAliveBJ( YDLocal2Get(unit, "弹幕")) == true) and (CountUnitsInGroup( YDLocal2Get(group, "伤害单位组")) >= 1)) then
		call YDUserDataSet(unit, YDLocal2Get(unit, "弹幕"),"伤害目标", unit, FirstOfGroup( YDLocal2Get(group, "伤害单位组")))
		call YDLocal2Set(unit, "伤害目标", YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"伤害目标", unit))
		//弹幕是否触发攻击效果
		if ((YDLocal2Get(boolean, "碰撞消失") == true)) then
			if ((YDLocal2Get(boolean, "攻击效果") == true)) then
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"强化伤害", boolean) == true)) then
					call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), FirstOfGroup( YDLocal2Get(group, "伤害单位组")), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), true, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
				else
					call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), FirstOfGroup( YDLocal2Get(group, "伤害单位组")), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), true, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
				endif
			else
				if ((YDLocal2Get(real, "伤害绑定") >= 0.10)) then
					if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"强化伤害", boolean) == true)) then
						call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), FirstOfGroup( YDLocal2Get(group, "伤害单位组")), YDLocal2Get(real, "伤害绑定"), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
					else
						call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), FirstOfGroup( YDLocal2Get(group, "伤害单位组")), YDLocal2Get(real, "伤害绑定"), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
					endif
				else
					if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"强化伤害", boolean) == true)) then
						call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), FirstOfGroup( YDLocal2Get(group, "伤害单位组")), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS)
					else
						call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), FirstOfGroup( YDLocal2Get(group, "伤害单位组")), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "弹幕主人"), ConvertUnitState(0x15)), YDLocal2Get(real, "伤害系数")), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
					endif
					if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"水魔法伤害", boolean) == true)) then
						call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func003Func001Func002Func001A)
					else
					endif
					if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"火魔法伤害", boolean) == true)) then
						call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func003Func001Func003Func001A)
					else
					endif
				endif
			endif
		else
			if ((YDLocal2Get(boolean, "攻击效果") == true)) then
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"强化伤害", boolean) == true)) then
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func007Func001A)
				else
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func007Func002A)
				endif
			else
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"金魔法伤害", boolean) == true)) then
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func001Func001A)
				else
				endif
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"木魔法伤害", boolean) == true)) then
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func002Func001A)
				else
				endif
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"水魔法伤害", boolean) == true)) then
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func003Func001A)
				else
				endif
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"火魔法伤害", boolean) == true)) then
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func004Func001A)
				else
				endif
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"土魔法伤害", boolean) == true)) then
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func005Func001A)
				else
				endif
				if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"暗魔法伤害", boolean) == true)) then
					call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func006Func002A)
				else
					if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"强化伤害", boolean) == true)) then
						call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func006Func001Func002A)
					else
						call ForGroupBJ( YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"重复单位组", group),function Trig_____________DMXTFunc001Func002Func039Func005Func001Func006Func001Func001A)
					endif
				endif
			endif
		endif
		//避免指定目标的弹幕被删除，一定要追踪到目标造成伤害才会被删除
		if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"指定敌人", unit) == true)) then
			if ((IsUnitInGroup( YDLocal2Get(unit, "指定敌人"), YDLocal2Get(group, "伤害单位组")) == true)) then
				call GroupRemoveUnit( YDUserDataGet(string, "弹幕系统","单位组", group), YDLocal2Get(unit, "弹幕"))
				call KillUnit( YDLocal2Get(unit, "弹幕"))
			else
			endif
		else
			//碰撞消失的提前删除，避免弹射飞刀造成一次伤害就被删除
			if ((YDLocal2Get(boolean, "碰撞消失") == true)) then
				call GroupRemoveUnit( YDUserDataGet(string, "弹幕系统","单位组", group), YDLocal2Get(unit, "弹幕"))
				call KillUnit( YDLocal2Get(unit, "弹幕"))
			else
				if ((YDUserDataHas(unit, YDLocal2Get(unit, "弹幕"),"弹射次数上限", real) == true)) then
					if ((YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射次数", real) >= YDUserDataGet(unit, YDLocal2Get(unit, "弹幕"),"弹射次数上限", real))) then
						call GroupRemoveUnit( YDUserDataGet(string, "弹幕系统","单位组", group), YDLocal2Get(unit, "弹幕"))
						call KillUnit( YDLocal2Get(unit, "弹幕"))
					else
					endif
				else
				endif
			endif
		endif
		//这里是弹幕的音效
		if ((GetUnitTypeId( YDLocal2Get(unit, "弹幕主人")) == 'E001')) then
			call UnitDamageTarget( YDLocal2Get(unit, "弹幕主人"), YDLocal2Get(unit, "伤害目标"), 0.00, false, false, ATTACK_TYPE_HERO, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_METAL_HEAVY_SLICE)
		else
		endif
	else
		if ((IsUnitAliveBJ( YDLocal2Get(unit, "弹幕")) == true)) then
		else
			call GroupRemoveUnit( YDUserDataGet(string, "弹幕系统","单位组", group), YDLocal2Get(unit, "弹幕"))
		endif
	endif
	call DestroyGroup( YDLocal2Get(group, "伤害单位组"))
	set ydl_group = null
	set ydl_unit = null
endfunction

function Trig_____________DMXTActions takes nothing returns nothing
	YDLocalInitialize()
	if ((IsUnitGroupEmptyBJ( YDUserDataGet(string, "弹幕系统","单位组", group)) == true)) then
		call DisableTrigger( GetTriggeringTrigger())
	else
		call ForGroupBJ( YDUserDataGet(string, "弹幕系统","单位组", group),function Trig_____________DMXTFunc001Func002A)
	endif
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig_____________DMXT takes nothing returns nothing
	set gg_trg_____________DMXT = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_____________DMXT,"弹幕系统DMXT")
#endif
	call TriggerRegisterTimerEventPeriodic(gg_trg_____________DMXT, 0.04)
	call TriggerAddAction(gg_trg_____________DMXT, function Trig_____________DMXTActions)
endfunction

