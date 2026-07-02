--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.01．获取丢弃监听")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.02．持有型周期效果")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.03．条件开关效果")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.04．范围脉冲效果")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.05．物品次数转移")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.06．暴击属性工具")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.07．物品技能工具")
    ____exports["是否为使用物品"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["是否为使用物品"]
    ____exports["单位持有物品"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["单位持有物品"]
    ____exports["获取单位指定物品"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["获取单位指定物品"]
    ____exports["单位存活"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["单位存活"]
    ____exports["单位是英雄"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["单位是英雄"]
    ____exports["单位可作为敌人目标"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["单位可作为敌人目标"]
    ____exports["获取范围敌人"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["获取范围敌人"]
    ____exports["获取范围友军"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["获取范围友军"]
    ____exports["获取范围尸体"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["获取范围尸体"]
    ____exports["取当前生命"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["取当前生命"]
    ____exports["取当前魔法"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["取当前魔法"]
    ____exports["取最大生命"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["取最大生命"]
    ____exports["取最大魔法"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["取最大魔法"]
    ____exports["取单位攻击"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["取单位攻击"]
    ____exports["计算两点距离"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["计算两点距离"]
    ____exports["计算两点角度"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["计算两点角度"]
    ____exports["限制目标点距离"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["限制目标点距离"]
    ____exports["设置生命"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["设置生命"]
    ____exports["设置魔法"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["设置魔法"]
    ____exports["调整生命"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["调整生命"]
    ____exports["调整魔法"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["调整魔法"]
    ____exports["造成强化伤害"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["造成强化伤害"]
    ____exports["造成火焰伤害"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["造成火焰伤害"]
    ____exports["造成暗影伤害"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["造成暗影伤害"]
    ____exports["造成普通伤害"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["造成普通伤害"]
    ____exports["造成精神自伤"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["造成精神自伤"]
    ____exports["执行治疗"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["执行治疗"]
    ____exports["播放点特效"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["播放点特效"]
    ____exports["播放单位特效"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["播放单位特效"]
    ____exports["施加眩晕"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["施加眩晕"]
    ____exports["施加减速"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["施加减速"]
    ____exports["清除负面Buff"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["清除负面Buff"]
    ____exports["临时调整攻击"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["临时调整攻击"]
    ____exports["临时调整护甲"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["临时调整护甲"]
    ____exports["临时调整攻速"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["临时调整攻速"]
    ____exports["调整玩家属性"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["调整玩家属性"]
    ____exports["调整单位属性"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["调整单位属性"]
    ____exports["读取玩家属性"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["读取玩家属性"]
    ____exports["读取单位属性"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["读取单位属性"]
    ____exports["英雄主属性是智力"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["英雄主属性是智力"]
    ____exports["增加英雄经验与智力"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["增加英雄经验与智力"]
    ____exports["单位所在点是荒芜"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["单位所在点是荒芜"]
    ____exports["击退远离来源"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["击退远离来源"]
    ____exports["拉向来源"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["拉向来源"]
    ____exports["命令攻击来源"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["命令攻击来源"]
    ____exports["取玩家ID"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["取玩家ID"]
    ____exports["创建火把单位"] = ____07_FF0E_7269_54C1_6280_80FD_5DE5_5177["创建火把单位"]
end
return ____exports
