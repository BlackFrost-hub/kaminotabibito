globals
//globals from BzAPI:
constant boolean LIBRARY_BzAPI=true
//endglobals from BzAPI
//globals from CyaCameraSystem:
constant boolean LIBRARY_CyaCameraSystem=true
//endglobals from CyaCameraSystem
//globals from IrAttackType:
constant boolean LIBRARY_IrAttackType=true
//endglobals from IrAttackType
//globals from MNEVENT:
constant boolean LIBRARY_MNEVENT=true
trigger MNEVENT___MNDamageEventTrigger= null
trigger array MNEVENT___DamageEventQueue
integer MNEVENT___DamageEventNumber= 0
timer MNEVENT___time= CreateTimer()
group MNEVENT___UnitGroup= CreateGroup()
triggeraction MNEVENT___ta
//endglobals from MNEVENT
//globals from MNXT:
constant boolean LIBRARY_MNXT=true
hashtable csht= InitHashtable()
//endglobals from MNXT
//globals from SLDebugLib:
constant boolean LIBRARY_SLDebugLib=true
        //trigger array SLTestCallback 
//endglobals from SLDebugLib
//globals from SLInteger:
constant boolean LIBRARY_SLInteger=true
hashtable SLInteger__HT=InitHashtable()
integer SLInteger__IntegerLists=0
integer SLInteger__K_Count=StringHash("Count")
integer SLInteger_CallbackInteger=0
boolean SLInteger_RemovedWhenForGroup=false
boolean SLInteger_IsOnForGroup=false
//endglobals from SLInteger
//globals from SLReal:
constant boolean LIBRARY_SLReal=true
hashtable SLReal__HT=InitHashtable()
integer SLReal__RealLists=0
integer SLReal__K_Count=StringHash("Count")
real SLReal_CallbackReal=0
boolean SLReal_RemovedWhenForGroup=false
boolean SLReal_IsOnForGroup=false
//endglobals from SLReal
//globals from SLStr:
constant boolean LIBRARY_SLStr=true
hashtable SLStr__HT=InitHashtable()
integer SLStr__StrLists=0
integer SLStr__K_Count=StringHash("Count")
string SLStr_CallbackStr=null
//endglobals from SLStr
//globals from StarCommon:
constant boolean LIBRARY_StarCommon=true
string array SSL_StringBuffer
integer SSL_StringBufferIndex=0
//endglobals from StarCommon
//globals from StarEvent:
constant boolean LIBRARY_StarEvent=true
trigger StarTrig_ItemPickUP=CreateTrigger()
trigger StarTrig_UnitOrder=CreateTrigger()
trigger StarTrig_UnitSell=CreateTrigger()
trigger StarTrig_OnDie=CreateTrigger()
trigger StarTrig_EnterMap=CreateTrigger()
//endglobals from StarEvent
//globals from StarLoadAny:
constant boolean LIBRARY_StarLoadAny=true
//endglobals from StarLoadAny
//globals from X:
constant boolean LIBRARY_X=true
hashtable X_ht= InitHashtable()
constant real X__MAX_RANGE= 10.
constant integer X__DUMMY_ITEM_ID= 'wolg'
item X__Item= null
rect X__Find= null
item array X__Hid
integer X__HidMax= 0
real X_X= 0.
real X_Y= 0.
//endglobals from X
//globals from YDTriggerSaveLoadSystem:
constant boolean LIBRARY_YDTriggerSaveLoadSystem=true
integer StarLuaKey= 0
integer StarBlockKey= 0
integer G_LIndex= 0
integer G_SIndex= 0
integer G_LastSIndex= 0
integer G_LastLIndex= 0
integer G_SIndex3=0
integer G_SIndex4=0
hashtable YDHT
hashtable YDLOC
integer SKey_PIndex= 0x176FC2AB
integer Star_PIndex= 0
integer SKey_Trigger= 0xDF9D0BE0
//endglobals from YDTriggerSaveLoadSystem
//globals from YDWEAbilityState:
constant boolean LIBRARY_YDWEAbilityState=true
		
constant integer YDWEAbilityState__ABILITY_STATE_COOLDOWN= 1
constant integer YDWEAbilityState__ABILITY_DATA_TARGS= 100
constant integer YDWEAbilityState__ABILITY_DATA_CAST= 101
constant integer YDWEAbilityState__ABILITY_DATA_DUR= 102
constant integer YDWEAbilityState__ABILITY_DATA_HERODUR= 103
constant integer YDWEAbilityState__ABILITY_DATA_COST= 104
constant integer YDWEAbilityState__ABILITY_DATA_COOL= 105
constant integer YDWEAbilityState__ABILITY_DATA_AREA= 106
constant integer YDWEAbilityState__ABILITY_DATA_RNG= 107
constant integer YDWEAbilityState__ABILITY_DATA_DATA_A= 108
constant integer YDWEAbilityState__ABILITY_DATA_DATA_B= 109
constant integer YDWEAbilityState__ABILITY_DATA_DATA_C= 110
constant integer YDWEAbilityState__ABILITY_DATA_DATA_D= 111
constant integer YDWEAbilityState__ABILITY_DATA_DATA_E= 112
constant integer YDWEAbilityState__ABILITY_DATA_DATA_F= 113
constant integer YDWEAbilityState__ABILITY_DATA_DATA_G= 114
constant integer YDWEAbilityState__ABILITY_DATA_DATA_H= 115
constant integer YDWEAbilityState__ABILITY_DATA_DATA_I= 116
constant integer YDWEAbilityState__ABILITY_DATA_UNITID= 117

constant integer YDWEAbilityState__ABILITY_DATA_HOTKET= 200
constant integer YDWEAbilityState__ABILITY_DATA_UNHOTKET= 201
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_HOTKEY= 202
constant integer YDWEAbilityState__ABILITY_DATA_NAME= 203
constant integer YDWEAbilityState__ABILITY_DATA_ART= 204
constant integer YDWEAbilityState__ABILITY_DATA_TARGET_ART= 205
constant integer YDWEAbilityState__ABILITY_DATA_CASTER_ART= 206
constant integer YDWEAbilityState__ABILITY_DATA_EFFECT_ART= 207
constant integer YDWEAbilityState__ABILITY_DATA_AREAEFFECT_ART= 208
constant integer YDWEAbilityState__ABILITY_DATA_MISSILE_ART= 209
constant integer YDWEAbilityState__ABILITY_DATA_SPECIAL_ART= 210
constant integer YDWEAbilityState__ABILITY_DATA_LIGHTNING_EFFECT= 211
constant integer YDWEAbilityState__ABILITY_DATA_BUFF_TIP= 212
constant integer YDWEAbilityState__ABILITY_DATA_BUFF_UBERTIP= 213
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_TIP= 214
constant integer YDWEAbilityState__ABILITY_DATA_TIP= 215
constant integer YDWEAbilityState__ABILITY_DATA_UNTIP= 216
constant integer YDWEAbilityState__ABILITY_DATA_RESEARCH_UBERTIP= 217
constant integer YDWEAbilityState__ABILITY_DATA_UBERTIP= 218
constant integer YDWEAbilityState__ABILITY_DATA_UNUBERTIP= 219
constant integer YDWEAbilityState__ABILITY_DATA_UNART= 220
//endglobals from YDWEAbilityState
//globals from YDWEEventDamageData:
constant boolean LIBRARY_YDWEEventDamageData=true
constant integer YDWEEventDamageData___EVENT_DAMAGE_DATA_VAILD= 0
constant integer YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_PHYSICAL= 1
constant integer YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_ATTACK= 2
constant integer YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_RANGED= 3
constant integer YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE= 4
constant integer YDWEEventDamageData___EVENT_DAMAGE_DATA_WEAPON_TYPE= 5
constant integer YDWEEventDamageData___EVENT_DAMAGE_DATA_ATTACK_TYPE= 6
//endglobals from YDWEEventDamageData
//globals from YDWEJapiEffect:
constant boolean LIBRARY_YDWEJapiEffect=true
//endglobals from YDWEJapiEffect
//globals from YDWEJapiUnit:
constant boolean LIBRARY_YDWEJapiUnit=true
//endglobals from YDWEJapiUnit
//globals from YDWEYDWEJapiScript:
constant boolean LIBRARY_YDWEYDWEJapiScript=true
constant integer YDWE_OBJECT_TYPE_ABILITY= 0
constant integer YDWE_OBJECT_TYPE_BUFF= 1
constant integer YDWE_OBJECT_TYPE_UNIT= 2
constant integer YDWE_OBJECT_TYPE_ITEM= 3
constant integer YDWE_OBJECT_TYPE_UPGRADE= 4
constant integer YDWE_OBJECT_TYPE_DOODAD= 5
constant integer YDWE_OBJECT_TYPE_DESTRUCTABLE= 6
//endglobals from YDWEYDWEJapiScript
//globals from StarBase:
constant boolean LIBRARY_StarBase=true
trigger StarBase__trig=CreateTrigger()
triggeraction StarBase__ta=null
location Star_Location=Location(0, 0)
hashtable StarBaseHT=InitHashtable()
constant integer skey_count=0xB7279243
constant integer skey_countEx=0x9F1E41BF
constant integer skey_index=0xA707D18B
constant integer skey_indexEx=0x7E88D913
string StarVarStr=""
unit Star_TriggerUnit=null
unit Star_TargetUnit=null
unit Star_SourceUnit=null
effect Star_TriggerEffect=null
effect Star_TargetEffect=null
item Star_TriggerItem=null
//endglobals from StarBase
//globals from StarOverSpeed:
constant boolean LIBRARY_StarOverSpeed=true
//endglobals from StarOverSpeed
//globals from StarUnit:
constant boolean LIBRARY_StarUnit=true
hashtable StarUnit__HT=InitHashtable()
unit CallBackUnit
destructable CallBackDestructable
trigger StarUnit__su_ItemAbilityTrig=CreateTrigger()
trigger StarUnit__su_ItemAbilityTrig2=CreateTrigger()
integer Star_LastSpellItemAbility=0
real Star_LastSpellItemAbilityTargetX=0
real Star_LastSpellItemAbilityTargetY=0
location Star_LastSpellItemAbilityTargetPoint=null
trigger array StarUnit__su_iatList
integer StarUnit__su_iatIndex=0
//endglobals from StarUnit
//globals from ItmeProperty:
constant boolean LIBRARY_ItmeProperty=true
unit UnitEvePty
integer ItmeProperty___max= 20
unit ItmeProperty___UnitPtyEvent
hashtable ItmeProperty___HS= InitHashtable()
hashtable ItmeProperty___HS_EVE= InitHashtable()
//endglobals from ItmeProperty
//globals from STES:
constant boolean LIBRARY_STES=true
hashtable STES__HT=InitHashtable()
hashtable STES_HT
integer STES_Hash
integer STES_Index
integer STES_LoopA
//endglobals from STES
//globals from StarDebugger:
constant boolean LIBRARY_StarDebugger=true
hashtable StarDebugger__ht=InitHashtable()
hashtable SDR_HT
integer SDR_Index=0
//endglobals from StarDebugger
//globals from StarString:
constant boolean LIBRARY_StarString=true
string array SS_CallbackString
integer SS_Index
string CallBackString
//endglobals from StarString
//globals from SUTriggerList:
constant boolean LIBRARY_SUTriggerList=true
integer SUTriggerList__key_Count=0x720A60C0
hashtable SUTriggerList__ht=InitHashtable()
hashtable SUTL_HT
//endglobals from SUTriggerList
//globals from StarGSS:
constant boolean LIBRARY_StarGSS=true
integer StarGSS__key_str=0x30FA192C
integer StarGSS__key_agi=0x678A421B
integer StarGSS__key_int=0x6F97DD18
integer StarGSS__key_atk=0x2CC80A8A
integer StarGSS__key_amr=0x40536706
integer StarGSS__key_hp=0xCDAAA9F4
integer StarGSS__key_mp=0x810169FE
integer StarGSS__key_ms=0xA6B44B64
integer StarGSS__key_as=0x86A02DAE
integer StarGSS__key_rhp=0xEBBDD513
integer StarGSS__key_rmp=0xEBD2A8F3
timer StarGSS__t=CreateTimer()
integer StarGSS__index=0
unit array StarGSS__list
real StarGSS__xiaolv=1
string array SGSS_TypeStr
integer array SGSS_TypeStrHash
//endglobals from StarGSS
rect gg_rct______________000= null
rect gg_rct______________001= null
rect gg_rct______________002= null
rect gg_rct______________003= null
unit array udg_TempUnit
real udg_TempDmg= 0
real udg_TempStr= 0
real udg_TempAgi= 0
real udg_TempInt= 0
real udg_TempHp= 0
real udg_TempArmor= 0
boolean udg_TempIsAdd= false
real udg_TempMp= 0
real udg_TempAtkSpeed= 0
real udg_TempMoveSpeed= 0
real udg_TempAll= 0
real array udg_TempAmount
integer udg_TempStatCount= 0
string array udg_TempString
real array udg_TempReadValue
real udg_TempScoreMin= 0
real udg_TempScoreMax= 0
integer udg_TempItemType= 0
trigger udg_RegTrigger= null
string udg_RegEventStr
real udg_T= 0
player array udg_TempPlayer
real udg_TempFacing= 0
real array udg_TempReal
integer array udg_TempInteger
integer udg_TempDamageType= 0
timer array udg_JSQ
integer array udg_UI
unit udg_Boss= null
trigger gg_trg____________________002= null
trigger gg_trg____________________004= null
trigger gg_trg__________u= null
trigger gg_trg_dmg= null
trigger gg_trg_GetDmgType= null
trigger gg_trg_LuaFunction= null
trigger gg_trg________________u= null
trigger gg_trg_____________u= null
trigger gg_trg_______lua_jass______u= null
trigger gg_trg_______movespeed= null
trigger gg_trg_____________am= null
trigger gg_trg____________________003= null
trigger gg_trg_HealItemEffect= null
trigger gg_trg_ZXRW01= null
trigger gg_trg_ZXRW02= null
trigger gg_trg____________________001= null
unit gg_unit_Hamg_0002= null

trigger l__library_init

//JASSHelper struct globals:
integer si__StringArray_I=0
integer si__StringArray_F=0
string array s__StringArray
constant integer s__StringArray_size=16
integer array si__StringArray_V
constant integer si__Math=2
integer si__Math_F=0
integer si__Math_I=0
integer array si__Math_V
constant integer s__Math_MaxInt=2147483647
constant integer s__Math_MinInt=- 2147483648
constant real s__Math_Tolerance=0.000001
constant real s__Math_PI=3.1415927
constant real s__Math_E=2.7182818
constant integer si__StringUtil=3
integer si__StringUtil_F=0
integer si__StringUtil_I=0
integer array si__StringUtil_V
integer s__StringUtil_count=0
constant integer si__Convert=4
integer si__Convert_F=0
integer si__Convert_I=0
integer array si__Convert_V
constant string s__Convert_charSet=" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~" // !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~ 
constant string s__Convert_charSet64="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/"
constant integer si__StarTable=5
integer si__StarTable_F=0
integer si__StarTable_I=0
integer array si__StarTable_V
hashtable s__StarTable_ht
constant integer si__Argb=6
integer s__Argb_Red=0xFFFF0303
integer s__Argb_Orange=0xFFFE8A0E
integer s__Argb_Yellow=0xFFFFFC01
integer s__Argb_Green=0xFF20C000
integer s__Argb_Cyan=0xFF1CE6B9
integer s__Argb_Blue=0xFF0042FF
integer s__Argb_Purple=0xFF540081
integer s__Argb_White=0xFFFFFFFF
integer s__Argb_Black=0xFF000000
constant integer si__Vector2=7
integer si__Vector2_F=0
integer si__Vector2_I=0
integer array si__Vector2_V
integer s__Vector2_Zero
integer s__Vector2_UnitX
integer s__Vector2_UnitY
integer s__Vector2_UnitScale
integer s__Vector2_NegativeUnitX
integer s__Vector2_NegativeUnitY
integer s__Vector2_Temp
real array s__Vector2_X
real array s__Vector2_Y
constant integer si__Vector3=8
integer si__Vector3_F=0
integer si__Vector3_I=0
integer array si__Vector3_V
integer s__Vector3_Zero
integer s__Vector3_UnitX
integer s__Vector3_UnitY
integer s__Vector3_UnitZ
integer s__Vector3_UnitScale
integer s__Vector3_NegativeUnitX
integer s__Vector3_NegativeUnitY
integer s__Vector3_NegativeUnitZ
integer s__Vector3_Temp
integer array s__Vector3_Vector2
real array s__Vector3_Z
constant integer si__Block=9
integer si__Block_F=0
integer si__Block_I=0
integer array si__Block_V
integer array s__Block_blocks
integer s__Block_Count=0
rect array s__Block_Rect
integer array s___Block_List
constant integer s___Block_List_size=2000
integer array s__Block_List
integer array s__Block_index
real array s__Block_minx
real array s__Block_miny
real array s__Block_maxx
real array s__Block_maxy
integer array s__Block_blocks2
integer s__Block_count2
constant integer si__Map=11
integer si__Map_F=0
integer si__Map_I=0
integer array si__Map_V
real s__Map_MaxX
real s__Map_MaxY
real s__Map_MinX
real s__Map_MinY
real s__Map_width
real s__Map_height
integer s__Map_blockMaxX
integer s__Map_blockMaxY
real s__Map_size
constant integer si__SEffect=12
integer si__SEffect_F=0
integer si__SEffect_I=0
integer array si__SEffect_V
integer s__SEffect_TI
effect array s__SEffect_object
string array s__SEffect_path
integer array s__SEffect_id
integer array s__SEffect_own
constant integer si__StarOverSpeed__StarOverSpeedGenerator=13
integer si__StarOverSpeed__StarOverSpeedGenerator_F=0
integer si__StarOverSpeed__StarOverSpeedGenerator_I=0
integer array si__StarOverSpeed__StarOverSpeedGenerator_V
timer s__StarOverSpeed__StarOverSpeedGenerator_Timer
boolean s__StarOverSpeed__StarOverSpeedGenerator_IsRun=false
integer s__StarOverSpeed__StarOverSpeedGenerator_count=0
integer s__StarOverSpeed__StarOverSpeedGenerator_now=0
boolean s__StarOverSpeed__StarOverSpeedGenerator_skip=false
integer array s__StarOverSpeed__StarOverSpeedGenerator_list
integer s__StarOverSpeed__StarOverSpeedGenerator_EventID=0
integer s__StarOverSpeed__StarOverSpeedGenerator_hashkey=0x02C93F13
real array s__StarOverSpeed__StarOverSpeedGenerator_speed
unit array s__StarOverSpeed__StarOverSpeedGenerator_u
trigger array s__StarOverSpeed__StarOverSpeedGenerator_t
trigger array s__StarOverSpeed__StarOverSpeedGenerator_cb
real array s__StarOverSpeed__StarOverSpeedGenerator_tx
real array s__StarOverSpeed__StarOverSpeedGenerator_ty
real array s__StarOverSpeed__StarOverSpeedGenerator_lx
real array s__StarOverSpeed__StarOverSpeedGenerator_ly
real array s__StarOverSpeed__StarOverSpeedGenerator_lf
boolean array s__StarOverSpeed__StarOverSpeedGenerator_movementsync
boolean array s__StarOverSpeed__StarOverSpeedGenerator_b
trigger st__Math_GetRandomReal
trigger st__Math_Cos
trigger st__Math_Atan2
trigger st__Math_Power
trigger st__Math_Exp
trigger st__Math_Modulo
trigger st__Math_Ln
trigger st__StringUtil_IndexOf
trigger st__StringUtil_CharAt
trigger st__StringUtil_SubString
trigger st__Convert_S2Id
trigger st__Convert_Id2S
trigger st__Convert_R2I
trigger st__Convert_R2S
trigger st__Argb_ToString
trigger st__Vector2_Scale
trigger st__Vector3_Scale
trigger st__Vector3_CrossProduct
trigger st__SEffect_onDestroy
trigger st__SEffect_SetRotateZ
trigger st__StarOverSpeed__StarOverSpeedGenerator_onDestroy
trigger st__StarOverSpeed__StarOverSpeedGenerator_Start
trigger st__StarOverSpeed__StarOverSpeedGenerator_Stop
trigger array st___prototype6
real f__arg_real1
real f__arg_real2
string f__arg_string1
string f__arg_string2
integer f__arg_integer1
integer f__arg_integer2
effect f__arg_effect1
integer f__arg_this
real f__result_real
integer f__result_integer
string f__result_string

endglobals
native DzGetMouseTerrainX takes nothing returns real
native DzGetMouseTerrainY takes nothing returns real
native DzGetMouseTerrainZ takes nothing returns real
native DzIsMouseOverUI takes nothing returns boolean
native DzGetMouseX takes nothing returns integer
native DzGetMouseY takes nothing returns integer
native DzGetMouseXRelative takes nothing returns integer
native DzGetMouseYRelative takes nothing returns integer
native DzSetMousePos takes integer x, integer y returns nothing
native DzTriggerRegisterMouseEvent takes trigger trig, integer btn, integer status, boolean sync, string func returns nothing
native DzTriggerRegisterMouseEventByCode takes trigger trig, integer btn, integer status, boolean sync, code funcHandle returns nothing
native DzTriggerRegisterKeyEvent takes trigger trig, integer key, integer status, boolean sync, string func returns nothing
native DzTriggerRegisterKeyEventByCode takes trigger trig, integer key, integer status, boolean sync, code funcHandle returns nothing
native DzTriggerRegisterMouseWheelEvent takes trigger trig, boolean sync, string func returns nothing
native DzTriggerRegisterMouseWheelEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
native DzTriggerRegisterMouseMoveEvent takes trigger trig, boolean sync, string func returns nothing
native DzTriggerRegisterMouseMoveEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
native DzGetTriggerKey takes nothing returns integer
native DzGetWheelDelta takes nothing returns integer
native DzIsKeyDown takes integer iKey returns boolean
native DzGetTriggerKeyPlayer takes nothing returns player
native DzGetWindowWidth takes nothing returns integer
native DzGetWindowHeight takes nothing returns integer
native DzGetWindowX takes nothing returns integer
native DzGetWindowY takes nothing returns integer
native DzTriggerRegisterWindowResizeEvent takes trigger trig, boolean sync, string func returns nothing
native DzTriggerRegisterWindowResizeEventByCode takes trigger trig, boolean sync, code funcHandle returns nothing
native DzIsWindowActive takes nothing returns boolean
native DzDestructablePosition takes destructable d, real x, real y returns nothing
native DzSetUnitPosition takes unit whichUnit, real x, real y returns nothing
native DzExecuteFunc takes string funcName returns nothing
native DzGetUnitUnderMouse takes nothing returns unit
native DzSetUnitTexture takes unit whichUnit, string path, integer texId returns nothing
native DzSetMemory takes integer address, real value returns nothing
native DzSetUnitID takes unit whichUnit, integer id returns nothing
native DzSetUnitModel takes unit whichUnit, string path returns nothing
native DzSetWar3MapMap takes string map returns nothing
native DzGetLocale takes nothing returns string
native DzGetUnitNeededXP takes unit whichUnit, integer level returns integer
native DzTriggerRegisterSyncData takes trigger trig, string prefix, boolean server returns nothing
native DzSyncData takes string prefix, string data returns nothing
native DzGetTriggerSyncPrefix takes nothing returns string
native DzGetTriggerSyncData takes nothing returns string
native DzGetTriggerSyncPlayer takes nothing returns player
native DzSyncBuffer takes string prefix, string data, integer dataLen returns nothing
native DzSyncDataImmediately takes string prefix, string data returns nothing
native DzFrameHideInterface takes nothing returns nothing
native DzFrameEditBlackBorders takes real upperHeight, real bottomHeight returns nothing
native DzFrameGetPortrait takes nothing returns integer
native DzFrameGetMinimap takes nothing returns integer
native DzFrameGetCommandBarButton takes integer row, integer column returns integer
native DzFrameGetHeroBarButton takes integer buttonId returns integer
native DzFrameGetHeroHPBar takes integer buttonId returns integer
native DzFrameGetHeroManaBar takes integer buttonId returns integer
native DzFrameGetItemBarButton takes integer buttonId returns integer
native DzFrameGetMinimapButton takes integer buttonId returns integer
native DzFrameGetUpperButtonBarButton takes integer buttonId returns integer
native DzFrameGetTooltip takes nothing returns integer
native DzFrameGetChatMessage takes nothing returns integer
native DzFrameGetUnitMessage takes nothing returns integer
native DzFrameGetTopMessage takes nothing returns integer
native DzGetColor takes integer r, integer g, integer b, integer a returns integer
native DzFrameSetUpdateCallback takes string func returns nothing
native DzFrameSetUpdateCallbackByCode takes code funcHandle returns nothing
native DzFrameShow takes integer frame, boolean enable returns nothing
native DzCreateFrame takes string frame, integer parent, integer id returns integer
native DzCreateSimpleFrame takes string frame, integer parent, integer id returns integer
native DzDestroyFrame takes integer frame returns nothing
native DzLoadToc takes string fileName returns nothing
native DzFrameSetPoint takes integer frame, integer point, integer relativeFrame, integer relativePoint, real x, real y returns nothing
native DzFrameSetAbsolutePoint takes integer frame, integer point, real x, real y returns nothing
native DzFrameClearAllPoints takes integer frame returns nothing
native DzFrameSetEnable takes integer name, boolean enable returns nothing
native DzFrameSetScript takes integer frame, integer eventId, string func, boolean sync returns nothing
native DzFrameSetScriptByCode takes integer frame, integer eventId, code funcHandle, boolean sync returns nothing
native DzGetTriggerUIEventPlayer takes nothing returns player
native DzGetTriggerUIEventFrame takes nothing returns integer
native DzFrameFindByName takes string name, integer id returns integer
native DzSimpleFrameFindByName takes string name, integer id returns integer
native DzSimpleFontStringFindByName takes string name, integer id returns integer
native DzSimpleTextureFindByName takes string name, integer id returns integer
native DzGetGameUI takes nothing returns integer
native DzClickFrame takes integer frame returns nothing
native DzSetCustomFovFix takes real value returns nothing
native DzEnableWideScreen takes boolean enable returns nothing
native DzFrameSetText takes integer frame, string text returns nothing
native DzFrameGetText takes integer frame returns string
native DzFrameSetTextSizeLimit takes integer frame, integer size returns nothing
native DzFrameGetTextSizeLimit takes integer frame returns integer
native DzFrameSetTextColor takes integer frame, integer color returns nothing
native DzGetMouseFocus takes nothing returns integer
native DzFrameSetAllPoints takes integer frame, integer relativeFrame returns boolean
native DzFrameSetFocus takes integer frame, boolean enable returns boolean
native DzFrameSetModel takes integer frame, string modelFile, integer modelType, integer flag returns nothing
native DzFrameGetEnable takes integer frame returns boolean
native DzFrameSetAlpha takes integer frame, integer alpha returns nothing
native DzFrameGetAlpha takes integer frame returns integer
native DzFrameSetAnimate takes integer frame, integer animId, boolean autocast returns nothing
native DzFrameSetAnimateOffset takes integer frame, real offset returns nothing
native DzFrameSetTexture takes integer frame, string texture, integer flag returns nothing
native DzFrameSetScale takes integer frame, real scale returns nothing
native DzFrameSetTooltip takes integer frame, integer tooltip returns nothing
native DzFrameCageMouse takes integer frame, boolean enable returns nothing
native DzFrameGetValue takes integer frame returns real
native DzFrameSetMinMaxValue takes integer frame, real minValue, real maxValue returns nothing
native DzFrameSetStepValue takes integer frame, real step returns nothing
native DzFrameSetValue takes integer frame, real value returns nothing
native DzFrameSetSize takes integer frame, real w, real h returns nothing
native DzCreateFrameByTagName takes string frameType, string name, integer parent, string template, integer id returns integer
native DzFrameSetVertexColor takes integer frame, integer color returns nothing
native DzOriginalUIAutoResetPoint takes boolean enable returns nothing
native DzFrameSetPriority takes integer frame, integer priority returns nothing
native DzFrameSetParent takes integer frame, integer parent returns nothing
native DzFrameGetHeight takes integer frame returns real
native DzFrameSetFont takes integer frame, string fileName, real height, integer flag returns nothing
native DzFrameGetParent takes integer frame returns integer
native DzFrameSetTextAlignment takes integer frame, integer align returns nothing
native DzFrameGetName takes integer frame returns string
native EXSetUnitArrayString takes integer uid, integer id, integer n, string name returns boolean
native EXSetUnitInteger takes integer uid, integer id, integer n returns boolean
native DzGetClientWidth takes nothing returns integer
native DzGetClientHeight takes nothing returns integer
native DzFrameIsVisible takes integer frame returns boolean
native DzFrameAddText takes integer frame, string text returns nothing
native DzUnitSilence takes unit whichUnit, boolean disable returns nothing
native DzUnitDisableAttack takes unit whichUnit, boolean disable returns nothing
native DzUnitDisableInventory takes unit whichUnit, boolean disable returns nothing
native DzUpdateMinimap takes nothing returns nothing
native DzUnitChangeAlpha takes unit whichUnit, integer alpha, boolean forceUpdate returns nothing
native DzUnitSetCanSelect takes unit whichUnit, boolean state returns nothing
native DzUnitSetTargetable takes unit whichUnit, boolean state returns nothing
native DzSaveMemoryCache takes string cache returns nothing
native DzGetMemoryCache takes nothing returns string
native DzSetSpeed takes real ratio returns nothing
native DzConvertWorldPosition takes real x, real y, real z, code callback returns boolean
native DzGetConvertWorldPositionX takes nothing returns real
native DzGetConvertWorldPositionY takes nothing returns real
native DzCreateCommandButton takes integer parent, string icon, string name, string desc returns integer
	native EXGetUnitAbility takes unit u, integer abilcode returns ability
	native EXGetUnitAbilityByIndex takes unit u, integer index returns ability
	native EXGetAbilityId takes ability abil returns integer
	native EXGetAbilityState takes ability abil, integer state_type returns real
	native EXSetAbilityState takes ability abil, integer state_type, real value returns boolean
	native EXGetAbilityDataReal takes ability abil, integer level, integer data_type returns real
	native EXSetAbilityDataReal takes ability abil, integer level, integer data_type, real value returns boolean
	native EXGetAbilityDataInteger takes ability abil, integer level, integer data_type returns integer
	native EXSetAbilityDataInteger takes ability abil, integer level, integer data_type, integer value returns boolean
	native EXGetAbilityDataString takes ability abil, integer level, integer data_type returns string
	native EXSetAbilityDataString takes ability abil, integer level, integer data_type, string value returns boolean
	native EXSetAbilityAEmeDataA takes ability abil, integer unitid returns boolean
	native EXGetItemDataString takes integer itemcode, integer data_type returns string
	native EXSetItemDataString takes integer itemcode, integer data_type, string value returns boolean
native EXGetEventDamageData takes integer edd_type returns integer
native EXSetEventDamage takes real amount returns boolean
	native EXGetEffectX takes effect e returns real
	native EXGetEffectY takes effect e returns real
	native EXGetEffectZ takes effect e returns real
	native EXSetEffectXY takes effect e, real x, real y returns nothing
	native EXSetEffectZ takes effect e, real z returns nothing
	native EXGetEffectSize takes effect e returns real
	native EXSetEffectSize takes effect e, real size returns nothing
	native EXEffectMatRotateX takes effect e, real angle returns nothing
	native EXEffectMatRotateY takes effect e, real angle returns nothing
	native EXEffectMatRotateZ takes effect e, real angle returns nothing
	native EXEffectMatScale takes effect e, real x, real y, real z returns nothing
	native EXEffectMatReset takes effect e returns nothing
	native EXSetEffectSpeed takes effect e, real speed returns nothing
	native EXSetUnitFacing takes unit u, real angle returns nothing
	native EXPauseUnit takes unit u, boolean flag returns nothing
	native EXSetUnitCollisionType takes boolean enable, unit u, integer t returns nothing
	native EXSetUnitMoveType takes unit u, integer t returns nothing
	native EXExecuteScript takes string script returns string


//Generated allocator of StringArray
function s__StringArray__allocate takes nothing returns integer
 local integer this=si__StringArray_F
    if (this!=0) then
        set si__StringArray_F=si__StringArray_V[this]
    else
        set si__StringArray_I=si__StringArray_I+16
        set this=si__StringArray_I
    endif
    if (this>8175) then
        return 0
    endif

    set si__StringArray_V[this]=-1
 return this
endfunction

//Generated destructor of StringArray
function s__StringArray_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__StringArray_V[this]!=-1) then
        return
    endif
    set si__StringArray_V[this]=si__StringArray_F
    set si__StringArray_F=this
endfunction

//Generated method caller for StarOverSpeed__StarOverSpeedGenerator.onDestroy
function sc__StarOverSpeed__StarOverSpeedGenerator_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__StarOverSpeed__StarOverSpeedGenerator_onDestroy)
endfunction

//Generated method caller for StarOverSpeed__StarOverSpeedGenerator.Start
function sc__StarOverSpeed__StarOverSpeedGenerator_Start takes nothing returns nothing
    call TriggerEvaluate(st__StarOverSpeed__StarOverSpeedGenerator_Start)
endfunction

//Generated method caller for StarOverSpeed__StarOverSpeedGenerator.Stop
function sc__StarOverSpeed__StarOverSpeedGenerator_Stop takes nothing returns nothing
    call TriggerEvaluate(st__StarOverSpeed__StarOverSpeedGenerator_Stop)
endfunction

//Generated allocator of StarOverSpeed__StarOverSpeedGenerator
function s__StarOverSpeed__StarOverSpeedGenerator__allocate takes nothing returns integer
 local integer this=si__StarOverSpeed__StarOverSpeedGenerator_F
    if (this!=0) then
        set si__StarOverSpeed__StarOverSpeedGenerator_F=si__StarOverSpeed__StarOverSpeedGenerator_V[this]
    else
        set si__StarOverSpeed__StarOverSpeedGenerator_I=si__StarOverSpeed__StarOverSpeedGenerator_I+1
        set this=si__StarOverSpeed__StarOverSpeedGenerator_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__StarOverSpeed__StarOverSpeedGenerator_V[this]=-1
 return this
endfunction

//Generated destructor of StarOverSpeed__StarOverSpeedGenerator
function sc__StarOverSpeed__StarOverSpeedGenerator_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__StarOverSpeed__StarOverSpeedGenerator_V[this]!=-1) then
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__StarOverSpeed__StarOverSpeedGenerator_onDestroy)
    set si__StarOverSpeed__StarOverSpeedGenerator_V[this]=si__StarOverSpeed__StarOverSpeedGenerator_F
    set si__StarOverSpeed__StarOverSpeedGenerator_F=this
endfunction

//Generated method caller for SEffect.onDestroy
function sc__SEffect_onDestroy takes integer this returns nothing
    set f__arg_this=this
    call TriggerEvaluate(st__SEffect_onDestroy)
endfunction

//Generated method caller for SEffect.SetRotateZ
function sc__SEffect_SetRotateZ takes effect e,real z returns nothing
            call EXEffectMatReset(e)
            call EXEffectMatRotateZ(e, z)
endfunction

//Generated allocator of SEffect
function s__SEffect__allocate takes nothing returns integer
 local integer this=si__SEffect_F
    if (this!=0) then
        set si__SEffect_F=si__SEffect_V[this]
    else
        set si__SEffect_I=si__SEffect_I+1
        set this=si__SEffect_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__SEffect_V[this]=-1
 return this
endfunction

//Generated destructor of SEffect
function sc__SEffect_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__SEffect_V[this]!=-1) then
        return
    endif
    set f__arg_this=this
    call TriggerEvaluate(st__SEffect_onDestroy)
    set si__SEffect_V[this]=si__SEffect_F
    set si__SEffect_F=this
endfunction

//Generated allocator of Map
function s__Map__allocate takes nothing returns integer
 local integer this=si__Map_F
    if (this!=0) then
        set si__Map_F=si__Map_V[this]
    else
        set si__Map_I=si__Map_I+1
        set this=si__Map_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__Map_V[this]=-1
 return this
endfunction

//Generated destructor of Map
function s__Map_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__Map_V[this]!=-1) then
        return
    endif
    set si__Map_V[this]=si__Map_F
    set si__Map_F=this
endfunction

//Generated allocator of Block
function s__Block__allocate takes nothing returns integer
 local integer this=si__Block_F
    if (this!=0) then
        set si__Block_F=si__Block_V[this]
    else
        set si__Block_I=si__Block_I+1
        set this=si__Block_I
    endif
    if (this>3) then
        return 0
    endif
    set s__Block_List[this]=(this-1)*2000
    set si__Block_V[this]=-1
 return this
endfunction

//Generated destructor of Block
function s__Block_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__Block_V[this]!=-1) then
        return
    endif
    set si__Block_V[this]=si__Block_F
    set si__Block_F=this
endfunction

//Generated method caller for Vector3.Scale
function sc__Vector3_Scale takes integer this,real factor returns integer
            set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[this]] * factor
            set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[this]] * factor
            set s__Vector3_Z[this]=s__Vector3_Z[this] * factor
            return this
endfunction

//Generated method caller for Vector3.CrossProduct
function sc__Vector3_CrossProduct takes integer this,integer that returns integer
    set f__arg_this=this
    set f__arg_integer1=that
    call TriggerEvaluate(st__Vector3_CrossProduct)
 return f__result_integer
endfunction

//Generated allocator of Vector3
function s__Vector3__allocate takes nothing returns integer
 local integer this=si__Vector3_F
    if (this!=0) then
        set si__Vector3_F=si__Vector3_V[this]
    else
        set si__Vector3_I=si__Vector3_I+1
        set this=si__Vector3_I
    endif
    if (this>8190) then
        return 0
    endif

   set s__Vector3_Vector2[this]=0
   set s__Vector3_Z[this]=0.0
    set si__Vector3_V[this]=-1
 return this
endfunction

//Generated destructor of Vector3
function s__Vector3_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__Vector3_V[this]!=-1) then
        return
    endif
    set si__Vector3_V[this]=si__Vector3_F
    set si__Vector3_F=this
endfunction

//Generated method caller for Vector2.Scale
function sc__Vector2_Scale takes integer this,real factor returns integer
            set s__Vector2_X[this]=s__Vector2_X[this] * factor
            set s__Vector2_Y[this]=s__Vector2_Y[this] * factor
            return this
endfunction

//Generated allocator of Vector2
function s__Vector2__allocate takes nothing returns integer
 local integer this=si__Vector2_F
    if (this!=0) then
        set si__Vector2_F=si__Vector2_V[this]
    else
        set si__Vector2_I=si__Vector2_I+1
        set this=si__Vector2_I
    endif
    if (this>8190) then
        return 0
    endif

   set s__Vector2_X[this]=0.0
   set s__Vector2_Y[this]=0.0
    set si__Vector2_V[this]=-1
 return this
endfunction

//Generated destructor of Vector2
function s__Vector2_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__Vector2_V[this]!=-1) then
        return
    endif
    set si__Vector2_V[this]=si__Vector2_F
    set si__Vector2_F=this
endfunction

