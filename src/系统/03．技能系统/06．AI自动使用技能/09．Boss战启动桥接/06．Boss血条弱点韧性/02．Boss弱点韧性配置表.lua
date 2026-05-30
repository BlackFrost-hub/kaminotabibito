local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.06．Boss血条弱点韧性.01．常量定义")
local ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点反馈默认配置"]
local ____Boss_5F31_70B9_5019_9009_5217_8868 = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点候选列表"]
local ____Boss_5F31_70B9YD_5B57_6BB5 = ____01_FF0E_5E38_91CF_5B9A_4E49["Boss弱点YD字段"]
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
____exports["Boss弱点韧性配置表"] = {}
local function _____8BFB_53D6Boss_5F31_70B9_6807_8BB0(bossUnit, weakKey)
    return YDUserDataGetSafe("unit", bossUnit, weakKey, "boolean") == true
end
local function _____8BFB_53D6Boss_62A4_76FE_503C(bossUnit, attr)
    local value = __TS__Number(YDUserDataGetSafe("unit", bossUnit, attr, "integer")) or 0
    return value > 0 and value or nil
end
local function _____8BFB_53D6Boss_79D2_6570_5B57_6BB5_6BEB_79D2(bossUnit, attr)
    local value = __TS__Number(YDUserDataGetSafe("unit", bossUnit, attr, "real")) or 0
    return value > 0 and value * 1000 or nil
end
local function _____521B_5EFAYD_5F31_70B9_914D_7F6E(bossUnit)
    local weakList = {}
    do
        local i = 0
        while i < #____Boss_5F31_70B9_5019_9009_5217_8868 do
            local candidate = ____Boss_5F31_70B9_5019_9009_5217_8868[i + 1]
            if _____8BFB_53D6Boss_5F31_70B9_6807_8BB0(bossUnit, candidate["弱点键"]) then
                weakList[#weakList + 1] = candidate
            end
            i = i + 1
        end
    end
    if #weakList <= 0 then
        return nil
    end
    return {
        ["配置键"] = "YD弱点标记",
        ["弱点列表"] = weakList,
        ["天生弱点数"] = #weakList,
        ["初始护盾值"] = _____8BFB_53D6Boss_62A4_76FE_503C(bossUnit, ____Boss_5F31_70B9YD_5B57_6BB5["原始护盾值"]),
        ["弱点伤害需求"] = _____8BFB_53D6Boss_62A4_76FE_503C(bossUnit, ____Boss_5F31_70B9YD_5B57_6BB5["器弱伤害需求"]),
        ["护盾冷却毫秒"] = _____8BFB_53D6Boss_79D2_6570_5B57_6BB5_6BEB_79D2(bossUnit, ____Boss_5F31_70B9YD_5B57_6BB5["护盾冷却"]) or ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾恢复延迟毫秒"],
        ["弱点发现音效路径"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点发现音效路径"],
        ["弱点击中音效路径"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点击中音效路径"],
        ["护盾破碎音效路径"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾破碎音效路径"],
        ["弱点发现提示启用"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点发现提示启用"],
        ["护盾命中削减值"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["护盾命中削减值"],
        ["弱点命中表现毫秒"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点命中表现毫秒"],
        ["弱点命中伤害加成"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["弱点命中伤害加成"],
        ["破盾控制Buff类型"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾控制Buff类型"],
        ["破盾控制持续秒"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾控制持续秒"],
        ["破盾伤害倍率"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破盾伤害倍率"],
        ["破碎护盾显示毫秒"] = ____Boss_5F31_70B9_53CD_9988_9ED8_8BA4_914D_7F6E["破碎护盾显示毫秒"]
    }
end
____exports["查找Boss弱点韧性配置"] = function(bossUnit)
    if bossUnit == nil or bossUnit == 0 then
        return nil
    end
    local ydConfig = _____521B_5EFAYD_5F31_70B9_914D_7F6E(bossUnit)
    if ydConfig ~= nil then
        return ydConfig
    end
    return nil
end
return ____exports
