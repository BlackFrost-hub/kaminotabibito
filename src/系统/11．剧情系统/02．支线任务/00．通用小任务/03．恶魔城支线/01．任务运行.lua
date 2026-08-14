--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.03．技能系统.04．快捷键技能.04．环境互动.00．通用.01．环境互动核心")
local _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_2["注册环境互动调查点"]
local _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9 = ____require_result_2["注销环境互动调查点"]
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_3["创建单位并登记排泄安全"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.物品相关函数.物品判断函数")
local ConsumeItemTypeCountByChargesBJ = ____require_result_5.ConsumeItemTypeCountByChargesBJ
local UnitHasItemOfTypeBJ = ____require_result_5.UnitHasItemOfTypeBJ
local ____require_result_6 = require("系统.09．表现系统.02．对话框系统.14．任务物品发放")
local _____53D1_653E_4EFB_52A1_7269_54C1 = ____require_result_6["发放任务物品"]
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_7.getRegisteredPlayerHero
local function _____6309_4EFB_52A1ID_521B_5EFANPC(_____4EFB_52A1ID)
    local ____NPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
    return ____NPC_751F_6210_5668["按任务ID创建NPC"](_____4EFB_52A1ID)
end
local function _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC(_____4EFB_52A1ID)
    local ____NPC_751F_6210_5668 = require("系统.08．任务系统.00．配置表.04．NPC生成器")
    return ____NPC_751F_6210_5668["按任务ID查找已创建NPC"](_____4EFB_52A1ID)
end
local ____require_result_8 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_8["广播单位提示"]
local ____require_result_9 = require("系统.08．任务系统.01．任务数据")
local questDB = ____require_result_9.questDB
local ____require_result_10 = require("系统.08．任务系统.02．任务管理器")
local _____89E6_53D1_4EFB_52A1UI_5237_65B0 = ____require_result_10["触发任务UI刷新"]
local ____require_result_11 = require("平台扩展API动作")
local _____8BBE_5355_4F4D_540D_5B57 = ____require_result_11["设单位名字"]
local Player = jass.Player
local RemoveUnit = jass.RemoveUnit
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitName = jass.GetUnitName
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitAnimation = jass.SetUnitAnimation
local IssueImmediateOrder = jass.IssueImmediateOrder
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local ConvertUnitState = jass.ConvertUnitState
local GetRandomReal = jass.GetRandomReal
local SetUnitStateJapi = japi.SetUnitState
____exports["熔火酒任务ID"] = 10102
____exports["迷宫缺灯任务ID"] = 10103
____exports["遗失角饰任务ID"] = 10104
____exports["墓门旧誓任务ID"] = 10105
____exports["熔核余温任务ID"] = 10106
____exports["合法决斗任务ID"] = 10107
____exports["城外恶魔守卫登记ID"] = 10901
local _____7194_706B_9152_7269_54C1ID = "I0JX"
local _____9057_5931_89D2_9970_7269_54C1ID = "I0JY"
local _____738B_65CF_65E7_8A93_5370_7269_54C1ID = "I0JZ"
local _____4F59_7130_91C7_6837_5668_7269_54C1ID = "I0K0"
local _____7A33_5B9A_4F59_7130_6837_672C_7269_54C1ID = "I0K1"
local _____73AF_5883_4E92_52A8_8303_56F4 = 300
local _____57CE_5916_5B88_536BX = 23462.5
local _____57CE_5916_5B88_536BY = -14789.7
local _____57CE_5916_5B88_536B_89E6_53D1_8303_56F4 = 300
local _____51B3_6597_5317_4FA7X = 14488.3
local _____51B3_6597_5317_4FA7Y = -16492.5
local _____51B3_6597_5357_4FA7X = 14488.3
local _____51B3_6597_5357_4FA7Y = -16992.5
local _____51B3_6597_7EDF_4E00_6700_5927_751F_547D = 10000
local _____51B3_6597_7EDF_4E00_653B_51FB_529B = 900
local _____51B3_6597_7EDF_4E00_62A4_7532 = 15
local _____51B3_6597_7EDF_4E00_653B_51FB_95F4_9694 = 1
local _____51B3_6597_88C1_5B9A_751F_547D_6BD4_4F8B = 0.15
local _____51B3_6597_653B_51FB_529B_72B6_6001 = ConvertUnitState(21)
local _____51B3_6597_62A4_7532_72B6_6001 = ConvertUnitState(32)
local _____51B3_6597_653B_51FB_95F4_9694_72B6_6001 = ConvertUnitState(37)
local _____6700_5927_751F_547D_72B6_6001 = jass.UNIT_STATE_MAX_LIFE
local _____5F53_524D_751F_547D_72B6_6001 = jass.UNIT_STATE_LIFE
local _____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868 = {
    {
        ID = "恶魔迷宫外_遗落纸张",
        ["任务ID"] = ____exports["迷宫缺灯任务ID"],
        X = 22749.2,
        Y = -9325.4,
        ["发现文本"] = "|cffffff00『调查发现』：|r烧焦的测绘纸上还留着半条路线，最后一笔停在迷宫入口附近。"
    },
    {
        ID = "恶魔迷宫外_引路灯",
        ["任务ID"] = ____exports["迷宫缺灯任务ID"],
        X = 21958.2,
        Y = -7467.6,
        ["发现文本"] = "|cffffff00『调查发现』：|r引路灯被人从固定架上硬生生拆走，只剩一小片带爪痕的金属底座。"
    },
    {
        ID = "恶魔迷宫外_岔路痕迹",
        ["任务ID"] = ____exports["迷宫缺灯任务ID"],
        X = 21298.3,
        Y = -9142.1,
        ["发现文本"] = "|cffffff00『调查发现』：|r岔路的碎石上留着拖行痕迹，方向正通往双翼恶魔盘旋的高地。"
    },
    {
        ID = "王墓_旧誓标志",
        ["任务ID"] = ____exports["墓门旧誓任务ID"],
        X = 5216.9,
        Y = -14796,
        ["发现文本"] = "|cffffff00『调查发现』：|r墓门下的旧徽记仍在回应守陵人的誓言，一枚王族旧誓印从裂缝中显露出来。"
    },
    {
        ID = "熔核_余焰一",
        ["任务ID"] = ____exports["熔核余温任务ID"],
        X = 10631.2,
        Y = -9219.5,
        ["发现文本"] = "|cffffff00『采样进度』：|r第一处余焰温度稳定，采样器已经记下它的焰流。"
    },
    {
        ID = "熔核_余焰二",
        ["任务ID"] = ____exports["熔核余温任务ID"],
        X = 7485.5,
        Y = -9306,
        ["发现文本"] = "|cffffff00『采样进度』：|r第二处余焰混着熔岩杂质，经过过滤后仍可作为样本的一部分。"
    },
    {
        ID = "熔核_余焰三",
        ["任务ID"] = ____exports["熔核余温任务ID"],
        X = 9169,
        Y = -10578,
        ["发现文本"] = "|cffffff00『采样进度』：|r第三处余焰的脉动最强，采样器的封口已经开始发烫。"
    },
    {
        ID = "熔核_余焰四",
        ["任务ID"] = ____exports["熔核余温任务ID"],
        X = 6864.6,
        Y = -10487.3,
        ["发现文本"] = "|cffffff00『采样完成』：|r四处余焰已经完成比对，采样器将它们压成了一份稳定余焰样本。"
    }
}
local _____5DF2_8C03_67E5_70B9 = {}
local _____7194_706B_9152_63A5_53D6_73A9_5BB6ID = -1
local _____7194_706B_9152_626B_63CF_56DE_8C03ID = 0
local _____9057_5931_89D2_9970_63A5_53D6_73A9_5BB6ID = -1
local _____9057_5931_89D2_9970_6076_9B54_72AC = nil
local _____5408_6CD5_51B3_6597_63A5_53D6_73A9_5BB6ID = -1
local _____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D = nil
local _____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D = nil
local _____5408_6CD5_51B3_6597_56DE_8C03ID = 0
local _____5408_6CD5_51B3_6597_5DF2_7ED3_675F = false
local function _____67E5_627E_6D3B_52A8_4EFB_52A1(_____73A9_5BB6ID, _____4EFB_52A1ID)
    local _____4EFB_52A1_952E = tostring(_____4EFB_52A1ID)
    local _____6D3B_52A8_4EFB_52A1_5217_8868 = questDB.getPlayerActiveQuests(_____73A9_5BB6ID)
    do
        local i = 0
        while i < #_____6D3B_52A8_4EFB_52A1_5217_8868 do
            local _____4EFB_52A1 = _____6D3B_52A8_4EFB_52A1_5217_8868[i + 1]
            if _____4EFB_52A1 ~= nil and _____4EFB_52A1.id == _____4EFB_52A1_952E then
                return _____4EFB_52A1
            end
            i = i + 1
        end
    end
    return nil
end
local function _____66F4_65B0_4EFB_52A1_76EE_6807(_____73A9_5BB6ID, _____4EFB_52A1ID, _____65B0_8FDB_5EA6)
    local _____4EFB_52A1 = _____67E5_627E_6D3B_52A8_4EFB_52A1(_____73A9_5BB6ID, _____4EFB_52A1ID)
    if _____4EFB_52A1 == nil or _____4EFB_52A1.objectives == nil or #_____4EFB_52A1.objectives == 0 then
        return false
    end
    local _____76EE_6807 = _____4EFB_52A1.objectives[1]
    if _____76EE_6807 == nil or _____65B0_8FDB_5EA6 <= _____76EE_6807.current then
        return false
    end
    if not questDB.updateObjective(_____73A9_5BB6ID, _____4EFB_52A1.id, _____76EE_6807.id, _____65B0_8FDB_5EA6) then
        return false
    end
    _____89E6_53D1_4EFB_52A1UI_5237_65B0(_____73A9_5BB6ID, _____4EFB_52A1.id)
    return true
end
local function _____8BFB_53D6_4EFB_52A1_8FDB_5EA6(_____73A9_5BB6ID, _____4EFB_52A1ID)
    local _____4EFB_52A1 = _____67E5_627E_6D3B_52A8_4EFB_52A1(_____73A9_5BB6ID, _____4EFB_52A1ID)
    if _____4EFB_52A1 == nil or _____4EFB_52A1.objectives == nil or #_____4EFB_52A1.objectives == 0 then
        return nil
    end
    local _____76EE_6807 = _____4EFB_52A1.objectives[1]
    local ____temp_12
    if _____76EE_6807 == nil then
        ____temp_12 = nil
    else
        ____temp_12 = {["当前"] = _____76EE_6807.current, ["需求"] = _____76EE_6807.required}
    end
    return ____temp_12
end
local function _____67E5_627E_8C03_67E5_70B9_914D_7F6E(_____8C03_67E5_70B9ID)
    do
        local i = 0
        while i < #_____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868 do
            if _____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868[i + 1].ID == _____8C03_67E5_70B9ID then
                return _____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868[i + 1]
            end
            i = i + 1
        end
    end
    return nil
end
local function _____6E05_7406_4EFB_52A1_8C03_67E5_70B9(_____4EFB_52A1ID)
    do
        local i = 0
        while i < #_____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868[i + 1]
                if _____914D_7F6E["任务ID"] ~= _____4EFB_52A1ID then
                    goto __continue20
                end
                _____6CE8_9500_73AF_5883_4E92_52A8_8C03_67E5_70B9(_____914D_7F6E.ID)
                _____5DF2_8C03_67E5_70B9[_____914D_7F6E.ID] = false
            end
            ::__continue20::
            i = i + 1
        end
    end
end
local function _____5904_7406_6076_9B54_57CE_73AF_5883_4E92_52A8(_____73A9_5BB6ID, _____65BD_6CD5_5355_4F4D, _____8C03_67E5_70B9)
    local _____914D_7F6E = _____67E5_627E_8C03_67E5_70B9_914D_7F6E(_____8C03_67E5_70B9.ID)
    if _____914D_7F6E == nil or _____5DF2_8C03_67E5_70B9[_____914D_7F6E.ID] == true then
        return false
    end
    local _____8FDB_5EA6 = _____8BFB_53D6_4EFB_52A1_8FDB_5EA6(_____73A9_5BB6ID, _____914D_7F6E["任务ID"])
    if _____8FDB_5EA6 == nil or _____8FDB_5EA6["当前"] >= _____8FDB_5EA6["需求"] then
        return false
    end
    if _____914D_7F6E["任务ID"] == ____exports["熔核余温任务ID"] then
        local _____91C7_6837_5668ID = stringToFourCCSafe(_____4F59_7130_91C7_6837_5668_7269_54C1ID)
        if not UnitHasItemOfTypeBJ(_____65BD_6CD5_5355_4F4D, _____91C7_6837_5668ID) then
            _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, "|cffffff00『任务提示』：|r没有余焰采样器，无法封存这里的火焰。", 4200)
            return false
        end
    end
    local _____65B0_8FDB_5EA6 = _____8FDB_5EA6["当前"] + 1
    if not _____66F4_65B0_4EFB_52A1_76EE_6807(_____73A9_5BB6ID, _____914D_7F6E["任务ID"], _____65B0_8FDB_5EA6) then
        return false
    end
    _____5DF2_8C03_67E5_70B9[_____914D_7F6E.ID] = true
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, _____914D_7F6E["发现文本"], 5000)
    if _____914D_7F6E["任务ID"] == ____exports["迷宫缺灯任务ID"] and _____65B0_8FDB_5EA6 == 3 then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____65BD_6CD5_5355_4F4D, "|cffffff00『调查结果』：|r三处痕迹都指向双翼究极恶魔。击败它，才能把迷宫外围的威胁彻底清除。", 5200)
    elseif _____914D_7F6E["任务ID"] == ____exports["墓门旧誓任务ID"] then
        _____53D1_653E_4EFB_52A1_7269_54C1(_____65BD_6CD5_5355_4F4D, _____738B_65CF_65E7_8A93_5370_7269_54C1ID)
    elseif _____914D_7F6E["任务ID"] == ____exports["熔核余温任务ID"] and _____65B0_8FDB_5EA6 >= _____8FDB_5EA6["需求"] then
        local _____91C7_6837_5668ID = stringToFourCCSafe(_____4F59_7130_91C7_6837_5668_7269_54C1ID)
        if ConsumeItemTypeCountByChargesBJ(_____65BD_6CD5_5355_4F4D, _____91C7_6837_5668ID, 1) then
            _____53D1_653E_4EFB_52A1_7269_54C1(_____65BD_6CD5_5355_4F4D, _____7A33_5B9A_4F59_7130_6837_672C_7269_54C1ID)
        end
    end
    return true
