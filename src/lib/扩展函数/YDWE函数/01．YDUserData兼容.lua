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
    if type(jass.StringHash) ~= "function" then
        error(
            __TS__New(Error, "[YDUserData兼容] 缺少 StringHash"),
            0
        )
    end
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
    if type(jass.GetHandleId) == "function" then
        return jass.GetHandleId(tableKey) or 0
    end
    return __TS__Number(tableKey) or 0
end
local function loadByHash(self, ____type, p, c)
    local h = hashHandle(nil)
    repeat
        local ____switch17 = ____type
        local ____cond17 = ____switch17 == "integer"
        if ____cond17 then
            local ____temp_9
            if type(jass.LoadInteger) == "function" then
                ____temp_9 = jass.LoadInteger(h, p, c)
            else
                ____temp_9 = 0
            end
            return ____temp_9
        end
        ____cond17 = ____cond17 or ____switch17 == "real"
        if ____cond17 then
            local ____temp_10
            if type(jass.LoadReal) == "function" then
                ____temp_10 = jass.LoadReal(h, p, c)
            else
                ____temp_10 = 0
            end
            return ____temp_10
        end
        ____cond17 = ____cond17 or (____switch17 == "radian" or ____switch17 == "degree")
        if ____cond17 then
            local ____temp_11
            if type(jass.LoadReal) == "function" then
                ____temp_11 = jass.LoadReal(h, p, c)
            else
                ____temp_11 = 0
            end
            return ____temp_11
        end
        ____cond17 = ____cond17 or ____switch17 == "boolean"
        if ____cond17 then
            local ____temp_12
            if type(jass.LoadBoolean) == "function" then
                ____temp_12 = jass.LoadBoolean(h, p, c)
            else
                ____temp_12 = false
            end
            return ____temp_12
        end
        ____cond17 = ____cond17 or (____switch17 == "string" or ____switch17 == "imagefile" or ____switch17 == "modelfile")
        if ____cond17 then
            local ____temp_13
            if type(jass.LoadStr) == "function" then
                ____temp_13 = jass.LoadStr(h, p, c)
            else
                ____temp_13 = ""
            end
            return ____temp_13
        end
        ____cond17 = ____cond17 or (____switch17 == "unitcode" or ____switch17 == "itemcode" or ____switch17 == "abilcode" or ____switch17 == "frame" or ____switch17 == "hashtable" or ____switch17 == "effectGroup" or ____switch17 == "lightningGroup" or ____switch17 == "StarStrPool" or ____switch17 == "starCircle" or ____switch17 == "Srrounder" or ____switch17 == "StarIntPool" or ____switch17 == "terraintype" or ____switch17 == "doodad")
        if ____cond17 then
            local ____temp_14
            if type(jass.LoadInteger) == "function" then
                ____temp_14 = jass.LoadInteger(h, p, c)
            else
                ____temp_14 = 0
            end
            return ____temp_14
        end
        ____cond17 = ____cond17 or ____switch17 == "unit"
        if ____cond17 then
            local ____temp_15
            if type(jass.LoadUnitHandle) == "function" then
                ____temp_15 = jass.LoadUnitHandle(h, p, c)
            else
                ____temp_15 = nil
            end
            return ____temp_15
        end
        ____cond17 = ____cond17 or ____switch17 == "group"
        if ____cond17 then
            local ____temp_16
            if type(jass.LoadGroupHandle) == "function" then
                ____temp_16 = jass.LoadGroupHandle(h, p, c)
            else
                ____temp_16 = nil
            end
            return ____temp_16
        end
        ____cond17 = ____cond17 or ____switch17 == "timer"
        if ____cond17 then
            local ____temp_17
            if type(jass.LoadTimerHandle) == "function" then
                ____temp_17 = jass.LoadTimerHandle(h, p, c)
            else
                ____temp_17 = nil
            end
            return ____temp_17
        end
        ____cond17 = ____cond17 or ____switch17 == "trigger"
        if ____cond17 then
            local ____temp_18
            if type(jass.LoadTriggerHandle) == "function" then
                ____temp_18 = jass.LoadTriggerHandle(h, p, c)
            else
                ____temp_18 = nil
            end
            return ____temp_18
        end
        ____cond17 = ____cond17 or ____switch17 == "item"
        if ____cond17 then
            local ____temp_19
            if type(jass.LoadItemHandle) == "function" then
                ____temp_19 = jass.LoadItemHandle(h, p, c)
            else
                ____temp_19 = nil
            end
            return ____temp_19
        end
        ____cond17 = ____cond17 or ____switch17 == "player"
        if ____cond17 then
            local ____temp_20
            if type(jass.LoadPlayerHandle) == "function" then
                ____temp_20 = jass.LoadPlayerHandle(h, p, c)
            else
                ____temp_20 = nil
            end
            return ____temp_20
        end
        ____cond17 = ____cond17 or ____switch17 == "location"
        if ____cond17 then
            local ____temp_21
            if type(jass.LoadLocationHandle) == "function" then
                ____temp_21 = jass.LoadLocationHandle(h, p, c)
            else
                ____temp_21 = nil
            end
            return ____temp_21
        end
        ____cond17 = ____cond17 or ____switch17 == "destructable"
        if ____cond17 then
            local ____temp_22
            if type(jass.LoadDestructableHandle) == "function" then
                ____temp_22 = jass.LoadDestructableHandle(h, p, c)
            else
                ____temp_22 = nil
            end
            return ____temp_22
        end
        ____cond17 = ____cond17 or ____switch17 == "force"
        if ____cond17 then
            local ____temp_23
            if type(jass.LoadForceHandle) == "function" then
                ____temp_23 = jass.LoadForceHandle(h, p, c)
            else
                ____temp_23 = nil
            end
            return ____temp_23
        end
        ____cond17 = ____cond17 or ____switch17 == "rect"
        if ____cond17 then
            local ____temp_24
            if type(jass.LoadRectHandle) == "function" then
                ____temp_24 = jass.LoadRectHandle(h, p, c)
            else
                ____temp_24 = nil
            end
            return ____temp_24
        end
        ____cond17 = ____cond17 or ____switch17 == "region"
        if ____cond17 then
            local ____temp_25
            if type(jass.LoadRegionHandle) == "function" then
                ____temp_25 = jass.LoadRegionHandle(h, p, c)
            else
                ____temp_25 = nil
            end
            return ____temp_25
        end
        ____cond17 = ____cond17 or ____switch17 == "sound"
        if ____cond17 then
            local ____temp_26
            if type(jass.LoadSoundHandle) == "function" then
                ____temp_26 = jass.LoadSoundHandle(h, p, c)
            else
                ____temp_26 = nil
            end
            return ____temp_26
        end
        ____cond17 = ____cond17 or ____switch17 == "effect"
        if ____cond17 then
            local ____temp_27
            if type(jass.LoadEffectHandle) == "function" then
                ____temp_27 = jass.LoadEffectHandle(h, p, c)
            else
                ____temp_27 = nil
            end
            return ____temp_27
        end
        ____cond17 = ____cond17 or ____switch17 == "unitpool"
        if ____cond17 then
            local ____temp_28
            if type(jass.LoadUnitPoolHandle) == "function" then
                ____temp_28 = jass.LoadUnitPoolHandle(h, p, c)
            else
                ____temp_28 = nil
            end
            return ____temp_28
        end
        ____cond17 = ____cond17 or ____switch17 == "itempool"
        if ____cond17 then
            local ____temp_29
            if type(jass.LoadItemPoolHandle) == "function" then
                ____temp_29 = jass.LoadItemPoolHandle(h, p, c)
            else
                ____temp_29 = nil
            end
            return ____temp_29
        end
        ____cond17 = ____cond17 or ____switch17 == "quest"
        if ____cond17 then
            local ____temp_30
            if type(jass.LoadQuestHandle) == "function" then
                ____temp_30 = jass.LoadQuestHandle(h, p, c)
            else
                ____temp_30 = nil
            end
            return ____temp_30
        end
        ____cond17 = ____cond17 or ____switch17 == "questitem"
        if ____cond17 then
            local ____temp_31
            if type(jass.LoadQuestItemHandle) == "function" then
                ____temp_31 = jass.LoadQuestItemHandle(h, p, c)
            else
                ____temp_31 = nil
            end
            return ____temp_31
        end
        ____cond17 = ____cond17 or ____switch17 == "timerdialog"
        if ____cond17 then
            local ____temp_32
            if type(jass.LoadTimerDialogHandle) == "function" then
                ____temp_32 = jass.LoadTimerDialogHandle(h, p, c)
            else
                ____temp_32 = nil
            end
            return ____temp_32
        end
        ____cond17 = ____cond17 or ____switch17 == "leaderboard"
        if ____cond17 then
            local ____temp_33
            if type(jass.LoadLeaderboardHandle) == "function" then
                ____temp_33 = jass.LoadLeaderboardHandle(h, p, c)
            else
                ____temp_33 = nil
            end
            return ____temp_33
        end
        ____cond17 = ____cond17 or ____switch17 == "multiboard"
        if ____cond17 then
            local ____temp_34
            if type(jass.LoadMultiboardHandle) == "function" then
                ____temp_34 = jass.LoadMultiboardHandle(h, p, c)
            else
                ____temp_34 = nil
            end
            return ____temp_34
        end
        ____cond17 = ____cond17 or ____switch17 == "multiboarditem"
        if ____cond17 then
            local ____temp_35
            if type(jass.LoadMultiboardItemHandle) == "function" then
                ____temp_35 = jass.LoadMultiboardItemHandle(h, p, c)
            else
                ____temp_35 = nil
            end
            return ____temp_35
        end
        ____cond17 = ____cond17 or ____switch17 == "trackable"
        if ____cond17 then
            local ____temp_36
            if type(jass.LoadTrackableHandle) == "function" then
                ____temp_36 = jass.LoadTrackableHandle(h, p, c)
            else
                ____temp_36 = nil
            end
            return ____temp_36
        end
        ____cond17 = ____cond17 or ____switch17 == "dialog"
        if ____cond17 then
            local ____temp_37
            if type(jass.LoadDialogHandle) == "function" then
                ____temp_37 = jass.LoadDialogHandle(h, p, c)
            else
                ____temp_37 = nil
            end
            return ____temp_37
        end
        ____cond17 = ____cond17 or ____switch17 == "button"
        if ____cond17 then
            local ____temp_38
            if type(jass.LoadButtonHandle) == "function" then
                ____temp_38 = jass.LoadButtonHandle(h, p, c)
            else
                ____temp_38 = nil
            end
            return ____temp_38
        end
        ____cond17 = ____cond17 or ____switch17 == "texttag"
        if ____cond17 then
            local ____temp_39
            if type(jass.LoadTextTagHandle) == "function" then
                ____temp_39 = jass.LoadTextTagHandle(h, p, c)
            else
                ____temp_39 = nil
            end
            return ____temp_39
        end
        ____cond17 = ____cond17 or ____switch17 == "lightning"
        if ____cond17 then
            local ____temp_40
            if type(jass.LoadLightningHandle) == "function" then
                ____temp_40 = jass.LoadLightningHandle(h, p, c)
            else
                ____temp_40 = nil
            end
            return ____temp_40
        end
        ____cond17 = ____cond17 or ____switch17 == "image"
        if ____cond17 then
            local ____temp_41
            if type(jass.LoadImageHandle) == "function" then
                ____temp_41 = jass.LoadImageHandle(h, p, c)
            else
                ____temp_41 = nil
            end
            return ____temp_41
        end
        ____cond17 = ____cond17 or ____switch17 == "fogstate"
        if ____cond17 then
            local ____temp_42
            if type(jass.LoadFogStateHandle) == "function" then
                ____temp_42 = jass.LoadFogStateHandle(h, p, c)
            else
                ____temp_42 = nil
            end
            return ____temp_42
        end
        ____cond17 = ____cond17 or ____switch17 == "fogmodifier"
        if ____cond17 then
            local ____temp_43
            if type(jass.LoadFogModifierHandle) == "function" then
                ____temp_43 = jass.LoadFogModifierHandle(h, p, c)
            else
                ____temp_43 = nil
            end
            return ____temp_43
        end
        do
            return nil
        end
    until true
