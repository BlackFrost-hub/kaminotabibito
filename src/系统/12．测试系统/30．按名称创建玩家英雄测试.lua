local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
---
-- @noSelfInFile
local globals = require("jass.globals")
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.12．聊天命令事件中心")
local _____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C = ____require_result_0["注册聊天命令前缀监听"]
local ____require_result_1 = require("系统.12．测试系统.00．测试系统辅助函数")
local _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6 = ____require_result_1["是允许测试玩家"]
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_2["按名字反查玩家英雄单位ID"]
local ____require_result_3 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local directRegisterPlayerHero = ____require_result_3.directRegisterPlayerHero
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_4.stringToFourCCSafe
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local _____83B7_53D6_5355_4F4DX = jass.GetUnitX
local _____83B7_53D6_5355_4F4DY = jass.GetUnitY
local _____83B7_53D6_5355_4F4D_9762_5411 = jass.GetUnitFacing
local _____521B_5EFA_5355_4F4D = jass.CreateUnit
local _____5224_65AD_5355_4F4D_7C7B_578B = jass.IsUnitType
local _____5355_4F4D_7C7B_578B_82F1_96C4 = jass.UNIT_TYPE_HERO
local _____5355_4F4D_7C7B_578B_6B7B_4EA1 = jass.UNIT_TYPE_DEAD
local _____6A21_5757_540D = "按名称创建玩家英雄测试"
local _____547D_4EE4_524D_7F00 = "-"
local _____4E8C_5341_81F3_4E8C_5341_4E94_82F1_96C4_5355_4F4DID_8868 = {
    E0L0 = true,
    E0L1 = true,
    E0L2 = true,
    E0L3 = true,
    E0L4 = true,
    E0L5 = true
}
local function ____on_6309_540D_79F0_521B_5EFA_73A9_5BB6_82F1_96C4(_____73A9_5BB6, _____547D_4EE4)
    if not _____662F_5141_8BB8_6D4B_8BD5_73A9_5BB6(_____73A9_5BB6) then
        return
    end
    local _____82F1_96C4_540D_79F0 = __TS__StringTrim(__TS__StringSubstring(_____547D_4EE4, #_____547D_4EE4_524D_7F00))
    if _____82F1_96C4_540D_79F0 == "" then
        debugLogForce(_____6A21_5757_540D, "命令缺少英雄名", "用法", "-英雄名")
        return
    end
    local _____82F1_96C4_5355_4F4D_5B57_7B26_4E32 = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____82F1_96C4_540D_79F0)
    if _____82F1_96C4_5355_4F4D_5B57_7B26_4E32 == nil or _____4E8C_5341_81F3_4E8C_5341_4E94_82F1_96C4_5355_4F4DID_8868[_____82F1_96C4_5355_4F4D_5B57_7B26_4E32] ~= true then
        debugLogForce(_____6A21_5757_540D, "只支持20-25号英雄", _____82F1_96C4_540D_79F0)
        return
    end
    local _____82F1_96C4_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____82F1_96C4_5355_4F4D_5B57_7B26_4E32)
    if _____82F1_96C4_5355_4F4D_7C7B_578BID == 0 then
        debugLogForce(_____6A21_5757_540D, "英雄单位ID无效", _____82F1_96C4_540D_79F0, _____82F1_96C4_5355_4F4D_5B57_7B26_4E32)
        return
    end
    local _____5927_6CD5_5E08 = globals.gg_unit_Hamg_0002
    if _____5927_6CD5_5E08 == nil or _____5927_6CD5_5E08 == 0 or _____5224_65AD_5355_4F4D_7C7B_578B(_____5927_6CD5_5E08, _____5355_4F4D_7C7B_578B_6B7B_4EA1) == true then
        debugLogForce(_____6A21_5757_540D, "未找到可用的预设大法师位置", "gg_unit_Hamg_0002")
        return
    end
    local _____82F1_96C4 = _____521B_5EFA_5355_4F4D(
        _____73A9_5BB6,
        _____82F1_96C4_5355_4F4D_7C7B_578BID,
        _____83B7_53D6_5355_4F4DX(_____5927_6CD5_5E08),
        _____83B7_53D6_5355_4F4DY(_____5927_6CD5_5E08),
        _____83B7_53D6_5355_4F4D_9762_5411(_____5927_6CD5_5E08)
    )
    if _____82F1_96C4 == nil or _____82F1_96C4 == 0 or _____5224_65AD_5355_4F4D_7C7B_578B(_____82F1_96C4, _____5355_4F4D_7C7B_578B_82F1_96C4) ~= true then
        debugLogForce(_____6A21_5757_540D, "创建玩家英雄失败", _____82F1_96C4_540D_79F0, _____82F1_96C4_5355_4F4D_5B57_7B26_4E32)
        return
    end
    directRegisterPlayerHero(_____73A9_5BB6, _____82F1_96C4)
    debugLogForce(
        _____6A21_5757_540D,
        "已创建并注册玩家英雄",
        _____82F1_96C4_540D_79F0,
        "单位ID",
        _____82F1_96C4_5355_4F4D_5B57_7B26_4E32
    )
end
_____6CE8_518C_804A_5929_547D_4EE4_524D_7F00_76D1_542C(_____547D_4EE4_524D_7F00, ____on_6309_540D_79F0_521B_5EFA_73A9_5BB6_82F1_96C4)
return ____exports