//Generated method caller for Argb.ToString
function sc__Argb_ToString takes integer this returns string
    set f__arg_this=this
    call TriggerEvaluate(st__Argb_ToString)
 return f__result_string
endfunction

//Generated allocator of StarTable
function s__StarTable__allocate takes nothing returns integer
 local integer this=si__StarTable_F
    if (this!=0) then
        set si__StarTable_F=si__StarTable_V[this]
    else
        set si__StarTable_I=si__StarTable_I+1
        set this=si__StarTable_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__StarTable_V[this]=-1
 return this
endfunction

//Generated destructor of StarTable
function s__StarTable_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__StarTable_V[this]!=-1) then
        return
    endif
    set si__StarTable_V[this]=si__StarTable_F
    set si__StarTable_F=this
endfunction

//Generated method caller for Convert.S2Id
function sc__Convert_S2Id takes string s returns integer
    set f__arg_string1=s
    call TriggerEvaluate(st__Convert_S2Id)
 return f__result_integer
endfunction

//Generated method caller for Convert.Id2S
function sc__Convert_Id2S takes integer id returns string
    set f__arg_integer1=id
    call TriggerEvaluate(st__Convert_Id2S)
 return f__result_string
endfunction

//Generated method caller for Convert.R2I
function sc__Convert_R2I takes real r returns integer
    set f__arg_real1=r
    call TriggerEvaluate(st__Convert_R2I)
 return f__result_integer
endfunction

//Generated method caller for Convert.R2S
function sc__Convert_R2S takes real r returns string
    set f__arg_real1=r
    call TriggerEvaluate(st__Convert_R2S)
 return f__result_string
endfunction

//Generated allocator of Convert
function s__Convert__allocate takes nothing returns integer
 local integer this=si__Convert_F
    if (this!=0) then
        set si__Convert_F=si__Convert_V[this]
    else
        set si__Convert_I=si__Convert_I+1
        set this=si__Convert_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__Convert_V[this]=-1
 return this
endfunction

//Generated destructor of Convert
function s__Convert_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__Convert_V[this]!=-1) then
        return
    endif
    set si__Convert_V[this]=si__Convert_F
    set si__Convert_F=this
endfunction

//Generated method caller for StringUtil.IndexOf
function sc__StringUtil_IndexOf takes string str,string sub returns integer
    set f__arg_string1=str
    set f__arg_string2=sub
    call TriggerEvaluate(st__StringUtil_IndexOf)
 return f__result_integer
endfunction

//Generated method caller for StringUtil.CharAt
function sc__StringUtil_CharAt takes string str,integer index returns string
    set f__arg_string1=str
    set f__arg_integer1=index
    call TriggerEvaluate(st__StringUtil_CharAt)
 return f__result_string
endfunction

//Generated method caller for StringUtil.SubString
function sc__StringUtil_SubString takes string str,integer begin,integer length returns string
    set f__arg_string1=str
    set f__arg_integer1=begin
    set f__arg_integer2=length
    call TriggerEvaluate(st__StringUtil_SubString)
 return f__result_string
endfunction

//Generated allocator of StringUtil
function s__StringUtil__allocate takes nothing returns integer
 local integer this=si__StringUtil_F
    if (this!=0) then
        set si__StringUtil_F=si__StringUtil_V[this]
    else
        set si__StringUtil_I=si__StringUtil_I+1
        set this=si__StringUtil_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__StringUtil_V[this]=-1
 return this
endfunction

//Generated destructor of StringUtil
function s__StringUtil_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__StringUtil_V[this]!=-1) then
        return
    endif
    set si__StringUtil_V[this]=si__StringUtil_F
    set si__StringUtil_F=this
endfunction

//Generated method caller for Math.GetRandomReal
function sc__Math_GetRandomReal takes real low,real high returns real
    set f__arg_real1=low
    set f__arg_real2=high
    call TriggerEvaluate(st__Math_GetRandomReal)
 return f__result_real
endfunction

//Generated method caller for Math.Cos
function sc__Math_Cos takes real r returns real
    set f__arg_real1=r
    call TriggerEvaluate(st__Math_Cos)
 return f__result_real
endfunction

//Generated method caller for Math.Atan2
function sc__Math_Atan2 takes real y,real x returns real
    set f__arg_real1=y
    set f__arg_real2=x
    call TriggerEvaluate(st__Math_Atan2)
 return f__result_real
endfunction

//Generated method caller for Math.Power
function sc__Math_Power takes real a,real power returns real
            return Pow(a, power)
endfunction

//Generated method caller for Math.Exp
function sc__Math_Exp takes real power returns real
            return Pow(s__Math_E, power)
endfunction

//Generated method caller for Math.Modulo
function sc__Math_Modulo takes real dividend,real divisor returns real
    set f__arg_real1=dividend
    set f__arg_real2=divisor
    call TriggerEvaluate(st__Math_Modulo)
 return f__result_real
endfunction

//Generated method caller for Math.Ln
function sc__Math_Ln takes real r returns real
    set f__arg_real1=r
    call TriggerEvaluate(st__Math_Ln)
 return f__result_real
endfunction

//Generated allocator of Math
function s__Math__allocate takes nothing returns integer
 local integer this=si__Math_F
    if (this!=0) then
        set si__Math_F=si__Math_V[this]
    else
        set si__Math_I=si__Math_I+1
        set this=si__Math_I
    endif
    if (this>8190) then
        return 0
    endif

    set si__Math_V[this]=-1
 return this
endfunction

//Generated destructor of Math
function s__Math_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__Math_V[this]!=-1) then
        return
    endif
    set si__Math_V[this]=si__Math_F
    set si__Math_F=this
endfunction
function sc___prototype6_execute takes integer i returns nothing

    call TriggerExecute(st___prototype6[i])
endfunction
function sc___prototype6_evaluate takes integer i returns nothing

    call TriggerEvaluate(st___prototype6[i])

endfunction

//library BzAPI:
//hardware




























//plus











//sync






//native DzGetPushContext takes nothing returns string

//gui













































































//显示/隐藏SimpleFrame
//native DzSimpleFrameShow takes integer frame, boolean enable returns nothing
// 追加文字（支持TextArea）

// 沉默单位-禁用技能

// 禁用攻击

// 禁用道具

// 刷新小地图

// 修改单位alpha

// 设置单位是否可以选中

// 修改单位是否可以被设置为目标

// 保存内存数据

// 读取内存数据

// 设置加速倍率

// 转换世界坐标为屏幕坐标-异步

// 转换世界坐标为屏幕坐标-获取转换后的X坐标

// 转换世界坐标为屏幕坐标-获取转换后的Y坐标

// 创建command button

function DzTriggerRegisterMouseEventTrg takes trigger trg,integer status,integer btn returns nothing
if trg == null then
return
endif
call DzTriggerRegisterMouseEvent(trg, btn, status, true, null)
endfunction
function DzTriggerRegisterKeyEventTrg takes trigger trg,integer status,integer btn returns nothing
if trg == null then
return
endif
call DzTriggerRegisterKeyEvent(trg, btn, status, true, null)
endfunction
function DzTriggerRegisterMouseMoveEventTrg takes trigger trg returns nothing
if trg == null then
return
endif
call DzTriggerRegisterMouseMoveEvent(trg, true, null)
endfunction
function DzTriggerRegisterMouseWheelEventTrg takes trigger trg returns nothing
if trg == null then
return
endif
call DzTriggerRegisterMouseWheelEvent(trg, true, null)
endfunction
function DzTriggerRegisterWindowResizeEventTrg takes trigger trg returns nothing
if trg == null then
return
endif
call DzTriggerRegisterWindowResizeEvent(trg, true, null)
endfunction
function DzF2I takes integer i returns integer
return i
endfunction
function DzI2F takes integer i returns integer
return i
endfunction
function DzK2I takes integer i returns integer
return i
endfunction
function DzI2K takes integer i returns integer
return i
endfunction
function DzTriggerRegisterMallItemSyncData takes trigger trig returns nothing
call DzTriggerRegisterSyncData(trig, "DZMIA", true)
endfunction
function DzGetTriggerMallItemPlayer takes nothing returns player
return DzGetTriggerSyncPlayer()
endfunction
function DzGetTriggerMallItem takes nothing returns string
return DzGetTriggerSyncData()
endfunction

//library BzAPI ends
//library CyaCameraSystem:
function Cya_CameraSetEQNoiseForPlayer_Timer takes nothing returns nothing
local player p= LoadPlayerHandle(YDHT, GetHandleId(GetExpiredTimer()), 0xA59BB4C6)
call FlushChildHashtable(YDHT, GetHandleId(GetExpiredTimer()))
call CameraClearNoiseForPlayer(p)
call DestroyTimer(GetExpiredTimer())
endfunction
function Cya_CameraSetEQNoiseForPlayer takes player p,real r,real time returns nothing
local timer t= CreateTimer()
call SavePlayerHandle(YDHT, GetHandleId(t), 0xA59BB4C6, p)
call CameraSetEQNoiseForPlayer(p, r)
call TimerStart(t, time, false, function Cya_CameraSetEQNoiseForPlayer_Timer)
set t=null
endfunction

//library CyaCameraSystem ends
//library IrAttackType:
function Ir_GetUnitAttackType takes unit u returns integer
return R2I(GetUnitState(u, ConvertUnitState(0x23)))
endfunction
function Ir_SetUnitAttackType takes unit u,integer atp returns nothing
call SetUnitState(u, ConvertUnitState(0x23), atp)
endfunction

//library IrAttackType ends
//library MNEVENT:
//===========================================================================
//任意单位伤害事件
//===========================================================================
function MNEVENT___UnitDeathconditions takes nothing returns boolean
return ( IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) != true )
endfunction
function MNEVENT___UnitDeathAction takes nothing returns nothing
call GroupRemoveUnit(MNEVENT___UnitGroup, GetTriggerUnit())
//call RemoveUnit(GetTriggerUnit())
endfunction
function MNEVENT___enumunitdamaged takes nothing returns nothing
call TriggerRegisterUnitEvent(MNEVENT___MNDamageEventTrigger, GetEnumUnit(), EVENT_UNIT_DAMAGED)
endfunction
function MNEVENT___MNAnyUnitDamagedAction takes nothing returns nothing
local integer i= 0
loop
exitwhen i >= MNEVENT___DamageEventNumber
if MNEVENT___DamageEventQueue[i] != null and IsTriggerEnabled(MNEVENT___DamageEventQueue[i]) and TriggerEvaluate(MNEVENT___DamageEventQueue[i]) then
call TriggerExecute(MNEVENT___DamageEventQueue[i]) //如果触发不为空,触发开启,则运行触发器i
endif
set i=i + 1
endloop
endfunction
function MNEVENT___MNAnyUnitDamagedFilter takes nothing returns boolean
if GetUnitAbilityLevel(GetFilterUnit(), 'Aloc') <= 0 then
//单位组加入该单位
call GroupAddUnit(MNEVENT___UnitGroup, GetFilterUnit())
call TriggerRegisterUnitEvent(MNEVENT___MNDamageEventTrigger, GetFilterUnit(), EVENT_UNIT_DAMAGED)
//注册指定单位接受伤害事件
endif
return false
endfunction
function MNEVENT___MNAnyUnitDamagedEnumUnit takes nothing returns nothing
local trigger t= CreateTrigger()
local region r= CreateRegion()
local group g= CreateGroup()
local trigger trideath= CreateTrigger()
call RegionAddRect(r, GetWorldBounds())
call TriggerRegisterEnterRegion(t, r, Condition(function MNEVENT___MNAnyUnitDamagedFilter))
//非蝗虫单位进入区域 注册指定单位接受伤害事件
call GroupEnumUnitsInRect(g, GetWorldBounds(), Condition(function MNEVENT___MNAnyUnitDamagedFilter))
//选取可用地图上现存的非蝗虫单位 注册指定单位接受伤害事件
//注册单位死亡事件
call TriggerRegisterAnyUnitEventBJ(trideath, EVENT_PLAYER_UNIT_DEATH)
call TriggerAddCondition(trideath, Condition(function MNEVENT___UnitDeathconditions))
call TriggerAddAction(trideath, function MNEVENT___UnitDeathAction)
call DestroyGroup(g)
set r=null
set t=null
set g=null
endfunction
function MNEVENT___timeout takes nothing returns nothing
call TriggerRemoveAction(MNEVENT___MNDamageEventTrigger, MNEVENT___ta) //删除触发器动作
call DestroyTrigger(MNEVENT___MNDamageEventTrigger)
set MNEVENT___MNDamageEventTrigger=CreateTrigger()
set MNEVENT___ta=TriggerAddAction(MNEVENT___MNDamageEventTrigger, function MNEVENT___MNAnyUnitDamagedAction)
call ForGroupBJ(MNEVENT___UnitGroup, function MNEVENT___enumunitdamaged)
endfunction
function MNAnyUnitDamaged takes trigger trg,real miao returns nothing
if trg == null then
return
endif
if MNEVENT___DamageEventNumber == 0 then
set MNEVENT___MNDamageEventTrigger=CreateTrigger()
set MNEVENT___ta=TriggerAddAction(MNEVENT___MNDamageEventTrigger, function MNEVENT___MNAnyUnitDamagedAction)
call MNEVENT___MNAnyUnitDamagedEnumUnit()
call TimerStart(MNEVENT___time, miao, true, function MNEVENT___timeout)
endif
set MNEVENT___DamageEventQueue[MNEVENT___DamageEventNumber]=trg
set MNEVENT___DamageEventNumber=MNEVENT___DamageEventNumber + 1
endfunction

//library MNEVENT ends
//library MNXT:

//library MNXT ends
//library SLDebugLib:
    function SLDebugLib__luainit takes nothing returns nothing
    //call BJDebugMsg("init lua main")
    call Cheat("exec-lua:Luamain")
    //call BJDebugMsg("init lua main")
    //call EXExecuteScript("(require'StarTest')")
    endfunction

//library SLDebugLib ends
//library SLInteger:

    //private:
    //public:
    function SLInteger_GetEnumInteger takes nothing returns integer
        return SLInteger_CallbackInteger
    endfunction
    function SGetEnumInteger takes nothing returns integer
        return (SLInteger_CallbackInteger) // INLINED!!
    endfunction  //init list
    function SLInteger__SLInteger_InitList takes integer id returns nothing
        call SaveInteger(SLInteger__HT, id, SLInteger__K_Count, 0)
    endfunction  //new list
    function SLInteger_CreateIntegerList takes nothing returns integer
        local integer id
        set SLInteger__IntegerLists=SLInteger__IntegerLists + 1
        set id=SLInteger__IntegerLists - 1
        call SaveInteger(SLInteger__HT, (id), SLInteger__K_Count, 0) // INLINED!!
        return id
    endfunction
    function SCreateListInteger takes nothing returns integer
        return SLInteger_CreateIntegerList()
    endfunction  //List.Destroy
    function SLInteger_RemoveList takes integer id returns nothing
        call FlushChildHashtable(SLInteger__HT, id)
    endfunction
    function SRemoveListInteger takes integer id returns nothing
        call FlushChildHashtable(SLInteger__HT, (id)) // INLINED!!
    endfunction  //List.Clear
    function SLInteger_ClearList takes integer id returns nothing
        call SaveInteger(SLInteger__HT, id, SLInteger__K_Count, 0)
        call SaveInteger(SLInteger__HT, id, 0, 0)
    endfunction
    function SClearListInteger takes integer id returns nothing
        call SLInteger_ClearList(id)
    endfunction  //ForeachList
    function SLInteger_ForList takes integer id,trigger t returns nothing
        local integer i
        local integer max
        set max=LoadInteger(SLInteger__HT, id, SLInteger__K_Count)
        set i=0
        set SLInteger_IsOnForGroup=true
        loop
        exitwhen ( i >= max )
            set SLInteger_CallbackInteger=LoadInteger(SLInteger__HT, id, i)
            if ( TriggerEvaluate(t) ) then
                call TriggerExecute(t)
            endif
            if ( SLInteger_RemovedWhenForGroup ) then
                set max=max - 1
                set i=i - 1
            endif
            set SLInteger_RemovedWhenForGroup=false
            set i=i + 1
        endloop
        set SLInteger_IsOnForGroup=false
        set SLInteger_CallbackInteger=0
    endfunction
    function SForListByCodeInteger takes integer id,string c returns nothing
        local integer i
        local integer max
        set max=LoadInteger(SLInteger__HT, id, SLInteger__K_Count)
        set i=0
        set SLInteger_IsOnForGroup=true
        loop
        exitwhen ( i >= max )
            set SLInteger_CallbackInteger=LoadInteger(SLInteger__HT, id, i)
            call ExecuteFunc(c)
            if ( SLInteger_RemovedWhenForGroup ) then
                set max=max - 1 //BJDebugMsg("max="+I2S(max)+"i="+I2S(i));
                set i=i - 1
            endif
            set SLInteger_RemovedWhenForGroup=false
            set i=i + 1
        endloop
        set SLInteger_IsOnForGroup=false
        set SLInteger_CallbackInteger=0
    endfunction
    function SForListInteger takes integer id,trigger t returns nothing
        call SLInteger_ForList(id , t)
    endfunction  //List.GetIndex
    function SLInteger_GetFirstOfList takes integer id returns integer
        return LoadInteger(SLInteger__HT, id, 0)
    endfunction
    function SFirstOfListInteger takes integer id returns integer
        return (LoadInteger(SLInteger__HT, (id), 0)) // INLINED!!
    endfunction  //List.XXXIsHave
    function SLInteger_IsIntegerOnList takes integer e,integer id returns integer
        local integer i
        local integer max
        set max=LoadInteger(SLInteger__HT, id, SLInteger__K_Count)
        set i=0
        loop
        exitwhen ( i >= max )
            if ( e == LoadInteger(SLInteger__HT, id, i) ) then
                return i
            endif
            set i=i + 1
        endloop
        return - 1
    endfunction  //List.IsHave
    function SLInteger_IsListHaveInteger takes integer e,integer id returns boolean
        return SLInteger_IsIntegerOnList(e , id) != - 1
    endfunction  //List.Remove
    function SLInteger_RemoveIntegerOfList takes integer e,integer id returns boolean
        local integer i
        local integer max
        set max=LoadInteger(SLInteger__HT, id, SLInteger__K_Count) - 1
        if ( max < 0 ) then
            return false
        endif
        set i=SLInteger_IsIntegerOnList(e , id)
        if ( i != - 1 ) then
            if ( i != max ) then
                call SaveInteger(SLInteger__HT, id, i, LoadInteger(SLInteger__HT, id, max))
            else
                call RemoveSavedInteger(SLInteger__HT, id, i)
            endif
            set max=max - 1
            call SaveInteger(SLInteger__HT, id, SLInteger__K_Count, max + 1)
            if ( SLInteger_IsOnForGroup ) then
                set SLInteger_RemovedWhenForGroup=true
            endif
            return true
        endif
        return false
    endfunction  //List.RemoveAt 移除在List<id>中位于i位置的对象
    function SLInteger_RemoveAtIntegerOfList takes integer i,integer id returns boolean
        local integer max
        set max=LoadInteger(SLInteger__HT, id, SLInteger__K_Count) - 1 //3 2
        if ( max < 0 ) then
            return false
        endif
        if ( i != max ) then
            call SaveInteger(SLInteger__HT, id, i, LoadInteger(SLInteger__HT, id, max))
        else
            call RemoveSavedInteger(SLInteger__HT, id, i)
        endif //1
        set max=max - 1 //2
        call SaveInteger(SLInteger__HT, id, SLInteger__K_Count, max + 1)
        if ( SLInteger_IsOnForGroup ) then
            set SLInteger_RemovedWhenForGroup=true
        endif
        return true
    endfunction
    function SRemoveInteger takes integer e,integer id returns boolean
        return SLInteger_RemoveIntegerOfList(e , id)
    endfunction  //List.Add
    function SLInteger_ListAddInteger takes integer e,integer id returns boolean
        local integer i
        local integer max
        set max=LoadInteger(SLInteger__HT, id, SLInteger__K_Count)
        set i=SLInteger_IsIntegerOnList(e , id)
        if ( i == - 1 ) then
            call SaveInteger(SLInteger__HT, id, max, e)
            set max=max + 1
            call SaveInteger(SLInteger__HT, id, SLInteger__K_Count, max)
            return true
        endif
        return false
    endfunction
    function SAddInteger takes integer e,integer id returns boolean
        return SLInteger_ListAddInteger(e , id)
    endfunction  //List.IsEmpty
    function SLInteger_IsListEmpty takes integer id returns boolean
        if ( LoadInteger(SLInteger__HT, id, SLInteger__K_Count) != 0 ) then
            return false
        endif
        return true
    endfunction  //List.getCount
    function SLInteger_GetCount takes integer id returns integer
        return LoadInteger(SLInteger__HT, id, SLInteger__K_Count)
    endfunction
    function SGetCountInteger takes integer id returns integer
        return (LoadInteger(SLInteger__HT, (id), SLInteger__K_Count)) // INLINED!!
    endfunction  //整数转List
    function I2SLInteger takes integer id returns integer
        return id
    endfunction  //List转整数
    function SLInteger2I takes integer SLInteger returns integer
        return SLInteger
    endfunction  //获取成员组的总表
    function SLInteger_GetTable takes nothing returns hashtable
        return SLInteger__HT
    endfunction
    function SLInteger__onInit takes nothing returns nothing
    endfunction

//library SLInteger ends
//library SLReal:

    //private:
    //public:
    function SLReal_GetEnumReal takes nothing returns real
        return SLReal_CallbackReal
    endfunction
    function SGetEnumReal takes nothing returns real
        return (SLReal_CallbackReal) // INLINED!!
    endfunction  //init list
    function SLReal__SLReal_InitList takes integer id returns nothing
        call SaveInteger(SLReal__HT, id, SLReal__K_Count, 0)
    endfunction  //new list
    function SLReal_CreateRealList takes nothing returns integer
        local integer id
        set SLReal__RealLists=SLReal__RealLists + 1
        set id=SLReal__RealLists - 1
        call SaveInteger(SLReal__HT, (id), SLReal__K_Count, 0) // INLINED!!
        return id
    endfunction
    function SCreateListReal takes nothing returns integer
        return SLReal_CreateRealList()
    endfunction  //List.Destroy
    function SLReal_RemoveList takes integer id returns nothing
        call FlushChildHashtable(SLReal__HT, id)
    endfunction
    function SRemoveListReal takes integer id returns nothing
        call FlushChildHashtable(SLReal__HT, (id)) // INLINED!!
    endfunction  //List.Clear
    function SLReal_ClearList takes integer id returns nothing
        call SaveInteger(SLReal__HT, id, SLReal__K_Count, 0)
        call SaveReal(SLReal__HT, id, 0, 0)
    endfunction
    function SClearListReal takes integer id returns nothing
        call SLReal_ClearList(id)
    endfunction  //ForeachList
    function SLReal_ForList takes integer id,trigger t returns nothing
        local integer i
        local integer max
        set max=LoadInteger(SLReal__HT, id, SLReal__K_Count)
        set i=0
        set SLReal_IsOnForGroup=true
        loop
        exitwhen ( i >= max )
            set SLReal_CallbackReal=LoadReal(SLReal__HT, id, i)
            if ( TriggerEvaluate(t) ) then
                call TriggerExecute(t)
            endif
            if ( SLReal_RemovedWhenForGroup ) then
                set max=max - 1
                set i=i - 1
            endif
            set SLReal_RemovedWhenForGroup=false
            set i=i + 1
        endloop
        set SLReal_IsOnForGroup=false
        set SLReal_CallbackReal=0
    endfunction
    function SForListByCodeReal takes integer id,string c returns nothing
        local integer i
        local integer max
        set max=LoadInteger(SLReal__HT, id, SLReal__K_Count)
        set i=0
        set SLReal_IsOnForGroup=true
        loop
        exitwhen ( i >= max )
            set SLReal_CallbackReal=LoadReal(SLReal__HT, id, i)
            call ExecuteFunc(c)
            if ( SLReal_RemovedWhenForGroup ) then
                set max=max - 1 //BJDebugMsg("max="+I2S(max)+"i="+I2S(i));
                set i=i - 1
            endif
            set SLReal_RemovedWhenForGroup=false
            set i=i + 1
        endloop
        set SLReal_IsOnForGroup=false
        set SLReal_CallbackReal=0
    endfunction
    function SForListReal takes integer id,trigger t returns nothing
        call SLReal_ForList(id , t)
    endfunction  //List.GetIndex
    function SLReal_GetFirstOfList takes integer id returns real
        return LoadReal(SLReal__HT, id, 0)
    endfunction
    function SFirstOfListReal takes integer id returns real
        return (LoadReal(SLReal__HT, (id), 0)) // INLINED!!
    endfunction  //List.XXXIsHave
    function SLReal_IsRealOnList takes real e,integer id returns integer
        local integer i
        local integer max
        set max=LoadInteger(SLReal__HT, id, SLReal__K_Count)
        set i=0
        loop
        exitwhen ( i >= max )
            if ( e == LoadReal(SLReal__HT, id, i) ) then
                return i
            endif
            set i=i + 1
        endloop
        return - 1
    endfunction  //List.IsHave
    function SLReal_IsListHaveReal takes real e,integer id returns boolean
        return SLReal_IsRealOnList(e , id) != - 1
    endfunction  //List.Remove
    function SLReal_RemoveRealOfList takes real e,integer id returns boolean
        local integer i
        local integer max
        set max=LoadInteger(SLReal__HT, id, SLReal__K_Count) - 1
        if ( max < 0 ) then
            return false
        endif
        set i=SLReal_IsRealOnList(e , id)
        if ( i != - 1 ) then
            if ( i != max ) then
                call SaveReal(SLReal__HT, id, i, LoadReal(SLReal__HT, id, max))
            else
                call RemoveSavedReal(SLReal__HT, id, i)
            endif
            set max=max - 1
            call SaveInteger(SLReal__HT, id, SLReal__K_Count, max + 1)
            if ( SLReal_IsOnForGroup ) then
                set SLReal_RemovedWhenForGroup=true
            endif
            return true
        endif
        return false
    endfunction  //List.RemoveAt 移除在List<id>中位于i位置的对象
    function SLReal_RemoveAtRealOfList takes integer i,integer id returns boolean
        local integer max
        set max=LoadInteger(SLReal__HT, id, SLReal__K_Count) - 1 //3 2
        if ( max < 0 ) then
            return false
        endif
        if ( i != max ) then
            call SaveReal(SLReal__HT, id, i, LoadReal(SLReal__HT, id, max))
        else
            call RemoveSavedReal(SLReal__HT, id, i)
        endif //1
        set max=max - 1 //2
        call SaveInteger(SLReal__HT, id, SLReal__K_Count, max + 1)
        if ( SLReal_IsOnForGroup ) then
            set SLReal_RemovedWhenForGroup=true
        endif
        return true
    endfunction
    function SRemoveReal takes real e,integer id returns boolean
        return SLReal_RemoveRealOfList(e , id)
    endfunction  //List.Add
    function SLReal_ListAddReal takes real e,integer id returns boolean
        local integer i
        local integer max
        set max=LoadInteger(SLReal__HT, id, SLReal__K_Count)
        set i=SLReal_IsRealOnList(e , id)
        if ( i == - 1 ) then
            call SaveReal(SLReal__HT, id, max, e)
            set max=max + 1
            call SaveInteger(SLReal__HT, id, SLReal__K_Count, max)
            return true
        endif
        return false
    endfunction
    function SAddReal takes real e,integer id returns boolean
        return SLReal_ListAddReal(e , id)
    endfunction  //List.IsEmpty
    function SLReal_IsListEmpty takes integer id returns boolean
        if ( LoadInteger(SLReal__HT, id, SLReal__K_Count) != 0 ) then
            return false
        endif
        return true
    endfunction  //List.getCount
    function SLReal_GetCount takes integer id returns integer
        return LoadInteger(SLReal__HT, id, SLReal__K_Count)
    endfunction
    function SGetCountReal takes integer id returns integer
        return (LoadInteger(SLReal__HT, (id), SLReal__K_Count)) // INLINED!!
    endfunction  //整数转List
    function I2SLReal takes integer id returns integer
        return id
    endfunction  //List转整数
    function SLReal2I takes integer SLReal returns integer
        return SLReal
    endfunction  //获取成员组的总表
    function SLReal_GetTable takes nothing returns hashtable
        return SLReal__HT
    endfunction
    function SLReal__onInit takes nothing returns nothing
    endfunction

//library SLReal ends
//library SLStr:

    //private:
    //public:
    function SLStr_GetEnumStr takes nothing returns string
        return SLStr_CallbackStr
    endfunction
    function SGetEnumStr takes nothing returns string
        return (SLStr_CallbackStr) // INLINED!!
    endfunction  //init list
    function SLStr__SLStr_InitList takes integer id returns nothing
        call SaveInteger(SLStr__HT, id, SLStr__K_Count, 0)
    endfunction  //new list
    function SLStr_CreateStrList takes nothing returns integer
        local integer id
        set SLStr__StrLists=SLStr__StrLists + 1
        set id=SLStr__StrLists - 1
        call SaveInteger(SLStr__HT, (id), SLStr__K_Count, 0) // INLINED!!
        return id
    endfunction
    function SCreateListStr takes nothing returns integer
        return SLStr_CreateStrList()
    endfunction  //List.Destroy
    function SLStr_RemoveList takes integer id returns nothing
        call FlushChildHashtable(SLStr__HT, id)
    endfunction
    function SRemoveListStr takes integer id returns nothing
        call FlushChildHashtable(SLStr__HT, (id)) // INLINED!!
    endfunction  //List.Clear
    function SLStr_ClearList takes integer id returns nothing
        call SaveInteger(SLStr__HT, id, SLStr__K_Count, 0)
        call SaveStr(SLStr__HT, id, 0, null)
    endfunction
    function SClearListStr takes integer id returns nothing
        call SLStr_ClearList(id)
    endfunction  //ForeachList
    function SLStr_ForList takes integer id,trigger t returns nothing
        local integer i
        local integer max
        set max=LoadInteger(SLStr__HT, id, SLStr__K_Count)
        set i=0
        loop
        exitwhen ( i >= max )
            set SLStr_CallbackStr=LoadStr(SLStr__HT, id, i)
            if ( TriggerEvaluate(t) ) then
                call TriggerExecute(t)
            endif
            set i=i + 1
        endloop
        set SLStr_CallbackStr=null
    endfunction
    function SForListByCodeStr takes integer id,string c returns nothing
        local integer i
        local integer max
        set max=LoadInteger(SLStr__HT, id, SLStr__K_Count)
        set i=0
        loop
        exitwhen ( i >= max )
            set SLStr_CallbackStr=LoadStr(SLStr__HT, id, i)
            call ExecuteFunc(c)
            set i=i + 1
        endloop
        set SLStr_CallbackStr=null
    endfunction
    function SForListStr takes integer id,trigger t returns nothing
        call SLStr_ForList(id , t)
    endfunction  //List.GetIndex
    function SLStr_GetFirstOfList takes integer id returns string
        return LoadStr(SLStr__HT, id, 0)
    endfunction
    function SFirstOfListStr takes integer id returns string
        return (LoadStr(SLStr__HT, (id), 0)) // INLINED!!
    endfunction  //List.XXXIsHave
    function SLStr_IsStrOnList takes string e,integer id returns integer
        local integer i
        local integer max
        set max=LoadInteger(SLStr__HT, id, SLStr__K_Count)
        set i=0
        loop
        exitwhen ( i >= max )
            if ( e == LoadStr(SLStr__HT, id, i) ) then
                return i
            endif
            set i=i + 1
        endloop
        return - 1
    endfunction  //List.IsHave
    function SLStr_IsListHaveStr takes string e,integer id returns boolean
        return SLStr_IsStrOnList(e , id) != - 1
    endfunction  //List.Remove
    function SLStr_RemoveStrOfList takes string e,integer id returns boolean
        local integer i
        local integer max
        set max=LoadInteger(SLStr__HT, id, SLStr__K_Count) - 1
        if ( max < 0 ) then
            return false
        endif
        set i=SLStr_IsStrOnList(e , id)
        if ( i != - 1 ) then
            if ( i != max ) then
                call SaveStr(SLStr__HT, id, i, LoadStr(SLStr__HT, id, max))
            else
                call SaveStr(SLStr__HT, id, i, null)
            endif
            set max=max - 1
            call SaveInteger(SLStr__HT, id, SLStr__K_Count, max + 1)
            return true
        endif
        return false
    endfunction
    function SRemoveStr takes string e,integer id returns boolean
        return SLStr_RemoveStrOfList(e , id)
    endfunction  //List.Add
    function SLStr_ListAddStr takes string e,integer id returns boolean
        local integer i
        local integer max
        set max=LoadInteger(SLStr__HT, id, SLStr__K_Count)
        set i=SLStr_IsStrOnList(e , id)
        if ( i == - 1 ) then
            call SaveStr(SLStr__HT, id, max, e)
            set max=max + 1
            call SaveInteger(SLStr__HT, id, SLStr__K_Count, max)
            return true
        endif
        return false
    endfunction
    function SAddStr takes string e,integer id returns boolean
        return SLStr_ListAddStr(e , id)
    endfunction  //List.IsEmpty
    function SLStr_IsListEmpty takes integer id returns boolean
        if ( LoadInteger(SLStr__HT, id, SLStr__K_Count) != 0 ) then
            return false
        endif
        return true
    endfunction  //List.getCount
    function SLStr_GetCount takes integer id returns integer
        return LoadInteger(SLStr__HT, id, SLStr__K_Count)
    endfunction
    function SGetCountStr takes integer id returns integer
        return (LoadInteger(SLStr__HT, (id), SLStr__K_Count)) // INLINED!!
    endfunction  //整数转List
    function I2SLStr takes integer id returns integer
        return id
    endfunction  //List转整数
    function SLStr2I takes integer SLStr returns integer
        return SLStr
    endfunction  //获取成员组的总表
    function SLStr_GetTable takes nothing returns hashtable
        return SLStr__HT
    endfunction
    function SLStr__onInit takes nothing returns nothing
    endfunction

//library SLStr ends
//library StarCommon:
    //public:
//processed :        type StringArray extends string array [16]
//processed:         function interface Action takes integer arg0 returns nothing
//processed:         function interface Func takes integer arg0 returns integer
//processed:         function interface Handler takes integer arg0, integer arg1 returns nothing
//processed:         function interface Sorter takes integer arg0, integer arg1 returns boolean
        function PrintForPlayer takes string text,player p returns nothing
            call DisplayTimedTextToPlayer(p, 0, 0, 15, text)
        endfunction
        function Print takes string text returns nothing
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, text)
        endfunction
        function printi takes integer i returns nothing
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, I2S(i))
        endfunction
        function printr takes real r returns nothing
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, R2S(r))
        endfunction
        function printsi takes string s,integer i returns nothing
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, s + I2S(i))
        endfunction
        function printsr takes string s,real i returns nothing
            call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, s + R2S(i))
        endfunction
        function printb takes string s,boolean b returns nothing
            if ( b ) then
                call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, s + "真")
            else
                call DisplayTimedTextToPlayer(GetLocalPlayer(), 0, 0, 60, s + "假")
            endif
        endfunction
    //private:
        function StarCommon__getRandomInt takes integer low,integer high returns integer
            return GetRandomInt(low, high)
        endfunction
        function StarCommon__getRandomReal takes real low,real high returns real
            return GetRandomReal(low, high)
        endfunction
        function StarCommon__sin takes real r returns real
            return Sin(r)
        endfunction
        function StarCommon__cos takes real r returns real
            return Cos(r)
        endfunction
        function StarCommon__tan takes real r returns real
            return Tan(r)
        endfunction
        function StarCommon__asin takes real r returns real
            return Asin(r)
        endfunction
        function StarCommon__acos takes real r returns real
            return Acos(r)
        endfunction
        function StarCommon__atan takes real r returns real
            return Atan(r)
        endfunction
        function StarCommon__atan2 takes real y,real x returns real
            return Atan2(y, x)
        endfunction
        function s__Math__get_Random takes nothing returns real
            return sc__Math_GetRandomReal(0.0 , 1.0)
        endfunction
        function s__Math_GetRandomReal takes real low,real high returns real
            return (GetRandomReal(((low )*1.0), (( high)*1.0))) // INLINED!!
        endfunction
        function s__Math_GetRandomInt takes integer low,integer high returns integer
            return (GetRandomInt((low ), ( high))) // INLINED!!
        endfunction
        function s__Math_Sign takes real r returns real
            if ( r < 0 ) then
                return - 1.0
            endif
            if ( r > 0 ) then
                return 1.0
            endif
            return 0.0
        endfunction
        function s__Math_ISign takes integer r returns integer
            if ( r < 0 ) then
                return - 1
            endif
            if ( r > 0 ) then
                return 1
            endif
            return 0
        endfunction
        function s__Math_Abs takes real r returns real
            if ( r < 0 ) then
                return - r
            endif
            return r
        endfunction
        function s__Math_Min takes real a,real b returns real
            if ( a > b ) then
                return b
            endif
            return a
        endfunction
        function s__Math_Max takes real a,real b returns real
            if ( a < b ) then
                return b
            endif
            return a
        endfunction
        function s__Math_Clamp takes real value,real low,real high returns real
            local real temp=high
            if ( low > high ) then
                set high=low
                set low=temp
            endif
            return s__Math_Min(s__Math_Max(value , low) , high)
        endfunction  //end of: Common_Math_Template ("real", "")
        function s__Math_IAbs takes integer r returns integer
            if ( r < 0 ) then
                return - r
            endif
            return r
        endfunction
        function s__Math_IMin takes integer a,integer b returns integer
            if ( a > b ) then
                return b
            endif
            return a
        endfunction
        function s__Math_IMax takes integer a,integer b returns integer
            if ( a < b ) then
                return b
            endif
            return a
        endfunction
        function s__Math_IClamp takes integer value,integer low,integer high returns integer
            local integer temp=high
            if ( low > high ) then
                set high=low
                set low=temp
            endif
            return s__Math_IMin(s__Math_IMax(value , low) , high)
        endfunction  //end of: Common_Math_Template ("integer", "I")
        function s__Math_Equals takes real a,real b,real tolerance returns boolean
            return a + tolerance >= b and a - tolerance <= b
        endfunction
        function s__Math_IsZero takes real r returns boolean
            return r >= - s__Math_Tolerance and r <= s__Math_Tolerance
        endfunction
        function s__Math_ToRadians takes real degrees returns real
            return degrees / 180.0 * s__Math_PI
        endfunction
        function s__Math_ToDegrees takes real radians returns real
            return radians * 180.0 / s__Math_PI
        endfunction
        function s__Math_GetRandomRealEx takes real min,real max returns real
            local real r
            if ( (GetRandomInt(((1 ) ), ( ( 100)))) < 50 ) then // INLINED!!
                set r=(GetRandomReal(((((min )*1.0) )*1.0), (( (( max)*1.0))*1.0))) // INLINED!!
            else
                set r=(GetRandomReal(((((min )*1.0) )*1.0), (( (( max)*1.0))*1.0))) * - 1 // INLINED!!
            endif
            return r
        endfunction  //坐标间距离
        function s__Math_GDBC takes real x1,real y1,real x2,real y2 returns real
            return SquareRoot(( y1 - y2 ) * ( y1 - y2 ) + ( x1 - x2 ) * ( x1 - x2 ))
        endfunction
        function s__Math_GetDistanceOfXY takes real x1,real y1,real x2,real y2 returns real
            return SquareRoot(( y1 - y2 ) * ( y1 - y2 ) + ( x1 - x2 ) * ( x1 - x2 ))
        endfunction  //两坐标相距距离少于r
        function s__Math_LocInRange takes real x1,real y1,real x2,real y2,real r returns boolean
            return ( ( y1 - y2 ) * ( y1 - y2 ) + ( x1 - x2 ) * ( x1 - x2 ) ) < ( r * r )
        endfunction  //两坐标相距距离少于r 省略乘法
        function s__Math_LocInRange2 takes real x1,real y1,real x2,real y2,real r returns boolean
            return ( ( y1 - y2 ) * ( y1 - y2 ) + ( x1 - x2 ) * ( x1 - x2 ) ) < r
        endfunction  ///坐标间角度
        function s__Math_GAFC takes real x1,real y1,real x2,real y2 returns real
            return Rad2Deg(sc__Math_Atan2(y2 - y1 , x2 - x1))
        endfunction  //单位间角度
        function s__Math_getAngleBetweenUnits takes unit u,unit tu returns real
            return s__Math_GAFC(GetUnitX(u) , GetUnitY(u) , GetUnitX(tu) , GetUnitY(tu))
        endfunction  //两点间角度
        function s__Math_Bessel2 takes real t,real mid,real st,real tt returns real
            return ( t * t * tt + 2 * t * ( 1 - t ) * mid + ( 1 - t ) * ( 1 - t ) * st )
        endfunction  //贝塞尔 二阶 通用 t 起点 终点 中点
        function s__Math_Bessel2_2 takes real t,real a,real b,real c returns real
            return a * ( 1 - t ) * ( 1 - t ) + c * 2 * ( 1 - t ) * t + b * t * t
        endfunction  //贝塞尔 二阶 通用 t 起点 中点 终点 
        function s__Math_Bessel2_3 takes real t,real a,real c,real b returns real
            return a * ( 1 - t ) * ( 1 - t ) + c * 2 * ( 1 - t ) * t + b * t * t
        endfunction  //计算俯仰轴
        function s__Math_CalcRotateY takes real a,real b,real c,real x,real y,real z returns real
            return Atan2BJ(c - z, s__Math_GDBC(a , b , x , y))
        endfunction  //抛物线 t 最大高度 基础高度偏移
        function s__Math_Parabola takes real t,real Max,real base returns real
            return ( - ( 2 * ( t ) - 1 ) * ( 2 * ( t ) - 1 ) + 1 ) * Max + base
        endfunction  //角度处理(any)->[0,360] ------- 在角度差较大的情况下也许可以直接用模运算
        function s__Math_AngleConversion takes real a returns real
            loop
            exitwhen ( ( a >= 0 and a <= 360 ) )
                if ( a >= 360 ) then
                    set a=a - 360
                else
                    set a=a + 360
                endif
            endloop
            return a
        endfunction  //角度处理(-360~720)->[0,360]
        function s__Math_AngleConversion2 takes real a returns real
            if ( a >= 360 ) then
                set a=a - 360
            else
                set a=a + 360
            endif
            return a
        endfunction  //平滑追踪角度公式 (起点x,y 终点dx,dy)
        function s__Math_GetTrackAngle takes real x,real y,real dx,real dy returns real
            return bj_RADTODEG * sc__Math_Atan2(dy - y , dx - x)
        endfunction  //平滑从a到b 使用t
        function s__Math_SmoothZ2Z takes real t,real a,real b returns real
            return a * ( 1 - t ) + b * t
        endfunction
        function s__Math_GetRotationAngle takes real d,real d1,real d2 returns real
            local real d3=s__Math_AngleConversion(d1 - d)
            if ( sc__Math_Cos(d3) * bj_RADTODEG > sc__Math_Cos(d2) * bj_RADTODEG ) then
                set d=d1
            elseif ( d3 <= 180 ) then
                set d=d + d3
            else
                set d=d - d3
            endif
            return d
        endfunction  //移动X坐标 方向 距离
        function s__Math_MoveX takes real x,real d,real dis returns real
            return x + CosBJ(d) * dis
        endfunction  //移动Y坐标 方向 距离
        function s__Math_MoveY takes real y,real d,real dis returns real
            return y + SinBJ(d) * dis
        endfunction  //抛物线--跳跃--参数
        function s__Math_GetJumpHeight takes integer steeps,real steepsMax,real heightMax,real fly returns real
            local real dheig=1.0 / steepsMax
            return ( - ( 2 * I2R(steeps) * dheig - 1 ) * ( 2 * I2R(steeps) * dheig - 1 ) + 1 ) * heightMax + fly
        endfunction
        function s__Math_Sin takes real r returns real
            return (Sin(((r)*1.0))) // INLINED!!
        endfunction
        function s__Math_Cos takes real r returns real
            return (Cos(((r)*1.0))) // INLINED!!
        endfunction
        function s__Math_Tan takes real r returns real
            return (Tan(((r)*1.0))) // INLINED!!
        endfunction
        function s__Math_Asin takes real r returns real
            return (Asin(((r)*1.0))) // INLINED!!
        endfunction
        function s__Math_Acos takes real r returns real
            return (Acos(((r)*1.0))) // INLINED!!
        endfunction
        function s__Math_Atan takes real r returns real
            return (Atan(((r)*1.0))) // INLINED!!
        endfunction
        function s__Math_Atan2 takes real y,real x returns real
            return (Atan2(((y )*1.0), (( x)*1.0))) // INLINED!!
        endfunction
        function s__Math_Sinh takes real y returns real
            return ( (Pow(s__Math_E, ((y)*1.0))) - (Pow(s__Math_E, ((- y)*1.0))) ) / 2.0 // INLINED!!
        endfunction
        function s__Math_Cosh takes real x returns real
            return ( (Pow(s__Math_E, ((x)*1.0))) + (Pow(s__Math_E, ((- x)*1.0))) ) / 2.0 // INLINED!!
        endfunction
        function s__Math_Tanh takes real r returns real
            return ( (Pow(s__Math_E, ((r)*1.0))) - (Pow(s__Math_E, ((- r)*1.0))) ) / ( (Pow(s__Math_E, ((r)*1.0))) + (Pow(s__Math_E, ((- r)*1.0))) ) // INLINED!!
        endfunction
        function s__Math_Ceil takes real r returns real
            local real i=I2R(R2I(r))
            if ( sc__Math_Modulo(r , 1.0) > 0.0 ) then
                return i + 1.0
            endif
            return i
        endfunction
        function s__Math_Floor takes real r returns real
            return I2R(R2I(r))
        endfunction
        function s__Math_Round takes real r returns real
            local real i=I2R(R2I(r))
            if ( sc__Math_Modulo(r , 1.0) >= 0.5 ) then
                return i + 1.0
            endif
            return i
        endfunction
        function s__Math_Sqr takes real r returns real
            return r * r
        endfunction
        function s__Math_Sqrt takes real r returns real
            return SquareRoot(r)
        endfunction
        function s__Math_InvSqrt takes real r returns real
            if ( ( r == 0 ) ) then
                return 0
            endif
            return 1 / SquareRoot(r)
        endfunction
        function s__Math_Cbr takes real r returns real
            return r * r * r
        endfunction
        function s__Math_Cbrt takes real r returns real
            return (Pow(((r )*1.0), (( 0.333333)*1.0))) // INLINED!!
        endfunction
        function s__Math_InvCbrt takes real r returns real
            if ( ( r == 0 ) ) then
                return 0
            endif
            return 1 / (Pow(((r )*1.0), (( 0.333333)*1.0))) // INLINED!!
        endfunction
        function s__Math_Power takes real a,real power returns real
            return Pow(a, power)
        endfunction
        function s__Math_Exp takes real power returns real
            return Pow(s__Math_E, power)
        endfunction
        function s__Math_Log takes real r,real a returns real
            return sc__Math_Ln(r) / sc__Math_Ln(a)
        endfunction
        function s__Math_Lg takes real r returns real
            return sc__Math_Ln(r) / sc__Math_Ln(10.0)
        endfunction
        function s__Math_Hypot takes real x,real y returns real
            return SquareRoot(x * x + y * y)
        endfunction
        function s__Math_Modulo takes real dividend,real divisor returns real
            local real modulus=dividend - I2R(R2I(dividend / divisor)) * divisor
            if ( modulus < 0 ) then
                set modulus=modulus + divisor
            endif
            return modulus
        endfunction
        function s__Math_IModulo takes integer dividend,integer divisor returns integer
            local integer modulus=dividend - dividend / divisor * divisor
            if ( modulus < 0 ) then
                set modulus=modulus + divisor
            endif
            return modulus
        endfunction  // )->the value that is closest in value to the argument &&  is equal to a mathematical integer.
        function s__Math_Rint takes real r returns real
            local real i=I2R(R2I(r))
            local real modulo=s__Math_Modulo(r , 1.0)
            if ( modulo > 0.5 or ( modulo == 0.5 and s__Math_Modulo(i , 2.0) != 0.0 ) ) then
                return i + 1.0
            endif
            return i
        endfunction  //  Computes the remainder operation on two arguments as prescribed by the IEEE 754 standard.
        function s__Math_IEEERemainder takes real dividend,real divisor returns real
            return dividend - divisor * s__Math_Round(dividend / divisor)
        endfunction  //  Uses Taylor series
        function s__Math_Ln takes real r returns real
            local real sum=0.0
            local real e=1.648721
            local real b=0.0
            loop
            exitwhen ( r < s__Math_E )
                set r=r / s__Math_E
                set sum=sum + 1.0
            endloop
            if ( r >= e ) then
                set r=r / e
                set sum=sum + 0.5
            endif
            set e=1.0
            set r=r - 1.0
            set b=r
            loop
            exitwhen ( e > 5.0 )
                set sum=sum + r / e
                set e=e + 1.0
                set r=r * b * ( - 1.0 )
            endloop
            return sum
        endfunction
    function StarCommon__subString takes string source,integer start,integer end returns string
        return SubString(source, start, end)
    endfunction
        function s__StringUtil_Render takes string str,integer color returns string
            return "|c" + sc__Argb_ToString(color) + str + "|r"
        endfunction
        function s__StringUtil_HashCode takes string str returns integer
            return StringHash(str)
        endfunction
        function s__StringUtil_Length takes string str returns integer
            return StringLength(str)
        endfunction
        function s__StringUtil_Contains takes string str,string pattern returns boolean
            return sc__StringUtil_IndexOf(str , pattern) != - 1
        endfunction
        function s__StringUtil_StartsWith takes string str,string pattern returns boolean
            local integer thisLen=StringLength(str)
            local integer patternLen=StringLength(pattern)
            if ( thisLen < patternLen or patternLen == 0 ) then
                return false
            endif
            return (SubString((str ), ( 0 ), ( patternLen))) == pattern // INLINED!!
        endfunction
        function s__StringUtil_EndsWith takes string str,string pattern returns boolean
            local integer thisLen=StringLength(str)
            local integer patternLen=StringLength(pattern)
            if ( thisLen < patternLen or patternLen == 0 ) then
                return false
            endif
            return (SubString((str ), ( thisLen - patternLen ), ( thisLen))) == pattern // INLINED!!
        endfunction
        function s__StringUtil_Compare takes string str,string str2 returns integer
            local integer strLen=StringLength(str)
            local integer strLen2=StringLength(str2)
            local integer minLen=IMinBJ(strLen, strLen2)
            local integer i=0
            local integer char=0
            local integer char2=0
            if ( str == str2 ) then
                return 0
            endif
            set i=0
            loop
            exitwhen ( i >= minLen )
                set char=sc__Convert_S2Id(sc__StringUtil_CharAt(str , i))
                set char2=sc__Convert_S2Id(sc__StringUtil_CharAt(str2 , i))
                if ( char != char2 ) then
                    return char - char2
                endif
            set i=i + 1
            endloop
            return 0
        endfunction
        function s__StringUtil_IndexOf takes string str,string sub returns integer
            local integer strLen=StringLength(str)
            local integer subLen=StringLength(sub)
            local integer i=0
            if ( strLen >= subLen and subLen > 0 ) then
                set i=0
                loop
                exitwhen i > strLen - subLen
                    if ( sub == sc__StringUtil_SubString(str , i , subLen) ) then
                        return i
                    endif
                set i=i + 1
                endloop
            endif
            return - 1
        endfunction
        function s__StringUtil_LastIndexOf takes string str,string sub returns integer
            local integer strLen=StringLength(str)
            local integer subLen=StringLength(sub)
            local integer i=0
            if ( strLen >= subLen and subLen > 0 ) then
                set i=strLen - subLen
                loop
                exitwhen i < 0
                    if ( sub == sc__StringUtil_SubString(str , i , subLen) ) then
                        return i
                    endif
                set i=i - 1
                endloop
            endif
            return - 1
        endfunction
        function s__StringUtil_CharAt takes string str,integer index returns string
            if ( index < 0 ) then
                set index=StringLength(str) + index
            endif
            return (SubString((str ), ( index ), ( index + 1))) // INLINED!!
        endfunction
        function s__StringUtil_Slice takes string str,integer begin,integer end returns string
            return (SubString((str ), ( begin ), ( end))) // INLINED!!
        endfunction
        function s__StringUtil_SubString takes string str,integer begin,integer length returns string
            return (SubString((str ), ( begin ), ( begin + length))) // INLINED!!
        endfunction
        function s__StringUtil_StrCont takes string s1,string s2,string s3 returns string
            local string str
            call RemoveSavedString(StarBaseHT, 1000, 0)
            call RemoveSavedString(StarBaseHT, 1000, 1)
            call RemoveSavedString(StarBaseHT, 1000, 2)
            call RemoveSavedString(StarBaseHT, 1000, 4)
            call SaveStr(StarBaseHT, 1000, 0, s1)
            call SaveStr(StarBaseHT, 1000, 1, s2)
            call SaveStr(StarBaseHT, 1000, 2, s3)
            call SaveStr(StarBaseHT, 1000, 4, "123456") //SaveStr(StarBaseHT,1000,3,s4);
            call EXExecuteScript("(require'StarStr').concat()") //99%未执行 need cheak
            set str=LoadStr(StarBaseHT, 1000, 4) //if(str==null){return "";}
            return str
        endfunction
        function s__StringUtil_StrPoolAdd takes string str returns nothing
            set SSL_StringBuffer[SSL_StringBufferIndex]=str // SaveStr(StarBaseHT,1000,count,str); // count+=1;
            set SSL_StringBufferIndex=SSL_StringBufferIndex + 1 // Print("SSL_StringBufferIndex:"+I2S(SSL_StringBufferIndex));
        endfunction  //读取连接完成的字符串
        function s__StringUtil_StrContLoad takes nothing returns string
            return EXExecuteScript("(require'StarStr').concat3()") // string str ; // SaveInteger(StarBaseHT,999,0,count); // // Print("运行"); // EXExecuteScript("(require'StarStr').concat2()"); // // Print("运行"); // count = 0; // str = LoadStr(StarBaseHT,999,1); // //Print(str); // return str; //Print("调用输出");
        endfunction
        function s__StringUtil_SubStr takes string str,integer length returns string
            local integer strLen=StringLength(str)
            if ( length > strLen or length < - strLen ) then
                return str
            endif
            if ( length >= 0 ) then
                return s__StringUtil_SubString(str , 0 , length)
            endif
            return s__StringUtil_SubString(str , strLen + length , - length)
        endfunction
        function s__StringUtil_Replace takes string str,string old,string new returns string
            local integer i=s__StringUtil_IndexOf(str , old)
            if ( i != - 1 ) then
                return s__StringUtil_SubStr(str , i) + new + s__StringUtil_SubStr(str , i + StringLength(old) - StringLength(str))
            endif
            return str
        endfunction
        function s__StringUtil_LastReplace takes string str,string old,string new returns string
            local integer i=s__StringUtil_LastIndexOf(str , old)
            if ( i != - 1 ) then
                return s__StringUtil_SubStr(str , i) + new + s__StringUtil_SubStr(str , i + StringLength(old) - StringLength(str))
            endif
            return str
        endfunction
        function s__StringUtil_ReplaceAll takes string str,string old,string new returns string
            local integer i=s__StringUtil_IndexOf(str , old)
            loop
            exitwhen ( i == - 1 )
                set str=s__StringUtil_SubStr(str , i) + new + s__StringUtil_SubStr(str , i + StringLength(old) - StringLength(str))
                set i=s__StringUtil_IndexOf(str , old)
            endloop
            return str
        endfunction
        function s__StringUtil_ToLowerCase takes string str returns string
            local string result=""
            local integer strLen=StringLength(str)
            local integer char=0
            local integer i=0
            set i=0
            loop
            exitwhen ( i >= strLen )
                set char=sc__Convert_S2Id(s__StringUtil_CharAt(str , i))
                if ( char > 64 and char < 91 ) then
                    set char=char + 32
                endif
                set result=result + sc__Convert_Id2S(char)
            set i=i + 1
            endloop
            return result
        endfunction
        function s__StringUtil_ToUpperCase takes string str returns string
            local string result=""
            local integer strLen=StringLength(str)
            local integer char=0
            local integer i=0
            set i=0
            loop
            exitwhen ( i >= strLen )
                set char=sc__Convert_S2Id(s__StringUtil_CharAt(str , i))
                if ( char > 96 and char < 123 ) then
                    set char=char - 32
                endif
                set result=result + sc__Convert_Id2S(char)
            set i=i + 1
            endloop
            return result
        endfunction
        function s__StringUtil_Reverse takes string str returns string
            local string result=""
            local integer strLen=StringLength(str)
            local integer i=0
            set i=strLen
            loop
            exitwhen ( i <= 0 )
                set result=result + s__StringUtil_CharAt(str , i - 1)
            set i=i - 1
            endloop
            return result
        endfunction
        function s__StringUtil_Trim takes string str returns string
            local integer begin=0
            local integer end=StringLength(str)
            local string char=""
            if ( str == "" ) then
                return ""
            endif
            set char=(SubString((str ), ( 0 ), ( 1))) // INLINED!!
            loop
            exitwhen ( not ( char == " " or char == "\t" or char == "\n" ) )
                set begin=begin + 1
                set char=s__StringUtil_CharAt(str , begin)
            endloop
            set char=(SubString((str ), ( end - 1 ), ( end))) // INLINED!!
            loop
            exitwhen ( not ( char == " " or char == "\t" or char == "\n" ) )
                set end=end - 1
                set char=s__StringUtil_CharAt(str , end - 1)
            endloop
            return (SubString((str ), ( begin ), ( end))) // INLINED!!
        endfunction  // Split("a,,b, c", ","); //--["a", "", "b", " c"]
        function s__StringUtil_Split takes string str,string delimiters returns integer
            local integer result=s__StringArray__allocate()
            local integer strLen=StringLength(str)
            local integer delimLen=StringLength(delimiters)
            local integer i=0
            local integer j=0
            local integer prev=0
            if ( str == "" ) then
                return result
            endif
            if ( delimLen == 0 ) then
                set strLen=R2I(s__Math_Min(strLen , s__StringArray_size))
                set i=0
                loop
                exitwhen ( i >= strLen )
                    set s__StringArray[result+i]=s__StringUtil_CharAt(str , i)
                set i=i + 1
                endloop
                return result
            endif
            set i=0
            loop
            exitwhen not ( i < strLen and j < s__StringArray_size )
                if ( (sc__StringUtil_IndexOf((delimiters ) , ( (SubString((str ), ( i ), ( i + 1))))) != - 1) ) then // INLINED!!
                    set s__StringArray[result+j]=(SubString((str ), ( prev ), ( i))) // INLINED!!
                    set j=j + 1
                    set prev=i + 1
                endif
            set i=i + 1
            endloop
            if ( j < s__StringArray_size ) then
                set s__StringArray[result+j]=(SubString((str ), ( prev ), ( strLen))) // INLINED!!
            endif
            return result
        endfunction  // It will cause a bug, if you set @para separator as "|"
        function s__StringUtil_Join takes integer arr,string separator returns string
            local string result=""
            local integer i
            set i=1
            loop
            exitwhen not ( i < s__StringArray_size and s__StringArray[arr+i] != null )
                set result=result + separator + s__StringArray[arr+i]
            set i=i + 1
            endloop
            return s__StringArray[arr] + result
        endfunction
    //private:
        function StarCommon__i2R takes integer i returns real
            return I2R(i)
        endfunction
        function StarCommon__i2S takes integer i returns string
            return I2S(i)
        endfunction
        function StarCommon__r2I takes real r returns integer
            return R2I(r)
        endfunction
        function StarCommon__r2S takes real r returns string
            return R2S(r)
        endfunction
        function StarCommon__s2I takes string s returns integer
            return S2I(s)
        endfunction
        function StarCommon__s2R takes string s returns real
            return S2R(s)
        endfunction
        function s__Convert_S2Id takes string s returns integer
            local string charSet=s__Convert_charSet
            local integer strLength=StringLength(s)
            local integer result=0
            local integer char=0
            local integer i=0
            set i=0
            loop
            exitwhen ( i >= strLength )
                set char=s__StringUtil_IndexOf(charSet , SubString(s, i, i + 1)) //debug Print(char>= 0, "[Convert.S2Id] The converted char is not between 32 &&  126!");
                set result=result + ( char + 32 ) * sc__Convert_R2I((Pow(((256.0 )*1.0), (( strLength - i - 1)*1.0)))) // INLINED!!
            set i=i + 1
            endloop
            return result
        endfunction
        function s__Convert_S2ID takes string s returns integer
            call RemoveSavedInteger(StarBaseHT, 1000, 1) //RemoveSavedString(StarBaseHT,1000,0);
            call SaveStr(StarBaseHT, 1000, 0, s)
            call EXExecuteScript("(require'Id').string2id()")
            return LoadInteger(StarBaseHT, 1000, 1)
        endfunction
        function s__Convert_ID2S takes integer i returns string
            local string s
            if ( i == 0 ) then
                return ""
            endif
            call RemoveSavedInteger(StarBaseHT, 1000, 0) //RemoveSavedString(StarBaseHT,1000,1);
            call SaveInteger(StarBaseHT, 1000, 0, i)
            call EXExecuteScript("(require'Id').id2string()")
            set s=LoadStr(StarBaseHT, 1000, 1)
            if ( s == null ) then
                return ""
            endif
            return s
        endfunction
        function s__Convert_ToMD5 takes string s returns string
            set StarVarStr=s
            return EXExecuteScript("(require'md5').sumhexa()")
        endfunction
        function s__Convert_Id2S takes integer id returns string
            local string charSet=s__Convert_charSet
            local string result=""
            local integer modulo=0
            loop
            exitwhen ( id <= 0 )
                set modulo=sc__Convert_R2I(s__Math_Modulo(id , 256.0))
                if ( modulo < 32 or modulo > 126 ) then
                    set result=result + "€"
                endif
                set result=result + SubString(charSet, modulo - 32, modulo - 31)
                set id=id / 256
            endloop
            return result
        endfunction
        function s__Convert_S2Int takes string s,integer base returns integer
            local string charSet=SubString(s__Convert_charSet64, 0, base)
            local integer strLength=StringLength(s)
            local integer result=0
            local integer sign=1
            local integer begin=0
            local integer char=0
            if ( SubString(s, 0, 1) == "-" ) then
                set sign=- 1
                set begin=1
            endif
            loop
            exitwhen ( begin >= strLength )
                set char=s__StringUtil_IndexOf(charSet , SubString(s, begin, begin + 1))
                set begin=begin + 1
                set result=result + char * sc__Convert_R2I((Pow(((base )*1.0), (( strLength - begin)*1.0)))) // INLINED!!
            endloop
            return result * sign
        endfunction
        function s__Convert_Int2S takes integer i,integer base returns string
            local string charSet=SubString(s__Convert_charSet64, 0, base)
            local string result=""
            local integer modulo=0
            if ( i < 0 ) then
                set result="-"
                set i=- i
            elseif ( i == 0 ) then
                return "0"
            endif
            loop
            exitwhen ( i <= 0 )
                set modulo=sc__Convert_R2I(s__Math_Modulo(i , base))
                set result=result + SubString(charSet, modulo, modulo + 1)
                set i=i / base
            endloop
            return result
        endfunction  // Don't set the @para count too large beacause of the Jass Decimal precision of less than 6 digits
        function s__Convert_Real2S takes real r,integer count returns string
            local string result=""
            local string str
            local integer strLen
            local integer i
            if ( count > 3 ) then
                set count=count - 3
                set result=sc__Convert_R2S((I2R(R2I(((r * 1000)*1.0)))) / 1000) // INLINED!!
                set str=s__StringUtil_Replace(sc__Convert_R2S(r * (Pow(((10 )*1.0), (( count)*1.0)))) , "." , "") // INLINED!!
                set strLen=StringLength(str)
                set i=strLen
                loop
                exitwhen ( i >= count )
                    set str="0" + str
                set i=i + 1
                endloop
                return result + s__StringUtil_SubStr(str , - count)
            elseif ( count >= 0 ) then
                set result=sc__Convert_R2S(r)
                return s__StringUtil_SubStr(result , StringLength(result) + count - 3)
            endif
            return ""
        endfunction
        function s__Convert_I2B takes integer i returns boolean
            return i != 0
        endfunction
        function s__Convert_R2B takes real r returns boolean
            return r != 0.0
        endfunction
        function s__Convert_S2B takes string s returns boolean
            return s != ""
        endfunction
        function s__Convert_B2I takes boolean b returns integer
            if ( b ) then
                return 1
            endif
            return 0
        endfunction
        function s__Convert_B2R takes boolean b returns real
            if ( b ) then
                return 1.0
            endif
            return 0.0
        endfunction
        function s__Convert_B2S takes boolean b returns string
            if ( b ) then
                return "true"
            endif
            return "false"
        endfunction
        function s__Convert_I2R takes integer i returns real
            return (I2R((i))) // INLINED!!
        endfunction
        function s__Convert_I2S takes integer i returns string
            return (I2S((i))) // INLINED!!
        endfunction
        function s__Convert_R2I takes real r returns integer
            return (R2I(((r)*1.0))) // INLINED!!
        endfunction
        function s__Convert_R2S takes real r returns string
            return (R2S(((r)*1.0))) // INLINED!!
        endfunction
        function s__Convert_S2I takes string s returns integer
            return (S2I((s))) // INLINED!!
        endfunction
        function s__Convert_S2R takes string s returns real
            return (S2R((s))) // INLINED!!
        endfunction
        function s__Convert_R2I2 takes real r returns integer
            return (R2I(((((r + 0.5)*1.0))*1.0))) // INLINED!!
        endfunction
    //private:  //#include "Common\\List.j" //#include "Common\\Tree.j"
        function StarCommon__Savereal takes hashtable ht,integer pk,integer ck,real value returns nothing
            call SaveReal(ht, pk, ck, value)
        endfunction
        function StarCommon__Loadreal takes hashtable ht,integer pk,integer ck returns real
            return LoadReal(ht, pk, ck)
        endfunction
        function s__StarTable_destroy takes integer this returns nothing
            call FlushChildHashtable(s__StarTable_ht, this)
            call s__StarTable_deallocate(this)
        endfunction
        function s__StarTable__getindex takes integer this,integer id returns integer
            return LoadInteger(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable__setindex takes integer this,integer id,integer value returns nothing
            call SaveInteger(s__StarTable_ht, this, id, value)
        endfunction
        function s__StarTable_Exists takes integer this,integer id returns boolean
            return HaveSavedInteger(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_Flush takes integer this,integer id returns integer
            local integer value=LoadInteger(s__StarTable_ht, this, id)
            call RemoveSavedInteger(s__StarTable_ht, this, id)
            return value
        endfunction  //判断是否存有指定类型/任意类型数据
        function s__StarTable_ExistsInt takes integer this,integer id returns boolean
            return HaveSavedInteger(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_ExistsBool takes integer this,integer id returns boolean
            return HaveSavedBoolean(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_ExistsReal takes integer this,integer id returns boolean
            return HaveSavedReal(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_ExistsString takes integer this,integer id returns boolean
            return HaveSavedString(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_ExistsHandle takes integer this,integer id returns boolean
            return HaveSavedHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_ExistsAny takes integer this,integer id returns boolean
            return HaveSavedInteger(s__StarTable_ht, this, id) or HaveSavedHandle(s__StarTable_ht, this, id) or HaveSavedString(s__StarTable_ht, this, id) or HaveSavedReal(s__StarTable_ht, this, id) or HaveSavedBoolean(s__StarTable_ht, this, id)
        endfunction  //清除指定类型/任意类型数据
        function s__StarTable_FlushInt takes integer this,integer id returns nothing
            call RemoveSavedInteger(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_FlushBool takes integer this,integer id returns nothing
            call RemoveSavedBoolean(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_FlushReal takes integer this,integer id returns nothing
            call RemoveSavedReal(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_FlushString takes integer this,integer id returns nothing
            call RemoveSavedString(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_FlushHandle takes integer this,integer id returns nothing
            call RemoveSavedHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_FlushAll takes integer this,integer id returns nothing
            call RemoveSavedInteger(s__StarTable_ht, this, id)
            call RemoveSavedBoolean(s__StarTable_ht, this, id)
            call RemoveSavedReal(s__StarTable_ht, this, id)
            call RemoveSavedString(s__StarTable_ht, this, id)
            call RemoveSavedHandle(s__StarTable_ht, this, id)
        endfunction  //textmacro instance: Common_Table ("Int", "Integer", "integer")
        function s__StarTable_SaveInt takes integer this,integer id,integer i returns nothing
            call SaveInteger(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadInt takes integer this,integer id returns integer
            return LoadInteger(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveBool takes integer this,integer id,boolean i returns nothing
            call SaveBoolean(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadBool takes integer this,integer id returns boolean
            return LoadBoolean(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveReal takes integer this,integer id,real i returns nothing
            call SaveReal((s__StarTable_ht ), ( this ), ( id ), (( i)*1.0)) // INLINED!!
        endfunction
        function s__StarTable_LoadReal takes integer this,integer id returns real
            return (LoadReal((s__StarTable_ht ), ( this ), ( id))) // INLINED!!
        endfunction
        function s__StarTable_SaveString takes integer this,integer id,string i returns nothing
            call SaveStr(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadString takes integer this,integer id returns string
            return LoadStr(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveTimer takes integer this,integer id,timer i returns nothing
            call SaveTimerHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadTimer takes integer this,integer id returns timer
            return LoadTimerHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveEffect takes integer this,integer id,effect i returns nothing
            call SaveEffectHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadEffect takes integer this,integer id returns effect
            return LoadEffectHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveLightning takes integer this,integer id,lightning i returns nothing
            call SaveLightningHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadLightning takes integer this,integer id returns lightning
            return LoadLightningHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveTextTag takes integer this,integer id,texttag i returns nothing
            call SaveTextTagHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadTextTag takes integer this,integer id returns texttag
            return LoadTextTagHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveTrigger takes integer this,integer id,trigger i returns nothing
            call SaveTriggerHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadTrigger takes integer this,integer id returns trigger
            return LoadTriggerHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveQuest takes integer this,integer id,quest i returns nothing
            call SaveQuestHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadQuest takes integer this,integer id returns quest
            return LoadQuestHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveDialog takes integer this,integer id,dialog i returns nothing
            call SaveDialogHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadDialog takes integer this,integer id returns dialog
            return LoadDialogHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveButton takes integer this,integer id,button i returns nothing
            call SaveButtonHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadButton takes integer this,integer id returns button
            return LoadButtonHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveMultiboard takes integer this,integer id,multiboard i returns nothing
            call SaveMultiboardHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadMultiboard takes integer this,integer id returns multiboard
            return LoadMultiboardHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveMultiboardItem takes integer this,integer id,multiboarditem i returns nothing
            call SaveMultiboardItemHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadMultiboardItem takes integer this,integer id returns multiboarditem
            return LoadMultiboardItemHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveRect takes integer this,integer id,rect i returns nothing
            call SaveRectHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadRect takes integer this,integer id returns rect
            return LoadRectHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveRegion takes integer this,integer id,region i returns nothing
            call SaveRegionHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadRegion takes integer this,integer id returns region
            return LoadRegionHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveImage takes integer this,integer id,image i returns nothing
            call SaveImageHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadImage takes integer this,integer id returns image
            return LoadImageHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveSound takes integer this,integer id,sound i returns nothing
            call SaveSoundHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadSound takes integer this,integer id returns sound
            return LoadSoundHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveWidget takes integer this,integer id,widget i returns nothing
            call SaveWidgetHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadWidget takes integer this,integer id returns widget
            return LoadWidgetHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveDestruct takes integer this,integer id,destructable i returns nothing
            call SaveDestructableHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadDestruct takes integer this,integer id returns destructable
            return LoadDestructableHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveItem takes integer this,integer id,item i returns nothing
            call SaveItemHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadItem takes integer this,integer id returns item
            return LoadItemHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_SaveUnit takes integer this,integer id,unit i returns nothing
            call SaveUnitHandle(s__StarTable_ht, this, id, i)
        endfunction
        function s__StarTable_LoadUnit takes integer this,integer id returns unit
            return LoadUnitHandle(s__StarTable_ht, this, id)
        endfunction
        function s__StarTable_onInit takes nothing returns nothing
            set s__StarTable_ht=InitHashtable()
        endfunction
        function s__Argb_create takes integer a,integer r,integer g,integer b returns integer
            return b + g * 0x100 + r * 0x10000 + a * 0x1000000
        endfunction  // Alpha
        function s__Argb__get_A takes integer this returns integer
            if ( (this) < 0 ) then
                return 0x80 + ( - ( - (this) + 0x80000000 ) ) / 0x1000000
            endif
            return ( (this) ) / 0x1000000
        endfunction
        function s__Argb__set_A takes integer this,integer alpha returns integer
            local integer a=0
            local integer r=0
            local integer g=0
            local integer b=0
            local integer col=(this)
            if ( col < 0 ) then
                set col=- ( - col + 0x80000000 )
                set a=0x80 + col / 0x1000000
                set col=col - ( a - 0x80 ) * 0x1000000
            else
                set a=col / 0x1000000
                set col=col - a * 0x1000000
            endif
            set r=col / 0x10000
            set col=col - r * 0x10000
            set g=col / 0x100
            set b=col - g * 0x100
            return (b + g * 0x100 + r * 0x10000 + alpha * 0x1000000)
        endfunction  // Red
        function s__Argb__get_R takes integer this returns integer
            local integer c=(this) * 0x100
            if ( c < 0 ) then
                return 0x80 + ( - ( - c + 0x80000000 ) ) / 0x1000000
            endif
            return c / 0x1000000
        endfunction
        function s__Argb__set_R takes integer this,integer red returns integer
            local integer a=0
            local integer r=0
            local integer g=0
            local integer b=0
            local integer col=(this)
            if ( col < 0 ) then
                set col=- ( - col + 0x80000000 )
                set a=0x80 + col / 0x1000000
                set col=col - ( a - 0x80 ) * 0x1000000
            else
                set a=col / 0x1000000
                set col=col - a * 0x1000000
            endif
            set r=col / 0x10000
            set col=col - r * 0x10000
            set g=col / 0x100
            set b=col - g * 0x100
            return (b + g * 0x100 + red * 0x10000 + a * 0x1000000)
        endfunction  // Green
        function s__Argb__get_G takes integer this returns integer
            local integer c=(this) * 0x10000
            if ( c < 0 ) then
                return 0x80 + ( - ( - c + 0x80000000 ) ) / 0x1000000
            endif
            return c / 0x1000000
        endfunction
        function s__Argb__set_G takes integer this,integer green returns integer
            local integer a=0
            local integer r=0
            local integer g=0
            local integer b=0
            local integer col=(this)
            if ( col < 0 ) then
                set col=- ( - col + 0x80000000 )
                set a=0x80 + col / 0x1000000
                set col=col - ( a - 0x80 ) * 0x1000000
            else
                set a=col / 0x1000000
                set col=col - a * 0x1000000
            endif
            set r=col / 0x10000
            set col=col - r * 0x10000
            set g=col / 0x100
            set b=col - g * 0x100
            return (b + green * 0x100 + r * 0x10000 + a * 0x1000000)
        endfunction  // Blue
        function s__Argb__get_B takes integer this returns integer
            local integer c=(this) * 0x1000000
            if ( c < 0 ) then
                return 0x80 + ( - ( - c + 0x80000000 ) ) / 0x1000000
            endif
            return c / 0x1000000
        endfunction
        function s__Argb__set_B takes integer this,integer blue returns integer
            local integer a=0
            local integer r=0
            local integer g=0
            local integer b=0
            local integer col=(this)
            if ( col < 0 ) then
                set col=- ( - col + 0x80000000 )
                set a=0x80 + col / 0x1000000
                set col=col - ( a - 0x80 ) * 0x1000000
            else
                set a=col / 0x1000000
                set col=col - a * 0x1000000
            endif
            set r=col / 0x10000
            set col=col - r * 0x10000
            set g=col / 0x100
            set b=col - g * 0x100
            return (blue + g * 0x100 + r * 0x10000 + a * 0x1000000)
        endfunction  //  Mixes two colors, s would be a number 0<=s<=1 that determines
        function s__Argb_Mix takes integer one,integer other,real ratio returns integer
            return (R2I(s__Argb__get_B(other) * ratio + s__Argb__get_B(one) * ( 1 - ratio ) + 0.5) + R2I(s__Argb__get_G(other) * ratio + s__Argb__get_G(one) * ( 1 - ratio ) + 0.5) * 0x100 + R2I(s__Argb__get_R(other) * ratio + s__Argb__get_R(one) * ( 1 - ratio ) + 0.5) * 0x10000 + R2I(s__Argb__get_A(other) * ratio + s__Argb__get_A(one) * ( 1 - ratio ) + 0.5) * 0x1000000)
        endfunction
        function s__Argb_ToString takes integer this returns string
            local string result=""
            local integer array arr
            local integer i
            set arr[0]=s__Argb__get_A(this)
            set arr[1]=s__Argb__get_R(this)
            set arr[2]=s__Argb__get_G(this)
            set arr[3]=s__Argb__get_B(this)
            set i=0
            loop
            exitwhen ( i >= 4 )
                if ( arr[i] < 16 ) then
                    set result=result + "0"
                endif
                set result=result + s__Convert_Int2S(arr[i] , 16)
            set i=i + 1
            endloop
            return result
        endfunction
        function s__Vector2__lessthan takes integer this,integer that returns boolean
            return s__Vector2_X[this] < s__Vector2_X[that] and s__Vector2_Y[this] < s__Vector2_Y[that]
        endfunction
        function s__Vector2__get_SquaredLength takes integer this returns real
            return s__Vector2_X[this] * s__Vector2_X[this] + s__Vector2_Y[this] * s__Vector2_Y[this]
        endfunction
        function s__Vector2__get_Length takes integer this returns real
            return (SquareRoot(((s__Vector2_X[this] * s__Vector2_X[this] + s__Vector2_Y[this] * s__Vector2_Y[this])*1.0))) // INLINED!!
        endfunction
        function s__Vector2__set_Length takes integer this,real value returns nothing
            call sc__Vector2_Scale(this,value * s__Math_InvSqrt(s__Vector2__get_SquaredLength(this)))
        endfunction
        function s__Vector2__get_Angle takes integer this returns real
            return Atan2(s__Vector2_Y[this], s__Vector2_X[this])
        endfunction
        function s__Vector2__set_Angle takes integer this,real value returns nothing
            local real length=s__Vector2__get_Length(this)
            set s__Vector2_X[this]=length * Cos(value)
            set s__Vector2_Y[this]=length * Sin(value)
        endfunction
        function s__Vector2_Equals takes integer this,integer that returns boolean
            return s__Math_IsZero(s__Vector2_X[this] - s__Vector2_X[that]) and s__Math_IsZero(s__Vector2_Y[this] - s__Vector2_Y[that])
        endfunction
        function s__Vector2_IsZero takes integer this returns boolean
            return s__Math_IsZero(s__Vector2_X[this]) and s__Math_IsZero(s__Vector2_Y[this])
        endfunction
        function s__Vector2_Reset takes integer this,real x,real y returns integer
            set s__Vector2_X[this]=x
            set s__Vector2_Y[this]=y
            return this
        endfunction
        function s__Vector2_ResetXY takes integer this,real x,real y returns integer
            set s__Vector2_X[this]=x
            set s__Vector2_Y[this]=y
            return this
        endfunction
        function s__Vector2_Copy takes integer this,integer that returns integer
            return s__Vector2_Reset(this,s__Vector2_X[that] , s__Vector2_Y[that])
        endfunction
        function s__Vector2_GetCopy takes integer this returns integer
            return s__Vector2_Reset(s__Vector2__allocate(),s__Vector2_X[this] , s__Vector2_Y[this])
        endfunction
        function s__Vector2_Normalize takes integer this returns real
            local real length=s__Vector2__get_Length(this)
            if ( length != 0 ) then
                call sc__Vector2_Scale(this,1 / length)
            endif
            return length
        endfunction
        function s__Vector2_GetNormalizedCopy takes integer this returns integer
            local integer n=s__Vector2_GetCopy(this)
            call s__Vector2_Normalize(n)
            return n
        endfunction
        function s__Vector2_GetNormal takes integer this returns integer
            return s__Vector2_Reset(s__Vector2__allocate(),- s__Vector2_Y[this] , s__Vector2_X[this])
        endfunction
        function s__Vector2_GetRandomDeviant takes integer this,real angle returns integer
            local real cosa
            local real sina
            set angle=angle * (sc__Math_GetRandomReal(0.0 , 1.0)) // INLINED!!
            set cosa=Cos(angle)
            set sina=Sin(angle)
            return s__Vector2_Reset(s__Vector2__allocate(),s__Vector2_X[this] * cosa - s__Vector2_Y[this] * sina , s__Vector2_X[this] * sina + s__Vector2_Y[this] * cosa)
        endfunction
        function s__Vector2_Swap takes integer this,integer that returns nothing
            local real temp
            set temp=s__Vector2_X[this]
            set s__Vector2_X[this]=s__Vector2_X[that]
            set s__Vector2_X[that]=temp
            set temp=s__Vector2_Y[this]
            set s__Vector2_Y[this]=s__Vector2_Y[that]
            set s__Vector2_Y[that]=temp
        endfunction
        function s__Vector2_GetSquaredDistanceWith takes integer this,integer that returns real
            return ( s__Vector2_X[this] - s__Vector2_X[that] ) * ( s__Vector2_X[this] - s__Vector2_X[that] ) + ( s__Vector2_Y[this] - s__Vector2_Y[that] ) * ( s__Vector2_Y[this] - s__Vector2_Y[that] )
        endfunction
        function s__Vector2_GetDistanceWith takes integer this,integer that returns real
            return (SquareRoot(((( s__Vector2_X[this] - s__Vector2_X[that] ) * ( s__Vector2_X[this] - s__Vector2_X[that] ) + ( s__Vector2_Y[this] - s__Vector2_Y[that] ) * ( s__Vector2_Y[this] - s__Vector2_Y[that] ))*1.0))) // INLINED!!
        endfunction
        function s__Vector2_GetAngleWith takes integer this,integer that returns real
            local real mul=s__Vector2__get_Length(this) * s__Vector2__get_Length(that)
            if ( ( mul == 0 ) ) then
                return 0.0
            endif
            return Acos(( s__Vector2_X[this] * s__Vector2_X[that] + s__Vector2_Y[this] * s__Vector2_Y[that] ) / mul)
        endfunction
        function s__Vector2_GetMiddle takes integer this,integer that returns integer
            return s__Vector2_Reset(s__Vector2__allocate(),( s__Vector2_X[this] + s__Vector2_X[that] ) / 2 , ( s__Vector2_Y[this] + s__Vector2_Y[that] ) / 2)
        endfunction
        function s__Vector2_MakeFloor takes integer this,integer that returns integer
            if ( s__Vector2_X[that] < s__Vector2_X[this] ) then
                set s__Vector2_X[this]=s__Vector2_X[that]
            endif
            if ( s__Vector2_Y[that] < s__Vector2_Y[this] ) then
                set s__Vector2_Y[this]=s__Vector2_Y[that]
            endif
            return this
        endfunction
        function s__Vector2_MakeCeil takes integer this,integer that returns integer
            if ( s__Vector2_X[that] > s__Vector2_X[this] ) then
                set s__Vector2_X[this]=s__Vector2_X[that]
            endif
            if ( s__Vector2_Y[that] > s__Vector2_Y[this] ) then
                set s__Vector2_Y[this]=s__Vector2_Y[that]
            endif
            return this
        endfunction
        function s__Vector2_Add takes integer this,integer that returns integer
            set s__Vector2_X[this]=s__Vector2_X[this] + s__Vector2_X[that]
            set s__Vector2_Y[this]=s__Vector2_Y[this] + s__Vector2_Y[that]
            return this
        endfunction
        function s__Vector2_Subtract takes integer this,integer that returns integer
            set s__Vector2_X[this]=s__Vector2_X[this] - s__Vector2_X[that]
            set s__Vector2_Y[this]=s__Vector2_Y[this] - s__Vector2_Y[that]
            return this
        endfunction
        function s__Vector2_Scale takes integer this,real factor returns integer
            set s__Vector2_X[this]=s__Vector2_X[this] * factor
            set s__Vector2_Y[this]=s__Vector2_Y[this] * factor
            return this
        endfunction
        function s__Vector2_DotProduct takes integer this,integer that returns real
            return s__Vector2_X[this] * s__Vector2_X[that] + s__Vector2_Y[this] * s__Vector2_Y[that]
        endfunction
        function s__Vector2_CrossProduct takes integer this,integer that returns real
            return s__Vector2_X[this] * s__Vector2_Y[that] - s__Vector2_Y[this] * s__Vector2_X[that]
        endfunction
        function s__Vector2_Project takes integer this,integer direction returns integer
            local real len2=s__Vector2_X[direction] * s__Vector2_X[direction] + s__Vector2_Y[direction] * s__Vector2_Y[direction]
            if ( ( len2 == 0.0 ) ) then
                return 0
            endif
            set len2=( s__Vector2_X[this] * s__Vector2_X[direction] + s__Vector2_Y[this] * s__Vector2_Y[direction] ) / len2
            return s__Vector2_Reset(this,s__Vector2_X[direction] * len2 , s__Vector2_Y[direction] * len2)
        endfunction  //  Creates an interpolated vector between this vector && that vector.
        function s__Vector2_Interpolate takes integer this,integer that,real k returns integer
            local integer result=s__Vector2__allocate()
            local real d=1.0 - k
            set s__Vector2_X[result]=s__Vector2_X[that] * d + s__Vector2_X[this] * k
            set s__Vector2_Y[result]=s__Vector2_Y[that] * d + s__Vector2_X[this] * k
            return result
        endfunction
        function s__Vector2_IsBetween takes integer this,integer begin,integer end returns boolean
            if ( s__Vector2_X[begin] != s__Vector2_X[end] ) then
                return ( s__Vector2_X[begin] <= s__Vector2_X[this] and s__Vector2_X[this] <= s__Vector2_X[end] ) or ( s__Vector2_X[begin] >= s__Vector2_X[this] and s__Vector2_X[this] >= s__Vector2_X[end] )
            endif
            return ( s__Vector2_Y[begin] <= s__Vector2_Y[this] and s__Vector2_Y[this] <= s__Vector2_Y[end] ) or ( s__Vector2_Y[begin] >= s__Vector2_Y[this] and s__Vector2_Y[this] >= s__Vector2_Y[end] )
        endfunction
        function s__Vector2_IsInCircle takes integer this,integer circleOrigin,real circleRadius returns boolean
            return circleRadius >= s__Vector2_GetDistanceWith(this,circleOrigin)
        endfunction
        function s__Vector2_ToString takes integer this returns string
            return "(" + s__Convert_Real2S(s__Vector2_X[this] , 6) + "," + s__Convert_Real2S(s__Vector2_Y[this] , 6) + ")"
        endfunction
        function s__Vector2_onInit takes nothing returns nothing
            set s__Vector2_Zero=s__Vector2_Reset(s__Vector2__allocate(),0 , 0)
            set s__Vector2_UnitX=s__Vector2_Reset(s__Vector2__allocate(),1 , 0)
            set s__Vector2_UnitY=s__Vector2_Reset(s__Vector2__allocate(),0 , 1)
            set s__Vector2_UnitScale=s__Vector2_Reset(s__Vector2__allocate(),1 , 1)
            set s__Vector2_NegativeUnitX=s__Vector2_Reset(s__Vector2__allocate(),- 1 , 0)
            set s__Vector2_NegativeUnitY=s__Vector2_Reset(s__Vector2__allocate(),0 , - 1)
            set s__Vector2_Temp=s__Vector2_Reset((0),0 , 0)
        endfunction
        function s__Vector3_create takes nothing returns integer
            local integer this=s__Vector2__allocate()
            set s__Vector3_Vector2[this]=this
            return this
        endfunction
        function s__Vector3_destroy takes integer this returns nothing
            call s__Vector2_deallocate(s__Vector3_Vector2[this])
        endfunction
        function s__Vector3__lessthan takes integer this,integer that returns boolean
            return s__Vector2_X[s__Vector3_Vector2[this]] < s__Vector2_X[s__Vector3_Vector2[that]] and s__Vector2_Y[s__Vector3_Vector2[this]] < s__Vector2_Y[s__Vector3_Vector2[that]] and s__Vector3_Z[this] < s__Vector3_Z[that]
        endfunction
        function s__Vector3__get_SquaredLength takes integer this returns real
            return s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_X[s__Vector3_Vector2[this]] + s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[this]] + s__Vector3_Z[this] * s__Vector3_Z[this]
        endfunction
        function s__Vector3__get_Length takes integer this returns real
            return (SquareRoot(((s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_X[s__Vector3_Vector2[this]] + s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[this]] + s__Vector3_Z[this] * s__Vector3_Z[this])*1.0))) // INLINED!!
        endfunction
        function s__Vector3__set_Length takes integer this,real value returns nothing
            call sc__Vector3_Scale(this,value * s__Math_InvSqrt(s__Vector3__get_SquaredLength(this)))
        endfunction
        function s__Vector3__get_Azimuth takes integer this returns real
            return s__Vector2__get_Angle(s__Vector3_Vector2[this])
        endfunction
        function s__Vector3__set_Azimuth takes integer this,real value returns nothing
            call s__Vector2__set_Angle(s__Vector3_Vector2[this],value)
        endfunction
        function s__Vector3__get_Pitching takes integer this returns real
            return Atan2(s__Vector3_Z[this], s__Math_Hypot(s__Vector2_Y[s__Vector3_Vector2[this]] , s__Vector2_X[s__Vector3_Vector2[this]]))
        endfunction
        function s__Vector3__set_Pitching takes integer this,real value returns nothing
            local real length=s__Vector3__get_Length(this)
            local real angle=s__Vector2__get_Angle(s__Vector3_Vector2[this])
            set s__Vector2_X[s__Vector3_Vector2[this]]=length * Cos(value) * Cos(angle)
            set s__Vector2_Y[s__Vector3_Vector2[this]]=length * Cos(value) * Sin(angle)
            set s__Vector3_Z[this]=length * Sin(value)
        endfunction
        function s__Vector3_Equals takes integer this,integer that returns boolean
            return s__Math_IsZero(s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[that]]) and s__Math_IsZero(s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[that]]) and s__Math_IsZero(s__Vector3_Z[this] - s__Vector3_Z[that])
        endfunction
        function s__Vector3_IsZero takes integer this returns boolean
            return s__Math_IsZero(s__Vector2_X[s__Vector3_Vector2[this]]) and s__Math_IsZero(s__Vector2_Y[s__Vector3_Vector2[this]]) and s__Math_IsZero(s__Vector3_Z[this])
        endfunction
        function s__Vector3_Reset takes integer this,real x,real y,real z returns integer
            set s__Vector2_X[s__Vector3_Vector2[this]]=x
            set s__Vector2_Y[s__Vector3_Vector2[this]]=y
            set s__Vector3_Z[this]=z
            return this
        endfunction
        function s__Vector3_Copy takes integer this,integer that returns integer
            return s__Vector3_Reset(this,s__Vector2_X[s__Vector3_Vector2[that]] , s__Vector2_Y[s__Vector3_Vector2[that]] , s__Vector3_Z[that])
        endfunction
        function s__Vector3_GetCopy takes integer this returns integer
            return s__Vector3_Reset(s__Vector3_create(),s__Vector2_X[s__Vector3_Vector2[this]] , s__Vector2_Y[s__Vector3_Vector2[this]] , s__Vector3_Z[this])
        endfunction
        function s__Vector3_Normalize takes integer this returns real
            local real length=s__Vector3__get_Length(this)
            if ( length != 0 ) then
                call sc__Vector3_Scale(this,1 / length)
            endif
            return length
        endfunction
        function s__Vector3_GetNormalizedCopy takes integer this returns integer
            local integer n=s__Vector3_GetCopy(this)
            call s__Vector3_Normalize(n)
            return n
        endfunction
        function s__Vector3_GetNormal takes integer this returns integer
            local integer perpendicular=sc__Vector3_CrossProduct(this,s__Vector3_UnitX)
            if ( s__Vector3__get_SquaredLength(perpendicular) <= 0 ) then
                call s__Vector2_deallocate(s__Vector3_Vector2[(perpendicular)]) // INLINED!!
                set perpendicular=sc__Vector3_CrossProduct(this,s__Vector3_UnitY)
            endif
            return perpendicular
        endfunction
        function s__Vector3_Swap takes integer this,integer that returns nothing
            local real temp
            set temp=s__Vector2_X[s__Vector3_Vector2[this]]
            set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[that]]
            set s__Vector2_X[s__Vector3_Vector2[that]]=temp
            set temp=s__Vector2_Y[s__Vector3_Vector2[this]]
            set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[that]]
            set s__Vector2_Y[s__Vector3_Vector2[that]]=temp
            set temp=s__Vector3_Z[this]
            set s__Vector3_Z[this]=s__Vector3_Z[that]
            set s__Vector3_Z[that]=temp
        endfunction
        function s__Vector3_GetSquaredDistanceWith takes integer this,integer that returns real
            return ( s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[that]] ) * ( s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[that]] ) + ( s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[that]] ) * ( s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[that]] ) + ( s__Vector3_Z[this] - s__Vector3_Z[that] ) * ( s__Vector3_Z[this] - s__Vector3_Z[that] )
        endfunction
        function s__Vector3_GetDistanceWith takes integer this,integer that returns real
            return (SquareRoot(((( s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[that]] ) * ( s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[that]] ) + ( s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[that]] ) * ( s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[that]] ) + ( s__Vector3_Z[this] - s__Vector3_Z[that] ) * ( s__Vector3_Z[this] - s__Vector3_Z[that] ))*1.0))) // INLINED!!
        endfunction
        function s__Vector3_GetAngleWith takes integer this,integer that returns real
            local real mul=s__Vector3__get_Length(this) * s__Vector3__get_Length(that)
            if ( ( mul == 0 ) ) then
                return 0.0
            endif
            return Acos(( s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_X[s__Vector3_Vector2[that]] + s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[that]] + s__Vector3_Z[this] * s__Vector3_Z[that] ) / mul)
        endfunction
        function s__Vector3_GetMiddle takes integer this,integer that returns integer
            return s__Vector3_Reset(s__Vector3_create(),( s__Vector2_X[s__Vector3_Vector2[this]] + s__Vector2_X[s__Vector3_Vector2[that]] ) / 2 , ( s__Vector2_Y[s__Vector3_Vector2[this]] + s__Vector2_Y[s__Vector3_Vector2[that]] ) / 2 , ( s__Vector3_Z[this] + s__Vector3_Z[that] ) / 2)
        endfunction
        function s__Vector3_MakeFloor takes integer this,integer that returns integer
            if ( s__Vector2_X[s__Vector3_Vector2[that]] < s__Vector2_X[s__Vector3_Vector2[this]] ) then
                set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[that]]
            endif
            if ( s__Vector2_Y[s__Vector3_Vector2[that]] < s__Vector2_Y[s__Vector3_Vector2[this]] ) then
                set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[that]]
            endif
            if ( s__Vector3_Z[that] < s__Vector3_Z[this] ) then
                set s__Vector3_Z[this]=s__Vector3_Z[that]
            endif
            return this
        endfunction
        function s__Vector3_MakeCeil takes integer this,integer that returns integer
            if ( s__Vector2_X[s__Vector3_Vector2[that]] > s__Vector2_X[s__Vector3_Vector2[this]] ) then
                set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[that]]
            endif
            if ( s__Vector2_Y[s__Vector3_Vector2[that]] > s__Vector2_Y[s__Vector3_Vector2[this]] ) then
                set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[that]]
            endif
            if ( s__Vector3_Z[that] > s__Vector3_Z[this] ) then
                set s__Vector3_Z[this]=s__Vector3_Z[that]
            endif
            return this
        endfunction
        function s__Vector3_Add takes integer this,integer that returns integer
            set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[this]] + s__Vector2_X[s__Vector3_Vector2[that]]
            set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[this]] + s__Vector2_Y[s__Vector3_Vector2[that]]
            set s__Vector3_Z[this]=s__Vector3_Z[this] + s__Vector3_Z[that]
            return this
        endfunction
        function s__Vector3_Subtract takes integer this,integer that returns integer
            set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[that]]
            set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[that]]
            set s__Vector3_Z[this]=s__Vector3_Z[this] - s__Vector3_Z[that]
            return this
        endfunction
        function s__Vector3_Scale takes integer this,real factor returns integer
            set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[this]] * factor
            set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[this]] * factor
            set s__Vector3_Z[this]=s__Vector3_Z[this] * factor
            return this
        endfunction
        function s__Vector3_DotProduct takes integer this,integer that returns real
            return s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_X[s__Vector3_Vector2[that]] + s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[that]] + s__Vector3_Z[this] * s__Vector3_Z[that]
        endfunction
        function s__Vector3_CrossProduct takes integer this,integer that returns integer
            local integer result=s__Vector3_create()
            set s__Vector2_X[s__Vector3_Vector2[result]]=s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector3_Z[that] - s__Vector2_Y[s__Vector3_Vector2[that]] * s__Vector3_Z[this]
            set s__Vector2_Y[s__Vector3_Vector2[result]]=s__Vector3_Z[this] * s__Vector2_X[s__Vector3_Vector2[that]] - s__Vector3_Z[that] * s__Vector2_X[s__Vector3_Vector2[this]]
            set s__Vector3_Z[result]=s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[that]] - s__Vector2_X[s__Vector3_Vector2[that]] * s__Vector2_Y[s__Vector3_Vector2[this]]
            return result
        endfunction
        function s__Vector3_Project takes integer this,integer direction returns integer
            local real len2=s__Vector2_X[s__Vector3_Vector2[direction]] * s__Vector2_X[s__Vector3_Vector2[direction]] + s__Vector2_Y[s__Vector3_Vector2[direction]] * s__Vector2_Y[s__Vector3_Vector2[direction]] + s__Vector3_Z[direction] * s__Vector3_Z[direction]
            if ( ( len2 == 0.0 ) ) then
                return 0
            endif
            set len2=( s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_X[s__Vector3_Vector2[direction]] + s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[direction]] + s__Vector3_Z[this] * s__Vector3_Z[direction] ) / len2
            return s__Vector3_Reset(this,s__Vector2_X[s__Vector3_Vector2[direction]] * len2 , s__Vector2_Y[s__Vector3_Vector2[direction]] * len2 , s__Vector3_Z[direction] * len2)
        endfunction
        function s__Vector3_Rotate takes integer this,integer axis,real angle returns integer
            local real xx=0.0
            local real xy=0.0
            local real xz=0.0
            local real yx=0.0
            local real yy=0.0
            local real yz=0.0
            local real zx=0.0
            local real zy=0.0
            local real zz=0.0
            local real al=s__Vector2_X[s__Vector3_Vector2[axis]] * s__Vector2_X[s__Vector3_Vector2[axis]] + s__Vector2_Y[s__Vector3_Vector2[axis]] * s__Vector2_Y[s__Vector3_Vector2[axis]] + s__Vector3_Z[axis] * s__Vector3_Z[axis]
            local real f=0.0
            local real c=Cos(angle)
            local real s=Sin(angle)
            if ( ( al == 0.0 ) ) then
                return this
            endif
            set f=( s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_X[s__Vector3_Vector2[axis]] + s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[axis]] + s__Vector3_Z[this] * s__Vector3_Z[axis] ) / al
            set zx=s__Vector2_X[s__Vector3_Vector2[axis]] * f
            set zy=s__Vector2_Y[s__Vector3_Vector2[axis]] * f
            set zz=s__Vector3_Z[axis] * f
            set xx=s__Vector2_X[s__Vector3_Vector2[this]] - zx
            set xy=s__Vector2_Y[s__Vector3_Vector2[this]] - zy
            set xz=s__Vector3_Z[this] - zz
            set al=SquareRoot(al)
            set yx=( s__Vector2_Y[s__Vector3_Vector2[axis]] * xz - s__Vector3_Z[axis] * xy ) / al
            set yy=( s__Vector3_Z[axis] * xx - s__Vector2_X[s__Vector3_Vector2[axis]] * xz ) / al
            set yz=( s__Vector2_X[s__Vector3_Vector2[axis]] * xy - s__Vector2_Y[s__Vector3_Vector2[axis]] * xx ) / al
            return s__Vector3_Reset(this,xx * c + yx * s + zx , xy * c + yy * s + zy , xz * c + yz * s + zz)
        endfunction
        function s__Vector3_Interpolate takes integer this,integer that,real k returns integer
            local integer result=s__Vector3__allocate()
            local real d=1.0 - k
            set s__Vector2_X[s__Vector3_Vector2[result]]=s__Vector2_X[s__Vector3_Vector2[that]] * d + s__Vector2_X[s__Vector3_Vector2[this]] * k
            set s__Vector2_Y[s__Vector3_Vector2[result]]=s__Vector2_Y[s__Vector3_Vector2[that]] * d + s__Vector2_X[s__Vector3_Vector2[this]] * k
            set s__Vector3_Z[result]=s__Vector3_Z[that] * d + s__Vector3_Z[this] * k
            return result
        endfunction
        function s__Vector3_IsInCylinder takes integer this,integer cylinderOrigin,integer cylinderHeight,real cylinderRadius returns boolean
            local real len2=0.0
            local real x=s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[cylinderOrigin]]
            local real y=s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[cylinderOrigin]]
            local real z=s__Vector3_Z[this] - s__Vector3_Z[cylinderOrigin]
            if ( x * s__Vector2_X[s__Vector3_Vector2[cylinderHeight]] + y * s__Vector2_Y[s__Vector3_Vector2[cylinderHeight]] + z * s__Vector3_Z[cylinderHeight] < 0.0 ) then
                return false
            endif
            set x=x - s__Vector2_X[s__Vector3_Vector2[cylinderHeight]]
            set y=y - s__Vector2_Y[s__Vector3_Vector2[cylinderHeight]]
            set z=z - s__Vector3_Z[cylinderHeight] //  point above cylinder
            if ( x * s__Vector2_X[s__Vector3_Vector2[cylinderHeight]] + y * s__Vector2_Y[s__Vector3_Vector2[cylinderHeight]] + z * s__Vector3_Z[cylinderHeight] > 0.0 ) then
                return false
            endif
            set len2=s__Vector2_X[s__Vector3_Vector2[cylinderHeight]] * s__Vector2_X[s__Vector3_Vector2[cylinderHeight]] + s__Vector2_Y[s__Vector3_Vector2[cylinderHeight]] * s__Vector2_Y[s__Vector3_Vector2[cylinderHeight]] + s__Vector3_Z[cylinderHeight] * s__Vector3_Z[cylinderHeight]
            if ( ( len2 == 0.0 ) ) then
                return false
            endif
            set len2=( x * s__Vector2_X[s__Vector3_Vector2[cylinderHeight]] + y * s__Vector2_Y[s__Vector3_Vector2[cylinderHeight]] + z * s__Vector3_Z[cylinderHeight] ) / len2
            set x=x - s__Vector2_X[s__Vector3_Vector2[cylinderHeight]] * len2
            set y=y - s__Vector2_Y[s__Vector3_Vector2[cylinderHeight]] * len2
            set z=z - s__Vector3_Z[cylinderHeight] * len2 //  point outside cylinder
            return x * x + y * y + z * z <= cylinderRadius * cylinderRadius
        endfunction
        function s__Vector3_IsInCone takes integer this,integer coneOrigin,integer coneHeight,real coneRadius returns boolean
            local real len2=0.0
            local real x=s__Vector2_X[s__Vector3_Vector2[this]] - s__Vector2_X[s__Vector3_Vector2[coneOrigin]]
            local real y=s__Vector2_Y[s__Vector3_Vector2[this]] - s__Vector2_Y[s__Vector3_Vector2[coneOrigin]]
            local real z=s__Vector3_Z[this] - s__Vector3_Z[coneOrigin]
            if ( x * s__Vector2_X[s__Vector3_Vector2[coneHeight]] + y * s__Vector2_Y[s__Vector3_Vector2[coneHeight]] + z * s__Vector3_Z[coneHeight] < 0.0 ) then
                return false
            endif
            set len2=s__Vector2_X[s__Vector3_Vector2[coneHeight]] * s__Vector2_X[s__Vector3_Vector2[coneHeight]] + s__Vector2_Y[s__Vector3_Vector2[coneHeight]] * s__Vector2_Y[s__Vector3_Vector2[coneHeight]] + s__Vector3_Z[coneHeight] * s__Vector3_Z[coneHeight]
            if ( ( len2 == 0.0 ) ) then
                return false
            endif
            set len2=( x * s__Vector2_X[s__Vector3_Vector2[coneHeight]] + y * s__Vector2_Y[s__Vector3_Vector2[coneHeight]] + z * s__Vector3_Z[coneHeight] ) / len2
            set x=x - s__Vector2_X[s__Vector3_Vector2[coneHeight]] * len2
            set y=y - s__Vector2_Y[s__Vector3_Vector2[coneHeight]] * len2
            set z=z - s__Vector3_Z[coneHeight] * len2 //  point outside cone
            return SquareRoot(x * x + y * y + z * z) <= coneRadius * ( 1.0 - len2 )
        endfunction
        function s__Vector3_IsInSphere takes integer this,integer sphereOrigin,real sphereRadius returns boolean
            return sphereRadius >= s__Vector3_GetDistanceWith(this,sphereOrigin)
        endfunction
        function s__Vector3_ToString takes integer this returns string
            return "(" + R2S(s__Vector2_X[s__Vector3_Vector2[this]]) + ", " + R2S(s__Vector2_Y[s__Vector3_Vector2[this]]) + ", " + R2S(s__Vector3_Z[this]) + ")"
        endfunction
        function s__Vector3_onInit takes nothing returns nothing
            set s__Vector3_Zero=s__Vector3_Reset((s__Vector2_Zero),0 , 0 , 0)
            set s__Vector3_UnitX=s__Vector3_Reset((s__Vector2_UnitX),1 , 0 , 0)
            set s__Vector3_UnitY=s__Vector3_Reset((s__Vector2_UnitY),0 , 1 , 0)
            set s__Vector3_UnitZ=s__Vector3_Reset(s__Vector3_create(),0 , 0 , 1)
            set s__Vector3_UnitScale=s__Vector3_Reset((s__Vector2_UnitScale),1 , 1 , 1)
            set s__Vector3_NegativeUnitX=s__Vector3_Reset((s__Vector2_NegativeUnitX),- 1 , 0 , 0)
            set s__Vector3_NegativeUnitY=s__Vector3_Reset((s__Vector2_NegativeUnitY),0 , - 1 , 0)
            set s__Vector3_NegativeUnitZ=s__Vector3_Reset(s__Vector3_create(),0 , 0 , - 1)
            set s__Vector3_Temp=s__Vector3_Reset((s__Vector2_Temp),0 , 0 , 0)
        endfunction
        function s__Block_create takes real a,real b,real c,real d returns integer
            local integer bl=s__Block__allocate()
            set s__Block_Rect[bl]=Rect(a, b, c, d)
            set s__Block_index[bl]=0
            set s__Block_minx[bl]=a
            set s__Block_miny[bl]=b
            set s__Block_maxx[bl]=c
            set s__Block_maxy[bl]=d
            set s__Block_blocks[s__Block_Count]=bl
            set s__Block_Count=s__Block_Count + 1 //BJDebugMsg("end");
            return bl
        endfunction  //移除特效
        function s__Block_remove takes integer this,integer e returns nothing
            set s__SEffect_id[s___Block_List[s__Block_List[this]+s__Block_index[this]]]=s__SEffect_id[e] //移动顶部数据的id到当前的id //移动顶部数据的对象到当前位置
            set s___Block_List[s__Block_List[this]+s__SEffect_id[e]]=s___Block_List[s__Block_List[this]+s__Block_index[this]] //当前区块内成员数-+1
            set s__Block_index[this]=s__Block_index[this] - 1
        endfunction  //添加特效
        function s__Block_add takes integer this,integer e returns nothing
            set s___Block_List[s__Block_List[this]+s__Block_index[this]]=e //更新Effect对象在当前区块的List中的ID
            set s__SEffect_id[e]=s__Block_index[this] //当前区块内成员数量+1
            set s__Block_index[this]=s__Block_index[this] + 1
        endfunction  //返回i位置的Effect
        function s__Block_get takes integer this,integer i returns integer
            return s___Block_List[s__Block_List[this]+i]
        endfunction  //返回用
        function s__Block_CheckOverlap takes real radius,real x_center,real y_center,real x1,real y1,real x2,real y2 returns boolean
            local real x
            local real y
            local real dist_sq
            if ( x_center > x2 ) then
                set x=x2
            elseif ( x_center < x1 ) then
                set x=x1
            else
                set x=x_center
            endif
            if ( y_center > y2 ) then
                set y=y2
            elseif ( y_center < y1 ) then
                set y=y1
            else
                set y=y_center
            endif
            set dist_sq=( x - x_center ) * ( x - x_center ) + ( y - y_center ) * ( y - y_center )
            if ( dist_sq <= radius * radius ) then
                return true
            endif
            return false
        endfunction  //计算所有在范围内的坐标 返回Block数组blocks2 与计数 count2
        function s__Block_GetInLoc takes real x,real y,real r returns nothing
            local integer i=0
            local integer this
            set s__Block_count2=0
            loop
            exitwhen ( i <= s__Block_Count )
                set this=s__Block_blocks[i]
                if ( s__Block_CheckOverlap(r , x , y , s__Block_minx[this] , s__Block_miny[this] , s__Block_maxx[this] , s__Block_maxy[this]) ) then
                    set s__Block_blocks2[s__Block_count2]=this
                    set s__Block_count2=s__Block_count2 + 1
                endif
                set i=i + 1
            endloop
        endfunction  //count2 !=0 的情况下遍历blocks2[0-count2].List[j] 得到Effect -> i = count2;j = 0- blocks2[0-count2].index 
        function s__Map_onInit takes nothing returns nothing
            local integer i=0
            local integer j=0
            local real sx
            local real sy
            local real a
            local real b
            set s__Map_MaxX=GetRectMaxX(GetEntireMapRect())
            set s__Map_MaxY=GetRectMaxY(GetEntireMapRect())
            set s__Map_MinX=GetRectMinX(GetEntireMapRect())
            set s__Map_MinY=GetRectMinY(GetEntireMapRect())
            set s__Map_width=RAbsBJ(s__Map_MaxX) + RAbsBJ(s__Map_MinX)
            set s__Map_height=RAbsBJ(s__Map_MaxY) + RAbsBJ(s__Map_MinY)
            return
        endfunction
        function s__SEffect_create takes string name,real x,real y returns integer
            local integer ect=s__SEffect__allocate()
            set s__SEffect_object[ect]=AddSpecialEffect(name, x, y)
            set s__SEffect_path[ect]=name //记录对象
            set s__SEffect_own[ect]=R2I(x / s__Map_size + 0.5) * s__Map_blockMaxX + R2I(y / s__Map_size + 0.5) //区块添加对象
            call s__Block_add(s__Block_blocks[s__SEffect_own[ect]],ect) //返回
            return ect
        endfunction  //获取特效路径
        function s__SEffect_getPath takes integer this returns string
            return s__SEffect_path[this]
        endfunction
        function s__SEffect_x takes integer this returns real
            return EXGetEffectX(s__SEffect_object[this])
        endfunction
        function s__SEffect_y takes integer this returns real
            return EXGetEffectY(s__SEffect_object[this])
        endfunction
        function s__SEffect_z takes integer this returns real
            return EXGetEffectZ(s__SEffect_object[this])
        endfunction
        function s__SEffect_setXY takes integer this,real x,real y returns nothing
            call EXSetEffectXY(s__SEffect_object[this], x, y)
            set s__SEffect_TI=R2I(x / s__Map_size + 0.5) * s__Map_blockMaxX + R2I(y / s__Map_size + 0.5)
            if ( s__SEffect_TI != s__SEffect_own[this] ) then
                call s__Block_remove(s__Block_blocks[s__SEffect_own[this]],this) //为旧区块移除对象
                set s__SEffect_own[this]=s__SEffect_TI //为新区块增加对象
                call s__Block_add(s__Block_blocks[s__SEffect_own[this]],this)
            endif
        endfunction  //设置Z
        function s__SEffect_setZ takes integer this,real z returns nothing
            call EXSetEffectZ(s__SEffect_object[this], z)
        endfunction
        function s__SEffect_setFacting takes integer this,real f returns nothing
            call sc__SEffect_SetRotateZ(s__SEffect_object[this] , f)
        endfunction
        function s__SEffect_size takes integer this returns real
            return EXGetEffectSize(s__SEffect_object[this])
        endfunction
        function s__SEffect_setSize takes integer this,real size returns nothing
            call EXSetEffectSize(s__SEffect_object[this], size)
        endfunction
        function s__SEffect_getHandle takes integer this returns integer
            return GetHandleId(s__SEffect_object[this])
        endfunction
        function s__SEffect_replaceEffect takes integer this,effect e returns nothing
            call EXSetEffectZ(s__SEffect_object[(this)], ((999999)*1.0)) // INLINED!!
            call DestroyEffect(s__SEffect_object[this])
            set s__SEffect_object[this]=e
        endfunction  //destroy
        function s__SEffect_onDestroy takes integer this returns nothing
            call DestroyEffect(s__SEffect_object[this]) //为区块移除对象
            call s__Block_remove(s__Block_blocks[s__SEffect_own[this]],this)
        endfunction  //尺寸