end
local function _____6CE8_518C_4EFB_52A1_8C03_67E5_70B9(_____4EFB_52A1ID)
    _____6E05_7406_4EFB_52A1_8C03_67E5_70B9(_____4EFB_52A1ID)
    do
        local i = 0
        while i < #_____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____6076_9B54_57CE_8C03_67E5_70B9_914D_7F6E_8868[i + 1]
                if _____914D_7F6E["任务ID"] ~= _____4EFB_52A1ID then
                    goto __continue34
                end
                _____6CE8_518C_73AF_5883_4E92_52A8_8C03_67E5_70B9({
                    ID = _____914D_7F6E.ID,
                    X = _____914D_7F6E.X,
                    Y = _____914D_7F6E.Y,
                    ["触发范围"] = _____73AF_5883_4E92_52A8_8303_56F4,
                    ["触发回调"] = _____5904_7406_6076_9B54_57CE_73AF_5883_4E92_52A8
                })
            end
            ::__continue34::
            i = i + 1
        end
    end
end
local function _____505C_6B62_7194_706B_9152_9001_8FBE_626B_63CF()
    if _____7194_706B_9152_626B_63CF_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____7194_706B_9152_626B_63CF_56DE_8C03ID)
    end
    _____7194_706B_9152_626B_63CF_56DE_8C03ID = 0
