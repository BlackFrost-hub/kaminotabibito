--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["广播提示玩家槽数"] = 4
____exports["每玩家广播提示槽数"] = 5
____exports["广播提示背景贴图"] = "UI\\xiaoxi\\UInoticebackdrop.tga"
____exports["广播提示默认头像"] = "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp"
____exports["广播提示字体"] = "UI\\uizt.ttf"
____exports["广播提示宽度"] = 0.235
____exports["广播提示高度"] = 0.034
____exports["广播提示头像大小"] = 0.026
____exports["广播提示文字宽度"] = 0.185
____exports["广播提示文字高度"] = 0.018
____exports["广播提示起始X"] = 0.22
____exports["广播提示停留X"] = 0.105
____exports["广播提示基准Y"] = 0.225
____exports["广播提示槽间距Y"] = 0.038
____exports["广播提示滑入毫秒"] = 300
____exports["广播提示默认停留毫秒"] = 3000
____exports["广播提示淡出毫秒"] = 450
____exports["广播提示刷新毫秒"] = 50
____exports["广播提示最大透明度"] = 255
____exports["广播提示优先级"] = 650
____exports["帧点左"] = 3
____exports["帧点中"] = 4
____exports["帧点右"] = 5
____exports["文本左对齐"] = 2
____exports["广播提示状态_隐藏"] = 0
____exports["广播提示状态_滑入"] = 1
____exports["广播提示状态_停留"] = 2
____exports["广播提示状态_淡出"] = 3
____exports["取广播提示槽索引"] = function(_____73A9_5BB6ID, _____69FD_4F4DID)
    return _____73A9_5BB6ID * ____exports["每玩家广播提示槽数"] + _____69FD_4F4DID
end
____exports["取广播提示槽位Y"] = function(_____69FD_4F4DID)
    return ____exports["广播提示基准Y"] + _____69FD_4F4DID * ____exports["广播提示槽间距Y"]
end
return ____exports
