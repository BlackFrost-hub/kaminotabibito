--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.00．配置")
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["巴尔扎罗斯单位技能配置"]
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建巴尔扎罗斯上下文"]
local _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8FD0_884C_65F6 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["注册巴尔扎罗斯运行时"]
local ____04_FF0E_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.04．熔核封印与护卫机制")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236 = ____04_FF0E_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236["初始化巴尔扎罗斯熔核封印与护卫机制"]
local ____index = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.index")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_683C_9C81_59C6_6280_80FD = ____index["初始化巴尔扎罗斯格鲁姆技能"]
local ____index = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.02．护卫B塞拉.index")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_585E_62C9_6280_80FD = ____index["初始化巴尔扎罗斯塞拉技能"]
local ____11_FF0E_5730_6838_53EC_5524 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.11．地核召唤")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524_8282_70B9 = ____11_FF0E_5730_6838_53EC_5524["初始化巴尔扎罗斯地核召唤节点"]
local ____12_FF0E_7194_5CA9_62A4_76FE = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.12．熔岩护盾")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8282_70B9 = ____12_FF0E_7194_5CA9_62A4_76FE["初始化巴尔扎罗斯熔岩护盾节点"]
local ____13_FF0E_672B_65E5_7194_7206 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.13．末日熔爆")
local _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206_8282_70B9 = ____13_FF0E_672B_65E5_7194_7206["初始化巴尔扎罗斯末日熔爆节点"]
local ____15_FF0E_6280_80FD_5165_53E3 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.15．技能入口")
local _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_6280_80FD_7ED3_6784 = ____15_FF0E_6280_80FD_5165_53E3["注册巴尔扎罗斯技能结构"]
local ____19_FF0EBoss_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．Boss公共工具")
local stringToFourCC = ____19_FF0EBoss_516C_5171_5DE5_5177.stringToFourCC
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.06．AI自动使用技能.09．Boss战启动桥接.01．Boss自动技能注册表")
local _____83B7_53D6_6240_6709Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587 = ____require_result_1["获取所有Boss自动技能启动上下文"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____5DF4_5C14_624E_7F57_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____5DF4_5C14_624E_7F57_65AF_88AB_52A8_5DF2_6CE8_518C = false
local function _____626B_63CF_5DF4_5C14_624E_7F57_65AF_542F_52A8_4E0A_4E0B_6587()
    local contexts = _____83B7_53D6_6240_6709Boss_81EA_52A8_6280_80FD_542F_52A8_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            do
                local item = contexts[i + 1]
                local ____temp_2
                if item ~= nil then
                    ____temp_2 = item["Boss单位"]
                else
                    ____temp_2 = nil
                end
                local boss = ____temp_2
                if boss == nil or boss == 0 or GetUnitTypeId(boss) ~= _____5DF4_5C14_624E_7F57_65AF_5355_4F4D_7C7B_578BID then
                    goto __continue4
                end
                local context = _____83B7_53D6_6216_521B_5EFA_5DF4_5C14_624E_7F57_65AF_4E0A_4E0B_6587(boss)
                if context ~= nil then
                    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_6838_5C01_5370_4E0E_62A4_536B_673A_5236(context)
                    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_683C_9C81_59C6_6280_80FD(context)
                    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_585E_62C9_6280_80FD(context)
                    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_5730_6838_53EC_5524_8282_70B9(context)
                    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_7194_5CA9_62A4_76FE_8282_70B9(context)
                    _____521D_59CB_5316_5DF4_5C14_624E_7F57_65AF_672B_65E5_7194_7206_8282_70B9(context)
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
end
____exports["注册巴尔扎罗斯被动效果"] = function()
    if _____5DF4_5C14_624E_7F57_65AF_88AB_52A8_5DF2_6CE8_518C then
        return
    end
    _____5DF4_5C14_624E_7F57_65AF_88AB_52A8_5DF2_6CE8_518C = true
    _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_8FD0_884C_65F6()
    _____6CE8_518C_5DF4_5C14_624E_7F57_65AF_6280_80FD_7ED3_6784()
    addPeriodicCallback(1000, _____626B_63CF_5DF4_5C14_624E_7F57_65AF_542F_52A8_4E0A_4E0B_6587)
end
____exports["注册巴尔扎罗斯被动效果"]()
return ____exports
