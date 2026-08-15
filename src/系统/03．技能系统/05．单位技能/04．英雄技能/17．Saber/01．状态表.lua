local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local _____72B6_6001_8868 = {}
____exports["获取或创建Saber状态"] = function(caster)
    local id = GetHandleId(caster)
    local record = _____72B6_6001_8868[id]
    if record == nil then
        record = {
            ["英雄句柄ID"] = id,
            ["施法者"] = caster,
            ["Q连击"] = 0,
            ["Q命中组"] = {},
            ["E开启"] = false,
            ["E攻击加成值"] = 0,
            ["阿瓦隆"] = false
        }
        _____72B6_6001_8868[id] = record
    end
    return record
end
____exports["获取Saber状态"] = function(caster)
    if caster == nil or caster == 0 then
        return nil
    end
    return _____72B6_6001_8868[GetHandleId(caster)]
end
____exports["Saber开启E"] = function(caster, _____653B_51FB_52A0_6210_503C)
    local record = ____exports["获取或创建Saber状态"](caster)
    record["E开启"] = true
    record["E攻击加成值"] = _____653B_51FB_52A0_6210_503C
end
--- 结束 E 状态（正常到期 / 被 W 地面联动消耗）。撤销攻击力由 E 技能文件按 record.E攻击加成值 处理。
____exports["Saber关闭E"] = function(caster)
    local record = ____exports["获取Saber状态"](caster)
    if record == nil then
        return
    end
    record["E开启"] = false
end
____exports["Saber是否E开启"] = function(caster)
    local record = ____exports["获取Saber状态"](caster)
    return record ~= nil and record["E开启"]
end
____exports["读取SaberE攻击加成值"] = function(caster)
    local record = ____exports["获取Saber状态"](caster)
    return record ~= nil and record["E攻击加成值"] or 0
end
____exports["Saber设置阿瓦隆"] = function(caster, flag)
    local record = ____exports["获取或创建Saber状态"](caster)
    record["阿瓦隆"] = flag
end
____exports["Saber是否阿瓦隆"] = function(caster)
    local record = ____exports["获取Saber状态"](caster)
    return record ~= nil and record["阿瓦隆"]
end
____exports["SaberQ命中去重添加"] = function(caster, target)
    if target == nil or target == 0 then
        return
    end
    local record = ____exports["获取或创建Saber状态"](caster)
    record["Q命中组"][GetHandleId(target)] = true
end
____exports["SaberQ命中去重包含"] = function(caster, target)
    if target == nil or target == 0 then
        return false
    end
    local record = ____exports["获取Saber状态"](caster)
    return record ~= nil and record["Q命中组"][GetHandleId(target)] == true
end
____exports["Saber清空Q命中组"] = function(caster)
    local record = ____exports["获取Saber状态"](caster)
    if record == nil then
        return
    end
    record["Q命中组"] = {}
end
--- 死亡/英雄替换时清理全部临时状态（各技能文件自身的计时器由各自清理）。
____exports["清理Saber状态"] = function(caster)
    if caster == nil or caster == 0 then
        return
    end
    __TS__Delete(
        _____72B6_6001_8868,
        GetHandleId(caster)
    )
end
return ____exports