//Generated destructor of SEffect
function s__SEffect_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__SEffect_V[this]!=-1) then
        return
    endif
    call s__SEffect_onDestroy(this)
    set si__SEffect_V[this]=si__SEffect_F
    set si__SEffect_F=this
endfunction
        function s__SEffect_Size takes effect e returns real
            return EXGetEffectSize(e)
        endfunction
        function s__SEffect_SetSize takes effect e,real size returns nothing
            call EXSetEffectSize(e, size)
        endfunction
        function s__SEffect_SetRotateZ takes effect e,real z returns nothing
            call EXEffectMatReset(e)
            call EXEffectMatRotateZ(e, z)
        endfunction
        function s__SEffect_GetX takes effect e returns real
            return EXGetEffectX(e)
        endfunction
        function s__SEffect_GetY takes effect e returns real
            return EXGetEffectY(e)
        endfunction
        function s__SEffect_GetZ takes effect e returns real
            return EXGetEffectZ(e)
        endfunction
        function s__SEffect_SetXY takes effect e,real x,real y returns nothing
            call EXSetEffectXY(e, x, y)
        endfunction
        function s__SEffect_SetZ takes effect e,real z returns nothing
            call EXSetEffectZ(e, z)
        endfunction
        function s__SEffect_SetSpeed takes effect e,real s returns nothing
            call EXSetEffectSpeed(e, s)
        endfunction

//library StarCommon ends
//library StarEvent:

    //public:
    function SE_Filter takes nothing returns boolean
        return IsHeroUnitId(GetUnitTypeId(GetFilterUnit()))
    endfunction
    //public:
    function StarEvent__onInit takes nothing returns nothing
        local integer i=0
        call TriggerRegisterAnyUnitEventBJ(StarTrig_OnDie, EVENT_PLAYER_UNIT_DEATH)
        loop
        exitwhen ( i > 4 )
            call TriggerRegisterPlayerUnitEvent(StarTrig_UnitOrder, Player(i), EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, Condition(function SE_Filter))
            call TriggerRegisterPlayerUnitEvent(StarTrig_ItemPickUP, Player(i), EVENT_PLAYER_UNIT_PICKUP_ITEM, Condition(function SE_Filter))
            call TriggerRegisterPlayerUnitEvent(StarTrig_UnitSell, Player(i), EVENT_PLAYER_UNIT_SELL_ITEM, Condition(function SE_Filter))
            set i=i + 1
        endloop // TimerStart(CreateTimer(),0,false,function(){
    endfunction  //     DestroyTimer(GetExpiredTimer()); // });