end
local function ____on_7194_706B_9152_9001_8FBE_626B_63CF()
    if _____7194_706B_9152_63A5_53D6_73A9_5BB6ID < 0 or _____67E5_627E_6D3B_52A8_4EFB_52A1(_____7194_706B_9152_63A5_53D6_73A9_5BB6ID, ____exports["熔火酒任务ID"]) == nil then
        _____505C_6B62_7194_706B_9152_9001_8FBE_626B_63CF()
        return
    end
    local _____73A9_5BB6 = jass.Player(_____7194_706B_9152_63A5_53D6_73A9_5BB6ID)
    local _____82F1_96C4 = getRegisteredPlayerHero(_____73A9_5BB6)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return
    end
    local ____X_5DEE = jass.GetUnitX(_____82F1_96C4) - _____57CE_5916_5B88_536BX
    local ____Y_5DEE = jass.GetUnitY(_____82F1_96C4) - _____57CE_5916_5B88_536BY
    if ____X_5DEE * ____X_5DEE + ____Y_5DEE * ____Y_5DEE > _____57CE_5916_5B88_536B_89E6_53D1_8303_56F4 * _____57CE_5916_5B88_536B_89E6_53D1_8303_56F4 then
        return
    end
    local _____9152_7269_54C1_7C7B_578BID = stringToFourCCSafe(_____7194_706B_9152_7269_54C1ID)
    if not ConsumeItemTypeCountByChargesBJ(_____82F1_96C4, _____9152_7269_54C1_7C7B_578BID, 1) then
        _____5E7F_64AD_5355_4F4D_63D0_793A(_____82F1_96C4, "|cffffff00『任务提示』：|r熔火酒不在身上，无法交给城外巡卫。", 4200)
        return
    end
    if not _____66F4_65B0_4EFB_52A1_76EE_6807(_____7194_706B_9152_63A5_53D6_73A9_5BB6ID, ____exports["熔火酒任务ID"], 1) then
        return
    end
    local _____5B88_536B = _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC(____exports["城外恶魔守卫登记ID"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____5B88_536B or _____82F1_96C4, "总算送到了。城外的夜风可比酒窖冷得多，回去替我向管事道声谢。", 4800)
    _____505C_6B62_7194_706B_9152_9001_8FBE_626B_63CF()
end
local function ____on_6076_9B54_57CE_4EFB_52A1_5355_4F4D_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D == nil or _____6B7B_4EA1_5355_4F4D == 0 then
        return
    end
    if _____9057_5931_89D2_9970_6076_9B54_72AC ~= nil and _____9057_5931_89D2_9970_6076_9B54_72AC ~= 0 and jass.GetHandleId(_____6B7B_4EA1_5355_4F4D) == jass.GetHandleId(_____9057_5931_89D2_9970_6076_9B54_72AC) then
        local _____73A9_5BB6ID = _____9057_5931_89D2_9970_63A5_53D6_73A9_5BB6ID
        _____9057_5931_89D2_9970_6076_9B54_72AC = nil
        local ____temp_13
        if _____73A9_5BB6ID >= 0 then
            ____temp_13 = getRegisteredPlayerHero(jass.Player(_____73A9_5BB6ID))
        else
            ____temp_13 = nil
        end
        local _____82F1_96C4 = ____temp_13
        if _____82F1_96C4 ~= nil and _____82F1_96C4 ~= 0 and _____66F4_65B0_4EFB_52A1_76EE_6807(_____73A9_5BB6ID, ____exports["遗失角饰任务ID"], 1) then
            _____53D1_653E_4EFB_52A1_7269_54C1(_____82F1_96C4, _____9057_5931_89D2_9970_7269_54C1ID)
            _____5E7F_64AD_5355_4F4D_63D0_793A(_____82F1_96C4, "|cffffff00『任务进度』：|r从恶魔犬的项圈下找到了遗失的仪式角饰。把它带回给年轻恶魔。", 5000)
        end
    end
    if jass.GetUnitTypeId(_____6B7B_4EA1_5355_4F4D) == stringToFourCCSafe("u004") then
        do
            local _____73A9_5BB6ID = 0
            while _____73A9_5BB6ID < 4 do
                do
                    local _____8FDB_5EA6 = _____8BFB_53D6_4EFB_52A1_8FDB_5EA6(_____73A9_5BB6ID, ____exports["迷宫缺灯任务ID"])
                    if _____8FDB_5EA6 == nil or _____8FDB_5EA6["当前"] < 3 or _____8FDB_5EA6["当前"] >= _____8FDB_5EA6["需求"] then
                        goto __continue50
                    end
                    if _____66F4_65B0_4EFB_52A1_76EE_6807(_____73A9_5BB6ID, ____exports["迷宫缺灯任务ID"], _____8FDB_5EA6["需求"]) then
                        _____5E7F_64AD_5355_4F4D_63D0_793A(_____6B7B_4EA1_5355_4F4D, "|cffffff00『调查完成』：|r双翼究极恶魔已经倒下，迷宫外围的路线重新恢复安全。回去找测绘师复命吧。", 5200)
                    end
                    break
                end
                ::__continue50::
                _____73A9_5BB6ID = _____73A9_5BB6ID + 1
            end
        end
    end
end
local function _____5355_4F4D_4ECD_7136_6709_6548(_____5355_4F4D)
    return _____5355_4F4D ~= nil and _____5355_4F4D ~= 0 and GetUnitTypeId(_____5355_4F4D) ~= 0
end
local function _____6E05_7406_5408_6CD5_51B3_6597_5355_4F4D()
    if _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D) then
        RemoveUnit(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D)
    end
    if _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D) then
        RemoveUnit(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D)
    end
    _____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D = nil
    _____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D = nil
