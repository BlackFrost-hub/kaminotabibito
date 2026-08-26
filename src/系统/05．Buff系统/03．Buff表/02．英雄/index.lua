local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_63D0_7C73_8BFA_65AF = require("系统.05．Buff系统.03．Buff表.02．英雄.01．提米诺斯")
local _____63D0_7C73_8BFA_65AFBuff_8868 = ____01_FF0E_63D0_7C73_8BFA_65AF["提米诺斯Buff表"]
local ____02_FF0E_6B27_83F2_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.02．欧菲莉亚")
local _____6B27_83F2_8389_4E9ABuff_8868 = ____02_FF0E_6B27_83F2_8389_4E9A["欧菲莉亚Buff表"]
local ____03_FF0E_857E_7C73_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.03．蕾米莉亚")
local _____857E_7C73_8389_4E9ABuff_8868 = ____03_FF0E_857E_7C73_8389_4E9A["蕾米莉亚Buff表"]
local ____04_FF0E_85E4_539F_59B9_7EA2 = require("系统.05．Buff系统.03．Buff表.02．英雄.04．藤原妹红")
local _____85E4_539F_59B9_7EA2Buff_8868 = ____04_FF0E_85E4_539F_59B9_7EA2["藤原妹红Buff表"]
local ____05_FF0E_5742_4E95_60A0_4E8C = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
local _____5742_4E95_60A0_4E8CBuff_8868 = ____05_FF0E_5742_4E95_60A0_4E8C["坂井悠二Buff表"]
local ____06_FF0E_585E_62C9_65AF = require("系统.05．Buff系统.03．Buff表.02．英雄.06．塞拉斯")
local _____585E_62C9_65AFBuff_8868 = ____06_FF0E_585E_62C9_65AF["塞拉斯Buff表"]
local ____07_FF0E_4E00_65B9_901A_884C = require("系统.05．Buff系统.03．Buff表.02．英雄.07．一方通行")
local _____4E00_65B9_901A_884CBuff_8868 = ____07_FF0E_4E00_65B9_901A_884C["一方通行Buff表"]
local ____08_FF0ESaber = require("系统.05．Buff系统.03．Buff表.02．英雄.08．Saber")
local ____SaberBuff_8868 = ____08_FF0ESaber["SaberBuff表"]
local ____09_FF0E_9ED1_5D0E_4E00_62A4 = require("系统.05．Buff系统.03．Buff表.02．英雄.09．黑崎一护")
local _____9ED1_5D0E_4E00_62A4Buff_8868 = ____09_FF0E_9ED1_5D0E_4E00_62A4["黑崎一护Buff表"]
local ____10_FF0E_9E7F_76EE_5706 = require("系统.05．Buff系统.03．Buff表.02．英雄.10．鹿目圆")
local _____9E7F_76EE_5706Buff_8868 = ____10_FF0E_9E7F_76EE_5706["鹿目圆Buff表"]
local ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE = require("系统.05．Buff系统.03．Buff表.02．英雄.11．佐佐木小次郎")
local _____4F50_4F50_6728_5C0F_6B21_90CEBuff_8868 = ____11_FF0E_4F50_4F50_6728_5C0F_6B21_90CE["佐佐木小次郎Buff表"]
local ____12_FF0E_94C3_4ED9 = require("系统.05．Buff系统.03．Buff表.02．英雄.12．铃仙")
local _____94C3_4ED9Buff_8868 = ____12_FF0E_94C3_4ED9["铃仙Buff表"]
local ____13_FF0E_963F_4F26_52B3_7279 = require("系统.05．Buff系统.03．Buff表.02．英雄.13．阿伦劳特")
local _____963F_4F26_52B3_7279Buff_8868 = ____13_FF0E_963F_4F26_52B3_7279["阿伦劳特Buff表"]
local ____14_FF0E_516B_4E91_7D2B = require("系统.05．Buff系统.03．Buff表.02．英雄.14．八云紫")
local _____516B_4E91_7D2BBuff_8868 = ____14_FF0E_516B_4E91_7D2B["八云紫Buff表"]
local ____15_FF0E_514B_52B3_5FB7 = require("系统.05．Buff系统.03．Buff表.02．英雄.15．克劳德")
local _____514B_52B3_5FB7Buff_8868 = ____15_FF0E_514B_52B3_5FB7["克劳德Buff表"]
local ____16_FF0E_5B89_65AF_827E_5C14 = require("系统.05．Buff系统.03．Buff表.02．英雄.16．安斯艾尔")
local _____5B89_65AF_827E_5C14Buff_8868 = ____16_FF0E_5B89_65AF_827E_5C14["安斯艾尔Buff表"]
local ____17_FF0E_6B27_5C14_8D1D_514B = require("系统.05．Buff系统.03．Buff表.02．英雄.17．欧尔贝克")
local _____6B27_5C14_8D1D_514BBuff_8868 = ____17_FF0E_6B27_5C14_8D1D_514B["欧尔贝克Buff表"]
local ____18_FF0E_4E91_7AEF = require("系统.05．Buff系统.03．Buff表.02．英雄.18．云端")
local _____4E91_7AEFBuff_8868 = ____18_FF0E_4E91_7AEF["云端Buff表"]
local ____19_FF0E_5341_516D_591C_54B2_591C = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜")
local _____5341_516D_591C_54B2_591CBuff_8868 = ____19_FF0E_5341_516D_591C_54B2_591C["十六夜咲夜Buff表"]
local ____20_FF0E_7231_871C_8389_96C5 = require("系统.05．Buff系统.03．Buff表.02．英雄.20．爱蜜莉雅")
local _____7231_871C_8389_96C5Buff_8868 = ____20_FF0E_7231_871C_8389_96C5["爱蜜莉雅Buff表"]
____exports["英雄Buff表"] = __TS__ObjectAssign(
    {},
    _____63D0_7C73_8BFA_65AFBuff_8868,
    _____6B27_83F2_8389_4E9ABuff_8868,
    _____857E_7C73_8389_4E9ABuff_8868,
    _____85E4_539F_59B9_7EA2Buff_8868,
    _____5742_4E95_60A0_4E8CBuff_8868,
    _____585E_62C9_65AFBuff_8868,
    _____4E00_65B9_901A_884CBuff_8868,
    ____SaberBuff_8868,
    _____9ED1_5D0E_4E00_62A4Buff_8868,
    _____9E7F_76EE_5706Buff_8868,
    _____4F50_4F50_6728_5C0F_6B21_90CEBuff_8868,
    _____94C3_4ED9Buff_8868,
    _____963F_4F26_52B3_7279Buff_8868,
    _____516B_4E91_7D2BBuff_8868,
    _____514B_52B3_5FB7Buff_8868,
    _____5B89_65AF_827E_5C14Buff_8868,
    _____6B27_5C14_8D1D_514BBuff_8868,
    _____4E91_7AEFBuff_8868,
    _____5341_516D_591C_54B2_591CBuff_8868,
    _____7231_871C_8389_96C5Buff_8868
)
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.01．提米诺斯")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.02．欧菲莉亚")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.03．蕾米莉亚")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.04．藤原妹红")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.05．坂井悠二")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.06．塞拉斯")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.07．一方通行")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.08．Saber")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.09．黑崎一护")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.10．鹿目圆")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.11．佐佐木小次郎")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.12．铃仙")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.13．阿伦劳特")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.14．八云紫")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.15．克劳德")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.16．安斯艾尔")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.17．欧尔贝克")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.18．云端")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.19．十六夜咲夜")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("系统.05．Buff系统.03．Buff表.02．英雄.20．爱蜜莉雅")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
____exports.default = ____exports["英雄Buff表"]
return ____exports
