local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local _____83B7_53D6YDLOC, _____53D6GSIndex, _____53D6GLIndex, jglobals
function _____83B7_53D6YDLOC()
    local g = _G
    local ____g_YDLOC_0 = g.YDLOC
    if ____g_YDLOC_0 == nil then
        ____g_YDLOC_0 = jglobals.YDLOC
    end
    local ____g_YDLOC_0_1 = ____g_YDLOC_0
    if ____g_YDLOC_0_1 == nil then
        ____g_YDLOC_0_1 = g.YDHASH_HANDLE
    end
    local ____g_YDLOC_0_1_2 = ____g_YDLOC_0_1
    if ____g_YDLOC_0_1_2 == nil then
        ____g_YDLOC_0_1_2 = jglobals.YDHASH_HANDLE
    end
    local ____g_YDLOC_0_1_2_3 = ____g_YDLOC_0_1_2
    if ____g_YDLOC_0_1_2_3 == nil then
        ____g_YDLOC_0_1_2_3 = g.YDHT
    end
    local ____g_YDLOC_0_1_2_3_4 = ____g_YDLOC_0_1_2_3
    if ____g_YDLOC_0_1_2_3_4 == nil then
        ____g_YDLOC_0_1_2_3_4 = jglobals.YDHT
    end
    local ____g_YDLOC_0_1_2_3_4_5 = ____g_YDLOC_0_1_2_3_4
    if ____g_YDLOC_0_1_2_3_4_5 == nil then
        ____g_YDLOC_0_1_2_3_4_5 = g.udg_YDHASH_HANDLE
    end
    local ____g_YDLOC_0_1_2_3_4_5_6 = ____g_YDLOC_0_1_2_3_4_5
    if ____g_YDLOC_0_1_2_3_4_5_6 == nil then
        ____g_YDLOC_0_1_2_3_4_5_6 = jglobals.udg_YDHASH_HANDLE
    end
    local ____g_YDLOC_0_1_2_3_4_5_6_7 = ____g_YDLOC_0_1_2_3_4_5_6
    if ____g_YDLOC_0_1_2_3_4_5_6_7 == nil then
        ____g_YDLOC_0_1_2_3_4_5_6_7 = g.udg_YDHT
    end
    local ____g_YDLOC_0_1_2_3_4_5_6_7_8 = ____g_YDLOC_0_1_2_3_4_5_6_7
    if ____g_YDLOC_0_1_2_3_4_5_6_7_8 == nil then
        ____g_YDLOC_0_1_2_3_4_5_6_7_8 = jglobals.udg_YDHT
    end
    local ____g_YDLOC_0_1_2_3_4_5_6_7_8_9 = ____g_YDLOC_0_1_2_3_4_5_6_7_8
    if ____g_YDLOC_0_1_2_3_4_5_6_7_8_9 == nil then
        ____g_YDLOC_0_1_2_3_4_5_6_7_8_9 = nil
    end
    return ____g_YDLOC_0_1_2_3_4_5_6_7_8_9
end
function _____53D6GSIndex()
    local g = _G
    local ____g_G_SIndex_10 = g.G_SIndex
    if ____g_G_SIndex_10 == nil then
        ____g_G_SIndex_10 = jglobals.G_SIndex
    end
    local value = ____g_G_SIndex_10
    return type(value) == "number" and value or 0
end
function _____53D6GLIndex()
    local g = _G
    local ____g_G_LIndex_11 = g.G_LIndex
    if ____g_G_LIndex_11 == nil then
        ____g_G_LIndex_11 = jglobals.G_LIndex
    end
    local value = ____g_G_LIndex_11
    return type(value) == "number" and value or 0
end
--- 通用函数 - 召唤物快捷模板
-- 
-- 说明：
-- - 配套底层 JASS 源文件：
--   `JASS/jass复制粘贴/召唤物.j`
-- - 本文件不重写 JASS 召唤逻辑，而是按旧模板要求写入 YDLocal 参数后触发 STES 事件 `OnSummonEvent`
-- - 适合技能侧快速创建/配置召唤物，并继续复用 JASS 端现有字段语义
local jass = require("jass.common")
jglobals = require("jass.globals")
local STES_Fire_Global = _G.STES_Fire
local function _____5B57_7B26_4E32_54C8_5E0C(name)
    return jass.StringHash(name) or 0