end
local function saveByHash(self, ____type, p, c, value)
    local h = hashHandle(nil)
    repeat
        local ____switch19 = ____type
        local ____cond19 = ____switch19 == "integer"
        if ____cond19 then
            if type(jass.SaveInteger) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveInteger"),
                    0
                )
            end
            jass.SaveInteger(
                h,
                p,
                c,
                __TS__Number(value) or 0
            )
            return
        end
        ____cond19 = ____cond19 or (____switch19 == "real" or ____switch19 == "radian" or ____switch19 == "degree")
        if ____cond19 then
            if type(jass.SaveReal) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveReal"),
                    0
                )
            end
            jass.SaveReal(
                h,
                p,
                c,
                __TS__Number(value) or 0
            )
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "boolean"
        if ____cond19 then
            if type(jass.SaveBoolean) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveBoolean"),
                    0
                )
            end
            jass.SaveBoolean(h, p, c, not not value)
            return
        end
        ____cond19 = ____cond19 or (____switch19 == "string" or ____switch19 == "imagefile" or ____switch19 == "modelfile")
        if ____cond19 then
            if type(jass.SaveStr) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveStr"),
                    0
                )
            end
            jass.SaveStr(
                h,
                p,
                c,
                tostring(value)
            )
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "unit"
        if ____cond19 then
            if type(jass.SaveUnitHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveUnitHandle"),
                    0
                )
            end
            jass.SaveUnitHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "group"
        if ____cond19 then
            if type(jass.SaveGroupHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveGroupHandle"),
                    0
                )
            end
            jass.SaveGroupHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "timer"
        if ____cond19 then
            if type(jass.SaveTimerHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveTimerHandle"),
                    0
                )
            end
            jass.SaveTimerHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "trigger"
        if ____cond19 then
            if type(jass.SaveTriggerHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveTriggerHandle"),
                    0
                )
            end
            jass.SaveTriggerHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "item"
        if ____cond19 then
            if type(jass.SaveItemHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveItemHandle"),
                    0
                )
            end
            jass.SaveItemHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "player"
        if ____cond19 then
            if type(jass.SavePlayerHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SavePlayerHandle"),
                    0
                )
            end
            jass.SavePlayerHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "location"
        if ____cond19 then
            if type(jass.SaveLocationHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveLocationHandle"),
                    0
                )
            end
            jass.SaveLocationHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "destructable"
        if ____cond19 then
            if type(jass.SaveDestructableHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveDestructableHandle"),
                    0
                )
            end
            jass.SaveDestructableHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "force"
        if ____cond19 then
            if type(jass.SaveForceHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveForceHandle"),
                    0
                )
            end
            jass.SaveForceHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "rect"
        if ____cond19 then
            if type(jass.SaveRectHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveRectHandle"),
                    0
                )
            end
            jass.SaveRectHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "region"
        if ____cond19 then
            if type(jass.SaveRegionHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveRegionHandle"),
                    0
                )
            end
            jass.SaveRegionHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "sound"
        if ____cond19 then
            if type(jass.SaveSoundHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveSoundHandle"),
                    0
                )
            end
            jass.SaveSoundHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "effect"
        if ____cond19 then
            if type(jass.SaveEffectHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveEffectHandle"),
                    0
                )
            end
            jass.SaveEffectHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "unitpool"
        if ____cond19 then
            if type(jass.SaveUnitPoolHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveUnitPoolHandle"),
                    0
                )
            end
            jass.SaveUnitPoolHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "itempool"
        if ____cond19 then
            if type(jass.SaveItemPoolHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveItemPoolHandle"),
                    0
                )
            end
            jass.SaveItemPoolHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "quest"
        if ____cond19 then
            if type(jass.SaveQuestHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveQuestHandle"),
                    0
                )
            end
            jass.SaveQuestHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "questitem"
        if ____cond19 then
            if type(jass.SaveQuestItemHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveQuestItemHandle"),
                    0
                )
            end
            jass.SaveQuestItemHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "timerdialog"
        if ____cond19 then
            if type(jass.SaveTimerDialogHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveTimerDialogHandle"),
                    0
                )
            end
            jass.SaveTimerDialogHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "leaderboard"
        if ____cond19 then
            if type(jass.SaveLeaderboardHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveLeaderboardHandle"),
                    0
                )
            end
            jass.SaveLeaderboardHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "multiboard"
        if ____cond19 then
            if type(jass.SaveMultiboardHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveMultiboardHandle"),
                    0
                )
            end
            jass.SaveMultiboardHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "multiboarditem"
        if ____cond19 then
            if type(jass.SaveMultiboardItemHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveMultiboardItemHandle"),
                    0
                )
            end
            jass.SaveMultiboardItemHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "trackable"
        if ____cond19 then
            if type(jass.SaveTrackableHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveTrackableHandle"),
                    0
                )
            end
            jass.SaveTrackableHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "dialog"
        if ____cond19 then
            if type(jass.SaveDialogHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveDialogHandle"),
                    0
                )
            end
            jass.SaveDialogHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "button"
        if ____cond19 then
            if type(jass.SaveButtonHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveButtonHandle"),
                    0
                )
            end
            jass.SaveButtonHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "texttag"
        if ____cond19 then
            if type(jass.SaveTextTagHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveTextTagHandle"),
                    0
                )
            end
            jass.SaveTextTagHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "lightning"
        if ____cond19 then
            if type(jass.SaveLightningHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveLightningHandle"),
                    0
                )
            end
            jass.SaveLightningHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "image"
        if ____cond19 then
            if type(jass.SaveImageHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveImageHandle"),
                    0
                )
            end
            jass.SaveImageHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "fogstate"
        if ____cond19 then
            if type(jass.SaveFogStateHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveFogStateHandle"),
                    0
                )
            end
            jass.SaveFogStateHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or ____switch19 == "fogmodifier"
        if ____cond19 then
            if type(jass.SaveFogModifierHandle) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveFogModifierHandle"),
                    0
                )
            end
            jass.SaveFogModifierHandle(h, p, c, value)
            return
        end
        ____cond19 = ____cond19 or (____switch19 == "unitcode" or ____switch19 == "itemcode" or ____switch19 == "abilcode" or ____switch19 == "frame" or ____switch19 == "hashtable" or ____switch19 == "effectGroup" or ____switch19 == "lightningGroup" or ____switch19 == "StarStrPool" or ____switch19 == "starCircle" or ____switch19 == "Srrounder" or ____switch19 == "StarIntPool" or ____switch19 == "terraintype" or ____switch19 == "doodad")
        if ____cond19 then
            if type(jass.SaveInteger) ~= "function" then
                error(
                    __TS__New(Error, "[YDUserData兼容] 缺少 SaveInteger"),
                    0
                )
            end
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
    if type(jass.FlushChildHashtable) == "function" then
        jass.FlushChildHashtable(h, p)
    end
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
        local ____switch63 = valueTypeName
        local ____cond63 = ____switch63 == "integer" or ____switch63 == "unitcode" or ____switch63 == "itemcode" or ____switch63 == "abilcode" or ____switch63 == "frame" or ____switch63 == "hashtable" or ____switch63 == "effectGroup" or ____switch63 == "lightningGroup" or ____switch63 == "StarStrPool" or ____switch63 == "starCircle" or ____switch63 == "Srrounder" or ____switch63 == "StarIntPool" or ____switch63 == "terraintype" or ____switch63 == "doodad"
        if ____cond63 then
            if type(rmInt) == "function" then
                rmInt(nil, h, p, c)
            end
            return
        end
        ____cond63 = ____cond63 or (____switch63 == "real" or ____switch63 == "radian" or ____switch63 == "degree")
        if ____cond63 then
            if type(rmReal) == "function" then
                rmReal(nil, h, p, c)
            end
            return
        end
        ____cond63 = ____cond63 or ____switch63 == "boolean"
        if ____cond63 then
            if type(rmBool) == "function" then
                rmBool(nil, h, p, c)
            end
            return
        end
        ____cond63 = ____cond63 or (____switch63 == "string" or ____switch63 == "imagefile" or ____switch63 == "modelfile")
        if ____cond63 then
            if type(rmStr) == "function" then
                rmStr(nil, h, p, c)
            end
            return
        end
        do
            if type(rmHandle) == "function" then
                rmHandle(nil, h, p, c)
            elseif type(rmInt) == "function" then
                rmInt(nil, h, p, c)
            end
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
    if type(jass.HaveSavedInteger) == "function" and jass.HaveSavedInteger(h, p, c) then
        return true
    end
    if type(jass.HaveSavedReal) == "function" and jass.HaveSavedReal(h, p, c) then
        return true
    end
    if type(jass.HaveSavedBoolean) == "function" and jass.HaveSavedBoolean(h, p, c) then
        return true
    end
    if type(jass.HaveSavedString) == "function" and jass.HaveSavedString(h, p, c) then
        return true
    end
    if type(jass.HaveSavedHandle) == "function" and jass.HaveSavedHandle(h, p, c) then
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
