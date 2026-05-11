local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__Delete = ____lualib.__TS__Delete
local __TS__New = ____lualib.__TS__New
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local _____53D6_53E5_67C4ID, _____751F_6210_8DEF_5F84_6BB5_5217_8868, ____on_5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDFTick, ____on_5730_9762_8DEF_5F84_94FA_8BBE_5B9A_65F6_5668_5230_65F6, GetExpiredTimer, GetHandleId, CosBJ, SinBJ, removePeriodicCallback, getServerTime, _____6D3B_8DC3_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8B, _____94FA_8BBE_5B9A_65F6_5668_5B9E_4F8B_6620_5C04, _____5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_56DE_8C03ID
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.index")
local _____521B_5EFA_533A_57DF_6548_679C = ____index["创建区域效果"]
local _____6E05_7406_533A_57DF_6548_679C_5468_671F_4F24_5BB3_53BB_91CD_7EC4 = ____index["清理区域效果周期伤害去重组"]
local _____77E9_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.矩形区域")
local _____83B7_53D6_77E9_5F62_533A_57DF_5355_4F4D = _____77E9_5F62_533A_57DF["获取矩形区域单位"]
function _____53D6_53E5_67C4ID(h)
    if h == nil or h == 0 then
        return 0
    end
    return GetHandleId(h) or 0
