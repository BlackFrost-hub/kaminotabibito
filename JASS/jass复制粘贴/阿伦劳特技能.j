//===========================================================================
// Trigger: 未命名触发器 002
//===========================================================================
function Trig____________________002Func001Func003Func005Func002003003 takes nothing returns boolean
	return (((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and (IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false)) and (((IsUnitAliveBJ( GetFilterUnit()) == true) and (GetOwningPlayer( GetFilterUnit()) != Player(PLAYER_NEUTRAL_PASSIVE))) and (GetFilterUnit() != YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))))
endfunction

function Trig____________________002Func001Func003Func005Func006Func001Func005A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call PlaySoundOnUnitBJ( gg_snd_LifeDrain, 100, YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	call YDWETimerDestroyLightning( 0.03, AddLightning( "DRAB", false, GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))))
	call SetUnitPathing( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), false)
	call YDLocalSet(GetExpiredTimer(), degree, "角度", YDWEAngleBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")))
	call YDLocalSet(GetExpiredTimer(), location, "初始点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	//友方加速为200%
	if ((IsUnitEnemy( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))) == true)) then
		call YDLocalSet(GetExpiredTimer(), location, "单位移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "初始点"), 12.00, YDLocalGet(GetExpiredTimer(), degree, "角度")))
	else
		call YDLocalSet(GetExpiredTimer(), location, "单位移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "初始点"), 24.00, YDLocalGet(GetExpiredTimer(), degree, "角度")))
	endif
	call SetUnitPositionLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "初始点"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
	//吸取敌人的生命值
	if ((IsUnitEnemy( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))) == true)) then
		call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), UNIT_STATE_LIFE, OperatorRealSubtract( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), UNIT_STATE_LIFE), OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "每秒吸取值"), 0.04)))
		call SetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), UNIT_STATE_LIFE, OperatorRealAdd( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), UNIT_STATE_LIFE), OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "每秒吸取值"), 0.04)))
	else
	endif
	//小于自身攻击范围范围则直接施放Then动作
	if ((YDWEDistanceBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), unit, "选取单位")) <= I2R( YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), "rangeN1")))) then
		call GroupRemoveUnit( YDLocalGet(GetExpiredTimer(), group, "效果单位组"), YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
		call SetUnitPathing( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), true)
		if ((IsUnitEnemy( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))) == true)) then
			call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnit( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), 'e00D', GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), 0))
			call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A0D9')
			call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "slow", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
			call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), unit, "选取单位"), OperatorRealAdd( OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), ConvertUnitState(0x15)), 1.50), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), UNIT_STATE_LIFE), 0.15)), false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS)
			call YDWETimerDestroyEffect( 1.00, AddSpecialEffect( "Objects\\Spawnmodels\\Undead\\UndeadDissipate\\UndeadDissipate.mdl", GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "选取单位"))))
			call EXSetEffectSize( GetLastCreatedEffectBJ(), YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), "modelScale"))
			call EXSetEffectZ( GetLastCreatedEffectBJ(), GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
		else
			call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnit( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), 'e00D', GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "选取单位")), 0))
			call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A0DA')
			call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "slow", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
		endif
	else
	endif
endfunction

function Trig____________________002Func001Func003Func005Func006Func001Func001A takes nothing returns nothing
	call SetUnitPathing( GetEnumUnit(), true)
endfunction

