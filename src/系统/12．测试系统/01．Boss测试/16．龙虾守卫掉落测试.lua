--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_0["是允许测试玩家"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_76D1_542C = ____require_result_1["注册聊天命令监听"]
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_4.debugLogForce
local ____require_result_5 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.02．Boss死亡结算.03．核心逻辑")
local _____83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E = ____require_result_5["获取Boss死亡结算配置"]
local CreateUnit = jass.CreateUnit
local GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local Player = jass.Player
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____6A21_5757_540D = "龙虾守卫掉落测试"
local _____6D4B_8BD5_547D_4EE4 = "龙虾"
local _____9F99_867E_5B88_536B_539F_59CBID = "n02U"
local _____9F99_867E_5B88_536B_5355_4F4DID = stringToFourCCSafe(_____9F99_867E_5B88_536B_539F_59CBID)
local _____6D4B_8BD5_5750_6807X = -540.6
local _____6D4B_8BD5_5750_6807Y = -2495.2
local _____6D4B_8BD5_9762_5411 = 270
local _____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B = nil
local function _____6D4B_8BD5_9F99_867E_5B88_536B_5B58_6D3B()
    return _____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B ~= nil and _____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B ~= 0 and GetUnitState(_____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B, UNIT_STATE_LIFE) > 0.405
end
local function _____8BFB_53D6_76F4_63A5_6389_843D_7269_54C1_6587_672C(_____914D_7F6E)
    if _____914D_7F6E == nil or _____914D_7F6E["直接掉落物品名列表"] == nil then
        return "nil"
    end
    return _____914D_7F6E["直接掉落物品名列表"]:join("、")
end
local function ____on_9F99_867E_5B88_536B_6389_843D_6D4B_8BD5_547D_4EE4(player, _command)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(player) then
        return
    end
    if _____9F99_867E_5B88_536B_5355_4F4DID <= 0 then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[龙虾守卫掉落测试] n02U 内部 ID 无效。 "
        )
        debugLogForce(_____6A21_5757_540D, "单位内部ID无效", "rawId", _____9F99_867E_5B88_536B_539F_59CBID)
        return
    end
    if _____6D4B_8BD5_9F99_867E_5B88_536B_5B58_6D3B() then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[龙虾守卫掉落测试] 测试龙虾守卫仍存活，请先击杀。 "
        )
        debugLogForce(
            _____6A21_5757_540D,
            "复用现有测试单位",
            "handle",
            GetHandleId(_____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B),
            "unitTypeId",
            GetUnitTypeId(_____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B)
        )
        return
    end
    _____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B = CreateUnit(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        _____9F99_867E_5B88_536B_5355_4F4DID,
        _____6D4B_8BD5_5750_6807X,
        _____6D4B_8BD5_5750_6807Y,
        _____6D4B_8BD5_9762_5411
    )
    if _____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B == nil or _____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B == 0 then
        DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "[龙虾守卫掉落测试] 创建 n02U 失败。 "
        )
        debugLogForce(
            _____6A21_5757_540D,
            "创建测试单位失败",
            "rawId",
            _____9F99_867E_5B88_536B_539F_59CBID,
            "unitTypeId",
            _____9F99_867E_5B88_536B_5355_4F4DID
        )
        return
    end
    DisplayTimedTextToPlayer(
        player,
        0,
        0,
        8,
        "[龙虾守卫掉落测试] 已在测试空地创建 n02U；击杀后检查掉落和日志。 "
    )
    debugLogForce(
        _____6A21_5757_540D,
        "创建测试单位",
        "handle",
        GetHandleId(_____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B),
        "rawId",
        _____9F99_867E_5B88_536B_539F_59CBID,
        "unitTypeId",
        GetUnitTypeId(_____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B),
        "x",
        _____6D4B_8BD5_5750_6807X,
        "y",
        _____6D4B_8BD5_5750_6807Y
    )
end
local function ____on_9F99_867E_5B88_536B_6D4B_8BD5_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit ~= _____5F53_524D_6D4B_8BD5_9F99_867E_5B88_536B then
        return
    end
    local _____914D_7F6E = _____83B7_53D6Boss_6B7B_4EA1_7ED3_7B97_914D_7F6E(dyingUnit)
    local ____debugLogForce_9 = debugLogForce
    local ____GetHandleId_result_7 = GetHandleId(dyingUnit)
    local ____GetUnitTypeId_result_8 = GetUnitTypeId(dyingUnit)
    local ____temp_6
    if _____914D_7F6E ~= nil then
        ____temp_6 = _____914D_7F6E["键"]
    else
        ____temp_6 = "nil"
    end
    ____debugLogForce_9(
        _____6A21_5757_540D,
        "测试单位死亡",
        "handle",
        ____GetHandleId_result_7,
        "unitTypeId",
        ____GetUnitTypeId_result_8,
        "结算键",
        ____temp_6,
        "直接掉落",
        _____8BFB_53D6_76F4_63A5_6389_843D_7269_54C1_6587_672C(_____914D_7F6E)
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_76D1_542C(_____6D4B_8BD5_547D_4EE4, ____on_9F99_867E_5B88_536B_6389_843D_6D4B_8BD5_547D_4EE4)
registerDeathListener(____on_9F99_867E_5B88_536B_6D4B_8BD5_6B7B_4EA1)
return ____exports
