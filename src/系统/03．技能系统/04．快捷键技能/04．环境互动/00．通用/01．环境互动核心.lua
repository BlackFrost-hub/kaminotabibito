local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.00．配置ID工具")
local _____89E3_6790_914D_7F6E_5185_90E8ID = ____require_result_2["解析配置内部ID"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8DDD_79BB_5E73_65B9XY = ____require_result_3["距离平方XY"]
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
local _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6 = ____require_result_4["发送单位提示给玩家"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_5.getGameTime
local ____require_result_6 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.00．环境互动配置")
local _____73AF_5883_4E92_52A8_6280_80FDID = ____require_result_6["环境互动技能ID"]
local _____73AF_5883_4E92_52A8_9ED8_8BA4_89E6_53D1_8303_56F4 = ____require_result_6["环境互动默认触发范围"]
local _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_6587_672C = ____require_result_6["环境互动空挥提示文本"]
local _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_6301_7EED_6BEB_79D2 = ____require_result_6["环境互动空挥提示持续毫秒"]
local _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_51B7_5374_6BEB_79D2 = ____require_result_6["环境互动空挥提示冷却毫秒"]
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerId = jass.GetPlayerId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
local _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 = {}
local _____5DF2_521D_59CB_5316_73AF_5883_4E92_52A8 = false
--- 玩家ID -> 上次空挥提示的游戏时间。只用于提示节流，与互动点生命周期无关。
local _____7A7A_6325_63D0_793A_4E0A_6B21_65F6_95F4_8868 = {}
local function _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9ID)
    do
        local i = 0
        while i < #_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 do
            do
                if _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868[i + 1].ID ~= _____8C03_67E5_70B9ID then
                    goto __continue4
                end
                __TS__ArraySplice(_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868, i, 1)
                return true
            end
            ::__continue4::
            i = i + 1
        end
    end
    return false
end
--- 施法范围内没有可取互动时，只对施法玩家反馈；按玩家节流，避免连续施法刷屏。
local function _____63D0_793A_7A7A_6325(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, _____73A9_5BB6ID)
    local _____5F53_524D_65F6_95F4 = getGameTime()
    local _____4E0A_6B21_65F6_95F4 = _____7A7A_6325_63D0_793A_4E0A_6B21_65F6_95F4_8868[_____73A9_5BB6ID]
    if _____4E0A_6B21_65F6_95F4 ~= nil and _____5F53_524D_65F6_95F4 - _____4E0A_6B21_65F6_95F4 < _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_51B7_5374_6BEB_79D2 then
        return
    end
    _____7A7A_6325_63D0_793A_4E0A_6B21_65F6_95F4_8868[_____73A9_5BB6ID] = _____5F53_524D_65F6_95F4
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_6587_672C, _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_6301_7EED_6BEB_79D2)
end
--- 概率奖励失败是一次有效互动，不能走空挥节流，否则玩家可能收不到结果。
local function _____63D0_793A_73AF_5883_4E92_52A8_65E0_6548(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D)
    _____53D1_9001_5355_4F4D_63D0_793A_7ED9_73A9_5BB6(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_6587_672C, _____73AF_5883_4E92_52A8_7A7A_6325_63D0_793A_6301_7EED_6BEB_79D2)
