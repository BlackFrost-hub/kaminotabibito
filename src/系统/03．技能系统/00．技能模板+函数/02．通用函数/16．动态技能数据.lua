--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local _____6280_80FD_52A8_4F5C = require("平台扩展API动作")
--- 只修改当前单位的技能实例，不创建技能、不替换技能、不承担技能逻辑。
-- 所有修改完成后统一刷新命令卡，适用于 Q/W/E/R/D 阶段显示切换。
____exports["动态修改单位技能数据"] = function(_____5355_4F4D, _____914D_7F6E_5217_8868)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            do
                local _____914D_7F6E = _____914D_7F6E_5217_8868[i + 1]
                local _____6280_80FDID = stringToFourCCSafe(_____914D_7F6E["技能ID"])
                if _____6280_80FDID == 0 then
                    goto __continue5
                end
                if _____914D_7F6E["名称"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能提示"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["名称"])
                end
                if _____914D_7F6E["图标"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能图标"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["图标"])
                end
                if _____914D_7F6E["说明"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能提示扩展"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["说明"])
                end
                if _____914D_7F6E["冷却"] ~= nil and _____6280_80FD_52A8_4F5C["技能_设置技能冷却时间"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能冷却时间"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["冷却"], _____914D_7F6E["最大冷却"] or _____914D_7F6E["冷却"])
                end
                if _____914D_7F6E["魔耗"] ~= nil and _____6280_80FD_52A8_4F5C["技能_设置技能魔法消耗"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能魔法消耗"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["魔耗"])
                end
                if _____914D_7F6E["施法距离"] ~= nil and _____6280_80FD_52A8_4F5C["技能_设置技能施法距离"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能施法距离"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["施法距离"])
                end
                if _____914D_7F6E["快捷键"] ~= nil and _____6280_80FD_52A8_4F5C["技能_设置技能快捷键"] ~= nil then
                    _____6280_80FD_52A8_4F5C["技能_设置技能快捷键"](_____5355_4F4D, _____6280_80FDID, _____914D_7F6E["快捷键"])
                end
                _____6280_80FD_52A8_4F5C["技能_设置刷新数据"](_____5355_4F4D, _____6280_80FDID)
            end
            ::__continue5::
            i = i + 1
        end
    end
end
return ____exports