end
local function _____505C_6B62_5408_6CD5_51B3_6597()
    if _____5408_6CD5_51B3_6597_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____5408_6CD5_51B3_6597_56DE_8C03ID)
    end
    _____5408_6CD5_51B3_6597_56DE_8C03ID = 0
    if _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D) then
        IssueImmediateOrder(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, "stop")
    end
    if _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D) then
        IssueImmediateOrder(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D, "stop")
    end
end
local function _____914D_7F6E_5408_6CD5_51B3_6597_6F14_5458(_____5355_4F4D, _____540D_79F0)
    if not _____5355_4F4D_4ECD_7136_6709_6548(_____5355_4F4D) then
        return
    end
    _____8BBE_5355_4F4D_540D_5B57(_____5355_4F4D, _____540D_79F0)
    UnitAddAbility(
        _____5355_4F4D,
        stringToFourCCSafe("Avul")
    )
    UnitRemoveAbility(
        _____5355_4F4D,
        stringToFourCCSafe("A08Q")
    )
    UnitRemoveAbility(
        _____5355_4F4D,
        stringToFourCCSafe("A08T")
    )
    UnitRemoveAbility(
        _____5355_4F4D,
        stringToFourCCSafe("A08K")
    )
    SetUnitStateJapi(_____5355_4F4D, _____6700_5927_751F_547D_72B6_6001, _____51B3_6597_7EDF_4E00_6700_5927_751F_547D)
    SetUnitStateJapi(_____5355_4F4D, _____51B3_6597_653B_51FB_529B_72B6_6001, _____51B3_6597_7EDF_4E00_653B_51FB_529B)
    SetUnitStateJapi(_____5355_4F4D, _____51B3_6597_62A4_7532_72B6_6001, _____51B3_6597_7EDF_4E00_62A4_7532)
    SetUnitStateJapi(_____5355_4F4D, _____51B3_6597_653B_51FB_95F4_9694_72B6_6001, _____51B3_6597_7EDF_4E00_653B_51FB_95F4_9694)
    SetUnitState(_____5355_4F4D, _____5F53_524D_751F_547D_72B6_6001, _____51B3_6597_7EDF_4E00_6700_5927_751F_547D)
