local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.00．公共")
local _____585E_62C9_516C_5171 = ____00_FF0E_516C_5171["塞拉公共"]
local ____585E_62C9_516C_5171_0 = _____585E_62C9_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____585E_62C9_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_585E_62C9_53F0_8BCD = ____585E_62C9_516C_5171_0["播放塞拉台词"]
local _____51CF_5C11_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570 = ____585E_62C9_516C_5171_0["减少巴尔扎罗斯灼热层数"]
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____585E_62C9_516C_5171_0["启动基础施法时间线"]
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____585E_62C9_516C_5171_0["创建技能提示圈"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____585E_62C9_516C_5171_0["获取Boss技能敌对英雄列表"]
local _____521B_5EFA_5FAA_73AF_70B9_7279_6548 = ____585E_62C9_516C_5171_0["创建循环点特效"]
local _____505C_6B62_5FAA_73AF_70B9_7279_6548 = ____585E_62C9_516C_5171_0["停止循环点特效"]
local addPeriodicCallback = ____585E_62C9_516C_5171_0.addPeriodicCallback
local removePeriodicCallback = ____585E_62C9_516C_5171_0.removePeriodicCallback
local getServerTime = ____585E_62C9_516C_5171_0.getServerTime
local GetUnitX = ____585E_62C9_516C_5171_0.GetUnitX
local GetUnitY = ____585E_62C9_516C_5171_0.GetUnitY
local _____5355_4F4D_6709_6548 = ____585E_62C9_516C_5171_0["单位有效"]
local _____53D6_5355_4F4DID = ____585E_62C9_516C_5171_0["取单位ID"]
local _____70B9_5728_5706_5185 = ____585E_62C9_516C_5171_0["点在圆内"]
local _____8BA1_7B97_51B0_7130_76EE_6807_4F4D_7F6E = ____585E_62C9_516C_5171_0["计算冰焰目标位置"]
local _____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868 = ____585E_62C9_516C_5171_0["零度领域减伤到期Ms表"]
local _____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868 = ____585E_62C9_516C_5171_0["绝对零度领域状态表"]
local function _____521B_5EFA_7EDD_5BF9_96F6_5EA6_9886_57DF(context, x, y)
    local sera = context["塞拉"]
    if not _____5355_4F4D_6709_6548(sera) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["绝对零度领域"]
    local seraId = _____53D6_5355_4F4DID(sera)
    local endMs = getServerTime() + config["持续秒"] * 1000
    _____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868[seraId] = {X = x, Y = y, ["结束Ms"] = endMs}
    local effectHandle = _____521B_5EFA_5FAA_73AF_70B9_7279_6548({
        ["模型路径"] = config["特效路径"],
        X = x,
        Y = y,
        Z = config["特效高度"],
        ["缩放"] = config["特效缩放"],
        ["重建间隔秒"] = config["特效重建间隔秒"],
        ["总持续秒"] = config["持续秒"],
        ["存活条件"] = function()
            return _____5355_4F4D_6709_6548(sera)
        end
    })
    local ____self_1 = context["清理"]
    ____self_1["登记清理"](
        ____self_1,
        "塞拉-绝对零度领域特效",
        function()
            _____505C_6B62_5FAA_73AF_70B9_7279_6548(effectHandle)
        end
    )
    local nextClear = {}
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            local hero = heroes[i + 1]
            if _____5355_4F4D_6709_6548(hero) and _____70B9_5728_5706_5185(
                GetUnitX(hero),
                GetUnitY(hero),
                x,
                y,
                config["半径"]
            ) then
                _____51CF_5C11_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570(hero, config["生成清除灼热层数"])
            end
            i = i + 1
        end
    end
    local tickId
    tickId = addPeriodicCallback(
        config["Tick毫秒"],
        function()
            local now = getServerTime()
            if now >= endMs or not _____5355_4F4D_6709_6548(sera) then
                removePeriodicCallback(tickId)
                __TS__Delete(_____7EDD_5BF9_96F6_5EA6_9886_57DF_72B6_6001_8868, seraId)
                return
            end
            local list = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
            do
                local i = 0
                while i < #list do
                    do
                        local hero = list[i + 1]
                        if not _____5355_4F4D_6709_6548(hero) then
                            goto __continue12
                        end
                        if not _____70B9_5728_5706_5185(
                            GetUnitX(hero),
                            GetUnitY(hero),
                            x,
                            y,
                            config["半径"]
                        ) then
                            goto __continue12
                        end
                        local heroId = _____53D6_5355_4F4DID(hero)
                        _____96F6_5EA6_9886_57DF_51CF_4F24_5230_671FMs_8868[heroId] = now + config["离开后减伤持续秒"] * 1000
                        if now >= (nextClear[heroId] or 0) then
                            _____51CF_5C11_5DF4_5C14_624E_7F57_65AF_707C_70ED_5C42_6570(hero, config["周期清除灼热层数"])
                            nextClear[heroId] = now + config["清层周期秒"] * 1000
                        end
                    end
                    ::__continue12::
                    i = i + 1
                end
            end
        end
    )
    local ____self_2 = context["清理"]
    ____self_2["登记周期回调"](____self_2, "塞拉-绝对零度领域Tick", tickId)
end
____exports["释放绝对零度领域"] = function(context, target)
    local sera = context["塞拉"]
    if not _____5355_4F4D_6709_6548(sera) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["绝对零度领域"]
    local center = _____8BA1_7B97_51B0_7130_76EE_6807_4F4D_7F6E(context, target)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "白色安全圆",
        X = center.X,
        Y = center.Y,
        ["半径"] = config["半径"],
        ["持续时间"] = config["施法硬直秒"]
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = sera,
        ["目标X"] = center.X,
        ["目标Y"] = center.Y,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["恢复动画编号"] = config["恢复动画编号"],
        ["吟唱条"] = {
            ["通道"] = "场地常驻AOE",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_585E_62C9_53F0_8BCD(sera, "绝对零度领域")
        end,
        ["on生效"] = function()
            _____521B_5EFA_7EDD_5BF9_96F6_5EA6_9886_57DF(context, center.X, center.Y)
        end
    })
end
return ____exports
