local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.00．配置")
local _____8299_8389_83B2_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲技能配置"]
local _____8299_8389_83B2D_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲D配置"]
local _____8299_8389_83B2_8868_73B0_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲表现配置"]
local _____8299_8389_83B2_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["芙莉莲音效配置"]
local ____require_result_0 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_CooPlayReuse = ____require_result_0.Sound3DII_CooPlayReuse
local ____require_result_1 = require("系统.09．表现系统.10．英雄语音.10．技能喊话.01．英雄技能喊话")
local _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD = ____require_result_1["播放英雄技能喊话"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.01A．动作表现")
local _____64AD_653E_9650_65F6_52A8_4F5C = ____require_result_2["播放限时动作"]
local _____8299_8389_83B2_52A8_4F5C_69FD = ____require_result_2["芙莉莲动作槽"]
local jass = require("jass.common")
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_4.getGameTime
local addDelayedCallback = ____require_result_4.addDelayedCallback
local removeDelayedCallback = ____require_result_4.removeDelayedCallback
local addPeriodicCallback = ____require_result_4.addPeriodicCallback
local removePeriodicCallback = ____require_result_4.removePeriodicCallback
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_5["注册单位技能壳监听"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.27．战斗技能实例生命周期工厂")
local _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_6["创建战斗技能实例"]
local _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B = ____require_result_6["查询战斗技能实例"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.04．区域效果.区域效果")
local _____521B_5EFA_533A_57DF_6548_679C = ____require_result_7["创建区域效果"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_8.createUnitEffect
local destroyUnitEffect = ____require_result_8.destroyUnitEffect
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("lib.扩展函数.KK扩展API.00．装饰物函数")
local DzDoodadCreate = ____require_result_9.DzDoodadCreate
local DzDoodadSetModel = ____require_result_9.DzDoodadSetModel
local DzDoodadRemove = ____require_result_9.DzDoodadRemove
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_10["单位存活"]
local ____require_result_11 = require("系统.03．技能系统.05．单位技能.04．英雄技能.25．芙莉莲.02．被动效果")
local _____662F_8299_8389_83B2 = ____require_result_11["是芙莉莲"]
local _____8BB0_5F55_8299_8389_83B2_6D3B_52A8 = ____require_result_11["记录芙莉莲活动"]
local _____767B_8BB0_8299_8389_83B2_6E05_7406 = ____require_result_11["登记芙莉莲清理"]
local _____82B1_7530_5224_5B9A_63A5_53E3 = ____require_result_11["花田判定接口"]
local _____91CD_65B0_5B89_6392_9690_533F_8BA1_65F6 = ____require_result_11["重新安排隐匿计时"]
local ____require_result_12 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_12.debugLogForce
local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E["单位类型ID"])
local ____D_6280_80FDID = stringToFourCCSafe(_____8299_8389_83B2_6280_80FD_914D_7F6E.D["技能ID"])
local ____D_914D_7F6E = _____8299_8389_83B2D_914D_7F6E
local _____82B1_6D77_88C5_9970_7269ID = stringToFourCCSafe("D0B5")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local function _____8DDD_79BB_5E73_65B9(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return dx * dx + dy * dy
end
local _____82B1_7530_8868 = {}
local function _____8DDD_79BB_5E73_65B9_5355_4F4D(a, b)
    return _____8DDD_79BB_5E73_65B9(
        GetUnitX(a),
        GetUnitY(a),
        GetUnitX(b),
        GetUnitY(b)
    )
end
_____82B1_7530_5224_5B9A_63A5_53E3["在花田内"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____82B1_7530 = _____82B1_7530_8868[GetHandleId(_____82F1_96C4)]
    return _____82B1_7530 ~= nil and not _____82B1_7530["已结束"] and _____8DDD_79BB_5E73_65B9(
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4),
        _____82B1_7530["中心X"],
        _____82B1_7530["中心Y"]
    ) <= _____82B1_7530["半径"] * _____82B1_7530["半径"]
end
_____82B1_7530_5224_5B9A_63A5_53E3["在花田内静止"] = function(_____82F1_96C4)
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 then
        return false
    end
    local _____82B1_7530 = _____82B1_7530_8868[GetHandleId(_____82F1_96C4)]
    return _____82B1_7530 ~= nil and not _____82B1_7530["已结束"] and _____82B1_7530["静止标记"] and _____8DDD_79BB_5E73_65B9(
        GetUnitX(_____82F1_96C4),
        GetUnitY(_____82F1_96C4),
        _____82B1_7530["中心X"],
        _____82B1_7530["中心Y"]
    ) <= _____82B1_7530["半径"] * _____82B1_7530["半径"]
end
--- 芙莉莲是否在花田内（R/E 模块运行时读取；与 花田判定接口 同源）
____exports["在花田内"] = function(_____8299_8389_83B2)
    return _____82B1_7530_5224_5B9A_63A5_53E3["在花田内"](_____8299_8389_83B2)
end
--- 花田内静止检测：采样间隔、移动阈值和连续次数均由 D 配置驱动。
local function _____542F_52A8_9759_6B62_68C0_6D4B(_____82B1_7530)
    _____82B1_7530["静止检测ID"] = addPeriodicCallback(
        ____D_914D_7F6E["静止检测间隔毫秒"],
        function()
            if _____82B1_7530["已结束"] then
                return
            end
            local _____82F1_96C4 = _____82B1_7530["芙莉莲"]
            if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or not _____5355_4F4D_5B58_6D3B(_____82F1_96C4) then
                return
            end
            local _____5728_5185 = _____8DDD_79BB_5E73_65B9(
                GetUnitX(_____82F1_96C4),
                GetUnitY(_____82F1_96C4),
                _____82B1_7530["中心X"],
                _____82B1_7530["中心Y"]
            ) <= _____82B1_7530["半径"] * _____82B1_7530["半径"]
            if not _____5728_5185 then
                _____82B1_7530["静止采样计数"] = 0
                _____82B1_7530["静止标记"] = false
                return
            end
            local _____79FB_52A8_5E73_65B9 = _____8DDD_79BB_5E73_65B9(
                GetUnitX(_____82F1_96C4),
                GetUnitY(_____82F1_96C4),
                _____82B1_7530["静止上次X"],
                _____82B1_7530["静止上次Y"]
            )
            local _____539F_9759_6B62 = _____82B1_7530["静止标记"]
            if _____79FB_52A8_5E73_65B9 <= ____D_914D_7F6E["静止移动阈值"] * ____D_914D_7F6E["静止移动阈值"] then
                _____82B1_7530["静止采样计数"] = _____82B1_7530["静止采样计数"] + 1
                if _____82B1_7530["静止采样计数"] >= ____D_914D_7F6E["静止连续采样次数"] then
                    _____82B1_7530["静止标记"] = true
                end
            else
                _____82B1_7530["静止采样计数"] = 0
                _____82B1_7530["静止标记"] = false
            end
            _____82B1_7530["静止上次X"] = GetUnitX(_____82F1_96C4)
            _____82B1_7530["静止上次Y"] = GetUnitY(_____82F1_96C4)
            if _____82B1_7530["静止标记"] ~= _____539F_9759_6B62 then
                _____91CD_65B0_5B89_6392_9690_533F_8BA1_65F6(_____82F1_96C4)
            end
        end
    )
end
--- Q/W/E 花田修正：花田存在 + 芙莉莲在花田内 + 修正未消费 → 消费返回 true
____exports["尝试消费花田修正"] = function(_____8299_8389_83B2)
    if _____8299_8389_83B2 == nil or _____8299_8389_83B2 == 0 then
        return false
    end
    local _____82B1_7530 = _____82B1_7530_8868[GetHandleId(_____8299_8389_83B2)]
    if _____82B1_7530 == nil or _____82B1_7530["已结束"] or _____82B1_7530["修正已消费"] then
        return false
    end
    if not _____82B1_7530_5224_5B9A_63A5_53E3["在花田内"](_____8299_8389_83B2) then
        return false
    end
    _____82B1_7530["修正已消费"] = true
    return true
end
--- R 花田盛开：花田存在 + R 在花田内释放 + 盛开未消费 → 消费返回 true（只强化一次表现，不追加伤害）
____exports["尝试消费花田盛开"] = function(_____8299_8389_83B2)
    if _____8299_8389_83B2 == nil or _____8299_8389_83B2 == 0 then
        return false
    end
    local _____82B1_7530 = _____82B1_7530_8868[GetHandleId(_____8299_8389_83B2)]
    if _____82B1_7530 == nil or _____82B1_7530["已结束"] or _____82B1_7530["盛开已消费"] then
        return false
    end
    if not _____82B1_7530_5224_5B9A_63A5_53E3["在花田内"](_____8299_8389_83B2) then
        return false
    end
    _____82B1_7530["盛开已消费"] = true
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["模型路径"],
        X = _____82B1_7530["中心X"],
        Y = _____82B1_7530["中心Y"],
        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["D盛开"]["高度"],
        ["面向角度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D盛开"]["面向角度"],
        ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D盛开"]["动画索引"],
        ["缩放"] = _____82B1_7530["半径"] / _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["基准半径"] * _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["基准缩放"] * _____8299_8389_83B2_8868_73B0_914D_7F6E["D盛开"]["缩放倍率"],
        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D盛开"]["持续秒"],
        RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["D盛开"].RGB
    })
    return true
end
local function _____9500_6BC1_82B1_7530(_____82B1_7530, _____81EA_7136_7ED3_675F)
    if _____82B1_7530["已结束"] then
        return
    end
    debugLogForce(
        "芙莉莲-D",
        "结束",
        "原因",
        _____81EA_7136_7ED3_675F and "自然消散" or "打断/死亡/替换",
        "英雄",
        _____82B1_7530["芙莉莲"]
    )
    _____82B1_7530["已结束"] = true
    if _____82B1_7530["到期回调ID"] ~= 0 then
        removeDelayedCallback(_____82B1_7530["到期回调ID"])
    end
    if _____82B1_7530["静止检测ID"] ~= 0 then
        removePeriodicCallback(_____82B1_7530["静止检测ID"])
    end
    if _____82B1_7530["区域"] ~= nil then
        local ____self_13 = _____82B1_7530["区域"]
        ____self_13["销毁"](____self_13)
        _____82B1_7530["区域"] = nil
    end
    if _____82B1_7530["视野句柄"] ~= nil and _____82B1_7530["视野句柄"] ~= 0 then
        jass.DestroyFogModifier(_____82B1_7530["视野句柄"])
        _____82B1_7530["视野句柄"] = nil
    end
    if _____82B1_7530["花瓣句柄"] ~= nil and _____82B1_7530["花瓣句柄"] ~= 0 then
        if _____81EA_7136_7ED3_675F then
            local _____53E5_67C4 = _____82B1_7530["花瓣句柄"]
            _____82B1_7530["花瓣句柄"] = nil
            addDelayedCallback(
                ____D_914D_7F6E["自然淡出延迟毫秒"],
                function()
                    jass.DestroyEffect(_____53E5_67C4)
                end
            )
        else
            jass.DestroyEffect(_____82B1_7530["花瓣句柄"])
            _____82B1_7530["花瓣句柄"] = nil
        end
    end
    do
        local i = 0
        while i < #_____82B1_7530["花簇句柄列表"] do
            local _____82B1_7C07 = _____82B1_7530["花簇句柄列表"][i + 1]
            if _____82B1_7C07 ~= nil and _____82B1_7C07 ~= 0 then
                DzDoodadRemove(_____82B1_7C07)
            end
            i = i + 1
        end
    end
    _____82B1_7530["花簇句柄列表"] = {}
    __TS__Delete(
        _____82B1_7530_8868,
        GetHandleId(_____82B1_7530["芙莉莲"])
    )
end
--- 在花田半径内按交错网格创建有限花簇，避免规则方格的拼接感和无限实例。
local function _____521B_5EFA_82B1_6D77(_____82B1_7530)
    local _____914D_7F6E = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花海"]
    local _____6709_6548_534A_5F84 = math.max(0, _____82B1_7530["半径"] - _____914D_7F6E["边缘内缩"])
    local _____6709_6548_534A_5F84_5E73_65B9 = _____6709_6548_534A_5F84 * _____6709_6548_534A_5F84
    local _____6570_91CF = 0
    do
        local _____884C = -_____914D_7F6E["网格半径"]
        while _____884C <= _____914D_7F6E["网格半径"] do
            local _____884C_504F_79FB = math.abs(_____884C) % _____914D_7F6E["交错行周期"] == _____914D_7F6E["交错行余数"] and _____914D_7F6E["间距X"] * _____914D_7F6E["交错行偏移比例"] or 0
            do
                local _____5217 = -_____914D_7F6E["网格半径"]
                while _____5217 <= _____914D_7F6E["网格半径"] do
                    do
                        if _____6570_91CF >= _____914D_7F6E["最大实例数"] then
                            return
                        end
                        local x = _____82B1_7530["中心X"] + _____5217 * _____914D_7F6E["间距X"] + _____884C_504F_79FB
                        local y = _____82B1_7530["中心Y"] + _____884C * _____914D_7F6E["间距Y"]
                        if _____8DDD_79BB_5E73_65B9(x, y, _____82B1_7530["中心X"], _____82B1_7530["中心Y"]) > _____6709_6548_534A_5F84_5E73_65B9 then
                            goto __continue43
                        end
                        local _____56FE_6848_7D22_5F15 = math.abs(_____884C * _____914D_7F6E["图案行步进"] + _____5217 * _____914D_7F6E["图案列步进"]) % _____914D_7F6E["图案数量"]
                        local _____7F29_653E_500D_7387 = _____914D_7F6E["基准缩放"] * (1 + (_____56FE_6848_7D22_5F15 - 1) * _____914D_7F6E["缩放扰动"])
                        local _____7F51_683C_5E8F_53F7 = (_____884C + _____914D_7F6E["网格半径"]) * (_____914D_7F6E["网格半径"] * 2 + 1) + _____5217 + _____914D_7F6E["网格半径"]
                        local _____671D_5411 = _____7F51_683C_5E8F_53F7 * _____914D_7F6E["旋转步进"] % _____914D_7F6E["旋转角度周期"]
                        local _____82B1_7C07 = DzDoodadCreate(
                            _____82B1_6D77_88C5_9970_7269ID,
                            _____914D_7F6E["装饰物变体ID"],
                            x,
                            y,
                            _____914D_7F6E["高度"],
                            _____671D_5411,
                            _____7F29_653E_500D_7387
                        )
                        if _____82B1_7C07 ~= nil and _____82B1_7C07 ~= 0 then
                            DzDoodadSetModel(_____82B1_7C07, _____914D_7F6E["模型路径"])
                            local ____82B1_7530__82B1_7C07_53E5_67C4_5217_8868_14 = _____82B1_7530["花簇句柄列表"]
                            ____82B1_7530__82B1_7C07_53E5_67C4_5217_8868_14[#____82B1_7530__82B1_7C07_53E5_67C4_5217_8868_14 + 1] = _____82B1_7C07
                            _____6570_91CF = _____6570_91CF + 1
                        end
                    end
                    ::__continue43::
                    _____5217 = _____5217 + 1
                end
            end
            _____884C = _____884C + 1
        end
    end
end
local function _____91CA_653ED(_context, _____65BD_6CD5_8005, _____6280_80FD_5B9E_4F8BID)
    debugLogForce("芙莉莲-D", "释放", "技能实例ID", _____6280_80FD_5B9E_4F8BID or "-")
    if not _____662F_8299_8389_83B2(_____65BD_6CD5_8005) then
        return
    end
    _____8BB0_5F55_8299_8389_83B2_6D3B_52A8(_____65BD_6CD5_8005)
    _____64AD_653E_9650_65F6_52A8_4F5C(_____65BD_6CD5_8005, _____8299_8389_83B2_52A8_4F5C_69FD["D花田"], "芙莉莲D动作")
    local _____76EE_6807X = GetSpellTargetX()
    local _____76EE_6807Y = GetSpellTargetY()
    local id = GetHandleId(_____65BD_6CD5_8005)
    local _____65E7_82B1_7530 = _____82B1_7530_8868[id]
    if _____65E7_82B1_7530 ~= nil then
        _____9500_6BC1_82B1_7530(_____65E7_82B1_7530, false)
        local _____65E7_5B9E_4F8B_5217_8868 = _____67E5_8BE2_6218_6597_6280_80FD_5B9E_4F8B(_____65BD_6CD5_8005, "芙莉莲D")
        do
            local i = 0
            while i < #_____65E7_5B9E_4F8B_5217_8868 do
                local ____self_15 = _____65E7_5B9E_4F8B_5217_8868[i + 1]
                ____self_15["完成"](____self_15)
                i = i + 1
            end
        end
    end
    local _____82B1_7530 = {
        ["芙莉莲"] = _____65BD_6CD5_8005,
        ["中心X"] = _____76EE_6807X,
        ["中心Y"] = _____76EE_6807Y,
        ["半径"] = ____D_914D_7F6E["半径"],
        ["区域"] = nil,
        ["花瓣句柄"] = nil,
        ["花簇句柄列表"] = {},
        ["视野句柄"] = nil,
        ["修正已消费"] = false,
        ["盛开已消费"] = false,
        ["静止上次X"] = GetUnitX(_____65BD_6CD5_8005),
        ["静止上次Y"] = GetUnitY(_____65BD_6CD5_8005),
        ["静止采样计数"] = 0,
        ["静止标记"] = false,
        ["到期回调ID"] = 0,
        ["静止检测ID"] = 0,
        ["已结束"] = false
    }
    _____82B1_7530_8868[id] = _____82B1_7530
    debugLogForce(
        "芙莉莲-D",
        "状态",
        "花田建立",
        "英雄",
        _____65BD_6CD5_8005
    )
    local _____63A7_5236_5668 = _____521B_5EFA_6218_6597_6280_80FD_5B9E_4F8B({
        ["技能键"] = "芙莉莲D",
        ["施法者"] = _____65BD_6CD5_8005,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["数据"] = _____82B1_7530,
        ["结束回调"] = function(______539F_56E0, _c)
            _____9500_6BC1_82B1_7530(_____82B1_7530, false)
        end
    })
    _____82B1_7530["区域"] = _____521B_5EFA_533A_57DF_6548_679C({
        X = _____76EE_6807X,
        Y = _____76EE_6807Y,
        ["半径"] = ____D_914D_7F6E["半径"],
        ["持续时间"] = ____D_914D_7F6E["持续秒"],
        ["影响目标"] = "友方",
        ["所有者"] = _____65BD_6CD5_8005,
        ["on销毁"] = function()
            if not _____82B1_7530["已结束"] then
                _____9500_6BC1_82B1_7530(_____82B1_7530, true)
                _____63A7_5236_5668["完成"](_____63A7_5236_5668)
            end
        end
    })
    _____82B1_7530["视野句柄"] = jass.CreateFogModifierRadius(
        GetOwningPlayer(_____65BD_6CD5_8005),
        jass.FOG_OF_WAR_VISIBLE,
        _____76EE_6807X,
        _____76EE_6807Y,
        ____D_914D_7F6E["半径"],
        true,
        false
    )
    if _____82B1_7530["视野句柄"] ~= nil and _____82B1_7530["视野句柄"] ~= 0 then
        jass.EnableFogModifier(_____82B1_7530["视野句柄"])
    end
    _____82B1_7530["花瓣句柄"] = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["模型路径"],
        X = _____76EE_6807X,
        Y = _____76EE_6807Y,
        Z = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["高度"],
        ["面向角度"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["面向角度"],
        ["动画索引"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["动画索引"],
        ["缩放"] = ____D_914D_7F6E["半径"] / _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["基准半径"] * _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["基准缩放"],
        ["持续秒"] = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"]["持续秒"],
        RGB = _____8299_8389_83B2_8868_73B0_914D_7F6E["D花瓣"].RGB
    })
    _____521B_5EFA_82B1_6D77(_____82B1_7530)
    Sound3DII_CooPlayReuse(
        _____8299_8389_83B2_97F3_6548_914D_7F6E["D花田"]["路径"],
        _____76EE_6807X,
        _____76EE_6807Y,
        _____8299_8389_83B2_97F3_6548_914D_7F6E["D花田"]["高度"],
        _____8299_8389_83B2_97F3_6548_914D_7F6E["D花田"]["裁断距离"]
    )
    _____64AD_653E_82F1_96C4_6280_80FD_558A_8BDD(_____65BD_6CD5_8005, "芙莉莲", _____8299_8389_83B2_6280_80FD_914D_7F6E.D["技能ID"])
    _____542F_52A8_9759_6B62_68C0_6D4B(_____82B1_7530)
    _____82B1_7530["到期回调ID"] = addDelayedCallback(
        ____D_914D_7F6E["持续秒"] * 1000 + ____D_914D_7F6E["到期兜底延迟毫秒"],
        function()
            if _____82B1_7530["已结束"] then
                return
            end
            _____9500_6BC1_82B1_7530(_____82B1_7530, true)
            _____63A7_5236_5668["完成"](_____63A7_5236_5668)
        end
    )
    _____63A7_5236_5668["登记延迟回调"](_____63A7_5236_5668, _____82B1_7530["到期回调ID"])
end
local _____5DF2_6CE8_518C = false
____exports["注册芙莉莲D"] = function()
    debugLogForce("芙莉莲-D", "注册", "名称", "注册芙莉莲D")
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "芙莉莲-创造花田的魔法（D）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8299_8389_83B2_6280_80FD_914D_7F6E.D["技能ID"],
        ["获取或创建上下文"] = function(unit)
            return {["英雄"] = unit}
        end,
        ["释放技能"] = _____91CA_653ED,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____D_914D_7F6E["持续秒"] + ____D_914D_7F6E["实例收尾缓冲秒"]
    })
end
return ____exports