end
____exports["创建合法决斗场景单位"] = function()
    local _____5DF2_521B_5EFA_4EF2_88C1_5458 = _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC(____exports["合法决斗任务ID"])
    if not _____5355_4F4D_4ECD_7136_6709_6548(_____5DF2_521B_5EFA_4EF2_88C1_5458) then
        _____6309_4EFB_52A1ID_521B_5EFANPC(____exports["合法决斗任务ID"])
    end
    local _____4E2D_7ACB_88AB_52A8 = Player(jass.PLAYER_NEUTRAL_PASSIVE)
    if not _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D) then
        _____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            _____4E2D_7ACB_88AB_52A8,
            stringToFourCCSafe("n03L"),
            _____51B3_6597_5317_4FA7X,
            _____51B3_6597_5317_4FA7Y,
            270
        )
        _____914D_7F6E_5408_6CD5_51B3_6597_6F14_5458(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, "熔角战士·卡鲁")
    end
    if not _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D) then
        _____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
            _____4E2D_7ACB_88AB_52A8,
            stringToFourCCSafe("o001"),
            _____51B3_6597_5357_4FA7X,
            _____51B3_6597_5357_4FA7Y,
            90
        )
        _____914D_7F6E_5408_6CD5_51B3_6597_6F14_5458(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D, "赤甲步兵·维萨")
    end