end
local function _____5904_7406_73AF_5883_4E92_52A8_6280_80FD(_____65BD_6CD5_5355_4F4D, _____6280_80FDID)
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____65BD_6CD5_5355_4F4D) then
        return
    end
    if _____6280_80FDID ~= _____89E3_6790_914D_7F6E_5185_90E8ID(_____73AF_5883_4E92_52A8_6280_80FDID) then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____65BD_6CD5_5355_4F4D)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____73A9_5BB6ID = GetPlayerId(_____73A9_5BB6)
    local _____65BD_6CD5X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____65BD_6CD5Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    do
        local i = 0
        while i < #_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 do
            do
                local _____8C03_67E5_70B9 = _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868[i + 1]
                local _____89E6_53D1_8303_56F4 = _____8C03_67E5_70B9["触发范围"] ~= nil and _____8C03_67E5_70B9["触发范围"] > 0 and _____8C03_67E5_70B9["触发范围"] or _____73AF_5883_4E92_52A8_9ED8_8BA4_89E6_53D1_8303_56F4
                if _____8DDD_79BB_5E73_65B9XY(_____65BD_6CD5X, _____65BD_6CD5Y, _____8C03_67E5_70B9.X, _____8C03_67E5_70B9.Y) > _____89E6_53D1_8303_56F4 * _____89E6_53D1_8303_56F4 then
                    goto __continue14
                end
                if _____8C03_67E5_70B9["一次性奖励概率"] ~= nil then
                    if _____8C03_67E5_70B9["触发前置检查"] ~= nil and not _____8C03_67E5_70B9["触发前置检查"](_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9) then
                        goto __continue14
                    end
                    _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9.ID)
                    if GetRandomReal(0, 1) >= _____8C03_67E5_70B9["一次性奖励概率"] then
                        _____63D0_793A_73AF_5883_4E92_52A8_65E0_6548(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D)
                        return
                    end
                    if not _____8C03_67E5_70B9["触发回调"](_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9) then
                        _____63D0_793A_73AF_5883_4E92_52A8_65E0_6548(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D)
                    end
                    return
                end
                if _____8C03_67E5_70B9["触发回调"](_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9) then
                    if _____8C03_67E5_70B9["一次性"] ~= false then
                        _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9.ID)
                    end
                    return
                end
            end
            ::__continue14::
            i = i + 1
        end
    end
    _____63D0_793A_7A7A_6325(_____73A9_5BB6, _____65BD_6CD5_5355_4F4D, _____73A9_5BB6ID)