//library StarEvent ends
//library StarLoadAny:
    function S_Loadunit takes integer i,string s returns unit
        return LoadUnitHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2unit takes string s returns unit
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadUnitHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("unit","Unit")
    function S_Loadeffect takes integer i,string s returns effect
        return LoadEffectHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2effect takes string s returns effect
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadEffectHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("effect","Effect")
    function S_Loadgroup takes integer i,string s returns group
        return LoadGroupHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2group takes string s returns group
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadGroupHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("group","Group")
    function S_Loadplayer takes integer i,string s returns player
        return LoadPlayerHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2player takes string s returns player
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadPlayerHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("player","Player")
    function S_Loadtrigger takes integer i,string s returns trigger
        return LoadTriggerHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2trigger takes string s returns trigger
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadTriggerHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("trigger","Trigger")
    function S_Loadtimer takes integer i,string s returns timer
        return LoadTimerHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2timer takes string s returns timer
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadTimerHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("timer","Timer")
    function S_Loadability takes integer i,string s returns ability
        return LoadAbilityHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2ability takes string s returns ability
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadAbilityHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("ability","Ability")
    function S_Loaditem takes integer i,string s returns item
        return LoadItemHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2item takes string s returns item
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadItemHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("item","Item")
    function S_Loadlocation takes integer i,string s returns location
        return LoadLocationHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2location takes string s returns location
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadLocationHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("location","Location")
    function S_Loaddestructable takes integer i,string s returns destructable
        return LoadDestructableHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2destructable takes string s returns destructable
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadDestructableHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("destructable","Destructable")
    function S_Loadrect takes integer i,string s returns rect
        return LoadRectHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2rect takes string s returns rect
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadRectHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("rect","Rect")
    function S_Loadregion takes integer i,string s returns region
        return LoadRegionHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2region takes string s returns region
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadRegionHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("region","Region")
    function S_Loadtrackable takes integer i,string s returns trackable
        return LoadTrackableHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2trackable takes string s returns trackable
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadTrackableHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("trackable","Trackable")
    function S_Loadsound takes integer i,string s returns sound
        return LoadSoundHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2sound takes string s returns sound
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadSoundHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("sound","Sound")
    function S_Loadlightning takes integer i,string s returns lightning
        return LoadLightningHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2lightning takes string s returns lightning
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadLightningHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("lightning","Lightning")
    function S_Loadtexttag takes integer i,string s returns texttag
        return LoadTextTagHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2texttag takes string s returns texttag
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadTextTagHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("texttag","TextTag")
    function S_Loaddialog takes integer i,string s returns dialog
        return LoadDialogHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2dialog takes string s returns dialog
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadDialogHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("dialog","Dialog")
    function S_Loadbutton takes integer i,string s returns button
        return LoadButtonHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2button takes string s returns button
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadButtonHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("button","Button")
    function S_Loadmultiboard takes integer i,string s returns multiboard
        return LoadMultiboardHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2multiboard takes string s returns multiboard
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadMultiboardHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("multiboard","Multiboard")
    function S_Loadmultiboarditem takes integer i,string s returns multiboarditem
        return LoadMultiboardItemHandle(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2multiboarditem takes string s returns multiboarditem
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadMultiboardItemHandle(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny("multiboarditem","MultiboardItem")
    function S_Loadstring takes integer i,string s returns string
        return LoadStr(YDLOC, i, StringHash(s))
    endfunction
    function S_Savestring takes integer i,string s,string v returns nothing
        call SaveStr(YDLOC, i, StringHash(s), v)
    endfunction
    function S_Load2string takes string s returns string
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadStr(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction
    function S_Save2string takes string s,string v returns string
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        call SaveStr(YDLOC, (i ), StringHash(( s )), ( v)) // INLINED!!
        return (LoadStr(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny2("string","Str")
    function S_Loadreal takes integer i,string s returns real
        return LoadReal(YDLOC, i, StringHash(s))
    endfunction
    function S_Savereal takes integer i,string s,real v returns nothing
        call SaveReal(YDLOC, i, StringHash(s), v)
    endfunction
    function S_Load2real takes string s returns real
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadReal(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction
    function S_Save2real takes string s,real v returns real
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        call SaveReal(YDLOC, (i ), StringHash(( s )), (( v)*1.0)) // INLINED!!
        return (LoadReal(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny2("real","Real")
    function S_Loadinteger takes integer i,string s returns integer
        return LoadInteger(YDLOC, i, StringHash(s))
    endfunction
    function S_Saveinteger takes integer i,string s,integer v returns nothing
        call SaveInteger(YDLOC, i, StringHash(s), v)
    endfunction
    function S_Load2integer takes string s returns integer
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadInteger(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction
    function S_Save2integer takes string s,integer v returns integer
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        call SaveInteger(YDLOC, (i ), StringHash(( s )), ( v)) // INLINED!!
        return (LoadInteger(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny2("integer","Integer")
    function S_Loadboolean takes integer i,string s returns boolean
        return LoadBoolean(YDLOC, i, StringHash(s))
    endfunction
    function S_Saveboolean takes integer i,string s,boolean v returns nothing
        call SaveBoolean(YDLOC, i, StringHash(s), v)
    endfunction
    function S_Load2boolean takes string s returns boolean
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadBoolean(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction
    function S_Save2boolean takes string s,boolean v returns boolean
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        call SaveBoolean(YDLOC, (i ), StringHash(( s )), ( v)) // INLINED!!
        return (LoadBoolean(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny2("boolean","Boolean")
    function S_Save3integer takes integer i,integer s returns integer
        set i=GetHandleId(GetTriggeringTrigger()) * i
        call SaveInteger(YDLOC, i, s, LoadInteger(YDLOC, i, s) + 1)
        return LoadInteger(YDLOC, i, s) - 1
    endfunction  //逆天计时器
    function S_Save3integer2 takes integer i,integer s returns integer
        set i=GetHandleId(GetExpiredTimer())
        call SaveInteger(YDLOC, i, s, LoadInteger(YDLOC, i, s) + 1)
        return LoadInteger(YDLOC, i, s) - 1
    endfunction  //逆天触发器
    function S_Save3integer3 takes integer i,integer s returns integer
        set i=GetHandleId(GetTriggeringTrigger())
        call SaveInteger(YDLOC, i, s, LoadInteger(YDLOC, i, s) + 1)
        return LoadInteger(YDLOC, i, s) - 1
    endfunction  //通用
    function S_Save3integer4 takes integer i,integer s returns integer
        if ( i == 0 ) then
            if ( GetTriggeringTrigger() != null ) then
                set i=GetHandleId(GetTriggeringTrigger())
            else
                set i=GetHandleId(GetExpiredTimer())
            endif
        else
            set i=GetHandleId(GetTriggeringTrigger()) * i
        endif
        call SaveInteger(YDLOC, i, s, LoadInteger(YDLOC, i, s) + 1)
        return LoadInteger(YDLOC, i, s) - 1
    endfunction  //textmacro instance: Star_LoadAny3("itemcode","Integer","integer")
    function S_Loaditemcode takes integer i,string s returns integer
        return LoadInteger(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2itemcode takes string s returns integer
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadInteger(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny3("itemcode","Integer","integer")
    function S_Loadabilcode takes integer i,string s returns integer
        return LoadInteger(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2abilcode takes string s returns integer
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadInteger(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny3("abilcode","Integer","integer")
    function S_Loadunitcode takes integer i,string s returns integer
        return LoadInteger(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2unitcode takes string s returns integer
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadInteger(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny3("unitcode","Integer","integer")
    function S_Loaddegree takes integer i,string s returns real
        return LoadReal(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2degree takes string s returns real
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadReal(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny3("degree","Real","real")
    function S_Loadradian takes integer i,string s returns real
        return LoadReal(YDLOC, i, StringHash(s))
    endfunction
    function S_Load2radian takes string s returns real
        local integer i=GetHandleId(GetTriggeringTrigger()) * ( LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76) + 3 )
        return (LoadReal(YDLOC, (i ), StringHash(( s)))) // INLINED!!
    endfunction  //end of: Star_LoadAny3("radian","Real","real")
        function StarLoadAny___anon__0 takes nothing returns nothing
            local timer t=GetExpiredTimer()
            local integer hd=GetHandleId(t)
            local integer s=LoadInteger(StarBaseHT, hd, 0xABCD)
            call RemoveSavedBoolean(YDHT, GetHandleId(LoadUnitHandle(StarBaseHT, hd, 0xABCC)), s)
            call FlushChildHashtable(StarBaseHT, hd)
            call DestroyTimer(t)
            set t=null
        endfunction
    function StarSetBool takes real t,unit u,integer s returns nothing
        local timer t1=CreateTimer()
        call SaveBoolean(YDHT, GetHandleId(u), s, true)
        call SaveInteger(StarBaseHT, GetHandleId(t1), 0xABCD, s)
        call SaveUnitHandle(StarBaseHT, GetHandleId(t1), 0xABCC, u)
        call TimerStart(t1, t, false, function StarLoadAny___anon__0)
        set t1=null
    endfunction

//library StarLoadAny ends
//library X:
//X_GDBC : 坐标间距离 x1 y1 x2 y2
//X_GAFC : 坐标间角度 x1 y1 x2 y2
//X_SetUnitMovable 设置单位是否可以移动
//X_GetAbleX 在检测可通行性之后 获取可通行的X坐标
//X_GetAbleY 在检测可通行性之后 获取可通行的Y坐标
//R2I2 转换实数为整数[四舍五入]
//X_IsTerrainWalkable x y  坐标可通行
//========================
function X_IsTerrainDeepWater takes real x,real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
endfunction
function X_IsTerrainShallowWater takes real x,real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
endfunction
function X_IsTerrainLand takes real x,real y returns boolean
    return IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
endfunction
function X_IsTerrainPlatform takes real x,real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
endfunction
function X__HideItem takes nothing returns nothing
    if IsItemVisible(GetEnumItem()) then
        set X__Hid[X__HidMax]=GetEnumItem()
        call SetItemVisible(X__Hid[X__HidMax], false)
        set X__HidMax=X__HidMax + 1
    endif
endfunction
function X_IsTerrainWalkable takes real x,real y returns boolean
    //隐藏这个区域内的其他物品，防止物品间的碰撞导致bug
    call MoveRectTo(X__Find, x, y)
    call EnumItemsInRect(X__Find, null, function X__HideItem)
    //物品法检测
    call SetItemPosition(X__Item, x, y) //Unhides the item
set X_X=GetItemX(X__Item)
    set X_Y=GetItemY(X__Item)

        set X_X=X_X
        set X_Y=X_Y

    call SetItemVisible(X__Item, false) //隐藏用来检测的物品 （怀特的另一条腿）
    //显示这个区域的物品
    loop
        exitwhen X__HidMax <= 0
        set X__HidMax=X__HidMax - 1
        call SetItemVisible(X__Hid[X__HidMax], true)
        set X__Hid[X__HidMax]=null
    endloop
    //返回是否可以通行
    return ( X_X - x ) * ( X_X - x ) + ( X_Y - y ) * ( X_Y - y ) <= X__MAX_RANGE * X__MAX_RANGE and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
endfunction
//设置单位可移动性
function X_SetUnitMovable takes unit u,boolean b returns nothing
if b then
    call SetUnitPropWindow(u, GetUnitDefaultPropWindow(u))
else
    call SetUnitPropWindow(u, 0)
endif
endfunction
//坐标间距离 x1 y1 x2 y2
function X_GDBC takes real x1,real y1,real x2,real y2 returns real
    return SquareRoot(( y1 - y2 ) * ( y1 - y2 ) + ( x1 - x2 ) * ( x1 - x2 ))
endfunction
//坐标间角度 x1 y1 x2 y2
function X_GAFC takes real x1,real y1,real x2,real y2 returns real
return Rad2Deg(Atan2(y2 - y1, x2 - x1))
endfunction
//可通行X坐标
function X_GetAbleX takes nothing returns real
return X_X
endfunction
//可通行Y坐标
function X_GetAbleY takes nothing returns real
return X_Y
endfunction
//转换实数为整数(四舍五入)
function X_X_R2I2 takes real r returns integer
    return R2I(r + 0.5)
endfunction
//转换实数为整数(四舍五入)
function R2I2 takes real r returns integer
    return R2I(r + 0.5)
endfunction
//碰撞检测初始化
function X__Init takes nothing returns nothing
    set X__Find=Rect(0., 0., 128., 128.)
    set X__Item=CreateItem(X__DUMMY_ITEM_ID, 0, 0)
    call SetItemVisible(X__Item, false)
endfunction

//library X ends
//library YDTriggerSaveLoadSystem:
                                           
//对应LOCALSET
    function StarYDGetIndex takes trigger trg returns integer
        local integer hd= GetHandleId(trg)
        return hd * LoadInteger(YDLOC, hd, 0xCFDE6C76) + 3
    endfunction
    function YDGetStep2 takes string str,integer step returns integer
        call BJDebugMsg("Error at function YDGetStep2")
        return 0
    endfunction 
    function YDGetStep takes trigger trg,integer step returns integer
        call BJDebugMsg("Error at function YDGetStep")
        return 0
    endfunction 
    
    
    
    
    //获取事件名的code(字符串哈希)
   
    
 
//重启当前计时器
//----------------------------------------------------------------
// 转换StarType1Id到TypeName
//----------------------------------------------------------------
   
    function YDTriggerSaveLoadSystem__Init takes nothing returns nothing
            set YDHT=InitHashtable()
        set YDLOC=InitHashtable()
    endfunction

//library YDTriggerSaveLoadSystem ends
//library YDWEAbilityState:











 function YDWEGetUnitAbilityState takes unit u,integer abilcode,integer state_type returns real
		return EXGetAbilityState(EXGetUnitAbility(u, abilcode), state_type)
	endfunction
 function YDWEGetUnitAbilityDataInteger takes unit u,integer abilcode,integer level,integer data_type returns integer
		return EXGetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
 function YDWEGetUnitAbilityDataReal takes unit u,integer abilcode,integer level,integer data_type returns real
		return EXGetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
 function YDWEGetUnitAbilityDataString takes unit u,integer abilcode,integer level,integer data_type returns string
		return EXGetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type)
	endfunction
 function YDWESetUnitAbilityState takes unit u,integer abilcode,integer state_type,real value returns boolean
		return EXSetAbilityState(EXGetUnitAbility(u, abilcode), state_type, value)
	endfunction
 function YDWESetUnitAbilityDataInteger takes unit u,integer abilcode,integer level,integer data_type,integer value returns boolean
		return EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
 function YDWESetUnitAbilityDataReal takes unit u,integer abilcode,integer level,integer data_type,real value returns boolean
		return EXSetAbilityDataReal(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction
 function YDWESetUnitAbilityDataString takes unit u,integer abilcode,integer level,integer data_type,string value returns boolean
		return EXSetAbilityDataString(EXGetUnitAbility(u, abilcode), level, data_type, value)
	endfunction

 function YDWEUnitTransform takes unit u,integer abilcode,integer targetid returns nothing
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityDataInteger(EXGetUnitAbility(u, abilcode), 1, YDWEAbilityState__ABILITY_DATA_UNITID, GetUnitTypeId(u))
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), GetUnitTypeId(u))
		call UnitRemoveAbility(u, abilcode)
		call UnitAddAbility(u, abilcode)
		call EXSetAbilityAEmeDataA(EXGetUnitAbility(u, abilcode), targetid)
		call UnitRemoveAbility(u, abilcode)
	endfunction


 function YDWEGetItemDataString takes integer itemcode,integer data_type returns string
		return EXGetItemDataString(itemcode, data_type)
	endfunction
 function YDWESetItemDataString takes integer itemcode,integer data_type,string value returns boolean
		return EXSetItemDataString(itemcode, data_type, value)
	endfunction

//library YDWEAbilityState ends
//library YDWEEventDamageData:


function YDWEIsEventPhysicalDamage takes nothing returns boolean
return 0 != EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_PHYSICAL)
endfunction
function YDWEIsEventAttackDamage takes nothing returns boolean
return 0 != EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_ATTACK)
endfunction
function YDWEIsEventRangedDamage takes nothing returns boolean
return 0 != EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_RANGED)
endfunction
function YDWEIsEventDamageType takes damagetype damageType returns boolean
return damageType == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))
endfunction
function YDWEIsEventWeaponType takes weapontype weaponType returns boolean
return weaponType == ConvertWeaponType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_WEAPON_TYPE))
endfunction
function YDWEIsEventAttackType takes attacktype attackType returns boolean
return attackType == ConvertAttackType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_ATTACK_TYPE))
endfunction
function YDWESetEventDamage takes real amount returns boolean
return EXSetEventDamage(amount)
endfunction

//library YDWEEventDamageData ends
//library YDWEJapiEffect:













 function YDWESetEffectLoc takes effect e,location loc returns nothing
		call EXSetEffectXY(e, GetLocationX(loc), GetLocationY(loc))
	endfunction

//library YDWEJapiEffect ends
//library YDWEJapiUnit:




 function YDWEUnitAddStun takes unit u returns nothing
		call EXPauseUnit(u, true)
	endfunction
 function YDWEUnitRemoveStun takes unit u returns nothing
		call EXPauseUnit(u, false)
	endfunction

//library YDWEJapiUnit ends
//library YDWEYDWEJapiScript:
	


//library YDWEYDWEJapiScript ends
//library StarBase:

    function GetPlayerNameReal takes player p returns string
        local string str=GetPlayerName(p) + "?"
        set str=SubStringBJ(str, 1, StringLength(str) - 1)
        return str
    endfunction
    //public:
        function LogPut takes string str returns nothing
            call BJDebugMsg(str)
        endfunction
        function R2I45 takes real r returns integer
            return R2I(r + 0.5)
        endfunction
        function Number2Int takes integer number returns integer
            return number
        endfunction  //无法异步执行一个Code
        function StarRunCode takes code c returns nothing
            set StarBase__ta=TriggerAddAction(StarBase__trig, c)
            call TriggerExecute(StarBase__trig)
            call TriggerRemoveAction(StarBase__trig, StarBase__ta)
            set StarBase__ta=null
        endfunction  //运行函数Ex
        function ExcuteFuncEx takes string funcName returns nothing
            call BJDebugMsg("Error at function ExcuteFuncEx")
        endfunction
        function Star_GetTriggerUnit takes nothing returns unit
            return Star_TriggerUnit
        endfunction
        function Star_SetTriggerUnit takes unit u returns nothing
            set Star_TriggerUnit=u
        endfunction
        function Star_GetTargetUnit takes nothing returns unit
            return Star_TargetUnit
        endfunction
        function Star_SetTargetUnit takes unit u returns nothing
            set Star_TargetUnit=u
        endfunction
        function Star_GetSourceUnit takes nothing returns unit
            return Star_SourceUnit
        endfunction
        function Star_SetSourceUnit takes unit u returns nothing
            set Star_SourceUnit=u
        endfunction
        function Star_GetTriggerEffect takes nothing returns effect
            return Star_TriggerEffect
        endfunction
        function Star_SetTriggerEffect takes effect e returns nothing
            set Star_TriggerEffect=e
        endfunction
        function Star_GetTargetEffect takes nothing returns effect
            return Star_TargetEffect
        endfunction
        function Star_SetTargetEffect takes effect e returns nothing
            set Star_TargetEffect=e
        endfunction
        function Star_GetTriggerItem takes nothing returns item
            return Star_TriggerItem
        endfunction
        function Star_SetTriggerItem takes item ite returns nothing
            set Star_TriggerItem=ite
        endfunction
        function Star_CoordinateX takes real x returns real
            return RMinBJ(RMaxBJ(x, s__Map_MinX), s__Map_MaxX)
        endfunction  //修正Y坐标
        function Star_CoordinateY takes real y returns real
            return RMinBJ(RMaxBJ(y, s__Map_MinY), s__Map_MaxY)
        endfunction  //获取坐标的Z轴高度
        function Star_GetLocZ takes real x,real y returns real
            call MoveLocation(Star_Location, x, y) // if(Star_Location==null){Star_Location = Location(x,y);} //else{MoveLocation(Star_Location,x,y);}
            return GetLocationZ(Star_Location)
        endfunction
        function GetRectByHandle takes integer i returns rect
            call FlushChildHashtable(StarBaseHT, 2)
            call SaveFogStateHandle(StarBaseHT, 2, 1, ConvertFogState(i))
            return LoadRectHandle(StarBaseHT, 2, 1)
        endfunction
        function SCreateEffect takes string p,real x,real y returns effect
            return AddSpecialEffect(p, x, y)
        endfunction
    function StarBase__onInit takes nothing returns nothing
        call Number2Int(1) // StarRunCode(c);
    endfunction

//library StarBase ends
//library StarOverSpeed:
            function s__StarOverSpeed__StarOverSpeedGenerator_anon__0 takes nothing returns nothing
                local integer i=LoadInteger(StarBaseHT, GetHandleId(GetTriggeringTrigger()), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
                local integer this=i
                set s__StarOverSpeed__StarOverSpeedGenerator_tx[this]=GetOrderPointX()
                set s__StarOverSpeed__StarOverSpeedGenerator_ty[this]=GetOrderPointY()
            endfunction
        function s__StarOverSpeed__StarOverSpeedGenerator_create takes unit u,real s,boolean b returns integer
            local integer this
            if ( not ( HaveSavedInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey) ) ) then
                set this=s__StarOverSpeed__StarOverSpeedGenerator__allocate()
                call SaveInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey, this)
                set s__StarOverSpeed__StarOverSpeedGenerator_u[this]=u
                set s__StarOverSpeed__StarOverSpeedGenerator_speed[this]=s
                set s__StarOverSpeed__StarOverSpeedGenerator_t[this]=CreateTrigger()
                call SaveInteger(StarBaseHT, GetHandleId(s__StarOverSpeed__StarOverSpeedGenerator_t[this]), s__StarOverSpeed__StarOverSpeedGenerator_hashkey, this)
                call TriggerAddAction(s__StarOverSpeed__StarOverSpeedGenerator_t[this], function s__StarOverSpeed__StarOverSpeedGenerator_anon__0)
                call TriggerRegisterUnitEvent(s__StarOverSpeed__StarOverSpeedGenerator_t[this], u, EVENT_UNIT_ISSUED_POINT_ORDER) //设置变量结束
                set s__StarOverSpeed__StarOverSpeedGenerator_list[s__StarOverSpeed__StarOverSpeedGenerator_count]=this //--------------压栈-------------- 无需改动
                set s__StarOverSpeed__StarOverSpeedGenerator_count=s__StarOverSpeed__StarOverSpeedGenerator_count + 1 //检查中心计时器运行状态
                call TriggerEvaluate(st__StarOverSpeed__StarOverSpeedGenerator_Start) // INLINED!!
                return this
            else
                return LoadInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            endif
        endfunction  //
        function s__StarOverSpeed__StarOverSpeedGenerator_doEvent takes integer this,integer i returns nothing
            local real x
            local real y
            local real f
            local real d
            local real dis
            local real dis2
            local real s
            local real s2
            set x=GetUnitX(s__StarOverSpeed__StarOverSpeedGenerator_u[this])
            set y=GetUnitY(s__StarOverSpeed__StarOverSpeedGenerator_u[this])
            if ( GetUnitCurrentOrder(s__StarOverSpeed__StarOverSpeedGenerator_u[this]) == 851971 or GetUnitCurrentOrder(s__StarOverSpeed__StarOverSpeedGenerator_u[this]) == 851986 ) then
                set s=s__StarOverSpeed__StarOverSpeedGenerator_speed[this] - GetUnitMoveSpeed(s__StarOverSpeed__StarOverSpeedGenerator_u[this])
                set s2=s / 50
                set dis=s__Math_GDBC(x , y , s__StarOverSpeed__StarOverSpeedGenerator_lx[this] , s__StarOverSpeed__StarOverSpeedGenerator_ly[this])
                set dis2=s__Math_GDBC(x , y , s__StarOverSpeed__StarOverSpeedGenerator_tx[this] , s__StarOverSpeed__StarOverSpeedGenerator_ty[this])
                set f=GetUnitFacing(s__StarOverSpeed__StarOverSpeedGenerator_u[this])
                if ( dis > ( GetUnitMoveSpeed(s__StarOverSpeed__StarOverSpeedGenerator_u[this]) / 60 ) ) then
                    if ( RAbsBJ(f) - RAbsBJ(s__StarOverSpeed__StarOverSpeedGenerator_lf[this]) < 2 ) then
                        if ( dis2 > s2 ) then
                            set d=s__Math_GAFC(s__StarOverSpeed__StarOverSpeedGenerator_lx[this] , s__StarOverSpeed__StarOverSpeedGenerator_ly[this] , x , y)
                            set s__StarOverSpeed__StarOverSpeedGenerator_lx[this]=x + CosBJ(d) * s2
                            set s__StarOverSpeed__StarOverSpeedGenerator_ly[this]=y + SinBJ(d) * s2
                            if ( not ( X_IsTerrainWalkable(s__StarOverSpeed__StarOverSpeedGenerator_lx[this] , s__StarOverSpeed__StarOverSpeedGenerator_ly[this]) ) ) then
                                set s__StarOverSpeed__StarOverSpeedGenerator_lx[this]=(X_X) // INLINED!!
                                set s__StarOverSpeed__StarOverSpeedGenerator_ly[this]=(X_Y) // INLINED!!
                            endif
                            call SetUnitX(s__StarOverSpeed__StarOverSpeedGenerator_u[this], s__StarOverSpeed__StarOverSpeedGenerator_lx[this])
                            call SetUnitY(s__StarOverSpeed__StarOverSpeedGenerator_u[this], s__StarOverSpeed__StarOverSpeedGenerator_ly[this])
                        else
                            set s__StarOverSpeed__StarOverSpeedGenerator_lx[this]=s__StarOverSpeed__StarOverSpeedGenerator_tx[this]
                            set s__StarOverSpeed__StarOverSpeedGenerator_ly[this]=s__StarOverSpeed__StarOverSpeedGenerator_ty[this]
                            if ( not ( X_IsTerrainWalkable(s__StarOverSpeed__StarOverSpeedGenerator_lx[this] , s__StarOverSpeed__StarOverSpeedGenerator_ly[this]) ) ) then
                                set s__StarOverSpeed__StarOverSpeedGenerator_lx[this]=(X_X) // INLINED!!
                                set s__StarOverSpeed__StarOverSpeedGenerator_ly[this]=(X_Y) // INLINED!!
                            endif
                            call SetUnitX(s__StarOverSpeed__StarOverSpeedGenerator_u[this], s__StarOverSpeed__StarOverSpeedGenerator_lx[this])
                            call SetUnitY(s__StarOverSpeed__StarOverSpeedGenerator_u[this], s__StarOverSpeed__StarOverSpeedGenerator_ly[this])
                        endif
                    else
                        set s__StarOverSpeed__StarOverSpeedGenerator_lx[this]=x
                        set s__StarOverSpeed__StarOverSpeedGenerator_ly[this]=y
                    endif
                else
                    set s__StarOverSpeed__StarOverSpeedGenerator_lx[this]=x
                    set s__StarOverSpeed__StarOverSpeedGenerator_ly[this]=y
                endif
                set s__StarOverSpeed__StarOverSpeedGenerator_lf[this]=f
            else
                set s__StarOverSpeed__StarOverSpeedGenerator_lx[this]=x
                set s__StarOverSpeed__StarOverSpeedGenerator_ly[this]=y
            endif
        endfunction
        function s__StarOverSpeed__StarOverSpeedGenerator_onDestroy takes integer this returns nothing
            call RemoveSavedInteger(StarBaseHT, GetHandleId(s__StarOverSpeed__StarOverSpeedGenerator_t[this]), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            call RemoveSavedInteger(StarBaseHT, GetHandleId(s__StarOverSpeed__StarOverSpeedGenerator_u[this]), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            call DestroyTrigger(s__StarOverSpeed__StarOverSpeedGenerator_t[this])
            set s__StarOverSpeed__StarOverSpeedGenerator_u[this]=null //------------------出栈--------------
            if ( s__StarOverSpeed__StarOverSpeedGenerator_now != s__StarOverSpeed__StarOverSpeedGenerator_count - 1 ) then
                set s__StarOverSpeed__StarOverSpeedGenerator_skip=true
                set s__StarOverSpeed__StarOverSpeedGenerator_list[s__StarOverSpeed__StarOverSpeedGenerator_now]=s__StarOverSpeed__StarOverSpeedGenerator_list[s__StarOverSpeed__StarOverSpeedGenerator_count - 1]
            endif
            set s__StarOverSpeed__StarOverSpeedGenerator_count=s__StarOverSpeed__StarOverSpeedGenerator_count - 1
        endfunction  //-------------- 无需改动--------------------

//Generated destructor of StarOverSpeed__StarOverSpeedGenerator
function s__StarOverSpeed__StarOverSpeedGenerator_deallocate takes integer this returns nothing
    if this==null then
        return
    elseif (si__StarOverSpeed__StarOverSpeedGenerator_V[this]!=-1) then
        return
    endif
    call s__StarOverSpeed__StarOverSpeedGenerator_onDestroy(this)
    set si__StarOverSpeed__StarOverSpeedGenerator_V[this]=si__StarOverSpeed__StarOverSpeedGenerator_F
    set si__StarOverSpeed__StarOverSpeedGenerator_F=this
endfunction
            function s__StarOverSpeed__StarOverSpeedGenerator_anon__1 takes nothing returns nothing
                local integer i=0
                loop
                exitwhen ( i >= s__StarOverSpeed__StarOverSpeedGenerator_count )
                    set s__StarOverSpeed__StarOverSpeedGenerator_now=i
                    call s__StarOverSpeed__StarOverSpeedGenerator_doEvent(s__StarOverSpeed__StarOverSpeedGenerator_list[i],i)
                    if ( s__StarOverSpeed__StarOverSpeedGenerator_skip ) then
                        set s__StarOverSpeed__StarOverSpeedGenerator_skip=false
                        set i=i - 1
                    endif
                    set i=i + 1
                endloop //没有子成员,停止计时器
                if ( s__StarOverSpeed__StarOverSpeedGenerator_count == 0 ) then
                    call TriggerEvaluate(st__StarOverSpeed__StarOverSpeedGenerator_Stop) // INLINED!!
                endif
            endfunction
        function s__StarOverSpeed__StarOverSpeedGenerator_Start takes nothing returns nothing
            if ( not ( s__StarOverSpeed__StarOverSpeedGenerator_IsRun ) ) then
                call TimerStart(s__StarOverSpeed__StarOverSpeedGenerator_Timer, 0.02, true, function s__StarOverSpeed__StarOverSpeedGenerator_anon__1)
                set s__StarOverSpeed__StarOverSpeedGenerator_IsRun=true
            endif
        endfunction  //-------------- 无需改动--------------------
        function s__StarOverSpeed__StarOverSpeedGenerator_Stop takes nothing returns nothing
            if ( s__StarOverSpeed__StarOverSpeedGenerator_IsRun ) then
                call PauseTimer(s__StarOverSpeed__StarOverSpeedGenerator_Timer)
                set s__StarOverSpeed__StarOverSpeedGenerator_IsRun=false
            endif
        endfunction  //-------------- 无需改动--------------------
        function s__StarOverSpeed__StarOverSpeedGenerator_onInit takes nothing returns nothing
            set s__StarOverSpeed__StarOverSpeedGenerator_Timer=CreateTimer()
        endfunction
    function SOS_SetUnitSpeed takes unit u,real s,boolean b returns integer
        local integer this
        if ( HaveSavedInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey) ) then
            set this=LoadInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            set s__StarOverSpeed__StarOverSpeedGenerator_speed[this]=s
            set s__StarOverSpeed__StarOverSpeedGenerator_b[this]=b
        else
            set this=s__StarOverSpeed__StarOverSpeedGenerator_create(u , s , b)
        endif //debug if(this==0){Print("an error at function SOS_SetUnitSpeed overflow of struct");}
        return this
    endfunction  //获取单位当前移动速度 若不在系统中 则返回当前移动速度
    function SOS_GetUnitSpeed takes unit u returns real
        local integer this
        local real s
        if ( HaveSavedInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey) ) then
            set this=LoadInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            set s=s__StarOverSpeed__StarOverSpeedGenerator_speed[this]
        else
            set s=GetUnitMoveSpeed(u)
        endif
        return s
    endfunction  //取消移动速度突破 单位u
    function SOS_UnSetUnitSpeed takes unit u returns nothing
        local integer this
        if ( HaveSavedInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey) ) then
            set this=LoadInteger(StarBaseHT, GetHandleId(u), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            call s__StarOverSpeed__StarOverSpeedGenerator_deallocate(this)
        endif
    endfunction

//library StarOverSpeed ends
//library StarUnit:

    //private:
    function SU_IsUnitInvincible takes unit u returns boolean
        if ( GetUnitAbilityLevel(u, 'Avul') != 0 ) then
            return true
        elseif ( GetUnitAbilityLevel(u, 'Bvul') != 0 ) then
            return true
        elseif ( GetUnitAbilityLevel(u, 'BHds') != 0 ) then
            return true
        endif
        return false
    endfunction
    //public:
        function SU_SetUnitFlyHeight takes unit whichUnit,real newHeight,real rate returns nothing
            call UnitAddAbility(whichUnit, 'Amrf')
            call UnitRemoveAbility(whichUnit, 'Amrf')
            call SetUnitFlyHeight(whichUnit, newHeight, rate)
        endfunction
    function SU_GetHeroAllState takes unit u,boolean b returns real
        return I2R(GetHeroStr(u, b) + GetHeroAgi(u, b) + GetHeroInt(u, b))
    endfunction  //获取单位已经损失的生命值百分比
    function SU_GetUnitLostHPPercent takes unit u returns real
        return ( GetUnitState(u, UNIT_STATE_MAX_LIFE) - GetUnitState(u, UNIT_STATE_LIFE) ) / GetUnitState(u, UNIT_STATE_MAX_LIFE)
    endfunction  //获取单位已经损失的生命值
    function SU_GetUnitLostHP takes unit u returns real
        return GetUnitState(u, UNIT_STATE_MAX_LIFE) - GetUnitState(u, UNIT_STATE_LIFE)
    endfunction  //为单位u添加生命值 值为 value 是否百分比->bool
    function UnitAddHp takes unit u,real value,boolean b returns nothing
        local real hp=GetUnitState(u, UNIT_STATE_LIFE)
        local real maxhp=GetUnitState(u, UNIT_STATE_MAX_LIFE)
        local real bfb=hp / maxhp
        local real t
        if ( b ) then
            set t=maxhp * value //百分比
        else
            set t=value
        endif //增加上限
        call SetUnitState(u, UNIT_STATE_MAX_LIFE, t + maxhp) //设置生命值
        call SetUnitState(u, UNIT_STATE_LIFE, ( GetUnitState(u, UNIT_STATE_MAX_LIFE) * bfb ))
    endfunction  //单位生命周期类型检查-是水元素 如果是水元素 则返回true
    function IsWaterElement takes unit u returns boolean
        return GetUnitAbilityLevel(u, 'BHwe') != 0
    endfunction  //获取单位生命周期ID        
    function GetUnitTimedLifeID takes unit u returns integer
        if ( GetUnitAbilityLevel(u, 'BUan') != 0 ) then //操纵死尸
            return 1
        endif //疾病云雾
        if ( GetUnitAbilityLevel(u, 'Bapl') != 0 ) then
            return 2
        endif //自然之力
        if ( GetUnitAbilityLevel(u, 'BEfn') != 0 ) then
            return 3
        endif //治疗守卫
        if ( GetUnitAbilityLevel(u, 'Bhwd') != 0 ) then
            return 4
        endif //复活死尸
        if ( GetUnitAbilityLevel(u, 'Brai') != 0 ) then
            return 5
        endif //水元素
        if ( GetUnitAbilityLevel(u, 'BHwe') != 0 ) then
            return 6
        endif //定时的生命
        if ( GetUnitAbilityLevel(u, 'BTLF') != 0 ) then
            return 7
        endif //什么也不是
        return 0
    endfunction  //转换整数为生命周期枚举ID -> GUI封装
    function I2TimedLifeID takes integer i returns integer
        return i
    endfunction  //转换整数地址为单位
    function GetUnitByHandle takes integer i returns unit
        call FlushChildHashtable(StarUnit__HT, 2)
        call SaveFogStateHandle(StarUnit__HT, 2, 1, ConvertFogState(i))
        set CallBackUnit=LoadUnitHandle(StarUnit__HT, 2, 1)
        return CallBackUnit
    endfunction
    function GetDestructableByHandle takes integer i returns destructable
        call FlushChildHashtable(StarUnit__HT, 2)
        call SaveFogStateHandle(StarUnit__HT, 2, 1, ConvertFogState(i))
        set CallBackDestructable=LoadDestructableHandle(StarUnit__HT, 2, 1)
        return CallBackDestructable
    endfunction
    function Item2Unit takes item wp returns unit
        local integer i=GetHandleId(wp)
        call FlushChildHashtable(StarUnit__HT, 2)
        call SaveFogStateHandle(StarUnit__HT, 2, 1, ConvertFogState(i))
        call printi(LoadInteger(StarUnit__HT, 2, 1))
        set CallBackUnit=LoadUnitHandle(StarUnit__HT, 2, 1)
        return CallBackUnit
    endfunction
    function SU_FHDWInit takes nothing returns nothing
    endfunction  //选取所有单位位置 //存到哈希表 //获取单位模型文件路径
    function SU_GetUnitModel takes unit u returns string
        local string file=( EXExecuteScript("(require'jass.slk').unit[" + I2S(GetUnitTypeId(u)) + "].file") )
        local string s=""
        if ( HaveSavedString(YDHT, GetHandleId(u), 0x6393E129) ) then
            set file=LoadStr(YDHT, GetHandleId(u), 0x6393E129)
        endif
        set s=SubString(file, StringLength(file) - 4, StringLength(file))
        if ( s != ".mdl" and s != ".mdx" ) then
            set file=file + ".mdl"
        endif
        return file
    endfunction  //获取英雄主属性
    function SU_GetHeroParmary takes unit u returns integer
        local string str=""
        if ( GetHandleId(u) == 0 ) then
            return - 1
        endif
        set str=( EXExecuteScript("(require'jass.slk').unit[" + I2S(GetUnitTypeId(u)) + "].Primary") )
        if ( str == "STR" ) then
            return 0
        endif
        if ( str == "AGI" ) then
            return 1
        endif
        if ( str == "INT" ) then
            return 2
        endif
        return - 1
    endfunction  //增加/设置/英雄属性 typ = 0 add typ = 1 set
    function SU_AddHeroState takes unit u,integer id,integer typ,integer value returns nothing
        if ( id == 0 ) then
            if ( typ == 0 ) then
                call SetHeroStr(u, GetHeroStr(u, false) + value, false)
            else
                call SetHeroStr(u, value, false)
            endif
        endif
        if ( id == 1 ) then
            if ( typ == 0 ) then
                call SetHeroAgi(u, GetHeroAgi(u, false) + value, false)
            else
                call SetHeroAgi(u, value, false)
            endif
        endif
        if ( id == 2 ) then
            if ( typ == 0 ) then
                call SetHeroInt(u, GetHeroInt(u, false) + value, false)
            else
                call SetHeroInt(u, value, false)
            endif
        endif
    endfunction  //获取英雄主属性的数值
    function SU_GetHeroParmaryValue takes unit u returns integer
        local integer typ=SU_GetHeroParmary(u)
        if ( typ == 0 ) then
            return GetHeroStr(u, true)
        elseif ( typ == 1 ) then
            return GetHeroAgi(u, true)
        elseif ( typ == 2 ) then
            return GetHeroInt(u, true)
        endif
        return - 1
    endfunction  //添加英雄三项属性
    function SU_AddHeroAllState takes unit u,integer a,integer b,integer c returns nothing
        call SU_AddHeroState(u , 0 , 0 , a)
        call SU_AddHeroState(u , 1 , 0 , c)
        call SU_AddHeroState(u , 2 , 0 , b)
    endfunction  ///增加/设置/英雄主属性的值 typ: 0 = add  1 = set 2 = sub
    function SU_SetHeroParmaryValue takes unit u,integer typ,integer value returns nothing
        if ( typ == 0 ) then
            call SU_AddHeroState(u , SU_GetHeroParmary(u) , 0 , value)
        elseif ( typ == 1 ) then
            call SU_AddHeroState(u , SU_GetHeroParmary(u) , 1 , value)
        elseif ( typ == 2 ) then
            call SU_AddHeroState(u , SU_GetHeroParmary(u) , 1 , value * - 1)
        endif
    endfunction  //判断英雄主属性
    function SU_HeroISParmary takes unit u,integer i returns boolean
        return ( SU_GetHeroParmary(u) == i )
    endfunction  //这里是单位死亡事件回调
    function SU_UnitOnDie takes unit u returns nothing
    endfunction  //复活单位
    function SU_DotBehindUnit takes real fac,real x,real y,real a,real b returns boolean
        set fac=s__Math_GAFC(x , y , a , b) - fac
        if ( CosBJ(fac) <= - 0.707106 ) then //单位在单位背面
            return true
        endif
        return false
    endfunction  //获取单位和单位间的角度关系
    function SU_GetUnitOfUnit takes unit u,unit tu returns integer
        local real x=GetUnitX(u)
        local real y=GetUnitY(u)
        local real a=GetUnitX(tu)
        local real b=GetUnitY(tu)
        local real fac=s__Math_GAFC(x , y , a , b) - GetUnitFacing(u)
        local real c=CosBJ(fac)
        if ( c >= 0.866025 ) then //单位在单位正面（更小范围）+-30
            return 1
        endif
        if ( c >= 0.707106 ) then //单位在单位正面 +-45
            return 4
        endif
        if ( c <= - 0.866025 ) then //单位在单位背面（更小范围）
            return 2
        endif
        if ( c <= - 0.707106 ) then //单位在单位背面
            return 5
        endif //单位在单位侧面
        return 3
    endfunction
    function SU_IsUnitInfrontUnit2 takes unit u,unit tu returns boolean
        local real x=GetUnitX(u)
        local real y=GetUnitY(u)
        local real a=GetUnitX(tu)
        local real b=GetUnitY(tu)
        local real fac=s__Math_GAFC(x , y , a , b) - GetUnitFacing(u)
        local real c=CosBJ(fac)
        if ( c > 0 ) then
            return true
        endif
        return false
    endfunction  //单位在单位正前方
    function SU_IsUnitInfrontUnit takes unit u,unit tu returns boolean
        if ( SU_GetUnitOfUnit(u , tu) == 1 ) then
            return true
        endif
        return false
    endfunction  //单位在单位正后方
    function SU_IsUnitBehindUnit takes unit u,unit tu returns boolean
        if ( SU_GetUnitOfUnit(u , tu) == 2 ) then
            return true
        endif
        return false
    endfunction  //获取英雄/单位白字攻击力
    function SU_GetUnitWhiteAtk takes unit u,integer a returns real
        local integer i=SU_GetHeroParmaryValue(u)
        local integer v=0
        local real w
        if ( i == 0 ) then
            set v=GetHeroStr(u, true) - GetHeroStr(u, false)
        elseif ( i == 1 ) then
            set v=GetHeroAgi(u, true) - GetHeroAgi(u, false)
        elseif ( i == 2 ) then
            set v=GetHeroInt(u, true) - GetHeroInt(u, false)
        endif
        return GetUnitState(u, ConvertUnitState(0x12)) + GetUnitState(u, ConvertUnitState(0x10)) * ( GetUnitState(u, ConvertUnitState(0x11)) + 1 ) / 2 - ( a * v )
    endfunction
    function SU_GetUnitMoveDis takes unit u,trigger t returns nothing
    endfunction  //检查单位是死亡的 高精度
    function SU_IsUnitDie takes unit u returns boolean
        return ( GetUnitState(u, UNIT_STATE_LIFE) > .405 ) //return !LoadBoolean(StarBaseHT,GetHandleId(u),0x2275B9FE);
    endfunction  //是单位u的敌对单位且非无敌非建筑非死亡
    function SUF_Base_1 takes unit u returns boolean
        local unit fu=GetFilterUnit()
        local boolean b=IsUnitEnemy(fu, GetOwningPlayer(u)) and GetUnitAbilityLevel(fu, 'Avul') == 0 and not ( IsUnitType(fu, UNIT_TYPE_STRUCTURE) ) and not ( (GetUnitState((fu), UNIT_STATE_LIFE) > .405) ) // INLINED!!
        set fu=null
        return b
    endfunction
    function SUF_Base_3 takes unit fu,unit u returns boolean
        local boolean b=IsUnitEnemy(fu, GetOwningPlayer(u)) and GetUnitAbilityLevel(fu, 'Avul') == 0 and not ( IsUnitType(fu, UNIT_TYPE_STRUCTURE) ) and not ( (GetUnitState((fu), UNIT_STATE_LIFE) > .405) ) // INLINED!!
        return b
    endfunction  //不是单位u的敌对单位且非无敌非建筑非死亡
    function SUF_Base_2 takes unit u returns boolean
        local unit fu=GetFilterUnit()
        local boolean b=not ( IsUnitEnemy(fu, GetOwningPlayer(u)) ) and GetUnitAbilityLevel(fu, 'Avul') == 0 and not ( IsUnitType(fu, UNIT_TYPE_STRUCTURE) ) and not ( (GetUnitState((fu), UNIT_STATE_LIFE) > .405) ) // INLINED!!
        set fu=null
        return b
    endfunction  //true为显示 false为隐藏
    function SU_ShowOrHideUnit takes unit u,boolean isShow returns nothing
        if ( isShow ) then
            call SetUnitVertexColor(u, 255, 255, 255, 255)
            call SU_SetUnitFlyHeight(u , 999999 , 0)
        else
            call SetUnitVertexColor(u, 255, 255, 255, 0)
            call SU_SetUnitFlyHeight(u , 0 , 0)
        endif
    endfunction  //初始化
        function StarUnit__anon__0 takes nothing returns nothing
            call SaveBoolean(StarBaseHT, GetHandleId(GetTriggerUnit()), 0x2275B9FE, true)
        endfunction  //单位死亡
        function StarUnit__anon__1 takes nothing returns nothing
            call RemoveSavedBoolean(StarBaseHT, GetHandleId(GetTriggerUnit()), 0x2275B9FE)
            if ( not ( IsUnitType(GetTriggerUnit(), UNIT_TYPE_HERO) ) ) then
                call FlushChildHashtable(StarBaseHT, GetHandleId(GetTriggerUnit()))
            endif
        endfunction
        function StarUnit__anon__2 takes nothing returns nothing
            call SaveBoolean(StarBaseHT, GetHandleId(GetFilterUnit()), 0x2275B9FE, true)
        endfunction
    function StarUnit__UnitDieListener takes nothing returns nothing
        local group g=CreateGroup()
        local region rectRegion=CreateRegion()
        call RegionAddRect(rectRegion, bj_mapInitialPlayableArea)
        call TriggerRegisterEnterRegion(StarTrig_EnterMap, rectRegion, null)
        set rectRegion=null
        call TriggerAddAction(StarTrig_EnterMap, function StarUnit__anon__0)
        call TriggerAddAction(StarTrig_OnDie, function StarUnit__anon__1)
        call GroupEnumUnitsInRect(g, GetWorldBounds(), Condition(function StarUnit__anon__2))
        call DestroyGroup(g)
        set g=null
    endfunction  //类型 句柄 名字 增量 增加？ 
    function SU_UserIntDataSetAny takes integer hd,integer i,integer iv,boolean b returns integer
        local integer value
        if ( b ) then
            set value=LoadInteger(YDHT, hd, i) + iv
            call SaveInteger(YDHT, hd, i, value)
        else
            set value=LoadInteger(YDHT, hd, i) - iv
            if ( value <= 0 ) then
                call RemoveSavedInteger(YDHT, hd, i)
            endif
        endif
        return value
    endfunction  // 单位逆天自定义值整数自增带条件
    function SU_UserIntDataSet takes unit u,integer i,integer iv,boolean b returns nothing
        local integer hd=GetHandleId(u)
        if ( b ) then
            call SaveInteger(YDHT, hd, i, LoadInteger(YDHT, hd, i) + iv)
        else
            call SaveInteger(YDHT, hd, i, LoadInteger(YDHT, hd, i) - iv)
            if ( LoadInteger(YDHT, hd, i) <= 0 ) then
                call RemoveSavedInteger(YDHT, hd, i)
            endif
        endif
    endfunction  // 单位逆天自定义值实数自增带条件
    function SU_UserRealDataSet takes unit u,integer i,real iv,boolean b returns nothing
        local integer hd=GetHandleId(u)
        if ( b ) then
            call SaveReal(YDHT, hd, i, LoadReal(YDHT, hd, i) + iv)
        else
            call SaveReal(YDHT, hd, i, LoadReal(YDHT, hd, i) - iv)
            if ( LoadReal(YDHT, hd, i) <= 0 ) then
                call RemoveSavedReal(YDHT, hd, i)
            endif
        endif
    endfunction  //治疗单位 治疗来源 治疗目标 治疗值
    function SU_TreatmentUnit takes unit u,unit tu,real hp returns nothing
        local real a=LoadReal(YDHT, GetHandleId(u), 0xAC305711)
        local real b=LoadReal(YDHT, GetHandleId(tu), 0xAF2E558C)
        local trigger t
        local integer ydl_triggerstep
        local integer i
        local integer index
        local integer hash
        set hp=hp * ( 1 + a + b )
        set hash=0x777199F2 + GetHandleId(u)
        set index=LoadInteger(SUTL_HT, hash, skey_index)
        set i=0
        loop
        exitwhen ( i >= index )
            set t=LoadTriggerHandle(SUTL_HT, hash, i)
            set ydl_triggerstep=GetHandleId(t) * ( LoadInteger(YDLOC, GetHandleId(t), 0xCFDE6C76) + 3 )
            call SaveInteger(YDHT, GetHandleId(t), SKey_PIndex, 0xFA0CA686)
            call SaveReal(YDLOC, ydl_triggerstep, 0x9EE8AA2E, hp)
            call SaveUnitHandle(YDLOC, ydl_triggerstep, 0x5A5B4CBF, u)
            call SaveUnitHandle(YDLOC, ydl_triggerstep, 0xD84480C3, tu)
            call TriggerExecute(t)
            set hp=LoadReal(YDHT, 0xFA0CA686, 0x9EE8AA2E)
        set i=i + 1
        endloop //---------------------------------
        call SetUnitState(tu, UNIT_STATE_LIFE, GetUnitState(tu, UNIT_STATE_LIFE) + hp)
        set t=null
    endfunction
    function SU_InititemAbilityListener_1 takes nothing returns nothing
        local integer hd=GetHandleId(GetTriggerUnit())
        call SaveInteger(StarBaseHT, hd, 0xEFA5C23E, GetSpellAbilityId())
        call SaveReal(StarBaseHT, hd, 0x478F045D, GetSpellTargetX())
        call SaveReal(StarBaseHT, hd, 0xE33A0BC9, GetSpellTargetY())
    endfunction
    //public:
    function SU_AddItemAbilityEvent takes trigger trg returns nothing
        local integer hd=GetHandleId(trg)
        if ( trg == null ) then
            return
        endif
        if ( not ( HaveSavedInteger(YDHT, hd, 0x7E57DD41) ) ) then
            call SaveInteger(YDHT, hd, 0x7E57DD41, StarUnit__su_iatIndex) //i = LoadInteger(YDHT,hd,StrHEX(物品技能事件索引));
            set StarUnit__su_iatList[StarUnit__su_iatIndex]=trg
            set StarUnit__su_iatIndex=StarUnit__su_iatIndex + 1
        endif
    endfunction  //使用物品技能
    function SU_InititemAbilityListener_2 takes nothing returns nothing
        local integer hd=GetHandleId(GetTriggerUnit())
        local integer i=0
        set Star_LastSpellItemAbility=LoadInteger(StarBaseHT, hd, 0xEFA5C23E)
        set Star_LastSpellItemAbilityTargetX=LoadReal(StarBaseHT, hd, 0x478F045D)
        set Star_LastSpellItemAbilityTargetY=LoadReal(StarBaseHT, hd, 0xE33A0BC9)
        if ( StarUnit__su_iatIndex > 0 ) then
            set Star_LastSpellItemAbilityTargetPoint=Location(Star_LastSpellItemAbilityTargetX, Star_LastSpellItemAbilityTargetY)
            loop
            exitwhen ( i >= StarUnit__su_iatIndex )
                if ( StarUnit__su_iatList[i] != null and IsTriggerEnabled(StarUnit__su_iatList[i]) and TriggerEvaluate(StarUnit__su_iatList[i]) ) then
                    call TriggerExecute(StarUnit__su_iatList[i])
                endif
                set i=i + 1
            endloop
        endif
        call RemoveLocation(Star_LastSpellItemAbilityTargetPoint)
        set Star_LastSpellItemAbilityTargetPoint=null
    endfunction
    function SU_InititemAbilityListener takes nothing returns nothing
        call TriggerRegisterAnyUnitEventBJ(StarUnit__su_ItemAbilityTrig, EVENT_PLAYER_UNIT_SPELL_EFFECT) //使用物品
        call TriggerRegisterAnyUnitEventBJ(StarUnit__su_ItemAbilityTrig2, EVENT_PLAYER_UNIT_USE_ITEM)
        call TriggerAddAction(StarUnit__su_ItemAbilityTrig, function SU_InititemAbilityListener_1)
        call TriggerAddAction(StarUnit__su_ItemAbilityTrig2, function SU_InititemAbilityListener_2)
    endfunction
    function StarUnit__onInit takes nothing returns nothing
        if ( YDHT == null ) then
            call BJDebugMsg("YDHT 没有初始化")
            set YDHT=InitHashtable()
        endif
        call StarUnit__UnitDieListener()
        call SU_InititemAbilityListener()
    endfunction

//library StarUnit ends
//library ItmeProperty:
//获取单位属性
function GS_LoadUintProperty takes unit u,integer i returns real
if ( i == 0 ) then //生命
return GetUnitState(u, UNIT_STATE_LIFE)
endif
if ( i == 1 ) then //魔法
return GetUnitState(u, UNIT_STATE_MAX_MANA)
endif
if ( i == 2 ) then //攻击
return GetUnitState(u, ConvertUnitState(0x12))
endif
if ( i == 3 ) then //护甲
return GetUnitState(u, ConvertUnitState(0x20))
endif
if ( i == 4 ) then //攻速
return GetUnitState(u, ConvertUnitState(0x51))
endif
if ( i == 5 ) then //移动
return GetUnitMoveSpeed(u)
endif
return LoadReal(ItmeProperty___HS, GetHandleId(u), i)
endfunction
function GS_LoadUintProperty_B takes unit u,integer i returns real
return GS_LoadUintProperty(u , i)
endfunction
//修改单位属性
function GS_Unit_Pry_change takes unit u,integer i,real r returns nothing
local real HP
if ( u == null or r == 0 ) then
return
endif
if ( i == 0 ) then //生命
set HP=GetUnitLifePercent(u)
call SetUnitState(u, UNIT_STATE_MAX_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE) + ( r * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), 15) ) ))
call SetUnitLifePercentBJ(u, HP)
return
endif
if ( i == 1 ) then //魔法
set HP=GetUnitManaPercent(u)
call SetUnitState(u, UNIT_STATE_MAX_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA) + r)
call SetUnitManaPercentBJ(u, HP)
return
endif
if ( i == 2 ) then //攻击
call SetUnitState(u, ConvertUnitState(0x12), GetUnitState(u, ConvertUnitState(0x12)) + ( r * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), 16) ) ))
return
endif
if ( i == 3 ) then //护甲
call SetUnitState(u, ConvertUnitState(0x20), GetUnitState(u, ConvertUnitState(0x20)) + ( r * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), 17) ) ))
return
endif
if ( i == 4 ) then //攻速
call SetUnitState(u, ConvertUnitState(0x51), GetUnitState(u, ConvertUnitState(0x51)) + r)
return
endif
if ( i == 5 ) then //移动
call SaveReal(ItmeProperty___HS, GetHandleId(u), i, LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r)
call SetUnitMoveSpeed(u, GetUnitDefaultMoveSpeed(u) * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) ))
return
endif
if ( i == 13 ) then //百分比生命
set HP=GetUnitLifePercent(u)
call SetUnitState(u, UNIT_STATE_MAX_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE) / ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) ) * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r ))
call SetUnitLifePercentBJ(u, HP)
call SaveReal(ItmeProperty___HS, GetHandleId(u), i, LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r)
return
endif
if ( i == 14 ) then //百分比攻击
if r < 0 then
call SetUnitState(u, ConvertUnitState(0x12), GetUnitState(u, ConvertUnitState(0x12)) / ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) ) * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r ))
else
call SetUnitState(u, ConvertUnitState(0x12), GetUnitState(u, ConvertUnitState(0x12)) / ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) ) * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r ) + 1)
endif
call SaveReal(ItmeProperty___HS, GetHandleId(u), i, LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r)
return
endif
if ( i == 15 ) then //百分比护甲
call SetUnitState(u, ConvertUnitState(0x20), GetUnitState(u, ConvertUnitState(0x20)) / ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) ) * ( 1 + LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r ))
call SaveReal(ItmeProperty___HS, GetHandleId(u), i, LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r)
return
endif
if ( i == 16 ) then
call ModifyHeroStat(bj_HEROSTAT_STR, u, bj_MODIFYMETHOD_ADD, R2I(r))
call GS_Unit_Pry_change(u , 0 , r * 5)
return
endif
if ( i == 17 ) then
call ModifyHeroStat(bj_HEROSTAT_AGI, u, bj_MODIFYMETHOD_ADD, R2I(r))
call GS_Unit_Pry_change(u , 2 , r * 0.3)
call GS_Unit_Pry_change(u , 3 , r)
return
endif
if ( i == 18 ) then
call ModifyHeroStat(bj_HEROSTAT_INT, u, bj_MODIFYMETHOD_ADD, R2I(r))
call GS_Unit_Pry_change(u , 5 , r * 0.5)
return
endif
call SaveReal(ItmeProperty___HS, GetHandleId(u), i, LoadReal(ItmeProperty___HS, GetHandleId(u), i) + r)
endfunction
function GS_UnitPry takes unit u,integer change,integer ptytype,real r returns nothing
if change == 1 then
set r=0 - r
endif
call GS_Unit_Pry_change(u , ptytype , r)
endfunction
function GS_UnitPryB takes unit u,integer change,integer ptytype,real r returns nothing
call GS_UnitPry(u , change , ptytype , r)
endfunction
//初始化增加属性
function GS_UintPty_ini2 takes unit u returns nothing
if ( IsUnitType(u, UNIT_TYPE_HERO) == false ) then
return
endif
call GS_UnitPry(u , 0 , 0 , I2R(GetHeroStr(u, true)) * 5)
call GS_UnitPry(u , 0 , 2 , I2R(GetHeroAgi(u, true)) * 1)
call GS_UnitPry(u , 0 , 3 , I2R(GetHeroAgi(u, true)) * 0.3)
call GS_UnitPry(u , 0 , 1 , I2R(GetHeroInt(u, true)) * 5)
endfunction
//物品单项属性
function GS_item_Property takes item itm,integer ptytype,integer change,real r returns nothing
local unit u= LoadUnitHandle(ItmeProperty___HS, 0, GetHandleId(itm))
if ( change == 0 ) then
call SaveReal(ItmeProperty___HS, GetHandleId(itm), ptytype, LoadReal(ItmeProperty___HS, GetHandleId(itm), ptytype) + r)
endif
if ( change == 1 ) then
call SaveReal(ItmeProperty___HS, GetHandleId(itm), ptytype, LoadReal(ItmeProperty___HS, GetHandleId(itm), ptytype) - r)
endif
if ( change == 2 ) then
call SaveReal(ItmeProperty___HS, GetHandleId(itm), ptytype, r)
endif
call GS_UnitPry(u , change , ptytype , LoadReal(ItmeProperty___HS, GetHandleId(itm), ptytype))
set u=null
endfunction
function GS_item_Property_B takes item itm,integer i1,integer i2,real r returns nothing
call GS_item_Property(itm , i1 , i2 , r)
endfunction
//*获得物品
function item_eve takes nothing returns nothing
local item itm= GetManipulatedItem()
local unit u= GetTriggerUnit()
local integer a= 0
local integer change= 0
local real data
if ( ( IsItemPowerup(GetManipulatedItem()) == true ) ) then
call RemoveItem(GetManipulatedItem())
return
endif
if ( ( EVENT_PLAYER_UNIT_PICKUP_ITEM == GetTriggerEventId() ) == true ) then
set change=0
call SaveUnitHandle(ItmeProperty___HS, 0, GetHandleId(itm), GetTriggerUnit())
else
set change=1
call FlushChildHashtableBJ(0, ItmeProperty___HS)
endif