function Trig____________________002Func001Func003Func005Func006T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 75.00))) then
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "效果单位组"),function Trig____________________002Func001Func003Func005Func006Func001Func001A)
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "效果单位组"),function Trig____________________002Func001Func003Func005Func006Func001Func005A)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig____________________002Func001Func003Func005T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), location, "目标点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "目标单位")))
	call YDLocalSet(GetExpiredTimer(), group, "效果单位组", GetUnitsInRangeOfLocMatching( 450.00, YDLocalGet(GetExpiredTimer(), location, "目标点"), Condition(function Trig____________________002Func001Func003Func005Func002003003)))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "目标点"))
	call YDLocalSet(GetExpiredTimer(), real, "每秒吸取值", YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")),"总生命恢复", real))
	call YDLocalSet(GetExpiredTimer(), real, "循环实数", 0.00)
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, location, "初始点", YDLocalGet(GetExpiredTimer(), location, "初始点"))
	call YDLocalSet(ydl_timer, location, "单位移动点", YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
	call YDLocalSet(ydl_timer, real, "循环实数", YDLocalGet(GetExpiredTimer(), real, "循环实数"))
	call YDLocalSet(ydl_timer, group, "效果单位组", YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
	call YDLocalSet(ydl_timer, real, "每秒吸取值", YDLocalGet(GetExpiredTimer(), real, "每秒吸取值"))
	call YDLocalSet(ydl_timer, degree, "角度", YDLocalGet(GetExpiredTimer(), degree, "角度"))
	call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"))
	call YDLocalSet(ydl_timer, unit, "选取单位", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	call YDLocalSet(ydl_timer, unit, "阿劳伦特", YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.04, true, function Trig____________________002Func001Func003Func005Func006T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.04, true," function Trig____________________002Func001Func003Func005Func006T","未命名触发器 002")
#endif 
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func009003003 takes nothing returns boolean
	return (((IsUnitType( GetFilterUnit(), UNIT_TYPE_ANCIENT) == false) and (IsUnitType( GetFilterUnit(), UNIT_TYPE_MECHANICAL) == false)) and ((IsUnitAliveBJ( GetFilterUnit()) == true) and ((IsUnitEnemy( GetFilterUnit(), GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))) == true) and (GetFilterUnit() != YDLocalGet(GetExpiredTimer(), unit, "目标单位")))))
endfunction

function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func004Func005A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "辅助马甲", CreateUnit( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit")), 'e00D', GetUnitX( GetEnumUnit()), GetUnitY( GetEnumUnit()), 0))
	call UnitAddAbility( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), 'A01Z')
	call IssueTargetOrder( YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"), "thunderbolt", GetEnumUnit())
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), ConvertUnitState(0x15)), 2.00), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_METAL_HEAVY_SLICE)
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetEnumUnit(), "chest"))
endfunction

function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func004Func006A takes nothing returns nothing
	call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), GetEnumUnit(), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), ConvertUnitState(0x15)), 1.50), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_METAL_HEAVY_SLICE)
	call YDWETimerDestroyEffect( 1.00, AddSpecialEffectTarget( "Objects\\Spawnmodels\\Critters\\Albatross\\CritterBloodAlbatross.mdl", GetEnumUnit(), "chest"))
endfunction

function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func005Func002Func001Func004A takes nothing returns nothing
	call YDLocalSet(GetExpiredTimer(), unit, "选取单位", GetEnumUnit())
	call YDLocalSet(GetExpiredTimer(), degree, "角度", YDWEAngleBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), location, "初始点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位")))
	call YDLocalSet(GetExpiredTimer(), location, "单位移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "初始点"), 20.00, YDLocalGet(GetExpiredTimer(), degree, "角度")))
	call SetUnitPositionLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
	if ((IsTerrainPathableBJ( YDLocalGet(GetExpiredTimer(), location, "单位位移点"), PATHING_TYPE_WALKABILITY) == true)) then
	else
		if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), 'BPSE') == false)) then
			call GroupRemoveUnit( YDLocalGet(GetExpiredTimer(), group, "效果单位组"), YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
		else
			call SetUnitPositionLoc( YDLocalGet(GetExpiredTimer(), unit, "选取单位"), YDLocalGet(GetExpiredTimer(), location, "初始点"))
		endif
	endif
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "初始点"))
	call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
endfunction

