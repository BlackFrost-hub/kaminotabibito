local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.01．物品使用配置表")
local _____7269_54C1_4F7F_7528_88C5_5907ID = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用装备ID"]
local _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E = ____01_FF0E_7269_54C1_4F7F_7528_914D_7F6E_8868["物品使用数值配置"]
local ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177 = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具")
local _____662F_5426_4E3A_4F7F_7528_7269_54C1 = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["是否为使用物品"]
local _____5355_4F4D_5B58_6D3B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["单位存活"]
local _____589E_52A0_82F1_96C4_7ECF_9A8C_4E0E_667A_529B = ____02_FF0E_7269_54C1_4F7F_7528_5DE5_5177["增加英雄经验与智力"]
local ____22_FF0E_5355_4F4D_6C38_4E45_6807_8BB0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.22．单位永久标记")
local _____521B_5EFA_5355_4F4D_6C38_4E45_6807_8BB0 = ____22_FF0E_5355_4F4D_6C38_4E45_6807_8BB0["创建单位永久标记"]
local ____require_result_0 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4 = ____require_result_0["获取玩家英雄单位组"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_1["开始充能"]
local jass = require("jass.common")
local GetHeroInt = jass.GetHeroInt
local ForGroup = jass.ForGroup
local GetEnumUnit = jass.GetEnumUnit
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local Player = jass.Player
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local _____5546_4EBA_4E4B_4E66_5DF2_53C2_609F = _____521B_5EFA_5355_4F4D_6C38_4E45_6807_8BB0("商人之书已参悟")
local _____5546_4EBA_4E4B_4E66_65BD_6CD5_6BEB_79D2 = 3000
local _____5546_4EBA_4E4B_4E66_63D0_793A_524D_7F00 = "|cffffff00『系统提示』|r："
local _____5546_4EBA_4E4B_4E66_65BD_6CD5_4E2D = {}
local _____667A_529B_6BD4_8F83_76EE_6807_667A_529B = 0
local _____667A_529B_6BD4_8F83_6700_5927_503C = 0
local function _____63D0_793A_5546_4EBA_4E4B_4E66(unit, text)
    if unit == nil or unit == 0 then
        return
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return
    end
    DisplayTimedTextToPlayer(
        Player(GetPlayerId(owner)),
        0,
        0,
        5,
        (_____5546_4EBA_4E4B_4E66_63D0_793A_524D_7F00 .. text) .. "|r"
    )
end
local function ____on_7EDF_8BA1_6700_9AD8_667A_529B_82F1_96C4()
    local hero = GetEnumUnit()
    if not _____5355_4F4D_5B58_6D3B(hero) then
        return
    end
    local value = GetHeroInt(hero, true)
    if value > _____667A_529B_6BD4_8F83_6700_5927_503C then
        _____667A_529B_6BD4_8F83_6700_5927_503C = value
    end
end
local function _____662F_5426_5F53_524D_6700_9AD8_667A_529B_82F1_96C4(unit)
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    local group = _____83B7_53D6_73A9_5BB6_82F1_96C4_5355_4F4D_7EC4()
    if group == nil or group == 0 then
        return true
    end
    _____667A_529B_6BD4_8F83_76EE_6807_667A_529B = GetHeroInt(unit, true)
    _____667A_529B_6BD4_8F83_6700_5927_503C = _____667A_529B_6BD4_8F83_76EE_6807_667A_529B
    ForGroup(group, ____on_7EDF_8BA1_6700_9AD8_667A_529B_82F1_96C4)
    return _____667A_529B_6BD4_8F83_76EE_6807_667A_529B >= _____667A_529B_6BD4_8F83_6700_5927_503C
end
local function ____on_5546_4EBA_4E4B_4E66_5145_80FD_5B8C_6210(unit, ______5145_80FDID)
    local id = GetHandleId(unit) or 0
    if id ~= 0 then
        __TS__Delete(_____5546_4EBA_4E4B_4E66_65BD_6CD5_4E2D, id)
    end
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    if not _____662F_5426_5F53_524D_6700_9AD8_667A_529B_82F1_96C4(unit) then
        _____63D0_793A_5546_4EBA_4E4B_4E66(unit, "此书晦涩难懂，我看不明白。")
        return
    end
    if not _____5546_4EBA_4E4B_4E66_5DF2_53C2_609F["标记若不存在"](unit) then
        _____63D0_793A_5546_4EBA_4E4B_4E66(unit, "这本书的内容已经被参透了。")
        return
    end
    local cfg = _____7269_54C1_4F7F_7528_6570_503C_914D_7F6E["商人之书"]
    _____589E_52A0_82F1_96C4_7ECF_9A8C_4E0E_667A_529B(unit, cfg["经验次数"], cfg["每次经验"], cfg["智力增加"])
    _____63D0_793A_5546_4EBA_4E4B_4E66(unit, "你读懂了商人的手札，获得经验与智力提升。")
end
local function ____on_5546_4EBA_4E4B_4E66_5145_80FD_7ED3_675F(unit, ______539F_56E0, ______5145_80FDID)
    local id = GetHandleId(unit) or 0
    if id ~= 0 then
        __TS__Delete(_____5546_4EBA_4E4B_4E66_65BD_6CD5_4E2D, id)
    end
end
____exports["处理商人之书使用"] = function(ctx)
    if not _____662F_5426_4E3A_4F7F_7528_7269_54C1(ctx["物品"], _____7269_54C1_4F7F_7528_88C5_5907ID["商人之书"]) then
        return
    end
    local unit = ctx["施法单位"]
    if not _____662F_5426_5F53_524D_6700_9AD8_667A_529B_82F1_96C4(unit) then
        _____63D0_793A_5546_4EBA_4E4B_4E66(unit, "此书晦涩难懂，我看不明白。")
        return
    end
    if _____5546_4EBA_4E4B_4E66_5DF2_53C2_609F["存在"](unit) then
        _____63D0_793A_5546_4EBA_4E4B_4E66(unit, "这本书的内容已经被参透了。")
        return
    end
    local id = GetHandleId(unit) or 0
    if id ~= 0 and _____5546_4EBA_4E4B_4E66_65BD_6CD5_4E2D[id] == true then
        return
    end
    if id ~= 0 then
        _____5546_4EBA_4E4B_4E66_65BD_6CD5_4E2D[id] = true
    end
    _____5F00_59CB_5145_80FD(unit, {
        ["持续时间"] = _____5546_4EBA_4E4B_4E66_65BD_6CD5_6BEB_79D2 / 1000,
        ["主单位"] = unit,
        ["主单位死亡时中断"] = true,
        ["强制硬直"] = true,
        ["显示进度条特效"] = true,
        ["充能完成回调"] = ____on_5546_4EBA_4E4B_4E66_5145_80FD_5B8C_6210,
        ["结束回调"] = ____on_5546_4EBA_4E4B_4E66_5145_80FD_7ED3_675F
    })
end
return ____exports
