--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local ____require_result_2 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E = ____require_result_2["获取Boss死亡结算配置"]
local _____6267_884CBoss_6B7B_4EA1_7ED3_7B97 = ____require_result_2["执行Boss死亡结算"]
local _____6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5 = "测试Boss跳过死亡结算"
local _____521D_59CB_6CE8_518CBoss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5 = "初始注册Boss跳过死亡结算"
local _____5DF2_521D_59CB_5316Boss_6B7B_4EA1_7ED3_7B97_6865_63A5 = false
local function ____onBoss_6B7B_4EA1_7ED3_7B97_4E8B_4EF6(dyingUnit, killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if YDUserDataGetSafe("unit", dyingUnit, _____6D4B_8BD5Boss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5, "boolean") == true then
        return
    end
    if YDUserDataGetSafe("unit", dyingUnit, _____521D_59CB_6CE8_518CBoss_8DF3_8FC7_6B7B_4EA1_7ED3_7B97_5B57_6BB5, "boolean") == true then
        return
    end
    local _____914D_7F6E = _____83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E(dyingUnit)
    if _____914D_7F6E == nil then
        return
    end
    if _____914D_7F6E["保留原剧情执行"] == true then
        return
    end
    _____6267_884CBoss_6B7B_4EA1_7ED3_7B97(_____914D_7F6E, dyingUnit, killingUnit)
end
____exports["初始化Boss死亡结算死亡事件桥接"] = function()
    if _____5DF2_521D_59CB_5316Boss_6B7B_4EA1_7ED3_7B97_6865_63A5 then
        return
    end
    _____5DF2_521D_59CB_5316Boss_6B7B_4EA1_7ED3_7B97_6865_63A5 = true
    registerDeathListener(____onBoss_6B7B_4EA1_7ED3_7B97_4E8B_4EF6)
end
____exports["初始化Boss死亡结算死亡事件桥接"]()
return ____exports