end
local function _____5B8C_6210_5408_6CD5_51B3_6597_88C1_5B9A(_____80DC_8005, _____8D25_8005)
    if _____5408_6CD5_51B3_6597_5DF2_7ED3_675F then
        return
    end
    _____5408_6CD5_51B3_6597_5DF2_7ED3_675F = true
    _____505C_6B62_5408_6CD5_51B3_6597()
    if _____5355_4F4D_4ECD_7136_6709_6548(_____80DC_8005) then
        SetUnitAnimation(_____80DC_8005, "stand victory")
    end
    if _____5355_4F4D_4ECD_7136_6709_6548(_____8D25_8005) then
        SetUnitAnimation(_____8D25_8005, "stand")
    end
    if _____5408_6CD5_51B3_6597_63A5_53D6_73A9_5BB6ID >= 0 then
        _____66F4_65B0_4EFB_52A1_76EE_6807(_____5408_6CD5_51B3_6597_63A5_53D6_73A9_5BB6ID, ____exports["合法决斗任务ID"], 1)
    end
    local _____4EF2_88C1_5458 = _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC(____exports["合法决斗任务ID"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(
        _____4EF2_88C1_5458 or _____80DC_8005,
        ("胜负已分。" .. GetUnitName(_____80DC_8005)) .. "取得了这场决斗的胜利，双方立即停手。",
        5200
    )
    addDelayedCallback(3500, _____6E05_7406_5408_6CD5_51B3_6597_5355_4F4D)
end
local function ____on_5408_6CD5_51B3_6597_56DE_5408()
    if _____5408_6CD5_51B3_6597_5DF2_7ED3_675F or not _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D) or not _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D) then
        _____505C_6B62_5408_6CD5_51B3_6597()
        return
    end
    local _____5317_4FA7_5F53_524D_751F_547D = GetUnitState(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, _____5F53_524D_751F_547D_72B6_6001)
    local _____5357_4FA7_5F53_524D_751F_547D = GetUnitState(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D, _____5F53_524D_751F_547D_72B6_6001)
    local _____5317_4FA7_7ED3_7B97_751F_547D = _____5317_4FA7_5F53_524D_751F_547D - GetRandomReal(760, 1040)
    local _____5357_4FA7_7ED3_7B97_751F_547D = _____5357_4FA7_5F53_524D_751F_547D - GetRandomReal(760, 1040)
    local _____88C1_5B9A_751F_547D = _____51B3_6597_7EDF_4E00_6700_5927_751F_547D * _____51B3_6597_88C1_5B9A_751F_547D_6BD4_4F8B
    SetUnitAnimation(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, "attack")
    SetUnitAnimation(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D, "attack")
    if _____5317_4FA7_7ED3_7B97_751F_547D <= _____88C1_5B9A_751F_547D or _____5357_4FA7_7ED3_7B97_751F_547D <= _____88C1_5B9A_751F_547D then
        SetUnitState(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, _____5F53_524D_751F_547D_72B6_6001, _____5317_4FA7_7ED3_7B97_751F_547D > _____88C1_5B9A_751F_547D and _____5317_4FA7_7ED3_7B97_751F_547D or _____88C1_5B9A_751F_547D)
        SetUnitState(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D, _____5F53_524D_751F_547D_72B6_6001, _____5357_4FA7_7ED3_7B97_751F_547D > _____88C1_5B9A_751F_547D and _____5357_4FA7_7ED3_7B97_751F_547D or _____88C1_5B9A_751F_547D)
        if _____5317_4FA7_7ED3_7B97_751F_547D > _____5357_4FA7_7ED3_7B97_751F_547D then
            _____5B8C_6210_5408_6CD5_51B3_6597_88C1_5B9A(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, _____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D)
        else
            _____5B8C_6210_5408_6CD5_51B3_6597_88C1_5B9A(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D, _____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D)
        end
        return
    end
    SetUnitState(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, _____5F53_524D_751F_547D_72B6_6001, _____5317_4FA7_7ED3_7B97_751F_547D)
    SetUnitState(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D, _____5F53_524D_751F_547D_72B6_6001, _____5357_4FA7_7ED3_7B97_751F_547D)
