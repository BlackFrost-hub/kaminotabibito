local ____lualib = require("lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
--- YDUserData 兼容层（精简版）
-- - 目标：稳定读取/写入 YDHash（优先 Hashtable）
-- - 保留当前测试/业务实际用到的接口，删除调试堆积代码
-- 
-- 类型速查（对齐 SaveLoadSystem/Any2I.h）：
-- - 基础：integer / real / boolean / string
-- - 句柄：timer / trigger / unit / item / group / player / location / destructable
--        force / rect / region / sound / effect / unitpool / itempool / quest / questitem
--        timerdialog / leaderboard / multiboard / multiboarditem / trackable / dialog / button
--        texttag / lightning / image / fogstate / fogmodifier
-- - 编码/整数扩展：unitcode / abilcode / itemcode / frame / hashtable / effectGroup
--        lightningGroup / StarStrPool / starCircle / Srrounder / StarIntPool / terraintype / doodad
-- - 其它：radian / degree / imagefile / modelfile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local japi = nil
do
    local function ____catch(_e)
        japi = nil
    end
    local ____try, ____hasReturned = pcall(function()
        japi = require("jass.japi")
    end)
    if not ____try then
        ____catch(____hasReturned)
    end
end
local function sym(self, name)
    local ____G_name_1 = _G[name]
    if ____G_name_1 == nil then
        local ____jglobals_0
        if jglobals then
            ____jglobals_0 = jglobals[name]
        else
            ____jglobals_0 = nil
        end
        ____G_name_1 = ____jglobals_0
    end
    local ____G_name_1_3 = ____G_name_1
    if ____G_name_1_3 == nil then
        local ____jass_2
        if jass then
            ____jass_2 = jass[name]
        else
            ____jass_2 = nil
        end
        ____G_name_1_3 = ____jass_2
    end
    local ____G_name_1_3_5 = ____G_name_1_3
    if ____G_name_1_3_5 == nil then
        local ____japi_4
        if japi then
            ____japi_4 = japi[name]
        else
            ____japi_4 = nil
        end
        ____G_name_1_3_5 = ____japi_4
    end
    return ____G_name_1_3_5
end
local function hashHandle(self)
    local ____sym_result_6 = sym(nil, "YDHASH_HANDLE")
    if ____sym_result_6 == nil then
        ____sym_result_6 = sym(nil, "YDHT")
    end
    local ____sym_result_6_7 = ____sym_result_6
    if ____sym_result_6_7 == nil then
        ____sym_result_6_7 = sym(nil, "udg_YDHASH_HANDLE")
    end
    local ____sym_result_6_7_8 = ____sym_result_6_7
    if ____sym_result_6_7_8 == nil then
        ____sym_result_6_7_8 = sym(nil, "udg_YDHT")
    end
    local h = ____sym_result_6_7_8
    if h == nil then
        error(
            __TS__New(Error, "[YDUserData兼容] 缺少哈希句柄: YDHASH_HANDLE/YDHT"),
            0
        )
    end
    return h
end
local function sh(self, s)
    return jass.StringHash(s) or 0
end
local function tableId(self, tableType, tableKey)
    if tableType == "string" then
        return sh(
            nil,
            tostring(tableKey)
        )
    end
    if tableType == "integer" or tableType == "real" or tableType == "unitcode" or tableType == "itemcode" or tableType == "abilcode" or tableType == "frame" or tableType == "hashtable" or tableType == "effectGroup" or tableType == "lightningGroup" or tableType == "StarStrPool" or tableType == "starCircle" or tableType == "Srrounder" or tableType == "StarIntPool" or tableType == "terraintype" or tableType == "doodad" then
        return __TS__Number(tableKey) or 0
    end
    if tableType == "boolean" then
        return tableKey and 1 or 0
    end
    if tableType == "radian" or tableType == "degree" then
        return __TS__Number(tableKey) or 0
    end
    if tableType == "imagefile" or tableType == "modelfile" then
        return sh(
            nil,
            tostring(tableKey)
        )
    end
    return jass.GetHandleId(tableKey) or 0
end
local function loadByHash(self, ____type, p, c)
    local h = hashHandle(nil)
    repeat
        local ____switch15 = ____type
        local ____cond15 = ____switch15 == "integer"
        if ____cond15 then
            return jass.LoadInteger(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "real"
        if ____cond15 then
            return jass.LoadReal(h, p, c)
        end
        ____cond15 = ____cond15 or (____switch15 == "radian" or ____switch15 == "degree")
        if ____cond15 then
            return jass.LoadReal(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "boolean"
        if ____cond15 then
            return jass.LoadBoolean(h, p, c)
        end
        ____cond15 = ____cond15 or (____switch15 == "string" or ____switch15 == "imagefile" or ____switch15 == "modelfile")
        if ____cond15 then
            return jass.LoadStr(h, p, c)
        end
        ____cond15 = ____cond15 or (____switch15 == "unitcode" or ____switch15 == "itemcode" or ____switch15 == "abilcode" or ____switch15 == "frame" or ____switch15 == "hashtable" or ____switch15 == "effectGroup" or ____switch15 == "lightningGroup" or ____switch15 == "StarStrPool" or ____switch15 == "starCircle" or ____switch15 == "Srrounder" or ____switch15 == "StarIntPool" or ____switch15 == "terraintype" or ____switch15 == "doodad")
        if ____cond15 then
            return jass.LoadInteger(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "unit"
        if ____cond15 then
            return jass.LoadUnitHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "group"
        if ____cond15 then
            return jass.LoadGroupHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "timer"
        if ____cond15 then
            return jass.LoadTimerHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "trigger"
        if ____cond15 then
            return jass.LoadTriggerHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "item"
        if ____cond15 then
            return jass.LoadItemHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "player"
        if ____cond15 then
            return jass.LoadPlayerHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "location"
        if ____cond15 then
            return jass.LoadLocationHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "destructable"
        if ____cond15 then
            return jass.LoadDestructableHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "force"
        if ____cond15 then
            return jass.LoadForceHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "rect"
        if ____cond15 then
            return jass.LoadRectHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "region"
        if ____cond15 then
            return jass.LoadRegionHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "sound"
        if ____cond15 then
            return jass.LoadSoundHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "effect"
        if ____cond15 then
            return jass.LoadEffectHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "unitpool"
        if ____cond15 then
            return jass.LoadUnitPoolHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "itempool"
        if ____cond15 then
            return jass.LoadItemPoolHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "quest"
        if ____cond15 then
            return jass.LoadQuestHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "questitem"
        if ____cond15 then
            return jass.LoadQuestItemHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "timerdialog"
        if ____cond15 then
            return jass.LoadTimerDialogHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "leaderboard"
        if ____cond15 then
            return jass.LoadLeaderboardHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "multiboard"
        if ____cond15 then
            return jass.LoadMultiboardHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "multiboarditem"
        if ____cond15 then
            return jass.LoadMultiboardItemHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "trackable"
        if ____cond15 then
            return jass.LoadTrackableHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "dialog"
        if ____cond15 then
            return jass.LoadDialogHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "button"
        if ____cond15 then
            return jass.LoadButtonHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "texttag"
        if ____cond15 then
            return jass.LoadTextTagHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "lightning"
        if ____cond15 then
            return jass.LoadLightningHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "image"
        if ____cond15 then
            return jass.LoadImageHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "fogstate"
        if ____cond15 then
            return jass.LoadFogStateHandle(h, p, c)
        end
        ____cond15 = ____cond15 or ____switch15 == "fogmodifier"
        if ____cond15 then
            return jass.LoadFogModifierHandle(h, p, c)
        end
        do
            return nil
        end
    until true
end
local function saveByHash(self, ____type, p, c, value)
    local h = hashHandle(nil)
    repeat
        local ____switch17 = ____type
        local ____cond17 = ____switch17 == "integer"
        if ____cond17 then
            jass.SaveInteger(
                h,
                p,
                c,
                __TS__Number(value) or 0
            )
            return
        end
        ____cond17 = ____cond17 or (____switch17 == "real" or ____switch17 == "radian" or ____switch17 == "degree")
        if ____cond17 then
            jass.SaveReal(
                h,
                p,
                c,
                __TS__Number(value) or 0
            )
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "boolean"
        if ____cond17 then
            jass.SaveBoolean(h, p, c, not not value)
            return
        end
        ____cond17 = ____cond17 or (____switch17 == "string" or ____switch17 == "imagefile" or ____switch17 == "modelfile")
        if ____cond17 then
            jass.SaveStr(
                h,
                p,
                c,
                tostring(value)
            )
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "unit"
        if ____cond17 then
            jass.SaveUnitHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "group"
        if ____cond17 then
            jass.SaveGroupHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "timer"
        if ____cond17 then
            jass.SaveTimerHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "trigger"
        if ____cond17 then
            jass.SaveTriggerHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "item"
        if ____cond17 then
            jass.SaveItemHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "player"
        if ____cond17 then
            jass.SavePlayerHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "location"
        if ____cond17 then
            jass.SaveLocationHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "destructable"
        if ____cond17 then
            jass.SaveDestructableHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "force"
        if ____cond17 then
            jass.SaveForceHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "rect"
        if ____cond17 then
            jass.SaveRectHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "region"
        if ____cond17 then
            jass.SaveRegionHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "sound"
        if ____cond17 then
            jass.SaveSoundHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "effect"
        if ____cond17 then
            jass.SaveEffectHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "unitpool"
        if ____cond17 then
            jass.SaveUnitPoolHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "itempool"
        if ____cond17 then
            jass.SaveItemPoolHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "quest"
        if ____cond17 then
            jass.SaveQuestHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "questitem"
        if ____cond17 then
            jass.SaveQuestItemHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "timerdialog"
        if ____cond17 then
            jass.SaveTimerDialogHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "leaderboard"
        if ____cond17 then
            jass.SaveLeaderboardHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "multiboard"
        if ____cond17 then
            jass.SaveMultiboardHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "multiboarditem"
        if ____cond17 then
            jass.SaveMultiboardItemHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "trackable"
        if ____cond17 then
            jass.SaveTrackableHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "dialog"
        if ____cond17 then
            jass.SaveDialogHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "button"
        if ____cond17 then
            jass.SaveButtonHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "texttag"
        if ____cond17 then
            jass.SaveTextTagHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "lightning"
        if ____cond17 then
            jass.SaveLightningHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "image"
        if ____cond17 then
            jass.SaveImageHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "fogstate"
        if ____cond17 then
            jass.SaveFogStateHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or ____switch17 == "fogmodifier"
        if ____cond17 then
            jass.SaveFogModifierHandle(h, p, c, value)
            return
        end
        ____cond17 = ____cond17 or (____switch17 == "unitcode" or ____switch17 == "itemcode" or ____switch17 == "abilcode" or ____switch17 == "frame" or ____switch17 == "hashtable" or ____switch17 == "effectGroup" or ____switch17 == "lightningGroup" or ____switch17 == "StarStrPool" or ____switch17 == "starCircle" or ____switch17 == "Srrounder" or ____switch17 == "StarIntPool" or ____switch17 == "terraintype" or ____switch17 == "doodad")
        if ____cond17 then
            jass.SaveInteger(
                h,
                p,
                c,
                __TS__Number(value) or 0
            )
            return
        end
    until true
end
function ____exports.ydUserDataGetByTypeName(self, tableTypeName, tableKey, attr, valueTypeName)
    local p = tableId(nil, tableTypeName, tableKey)
    local c = sh(nil, attr)
    return loadByHash(nil, valueTypeName, p, c)
end
function ____exports.ydUserDataSetByTypeName(self, tableTypeName, tableKey, attr, valueTypeName, value)
    local p = tableId(nil, tableTypeName, tableKey)
    local c = sh(nil, attr)
    saveByHash(
        nil,
        valueTypeName,
        p,
        c,
        value
    )
end
function ____exports.YDUserDataGet(self, tableTypeName, tableKey, attr, valueTypeName)
    return ____exports.ydUserDataGetByTypeName(
        nil,
        tableTypeName,
        tableKey,
        attr,
        valueTypeName
    )
end
function ____exports.YDUserDataSet(self, tableTypeName, tableKey, attr, valueTypeName, value)
    ____exports.ydUserDataSetByTypeName(
        nil,
        tableTypeName,
        tableKey,
        attr,
        valueTypeName,
        value
    )
end
function ____exports.YDUserDataGet2(self, tableTypeName, tableKey, attr, valueTypeName)
    return ____exports.ydUserDataGetByTypeName(
        nil,
        tableTypeName,
        tableKey,
        attr,
        valueTypeName
    )
end
function ____exports.YDUserDataSet2(self, tableTypeName, tableKey, attr, valueTypeName, value)
    ____exports.ydUserDataSetByTypeName(
        nil,
        tableTypeName,
        tableKey,
        attr,
        valueTypeName,
        value
    )
end
--- YDUserDataClearTable - 清除指定表的所有数据
-- 对应宏: YDHashClearTable(YDHASH_HANDLE, YDHashAny2I(table_type, table))
function ____exports.YDUserDataClearTable(self, tableTypeName, tableKey)
    local h = hashHandle(nil)
    local p = tableId(nil, tableTypeName, tableKey)
    jass.FlushChildHashtable(h, p)
end
--- YDUserDataClear - 清除指定属性
-- 对应宏: YDHashClear（按值类型选用 RemoveSaved*）
function ____exports.YDUserDataClear(self, tableTypeName, tableKey, attr, valueTypeName)
    local h = hashHandle(nil)
    local p = tableId(nil, tableTypeName, tableKey)
    local c = sh(nil, attr)
    local rmInt = jass.RemoveSavedInteger
    local rmReal = jass.RemoveSavedReal
    local rmBool = jass.RemoveSavedBoolean
    local rmStr = jass.RemoveSavedString
    local rmHandle = jass.RemoveSavedHandle
    repeat
        local ____switch26 = valueTypeName
        local ____cond26 = ____switch26 == "integer" or ____switch26 == "unitcode" or ____switch26 == "itemcode" or ____switch26 == "abilcode" or ____switch26 == "frame" or ____switch26 == "hashtable" or ____switch26 == "effectGroup" or ____switch26 == "lightningGroup" or ____switch26 == "StarStrPool" or ____switch26 == "starCircle" or ____switch26 == "Srrounder" or ____switch26 == "StarIntPool" or ____switch26 == "terraintype" or ____switch26 == "doodad"
        if ____cond26 then
            rmInt(nil, h, p, c)
            return
        end
        ____cond26 = ____cond26 or (____switch26 == "real" or ____switch26 == "radian" or ____switch26 == "degree")
        if ____cond26 then
            rmReal(nil, h, p, c)
            return
        end
        ____cond26 = ____cond26 or ____switch26 == "boolean"
        if ____cond26 then
            rmBool(nil, h, p, c)
            return
        end
        ____cond26 = ____cond26 or (____switch26 == "string" or ____switch26 == "imagefile" or ____switch26 == "modelfile")
        if ____cond26 then
            rmStr(nil, h, p, c)
            return
        end
        do
            rmHandle(nil, h, p, c)
        end
    until true
end
function ____exports.YDUserDataClear2(self, tableTypeName, tableKey, valueTypeName, attr)
    ____exports.YDUserDataClear(
        nil,
        tableTypeName,
        tableKey,
        attr,
        valueTypeName
    )
end
local function hasByHash(self, ____type, p, c)
    local h = hashHandle(nil)
    if jass.HaveSavedInteger(h, p, c) then
        return true
    end
    if jass.HaveSavedReal(h, p, c) then
        return true
    end
    if jass.HaveSavedBoolean(h, p, c) then
        return true
    end
    if jass.HaveSavedString(h, p, c) then
        return true
    end
    if jass.HaveSavedHandle(h, p, c) then
        return true
    end
    return false
end
function ____exports.YDUserDataHas(self, tableTypeName, tableKey, attr, valueTypeName)
    local p = tableId(nil, tableTypeName, tableKey)
    local c = sh(nil, attr)
    return hasByHash(nil, valueTypeName, p, c)
end
function ____exports.YDUserDataHas2(self, tableTypeName, tableKey, valueTypeName, attr)
    local p = tableId(nil, tableTypeName, tableKey)
    local c = sh(nil, attr)
    return hasByHash(nil, valueTypeName, p, c)
end
return ____exports