function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func005Func002T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if (((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 15.00))) then
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "效果单位组"),function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func005Func002Func001Func004A)
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDWETimerDestroyEffect( 2.00, AddSpecialEffect( "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "目标单位")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "目标单位"))))
	call PlaySoundOnUnitBJ( gg_snd_StampedeHit1, 100, YDLocalGet(GetExpiredTimer(), unit, "目标单位"))
	call PlaySoundOnUnitBJ( gg_snd_ThunderBoltMissileDeath, 100, YDLocalGet(GetExpiredTimer(), unit, "目标单位"))
	if ((YDLocalGet(GetExpiredTimer(), real, "计时器实数") == 0.27)) then
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "目标单位"), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), ConvertUnitState(0x15)), 3.00), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_METAL_HEAVY_SLICE)
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "效果单位组"),function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func004Func006A)
	else
		call YDUserDataSet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")),"暴击率", real, OperatorRealAdd( YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")),"暴击率", real), 1.00))
		call UnitDamageTarget( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), YDLocalGet(GetExpiredTimer(), unit, "目标单位"), OperatorRealMultiply( GetUnitState( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), ConvertUnitState(0x15)), 2.00), true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_METAL_HEAVY_SLICE)
		call YDUserDataSet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")),"暴击率", real, OperatorRealAdd( YDUserDataGet(player, GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")),"暴击率", real), -1.00))
		call ForGroupBJ( YDLocalGet(GetExpiredTimer(), group, "效果单位组"),function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func004Func005A)
	endif
	if ((YDLocalGet(GetExpiredTimer(), real, "计时器实数") == 0.27)) then
		call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", 0.00)
		set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
		call YDLocalSet(ydl_timer, location, "初始点", YDLocalGet(GetExpiredTimer(), location, "初始点"))
		call YDLocalSet(ydl_timer, location, "单位位移点", YDLocalGet(GetExpiredTimer(), location, "单位位移点"))
		call YDLocalSet(ydl_timer, location, "单位移动点", YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
		call YDLocalSet(ydl_timer, real, "循环实数", YDLocalGet(GetExpiredTimer(), real, "循环实数"))
		call YDLocalSet(ydl_timer, group, "效果单位组", YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
		call YDLocalSet(ydl_timer, degree, "角度", YDLocalGet(GetExpiredTimer(), degree, "角度"))
		call YDLocalSet(ydl_timer, unit, "选取单位", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
		call YDLocalSet(ydl_timer, unit, "阿劳伦特", YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
		call TimerStart(ydl_timer, 0.02, true, function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func005Func002T)
#ifdef StarDebuggerIncluded 
		call  SDR_DebugTimer(ydl_timer, 0.02, true," function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014Func005Func002T","未命名触发器 002")
#endif 
	endif
	call YDLocalSet(GetExpiredTimer(), boolean, "天堂审判开启", false)
	call SetUnitTimeScale( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), 1.00)
	call PauseUnit( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), false)
	call SetUnitPathing( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), true)
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig____________________002Func001Func003Func002Func001Func013T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")) == true) and ((IsUnitInRange( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), unit, "目标单位"), YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), "rangeN1")) == true) or (YDLocalGet(GetExpiredTimer(), real, "循环实数") >= 20.00))) then
		call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDUserDataGet(unit, YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"),"默认飞行高度", real), 0.00)
		//起码要在自身攻击范围×2的距离内，且自身存活
		if ((IsUnitAliveBJ( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")) == true) and (IsUnitInRange( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), unit, "目标单位"), OperatorRealMultiply( YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), "rangeN1"), 2.00)) == true)) then
			if ((YDLocalGet(GetExpiredTimer(), boolean, "天堂审判开启") == false)) then
				//根据状态有不同的动作，设置不同时间
				call YDLocalSet(GetExpiredTimer(), real, "计时器实数", 0.27)
				call SetUnitAnimationByIndex( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), 3)
			else
				call YDLocalSet(GetExpiredTimer(), real, "计时器实数", 0.00)
			endif
			call YDLocalSet(GetExpiredTimer(), location, "目标点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "目标单位")))
			call YDLocalSet(GetExpiredTimer(), group, "效果单位组", GetUnitsInRangeOfLocMatching( 300.00, YDLocalGet(GetExpiredTimer(), location, "目标点"), Condition(function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func009003003)))
			call YDLocalSet(GetExpiredTimer(), effect, "光之审判特效", AddSpecialEffect( "war3mapImported\\Judgement_impact_chest.mdx", GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "目标单位")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "目标单位"))))
			call EXSetEffectSize( YDLocalGet(GetExpiredTimer(), effect, "光之审判特效"), 2.00)
			call EXSetEffectZ( YDLocalGet(GetExpiredTimer(), effect, "光之审判特效"), OperatorRealAdd( 50.00, GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "目标单位"))))
			call YDWETimerDestroyEffect( 2.00, YDLocalGet(GetExpiredTimer(), effect, "光之审判特效"))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
			call YDLocalSet(ydl_timer, location, "初始点", YDLocalGet(GetExpiredTimer(), location, "初始点"))
			call YDLocalSet(ydl_timer, location, "单位位移点", YDLocalGet(GetExpiredTimer(), location, "单位位移点"))
			call YDLocalSet(ydl_timer, location, "单位移动点", YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
			call YDLocalSet(ydl_timer, real, "循环实数", YDLocalGet(GetExpiredTimer(), real, "循环实数"))
			call YDLocalSet(ydl_timer, group, "效果单位组", YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
			call YDLocalSet(ydl_timer, unit, "目标单位", YDLocalGet(GetExpiredTimer(), unit, "目标单位"))
			call YDLocalSet(ydl_timer, degree, "角度", YDLocalGet(GetExpiredTimer(), degree, "角度"))
			call YDLocalSet(ydl_timer, real, "计时器实数", YDLocalGet(GetExpiredTimer(), real, "计时器实数"))
			call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"))
			call YDLocalSet(ydl_timer, unit, "选取单位", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
			call YDLocalSet(ydl_timer, unit, "阿劳伦特", YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, YDLocalGet(GetExpiredTimer(), real, "计时器实数"), false, function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, YDLocalGet(GetExpiredTimer(), real, "计时器实数"), false," function Trig____________________002Func001Func003Func002Func001Func013Func001Func004Func014T","未命名触发器 002")
#endif 
		else
			call YDLocalSet(GetExpiredTimer(), boolean, "天堂审判开启", false)
			call SetUnitPathing( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), true)
			call SetUnitTimeScale( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), 1.00)
			call PauseUnit( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), false)
			call DestroyGroup( YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
		endif
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "目标点"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", OperatorRealAdd( YDLocalGet(GetExpiredTimer(), real, "循环实数"), 1.00))
		call YDLocalSet(GetExpiredTimer(), degree, "角度", YDWEAngleBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), unit, "目标单位")))
		call YDLocalSet(GetExpiredTimer(), location, "单位点", GetUnitLoc( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")))
		call YDLocalSet(GetExpiredTimer(), unit, "阿劳伦特分身", CreateUnit( GetOwningPlayer( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), 'e060', GetUnitX( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), GetUnitY( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), GetUnitFacing( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))))
		call YDWETimerRemoveUnit( 0.35, YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"))
		call SetUnitVertexColorBJ( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"), 100, 100, 100, 80.00)
		call SetUnitTimeScale( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"), OperatorRealAdd( 1.00, OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "循环实数"), OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "倍数"), 1.00))))
		if ((YDLocalGet(GetExpiredTimer(), boolean, "天堂审判开启") == false)) then
			call SetUnitAnimationByIndex( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"), 6)
			call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"), OperatorRealAdd( GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), 0.00), 0.00)
		else
			call SetUnitAnimationByIndex( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"), 3)
			if ((YDLocalGet(GetExpiredTimer(), real, "循环实数") >= OperatorRealMultiply( YDLocalGet(GetExpiredTimer(), real, "次数"), 0.50))) then
				call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), OperatorRealSubtract( GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), 40.00), 0.00)
			else
				call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), OperatorRealAdd( GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), 40.00), 0.00)
			endif
			call SetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"), OperatorRealAdd( GetUnitFlyHeight( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), 0.00), 0.00)
		endif
		call YDLocalSet(GetExpiredTimer(), location, "单位移动点", PolarProjectionBJ( YDLocalGet(GetExpiredTimer(), location, "单位点"), 60.00, YDLocalGet(GetExpiredTimer(), degree, "角度")))
		call SetUnitPositionLoc( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "单位点"))
		call RemoveLocation( YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig____________________002Func001Func003Func002Func001T takes nothing returns nothing
	local timer ydl_timer
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	call YDLocalSet(GetExpiredTimer(), real, "循环实数", 0.00)
	call YDLocalSet(GetExpiredTimer(), real, "距离", YDWEDistanceBetweenUnits( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), YDLocalGet(GetExpiredTimer(), unit, "目标单位")))
	//设次数为X，也就是这个循环计时器至少运行X次
	call YDLocalSet(GetExpiredTimer(), real, "次数", OperatorRealDivide( YDLocalGet(GetExpiredTimer(), real, "距离"), 60.00))
	//分身基础动画倍速
	call YDLocalSet(GetExpiredTimer(), real, "倍数", OperatorRealDivide( 1.00, YDLocalGet(GetExpiredTimer(), real, "次数")))
	//小于自身攻击范围范围则直接施放Then动作
	if ((YDLocalGet(GetExpiredTimer(), real, "距离") >= I2R( YDWEGetObjectPropertyInteger( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特")), "rangeN1")))) then
	else
		call YDLocalSet(GetExpiredTimer(), real, "循环实数", 20.00)
	endif
	call PauseUnit( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), true)
	call SetUnitPathing( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), false)
	//通过魔法效果是否存在检测大招-『天堂审判』R开启状态
	if ((UnitHasBuffBJ( YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"), 'B018') == false)) then
		call SetUnitAnimationByIndex( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), 6)
		call SetUnitTimeScale( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), 2.10)
	else
		call YDWEFlyEnable( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))
		//因为这个技能是以施放技能时的瞬间为标准判断，所以先提前设置一个真值，以防技能施法过程中魔法效果消失而产生bug
		call YDLocalSet(GetExpiredTimer(), boolean, "天堂审判开启", true)
		call SetUnitAnimationByIndex( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), 3)
		call SetUnitTimeScale( YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"), 1.00)
	endif
	set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
	call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", YDLocalGet(GetExpiredTimer(), unit, "GetTriggerUnit"))
	call YDLocalSet(ydl_timer, real, "倍数", YDLocalGet(GetExpiredTimer(), real, "倍数"))
	call YDLocalSet(ydl_timer, effect, "光之审判特效", YDLocalGet(GetExpiredTimer(), effect, "光之审判特效"))
	call YDLocalSet(ydl_timer, location, "初始点", YDLocalGet(GetExpiredTimer(), location, "初始点"))
	call YDLocalSet(ydl_timer, location, "单位位移点", YDLocalGet(GetExpiredTimer(), location, "单位位移点"))
	call YDLocalSet(ydl_timer, location, "单位点", YDLocalGet(GetExpiredTimer(), location, "单位点"))
	call YDLocalSet(ydl_timer, location, "单位移动点", YDLocalGet(GetExpiredTimer(), location, "单位移动点"))
	call YDLocalSet(ydl_timer, boolean, "天堂审判开启", YDLocalGet(GetExpiredTimer(), boolean, "天堂审判开启"))
	call YDLocalSet(ydl_timer, real, "循环实数", YDLocalGet(GetExpiredTimer(), real, "循环实数"))
	call YDLocalSet(ydl_timer, group, "效果单位组", YDLocalGet(GetExpiredTimer(), group, "效果单位组"))
	call YDLocalSet(ydl_timer, real, "次数", YDLocalGet(GetExpiredTimer(), real, "次数"))
	call YDLocalSet(ydl_timer, unit, "目标单位", YDLocalGet(GetExpiredTimer(), unit, "目标单位"))
	call YDLocalSet(ydl_timer, location, "目标点", YDLocalGet(GetExpiredTimer(), location, "目标点"))
	call YDLocalSet(ydl_timer, degree, "角度", YDLocalGet(GetExpiredTimer(), degree, "角度"))
	call YDLocalSet(ydl_timer, real, "计时器实数", YDLocalGet(GetExpiredTimer(), real, "计时器实数"))
	call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocalGet(GetExpiredTimer(), unit, "辅助马甲"))
	call YDLocalSet(ydl_timer, unit, "选取单位", YDLocalGet(GetExpiredTimer(), unit, "选取单位"))
	call YDLocalSet(ydl_timer, unit, "阿劳伦特", YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特"))
	call YDLocalSet(ydl_timer, unit, "阿劳伦特分身", YDLocalGet(GetExpiredTimer(), unit, "阿劳伦特分身"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
	call TimerStart(ydl_timer, 0.05, true, function Trig____________________002Func001Func003Func002Func001Func013T)
#ifdef StarDebuggerIncluded 
	call  SDR_DebugTimer(ydl_timer, 0.05, true," function Trig____________________002Func001Func003Func002Func001Func013T","未命名触发器 002")
#endif 
	#ifdef StarDebuggerIncluded 
	call SDR_DebugTimer_Remove(GetExpiredTimer())
	#endif 
	call YDLocal3Release()
	call DestroyTimer(GetExpiredTimer())
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
	set ydl_timer = null
endfunction

function Trig____________________002Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	if ((GetSpellAbilityId() == 'A0D4')) then
		call YDLocal1Set(unit, "阿劳伦特", GetTriggerUnit())
		call YDLocal1Set(unit, "目标单位", GetSpellTargetUnit())
		if ((GetUnitTypeId( GetTriggerUnit()) == 'H00F')) then
			//对友军不发动效果
			if ((IsUnitEnemy( YDLocal1Get(unit, "目标单位"), GetOwningPlayer( YDLocal1Get(unit, "阿劳伦特"))) == true)) then
				set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
				call YDLocalSet(ydl_timer, unit, "GetTriggerUnit", GetTriggerUnit())
				call YDLocalSet(ydl_timer, real, "倍数", YDLocal1Get(real, "倍数"))
				call YDLocalSet(ydl_timer, effect, "光之审判特效", YDLocal1Get(effect, "光之审判特效"))
				call YDLocalSet(ydl_timer, location, "初始点", YDLocal1Get(location, "初始点"))
				call YDLocalSet(ydl_timer, location, "单位位移点", YDLocal1Get(location, "单位位移点"))
				call YDLocalSet(ydl_timer, location, "单位点", YDLocal1Get(location, "单位点"))
				call YDLocalSet(ydl_timer, location, "单位移动点", YDLocal1Get(location, "单位移动点"))
				call YDLocalSet(ydl_timer, boolean, "天堂审判开启", YDLocal1Get(boolean, "天堂审判开启"))
				call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
				call YDLocalSet(ydl_timer, group, "效果单位组", YDLocal1Get(group, "效果单位组"))
				call YDLocalSet(ydl_timer, real, "次数", YDLocal1Get(real, "次数"))
				call YDLocalSet(ydl_timer, unit, "目标单位", YDLocal1Get(unit, "目标单位"))
				call YDLocalSet(ydl_timer, location, "目标点", YDLocal1Get(location, "目标点"))
				call YDLocalSet(ydl_timer, degree, "角度", YDLocal1Get(degree, "角度"))
				call YDLocalSet(ydl_timer, real, "计时器实数", YDLocal1Get(real, "计时器实数"))
				call YDLocalSet(ydl_timer, real, "距离", YDLocal1Get(real, "距离"))
				call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
				call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
				call YDLocalSet(ydl_timer, unit, "阿劳伦特", YDLocal1Get(unit, "阿劳伦特"))
				call YDLocalSet(ydl_timer, unit, "阿劳伦特分身", YDLocal1Get(unit, "阿劳伦特分身"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
				call TimerStart(ydl_timer, 0.00, false, function Trig____________________002Func001Func003Func002Func001T)
#ifdef StarDebuggerIncluded 
				call  SDR_DebugTimer(ydl_timer, 0.00, false," function Trig____________________002Func001Func003Func002Func001T","未命名触发器 002")
#endif 
			else
			endif
		else
			call YDWESetUnitAbilityState( YDLocal1Get(unit, "阿劳伦特"), GetSpellAbilityId(), 1, 10.00)
			call SetUnitManaPercentBJ( GetTriggerUnit(), OperatorRealSubtract( GetUnitManaPercent( GetTriggerUnit()), 10.00))
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, location, "初始点", YDLocal1Get(location, "初始点"))
			call YDLocalSet(ydl_timer, location, "单位移动点", YDLocal1Get(location, "单位移动点"))
			call YDLocalSet(ydl_timer, real, "循环实数", YDLocal1Get(real, "循环实数"))
			call YDLocalSet(ydl_timer, group, "效果单位组", YDLocal1Get(group, "效果单位组"))
			call YDLocalSet(ydl_timer, real, "每秒吸取值", YDLocal1Get(real, "每秒吸取值"))
			call YDLocalSet(ydl_timer, unit, "目标单位", YDLocal1Get(unit, "目标单位"))
			call YDLocalSet(ydl_timer, location, "目标点", YDLocal1Get(location, "目标点"))
			call YDLocalSet(ydl_timer, degree, "角度", YDLocal1Get(degree, "角度"))
			call YDLocalSet(ydl_timer, unit, "辅助马甲", YDLocal1Get(unit, "辅助马甲"))
			call YDLocalSet(ydl_timer, unit, "选取单位", YDLocal1Get(unit, "选取单位"))
			call YDLocalSet(ydl_timer, unit, "阿劳伦特", YDLocal1Get(unit, "阿劳伦特"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 0.00, false, function Trig____________________002Func001Func003Func005T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 0.00, false," function Trig____________________002Func001Func003Func005T","未命名触发器 002")
#endif 
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig____________________002 takes nothing returns nothing
	set gg_trg____________________002 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg____________________002,"未命名触发器 002")
#endif
	call TriggerAddAction(gg_trg____________________002, function Trig____________________002Actions)
endfunction

