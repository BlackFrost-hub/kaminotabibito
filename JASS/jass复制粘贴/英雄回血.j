//===========================================================================
// Trigger: 每秒回血回魔HP+MP
//===========================================================================
function Trig___________________HP_MPFunc002A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(real, "基础生命恢复", OperatorRealMultiply( I2R( GetHeroStr( YDLocal2Get(unit, "选取单位"), true)), 0.32))
	if ((UnitHasItemOfTypeBJ( YDLocal2Get(unit, "选取单位"), 'I0BR') == true)) then
		call YDLocal2Set(real, "基础生命恢复", OperatorRealAdd( YDLocal2Get(real, "基础生命恢复"), OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "选取单位"), ConvertUnitState(0x15)), 0.12)))
	else
	endif
	if ((GetUnitTypeId( YDLocal2Get(unit, "选取单位")) == 'H00R')) then
		call YDLocal2Set(real, "基础生命恢复", OperatorRealMultiply( YDLocal2Get(real, "基础生命恢复"), 1.60))
	else
	endif
	call YDLocal2Set(real, "基础魔法恢复", OperatorRealMultiply( I2R( GetHeroInt( YDLocal2Get(unit, "选取单位"), true)), 0.15))
	call YDLocal2Set(real, "生命恢复", YDUserDataGet(unit, YDLocal2Get(unit, "选取单位"),"生命恢复", real))
	call YDLocal2Set(real, "生命恢复", OperatorRealAdd( YDLocal2Get(real, "生命恢复"), YDLocal2Get(real, "基础生命恢复")))
	call YDUserDataSet(player, GetOwningPlayer( YDLocal2Get(unit, "选取单位")),"生命恢复", real, YDLocal2Get(real, "生命恢复"))
	call YDLocal2Set(real, "魔法恢复", YDUserDataGet(unit, YDLocal2Get(unit, "选取单位"),"魔法恢复", real))
	call YDLocal2Set(real, "魔法恢复", OperatorRealAdd( YDLocal2Get(real, "魔法恢复"), YDLocal2Get(real, "基础魔法恢复")))
	call YDUserDataSet(player, GetOwningPlayer( YDLocal2Get(unit, "选取单位")),"魔法恢复", real, YDLocal2Get(real, "魔法恢复"))
	call YDLocal2Set(real, "百分比生命回复", YDUserDataGet(player, GetOwningPlayer( YDLocal2Get(unit, "选取单位")),"百分比生命回复", real))
	if ((YDLocal2Get(real, "百分比生命回复") >= 0.06)) then
		call YDLocal2Set(real, "百分比生命回复", 0.06)
	else
	endif
	call YDLocal2Set(real, "百分比魔法回复", YDUserDataGet(player, GetOwningPlayer( YDLocal2Get(unit, "选取单位")),"百分比魔法回复", real))
	if ((YDLocal2Get(real, "百分比魔法回复") >= 0.04)) then
		call YDLocal2Set(real, "百分比魔法回复", 0.04)
	else
	endif
	call YDLocal2Set(real, "生命恢复属性增幅", YDUserDataGet(player, GetOwningPlayer( YDLocal2Get(unit, "选取单位")),"生命恢复属性增幅", real))
	call YDLocal2Set(real, "总生命恢复", OperatorRealMultiply( OperatorRealAdd( 1.00, YDLocal2Get(real, "生命恢复属性增幅")), OperatorRealAdd( OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_MAX_LIFE), YDLocal2Get(real, "百分比生命回复")), YDLocal2Get(real, "生命恢复"))))
	call YDLocal2Set(real, "总魔法恢复", OperatorRealMultiply( 1.00, OperatorRealAdd( OperatorRealMultiply( GetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_MAX_MANA), YDLocal2Get(real, "百分比魔法回复")), YDLocal2Get(real, "魔法恢复"))))
	call YDUserDataSet(player, GetOwningPlayer( YDLocal2Get(unit, "选取单位")),"总生命恢复", real, YDLocal2Get(real, "总生命恢复"))
	call YDUserDataSet(player, GetOwningPlayer( YDLocal2Get(unit, "选取单位")),"总魔法恢复", real, YDLocal2Get(real, "总魔法恢复"))
	if (((YDLocal2Get(real, "总生命恢复") > 0.50) or (YDLocal2Get(real, "百分比生命回复") >= 0.01))) then
		call SetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_LIFE), YDLocal2Get(real, "总生命恢复")))
	else
	endif
	if (((YDLocal2Get(real, "总魔法恢复") > 0.50) or (YDLocal2Get(real, "百分比魔法回复") >= 0.01))) then
		call SetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_MANA, OperatorRealAdd( GetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_MANA), YDLocal2Get(real, "总魔法恢复")))
	else
	endif
endfunction

function Trig___________________HP_MPFunc003A takes nothing returns nothing
	call YDLocal2Set(unit, "选取单位", GetEnumUnit())
	call YDLocal2Set(real, "生命恢复", YDUserDataGet(unit, YDLocal2Get(unit, "选取单位"),"生命恢复", real))
	call YDLocal2Set(real, "生命恢复属性增幅", YDUserDataGet(unit, YDLocal2Get(unit, "选取单位"),"生命恢复属性增幅", real))
	call YDLocal2Set(real, "总生命恢复", OperatorRealMultiply( OperatorRealAdd( 1.00, YDLocal2Get(real, "生命恢复属性增幅")), YDLocal2Get(real, "生命恢复")))
	if (((YDLocal2Get(real, "总生命恢复") > 0.50) or (YDLocal2Get(real, "百分比生命回复") >= 0.01))) then
		call SetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( YDLocal2Get(unit, "选取单位"), UNIT_STATE_LIFE), YDLocal2Get(real, "总生命恢复")))
	else
	endif
endfunction

function Trig___________________HP_MPActions takes nothing returns nothing
	YDLocalInitialize()
	//来自装备，技能的生命和魔法恢复
	call ForGroupBJ( YDUserDataGet(string, "玩家英雄","单位组", group),function Trig___________________HP_MPFunc002A)
	call ForGroupBJ( YDUserDataGet(string, "动漫Boss","单位组", group),function Trig___________________HP_MPFunc003A)
	call YDLocal1Release()
endfunction

//===========================================================================
function InitTrig___________________HP_MP takes nothing returns nothing
	set gg_trg___________________HP_MP = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg___________________HP_MP,"每秒回血回魔HP+MP")
#endif
	call TriggerRegisterTimerEventPeriodic(gg_trg___________________HP_MP, 1.00)
	call TriggerAddAction(gg_trg___________________HP_MP, function Trig___________________HP_MPActions)
endfunction

