//===========================================================================
// Trigger: SHXS_001
//===========================================================================
function Trig_SHXS_001Conditions takes nothing returns boolean
	return ((GetEventDamage() > 1.10))
endfunction

function Trig_SHXS_001Func009Func007Func003Func008T takes nothing returns nothing
	#ifdef YDLOC_New
	local integer L_LIndex = G_SIndex
	set G_SIndex = GetHandleId(GetExpiredTimer())
	set G_LIndex = G_SIndex
	#endif
	if ((YDLocalGet(GetExpiredTimer(), integer, "ii") == 30)) then
		call DestroyImage( YDLocalGet(GetExpiredTimer(), image, "tag"))
		#ifdef StarDebuggerIncluded 
		call SDR_DebugTimer_Remove(GetExpiredTimer())
		#endif 
		call YDLocal3Release()
		call DestroyTimer(GetExpiredTimer())
	else
		call YDLocalSet(GetExpiredTimer(), integer, "ii", (YDLocalGet(GetExpiredTimer(), integer, "ii") + 1))
		call SetImagePosition( YDLocalGet(GetExpiredTimer(), image, "tag"), (YDLocalGet(GetExpiredTimer(), real, "x") + YDLocalGet(GetExpiredTimer(), real, "JL")), YDLocalGet(GetExpiredTimer(), real, "y"), (20.00 * I2R( YDLocalGet(GetExpiredTimer(), integer, "ii"))))
	endif
	#ifdef YDLOC_New
	set G_SIndex = L_LIndex
	set G_LIndex = G_SIndex
	#endif
endfunction