end
local function _____5F00_59CB_5408_6CD5_51B3_6597()
    if not _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D) or not _____5355_4F4D_4ECD_7136_6709_6548(_____5408_6CD5_51B3_6597_5357_4FA7_5355_4F4D) then
        return
    end
    local _____4EF2_88C1_5458 = _____6309_4EFB_52A1ID_67E5_627E_5DF2_521B_5EFANPC(____exports["合法决斗任务ID"])
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____4EF2_88C1_5458 or _____5408_6CD5_51B3_6597_5317_4FA7_5355_4F4D, "城契为证，点到为止。决斗开始！", 3600)
    _____5408_6CD5_51B3_6597_56DE_8C03ID = addPeriodicCallback(1000, ____on_5408_6CD5_51B3_6597_56DE_5408)
end
____exports["接受迟到的熔火酒任务"] = function(_____73A9_5BB6ID)
    _____7194_706B_9152_63A5_53D6_73A9_5BB6ID = _____73A9_5BB6ID
    _____505C_6B62_7194_706B_9152_9001_8FBE_626B_63CF()
    _____7194_706B_9152_626B_63CF_56DE_8C03ID = addPeriodicCallback(500, ____on_7194_706B_9152_9001_8FBE_626B_63CF)
end
____exports["完成迟到的熔火酒任务"] = function(______73A9_5BB6ID)
    _____505C_6B62_7194_706B_9152_9001_8FBE_626B_63CF()
    _____7194_706B_9152_63A5_53D6_73A9_5BB6ID = -1