end
function _____751F_6210_8DEF_5F84_6BB5_5217_8868(_____53C2_6570)
    local _____7ED3_679C = {}
    local _____8DEF_5F84_957F_5EA6 = _____53C2_6570["路径长度"] > 0 and _____53C2_6570["路径长度"] or 0
    local _____8DEF_5F84_534A_5F84 = _____53C2_6570["路径半径"] > 0 and _____53C2_6570["路径半径"] or 0
    local _____6BB5_95F4_8DDD = _____53C2_6570["段间距"] ~= nil and _____53C2_6570["段间距"] > 0 and _____53C2_6570["段间距"] or (_____8DEF_5F84_534A_5F84 > 0 and _____8DEF_5F84_534A_5F84 or 100)
    if _____8DEF_5F84_957F_5EA6 <= 0 then
        _____7ED3_679C[#_____7ED3_679C + 1] = {X = _____53C2_6570["起点X"], Y = _____53C2_6570["起点Y"]}
        return _____7ED3_679C
    end
    local _____5F53_524D_8DDD_79BB = 0
    while _____5F53_524D_8DDD_79BB <= _____8DEF_5F84_957F_5EA6 do
        _____7ED3_679C[#_____7ED3_679C + 1] = {
            X = _____53C2_6570["起点X"] + CosBJ(_____53C2_6570["方向角"]) * _____5F53_524D_8DDD_79BB,
            Y = _____53C2_6570["起点Y"] + SinBJ(_____53C2_6570["方向角"]) * _____5F53_524D_8DDD_79BB
        }
        _____5F53_524D_8DDD_79BB = _____5F53_524D_8DDD_79BB + _____6BB5_95F4_8DDD
    end
    local _____6700_540E_4E00_6BB5 = _____7ED3_679C[#_____7ED3_679C]
    local _____7EC8_70B9X = _____53C2_6570["起点X"] + CosBJ(_____53C2_6570["方向角"]) * _____8DEF_5F84_957F_5EA6
    local _____7EC8_70B9Y = _____53C2_6570["起点Y"] + SinBJ(_____53C2_6570["方向角"]) * _____8DEF_5F84_957F_5EA6
    if _____6700_540E_4E00_6BB5 == nil or _____6700_540E_4E00_6BB5.X ~= _____7EC8_70B9X or _____6700_540E_4E00_6BB5.Y ~= _____7EC8_70B9Y then
        _____7ED3_679C[#_____7ED3_679C + 1] = {X = _____7EC8_70B9X, Y = _____7EC8_70B9Y}
    end
    return _____7ED3_679C
end
function ____on_5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDFTick()
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    local _____4ECD_6709_6574_4F53_77E9_5F62_5B9E_4F8B = false
    for _____5B9E_4F8BID_6587_672C in pairs(_____6D3B_8DC3_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8B) do
        do
            local _____5B9E_4F8B = _____6D3B_8DC3_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8B[_____5B9E_4F8BID_6587_672C]
            if _____5B9E_4F8B == nil then
                goto __continue45
            end
            if _____5B9E_4F8B["参数"]["伤害模式"] == "整体矩形" then
                _____4ECD_6709_6574_4F53_77E9_5F62_5B9E_4F8B = true
                _____5B9E_4F8B["整体伤害系统Tick"](_____5B9E_4F8B, _____5F53_524D_65F6_95F4_6BEB_79D2)
            end
        end
        ::__continue45::
    end
    if not _____4ECD_6709_6574_4F53_77E9_5F62_5B9E_4F8B and _____5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_56DE_8C03ID)
        _____5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_56DE_8C03ID = 0
    end
end
function ____on_5730_9762_8DEF_5F84_94FA_8BBE_5B9A_65F6_5668_5230_65F6()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local _____5B9A_65F6_5668ID = _____53D6_53E5_67C4ID(timer)
    local _____5B9E_4F8BID = _____94FA_8BBE_5B9A_65F6_5668_5B9E_4F8B_6620_5C04[_____5B9A_65F6_5668ID]
    if _____5B9E_4F8BID == nil or _____5B9E_4F8BID <= 0 then
        return
    end
    local _____5B9E_4F8B = _____6D3B_8DC3_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8B[_____5B9E_4F8BID]
    if _____5B9E_4F8B == nil then
        return
    end
    _____5B9E_4F8B["创建下一段区域"](_____5B9E_4F8B)
end
--- 地面路径持续区域模板
-- 
-- 说明：
-- 1. 沿一条路径按段铺设多个持续区域。
-- 2. 适合地裂、火焰路径、冰霜路径、毒雾路径等技能。
-- 3. 每段复用现有 `区域效果`，统一处理持续伤害与敌友筛选。
local jass = require("jass.common")
local CreateTimer = jass.CreateTimer
GetExpiredTimer = jass.GetExpiredTimer
GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.BJ函数.12．数学函数")
CosBJ = ____require_result_1.CosBJ
SinBJ = ____require_result_1.SinBJ
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
removePeriodicCallback = ____require_result_2.removePeriodicCallback
getServerTime = ____require_result_2.getServerTime
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_3.isUnitEnemy
local isUnitAlly = ____require_result_3.isUnitAlly
local _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0 = __TS__Class()
_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.name = "地面路径持续区域实现"
function _____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.prototype.____constructor(self, _____5B9E_4F8BID, _____53C2_6570)
    self["区域实例列表"] = {}
    self["铺设定时器"] = nil
    self["下一个段索引"] = 0
    self["已销毁"] = false
    self["已全部铺设"] = false
    self["整体伤害结束时间毫秒"] = 0
    self["下次整体伤害时间毫秒"] = 0
    self["整体伤害单位筛选"] = function(____, _____5355_4F4D)
        local _____5F71_54CD_76EE_6807 = self["参数"]["影响目标"] or "敌方"
        local _____6240_6709_8005 = self["参数"]["所有者"]
        if _____5F71_54CD_76EE_6807 == "全部" then
            return true
        end
        if _____6240_6709_8005 == nil or _____6240_6709_8005 == 0 then
            return true
        end
        if _____5F71_54CD_76EE_6807 == "敌方" then
            return isUnitEnemy(_____5355_4F4D, _____6240_6709_8005)
        end
        return isUnitAlly(_____5355_4F4D, _____6240_6709_8005)
    end
    self["实例ID"] = _____5B9E_4F8BID
    self["参数"] = _____53C2_6570
    self["路径段列表"] = _____751F_6210_8DEF_5F84_6BB5_5217_8868(_____53C2_6570)
    local _____5F53_524D_65F6_95F4_6BEB_79D2 = getServerTime()
    self["整体伤害结束时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + _____53C2_6570["区域持续时间"] * 1000
    self["下次整体伤害时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2
end
_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.prototype["启动"] = function(self)
    if #self["路径段列表"] <= 0 then
        self["处理全部铺设完成"](self)
        return
    end
    self["创建下一段区域"](self)
    if self["下一个段索引"] >= #self["路径段列表"] then
        return
    end
    local _____94FA_8BBE_95F4_9694 = self["参数"]["铺设间隔"] ~= nil and self["参数"]["铺设间隔"] > 0 and self["参数"]["铺设间隔"] or 0.06
    self["铺设定时器"] = CreateTimer()
    if self["铺设定时器"] == nil or self["铺设定时器"] == 0 then
        while self["下一个段索引"] < #self["路径段列表"] do
            self["创建下一段区域"](self)
        end
        return
    end
    local _____5B9A_65F6_5668ID = _____53D6_53E5_67C4ID(self["铺设定时器"])
    if _____5B9A_65F6_5668ID > 0 then
        _____94FA_8BBE_5B9A_65F6_5668_5B9E_4F8B_6620_5C04[_____5B9A_65F6_5668ID] = self["实例ID"]
    end
    safeTimerStart(self["铺设定时器"], _____94FA_8BBE_95F4_9694, true, ____on_5730_9762_8DEF_5F84_94FA_8BBE_5B9A_65F6_5668_5230_65F6)
end
_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.prototype["创建下一段区域"] = function(self)
    if self["已销毁"] then
        return
    end
    local _____6BB5_7D22_5F15 = self["下一个段索引"]
    local _____8DEF_5F84_6BB5 = self["路径段列表"][_____6BB5_7D22_5F15 + 1]
    if _____8DEF_5F84_6BB5 == nil then
        self["停止铺设定时器"](self)
        self["处理全部铺设完成"](self)
        return
    end
    local _____533A_57DF_5B9E_4F8B = _____521B_5EFA_533A_57DF_6548_679C({
        X = _____8DEF_5F84_6BB5.X,
        Y = _____8DEF_5F84_6BB5.Y,
        ["半径"] = self["参数"]["路径半径"],
        ["持续时间"] = self["参数"]["区域持续时间"],
        ["检测间隔"] = self["参数"]["检测间隔"],
        ["影响目标"] = self["参数"]["影响目标"] or "敌方",
        ["所有者"] = self["参数"]["所有者"],
        ["模型路径"] = self["参数"]["模型路径"],
        ["特效高度"] = self["参数"]["特效高度"],
        ["显示提示圈"] = self["参数"]["显示提示圈"],
        ["周期伤害"] = self["参数"]["伤害模式"] == "整体矩形" and 0 or self["参数"]["周期伤害"],
        ["周期伤害去重组"] = self["实例ID"],
        ["周期伤害去重间隔"] = self["参数"]["检测间隔"]
    })
    local ____self__533A_57DF_5B9E_4F8B_5217_8868_4 = self["区域实例列表"]
    ____self__533A_57DF_5B9E_4F8B_5217_8868_4[#____self__533A_57DF_5B9E_4F8B_5217_8868_4 + 1] = _____533A_57DF_5B9E_4F8B
    self["下一个段索引"] = self["下一个段索引"] + 1
    local ____opt_5 = self["参数"]["on单段创建"]
    if ____opt_5 ~= nil then
        ____opt_5(_____6BB5_7D22_5F15 + 1, _____8DEF_5F84_6BB5.X, _____8DEF_5F84_6BB5.Y)
    end
    if self["下一个段索引"] >= #self["路径段列表"] then
        self["停止铺设定时器"](self)
        self["处理全部铺设完成"](self)
    end
end
_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.prototype["销毁"] = function(self)
    if self["已销毁"] then
        return
    end
    self["已销毁"] = true
    self["停止铺设定时器"](self)
    for ____, _____533A_57DF_5B9E_4F8B in ipairs(self["区域实例列表"]) do
        _____533A_57DF_5B9E_4F8B["销毁"](_____533A_57DF_5B9E_4F8B)
    end
    _____6E05_7406_533A_57DF_6548_679C_5468_671F_4F24_5BB3_53BB_91CD_7EC4(self["实例ID"])
    __TS__Delete(_____6D3B_8DC3_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8B, self["实例ID"])
    local ____opt_7 = self["参数"]["on销毁"]
    if ____opt_7 ~= nil then
        ____opt_7(self["实例ID"])
    end
end
_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.prototype["整体伤害系统Tick"] = function(self, _____5F53_524D_65F6_95F4_6BEB_79D2)
    if self["已销毁"] then
        return
    end
    if self["参数"]["伤害模式"] ~= "整体矩形" then
        return
    end
    if (self["参数"]["周期伤害"] or 0) <= 0 then
        return
    end
    if _____5F53_524D_65F6_95F4_6BEB_79D2 >= self["整体伤害结束时间毫秒"] then
        return
    end
    if _____5F53_524D_65F6_95F4_6BEB_79D2 < self["下次整体伤害时间毫秒"] then
        return
    end
    local _____68C0_6D4B_95F4_9694_79D2 = self["参数"]["检测间隔"] ~= nil and self["参数"]["检测间隔"] > 0 and self["参数"]["检测间隔"] or 0.02
    self["下次整体伤害时间毫秒"] = _____5F53_524D_65F6_95F4_6BEB_79D2 + _____68C0_6D4B_95F4_9694_79D2 * 1000
    local _____6574_4F53_4F24_5BB3_957F_5EA6 = self["参数"]["整体伤害长度"] ~= nil and self["参数"]["整体伤害长度"] > 0 and self["参数"]["整体伤害长度"] or self["参数"]["路径长度"]
    local _____6574_4F53_4F24_5BB3_534A_5F84 = self["参数"]["整体伤害半径"] ~= nil and self["参数"]["整体伤害半径"] > 0 and self["参数"]["整体伤害半径"] or self["参数"]["路径半径"]
    if _____6574_4F53_4F24_5BB3_957F_5EA6 <= 0 or _____6574_4F53_4F24_5BB3_534A_5F84 <= 0 then
        return
    end
    local _____4E2D_5FC3X = self["参数"]["起点X"] + CosBJ(self["参数"]["方向角"]) * (_____6574_4F53_4F24_5BB3_957F_5EA6 * 0.5)
    local _____4E2D_5FC3Y = self["参数"]["起点Y"] + SinBJ(self["参数"]["方向角"]) * (_____6574_4F53_4F24_5BB3_957F_5EA6 * 0.5)
    local _____5355_4F4D_5217_8868 = _____83B7_53D6_77E9_5F62_533A_57DF_5355_4F4D({
        X = _____4E2D_5FC3X,
        Y = _____4E2D_5FC3Y,
        ["长度"] = _____6574_4F53_4F24_5BB3_957F_5EA6,
        ["宽度"] = _____6574_4F53_4F24_5BB3_534A_5F84 * 2,
        ["方向角"] = self["参数"]["方向角"]
    })
    for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
        do
            if not self["整体伤害单位筛选"](self, _____5355_4F4D) then
                goto __continue28
            end
            local ____self__53C2_6570__6240_6709_8005_9 = self["参数"]["所有者"]
            if ____self__53C2_6570__6240_6709_8005_9 == nil then
                ____self__53C2_6570__6240_6709_8005_9 = _____5355_4F4D
            end
            UnitDamageTarget(
                ____self__53C2_6570__6240_6709_8005_9,
                _____5355_4F4D,
                self["参数"]["周期伤害"] or 0,
                false,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_NORMAL,
                WEAPON_TYPE_WHOKNOWS
            )
        end
        ::__continue28::
    end
end
_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.prototype["停止铺设定时器"] = function(self)
    if self["铺设定时器"] == nil or self["铺设定时器"] == 0 then
        return
    end
    local _____5B9A_65F6_5668ID = _____53D6_53E5_67C4ID(self["铺设定时器"])
    if _____5B9A_65F6_5668ID > 0 then
        __TS__Delete(_____94FA_8BBE_5B9A_65F6_5668_5B9E_4F8B_6620_5C04, _____5B9A_65F6_5668ID)
    end
    safeDestroyTimer(self["铺设定时器"])
    self["铺设定时器"] = nil
end
_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0.prototype["处理全部铺设完成"] = function(self)
    if self["已全部铺设"] then
        return
    end
    self["已全部铺设"] = true
    local ____opt_10 = self["参数"]["on全部铺设完成"]
    if ____opt_10 ~= nil then
        ____opt_10(self["实例ID"])
    end
end
local _____9ED8_8BA4_706B_7130_8DEF_5F84_7279_6548 = "Abilities\\Spells\\Other\\ImmolationRed\\ImmolationRedDamage.mdl"
_____6D3B_8DC3_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8B = {}
_____94FA_8BBE_5B9A_65F6_5668_5B9E_4F8B_6620_5C04 = {}
local _____4E0B_4E00_4E2A_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8BID = 0
_____5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_56DE_8C03ID = 0
local function _____786E_4FDD_5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_5DF2_542F_52A8()
    if _____5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_56DE_8C03ID ~= 0 then
        return
    end
    _____5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_56DE_8C03ID = addPeriodicCallback(20, ____on_5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDFTick)
end
____exports["创建地面路径持续区域"] = function(_____53C2_6570)
    _____4E0B_4E00_4E2A_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8BID = _____4E0B_4E00_4E2A_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8BID + 1
    local _____5B9E_4F8BID = _____4E0B_4E00_4E2A_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8BID
    local _____5B9E_4F8B = __TS__New(_____5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_73B0, _____5B9E_4F8BID, _____53C2_6570)
    _____6D3B_8DC3_5730_9762_8DEF_5F84_6301_7EED_533A_57DF_5B9E_4F8B[_____5B9E_4F8BID] = _____5B9E_4F8B
    if _____53C2_6570["伤害模式"] == "整体矩形" then
        _____786E_4FDD_5730_9762_8DEF_5F84_6574_4F53_4F24_5BB3_7CFB_7EDF_5DF2_542F_52A8()
    end
    _____5B9E_4F8B["启动"](_____5B9E_4F8B)
    return _____5B9E_4F8B
end
____exports["创建火焰路径持续区域"] = function(_____53C2_6570)
    return ____exports["创建地面路径持续区域"](__TS__ObjectAssign({}, _____53C2_6570, {["模型路径"] = _____53C2_6570["模型路径"] or _____9ED8_8BA4_706B_7130_8DEF_5F84_7279_6548}))
end
return ____exports