function Trig_SHXS_001Actions takes nothing returns nothing
	local timer ydl_timer
	YDLocalInitialize()
	call YDLocal1Set(unit, "U", GetEventDamageSource())
	call YDLocal1Set(unit, "U1", GetTriggerUnit())
	call YDLocal1Set(real, "x", GetUnitX( YDLocal1Get(unit, "U1")))
	call YDLocal1Set(real, "y", GetUnitY( YDLocal1Get(unit, "U1")))
	set bj_forLoopAIndex = 0
	set bj_forLoopAIndexEnd = 9
	loop
		exitwhen bj_forLoopAIndex > bj_forLoopAIndexEnd
		call YDLocal1ArraySet(string, "TX", bj_forLoopAIndex, YDWEOperatorString3( "war3mapImported\\z", I2S( bj_forLoopAIndex), "-6.blp"))
		set bj_forLoopAIndex = bj_forLoopAIndex + 1
	endloop
	if ((YDWEIsEventDamageType( DAMAGE_TYPE_MIND) == true)) then
		call YDLocal1Set(integer, "红", 255)
		call YDLocal1Set(integer, "绿", 255)
		call YDLocal1Set(integer, "蓝", 255)
	else
		if ((YDWEIsEventDamageType( DAMAGE_TYPE_NORMAL) == true)) then
			call YDLocal1Set(integer, "红", 160)
			call YDLocal1Set(integer, "绿", 82)
			call YDLocal1Set(integer, "蓝", 45)
		else
			if ((YDWEIsEventDamageType( DAMAGE_TYPE_ENHANCED) == true)) then
				call YDLocal1Set(integer, "红", 255)
				call YDLocal1Set(integer, "绿", 140)
				call YDLocal1Set(integer, "蓝", 0)
			else
				if ((YDWEIsEventDamageType( DAMAGE_TYPE_FIRE) == true)) then
					call YDLocal1Set(integer, "红", 255)
					call YDLocal1Set(integer, "绿", 0)
					call YDLocal1Set(integer, "蓝", 0)
				else
					if ((YDWEIsEventDamageType( DAMAGE_TYPE_COLD) == true)) then
						call YDLocal1Set(integer, "红", 0)
						call YDLocal1Set(integer, "绿", 191)
						call YDLocal1Set(integer, "蓝", 255)
					else
						if (((YDWEIsEventDamageType( DAMAGE_TYPE_SLOW_POISON) == true) or (YDWEIsEventDamageType( DAMAGE_TYPE_POISON) == true) or (YDWEIsEventDamageType( DAMAGE_TYPE_ACID) == true))) then
							call YDLocal1Set(integer, "红", 255)
							call YDLocal1Set(integer, "绿", 215)
							call YDLocal1Set(integer, "蓝", 0)
						else
							if ((YDWEIsEventDamageType( DAMAGE_TYPE_PLANT) == true)) then
								call YDLocal1Set(integer, "红", 124)
								call YDLocal1Set(integer, "绿", 252)
								call YDLocal1Set(integer, "蓝", 0)
							else
								if ((YDWEIsEventDamageType( DAMAGE_TYPE_SHADOW_STRIKE) == true)) then
									call YDLocal1Set(integer, "红", 128)
									call YDLocal1Set(integer, "绿", 0)
									call YDLocal1Set(integer, "蓝", 128)
								else
									if ((YDWEIsEventDamageType( DAMAGE_TYPE_MAGIC) == true)) then
										call YDLocal1Set(integer, "红", 0)
										call YDLocal1Set(integer, "绿", 0)
										call YDLocal1Set(integer, "蓝", 255)
									else
										if ((YDWEIsEventDamageType( DAMAGE_TYPE_LIGHTNING) == true)) then
											call YDLocal1Set(integer, "红", 220)
											call YDLocal1Set(integer, "绿", 255)
											call YDLocal1Set(integer, "蓝", 255)
										else
											if ((YDWEIsEventDamageType( DAMAGE_TYPE_DIVINE) == true)) then
												call YDLocal1Set(integer, "红", 255)
												call YDLocal1Set(integer, "绿", 215)
												call YDLocal1Set(integer, "蓝", 0)
											else
												if ((YDWEIsEventDamageType( DAMAGE_TYPE_DEMOLITION) == true)) then
													call YDLocal1Set(integer, "红", 210)
													call YDLocal1Set(integer, "绿", 105)
													call YDLocal1Set(integer, "蓝", 30)
												else
												endif
											endif
										endif
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
	endif
	call YDLocal1Set(integer, "zs", R2I( GetEventDamage()))
	call YDLocal1Set(string, "ZFC", I2S( YDLocal1Get(integer, "zs")))
	if ((YDLocal1Get(integer, "zs") < 10)) then
		call YDLocal1Set(integer, "n", 1)
	else
		if ((YDLocal1Get(integer, "zs") < 100)) then
			call YDLocal1Set(integer, "n", 2)
		else
			if ((YDLocal1Get(integer, "zs") < 1000)) then
				call YDLocal1Set(integer, "n", 3)
			else
				if ((YDLocal1Get(integer, "zs") < 10000)) then
					call YDLocal1Set(integer, "n", 4)
				else
					if ((YDLocal1Get(integer, "zs") < 100000)) then
						call YDLocal1Set(integer, "n", 5)
					else
						if ((YDLocal1Get(integer, "zs") < 1000000)) then
							call YDLocal1Set(integer, "n", 6)
						else
							if ((YDLocal1Get(integer, "zs") < 10000000)) then
								call YDLocal1Set(integer, "n", 7)
							else
								if ((YDLocal1Get(integer, "zs") < 100000000)) then
									call YDLocal1Set(integer, "n", 8)
								else
									if ((YDLocal1Get(integer, "zs") < 1000000000)) then
										call YDLocal1Set(integer, "n", 9)
									else
									endif
								endif
							endif
						endif
					endif
				endif
			endif
		endif
	endif
	//用于间隔每个字的距离
	call YDLocal1Set(real, "JL", YDWEOperatorReal3( 0.00, -, 27.50, *, I2R( YDLocal1Get(integer, "n"))))
	//根据位数创建漂浮文字
	set bj_forLoopBIndex = 1
	set bj_forLoopBIndexEnd = (YDLocal1Get(integer, "n") + 1)
	loop
		exitwhen bj_forLoopBIndex > bj_forLoopBIndexEnd
		call YDLocal1ArraySet(integer, "i", bj_forLoopBIndex, S2I( SubStringBJ( YDLocal1Get(string, "ZFC"), bj_forLoopBIndex, bj_forLoopBIndex)))
		call YDLocal1Set(real, "JL", (YDLocal1Get(real, "JL") + 25.00))
		if ((bj_forLoopBIndex < (YDLocal1Get(integer, "n") + 1))) then
			call YDLocal1Set(real, "模型大小", YDWEGetObjectPropertyReal( YDWE_OBJECT_TYPE_UNIT, GetUnitTypeId( GetTriggerUnit()), "modelScale"))
			call YDLocal1Set(image, "tag", CreateImage( YDLocal1ArrayGet(string, "TX", YDLocal1ArrayGet(integer, "i", bj_forLoopBIndex)), OperatorRealMultiply( 75.00, YDLocal1Get(real, "模型大小")), OperatorRealMultiply( 75.00, YDLocal1Get(real, "模型大小")), OperatorRealMultiply( 75.00, YDLocal1Get(real, "模型大小")), (YDLocal1Get(real, "x") + YDLocal1Get(real, "JL")), YDLocal1Get(real, "y"), 5.00, 0, 0, 0, 2))
			call YDLocal1Set(image, "tag", CreateImage( YDLocal1ArrayGet(string, "TX", YDLocal1ArrayGet(integer, "i", bj_forLoopBIndex)), OperatorRealMultiply( 75.00, 1.00), OperatorRealMultiply( 75.00, 1.00), OperatorRealMultiply( 75.00, 1.00), (YDLocal1Get(real, "x") + YDLocal1Get(real, "JL")), YDLocal1Get(real, "y"), 5.00, 0, 0, 0, 2))
			call SetImageColor( YDLocal1Get(image, "tag"), YDLocal1Get(integer, "红"), YDLocal1Get(integer, "绿"), YDLocal1Get(integer, "蓝"), 255)
			call SetImageConstantHeight( YDLocal1Get(image, "tag"), true, OperatorRealMultiply( OperatorRealAdd( 300.00, GetUnitFlyHeight( GetTriggerUnit())), YDLocal1Get(real, "模型大小")))
			call SetImageRenderAlways( YDLocal1Get(image, "tag"), true)
			set ydl_timer = CreateTimer()
