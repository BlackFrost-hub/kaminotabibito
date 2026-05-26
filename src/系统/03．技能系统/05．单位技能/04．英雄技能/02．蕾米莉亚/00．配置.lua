local ____lualib = require("lualib_bundle")
local Error = ____lualib.Error
local RangeError = ____lualib.RangeError
local ReferenceError = ____lualib.ReferenceError
local SyntaxError = ____lualib.SyntaxError
local TypeError = ____lualib.TypeError
local URIError = ____lualib.URIError
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置")
local _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID = ____require_result_1["按名字反查玩家英雄单位ID"]
local ____require_result_2 = require("系统.03．技能系统.08．技能数据表.01．技能名反查")
local _____6309_540D_5B57_53CD_67E5_6280_80FDID = ____require_result_2["按名字反查技能ID"]
local _____82F1_96C4_540D = "蕾米莉亚"
local _____6280_80FD_540D_79F0 = "A-蕾米莉亚-恶魔突袭（D）"
local _____82F1_96C4_5355_4F4DID = _____6309_540D_5B57_53CD_67E5_73A9_5BB6_82F1_96C4_5355_4F4DID(_____82F1_96C4_540D)
local _____6280_80FD_539F_59CBID = _____6309_540D_5B57_53CD_67E5_6280_80FDID(_____6280_80FD_540D_79F0)
if _____82F1_96C4_5355_4F4DID == nil or _____82F1_96C4_5355_4F4DID == "" then
    error(
        __TS__New(Error, "无法反查英雄单位ID：蕾米莉亚"),
        0
    )
end
if _____6280_80FD_539F_59CBID == nil or _____6280_80FD_539F_59CBID == "" then
    error(
        __TS__New(Error, "无法反查技能ID：A-蕾米莉亚-恶魔突袭（D）"),
        0
    )
end
____exports["蕾米莉亚单位技能配置"] = {
    ["英雄名"] = _____82F1_96C4_540D,
    ["单位ID"] = _____82F1_96C4_5355_4F4DID,
    ["技能名称"] = _____6280_80FD_540D_79F0,
    ["技能ID"] = _____6280_80FD_539F_59CBID,
    ["技能类型ID"] = stringToFourCCSafe(_____6280_80FD_539F_59CBID),
    ["单位类型ID"] = stringToFourCCSafe(_____82F1_96C4_5355_4F4DID),
    ["说明"] = "蕾米莉亚击杀敌人后重置恶魔突袭冷却"
}
return ____exports