end
--- 注册一个可被环境互动技能触发的调查点；同 ID 会先替换旧配置。
____exports["注册环境互动调查点"] = function(_____8C03_67E5_70B9)
    if _____8C03_67E5_70B9 == nil or _____8C03_67E5_70B9.ID == "" or _____8C03_67E5_70B9["触发回调"] == nil then
        return false
    end
    _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9.ID)
    _____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868[#_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 + 1] = _____8C03_67E5_70B9
    return true
end
--- 注销指定调查点，返回是否找到并移除。
____exports["注销环境互动调查点"] = function(_____8C03_67E5_70B9ID)
    if _____8C03_67E5_70B9ID == "" then
        return false
    end
    return _____79FB_9664_8C03_67E5_70B9(_____8C03_67E5_70B9ID)
end
--- 注销全部调查点；任务结束、场景切换或失败清理时使用。
____exports["清理全部环境互动调查点"] = function()
    do
        local i = #_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868 - 1
        while i >= 0 do
            table.remove(_____73AF_5883_4E92_52A8_8C03_67E5_70B9_5217_8868)
            i = i - 1
        end
    end
end
____exports["init环境互动"] = function()
    if _____5DF2_521D_59CB_5316_73AF_5883_4E92_52A8 then
        return
    end
    _____5DF2_521D_59CB_5316_73AF_5883_4E92_52A8 = true
    local _____65E7_73AF_5883_4E92_52A8_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.02．旧环境互动.01．旧环境互动核心")
    local ____opt_7 = _____65E7_73AF_5883_4E92_52A8_6A21_5757["注册旧环境互动调查点"]
    if ____opt_7 ~= nil then
        ____opt_7()
    end
    local _____7956_5730_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.03．精灵祖地.00．入口配置")
    local ____opt_9 = _____7956_5730_63A2_7D22_6A21_5757["注册精灵祖地探索点"]
    if ____opt_9 ~= nil then
        ____opt_9()
    end
    local _____738B_57CE_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.01．精灵王城.00．入口配置")
    local ____opt_11 = _____738B_57CE_63A2_7D22_6A21_5757["注册精灵王城探索点"]
    if ____opt_11 ~= nil then
        ____opt_11()
    end
    local _____9759_7075_68EE_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.01．静灵森.00．入口配置")
    local ____opt_13 = _____9759_7075_68EE_63A2_7D22_6A21_5757["注册静灵森探索点"]
    if ____opt_13 ~= nil then
        ____opt_13()
    end
    local _____7CBE_7075_6751_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.02．精灵村.00．入口配置")
    local ____opt_15 = _____7CBE_7075_6751_63A2_7D22_6A21_5757["注册精灵村探索点"]
    if ____opt_15 ~= nil then
        ____opt_15()
    end
    local _____76D7_8D3C_6D1E_7A9F_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.03．盗贼洞窟.00．入口配置")
    local ____opt_17 = _____76D7_8D3C_6D1E_7A9F_63A2_7D22_6A21_5757["注册盗贼洞窟探索点"]
    if ____opt_17 ~= nil then
        ____opt_17()
    end
    local _____7CBE_7075_4F20_9001_9635_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.04．精灵传送阵.00．入口配置")
    local ____opt_19 = _____7CBE_7075_4F20_9001_9635_63A2_7D22_6A21_5757["注册精灵传送阵探索点"]
    if ____opt_19 ~= nil then
        ____opt_19()
    end
    local _____707C_70ED_706B_5C71_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.06．灼热火山.00．入口配置")
    local ____opt_21 = _____707C_70ED_706B_5C71_63A2_7D22_6A21_5757["注册灼热火山探索点"]
    if ____opt_21 ~= nil then
        ____opt_21()
    end
    local _____6076_9B54_57CE_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.01．恶魔城.00．入口配置")
    local ____opt_23 = _____6076_9B54_57CE_63A2_7D22_6A21_5757["注册恶魔城探索点"]
    if ____opt_23 ~= nil then
        ____opt_23()
    end
    local _____6076_9B54_8FF7_5BAB_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.08．恶魔迷宫.00．入口配置")
    local ____opt_25 = _____6076_9B54_8FF7_5BAB_63A2_7D22_6A21_5757["注册恶魔迷宫探索点"]
    if ____opt_25 ~= nil then
        ____opt_25()
    end
    local _____738B_5EAD_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.05．王庭.00．入口配置")
    local ____opt_27 = _____738B_5EAD_63A2_7D22_6A21_5757["注册王庭探索点"]
    if ____opt_27 ~= nil then
        ____opt_27()
    end
    local _____94A5_5319_5723_5730_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.02．第二章.06．钥匙圣地.00．入口配置")
    local ____opt_29 = _____94A5_5319_5723_5730_63A2_7D22_6A21_5757["注册钥匙圣地探索点"]
    if ____opt_29 ~= nil then
        ____opt_29()
    end
    local _____706B_7130_795E_6BBF_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.03．火焰神殿.00．入口配置")
    local ____opt_31 = _____706B_7130_795E_6BBF_63A2_7D22_6A21_5757["注册火焰神殿探索点"]
    if ____opt_31 ~= nil then
        ____opt_31()
    end
    local _____82F1_7075_5893_5730_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.04．英灵墓地.00．入口配置")
    local ____opt_33 = _____82F1_7075_5893_5730_63A2_7D22_6A21_5757["注册英灵墓地探索点"]
    if ____opt_33 ~= nil then
        ____opt_33()
    end
    local _____5C01_5370_6838_5FC3_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.05．封印核心.00．入口配置")
    local ____opt_35 = _____5C01_5370_6838_5FC3_63A2_7D22_6A21_5757["注册封印核心探索点"]
    if ____opt_35 ~= nil then
        ____opt_35()
    end
    local _____60B2_98CE_5C71_8C37_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.01．第一章.04．悲风山谷.00．入口配置")
    local ____opt_37 = _____60B2_98CE_5C71_8C37_63A2_7D22_6A21_5757["注册悲风山谷探索点"]
    if ____opt_37 ~= nil then
        ____opt_37()
    end
    local _____6076_9B54_57CE_91CE_5916_7194_5CA9_63A2_7D22_6A21_5757 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.03．区域探索.03．第三章.01．恶魔城.01．野外熔岩区.00．入口配置")
    local ____opt_39 = _____6076_9B54_57CE_91CE_5916_7194_5CA9_63A2_7D22_6A21_5757["注册恶魔城野外熔岩探索点"]
    if ____opt_39 ~= nil then
        ____opt_39()
    end
    registerSpellEffectListener(_____5904_7406_73AF_5883_4E92_52A8_6280_80FD)
end
return ____exports
