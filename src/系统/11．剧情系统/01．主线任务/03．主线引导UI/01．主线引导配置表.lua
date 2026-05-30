--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____require_result_0["读取剧情进度"]
local STRING_293 = "|cffffff00『主线引导』|r：穿过|cffff9900山谷|r前往|cffffcc99西里尔村落|r"
local STRING_294 = "|cffffff00『系统提示』：|r|cffff0000前往村子北方地精处！|r"
local STRING_295 = "|cffffff00『系统提示』：|r|cffff0000前往地精洞窟深处（有Boss战斗）|r"
local STRING_296 = "|cffffff00『系统提示』：|r|cffff0000击杀Boss-『地精祭祀』！|r"
local STRING_297 = "|cffffff00『系统提示』：|r|cffff0000回到西里尔村（精灵村）将消息告诉族长！|r"
local STRING_298 = "|cffffff00『主线引导』：|r穿过东部|cffff9900『巨石山谷』|r前往沙漠寻找|cffcc99ff『魔力源泉』|r"
local STRING_299 = "|cffffff00『系统提示』：|主线目标，在聚集地中寻找|cffcc99ff『魔力源石』|r的消息"
local STRING_300 = "|cffffff00『主线目标』：|r前往|cffff9900『蛇人族领地』|r询问|cff00ff00『夜光翡翠』|r消息。"
local STRING_301 = "|cffffff00『主线目标』：|r前往|cffff9900『东边藏品处』|r询问|cff00ff00『夜光翡翠』|r消息。"
local STRING_302 = "|cffffff00『主线引导』：|r|cffff6800『蛇人族』|r让我们帮他们狩猎一头|cffff0000『食人魔』|r，看来并不简单，考虑好后再作决定吧（考虑清楚后选择|cffffffcc『藏品管家』|r后点击接受任务）"
local STRING_303 = "|cffffff00『主线引导』：|r进入『传送裂缝』击败沙漠食人魔！"
local STRING_304 = "|cffffff00『主线引导』：|r击败沙漠食人魔！"
local STRING_305 = "|cffffff00『主线引导』：|r击败杀戮食人魔！"
local STRING_306 = "|cffffff00『主线引导』：|r前往|cffffff00『蛇人领地』|r找|cffffff00『藏品管事-凯希丁』|r交差"
local STRING_307 = "『主线引导』：与队长|cffff0000切磋|r，血量削减至10%让其认可实力。|cffffffcc(使用英雄天生技能『异界能力』中的『挑战』对队长使用后开始Boss战决斗)|r"
local STRING_308 = "|cffffff00『主线引导』|r：回到|cffffcc99『沙漠聚集地』情报商人处|r交换|cff00ccff『魔力源石』|r。"
local STRING_309 = "|cffffff00『主线引导』：|r回到|cffffffcc『西里尔精灵村』（村口）|r打开钥匙的封印。|n|cffffffcc下一个主线任务会开启|r|cffff0000本章节最终的『Boss战』|r。难度较高|cffffffcc请做好万全准备！！！|r"
local STRING_310 = "|cffffff00『主线引导』：|r击败神秘蒙面人！！"
local STRING_311 = "|cffffff00『主线目标』：|r跟随精灵族长！"
local STRING_312 = "|cffffff00『主线引导』：|r使用|cffff99cc『森林传送阵』（在传送阵附近使用异界能力中的『环境交互』）|r前往|cffffcc99『克林山谷』|r寻找|cffff9900『克林姆德一脉』|r"
local STRING_313 = "|cffffff00『主线引导』：|r拜访此地的|cffffffcc『看守者』（村口）|r验明身份。"
local STRING_314 = "|cffffff00『主线引导』：|r穿过|cffff9900『克林山谷』|r前往|cffff9900『克林姆德城』|r"
local STRING_315 = "|cffffff00『主线引导』：|r前往|cffff9900『克林姆德王宫』|r觐见|cffff99cc『克林姆德王』|r|n。"
local STRING_316 = "|cffffff00『主线引导』：觐见|cffff99cc『克林姆德王』|r|n。"
local STRING_317 = "|cffffff00『主线目标』：|r|cffffcc99前往东南方向的『巨魔一族』领地调查。|r"
--- 进度 -> 配置映射表
local _____8FDB_5EA6_914D_7F6E_8868 = {}
_____8FDB_5EA6_914D_7F6E_8868[0] = {["提示文本"] = STRING_293, ["镜头X"] = -29104.8, ["镜头Y"] = -27527.1}
_____8FDB_5EA6_914D_7F6E_8868[1] = {["提示文本"] = STRING_294, ["镜头X"] = -29392.7, ["镜头Y"] = -20049.2}
_____8FDB_5EA6_914D_7F6E_8868[2] = {["提示文本"] = STRING_295}
_____8FDB_5EA6_914D_7F6E_8868[3] = {["提示文本"] = STRING_296}
_____8FDB_5EA6_914D_7F6E_8868[4] = {["提示文本"] = STRING_297, ["镜头X"] = 28709.4, ["镜头Y"] = -28997.1}
_____8FDB_5EA6_914D_7F6E_8868[5] = {["提示文本"] = STRING_298, ["镜头X"] = -16003.4, ["镜头Y"] = -24617.3}
_____8FDB_5EA6_914D_7F6E_8868[6] = {["提示文本"] = STRING_299, ["镜头X"] = -5276.3, ["镜头Y"] = -24408.3}
_____8FDB_5EA6_914D_7F6E_8868[7] = {["提示文本"] = STRING_300, ["镜头X"] = 1455.7, ["镜头Y"] = -21980}
_____8FDB_5EA6_914D_7F6E_8868[8] = {["提示文本"] = STRING_301, ["镜头X"] = -20880.7, ["镜头Y"] = 3186.4}
_____8FDB_5EA6_914D_7F6E_8868[9] = {["提示文本"] = STRING_302, ["镜头跟随单位"] = "主线NPC.蛇人族藏品管家"}
_____8FDB_5EA6_914D_7F6E_8868[10] = {["提示文本"] = STRING_303}
_____8FDB_5EA6_914D_7F6E_8868[11] = {["提示文本"] = STRING_304}
_____8FDB_5EA6_914D_7F6E_8868[12] = {["提示文本"] = STRING_305}
_____8FDB_5EA6_914D_7F6E_8868[13] = {["提示文本"] = STRING_306, ["镜头跟随单位"] = "主线NPC.蛇人族藏品管家"}
_____8FDB_5EA6_914D_7F6E_8868[14] = {["提示文本"] = STRING_307, ["镜头跟随单位"] = "主线NPC.蛇人族卫队长"}
_____8FDB_5EA6_914D_7F6E_8868[15] = {["提示文本"] = STRING_308, ["镜头X"] = -7061.2, ["镜头Y"] = -26301.8}
_____8FDB_5EA6_914D_7F6E_8868[16] = {["提示文本"] = STRING_309, ["镜头X"] = -24133.2, ["镜头Y"] = -26225.9}
_____8FDB_5EA6_914D_7F6E_8868[17] = {["提示文本"] = STRING_310}
_____8FDB_5EA6_914D_7F6E_8868[18] = {["提示文本"] = STRING_311, ["镜头X"] = 28775.2, ["镜头Y"] = -28660.2}
_____8FDB_5EA6_914D_7F6E_8868[19] = {["提示文本"] = STRING_312, ["镜头X"] = 28775.2, ["镜头Y"] = -28660.2}
_____8FDB_5EA6_914D_7F6E_8868[20] = {["提示文本"] = STRING_313, ["镜头X"] = -21118.8, ["镜头Y"] = -14288.2}
_____8FDB_5EA6_914D_7F6E_8868[21] = {["提示文本"] = STRING_314, ["镜头X"] = -6997.4, ["镜头Y"] = -13110.9}
_____8FDB_5EA6_914D_7F6E_8868[22] = {["提示文本"] = STRING_315, ["镜头X"] = -10900.6, ["镜头Y"] = -10601.8}
_____8FDB_5EA6_914D_7F6E_8868[23] = {["提示文本"] = STRING_316, ["镜头X"] = 18924.9, ["镜头Y"] = -24399.8}
_____8FDB_5EA6_914D_7F6E_8868[25] = {["提示文本"] = STRING_317, ["镜头X"] = -2906.2, ["镜头Y"] = -14099.8}
--- 根据剧情进度获取配置
-- 进度 < 1 时使用 0；否则直接使用进度值
____exports["获取进度配置"] = function()
    local _____8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    local key = _____8FDB_5EA6 < 1 and 0 or _____8FDB_5EA6
    return _____8FDB_5EA6_914D_7F6E_8868[key]
end
return ____exports
