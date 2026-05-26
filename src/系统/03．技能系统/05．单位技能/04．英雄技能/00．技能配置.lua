local ____lualib = require("lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.01．技能配置工具")
local _____521B_5EFA_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_0["创建单位技能配置"]
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_1["按名字反查玩家英雄单位ID"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.03．技能系统.08．技能数据表.01．技能名反查")
local _____6309_540D_5B57_53CD_67E5_6280_80FDID = ____require_result_3["按名字反查技能ID"]
local _____857E_7C73_8389_4E9A_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID("蕾米莉亚")
local _____857E_7C73_8389_4E9A_6076_9B54_7A81_88ADID = _____6309_540D_5B57_53CD_67E5_6280_80FDID("A-蕾米莉亚-恶魔突袭（D）")
if _____857E_7C73_8389_4E9A_5355_4F4DID == nil or _____857E_7C73_8389_4E9A_5355_4F4DID == "" then
    error(
        __TS__New(Error, "无法反查英雄单位ID：蕾米莉亚"),
        0
    )
end
if _____857E_7C73_8389_4E9A_6076_9B54_7A81_88ADID == nil or _____857E_7C73_8389_4E9A_6076_9B54_7A81_88ADID == "" then
    error(
        __TS__New(Error, "无法反查技能ID：A-蕾米莉亚-恶魔突袭（D）"),
        0
    )
end
local _____857E_7C73_8389_4E9A_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____857E_7C73_8389_4E9A_5355_4F4DID)
local _____857E_7C73_8389_4E9A_6076_9B54_7A81_88AD_7C7B_578BID = stringToFourCCSafe(_____857E_7C73_8389_4E9A_6076_9B54_7A81_88ADID)
____exports["英雄技能配置表"] = {
    _____521B_5EFA_5355_4F4D_6280_80FD_914D_7F6E({
        ["技能ID"] = "英雄示例",
        ["技能名称"] = "英雄示例技能",
        ["归类"] = "英雄",
        ["触发方式"] = "初始化",
        ["说明"] = "占位示例，后续按实际英雄技能替换。"
    }),
    _____521B_5EFA_5355_4F4D_6280_80FD_914D_7F6E({
        ["技能ID"] = "蕾米莉亚-击杀重置恶魔突袭",
        ["技能名称"] = "蕾米莉亚-击杀重置恶魔突袭（D）",
        ["归类"] = "英雄",
        ["触发方式"] = "死亡",
        ["单位类型列表"] = {_____857E_7C73_8389_4E9A_5355_4F4D_7C7B_578BID},
        ["配置数据"] = {
            ["英雄名"] = "蕾米莉亚",
            ["单位名"] = "蕾米莉亚",
            ["技能名称"] = "A-蕾米莉亚-恶魔突袭（D）",
            ["技能ID"] = _____857E_7C73_8389_4E9A_6076_9B54_7A81_88AD_7C7B_578BID,
            ["冷却重置值"] = 0
        }
    })
}
return ____exports