#ifdef YDLOC_New
set G_SIndex = GetHandleId(ydl_timer)
#endif
			call YDLocalSet(ydl_timer, integer, "ii", 0)
			call YDLocalSet(ydl_timer, real, "JL", YDLocal1Get(real, "JL"))
			call YDLocalSet(ydl_timer, image, "tag", YDLocal1Get(image, "tag"))
			call YDLocalSet(ydl_timer, real, "x", YDLocal1Get(real, "x"))
			call YDLocalSet(ydl_timer, real, "y", YDLocal1Get(real, "y"))
#ifdef YDLOC_New
set G_SIndex = G_LIndex
#endif
			call TimerStart(ydl_timer, 0.04, true, function Trig_SHXS_001Func009Func007Func003Func008T)
#ifdef StarDebuggerIncluded 
			call  SDR_DebugTimer(ydl_timer, 0.04, true," function Trig_SHXS_001Func009Func007Func003Func008T","SHXS_001")
#endif 
		else
		endif
		set bj_forLoopBIndex = bj_forLoopBIndex + 1
	endloop
	if ((YDUserDataGet(string, "Boss战","单位", unit) != null)) then
		if ((YDUserDataGet(string, "Boss战","单位", unit) == YDLocal1Get(unit, "U1")) and (IsPlayerInForce( GetOwningPlayer( YDLocal1Get(unit, "U")), YDUserDataGet(string, "玩家","玩家组", force)) == true)) then
			call YDLocal1Set(real, "SZ", RMinBJ( GetUnitState( YDLocal1Get(unit, "U1"), UNIT_STATE_LIFE), I2R( YDLocal1Get(integer, "zs"))))
			call YDUserDataSet(player, GetOwningPlayer( YDLocal1Get(unit, "U")),"造成伤害", real, (YDUserDataGet(player, GetOwningPlayer( YDLocal1Get(unit, "U")),"造成伤害", real) + YDLocal1Get(real, "SZ")))
		else
		endif
		if ((IsUnitType( YDLocal1Get(unit, "U1"), UNIT_TYPE_SUMMONED) == false) and (YDUserDataGet(string, "Boss战","单位", unit) == YDLocal1Get(unit, "U")) and (IsPlayerInForce( GetOwningPlayer( YDLocal1Get(unit, "U1")), YDUserDataGet(string, "玩家","玩家组", force)) == true)) then
			call YDLocal1Set(real, "CS", RMinBJ( GetUnitState( YDLocal1Get(unit, "U"), UNIT_STATE_LIFE), I2R( YDLocal1Get(integer, "zs"))))
			call YDUserDataSet(player, GetOwningPlayer( YDLocal1Get(unit, "U1")),"承受伤害", real, (YDUserDataGet(player, GetOwningPlayer( YDLocal1Get(unit, "U1")),"承受伤害", real) + YDLocal1Get(real, "CS")))
		else
		endif
	else
	endif
	call YDLocal1Release()
	set ydl_timer = null
endfunction

//===========================================================================
function InitTrig_SHXS_001 takes nothing returns nothing
	set gg_trg_SHXS_001 = CreateTrigger()
#ifdef DEBUG
	call YDWESaveTriggerName(gg_trg_SHXS_001,"SHXS_001")
#endif
	call MNAnyUnitDamaged(gg_trg_SHXS_001, 5.00)
	call TriggerAddCondition(gg_trg_SHXS_001, Condition(function Trig_SHXS_001Conditions))
	call TriggerAddAction(gg_trg_SHXS_001, function Trig_SHXS_001Actions)
endfunction