end
local function _____5199_5C40_90E8(____type, name, value)
    local ydloc = _____83B7_53D6YDLOC()
    if not ydloc then
        return
    end
    local page = _____53D6GSIndex()
    local key = _____5B57_7B26_4E32_54C8_5E0C(name)
    repeat
        local ____switch5 = ____type
        local ____cond5 = ____switch5 == "unit"
        if ____cond5 then
            jass.SaveUnitHandle(ydloc, page, key, value)
            return
        end
        ____cond5 = ____cond5 or ____switch5 == "integer"
        if ____cond5 then
            jass.SaveInteger(ydloc, page, key, value)
            return
        end
        ____cond5 = ____cond5 or ____switch5 == "real"
        if ____cond5 then
            jass.SaveReal(ydloc, page, key, value)
            return
        end
        ____cond5 = ____cond5 or ____switch5 == "string"
        if ____cond5 then
            jass.SaveStr(ydloc, page, key, value)
            return
        end
    until true
end
local function _____8BFB_5C40_90E8(____type, name)
    local ydloc = _____83B7_53D6YDLOC()
    if not ydloc then
        return nil
    end
    local page = _____53D6GLIndex()
    local key = _____5B57_7B26_4E32_54C8_5E0C(name)
    repeat
        local ____switch8 = ____type
        local ____cond8 = ____switch8 == "unit"
        if ____cond8 then
            return jass.LoadUnitHandle(ydloc, page, key)
        end
        ____cond8 = ____cond8 or ____switch8 == "integer"
        if ____cond8 then
            return jass.LoadInteger(ydloc, page, key)
        end
        ____cond8 = ____cond8 or ____switch8 == "real"
        if ____cond8 then
            return jass.LoadReal(ydloc, page, key)
        end
        ____cond8 = ____cond8 or ____switch8 == "string"
        if ____cond8 then
            return jass.LoadStr(ydloc, page, key)
        end
    until true
end
local function _____8BBEGSIndex(v)
    _G.G_SIndex = v
    jglobals.G_SIndex = v
end
local function _____8BBEGLIndex(v)
    _G.G_LIndex = v
    jglobals.G_LIndex = v
end
local function _____89E6_53D1STES_4E8B_4EF6(name)
    if type(STES_Fire_Global) ~= "function" then
        return
    end
    STES_Fire_Global(nil, name)
end
local function _____56DB_4F4D_7801(raw)
    return (string.byte(raw, 1) or 0 / 0) * 16777216 + (string.byte(raw, 2) or 0 / 0) * 65536 + (string.byte(raw, 3) or 0 / 0) * 256 + (string.byte(raw, 4) or 0 / 0)
end
local SUMMON_STES_EVENT = "OnSummonEvent"
local LOCAL_PAGE_BASE = 1392508928
local nextLocalPageSeed = 0
local function _____5F52_4E00_5316_5355_4F4D_7C7B_578B(unitType)
    if type(unitType) == "number" then
        return unitType
    end
    if type(unitType) == "string" and #unitType == 4 then
        return _____56DB_4F4D_7801(unitType)
    end
    return 0
end
local function _____5206_914D_4E34_65F6_7236_9875()
    nextLocalPageSeed = nextLocalPageSeed + 1
    if nextLocalPageSeed >= 16777215 then
        nextLocalPageSeed = 1
    end
    return LOCAL_PAGE_BASE + nextLocalPageSeed