set u=null
set itm=null
endfunction
//初始化
function item_init takes nothing returns nothing
local trigger t1= CreateTrigger()
local trigger t2= CreateTrigger()
call TriggerRegisterAnyUnitEventBJ(t1, EVENT_PLAYER_UNIT_PICKUP_ITEM)
call TriggerAddAction(t1, function item_eve)
call TriggerRegisterAnyUnitEventBJ(t2, EVENT_PLAYER_UNIT_DROP_ITEM)
call TriggerAddAction(t2, function item_eve)
endfunction

//library ItmeProperty ends
//library STES:

    //public:
        function STES_GetTable takes nothing returns hashtable
            return STES__HT
        endfunction  //为触发器注册自定义事件 事件名 = name
        function STES_Register takes trigger t,string name returns nothing
            local integer hash=StringHash(name)
            local integer hd=GetHandleId(t)
            local integer index=LoadInteger(STES__HT, hash, skey_index)
            local integer index2=LoadInteger(STES__HT, hd, skey_index)
            call SaveTriggerHandle(STES__HT, hash, index, t) //保存触发器//index += 1; //保存计数
            call SaveInteger(STES__HT, hash, skey_index, index + 1) //触发器上绑定对应事件
            call SaveStr(STES__HT, hd, index2, name) //保存事件 //保存事件计数
            call SaveInteger(STES__HT, hd, skey_index, index2 + 1) //SaveInteger(HT,hd,skey_count,index)//保存事件计数
        endfunction  ///注册事件Ex
        function STES_RegisterEx takes string funcName,string eventName returns nothing
            local integer hash=StringHash(eventName)
            local integer hd=StringHash(funcName)
            local integer index=LoadInteger(STES__HT, hash, skey_indexEx)
            local integer index2=LoadInteger(STES__HT, hd, skey_indexEx)
            call SaveStr(STES__HT, hash, index, funcName) //保存函数名//index += 1; //保存计数
            call SaveInteger(STES__HT, hash, skey_indexEx, index + 1) //函数上绑定对应事件
            call SaveStr(STES__HT, hd, index2, eventName) //保存事件 //保存事件计数
            call SaveInteger(STES__HT, hd, skey_indexEx, index2 + 1)
        endfunction  //无参版本 有参版本写在dll里面
        function STES_Execute takes string name returns nothing
            local integer hash=StringHash(name)
            local integer index=LoadInteger(STES__HT, hash, skey_index)
            local integer i=0
            local trigger t
            loop
            exitwhen ( i >= index )
                set t=LoadTriggerHandle(STES__HT, hash, i) //运行触发器t
                if ( TriggerEvaluate(t) ) then
                    call TriggerExecute(t)
                endif
                set i=i + 1
            endloop
            set t=null
        endfunction  //注册单位自定义事件
        function STES_GetUnitEvent takes unit u,string name returns string
            return I2S(GetHandleId(u)) + name
        endfunction  //清除触发器上的指定事件
        function STES_RemoveEvent takes trigger t,string Targetname returns nothing
            local integer hd=GetHandleId(t)
            local integer index=LoadInteger(STES__HT, hd, skey_index)
            local integer i=0
            local integer a=0
            local integer b=0
            local string name
            local integer hash
            local trigger t1
            loop
            exitwhen ( i >= index )
                set name=LoadStr(STES__HT, hd, i) //如果事件名称 相同 那么清除它
                if ( name == Targetname ) then
                    set hash=StringHash(name) //获取计数
                    set a=LoadInteger(STES__HT, hash, skey_index)
                    loop
                    exitwhen ( b >= a )
                        set t1=LoadTriggerHandle(STES__HT, hash, b)
                        if ( t1 == t ) then
                            set a=a - 1
                            set t1=LoadTriggerHandle(STES__HT, hash, a)
                            call SaveTriggerHandle(STES__HT, hash, b, t1)
                            call SaveInteger(STES__HT, hash, skey_index, a)
                            if ( a >= b ) then
                                exitwhen true
                            endif
                        endif
                        set b=b + 1
                    endloop
                    call SaveStr(STES__HT, hd, i, LoadStr(STES__HT, hd, index))
                    set index=index - 1
                    call SaveInteger(STES__HT, hash, skey_index, index)
                    if ( i >= index ) then
                        exitwhen true
                    endif
                endif
                set i=i + 1
            endloop //FlushChildHashtable(HT,hd);
            set t1=null
        endfunction  //清除触发器上的所有自定义事件
        function STES_Remove takes trigger t returns nothing
            local integer hd=GetHandleId(t)
            local integer index=LoadInteger(STES__HT, hd, skey_index)
            local integer i=0
            local integer a=0
            local integer b=0
            local string name
            local integer hash
            local trigger t1
            loop
            exitwhen ( i >= index )
                set name=LoadStr(STES__HT, hd, i) //事件名称 //事件hash
                set hash=StringHash(name) //获取计数
                set a=LoadInteger(STES__HT, hash, skey_index)
                loop
                exitwhen ( b >= a )
                    set t1=LoadTriggerHandle(STES__HT, hash, b) //遍历事件 //找到事件对应的触发器
                    if ( t1 == t ) then
                        set a=a - 1 //触发器数量-1 //将顶部的触发器拉过来)
                        set t1=LoadTriggerHandle(STES__HT, hash, a) //save
                        call SaveTriggerHandle(STES__HT, hash, b, t1) //save index
                        call SaveInteger(STES__HT, hash, skey_index, a)
                        if ( a >= b ) then
                            exitwhen true
                        endif
                    endif
                    set b=b + 1
                endloop
                set i=i + 1
            endloop
            call FlushChildHashtable(STES__HT, hd)
            set t1=null
        endfunction
        function STES__onInit takes nothing returns nothing
            set STES_HT=STES__HT
        endfunction

//library STES ends
//library StarDebugger:

    function StarDebugger__Print takes string text returns nothing
        call BJDebugMsg((text)) // INLINED!!
    endfunction
    function SDR_DebugTimer takes timer t,real time,boolean isloop,string Target,string trig returns nothing
        call SaveTimerHandle(StarDebugger__ht, SDR_Index, 0, t)
        call SaveInteger(StarDebugger__ht, GetHandleId(t), 0, SDR_Index)
        call SaveReal(StarDebugger__ht, GetHandleId(t), 1, time)
        call SaveBoolean(StarDebugger__ht, GetHandleId(t), 2, isloop)
        call SaveStr(StarDebugger__ht, GetHandleId(t), 3, Target)
        call SaveStr(StarDebugger__ht, GetHandleId(t), 4, trig)
        set SDR_Index=SDR_Index + 1
    endfunction
    function SDR_ExTimerStart takes timer t,real time,boolean isloop,code c,string str returns nothing
        call TimerStart(t, time, isloop, c)
        call SDR_DebugTimer(t , time , isloop , str , "")
    endfunction  // public function SDR_DebugTimer2(timer t,real time,boolean isloop,string Target,code c){
    function SDR_DebugTimer_Remove takes timer t returns nothing
        local integer id
        local timer tr
        if ( HaveSavedInteger(StarDebugger__ht, GetHandleId(t), 0) ) then
            set id=LoadInteger(StarDebugger__ht, GetHandleId(t), 0)
            if ( id != ( SDR_Index - 1 ) ) then
                set tr=LoadTimerHandle(StarDebugger__ht, SDR_Index - 1, 0) //交换数据
                call SaveTimerHandle(StarDebugger__ht, id, 0, tr)
                call SaveInteger(StarDebugger__ht, GetHandleId(tr), 0, id) //清除旧计时器引用
                call FlushChildHashtable(StarDebugger__ht, GetHandleId(t))
            endif
            set SDR_Index=SDR_Index - 1
        endif
        set tr=null
    endfunction
    function StarDebugger__SDR_B2I takes boolean b returns string
        if ( b ) then
            return "循环"
        else
            return "不循环"
        endif
    endfunction
    function SDR_Print takes nothing returns nothing
        local integer i=0
        local integer j=0
        local timer t
        call BJDebugMsg((("==========逆天计时器引用检查=========="))) // INLINED!!
        loop
        exitwhen ( i >= SDR_Index )
            set t=LoadTimerHandle(StarDebugger__ht, i, 0)
            if ( t != null ) then
                call BJDebugMsg((("计时器句柄:" + I2S(GetHandleId(t)) + "，周期:" + R2S(LoadReal(StarDebugger__ht, GetHandleId(t), 1)) + "，" + StarDebugger__SDR_B2I(LoadBoolean(StarDebugger__ht, GetHandleId(t), 2)) + "，回调函数:" + LoadStr(StarDebugger__ht, GetHandleId(t), 3) + ",在触发器:" + LoadStr(StarDebugger__ht, GetHandleId(t), 4)))) // INLINED!!
                set j=j + 1
            endif
            set i=i + 1
        endloop
        call BJDebugMsg((("逆天计时器数量：" + I2S(j)))) // INLINED!!
        set t=null
        call BJDebugMsg((("==============The  End==============="))) // INLINED!!
    endfunction
    function StarDebugger__onInit takes nothing returns nothing
        set SDR_HT=StarDebugger__ht
    endfunction

//library StarDebugger ends
//library StarString:

    //public:
    function StringBufferLoad takes nothing returns string
        return EXExecuteScript("(require'StarStr').concat3()") // return StringUtil.StrContLoad();
    endfunction  //添加字符串到待连接字符串缓冲池
    function StringBufferAdd takes string str returns nothing
        set SSL_StringBuffer[SSL_StringBufferIndex]=str // Print("添加"); // StringUtil.StrPoolAdd(s);
        set SSL_StringBufferIndex=SSL_StringBufferIndex + 1
    endfunction  //连接字符串lv3EX
    function StringContEX takes string A,string B,string C returns string
        call s__StringUtil_StrPoolAdd(A)
        call s__StringUtil_StrPoolAdd(B)
        call s__StringUtil_StrPoolAdd(C)
        return (EXExecuteScript("(require'StarStr').concat3()")) // INLINED!!
    endfunction  ///string.gsub('aaaa','a','z')
    function SS_Stringgsub takes string a,string b,string c returns string
        local string str="string.gsub +('" + a + "'),'" + b + "','" + c + "')"
        local string str2=EXExecuteScript(str)
        if ( str2 != null ) then
            return str2
        endif
        return ""
    endfunction  //连接字符串
    function stradd takes string s1,string s2 returns string
        return s1 + s2
    endfunction  //将实数转为整数后格式化为指定长度的字符串
    function FormatNumToString takes real r,integer max returns string
        local integer i=0
        local string str2=I2S(R2I(r))
        if ( r < 0 ) then
            set max=max - 1
            call StringBufferAdd("-")
            set str2=SubStringBJ(str2, 2, StringLength(str2))
        endif
        set i=0
        loop
        exitwhen ( i >= ( max - StringLength(str2) ) )
            call StringBufferAdd("0")
        set i=i + 1
        endloop
        call StringBufferAdd(str2)
        return (EXExecuteScript("(require'StarStr').concat3()")) // INLINED!!
    endfunction
    function FormatIntToString takes integer r,integer max returns string
        local integer i=0
        local string str2=I2S(r)
        if ( r < 0 ) then
            set max=max - 1
            call StringBufferAdd("-")
            set str2=SubStringBJ(str2, 2, StringLength(str2))
        endif
        set i=0
        loop
        exitwhen ( i >= ( max - StringLength(str2) ) )
            call StringBufferAdd("0")
        set i=i + 1
        endloop
        call StringBufferAdd(str2)
        return (EXExecuteScript("(require'StarStr').concat3()")) // INLINED!!
    endfunction  //格式化玩家ID为两位字符串
    function GetPlayerIDString takes player p returns string
        local integer id=GetPlayerId(p)
        if ( id < 10 ) then
            set CallBackString="0" + I2S(id)
            return CallBackString
        endif
        set CallBackString=I2S(id)
        return CallBackString
    endfunction  //获取字符串中指定的第一个字符出现的位置
    function GetIndexOfChar takes string str,string tgt returns integer
        local string c=SubStringBJ(tgt, 1, 1)
        local string b
        local integer max=StringLength(str)
        local integer i=0
        loop
        exitwhen ( i >= max )
            set b=SubStringBJ(str, i, i)
            if ( b == c ) then
                return i
            endif
            set i=i + 1
        endloop
        return - 1
    endfunction  //分割字符串str分隔符为tgt 若没有找到分隔符 则返回str
    function strtok takes string str,string tgt returns nothing
        local string c=SubStringBJ(tgt, 1, 1)
        local string b
        local integer max=StringLength(str)
        local integer i=0
        local integer base=1
        set SS_Index=0
        loop
        exitwhen ( i >= max )
            set i=i + 1
            set b=SubStringBJ(str, i, i)
            if ( b == c ) then
                set SS_CallbackString[SS_Index]=SubStringBJ(str, base, i - 1)
                set SS_Index=SS_Index + 1
                set base=i + 1
            endif
        endloop
        set SS_CallbackString[SS_Index]=SubStringBJ(str, base, i)
        set SS_Index=SS_Index + 1
    endfunction
    function StarString__onInit takes nothing returns nothing
    endfunction

//library StarString ends
//library SUTriggerList:

    function SUTL_UnitAddEventCallBack takes integer abc,handle u,integer c,trigger t returns nothing
        local integer uhd=GetHandleId(u)
        local integer thd=GetHandleId(t)
        local integer uCode=uhd + c
        local integer index=LoadInteger(SUTriggerList__ht, uCode, skey_index)
        call SaveInteger(SUTriggerList__ht, uhd, thd + SUTriggerList__key_Count, LoadInteger(SUTriggerList__ht, uhd, thd + SUTriggerList__key_Count) + 1) //如果没有注册
        if ( not ( HaveSavedInteger(SUTriggerList__ht, GetHandleId(t), uCode) ) ) then
            call SaveTriggerHandle(SUTriggerList__ht, uCode, index, t) //绑定触发器到单位事件队列上 //记录索引在触发器t的uCode上
            call SaveInteger(SUTriggerList__ht, GetHandleId(t), uCode, index) //绑定在该事件下的触发器数量 + 1
            call SaveInteger(SUTriggerList__ht, uCode, skey_index, index + 1)
        endif
    endfunction
    function SUTL_GetUnitEventCount takes unit u,integer c returns integer
        return LoadInteger(SUTriggerList__ht, GetHandleId(u), c + SUTriggerList__key_Count)
    endfunction
    function SUTL_GetObjectEventCount takes integer abc,handle u,trigger t returns integer
        local integer thd=GetHandleId(t)
        return LoadInteger(SUTriggerList__ht, GetHandleId(u), thd + SUTriggerList__key_Count)
    endfunction
    function SUTL_ClearObejctAllEvent takes integer abc,handle u returns nothing
        local integer uhd=GetHandleId(u)
    endfunction  //StarExecuteUnitEvent
    function SUTL_UnitRemoveEventCallBack takes integer abc,handle u,integer c,trigger t returns nothing
        local integer uhd=GetHandleId(u)
        local integer thd=GetHandleId(t)
        local integer uCode=uhd + c
        local integer index=LoadInteger(SUTriggerList__ht, uCode, skey_index) - 1
        local integer i=0
        local trigger trig
        call SaveInteger(SUTriggerList__ht, uhd, thd + SUTriggerList__key_Count, LoadInteger(SUTriggerList__ht, uhd, thd + SUTriggerList__key_Count) - 1) //Print(I2S(thd)+"的计数->"+I2S(LoadInteger(ht,GetHandleId(u),thd+key_Count)));
        if ( LoadInteger(SUTriggerList__ht, uhd, thd + SUTriggerList__key_Count) > 0 ) then
            return
        endif //Print("卸载");
        set i=LoadInteger(SUTriggerList__ht, GetHandleId(t), uCode) //printsi("index =",index); //读取索引//索引减1 得到真实数组顶部 //printsi("index =",LoadInteger(ht, uCode,skey_index));
        call RemoveSavedInteger(SUTriggerList__ht, GetHandleId(t), uCode) //删除索引从t的uCode上
        if ( i != index ) then //printsi(" in index =",LoadInteger(ht, uCode,skey_index));
            set trig=LoadTriggerHandle(SUTriggerList__ht, uCode, index) //读取顶部触发器 //用顶部覆盖当前位置
            call SaveTriggerHandle(SUTriggerList__ht, uCode, i, trig) //更新索引
            call SaveInteger(SUTriggerList__ht, GetHandleId(trig), uCode, index)
        endif //printsi("index =",LoadInteger(ht, uCode,skey_index));
        call SaveInteger(SUTriggerList__ht, uCode, skey_index, index) //更新顶
        set trig=null //printsi("index =",LoadInteger(ht, uCode,skey_index));
    endfunction  // while(i<index){ //     trig = LoadTrigger(ht, uCode,i); //     if(trig == t){ //         //doEvent //     } //     i+=1; // }
    function SUTL_UnitAddEventCallBackEx takes handle a,integer b,trigger c,boolean d returns nothing
        if ( d ) then
            call SUTL_UnitAddEventCallBack(0 , a , b , c)
        else
            call SUTL_UnitRemoveEventCallBack(0 , a , b , c)
        endif
    endfunction
    function SUTriggerList__onInit takes nothing returns nothing
        set SUTL_HT=SUTriggerList__ht
    endfunction  //