end
____exports["接受迷宫缺灯任务"] = function(______73A9_5BB6ID)
    _____6CE8_518C_4EFB_52A1_8C03_67E5_70B9(____exports["迷宫缺灯任务ID"])
end
____exports["完成迷宫缺灯任务"] = function(______73A9_5BB6ID)
    _____6E05_7406_4EFB_52A1_8C03_67E5_70B9(____exports["迷宫缺灯任务ID"])
end
____exports["接受遗失角饰任务"] = function(_____73A9_5BB6ID)
    _____9057_5931_89D2_9970_63A5_53D6_73A9_5BB6ID = _____73A9_5BB6ID
    if _____9057_5931_89D2_9970_6076_9B54_72AC ~= nil and _____9057_5931_89D2_9970_6076_9B54_72AC ~= 0 and jass.GetUnitTypeId(_____9057_5931_89D2_9970_6076_9B54_72AC) ~= 0 then
        jass.RemoveUnit(_____9057_5931_89D2_9970_6076_9B54_72AC)
    end
    _____9057_5931_89D2_9970_6076_9B54_72AC = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        jass.Player(12),
        stringToFourCCSafe("n037"),
        22448.7,
        -19816.9,
        180
    )
    local _____82F1_96C4 = getRegisteredPlayerHero(jass.Player(_____73A9_5BB6ID))
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____82F1_96C4, "|cffffff00『任务提示』：|r恶魔犬最后出现的位置在城外熔痕地带。仪式角饰应该还挂在它身上。", 5000)
end
____exports["完成遗失角饰任务"] = function(______73A9_5BB6ID)
    if _____9057_5931_89D2_9970_6076_9B54_72AC ~= nil and _____9057_5931_89D2_9970_6076_9B54_72AC ~= 0 and jass.GetUnitTypeId(_____9057_5931_89D2_9970_6076_9B54_72AC) ~= 0 then
        jass.RemoveUnit(_____9057_5931_89D2_9970_6076_9B54_72AC)
    end
    _____9057_5931_89D2_9970_6076_9B54_72AC = nil
    _____9057_5931_89D2_9970_63A5_53D6_73A9_5BB6ID = -1
end
____exports["接受墓门旧誓任务"] = function(______73A9_5BB6ID)
    _____6CE8_518C_4EFB_52A1_8C03_67E5_70B9(____exports["墓门旧誓任务ID"])
end
____exports["完成墓门旧誓任务"] = function(______73A9_5BB6ID)
    _____6E05_7406_4EFB_52A1_8C03_67E5_70B9(____exports["墓门旧誓任务ID"])
end
____exports["接受熔核余温任务"] = function(______73A9_5BB6ID)
    _____6CE8_518C_4EFB_52A1_8C03_67E5_70B9(____exports["熔核余温任务ID"])
end
____exports["完成熔核余温任务"] = function(______73A9_5BB6ID)
    _____6E05_7406_4EFB_52A1_8C03_67E5_70B9(____exports["熔核余温任务ID"])
end
____exports["接受合法决斗任务"] = function(_____73A9_5BB6ID)
    _____505C_6B62_5408_6CD5_51B3_6597()
    _____5408_6CD5_51B3_6597_63A5_53D6_73A9_5BB6ID = _____73A9_5BB6ID
    _____5408_6CD5_51B3_6597_5DF2_7ED3_675F = false
    ____exports["创建合法决斗场景单位"]()
    addDelayedCallback(1200, _____5F00_59CB_5408_6CD5_51B3_6597)
end
____exports["完成合法决斗任务"] = function(______73A9_5BB6ID)
    _____505C_6B62_5408_6CD5_51B3_6597()
    _____6E05_7406_5408_6CD5_51B3_6597_5355_4F4D()
    _____5408_6CD5_51B3_6597_63A5_53D6_73A9_5BB6ID = -1
    _____5408_6CD5_51B3_6597_5DF2_7ED3_675F = false
end
registerDeathListener(____on_6076_9B54_57CE_4EFB_52A1_5355_4F4D_6B7B_4EA1)
return ____exports