end
local function _____5199_5165_53EC_5524_53C2_6570(_____53C2_6570)
    _____5199_5C40_90E8("unit", "Master", _____53C2_6570["主人单位"])
    if _____53C2_6570["召唤物单位"] ~= nil and _____53C2_6570["召唤物单位"] ~= 0 then
        _____5199_5C40_90E8("unit", "Summon", _____53C2_6570["召唤物单位"])
    end
    local _____5355_4F4D_7C7B_578B = _____5F52_4E00_5316_5355_4F4D_7C7B_578B(_____53C2_6570["单位类型"])
    if _____5355_4F4D_7C7B_578B ~= 0 then
        _____5199_5C40_90E8("integer", "unitType", _____5355_4F4D_7C7B_578B)
    end
    _____5199_5C40_90E8("real", "x", _____53C2_6570.X)
    _____5199_5C40_90E8("real", "y", _____53C2_6570.Y)
    _____5199_5C40_90E8("real", "facing", _____53C2_6570["朝向"] or 0)
    _____5199_5C40_90E8("real", "time", _____53C2_6570["持续时间"] or 0)
    _____5199_5C40_90E8("string", "ModelFileID", _____53C2_6570["模型文件"] or "")
    if _____53C2_6570["飞行高度"] ~= nil then
        _____5199_5C40_90E8("real", "moveHeight", _____53C2_6570["飞行高度"])
    end
    if _____53C2_6570["生命值"] ~= nil then
        _____5199_5C40_90E8("real", "HP", _____53C2_6570["生命值"])
    end
    if _____53C2_6570["生命回复"] ~= nil then
        _____5199_5C40_90E8("real", "regenHP", _____53C2_6570["生命回复"])
    end
    if _____53C2_6570["攻击力"] ~= nil then
        _____5199_5C40_90E8("real", "AttackPower", _____53C2_6570["攻击力"])
    end
    if _____53C2_6570["攻击间隔"] ~= nil then
        _____5199_5C40_90E8("real", "MoveHeight", _____53C2_6570["攻击间隔"])
        _____5199_5C40_90E8("real", "atkCd", _____53C2_6570["攻击间隔"])
    end
    if _____53C2_6570["护甲"] ~= nil then
        _____5199_5C40_90E8("real", "def", _____53C2_6570["护甲"])
    end
    if _____53C2_6570["缩放"] ~= nil then
        _____5199_5C40_90E8("real", "size", _____53C2_6570["缩放"])
    end
end
____exports["创建召唤物并套用JASS模板"] = function(_____53C2_6570)
    if _____53C2_6570["主人单位"] == nil or _____53C2_6570["主人单位"] == 0 then
        return nil
    end
    if (_____53C2_6570["召唤物单位"] == nil or _____53C2_6570["召唤物单位"] == 0) and _____5F52_4E00_5316_5355_4F4D_7C7B_578B(_____53C2_6570["单位类型"]) == 0 then
        return nil
    end
    local YDLOC = _____83B7_53D6YDLOC()
    if not YDLOC then
        return nil
    end
    local prevSIndex = _____53D6GSIndex()
    local prevLIndex = _____53D6GLIndex()
    local parentPage = _____5206_914D_4E34_65F6_7236_9875()
    _____8BBEGSIndex(parentPage)
    _____8BBEGLIndex(parentPage)
    _____5199_5165_53EC_5524_53C2_6570(_____53C2_6570)
    _____89E6_53D1STES_4E8B_4EF6(SUMMON_STES_EVENT)
    local _____53EC_5524_7269 = _____8BFB_5C40_90E8("unit", "Summon")
    jass.FlushChildHashtable(YDLOC, parentPage)
    _____8BBEGSIndex(prevSIndex)
    _____8BBEGLIndex(prevLIndex)
    local ____temp_12
    if _____53EC_5524_7269 ~= nil and _____53EC_5524_7269 ~= 0 then
        ____temp_12 = _____53EC_5524_7269
    else
        ____temp_12 = nil
    end
    return ____temp_12
end
____exports["快捷创建召唤物"] = function(_____4E3B_4EBA_5355_4F4D, _____5355_4F4D_7C7B_578B, X, Y, _____6301_7EED_65F6_95F4, _____989D_5916_53C2_6570)
    return ____exports["创建召唤物并套用JASS模板"](__TS__ObjectAssign({
        ["主人单位"] = _____4E3B_4EBA_5355_4F4D,
        ["单位类型"] = _____5355_4F4D_7C7B_578B,
        X = X,
        Y = Y,
        ["持续时间"] = _____6301_7EED_65F6_95F4
    }, _____989D_5916_53C2_6570))
end
return ____exports