//library SUTriggerList ends
//library StarGSS:

    function SGSS_SetUnitHPRegenerates takes unit u,real r returns nothing
        local real atk
        local integer hd=GetHandleId(u)
        set atk=LoadReal(StarBaseHT, hd, StarGSS__key_atk) + r
        if ( GetUnitAbilityLevel(u, 'ASG1') == 0 ) then
            call UnitAddAbility(u, 'ASG1')
        endif
        call YDWESetUnitAbilityDataReal(u , 'ASG1' , 1 , 108 , atk)
        call IncUnitAbilityLevel(u, 'ASG1')
        call DecUnitAbilityLevel(u, 'ASG1')
        call SaveReal(StarBaseHT, hd, StarGSS__key_atk, atk)
    endfunction  //增加单位u的攻击力增加r点
    function SGSS_SetUnitAttack takes unit u,real r returns nothing
        local real atk
        local integer hd=GetHandleId(u)
        set atk=LoadReal(StarBaseHT, hd, StarGSS__key_atk) + r
        if ( GetUnitAbilityLevel(u, 'ASG1') == 0 ) then
            call UnitAddAbility(u, 'ASG1')
        endif
        call YDWESetUnitAbilityDataReal(u , 'ASG1' , 1 , 108 , atk)
        call IncUnitAbilityLevel(u, 'ASG1')
        call DecUnitAbilityLevel(u, 'ASG1')
        call SaveReal(StarBaseHT, hd, StarGSS__key_atk, atk)
    endfunction  //设置单位u的防御力增加r
    function SGSS_SetUnitAmrror takes unit u,real r returns nothing
        local real atk
        local integer hd=GetHandleId(u)
        set atk=LoadReal(StarBaseHT, hd, StarGSS__key_amr) + r
        if ( GetUnitAbilityLevel(u, 'ASG2') == 0 ) then
            call UnitAddAbility(u, 'ASG2')
        endif
        call YDWESetUnitAbilityDataReal(u , 'ASG2' , 1 , 108 , atk)
        call IncUnitAbilityLevel(u, 'ASG2')
        call DecUnitAbilityLevel(u, 'ASG2')
        call SaveReal(StarBaseHT, hd, StarGSS__key_amr, atk)
    endfunction  //增加单位u的生命值r点
    function SGSS_SetUnitHP takes unit u,real hp returns nothing
        local integer hd=GetHandleId(u)
        local real p
        local real ohp
        local real nhp
        local real mhp=GetUnitState(u, UNIT_STATE_MAX_LIFE)
        set ohp=LoadReal(StarBaseHT, hd, StarGSS__key_hp) + hp
        if ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 ) then
            set p=GetUnitState(u, UNIT_STATE_LIFE) / mhp
        endif //新增值 = hp 旧增值 = ohp 相加 等于 新值 
        set nhp=ohp + hp //最大生命值 = 最大生命值 - ohp + nmp
        call SetUnitState(u, UNIT_STATE_MAX_LIFE, mhp - ohp + nhp)
        if ( GetUnitState(u, UNIT_STATE_LIFE) > 0.405 ) then
            call SetUnitState(u, UNIT_STATE_LIFE, GetUnitState(u, UNIT_STATE_MAX_LIFE) * p)
        endif
        call SaveReal(StarBaseHT, hd, StarGSS__key_hp, nhp)
    endfunction  //增加单位u的法力值r点
    function SGSS_SetUnitMP takes unit u,real mp returns nothing
        local integer hd=GetHandleId(u) // integer hd = GetHandleId(u);real p; // p = GetUnitState(u,UNIT_STATE_MANA) / GetUnitState(u,UNIT_STATE_MAX_MANA); // SetUnitState(u,UNIT_STATE_MAX_MANA,GetUnitState(u,UNIT_STATE_MAX_MANA)+mp); 
        local real p
        local real ohp
        local real nhp
        local real mhp=GetUnitState(u, UNIT_STATE_MAX_MANA)
        set ohp=LoadReal(StarBaseHT, hd, StarGSS__key_mp) + mp
        set p=GetUnitState(u, UNIT_STATE_MANA) / mhp
        set nhp=ohp + mp
        call SetUnitState(u, UNIT_STATE_MAX_MANA, mhp - ohp + nhp)
        call SetUnitState(u, UNIT_STATE_MANA, GetUnitState(u, UNIT_STATE_MAX_MANA) * p)
        call SaveReal(StarBaseHT, hd, StarGSS__key_mp, nhp)
    endfunction  // 使 单位u 增加 力量a 智力b 敏捷c 点
    function SGSS_SetUnitState takes unit u,real a,real b,real c returns nothing
        local real str
        local real agi
        local real int2
        local integer hd=GetHandleId(u)
        set str=LoadReal(StarBaseHT, hd, StarGSS__key_str) + a
        set agi=LoadReal(StarBaseHT, hd, StarGSS__key_agi) + b
        set int2=LoadReal(StarBaseHT, hd, StarGSS__key_int) + c
        if ( GetUnitAbilityLevel(u, 'ASG3') == 0 ) then
            call UnitAddAbility(u, 'ASG3')
        endif // Print("力量->"+R2S(a)+",敏捷->"+R2S(b)+",智力->"+R2S(c));
        call YDWESetUnitAbilityDataReal(u , 'ASG3' , 1 , 110 , str)
        call YDWESetUnitAbilityDataReal(u , 'ASG3' , 1 , 108 , agi)
        call YDWESetUnitAbilityDataReal(u , 'ASG3' , 1 , 109 , int2)
        call IncUnitAbilityLevel(u, 'ASG3')
        call DecUnitAbilityLevel(u, 'ASG3')
        call SaveReal(StarBaseHT, hd, StarGSS__key_str, str)
        call SaveReal(StarBaseHT, hd, StarGSS__key_agi, agi)
        call SaveReal(StarBaseHT, hd, StarGSS__key_int, int2) // Print("总计加成力量->"+R2S(LoadReal(StarBaseHT,hd,key_str))+",总计加成敏捷->"+R2S(LoadReal(StarBaseHT,hd,key_agi))+",总计加成智力->"+R2S(LoadReal(StarBaseHT,hd,key_int)));
    endfunction  //增加单位移动速度
    function SGSS_SetUnitMoveSpeed takes unit u,real r returns nothing
        local real hp
        local integer hd=GetHandleId(u)
        set hp=LoadReal(StarBaseHT, hd, StarGSS__key_ms) + r
        if ( GetUnitAbilityLevel(u, 'ASG6') == 0 ) then
            call UnitAddAbility(u, 'ASG6')
        endif
        call YDWESetUnitAbilityDataReal(u , 'ASG6' , 1 , 108 , hp)
        call IncUnitAbilityLevel(u, 'ASG6')
        call DecUnitAbilityLevel(u, 'ASG6')
        call SaveReal(StarBaseHT, hd, StarGSS__key_ms, hp)
    endfunction  //增加单位${单位}生命恢复速率${值} 
    function SGSS_SetUnitHPRecover takes unit u,real r returns nothing
        local real hp
        local integer hd=GetHandleId(u)
        set hp=LoadReal(StarBaseHT, hd, StarGSS__key_rhp) + r
        call SaveReal(StarBaseHT, hd, StarGSS__key_rhp, hp)
    endfunction  //增加单位${单位}魔法恢复速率${值} 
    function SGSS_SetUnitManaRecover takes unit u,real r returns nothing
        local real hp
        local integer hd=GetHandleId(u)
        set hp=LoadReal(StarBaseHT, hd, StarGSS__key_rmp) + r
        call SaveReal(StarBaseHT, hd, StarGSS__key_rmp, hp)
    endfunction  //增加单位攻击速度
    function SGSS_SetUnitAttackSpeed takes unit u,real r returns nothing
        local real as
        local integer hd=GetHandleId(u)
        set as=LoadReal(StarBaseHT, hd, StarGSS__key_as) + r
        if ( GetUnitAbilityLevel(u, 'ASG7') == 0 ) then
            call UnitAddAbility(u, 'ASG7')
        endif
        call YDWESetUnitAbilityDataReal(u , 'ASG7' , 1 , 108 , as)
        call IncUnitAbilityLevel(u, 'ASG7')
        call DecUnitAbilityLevel(u, 'ASG7')
        call SaveReal(StarBaseHT, hd, StarGSS__key_as, as)
    endfunction  //增加单位攻击力 百分比 //SUTL_GetHashCode 
    function SGSS_SetUnitAttackPercentum takes unit u,real r returns nothing
        local integer hd=GetHandleId(u)
        local real pv=LoadReal(StarBaseHT, hd, 0xE2D1D0F7)
        local real av=LoadReal(StarBaseHT, hd, 0x5E2858CE)
        local real v=GetUnitState(u, ConvertUnitState(0x12)) + ( GetUnitState(u, ConvertUnitState(0x10)) * ( GetUnitState(u, ConvertUnitState(0x11)) + 1 ) / 2 )
        local real npv=pv + r //新的百分比 
        local real nav=v * npv
        if ( av == nav ) then
            return
        endif
        call SGSS_SetUnitAttack(u , - av)
        call SaveReal(StarBaseHT, hd, 0xE2D1D0F7, npv)
        call SaveReal(StarBaseHT, hd, 0x5E2858CE, nav) //更新增值
        call SGSS_SetUnitAttack(u , nav)
    endfunction  //增加单位防御力 百分比 //SUTL_GetHashCode 
    function SGSS_SetUnitAmrrorPercentum takes unit u,real r returns nothing
        local integer hd=GetHandleId(u)
        local real pv=LoadReal(StarBaseHT, hd, 0x7AAD9F3F)
        local real av=LoadReal(StarBaseHT, hd, 0xB77A676A)
        local real v=GetUnitState(u, ConvertUnitState(0x20)) - av //得到原始值 
        local real npv=pv + r
        local real nav=v * npv
        if ( av == nav ) then
            return
        endif
        call SGSS_SetUnitAmrror(u , - av)
        call SaveReal(StarBaseHT, hd, 0x7AAD9F3F, npv)
        call SaveReal(StarBaseHT, hd, 0xB77A676A, nav) //更新增值
        call SGSS_SetUnitAmrror(u , nav)
    endfunction
    function SGSS_SetUnitStrPercentum takes unit u,real r returns nothing
        local integer hd=GetHandleId(u)
        local real pv=LoadReal(StarBaseHT, hd, 0xFCD33D8D)
        local real av=LoadReal(StarBaseHT, hd, 0x7C8F4B1A)
        local real v=GetHeroStr(u, true) - av //得到原始值 
        local real npv=pv + r
        local real nav=v * npv
        if ( av == nav ) then
            return
        endif
        call SGSS_SetUnitState(u , - av , 0 , 0)
        call SaveReal(StarBaseHT, hd, 0xFCD33D8D, npv)
        call SaveReal(StarBaseHT, hd, 0x7C8F4B1A, nav)
        call SGSS_SetUnitState(u , nav , 0 , 0)
    endfunction
    function SGSS_SetUnitAgiPercentum takes unit u,real r returns nothing
        local integer hd=GetHandleId(u)
        local real pv=LoadReal(StarBaseHT, hd, 0x3B9A78FD)
        local real av=LoadReal(StarBaseHT, hd, 0x6B2C3F42)
        local real v=GetHeroAgi(u, true) - av //得到原始值 
        local real npv=pv + r
        local real nav=v * npv
        if ( av == nav ) then
            return
        endif
        call SGSS_SetUnitState(u , 0 , - av , 0)
        call SaveReal(StarBaseHT, hd, 0x3B9A78FD, npv)
        call SaveReal(StarBaseHT, hd, 0x6B2C3F42, nav)
        call SGSS_SetUnitState(u , 0 , nav , 0)
    endfunction
    function SGSS_SetUnitIntPercentum takes unit u,real r returns nothing
        local integer hd=GetHandleId(u)
        local real pv=LoadReal(StarBaseHT, hd, 0x36CADEBF)
        local real av=LoadReal(StarBaseHT, hd, 0xAA6CBC2D)
        local real v=GetHeroInt(u, true) - av //得到原始值 
        local real npv=pv + r
        local real nav=v * npv
        if ( av == nav ) then
            return
        endif
        call SGSS_SetUnitState(u , 0 , 0 , - av)
        call SaveReal(StarBaseHT, hd, 0x36CADEBF, npv)
        call SaveReal(StarBaseHT, hd, 0xAA6CBC2D, nav)
        call SGSS_SetUnitState(u , 0 , 0 , nav)
    endfunction
    function SGSS_B2I takes boolean b returns integer
        if ( b ) then
            return 1
        endif
        return - 1
    endfunction  //增加单位生命值 百分比 //SUTL_GetHashCode 
    function SGSS_SetUnitHPPercentum takes unit u,real r returns nothing
        local integer hd=GetHandleId(u)
        local real pv=LoadReal(StarBaseHT, hd, 0x53FA388D) //0    0.15 
        local real av=LoadReal(StarBaseHT, hd, 0x3F92336A) //0   108.75 
        local real v=GetUnitState(u, UNIT_STATE_MAX_LIFE) - av //得到原始值  
        local real npv=pv + r //新的百分比   //0+0.15=0.15  0.15+0 = 0.15 //新的加成值  
        local real nav=v * npv
        if ( av == nav ) then // Print("百分比:"+","+R2S(av)); // Print(R2S(v)+","+R2S(nav)); //同属性则不变 //更新增值
            return
        endif
        call SGSS_SetUnitHP(u , - av) //0.15 0.15 
        call SaveReal(StarBaseHT, hd, 0x53FA388D, npv) // 108.75 108.75
        call SaveReal(StarBaseHT, hd, 0x3F92336A, nav) //更新增值
        call SGSS_SetUnitHP(u , nav)
    endfunction  //增加单位法力值 百分比 //SUTL_GetHashCode 
    function SGSS_SetUnitMPPercentum takes unit u,real r returns nothing
        local integer hd=GetHandleId(u)
        local real pv=LoadReal(StarBaseHT, hd, 0x7B73D788)
        local real av=LoadReal(StarBaseHT, hd, 0x22604F43)
        local real v=GetUnitState(u, UNIT_STATE_MAX_MANA) - av //得到原始值 
        local real npv=pv + r
        local real nav=v * npv
        if ( av == nav ) then
            return
        endif
        call SGSS_SetUnitMP(u , - av)
        call SaveReal(StarBaseHT, hd, 0x7B73D788, npv)
        call SaveReal(StarBaseHT, hd, 0x22604F43, nav) //更新增值
        call SGSS_SetUnitMP(u , nav)
    endfunction
    function SGSS_SetUnitAllPercentum takes unit u,real v returns nothing
        call SGSS_SetUnitStrPercentum(u , v)
        call SGSS_SetUnitAgiPercentum(u , v)
        call SGSS_SetUnitIntPercentum(u , v)
    endfunction  //增加单位属性-百分比 1= 攻击力 2= 防御力 3=力量值 4=敏捷值 5=智力值 6=全属性 7= 生命值 8 = 法力值
    function SGSS_SetStatePercentum takes unit u,integer id,real v returns nothing
        if ( id == 1 ) then
            call SGSS_SetUnitAttackPercentum(u , v)
        elseif ( id == 2 ) then
            call SGSS_SetUnitAmrrorPercentum(u , v)
        elseif ( id == 3 ) then
            call SGSS_SetUnitStrPercentum(u , v)
        elseif ( id == 4 ) then
            call SGSS_SetUnitAgiPercentum(u , v)
        elseif ( id == 5 ) then
            call SGSS_SetUnitIntPercentum(u , v)
        elseif ( id == 6 ) then
            call SGSS_SetUnitStrPercentum(u , v)
            call SGSS_SetUnitAgiPercentum(u , v)
            call SGSS_SetUnitIntPercentum(u , v)
        elseif ( id == 7 ) then
            call SGSS_SetUnitHPPercentum(u , v)
        elseif ( id == 8 ) then
            call SGSS_SetUnitMPPercentum(u , v)
        endif
    endfunction
        function StarGSS__anon__0 takes nothing returns nothing
            local integer i=0
            local real temp=0
            local integer hd=0
            loop
            exitwhen ( i >= StarGSS__index )
                set hd=GetHandleId(StarGSS__list[i])
                call SGSS_SetUnitAttackPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitAmrrorPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitStrPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitAgiPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitIntPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitAllPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitHPPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitMPPercentum(StarGSS__list[i] , 0)
                set temp=LoadReal(StarBaseHT, hd, StarGSS__key_rhp)
                if ( temp != 0 ) then
                    call SetWidgetLife(StarGSS__list[i], RMaxBJ(.5, GetWidgetLife(StarGSS__list[i]) + temp * StarGSS__xiaolv))
                endif
                set temp=LoadReal(StarBaseHT, hd, StarGSS__key_rmp)
                if ( temp != 0 ) then
                    call SetUnitState(StarGSS__list[i], UNIT_STATE_MANA, GetUnitState(StarGSS__list[i], UNIT_STATE_MANA) + temp * StarGSS__xiaolv)
                endif
                set temp=GetUnitDefaultMoveSpeed(StarGSS__list[i]) + LoadReal(YDHT, GetHandleId(StarGSS__list[i]), 0xEBB396B3)
                if ( temp >= 400 ) then
                    call SOS_SetUnitSpeed(StarGSS__list[i] , temp , true)
                else
                    call SOS_UnSetUnitSpeed(StarGSS__list[i])
                endif
                set i=i + 1
            endloop
        endfunction
    function SGSS_UnitStateListener takes unit u returns nothing
        local real temp=0
        if ( HaveSavedInteger(StarBaseHT, GetHandleId(u), 0x8C2EBBA7) ) then
            return
        endif
        call SaveInteger(StarBaseHT, GetHandleId(u), 0x8C2EBBA7, StarGSS__index)
        set StarGSS__list[StarGSS__index]=u
        set StarGSS__index=StarGSS__index + 1
        call TimerStart(StarGSS__t, 1, true, function StarGSS__anon__0)
    endfunction
        function StarGSS__anon__1 takes nothing returns nothing
            local integer i=0
            loop //Print("i="+I2S(i));
            exitwhen ( i >= StarGSS__index )
                call SGSS_SetUnitAttackPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitAmrrorPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitStrPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitAgiPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitIntPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitAllPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitHPPercentum(StarGSS__list[i] , 0)
                call SGSS_SetUnitMPPercentum(StarGSS__list[i] , 0)
                set i=i + 1
            endloop
        endfunction
    function SGSS_UnitRegStateListener takes unit u returns nothing
        if ( HaveSavedInteger(StarBaseHT, GetHandleId(u), 0x8C2EBBA7) ) then
            return
        endif
        call SaveInteger(StarBaseHT, GetHandleId(u), 0x8C2EBBA7, StarGSS__index)
        set StarGSS__list[StarGSS__index]=u
        set StarGSS__index=StarGSS__index + 1
        call TimerStart(StarGSS__t, 1, true, function StarGSS__anon__1)
    endfunction
    function SGSS_UnitUnRegStateListener takes unit u returns nothing
        local integer i
        if ( HaveSavedInteger(StarBaseHT, GetHandleId(u), 0x8C2EBBA7) ) then
            set i=LoadInteger(StarBaseHT, GetHandleId(u), 0x8C2EBBA7)
            set StarGSS__list[i]=StarGSS__list[StarGSS__index]
            set StarGSS__index=StarGSS__index - 1
            call RemoveSavedInteger(StarBaseHT, GetHandleId(u), 0x8C2EBBA7)
        endif
    endfunction
    function SGSS_UnitStateInit takes nothing returns nothing
    endfunction
    function SGSS_SetUnitState_Str takes unit u,real v returns nothing
        call SGSS_SetUnitState(u , v , 0 , 0)
    endfunction
    function SGSS_SetUnitState_Agi takes unit u,real v returns nothing
        call SGSS_SetUnitState(u , 0 , v , 0)
    endfunction
    function SGSS_SetUnitState_Int takes unit u,real v returns nothing
        call SGSS_SetUnitState(u , 0 , 0 , v)
    endfunction  //#endif
    function SGSS_SetState takes unit u,integer id,real v returns nothing
        if ( id == 1 ) then
            call SGSS_SetUnitAttack(u , v)
        elseif ( id == 2 ) then
            call SGSS_SetUnitAmrror(u , v)
        elseif ( id == 3 ) then
            call SGSS_SetUnitState(u , v , 0 , 0)
        elseif ( id == 4 ) then
            call SGSS_SetUnitState(u , 0 , v , 0)
        elseif ( id == 5 ) then
            call SGSS_SetUnitState(u , 0 , 0 , v)
        elseif ( id == 6 ) then
            call SGSS_SetUnitState(u , v , v , v)
        elseif ( id == 7 ) then
            call SGSS_SetUnitHP(u , v)
        elseif ( id == 8 ) then
            call SGSS_SetUnitMP(u , v)
        elseif ( id == 9 ) then
            call SGSS_SetUnitMoveSpeed(u , v)
        elseif ( id == 10 ) then
            call SGSS_SetUnitAttackSpeed(u , v)
        endif
    endfunction  //刷新单位身上的等级加成
    function SGSS_ReSetUnitState takes unit u returns nothing
        local integer i=0
        local real newValue
        local real oldValue
        set i=1 //读取等级加成值
        loop
        exitwhen ( i >= 6 )
            set oldValue=LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[200 + i]) //计算新的值
            set newValue=GetHeroLevel(u) * LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[100 + i]) //记录新值
            call SaveReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[200 + i], newValue) //更新差异
            call SGSS_SetState(u , i , newValue - oldValue)
        set i=i + 1
        endloop
        set i=6 //读取等级加成值
        loop
        exitwhen ( i >= 8 )
            set oldValue=LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[200 + i]) //计算新的值
            set newValue=GetHeroLevel(u) * LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[100 + i]) //记录新值
            call SaveReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[200 + i], newValue) //更新差异
            call SGSS_SetState(u , i + 1 , newValue - oldValue)
        set i=i + 1
        endloop
    endfunction  //刷新固定加成
    function SGSS_ReSetUnitState2 takes unit u returns nothing
        local integer i=0
        local real newValue
        local real oldValue
        set i=1 //读取等级加成值
        loop
        exitwhen ( i >= 6 )
            set oldValue=LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[400 + i]) //计算新的值
            set newValue=LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[300 + i]) //记录新值
            call SaveReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[400 + i], newValue) //更新差异
            call SGSS_SetState(u , i , newValue - oldValue)
        set i=i + 1
        endloop
        set i=6 //读取等级加成值
        loop
        exitwhen ( i >= 8 )
            set oldValue=LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[400 + i]) //计算新的值
            set newValue=LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[300 + i]) //记录新值
            call SaveReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[400 + i], newValue) //更新差异
            call SGSS_SetState(u , i + 1 , newValue - oldValue)
        set i=i + 1
        endloop
    endfunction  //增加指定字段的等级加成率
    function SGSS_AddUnitLevelState takes unit u,integer i,real v returns nothing
        call SaveReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[100 + i], LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[100 + i]) + v)
    endfunction  //增加指定字段的基础值
    function SGSS_AddUnitBaseState takes unit u,integer i,real v returns nothing
        call SaveReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[300 + i], LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[300 + i]) + v)
    endfunction  //获取指定字段的等级加成率
    function SGSS_GetUnitLevelState takes unit u,integer i returns real
        return LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[100 + i])
    endfunction  //获取指定字段的基础值
    function SGSS_GetUnitBaseState takes unit u,integer i returns real
        return LoadReal(YDHT, GetHandleId(u), SGSS_TypeStrHash[300 + i])
    endfunction  //增加/减少物品等级关联属性
    function SGSS_UnitAddItemLevelState takes unit u,integer itp,boolean isGet,item wp returns nothing
        local integer hd=GetHandleId(wp)
        local integer i=0
        local real value
        local real qv
        local real bv
        local integer itemLevel=LoadInteger(YDHT, hd, 0x3D10D25E)
        local integer qhlv=LoadInteger(YDHT, hd, 0x30CFC9D7)
        set i=1 //基础成长率 vlaue
        loop
        exitwhen ( i >= 8 )
            set value=LoadReal(YDHT, itp, SGSS_TypeStrHash[i]) * SGSS_B2I(isGet) //基础值 赋予25级的属性
            set bv=value * 25 //基础成长率 *= 强化系数
            set qv=0.25 * qhlv * ( value ) //基础值 *= 品质系数
            set bv=bv * ( 0.5 + 0.5 * itemLevel ) //基础值 *= 强化系数
            set bv=bv * ( 1 + 0.25 * qhlv ) //基础成长率 *= 品质系数
            set value=( value + qv ) * ( 0.5 + 0.5 * itemLevel )
            call SGSS_AddUnitLevelState(u , i , value)
            call SGSS_AddUnitBaseState(u , i , bv)
        set i=i + 1
        endloop //刷新它
        call SGSS_ReSetUnitState(u)
        call SGSS_ReSetUnitState2(u)
    endfunction
    function SGSS_GetItemTitle takes unit u,item wp returns string
        local integer itemLevel=LoadInteger(YDHT, GetHandleId(wp), 0x3D10D25E)
        if ( itemLevel < 1 ) then
            set itemLevel=1
        endif
        if ( itemLevel > 6 ) then
            set itemLevel=6
        endif
        return SGSS_TypeStr[2100 + itemLevel] + GetItemName(wp) + "|r"
        return ""
    endfunction
    function SGSS_GetItemTips takes unit u,item wp returns string
        local integer hd=GetHandleId(wp)
        local integer typ=GetItemTypeId(wp)
        local real v
        local integer i=0
        local real qv
        local integer lv=GetHeroLevel(u)
        local integer qhlv=LoadInteger(YDHT, hd, 0x30CFC9D7)
        local integer itemLevel=LoadInteger(YDHT, GetHandleId(wp), 0x3D10D25E)
        call StringBufferAdd("|cff00ff00") //强化等级的星星
        set i=1
        loop
        exitwhen ( i > 10 )
            if ( i <= qhlv ) then
                call StringBufferAdd("★")
            else
                call StringBufferAdd("☆")
            endif
        set i=i + 1
        endloop
        call StringBufferAdd("|r\n\n")
        set i=1 //判断是否增加该属性
        loop
        exitwhen ( i >= 8 )
            if ( HaveSavedReal(YDHT, typ, SGSS_TypeStrHash[i]) ) then
                set v=LoadReal(YDHT, typ, SGSS_TypeStrHash[i]) * ( 25 + lv ) //读取表中的基础值 //基础值 * 25% 强化等级 * 品质加成
                set qv=( v * 0.25 * qhlv ) * ( 0.5 + 0.5 * itemLevel ) //Print("强化增值"+R2S(qv));
                set v=v * ( 0.5 + 0.5 * itemLevel ) //装备品级加成率 50% //这里的值要和上面的公式匹配
                call StringBufferAdd(SGSS_TypeStr[1000 + i])
                if ( v >= 10 ) then
                    call StringBufferAdd(I2S(R2I(v)))
                else
                    call StringBufferAdd(R2SW(v, 1, 1))
                endif
                if ( qv > 0 ) then
                    call StringBufferAdd("|r + |cff00ff00")
                    if ( qv >= 10 ) then
                        call StringBufferAdd(I2S(R2I(qv)))
                    else
                        call StringBufferAdd(R2SW(qv, 1, 1))
                    endif
                endif
                call StringBufferAdd("|r\n")
            endif
        set i=i + 1
        endloop
        call StringBufferAdd("|r\n") //StringBufferAdd(StarMapItemGetTips(wp));
        call StringBufferAdd((EXGetItemDataString((typ ), ( 3)))) // INLINED!!
        return (EXExecuteScript("(require'StarStr').concat3()")) // INLINED!!
    endfunction
    function SGSS_ResetItemModel takes item wp returns nothing
        local integer itemLevel=LoadInteger(YDHT, GetHandleId(wp), 0x3D10D25E)
        if ( itemLevel < 1 ) then
            set itemLevel=1
        endif
        if ( itemLevel > 6 ) then
            set itemLevel=6 //SetItemModel(wp,SGSS_TypeStr[4000+itemLevel]);
        endif
    endfunction
    function StarGSS__initVar takes nothing returns nothing
        local integer i=0
        set SGSS_TypeStr[1]="每级攻击力"
        set SGSS_TypeStr[2]="每级防御力"
        set SGSS_TypeStr[3]="每级力量值"
        set SGSS_TypeStr[4]="每级敏捷值"
        set SGSS_TypeStr[5]="每级智力值"
        set SGSS_TypeStr[6]="每级生命值"
        set SGSS_TypeStr[7]="每级法力值"
        set SGSS_TypeStr[1001]="|cffffffcc攻击力+"
        set SGSS_TypeStr[1002]="|cffc0c0c0防御力+"
        set SGSS_TypeStr[1003]="|cffff6800力量值+"
        set SGSS_TypeStr[1004]="|cffff6800敏捷值+"
        set SGSS_TypeStr[1005]="|cffff6800智力值+"
        set SGSS_TypeStr[1006]="|cff00ff00生命值+"
        set SGSS_TypeStr[1007]="|cff99ccff法力值+"
        set SGSS_TypeStr[2100]="|cff636363"
        set SGSS_TypeStr[2101]="|cffffffff"
        set SGSS_TypeStr[2102]="|cff80ff00"
        set SGSS_TypeStr[2103]="|cff0080ff"
        set SGSS_TypeStr[2104]="|cff8080ff"
        set SGSS_TypeStr[2105]="|cffffff00"
        set SGSS_TypeStr[2106]="|cffff0000"
        set SGSS_TypeStr[2107]="|cffffa600"
        set SGSS_TypeStr[2200]="[普通]"
        set SGSS_TypeStr[2201]="[普通]"
        set SGSS_TypeStr[2202]="|cff52E252[优良]|r"
        set SGSS_TypeStr[2203]="|cff0080ff[罕见]|r"
        set SGSS_TypeStr[2204]="|cff8080ff[稀有]|r"
        set SGSS_TypeStr[2205]="|cffffff00[传说]|r"
        set SGSS_TypeStr[2206]="|cffff0000[神话]|r"
        set SGSS_TypeStr[2207]="|cFF3E3151[混沌]|r"
        set i=1
        loop
        exitwhen ( i >= 8 )
            set SGSS_TypeStrHash[i]=StringHash(SGSS_TypeStr[i])
            set SGSS_TypeStr[100 + i]=( SGSS_TypeStr[i] + "英雄等级加成" )
            set SGSS_TypeStrHash[100 + i]=StringHash(SGSS_TypeStr[100 + i])
            set SGSS_TypeStr[200 + i]=( SGSS_TypeStr[i] + "英雄等级加成值" )
            set SGSS_TypeStrHash[200 + i]=StringHash(SGSS_TypeStr[200 + i])
            set SGSS_TypeStrHash[i]=StringHash(SGSS_TypeStr[i])
            set SGSS_TypeStr[300 + i]=( SGSS_TypeStr[i] + "英雄装备属性加成" )
            set SGSS_TypeStrHash[300 + i]=StringHash(SGSS_TypeStr[300 + i])
            set SGSS_TypeStr[400 + i]=( SGSS_TypeStr[i] + "英雄装备属性加成值" )
            set SGSS_TypeStrHash[400 + i]=StringHash(SGSS_TypeStr[400 + i])
        set i=i + 1
        endloop
        set SGSS_TypeStr[4000]="Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl"
        set SGSS_TypeStr[4001]="Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl"
        set SGSS_TypeStr[4002]="war3mapImported\\baoxiang5.mdl"
        set SGSS_TypeStr[4003]="war3mapImported\\baoxiang3.mdl"
        set SGSS_TypeStr[4004]="war3mapImported\\baoxiang4.mdl"
        set SGSS_TypeStr[4005]="war3mapImported\\baoxiang1.mdl"
        set SGSS_TypeStr[4006]="war3mapImported\\baoxiang2.mdl"
        set SGSS_TypeStr[4007]="war3mapImported\\baoxiang6.mdl"
    endfunction
    function StarGSS__onInit takes nothing returns nothing
        call TriggerExecute(st___prototype6[(1)]) // INLINED!!
    endfunction

//library StarGSS ends
//===========================================================================
//*
//*  Global variables
//*
//===========================================================================
//Star 
    // if ydl_localvar_step>250000 then YDNL    //     set ydl_localvar_step = ydl_localvar_step - 250000 YDNL     // endif YDNL    // call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)           YDNL    // call YDHashSet(YDLOC, integer, YDHashH2I(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
    
function InitGlobals takes nothing returns nothing
local integer i= 0
set i=0
loop
exitwhen ( i > 200 )
set udg_TempUnit[i]=null
set i=i + 1
endloop
set udg_TempDmg=0
set udg_TempStr=0
set udg_TempAgi=0
set udg_TempInt=0
set udg_TempHp=0
set udg_TempArmor=0
set udg_TempIsAdd=false
set udg_TempMp=0
set udg_TempAtkSpeed=0
set udg_TempMoveSpeed=0
set udg_TempAll=0
set i=0
loop
exitwhen ( i > 20 )
set udg_TempAmount[i]=0
set i=i + 1
endloop
set udg_TempStatCount=0
set i=0
loop
exitwhen ( i > 20 )
set udg_TempString[i]=""
set i=i + 1
endloop
set i=0
loop
exitwhen ( i > 20 )
set udg_TempReadValue[i]=0
set i=i + 1
endloop
set udg_TempScoreMin=0
set udg_TempScoreMax=0
set udg_TempItemType=0
set udg_RegEventStr=""
set udg_T=0
set udg_TempFacing=0
set i=0
loop
exitwhen ( i > 20 )
set udg_TempReal[i]=0
set i=i + 1
endloop
set i=0
loop
exitwhen ( i > 20 )
set udg_TempInteger[i]=0
set i=i + 1
endloop
set udg_TempDamageType=0
set i=0
loop
exitwhen ( i > 30 )
set udg_JSQ[i]=CreateTimer()
set i=i + 1
endloop
endfunction
function InitRandomGroups takes nothing returns nothing
local integer curset
endfunction
function InitSounds takes nothing returns nothing
endfunction
function CreateDestructables takes nothing returns nothing
local destructable d
local trigger t
local real life
endfunction
function CreateItems takes nothing returns nothing
local integer itemID
call CreateItem('I00P', - 632.1, 26.8)
call CreateItem('rspd', - 566.2, 405.6)
call CreateItem('I00P', - 424.2, 22.8)
call CreateItem('I00P', - 416.6, - 207.0)
call CreateItem('texp', - 740.5, 476.0)
call CreateItem('pres', - 663.7, 106.8)
call CreateItem('wlsd', - 266.9, 277.0)
call CreateItem('I00V', - 123.2, 172.8)
call CreateItem('I00V', - 86.7, 52.0)
call CreateItem('I00V', - 635.1, - 211.8)
call CreateItem('I00V', - 79.9, 242.4)
call CreateItem('I00V', - 38.4, 164.5)
call CreateItem('pres', - 379.6, 364.2)
endfunction
function CreateUnits takes nothing returns nothing
local unit u
local integer unitID
local trigger t
local real life
set u=CreateUnit(Player(0), 'Hamg', - 512.6, 219.9, 352.7)
set gg_unit_Hamg_0002=u
set life=GetUnitState(u, UNIT_STATE_LIFE)
call SetUnitState(u, UNIT_STATE_LIFE, 0.500000 * life)
set u=CreateUnit(Player(15), 'hfoo', 729.6, 553.3, 225.6)
set u=CreateUnit(Player(3), 'htow', 576.0, 0.0, 270.0)
set u=CreateUnit(Player(0), 'Hmkg', - 702.0, - 336.9, 272.4)
set u=CreateUnit(Player(15), 'hfoo', 649.7, - 466.2, 268.0)
endfunction
function CreateRegions takes nothing returns nothing
local weathereffect we
set gg_rct______________000=Rect(448, - 224, 672, 0)
set gg_rct______________001=Rect(- 640, - 224, - 416, 32)
set gg_rct______________002=Rect(- 1376, - 288, 576, 1376)
set gg_rct______________003=Rect(384, - 288, 800, 192)
endfunction
function CreateCameras takes nothing returns nothing
endfunction
//TESH.scrollpos=0
//TESH.alwaysfold=0
﻿﻿
//Base.j require
//基础库
//List库
//在自定义代码区顶部输入 #include "Star\\StarList.j" 来引用List
//new List 例如 integer list = SCreateList(location)
//List.Count 例如 integer count = SGetCount(location,1) 读取ID为1的List<location>
//List.Remove 例如 SRemoveAny(location,l,1) 把点 l 从 ID为1 的 List<location> 中移除
//List.Add  例如 SAddAny(location,l,1) 把点 l 从 添加至 ID为1 的 List<location> 中
//List.Destroy 例如 SRemoveList(location,1) 摧毁 ID为1 的List<location>
//List.Clear 例如 SClearList(location,1) 清空 ID为1 的List<location>
//List.First 例如 location p = SFirstOfList(location,1) 获取 ID为1 的List<location>中第一个location
//forlist t = Trigger  
//forlist t = function name
//在ForList中用于获取选取的成员
//事件监听库
//事件.j





//为单位注册添加事件响应 参数 单位 事件名 触发器 禁止重复添加
//为单位移除事件响应 参数 单位 事件名 触发器 禁止重复添加
//StarUI加载资源文件



    

    

    

    

    
//这里是逆天TJ交互部分宏定义文件
//逆天读写 宏定义
//清除逆天计时器/触发器内逆天局部 and 清除handle对象身上的逆天自定义值
//逆天局部写-逆天计时器（外部）
//逆天局部读-逆天计时器（外部）
//逆天局部写-逆天计时器
//逆天局部读-逆天计时器
//逆天局部读-触发器
//逆天局部读-组动作
//逆天局部读-逆天触发器
//逆天参数读-逆天计时器
//逆天自定义值读/写
//逆天-触发器运行 参数读写
// [弃用] -->逆天UI增强已经修复 逆天触发器-运行-参数——写 forRun 逆天触发器
//逆天计时器内-组读/写 只是为了兼容旧版本(YDWE1.27.6)的TJ交互实现的组读写
// #define LOCTSET8(_type,s,v)  YDLocal8Set(##_type,#s, ##v)
//LOCT2支持库
//逆天运行触发器-参数-读
//读取逆天-运行触发器参数
//#define LOCTEX1(_type,u) YDLocalGet(, ##_type, #u)
//#define LOCAL(_type,u) YDLocal1Get(##_type,#u)
//逆天参数清除-在逆天计时器
//逆天参数清除-在逆天触发器
//逆天参数清除-在主触发器
//逆天-数组清除(名字,索引)-在主触发器
//逆天局部变量++
//++i 
//逆天局部变量++_计时器版本
//++i 
//在逆天计时器内使用 使用变量s 循环max次时退出逆天计时器
//逆天局部变量++_逆天触发器版本
//++i 
//逆天变量自加 // new
//自用 ： 判断单位u上的布尔值s为true
//自用 : 延迟t秒后设置单位u上的s为false
//缩写定义
// #define float real
// #define bool boolean
// #define int integer
function Bridge_STES_Register takes nothing returns nothing
//call STES_Register(udg_RegTrigger, udg_RegEventStr)
endfunction
//===========================================================================
// Trigger: 未命名触发器 002
//===========================================================================
function Trig____________________002Actions takes nothing returns nothing
call DzLoadToc("ui\\MagePortrait5.toc")
call QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "424")
endfunction
//===========================================================================
function InitTrig____________________002 takes nothing returns nothing
set gg_trg____________________002=CreateTrigger()
call TriggerRegisterTimerEventSingle(gg_trg____________________002, 1.50)
call TriggerAddAction(gg_trg____________________002, function Trig____________________002Actions)
endfunction
//===========================================================================
// Trigger: 未命名触发器 004
//===========================================================================
function Trig____________________004Actions takes nothing returns nothing
endfunction
//===========================================================================
function InitTrig____________________004 takes nothing returns nothing
set gg_trg____________________004=CreateTrigger()
call TriggerAddAction(gg_trg____________________004, function Trig____________________004Actions)
endfunction
//===========================================================================
// Trigger: 初始化
//===========================================================================
function Trig__________uActions takes nothing returns nothing
call Cheat("exec-lua:test")
set udg_TempUnit[200]=null
set udg_TempReal[8000]=50.00
call SaveGroupHandle(YDHT, StringHash("玩家英雄"), 0x0A4A1F64, CreateGroup())
call GroupAddUnit(LoadGroupHandle(YDHT, StringHash("玩家英雄"), 0x0A4A1F64), gg_unit_Hamg_0002)
call AdjustPlayerStateBJ(1000, Player(0), PLAYER_STATE_RESOURCE_GOLD)
endfunction
//===========================================================================
function InitTrig__________u takes nothing returns nothing
set gg_trg__________u=CreateTrigger()
call TriggerAddAction(gg_trg__________u, function Trig__________uActions)
endfunction
//===========================================================================
// Trigger: dmg
//===========================================================================
function Trig_dmgConditions takes nothing returns boolean
return ( ( LoadBoolean(YDHT, GetHandleId(gg_unit_Hamg_0002), 0x437E2A40) == false ) )
endfunction
function Trig_dmgActions takes nothing returns nothing
call EXSetEventDamage(((50.00)*1.0)) // INLINED!!
set udg_TempReal[10]=50.00
endfunction
//===========================================================================
function InitTrig_dmg takes nothing returns nothing
set gg_trg_dmg=CreateTrigger()
call MNAnyUnitDamaged(gg_trg_dmg , 1.00)
call TriggerAddCondition(gg_trg_dmg, Condition(function Trig_dmgConditions))
call TriggerAddAction(gg_trg_dmg, function Trig_dmgActions)
endfunction
//===========================================================================
// Trigger: GetDmgType
//===========================================================================
function Trig_GetDmgTypeActions takes nothing returns nothing
if ( ( ((DAMAGE_TYPE_NORMAL) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 1 ) )
else
endif
if ( ( ((DAMAGE_TYPE_ENHANCED) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 2 ) )
else
endif
if ( ( ((DAMAGE_TYPE_FIRE) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 4 ) )
else
endif
if ( ( ((DAMAGE_TYPE_COLD) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 8 ) )
else
endif
if ( ( ((DAMAGE_TYPE_LIGHTNING) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 16 ) )
else
endif
if ( ( ( ((DAMAGE_TYPE_POISON) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) or ( ((DAMAGE_TYPE_DISEASE) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) or ( ((DAMAGE_TYPE_SLOW_POISON) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 32 ) )
else
endif
if ( ( ((DAMAGE_TYPE_DIVINE) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 64 ) )
else
endif
if ( ( ((DAMAGE_TYPE_MAGIC) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 128 ) )
else
endif
if ( ( ((DAMAGE_TYPE_MIND) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 256 ) )
else
endif
if ( ( ((DAMAGE_TYPE_PLANT) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 512 ) )
else
endif
if ( ( ((DAMAGE_TYPE_SHADOW_STRIKE) == ConvertDamageType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_DAMAGE_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 1024 ) )
else
endif
if ( ( ((ATTACK_TYPE_NORMAL) == ConvertAttackType(EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_ATTACK_TYPE))) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 2048 ) )
else
endif
if ( ( (0 != EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_PHYSICAL)) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 4096 ) )
else
endif
if ( ( (0 != EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_ATTACK)) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 8192 ) )
else
endif
if ( ( (0 != EXGetEventDamageData(YDWEEventDamageData___EVENT_DAMAGE_DATA_IS_RANGED)) == true ) ) then // INLINED!!
set udg_TempDamageType=( ( udg_TempDamageType ) + ( 16384 ) )
else
endif
endfunction
//===========================================================================
function InitTrig_GetDmgType takes nothing returns nothing
set gg_trg_GetDmgType=CreateTrigger()
call MNAnyUnitDamaged(gg_trg_GetDmgType , 60)
call TriggerAddAction(gg_trg_GetDmgType, function Trig_GetDmgTypeActions)
endfunction
//TESH.scrollpos=0
//TESH.alwaysfold=0
//这里的所有函数是配合ts→lua的调用
//===========================================================================
// 装备系统 - SGSS属性修改 (ID 1-10) + 玩家属性修改，lua实现
//===========================================================================
function ApplyItemBonus takes nothing returns nothing
local integer ydul_i
local integer ydul_i2
local unit u= udg_TempUnit[1]
local player p= GetOwningPlayer(u)
local real hp= udg_TempHp
local real mp= udg_TempMp
local real dmg= udg_TempDmg
local real armor= udg_TempArmor
local real atkSpeed= udg_TempAtkSpeed
local real moveSpeed= udg_TempMoveSpeed
local real str= udg_TempStr
local real agi= udg_TempAgi
local real int= udg_TempInt
local real all= udg_TempAll
local boolean isAdd= udg_TempIsAdd
local real value
local integer ydl_localvar_step= LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76)
 set ydl_localvar_step=ydl_localvar_step + 3
 call SaveInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)
 call SaveInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
set ydul_i=1
set ydul_i2=1
// 调试：看看单位是否存在
//call BJDebugMsg("【调试】udg_TempUnit[1] 是否存在：" + I2S(GetHandleId(udg_TempUnit[1])))
if isAdd then
set value=1.0
else
set value=- 1.0
endif
if dmg != 0.0 then
call SGSS_SetState(u , 1 , dmg * value)
endif
if armor != 0.0 then
call SGSS_SetState(u , 2 , armor * value)
endif
if str != 0.0 then
call SGSS_SetState(u , 3 , str * value)
endif
if agi != 0.0 then
call SGSS_SetState(u , 4 , agi * value)
endif
if int != 0.0 then
call SGSS_SetState(u , 5 , int * value)
endif
if all != 0.0 then
call SGSS_SetState(u , 6 , all * value)
endif
if hp != 0.0 then
call SGSS_SetState(u , 7 , hp * value)
endif
if mp != 0.0 then
call SGSS_SetState(u , 8 , mp * value)
endif
if moveSpeed != 0.0 then
call SGSS_SetState(u , 9 , moveSpeed * value)
endif
if atkSpeed != 0.0 then
call SGSS_SetState(u , 10 , atkSpeed * value)
endif
loop
exitwhen ydul_i > udg_TempStatCount
if ( ( IsUnitInGroup(udg_TempUnit[1], LoadGroupHandle(YDHT, StringHash("玩家英雄"), 0x0A4A1F64)) == false ) ) then
call SaveReal(YDHT, GetHandleId(udg_TempUnit[1]), StringHash(LoadStr(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step, 0x6913AF34 + ( ydul_i ))), ( ( LoadReal(YDHT, GetHandleId(udg_TempUnit[1]), StringHash(LoadStr(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step, 0x6913AF34 + ( ydul_i )))) ) + ( udg_TempAmount[ydul_i] ) ))
else
if ( ( udg_TempString[ydul_i] != "移动速度" ) ) then
call SaveReal(YDHT, GetHandleId(GetOwningPlayer(udg_TempUnit[1])), StringHash(udg_TempString[ydul_i]), ( ( LoadReal(YDHT, GetHandleId(GetOwningPlayer(udg_TempUnit[1])), StringHash(udg_TempString[ydul_i])) ) + ( udg_TempAmount[ydul_i] ) ))
//测试用，调试信息
//  call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, I2S( udg_TempStatCount))
//  call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, R2S( YDUserDataGet2(player, GetOwningPlayer( udg_TempUnit[1]),udg_TempString[ydul_i], real)))
//===========================================================================
//动态百分比属性
//===========================================================================
if ( ( udg_TempString[ydul_i] == "最大生命值%" ) ) then
call SGSS_SetUnitHPPercentum(udg_TempUnit[1] , udg_TempAmount[ydul_i])
endif
//=============================================================================
//动态基础百分比属性
//=============================================================================
if ( ( udg_TempString[ydul_i] == "基础攻击力%" ) ) then
call GS_UnitPry(udg_TempUnit[1] , 0 , 14 , udg_TempAmount[ydul_i])
endif
//==============================================================================
//金币/经验获取率
//==============================================================================
if ( ( udg_TempString[ydul_i] == "经验获取率" ) ) then
call SaveReal(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step, 0x5895FD64, ( ( 0.35 ) + ( ( ( 0.65 ) * ( udg_T ) ) ) ))
call SetPlayerHandicapXP(GetOwningPlayer(udg_TempUnit[1]), ( ( LoadReal(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step, 0x5895FD64) ) * ( udg_TempAmount[ydul_i] ) ))
endif
endif
endif
set ydul_i=ydul_i + 1
endloop
call FlushChildHashtable(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step)
//set udg_TempUnit[1] = null
set udg_TempHp=0.0
set udg_TempMp=0.0
set udg_TempDmg=0.0
set udg_TempArmor=0.0
set udg_TempAtkSpeed=0.0
set udg_TempMoveSpeed=0.0
set udg_TempStr=0.0
set udg_TempAgi=0.0
set udg_TempInt=0.0
set udg_TempAll=0.0
//call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, R2S( YDUserDataGet2(player, GetOwningPlayer( udg_TempUnit[1]),udg_TempString[ydul_i], real)))
// ========== 读取所有属性值到数组 ==========
if udg_TempStatCount > 0 then
set ydul_i2=1
loop
exitwhen ydul_i2 > udg_TempStatCount
set udg_TempReadValue[ydul_i2]=LoadReal(YDHT, GetHandleId(p), StringHash(udg_TempString[ydul_i2]))
//测试用，调试信息
//call QuestMessageBJ( GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, ("测试22" + R2S( udg_TempReadValue[ydul_i2])))
set ydul_i2=ydul_i2 + 1
endloop
endif
set u=null
set p=null
endfunction
//============================================================================
//单位狂暴//
//============================================================================
function UnitBerserk takes nothing returns nothing
call EXSetUnitFacing(udg_TempUnit[1], ( udg_TempFacing ))
call Cya_CameraSetEQNoiseForPlayer(udg_TempPlayer[1] , 20 , 3.00)
set udg_TempUnit[1]=null
set udg_TempPlayer[1]=null
set udg_TempFacing=0.00
endfunction
//============================================================================
//模拟魔兽原生移动速度的函数，通过lua实现
//============================================================================
function movespeed2 takes nothing returns nothing
call SGSS_SetState(udg_TempUnit[1] , 9 , udg_TempReal[1])
endfunction
//============================================================================
//取得单位主属性
//============================================================================
function GetHeroMainAttribute takes nothing returns nothing
set udg_TempInteger[1]=0
if ( ( ( EXExecuteScript("(require'jass.slk').unit[" + I2S(GetUnitTypeId(udg_TempUnit[1])) + "].Primary") ) == "STR" ) ) then
set udg_TempInteger[1]=1
endif
if ( ( ( EXExecuteScript("(require'jass.slk').unit[" + I2S(GetUnitTypeId(udg_TempUnit[1])) + "].Primary") ) == "AGI" ) ) then
set udg_TempInteger[1]=2
endif
if ( ( ( EXExecuteScript("(require'jass.slk').unit[" + I2S(GetUnitTypeId(udg_TempUnit[1])) + "].Primary") ) == "INT" ) ) then
set udg_TempInteger[1]=3
endif
endfunction
//TESH.scrollpos=0
//TESH.alwaysfold=0
//===========================================================================
// Trigger: 假装调用！
//===========================================================================
function Trig________________uActions takes nothing returns nothing
call ApplyItemBonus()
call UnitBerserk()
call SGSS_SetState(udg_TempUnit[1] , 9 , udg_TempReal[1]) // INLINED!!
call GetHeroMainAttribute()
call DzGetMouseX()
endfunction
//===========================================================================
function InitTrig________________u takes nothing returns nothing
set gg_trg________________u=CreateTrigger()
call TriggerAddAction(gg_trg________________u, function Trig________________uActions)
endfunction
//===========================================================================
// Trigger: 装备提取
//===========================================================================
function Trig_____________uActions takes nothing returns nothing
local integer star_loopA
local integer star_loopIndex
local integer star_hash
local integer ydl_triggerstep
local trigger ydl_trigger
local integer ydl_localvar_step= LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76)
 set ydl_localvar_step=ydl_localvar_step + 3
 call SaveInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)
 call SaveInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
set udg_TempScoreMin=150.00
set udg_TempScoreMax=350.00
set star_hash=StringHash("11")
set star_loopIndex=LoadInteger((STES__HT), star_hash, skey_index) // INLINED!!
set star_loopA=0
loop
exitwhen star_loopA >= star_loopIndex
set ydl_trigger=LoadTriggerHandle((STES__HT), star_hash, star_loopA) // INLINED!!
set ydl_triggerstep=GetHandleId(ydl_trigger) * ( LoadInteger(YDLOC, GetHandleId(ydl_trigger), 0xCFDE6C76) + 3 )

call SaveInteger(YDHT, GetHandleId(ydl_trigger), SKey_PIndex, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step)
call SaveReal(YDLOC, ydl_triggerstep, 0xF18A3536, 0.00)
call TriggerExecute(ydl_trigger)
set star_loopA=star_loopA + 1
endloop
call CreateItem(( udg_TempItemType ), 0.00, 0.00)
call FlushChildHashtable(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step)
set ydl_trigger=null
endfunction
//===========================================================================
function InitTrig_____________u takes nothing returns nothing
set gg_trg_____________u=CreateTrigger()
call TriggerRegisterPlayerChatEvent(gg_trg_____________u, Player(0), "22", true)
call TriggerAddAction(gg_trg_____________u, function Trig_____________uActions)
endfunction
//TESH.scrollpos=0
//TESH.alwaysfold=0
//更改攻击类型
function Lua_SetUnitAttackType takes unit u,integer attackType returns nothing
call Ir_SetUnitAttackType(gg_unit_Hamg_0002 , 5)
endfunction
//===========================================================================
// Trigger: 查看movespeed
//===========================================================================
function Trig_______movespeedActions takes nothing returns nothing
call QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, R2S(GetUnitMoveSpeed(gg_unit_Hamg_0002)))
endfunction
//===========================================================================
function InitTrig_______movespeed takes nothing returns nothing
set gg_trg_______movespeed=CreateTrigger()
call TriggerRegisterPlayerChatEvent(gg_trg_______movespeed, Player(0), "ydsd", true)
call TriggerAddAction(gg_trg_______movespeed, function Trig_______movespeedActions)
endfunction
//===========================================================================
// Trigger: 查看属性am
//===========================================================================
function Trig_____________amActions takes nothing returns nothing
local integer ydl_localvar_step= LoadInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76)
 set ydl_localvar_step=ydl_localvar_step + 3
 call SaveInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xCFDE6C76, ydl_localvar_step)
 call SaveInteger(YDLOC, GetHandleId(GetTriggeringTrigger()), 0xECE825E7, ydl_localvar_step)
call SaveReal(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step, 0x437E2A40, GetItemX(GetLastCreatedItem()))
call SaveBoolean(YDHT, GetHandleId(gg_unit_Hamg_0002), 0x437E2A40, true)
call QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, R2S(LoadReal(YDHT, GetHandleId(GetOwningPlayer(udg_TempUnit[1])), StringHash(GetEventPlayerChatString()))))
call FlushChildHashtable(YDLOC, GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step)
endfunction
//===========================================================================
function InitTrig_____________am takes nothing returns nothing
set gg_trg_____________am=CreateTrigger()
call TriggerRegisterPlayerChatEvent(gg_trg_____________am, Player(0), GetEventPlayerChatString(), true)
call TriggerAddAction(gg_trg_____________am, function Trig_____________amActions)
endfunction
//===========================================================================
// Trigger: 未命名触发器 003
//===========================================================================
function Trig____________________003Actions takes nothing returns nothing
call QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, "1111")
endfunction
//===========================================================================
function InitTrig____________________003 takes nothing returns nothing
set gg_trg____________________003=CreateTrigger()
call DzTriggerRegisterKeyEventTrg(gg_trg____________________003 , 1 , 'A')
call TriggerAddAction(gg_trg____________________003, function Trig____________________003Actions)
endfunction
//===========================================================================
// Trigger: HealItemEffect
//===========================================================================
function Trig_HealItemEffectActions takes nothing returns nothing
call QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, R2S(udg_TempReal[1]))
call QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, R2S(udg_TempReal[2]))
call QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_UPDATED, udg_TempString[0])
set udg_TempReal[1]=0.00
set udg_TempReal[2]=0.00
endfunction
//===========================================================================
function InitTrig_HealItemEffect takes nothing returns nothing
set gg_trg_HealItemEffect=CreateTrigger()
call TriggerAddAction(gg_trg_HealItemEffect, function Trig_HealItemEffectActions)
endfunction
//===========================================================================
function InitCustomTriggers takes nothing returns nothing
call InitTrig____________________002()
call InitTrig____________________004()
call InitTrig__________u()
call InitTrig_dmg()
call InitTrig_GetDmgType()
call InitTrig________________u()
call InitTrig_____________u()
call InitTrig_______movespeed()
call InitTrig_____________am()
call InitTrig____________________003()
call InitTrig_HealItemEffect()
endfunction
//===========================================================================
function RunInitializationTriggers takes nothing returns nothing
call ConditionalTriggerExecute(gg_trg__________u)
endfunction
function InitCustomPlayerSlots takes nothing returns nothing
call SetPlayerStartLocation(Player(0), 0)
call SetPlayerColor(Player(0), ConvertPlayerColor(0))
call SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
call SetPlayerRaceSelectable(Player(0), false)
call SetPlayerController(Player(0), MAP_CONTROL_USER)
call SetPlayerStartLocation(Player(1), 1)
call SetPlayerColor(Player(1), ConvertPlayerColor(1))
call SetPlayerRacePreference(Player(1), RACE_PREF_ORC)
call SetPlayerRaceSelectable(Player(1), false)
call SetPlayerController(Player(1), MAP_CONTROL_USER)
endfunction
function InitCustomTeams takes nothing returns nothing
// Force: TRIGSTR_007
call SetPlayerTeam(Player(0), 0)
call SetPlayerTeam(Player(1), 0)
endfunction
function InitAllyPriorities takes nothing returns nothing
call SetStartLocPrioCount(0, 1)
call SetStartLocPrio(0, 0, 1, MAP_LOC_PRIO_HIGH)
call SetStartLocPrioCount(1, 1)
call SetStartLocPrio(1, 0, 0, MAP_LOC_PRIO_HIGH)
endfunction
//===========================================================================
//*
//*  Main Initialization
//*
//===========================================================================
function StarBlockInitTimerEvent takes nothing returns nothing
call BJDebugMsg("鸣谢 -> 星星")
call DestroyTimer(GetExpiredTimer())
endfunction
function StarBlockInit takes nothing returns nothing
local timer t= CreateTimer()
call TimerStart(t, 1, false, function StarBlockInitTimerEvent)
set t=null
endfunction
function main takes nothing returns nothing
call SetCameraBounds(- 3328.000000 + GetCameraMargin(CAMERA_MARGIN_LEFT), - 3584.000000 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.000000 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.000000 - GetCameraMargin(CAMERA_MARGIN_TOP), - 3328.000000 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.000000 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.000000 - GetCameraMargin(CAMERA_MARGIN_RIGHT), - 3584.000000 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
call SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
call NewSoundEnvironment("Default")
call SetAmbientDaySound("LordaeronSummerDay")
call SetAmbientNightSound("LordaeronSummerNight")
call SetMapMusic("Music", true, 0)
call InitSounds()
call InitRandomGroups()
call CreateRegions()
call CreateCameras()
call CreateDestructables()
call CreateItems()
call CreateUnits()
call InitBlizzard()

call ExecuteFunc("jasshelper__initstructs31828796")
call ExecuteFunc("SLDebugLib__luainit")
call ExecuteFunc("SLInteger__onInit")
call ExecuteFunc("SLReal__onInit")
call ExecuteFunc("SLStr__onInit")
call ExecuteFunc("StarEvent__onInit")
call ExecuteFunc("X__Init")
call ExecuteFunc("YDTriggerSaveLoadSystem__Init")
call ExecuteFunc("StarBase__onInit")
call ExecuteFunc("StarUnit__onInit")
call ExecuteFunc("item_init")
call ExecuteFunc("STES__onInit")
call ExecuteFunc("StarDebugger__onInit")
call ExecuteFunc("StarString__onInit")
call ExecuteFunc("SUTriggerList__onInit")
call ExecuteFunc("StarGSS__onInit")

    call InitGlobals()
    call Cheat("exec-lua:war3map")
    call Cheat("exec-lua:war3map")
    call Cheat("exec-lua:war3map")
call ExecuteFunc("InitCustomTriggers")
call ConditionalTriggerExecute(gg_trg__________u) // INLINED!!
call TriggerExecute(st___prototype6[(2)]) // INLINED!!
endfunction
//===========================================================================
//*
//*  Map Configuration
//*
//===========================================================================
function config takes nothing returns nothing
call SetMapName("神隐testmap")
call SetMapDescription("没有说明")
call SetPlayers(2)
call SetTeams(2)
call SetGamePlacement(MAP_PLACEMENT_TEAMS_TOGETHER)
call DefineStartLocation(0, - 1152.000000, 64.000000)
call DefineStartLocation(1, 1920.000000, 640.000000)
call InitCustomPlayerSlots()
call InitCustomTeams()
call InitAllyPriorities()
endfunction




//Struct method generated initializers/callers:
function sa__StarOverSpeed__StarOverSpeedGenerator_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            call RemoveSavedInteger(StarBaseHT, GetHandleId(s__StarOverSpeed__StarOverSpeedGenerator_t[this]), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            call RemoveSavedInteger(StarBaseHT, GetHandleId(s__StarOverSpeed__StarOverSpeedGenerator_u[this]), s__StarOverSpeed__StarOverSpeedGenerator_hashkey)
            call DestroyTrigger(s__StarOverSpeed__StarOverSpeedGenerator_t[this])
            set s__StarOverSpeed__StarOverSpeedGenerator_u[this]=null //------------------出栈--------------
            if ( s__StarOverSpeed__StarOverSpeedGenerator_now != s__StarOverSpeed__StarOverSpeedGenerator_count - 1 ) then
                set s__StarOverSpeed__StarOverSpeedGenerator_skip=true
                set s__StarOverSpeed__StarOverSpeedGenerator_list[s__StarOverSpeed__StarOverSpeedGenerator_now]=s__StarOverSpeed__StarOverSpeedGenerator_list[s__StarOverSpeed__StarOverSpeedGenerator_count - 1]
            endif
            set s__StarOverSpeed__StarOverSpeedGenerator_count=s__StarOverSpeed__StarOverSpeedGenerator_count - 1
   return true
endfunction
function sa__StarOverSpeed__StarOverSpeedGenerator_Start takes nothing returns boolean

            if ( not ( s__StarOverSpeed__StarOverSpeedGenerator_IsRun ) ) then
                call TimerStart(s__StarOverSpeed__StarOverSpeedGenerator_Timer, 0.02, true, function s__StarOverSpeed__StarOverSpeedGenerator_anon__1)
                set s__StarOverSpeed__StarOverSpeedGenerator_IsRun=true
            endif
   return true
endfunction
function sa__StarOverSpeed__StarOverSpeedGenerator_Stop takes nothing returns boolean

            if ( s__StarOverSpeed__StarOverSpeedGenerator_IsRun ) then
                call PauseTimer(s__StarOverSpeed__StarOverSpeedGenerator_Timer)
                set s__StarOverSpeed__StarOverSpeedGenerator_IsRun=false
            endif
   return true
endfunction
function sa__SEffect_onDestroy takes nothing returns boolean
local integer this=f__arg_this
            call DestroyEffect(s__SEffect_object[this]) //为区块移除对象
            call s__Block_remove(s__Block_blocks[s__SEffect_own[this]],this)
   return true
endfunction
function sa__SEffect_SetRotateZ takes nothing returns boolean
    call s__SEffect_SetRotateZ(f__arg_effect1,f__arg_real1)
   return true
endfunction
function sa__Vector3_Scale takes nothing returns boolean
local integer this=f__arg_this
local real factor=f__arg_real1
            set s__Vector2_X[s__Vector3_Vector2[this]]=s__Vector2_X[s__Vector3_Vector2[this]] * factor
            set s__Vector2_Y[s__Vector3_Vector2[this]]=s__Vector2_Y[s__Vector3_Vector2[this]] * factor
            set s__Vector3_Z[this]=s__Vector3_Z[this] * factor
set f__result_integer= this
   return true
endfunction
function sa__Vector3_CrossProduct takes nothing returns boolean
local integer this=f__arg_this
local integer that=f__arg_integer1
            local integer result=s__Vector3_create()
            set s__Vector2_X[s__Vector3_Vector2[result]]=s__Vector2_Y[s__Vector3_Vector2[this]] * s__Vector3_Z[that] - s__Vector2_Y[s__Vector3_Vector2[that]] * s__Vector3_Z[this]
            set s__Vector2_Y[s__Vector3_Vector2[result]]=s__Vector3_Z[this] * s__Vector2_X[s__Vector3_Vector2[that]] - s__Vector3_Z[that] * s__Vector2_X[s__Vector3_Vector2[this]]
            set s__Vector3_Z[result]=s__Vector2_X[s__Vector3_Vector2[this]] * s__Vector2_Y[s__Vector3_Vector2[that]] - s__Vector2_X[s__Vector3_Vector2[that]] * s__Vector2_Y[s__Vector3_Vector2[this]]
set f__result_integer= result
   return true
endfunction
function sa__Vector2_Scale takes nothing returns boolean
local integer this=f__arg_this
local real factor=f__arg_real1
            set s__Vector2_X[this]=s__Vector2_X[this] * factor
            set s__Vector2_Y[this]=s__Vector2_Y[this] * factor
set f__result_integer= this
   return true
endfunction
function sa__Argb_ToString takes nothing returns boolean
local integer this=f__arg_this
            local string result=""
            local integer array arr
            local integer i
            set arr[0]=s__Argb__get_A(this)
            set arr[1]=s__Argb__get_R(this)
            set arr[2]=s__Argb__get_G(this)
            set arr[3]=s__Argb__get_B(this)
            set i=0
            loop
            exitwhen ( i >= 4 )
                if ( arr[i] < 16 ) then
                    set result=result + "0"
                endif
                set result=result + s__Convert_Int2S(arr[i] , 16)
            set i=i + 1
            endloop
set f__result_string= result
   return true
endfunction
function sa__Convert_S2Id takes nothing returns boolean
local string s=f__arg_string1
            local string charSet=s__Convert_charSet
            local integer strLength=StringLength(s)
            local integer result=0
            local integer char=0
            local integer i=0
            set i=0
            loop
            exitwhen ( i >= strLength )
                set char=s__StringUtil_IndexOf(charSet , SubString(s, i, i + 1)) //debug Print(char>= 0, "[Convert.S2Id] The converted char is not between 32 &&  126!");
                set result=result + ( char + 32 ) * sc__Convert_R2I((Pow(((256.0 )*1.0), (( strLength - i - 1)*1.0)))) // INLINED!!
            set i=i + 1
            endloop
set f__result_integer= result
   return true
endfunction
function sa__Convert_Id2S takes nothing returns boolean
local integer id=f__arg_integer1
            local string charSet=s__Convert_charSet
            local string result=""
            local integer modulo=0
            loop
            exitwhen ( id <= 0 )
                set modulo=sc__Convert_R2I(s__Math_Modulo(id , 256.0))
                if ( modulo < 32 or modulo > 126 ) then
                    set result=result + "€"
                endif
                set result=result + SubString(charSet, modulo - 32, modulo - 31)
                set id=id / 256
            endloop
set f__result_string= result
   return true
endfunction
function sa__Convert_R2I takes nothing returns boolean
local real r=f__arg_real1
set f__result_integer= (R2I(((r)*1.0))) // INLINED!!
   return true
endfunction
function sa__Convert_R2S takes nothing returns boolean
local real r=f__arg_real1
set f__result_string= (R2S(((r)*1.0))) // INLINED!!
   return true
endfunction
function sa__StringUtil_IndexOf takes nothing returns boolean
local string str=f__arg_string1
local string sub=f__arg_string2
            local integer strLen=StringLength(str)
            local integer subLen=StringLength(sub)
            local integer i=0
            if ( strLen >= subLen and subLen > 0 ) then
                set i=0
                loop
                exitwhen i > strLen - subLen
                    if ( sub == sc__StringUtil_SubString(str , i , subLen) ) then
set f__result_integer= i
return true
                    endif
                set i=i + 1
                endloop
            endif
set f__result_integer= - 1
   return true
endfunction
function sa__StringUtil_CharAt takes nothing returns boolean
local string str=f__arg_string1
local integer index=f__arg_integer1
            if ( index < 0 ) then
                set index=StringLength(str) + index
            endif
set f__result_string= (SubString((str ), ( index ), ( index + 1))) // INLINED!!
   return true
endfunction
function sa__StringUtil_SubString takes nothing returns boolean
local string str=f__arg_string1
local integer begin=f__arg_integer1
local integer length=f__arg_integer2
set f__result_string= (SubString((str ), ( begin ), ( begin + length))) // INLINED!!
   return true
endfunction
function sa__Math_GetRandomReal takes nothing returns boolean
local real low=f__arg_real1
local real high=f__arg_real2
set f__result_real= (GetRandomReal(((low )*1.0), (( high)*1.0))) // INLINED!!
   return true
endfunction
function sa__Math_Cos takes nothing returns boolean
local real r=f__arg_real1
set f__result_real= (Cos(((r)*1.0))) // INLINED!!
   return true
endfunction
function sa__Math_Atan2 takes nothing returns boolean
local real y=f__arg_real1
local real x=f__arg_real2
set f__result_real= (Atan2(((y )*1.0), (( x)*1.0))) // INLINED!!
   return true
endfunction
function sa__Math_Power takes nothing returns boolean
local real a=f__arg_real1
local real power=f__arg_real2
set f__result_real= Pow(a, power)
   return true
endfunction
function sa__Math_Exp takes nothing returns boolean
local real power=f__arg_real1
set f__result_real= Pow(s__Math_E, power)
   return true
endfunction
function sa__Math_Modulo takes nothing returns boolean
local real dividend=f__arg_real1
local real divisor=f__arg_real2
            local real modulus=dividend - I2R(R2I(dividend / divisor)) * divisor
            if ( modulus < 0 ) then
                set modulus=modulus + divisor
            endif
set f__result_real= modulus
   return true
endfunction
function sa__Math_Ln takes nothing returns boolean
local real r=f__arg_real1
            local real sum=0.0
            local real e=1.648721
            local real b=0.0
            loop
            exitwhen ( r < s__Math_E )
                set r=r / s__Math_E
                set sum=sum + 1.0
            endloop
            if ( r >= e ) then
                set r=r / e
                set sum=sum + 0.5
            endif
            set e=1.0
            set r=r - 1.0
            set b=r
            loop
            exitwhen ( e > 5.0 )
                set sum=sum + r / e
                set e=e + 1.0
                set r=r * b * ( - 1.0 )
            endloop
set f__result_real= sum
   return true
endfunction
function sa___prototype6_StarGSS__initVar takes nothing returns boolean

        local integer i=0
        set SGSS_TypeStr[1]="每级攻击力"
        set SGSS_TypeStr[2]="每级防御力"
        set SGSS_TypeStr[3]="每级力量值"
        set SGSS_TypeStr[4]="每级敏捷值"
        set SGSS_TypeStr[5]="每级智力值"
        set SGSS_TypeStr[6]="每级生命值"
        set SGSS_TypeStr[7]="每级法力值"
        set SGSS_TypeStr[1001]="|cffffffcc攻击力+"
        set SGSS_TypeStr[1002]="|cffc0c0c0防御力+"
        set SGSS_TypeStr[1003]="|cffff6800力量值+"
        set SGSS_TypeStr[1004]="|cffff6800敏捷值+"
        set SGSS_TypeStr[1005]="|cffff6800智力值+"
        set SGSS_TypeStr[1006]="|cff00ff00生命值+"
        set SGSS_TypeStr[1007]="|cff99ccff法力值+"
        set SGSS_TypeStr[2100]="|cff636363"
        set SGSS_TypeStr[2101]="|cffffffff"
        set SGSS_TypeStr[2102]="|cff80ff00"
        set SGSS_TypeStr[2103]="|cff0080ff"
        set SGSS_TypeStr[2104]="|cff8080ff"
        set SGSS_TypeStr[2105]="|cffffff00"
        set SGSS_TypeStr[2106]="|cffff0000"
        set SGSS_TypeStr[2107]="|cffffa600"
        set SGSS_TypeStr[2200]="[普通]"
        set SGSS_TypeStr[2201]="[普通]"
        set SGSS_TypeStr[2202]="|cff52E252[优良]|r"
        set SGSS_TypeStr[2203]="|cff0080ff[罕见]|r"
        set SGSS_TypeStr[2204]="|cff8080ff[稀有]|r"
        set SGSS_TypeStr[2205]="|cffffff00[传说]|r"
        set SGSS_TypeStr[2206]="|cffff0000[神话]|r"
        set SGSS_TypeStr[2207]="|cFF3E3151[混沌]|r"
        set i=1
        loop
        exitwhen ( i >= 8 )
            set SGSS_TypeStrHash[i]=StringHash(SGSS_TypeStr[i])
            set SGSS_TypeStr[100 + i]=( SGSS_TypeStr[i] + "英雄等级加成" )
            set SGSS_TypeStrHash[100 + i]=StringHash(SGSS_TypeStr[100 + i])
            set SGSS_TypeStr[200 + i]=( SGSS_TypeStr[i] + "英雄等级加成值" )
            set SGSS_TypeStrHash[200 + i]=StringHash(SGSS_TypeStr[200 + i])
            set SGSS_TypeStrHash[i]=StringHash(SGSS_TypeStr[i])
            set SGSS_TypeStr[300 + i]=( SGSS_TypeStr[i] + "英雄装备属性加成" )
            set SGSS_TypeStrHash[300 + i]=StringHash(SGSS_TypeStr[300 + i])
            set SGSS_TypeStr[400 + i]=( SGSS_TypeStr[i] + "英雄装备属性加成值" )
            set SGSS_TypeStrHash[400 + i]=StringHash(SGSS_TypeStr[400 + i])
        set i=i + 1
        endloop
        set SGSS_TypeStr[4000]="Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl"
        set SGSS_TypeStr[4001]="Objects\\InventoryItems\\TreasureChest\\treasurechest.mdl"
        set SGSS_TypeStr[4002]="war3mapImported\\baoxiang5.mdl"
        set SGSS_TypeStr[4003]="war3mapImported\\baoxiang3.mdl"
        set SGSS_TypeStr[4004]="war3mapImported\\baoxiang4.mdl"
        set SGSS_TypeStr[4005]="war3mapImported\\baoxiang1.mdl"
        set SGSS_TypeStr[4006]="war3mapImported\\baoxiang2.mdl"
        set SGSS_TypeStr[4007]="war3mapImported\\baoxiang6.mdl"
    return true
endfunction
function sa___prototype6_StarBlockInit takes nothing returns boolean

local timer t= CreateTimer()
call TimerStart(t, 1, false, function StarBlockInitTimerEvent)
set t=null
    return true
endfunction

function jasshelper__initstructs31828796 takes nothing returns nothing
    set st__StarOverSpeed__StarOverSpeedGenerator_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__StarOverSpeed__StarOverSpeedGenerator_onDestroy,Condition( function sa__StarOverSpeed__StarOverSpeedGenerator_onDestroy))
    set st__StarOverSpeed__StarOverSpeedGenerator_Start=CreateTrigger()
    call TriggerAddCondition(st__StarOverSpeed__StarOverSpeedGenerator_Start,Condition( function sa__StarOverSpeed__StarOverSpeedGenerator_Start))
    set st__StarOverSpeed__StarOverSpeedGenerator_Stop=CreateTrigger()
    call TriggerAddCondition(st__StarOverSpeed__StarOverSpeedGenerator_Stop,Condition( function sa__StarOverSpeed__StarOverSpeedGenerator_Stop))
    set st__SEffect_onDestroy=CreateTrigger()
    call TriggerAddCondition(st__SEffect_onDestroy,Condition( function sa__SEffect_onDestroy))
    set st__SEffect_SetRotateZ=CreateTrigger()
    call TriggerAddCondition(st__SEffect_SetRotateZ,Condition( function sa__SEffect_SetRotateZ))
    set st__Vector3_Scale=CreateTrigger()
    call TriggerAddCondition(st__Vector3_Scale,Condition( function sa__Vector3_Scale))
    set st__Vector3_CrossProduct=CreateTrigger()
    call TriggerAddCondition(st__Vector3_CrossProduct,Condition( function sa__Vector3_CrossProduct))
    set st__Vector2_Scale=CreateTrigger()
    call TriggerAddCondition(st__Vector2_Scale,Condition( function sa__Vector2_Scale))
    set st__Argb_ToString=CreateTrigger()
    call TriggerAddCondition(st__Argb_ToString,Condition( function sa__Argb_ToString))
    set st__Convert_S2Id=CreateTrigger()
    call TriggerAddCondition(st__Convert_S2Id,Condition( function sa__Convert_S2Id))
    set st__Convert_Id2S=CreateTrigger()
    call TriggerAddCondition(st__Convert_Id2S,Condition( function sa__Convert_Id2S))
    set st__Convert_R2I=CreateTrigger()
    call TriggerAddCondition(st__Convert_R2I,Condition( function sa__Convert_R2I))
    set st__Convert_R2S=CreateTrigger()
    call TriggerAddCondition(st__Convert_R2S,Condition( function sa__Convert_R2S))
    set st__StringUtil_IndexOf=CreateTrigger()
    call TriggerAddCondition(st__StringUtil_IndexOf,Condition( function sa__StringUtil_IndexOf))
    set st__StringUtil_CharAt=CreateTrigger()
    call TriggerAddCondition(st__StringUtil_CharAt,Condition( function sa__StringUtil_CharAt))
    set st__StringUtil_SubString=CreateTrigger()
    call TriggerAddCondition(st__StringUtil_SubString,Condition( function sa__StringUtil_SubString))
    set st__Math_GetRandomReal=CreateTrigger()
    call TriggerAddCondition(st__Math_GetRandomReal,Condition( function sa__Math_GetRandomReal))
    set st__Math_Cos=CreateTrigger()
    call TriggerAddCondition(st__Math_Cos,Condition( function sa__Math_Cos))
    set st__Math_Atan2=CreateTrigger()
    call TriggerAddCondition(st__Math_Atan2,Condition( function sa__Math_Atan2))
    set st__Math_Power=CreateTrigger()
    call TriggerAddCondition(st__Math_Power,Condition( function sa__Math_Power))
    set st__Math_Exp=CreateTrigger()
    call TriggerAddCondition(st__Math_Exp,Condition( function sa__Math_Exp))
    set st__Math_Modulo=CreateTrigger()
    call TriggerAddCondition(st__Math_Modulo,Condition( function sa__Math_Modulo))
    set st__Math_Ln=CreateTrigger()
    call TriggerAddCondition(st__Math_Ln,Condition( function sa__Math_Ln))
    set st___prototype6[1]=CreateTrigger()
    call TriggerAddAction(st___prototype6[1],function sa___prototype6_StarGSS__initVar)
    call TriggerAddCondition(st___prototype6[1],Condition(function sa___prototype6_StarGSS__initVar))
    set st___prototype6[2]=CreateTrigger()
    call TriggerAddAction(st___prototype6[2],function sa___prototype6_StarBlockInit)
    call TriggerAddCondition(st___prototype6[2],Condition(function sa___prototype6_StarBlockInit))


















    call ExecuteFunc("s__StarTable_onInit")
    call ExecuteFunc("s__Vector2_onInit")
    call ExecuteFunc("s__Vector3_onInit")
    call ExecuteFunc("s__Map_onInit")
    call ExecuteFunc("s__StarOverSpeed__StarOverSpeedGenerator_onInit")
endfunction

