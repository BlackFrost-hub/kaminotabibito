--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5E73_53F0_539F_751F_8868 = require("jass.japi")
local _____539F_751F_51FD_6570_8868 = _____5E73_53F0_539F_751F_8868
____exports["地图_评论次数"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_CommentCount(_____73A9_5BB6)
end
____exports["地图_地图评论次数"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_CommentTotalCount()
end
____exports["地图_玩家在地图自定义排行榜上的排名"] = function(_____73A9_5BB6, ID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_CommentTotalCount1(_____73A9_5BB6, ID)
end
____exports["地图_玩家签到天数"] = function(_____73A9_5BB6, ID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_ContinuousCount(_____73A9_5BB6, ID)
end
____exports["地图_自定义排行榜上榜人数"] = function(ID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_CustomRankCount(ID)
end
____exports["地图_自定义排行榜上的玩家昵称"] = function(ID, _____6392_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_CustomRankPlayerName(ID, _____6392_540D)
end
____exports["地图_自定义排行榜上的玩家数值"] = function(ID, _____6392_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_CustomRankValue(ID, _____6392_540D)
end
____exports["地图_玩家好友数量"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_FriendCount(_____73A9_5BB6)
end
____exports["地图_取活动数据"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetActivityData()
end
____exports["地图_玩家在地图社区上的互动数据"] = function(_____73A9_5BB6, _____6570_636E_9879)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetForumData(_____73A9_5BB6, _____6570_636E_9879)
end
____exports["地图_本局游戏的开始时间"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetGameStartTime()
end
____exports["地图_玩家在公会的职责"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetGuildRole(_____73A9_5BB6)
end
____exports["地图_玩家天梯等级"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetLadderLevel(_____73A9_5BB6)
end
____exports["地图_玩家天梯排名"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetLadderRank(_____73A9_5BB6)
end
____exports["地图_玩家抽取地图宝箱总次数"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetLotteryUsedCount(_____73A9_5BB6)
end
____exports["地图_玩家抽取指定地图宝箱次数"] = function(_____73A9_5BB6, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetLotteryUsedCountEx(_____73A9_5BB6, _____5E8F_53F7)
end
____exports["地图_玩家地图商城道具剩余数量"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetMallItemCount(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_地图配置参数"] = function(_____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetMapConfig(_____952E_540D)
end
____exports["地图_玩家地图等级"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetMapLevel(_____73A9_5BB6)
end
____exports["地图_玩家在地图等级排行榜上的排名"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetMapLevelRank(_____73A9_5BB6)
end
____exports["地图_本局游戏的地图模式"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetMatchType()
end
____exports["地图_取平台贵宾"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetPlatformVIP(_____73A9_5BB6)
end
____exports["地图_玩家在KK对战平台的完整昵称"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetPlayerUserName(_____73A9_5BB6)
end
____exports["地图_取服务器存档组"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetPublicArchive(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_BOSS击杀后的掉落内容"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetServerArchiveDrop(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_BOSS击杀后的掉落数量"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetServerArchiveEquip(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器存储的数据"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetServerValue(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器值错误码"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetServerValueErrorCode(_____73A9_5BB6)
end
____exports["地图_玩家本局游戏距上一局游戏的时间差"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetSinceLastPlayedSeconds(_____73A9_5BB6)
end
____exports["地图_取服务器存储的技能类型"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredAbilityId(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器上的整数变量"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredInteger(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器存储的整数"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredIntegerEX(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器上的实数变量"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredReal(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器上的字符串变量"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredString(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器存储的字符串"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredStringEX(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_取服务器存储的单位类型"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredUnitType(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_读取全局存档"] = function(_____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Global_GetStoreString(_____952E_540D)
end
____exports["地图_玩家在指定地图累计消耗平台金币"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsConsumeGold(_____73A9_5BB6, _____5730_56FEID)
end
____exports["地图_玩家在指定地图的平台木材消耗"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsConsumeLumber(_____73A9_5BB6, _____5730_56FEID)
end
____exports["地图_玩家在指定地图的地图等级"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsLevel(_____73A9_5BB6, _____5730_56FEID)
end
____exports["地图_玩家累计游戏时长"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsTotalPlayed(_____73A9_5BB6)
end
____exports["地图_玩家累计游戏局数"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_PlayedGames(_____73A9_5BB6)
end
____exports["地图_取服务器存档"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_ServerArchive(_____73A9_5BB6, _____952E_540D)
end
____exports["建造_异步获取当前正在建造的技能编号"] = function()
    return _____539F_751F_51FD_6570_8868.DzAsyncGetCurrentBuildingAbilityId()
end
____exports["建造_异步获取当前正在建造的单位编号"] = function()
    return _____539F_751F_51FD_6570_8868.DzAsyncGetCurrentBuildingUnitId()
end
____exports["按位与"] = function(_____503CA, _____503CB)
    return _____539F_751F_51FD_6570_8868.DzBitAnd(_____503CA, _____503CB)
end
____exports["整数的2进制的位值"] = function(_____6574_6570_503C, _____5B57_8282_5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzBitGet(_____6574_6570_503C, _____5B57_8282_5E8F_53F7)
end
____exports["整数的256进制的位值"] = function(_____6574_6570_503C, _____5B57_8282_5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzBitGetByte(_____6574_6570_503C, _____5B57_8282_5E8F_53F7)
end
____exports["按位取反"] = function(_____6574_6570_503C)
    return _____539F_751F_51FD_6570_8868.DzBitNot(_____6574_6570_503C)
end
____exports["按位或"] = function(_____503CA, _____503CB)
    return _____539F_751F_51FD_6570_8868.DzBitOr(_____503CA, _____503CB)
end
____exports["按位左移"] = function(_____6574_6570_503C, _____79FB_4F4D_4F4D_6570)
    return _____539F_751F_51FD_6570_8868.DzBitShiftLeft(_____6574_6570_503C, _____79FB_4F4D_4F4D_6570)
end
____exports["按位右移"] = function(_____6574_6570_503C, _____79FB_4F4D_4F4D_6570)
    return _____539F_751F_51FD_6570_8868.DzBitShiftRight(_____6574_6570_503C, _____79FB_4F4D_4F4D_6570)
end
____exports["四字节组合为整数"] = function(_____5B57_82821, _____5B57_82822, _____5B57_82823, _____5B57_82824)
    return _____539F_751F_51FD_6570_8868.DzBitToInt(_____5B57_82821, _____5B57_82822, _____5B57_82823, _____5B57_82824)
end
____exports["按位异或"] = function(_____503CA, _____503CB)
    return _____539F_751F_51FD_6570_8868.DzBitXor(_____503CA, _____503CB)
end
____exports["转换屏幕坐标到世界x坐标"] = function(x, y)
    return _____539F_751F_51FD_6570_8868.DzConvertScreenPositionX(x, y)
end
____exports["转换屏幕坐标到世界y坐标"] = function(x, y)
    return _____539F_751F_51FD_6570_8868.DzConvertScreenPositionY(x, y)
end
____exports["转化_目标允许字符串转整数"] = function(_____76EE_6807_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzConvertStr2Targs(_____76EE_6807_7C7B_578B)
end
____exports["转化_目标允许整数转字符串"] = function(_____76EE_6807_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzConvertTargs2Str(_____76EE_6807_7C7B_578B)
end
____exports["装饰物_新建地形装饰物"] = function(ID, _____53D8_4F53, x, y, z, _____65CB_8F6C_89D2_5EA6, _____7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzDoodadCreate(
        ID,
        _____53D8_4F53,
        x,
        y,
        z,
        _____65CB_8F6C_89D2_5EA6,
        _____7F29_653E
    )
end
____exports["装饰物_装饰物动画数量"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetAnimationCount(_____88C5_9970_7269)
end
____exports["装饰物_装饰物动画名"] = function(_____88C5_9970_7269, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetAnimationName(_____88C5_9970_7269, _____5E8F_53F7)
end
____exports["装饰物_装饰物动画时间"] = function(_____88C5_9970_7269, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetAnimationTime(_____88C5_9970_7269, _____5E8F_53F7)
end
____exports["装饰物_装饰物当前动画编号"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetCurrentAnimationIndex(_____88C5_9970_7269)
end
____exports["装饰物_装饰物动画播放速度"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetTimeScale(_____88C5_9970_7269)
end
____exports["装饰物_装饰物的类型编号"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetTypeId(_____88C5_9970_7269)
end
____exports["装饰物_装饰物的横坐标坐标"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetX(_____88C5_9970_7269)
end
____exports["装饰物_装饰物的纵坐标坐标"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetY(_____88C5_9970_7269)
end
____exports["装饰物_装饰物的高度坐标"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadGetZ(_____88C5_9970_7269)
end
____exports["界面_添加模型"] = function(_____7236_7EA7_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameAddModel(_____7236_7EA7_754C_9762)
end
____exports["界面_添加模型特效"] = function(_____6A21_578B_754C_9762, _____9644_7740_70B9, _____6A21_578B_8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzFrameAddModelEffect(_____6A21_578B_754C_9762, _____9644_7740_70B9, _____6A21_578B_8DEF_5F84)
end
____exports["界面_原生_获取聊天输入栏控件"] = function()
    return _____539F_751F_51FD_6570_8868.DzFrameGetChatEditBar()
end
____exports["界面_取子控件"] = function(_____754C_9762, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzFrameGetChild(_____754C_9762, _____5E8F_53F7)
end
____exports["界面_取子控件数量"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetChildrenCount(_____754C_9762)
end
____exports["界面_取命令条按钮"] = function(_____884C, _____5217)
    return _____539F_751F_51FD_6570_8868.DzFrameGetCommandBarButton(_____884C, _____5217)
end
____exports["界面_取技能自动施法指示器"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetCommandBarButtonAutoCastIndicator(_____754C_9762)
end
____exports["界面_取技能冷却指示器"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetCommandBarButtonCooldownIndicator(_____754C_9762)
end
____exports["界面_取技能右下角数字文本框体"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetCommandBarButtonNumberOverlay(_____754C_9762)
end
____exports["界面_取技能右下角数字文本控件"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetCommandBarButtonNumberText(_____754C_9762)
end
____exports["界面_获取控件绑定的整数"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetContext(_____754C_9762)
end
____exports["界面_取BUFF控件"] = function(_____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzFrameGetInfoPanelBuffButton(_____5E8F_53F7)
end
____exports["界面_取框选控件"] = function(_____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzFrameGetInfoPanelSelectButton(_____5E8F_53F7)
end
____exports["界面_获取低于控制台的底层Frame"] = function()
    return _____539F_751F_51FD_6570_8868.DzFrameGetLowerLevelFrame()
end
____exports["界面_取模型颜色"] = function(_____6A21_578B_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetModelColor(_____6A21_578B_754C_9762)
end
____exports["界面_取模型大小"] = function(_____6A21_578B_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetModelSize(_____6A21_578B_754C_9762)
end
____exports["界面_取模型速度"] = function(_____6A21_578B_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetModelSpeed(_____6A21_578B_754C_9762)
end
____exports["界面_取模型横坐标"] = function(_____6A21_578B_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetModelX(_____6A21_578B_754C_9762)
end
____exports["界面_取模型纵坐标"] = function(_____6A21_578B_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetModelY(_____6A21_578B_754C_9762)
end
____exports["界面_取模型高度"] = function(_____6A21_578B_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetModelZ(_____6A21_578B_754C_9762)
end
____exports["界面_获取鼠标控件"] = function()
    return _____539F_751F_51FD_6570_8868.DzFrameGetMouse()
end
____exports["界面_获取控件的全局名字"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetName(_____754C_9762)
end
____exports["界面_取农民控件"] = function()
    return _____539F_751F_51FD_6570_8868.DzFrameGetPeonBar()
end
____exports["界面_取相对锚点所在界面"] = function(_____754C_9762, _____951A_70B9)
    return _____539F_751F_51FD_6570_8868.DzFrameGetPointRelative(_____754C_9762, _____951A_70B9)
end
____exports["界面_取相对锚点的界面锚点"] = function(_____754C_9762, _____951A_70B9)
    return _____539F_751F_51FD_6570_8868.DzFrameGetPointRelativePoint(_____754C_9762, _____951A_70B9)
end
____exports["界面_取锚点横坐标坐标"] = function(_____754C_9762, _____951A_70B9)
    return _____539F_751F_51FD_6570_8868.DzFrameGetPointX(_____754C_9762, _____951A_70B9)
end
____exports["界面_取锚点纵坐标坐标"] = function(_____754C_9762, _____951A_70B9)
    return _____539F_751F_51FD_6570_8868.DzFrameGetPointY(_____754C_9762, _____951A_70B9)
end
____exports["界面_获取控件实际高度"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetRealHeight(_____754C_9762)
end
____exports["界面_获取控件实际宽度"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetRealWidth(_____754C_9762)
end
____exports["界面_触发的血条"] = function()
    return _____539F_751F_51FD_6570_8868.DzFrameGetTriggerHpBar()
end
____exports["界面_触发血条的单位"] = function()
    return _____539F_751F_51FD_6570_8868.DzFrameGetTriggerHpBarUnit()
end
____exports["界面_取单位血条"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzFrameGetUnitHpBar(_____5355_4F4D)
end
____exports["界面_取宽度"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetWidth(_____754C_9762)
end
____exports["界面_游戏提示信息界面"] = function()
    return _____539F_751F_51FD_6570_8868.DzFrameGetWorldFrameMessage()
end
____exports["界面_转换地图坐标为小地图x坐标"] = function(x, y)
    return _____539F_751F_51FD_6570_8868.DzFrameWorldToMinimapPosX(x, y)
end
____exports["界面_转换地图坐标为小地图y坐标"] = function(x, y)
    return _____539F_751F_51FD_6570_8868.DzFrameWorldToMinimapPosY(x, y)
end
____exports["取商店目标"] = function(_____5546_5E97, _____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzGetActivePatron(_____5546_5E97, _____73A9_5BB6)
end
____exports["取普攻技能"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetAttackAbility(_____5355_4F4D)
end
____exports["取当前缓存模型的数量"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetCacheModelCount()
end
____exports["鼠标界面"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetCursorFrame()
end
____exports["装饰物_获取当前地形装饰物数量"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetDoodadsCount()
end
____exports["取特效透明度"] = function(_____7279_6548)
    return _____539F_751F_51FD_6570_8868.DzGetEffectVertexAlpha(_____7279_6548)
end
____exports["取特效颜色"] = function(_____7279_6548)
    return _____539F_751F_51FD_6570_8868.DzGetEffectVertexColor(_____7279_6548)
end
____exports["取帧率帧数"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetFPS()
end
____exports["取游戏界面"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetGameUI()
end
____exports["界面_获取游戏外界面底层"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetGlueUI()
end
____exports["英雄_获取主属性"] = function(_____5355_4F4D, _____5E03_5C142)
    return _____539F_751F_51FD_6570_8868.DzGetHeroPrimaryAttribute(_____5355_4F4D, _____5E03_5C142)
end
____exports["取英雄主属性附加"] = function(_____5355_4F4D, _____5C5E_6027)
    return _____539F_751F_51FD_6570_8868.DzGetHeroPrimaryAttributePlus(_____5355_4F4D, _____5C5E_6027)
end
____exports["英雄_获取主属性类型"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetHeroPrimaryAttributeType(_____5355_4F4D)
end
____exports["取物品技能"] = function(_____7279_6548, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzGetItemAbility(_____7279_6548, _____5E8F_53F7)
end
____exports["物品_获取物品的碰撞体积"] = function(_____7269_54C1)
    return _____539F_751F_51FD_6570_8868.DzGetItemCollisionSize(_____7269_54C1)
end
____exports["取字符串数量"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetJassStringTableCount()
end
____exports["物品_当前选择的物品异步"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetLastSelectedItem()
end
____exports["玩家_获取本地玩家的聊天频道"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetLocalChatRecipient()
end
____exports["取玩家选中的单位"] = function(_____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzGetLocalSelectUnit(_____5E8F_53F7)
end
____exports["取玩家选中的单位数量"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetLocalSelectUnitCount()
end
____exports["取预建造对象"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnBuildAgent()
end
____exports["取建造的命令编号"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnBuildOrderId()
end
____exports["取建造的命令类型"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnBuildOrderType()
end
____exports["取监听到的技能"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnTargetAbilId()
end
____exports["取监听到技能预选目标"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnTargetAgent()
end
____exports["取监听到技能预选目标_2"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnTargetInstantTarget()
end
____exports["取监听到技能预选命令"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnTargetOrderId()
end
____exports["取监听到技能预选命令类型"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetOnTargetOrderType()
end
____exports["物品_玩家当前选择的物品同步"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzGetPlayerLastSelectedItem(_____73A9_5BB6)
end
____exports["当前选择的单位"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetSelectedLeaderUnit()
end
____exports["当前选择的单位异步"] = function()
    return ____exports["当前选择的单位"]()
end
____exports["硬件_获取屏幕设备高度"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetSystemMetricsHeight()
end
____exports["硬件_获取屏幕设备宽度"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetSystemMetricsWidth()
end
____exports["坐标_获取地形高度轴高度"] = function(x, y)
    return _____539F_751F_51FD_6570_8868.DzGetTerrainZ(x, y)
end
____exports["取时间日期从时间戳"] = function(_____65F6_95F4_6233)
    return _____539F_751F_51FD_6570_8868.DzGetTimeDateFromTimestamp(_____65F6_95F4_6233)
end
____exports["取触发按键"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetTriggerKey()
end
____exports["取触发按键玩家"] = function()
    return _____539F_751F_51FD_6570_8868.DzGetTriggerKeyPlayer()
end
____exports["技能_获取技能施法范围"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityArea(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能图标"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityArt(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_设置技能魔法施放回复后摇"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityBackSwing(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取建造技能命令编号象牙塔"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityBuildOrderId(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能魔法施放点前摇"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityCastPoint(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能魔法施法时间"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityCastTime(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能当前冷却时间"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityCool(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能魔法消耗"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityCost(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能dataA"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityDataA(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能dataB"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityDataB(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能dataC"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityDataC(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能dataD"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityDataD(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能dataE"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityDataE(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取当前禁用的内部计数"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityDisabledCount(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能持续时间普通"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityDuration(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_工程升级_获取替换后的技能编号"] = function(_____5355_4F4D, _____65E7ID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityEngineeringUpgradeNewId(_____5355_4F4D, _____65E7ID)
end
____exports["技能_工程升级_获取替换前的技能编号"] = function(_____5355_4F4D, _____65B0ID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityEngineeringUpgradeOldId(_____5355_4F4D, _____65B0ID)
end
____exports["技能_获取技能持续时间英雄"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityHeroDuration(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取当前是否禁用状态"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityIsDisabled(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能最大冷却时间"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMaxCool(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能投射物弧度"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMissileArc(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能投射物模型"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMissileArt(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能投射物数量弹幕攻击"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMissileCount(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能投射物伤害弹幕攻击"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMissileDamage(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能投射物允许自导"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMissileHoming(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能投射物最大伤害弹幕攻击"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMissileMaxDamage(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能投射物速度"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityMissileSpeed(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能命令编号"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityOrderId(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能施法距离"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityRange(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取技能等级要求"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityReqLevel(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取魔法书的技能列表"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilitySpellBookList(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能目标允许"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityTargs(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["技能_获取当前科技条件是否达成"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityTechReach(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能提示"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityTip(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取技能提示扩展"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityUberTip(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_获取建造技能单位编号象牙塔"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAbilityUnitId(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["单位_获取单位作为目标类型"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAsAttackTargetType(_____5355_4F4D)
end
____exports["单位_获取单位攻击1目标允许"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAttack1TargetType(_____5355_4F4D)
end
____exports["单位_获取单位攻击2目标允许"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAttack2TargetType(_____5355_4F4D)
end
____exports["单位_获取攻击最大目标数"] = function(_____5355_4F4D, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzGetUnitAttackTargetCount(_____5355_4F4D, _____5E8F_53F7)
end
____exports["单位_获取魔法施放回复后摇"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitBackSwing(_____5355_4F4D)
end
____exports["单位_获取魔法施放点前摇"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitCastPoint(_____5355_4F4D)
end
____exports["单位_获取单位的碰撞体积"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitCollisionSize(_____5355_4F4D)
end
____exports["单位_获取单位控制命令是否被屏蔽"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitDisableControlOrder(_____5355_4F4D)
end
____exports["单位_获取单位本地命令是否被屏蔽"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitDisableLocalOrder(_____5355_4F4D)
end
____exports["单位_获取每秒生命恢复"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitLifeRegen(_____5355_4F4D)
end
____exports["单位_获取每秒魔法恢复"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitManaRegen(_____5355_4F4D)
end
____exports["单位_获取最高移动速度"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitMaxSpeed(_____5355_4F4D)
end
____exports["单位_获取最低移动速度"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitMinSpeed(_____5355_4F4D)
end
____exports["单位_获取单位头顶高度偏移"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitOverheadOffset(_____5355_4F4D)
end
____exports["单位_获取投射物发射坐标横坐标"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitPojectileLaunchX(_____5355_4F4D)
end
____exports["单位_获取投射物发射坐标纵坐标"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitPojectileLaunchY(_____5355_4F4D)
end
____exports["单位_获取投射物发射坐标高度"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitPojectileLaunchZ(_____5355_4F4D)
end
____exports["单位_获取单位高度轴高度"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzGetUnitZ(_____5355_4F4D)
end
____exports["取单位组里单位数量"] = function(_____5355_4F4D_7EC4)
    return _____539F_751F_51FD_6570_8868.DzGroupGetCount(_____5355_4F4D_7EC4)
end
____exports["取单位组里指定索引的单位"] = function(_____5355_4F4D_7EC4, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.DzGroupGetUnitAt(_____5355_4F4D_7EC4, _____5E8F_53F7)
end
____exports["物品_获取物品大小"] = function(_____7269_54C1)
    return _____539F_751F_51FD_6570_8868.DzItemGetSize(_____7269_54C1)
end
____exports["物品_获取物品颜色"] = function(_____7269_54C1)
    return _____539F_751F_51FD_6570_8868.DzItemGetVertexColor(_____7269_54C1)
end
____exports["检查字符串是否包含指定的子字符串"] = function(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____5E03_5C143)
    return _____539F_751F_51FD_6570_8868.DzStringContains(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____5E03_5C143)
end
____exports["字符串中查找子字符串并返回其位置"] = function(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
    return _____539F_751F_51FD_6570_8868.DzStringFind(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
end
____exports["检查字符串第一个不包含指定字符串里任意字符的位置"] = function(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
    return _____539F_751F_51FD_6570_8868.DzStringFindFirstNotOf(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
end
____exports["检测字符串里第一个包含指定字符串里任意字符的位置"] = function(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
    return _____539F_751F_51FD_6570_8868.DzStringFindFirstOf(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
end
____exports["从后往前查找字符串中不包含指定字符串任意字符的所在位置"] = function(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
    return _____539F_751F_51FD_6570_8868.DzStringFindLastNotOf(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
end
____exports["从后往前查找字符串中包含指定字符串任意字符的所在位置"] = function(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
    return _____539F_751F_51FD_6570_8868.DzStringFindLastOf(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____504F_79FB, _____5E03_5C144)
end
____exports["插入字符串"] = function(_____5B57_7B26_4E321, _____4F4D_7F6E, _____76EE_6807_5B57_7B26_4E32)
    return _____539F_751F_51FD_6570_8868.DzStringInsert(_____5B57_7B26_4E321, _____4F4D_7F6E, _____76EE_6807_5B57_7B26_4E32)
end
____exports["替换字符串"] = function(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____5B57_7B26_4E323, _____5E03_5C144)
    return _____539F_751F_51FD_6570_8868.DzStringReplace(_____5B57_7B26_4E321, _____76EE_6807_5B57_7B26_4E32, _____5B57_7B26_4E323, _____5E03_5C144)
end
____exports["反转字符串"] = function(_____5B57_7B26_4E321)
    return _____539F_751F_51FD_6570_8868.DzStringReverse(_____5B57_7B26_4E321)
end
____exports["删除字符串两边的空格"] = function(_____5B57_7B26_4E321)
    return _____539F_751F_51FD_6570_8868.DzStringTrim(_____5B57_7B26_4E321)
end
____exports["删除字符串左边的空格"] = function(_____5B57_7B26_4E321)
    return _____539F_751F_51FD_6570_8868.DzStringTrimLeft(_____5B57_7B26_4E321)
end
____exports["删除字符串右边的空格"] = function(_____5B57_7B26_4E321)
    return _____539F_751F_51FD_6570_8868.DzStringTrimRight(_____5B57_7B26_4E321)
end
____exports["漂浮字_取当前漂浮文字的字体"] = function()
    return _____539F_751F_51FD_6570_8868.DzTextTagGetFont()
end
____exports["漂浮字_取漂浮文字的阴影颜色"] = function(_____7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzTextTagGetShadowColor(_____7C7B_578B)
end
____exports["单位_创建幻象单位"] = function(_____73A9_5BB6, _____5355_4F4DID, x, y, _____5B9E_65705)
    return _____539F_751F_51FD_6570_8868.DzUnitCreateIllusion(
        _____73A9_5BB6,
        _____5355_4F4DID,
        x,
        y,
        _____5B9E_65705
    )
end
____exports["单位_为单位创建幻象"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzUnitCreateIllusionFromUnit(_____5355_4F4D)
end
____exports["单位_取单位的指定技能"] = function(_____5355_4F4D, _____6280_80FD_7F16_7801)
    return _____539F_751F_51FD_6570_8868.DzUnitFindAbility(_____5355_4F4D, _____6280_80FD_7F16_7801)
end
____exports["单位_取单位的命令数量"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzUnitOrdersCount(_____5355_4F4D)
end
____exports["工作表的值实数"] = function(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
    return _____539F_751F_51FD_6570_8868.DzXlsxWorksheetGetCellFloat(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
end
____exports["工作表的值整数"] = function(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
    return _____539F_751F_51FD_6570_8868.DzXlsxWorksheetGetCellInteger(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
end
____exports["工作表的值字符串"] = function(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
    return _____539F_751F_51FD_6570_8868.DzXlsxWorksheetGetCellString(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
end
____exports["单元格的数据类型"] = function(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
    return _____539F_751F_51FD_6570_8868.DzXlsxWorksheetGetCellType(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
end
____exports["工作表的总列数"] = function(_____6574_65701, _____5B57_7B26_4E322)
    return _____539F_751F_51FD_6570_8868.DzXlsxWorksheetGetColumnCount(_____6574_65701, _____5B57_7B26_4E322)
end
____exports["工作表的总行数"] = function(_____6574_65701, _____5B57_7B26_4E322)
    return _____539F_751F_51FD_6570_8868.DzXlsxWorksheetGetRowCount(_____6574_65701, _____5B57_7B26_4E322)
end
____exports["脚本扩展_执行"] = function(_____811A_672C)
    return _____539F_751F_51FD_6570_8868.EXExecuteScript(_____811A_672C)
end
____exports["技能扩展_取整数数据"] = function(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXGetAbilityDataInteger(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B)
end
____exports["技能扩展_取实数数据"] = function(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXGetAbilityDataReal(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B)
end
____exports["技能扩展_取字符串数据"] = function(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXGetAbilityDataString(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B)
end
____exports["技能扩展_取编号"] = function(_____6280_80FD)
    return _____539F_751F_51FD_6570_8868.EXGetAbilityId(_____6280_80FD)
end
____exports["技能扩展_取状态"] = function(_____6280_80FD, _____72B6_6001_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXGetAbilityState(_____6280_80FD, _____72B6_6001_7C7B_578B)
end
____exports["物品扩展_取字符串数据"] = function(_____7269_54C1_7F16_7801, _____6570_636E_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXGetItemDataString(_____7269_54C1_7F16_7801, _____6570_636E_7C7B_578B)
end
____exports["单位扩展_取技能"] = function(_____5355_4F4D, _____6280_80FD_7F16_7801)
    return _____539F_751F_51FD_6570_8868.EXGetUnitAbility(_____5355_4F4D, _____6280_80FD_7F16_7801)
end
____exports["单位扩展_按序号取技能"] = function(_____5355_4F4D, _____5E8F_53F7)
    return _____539F_751F_51FD_6570_8868.EXGetUnitAbilityByIndex(_____5355_4F4D, _____5E8F_53F7)
end
____exports["平台扩展_玩家平台该地图成就点数"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiAchievementPoints(_____73A9_5BB6)
end
____exports["平台扩展_取玩家在指定地图会员等级"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.KKApiConsumeLevel(_____73A9_5BB6, _____5730_56FEID)
end
____exports["平台扩展_取玩家当天总游戏局数"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiDayRounds(_____73A9_5BB6)
end
____exports["平台扩展_取随机数的组编号"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiGetBackendLogicGroup(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_取随机数的值"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiGetBackendLogicIntResult(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_取随机数的值_2"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiGetBackendLogicStrResult(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_取随机数的生成时间"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiGetBackendLogicUpdateTime(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_取赛事模式"] = function()
    return _____539F_751F_51FD_6570_8868.KKApiGetCompetitionGameMode()
end
____exports["平台扩展_玩家在公会的等级"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiGetGuildLevel(_____73A9_5BB6)
end
____exports["平台扩展_取天梯投降的队伍编号"] = function()
    return _____539F_751F_51FD_6570_8868.KKApiGetLadderSurrenderTeamId()
end
____exports["平台扩展_事件响应_商城道具最后变动的数量"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiGetMallItemUpdateCount(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_取地图版本号"] = function()
    return _____539F_751F_51FD_6570_8868.KKApiGetMapVersion()
end
____exports["平台扩展_取服务器存档限制余额"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiGetServerValueLimitLeft(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_取变动的随机存档"] = function()
    return _____539F_751F_51FD_6570_8868.KKApiGetSyncBackendLogic()
end
____exports["平台扩展_转换时间戳为具体时间"] = function(_____65F6_95F4_6233)
    return _____539F_751F_51FD_6570_8868.KKAPIGetTimeDateFromTimestamp(_____65F6_95F4_6233)
end
____exports["平台扩展_取时间戳日份"] = function(_____65F6_95F4_6233)
    return _____539F_751F_51FD_6570_8868.KKAPIGetTimestampDay(_____65F6_95F4_6233)
end
____exports["平台扩展_取时间戳月份"] = function(_____65F6_95F4_6233)
    return _____539F_751F_51FD_6570_8868.KKAPIGetTimestampMonth(_____65F6_95F4_6233)
end
____exports["平台扩展_取时间戳年份"] = function(_____65F6_95F4_6233)
    return _____539F_751F_51FD_6570_8868.KKAPIGetTimestampYear(_____65F6_95F4_6233)
end
____exports["平台扩展_宠物探险次数"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiMapExplorationNum(_____73A9_5BB6)
end
____exports["平台扩展_宠物探险时间"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiMapExplorationTime(_____73A9_5BB6)
end
____exports["平台扩展_测试大厅预约人数"] = function()
    return _____539F_751F_51FD_6570_8868.KKApiMapOrderNum()
end
____exports["平台扩展_取玩家的平台编号"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiPlayerGUID(_____73A9_5BB6)
end
____exports["平台扩展_玩家地图任务当前进度"] = function(_____73A9_5BB6, _____6574_65702)
    return _____539F_751F_51FD_6570_8868.KKApiQueryTaskCurrentProgress(_____73A9_5BB6, _____6574_65702)
end
____exports["平台扩展_玩家地图任务总进度"] = function(_____73A9_5BB6, _____6574_65702)
    return _____539F_751F_51FD_6570_8868.KKApiQueryTaskTotalProgress(_____73A9_5BB6, _____6574_65702)
end
____exports["平台扩展_剩余次数"] = function(_____73A9_5BB6, _____5206_7EC4_952E)
    return _____539F_751F_51FD_6570_8868.KKApiRandomSaveGameCount(_____73A9_5BB6, _____5206_7EC4_952E)
end
____exports["平台扩展_技能按钮_获取按钮上的技能编号"] = function(_____6574_65701)
    return _____539F_751F_51FD_6570_8868.KKCommandButtonGetAbilityId(_____6574_65701)
end
____exports["平台扩展_技能按钮_获取按钮上的命令编号"] = function(_____6574_65701)
    return _____539F_751F_51FD_6570_8868.KKCommandButtonGetOrderId(_____6574_65701)
end
____exports["平台扩展_界面_获取技能_物品按钮的冷却模型控件"] = function(_____6574_65701)
    return _____539F_751F_51FD_6570_8868.KKCommandGetCooldownModel(_____6574_65701)
end
____exports["平台扩展_转化_技能编号为整数"] = function(_____6574_6570_503C)
    return _____539F_751F_51FD_6570_8868.KKConvertAbilId2Int(_____6574_6570_503C)
end
____exports["平台扩展_转化_转颜色为整数"] = function(_____6574_6570_503C)
    return _____539F_751F_51FD_6570_8868.KKConvertColor2Int(_____6574_6570_503C)
end
____exports["平台扩展_转化_整数为技能编号"] = function(_____6574_6570_503C)
    return _____539F_751F_51FD_6570_8868.KKConvertInt2AbilId(_____6574_6570_503C)
end
____exports["平台扩展_转化_转整数为颜色"] = function(_____6574_6570_503C)
    return _____539F_751F_51FD_6570_8868.KKConvertInt2Color(_____6574_6570_503C)
end
____exports["界面_取颜色"] = function(_____900F_660E_5EA6, _____7EA2, _____7EFF, _____84DD)
    return _____539F_751F_51FD_6570_8868.DzGetColor(_____900F_660E_5EA6, _____7EA2, _____7EFF, _____84DD)
end
____exports["平台扩展_技能_创建技能按钮控件"] = function()
    return _____539F_751F_51FD_6570_8868.KKCreateCommandButton()
end
____exports["请求额外_整数数据"] = function(_____6570_636E_7C7B_578B, _____73A9_5BB6, _____5B57_7B26_4E323, _____5B57_7B26_4E324, _____5E03_5C145, _____6574_65706, _____6574_65707, _____6574_65708)
    return _____539F_751F_51FD_6570_8868.RequestExtraIntegerData(
        _____6570_636E_7C7B_578B,
        _____73A9_5BB6,
        _____5B57_7B26_4E323,
        _____5B57_7B26_4E324,
        _____5E03_5C145,
        _____6574_65706,
        _____6574_65707,
        _____6574_65708
    )
end
____exports["请求额外_实数数据"] = function(_____6570_636E_7C7B_578B, _____73A9_5BB6, _____5B57_7B26_4E323, _____5B57_7B26_4E324, _____5E03_5C145, _____6574_65706, _____6574_65707, _____6574_65708)
    return _____539F_751F_51FD_6570_8868.RequestExtraRealData(
        _____6570_636E_7C7B_578B,
        _____73A9_5BB6,
        _____5B57_7B26_4E323,
        _____5B57_7B26_4E324,
        _____5E03_5C145,
        _____6574_65706,
        _____6574_65707,
        _____6574_65708
    )
end
____exports["请求额外_字符串数据"] = function(_____6570_636E_7C7B_578B, _____73A9_5BB6, _____5B57_7B26_4E323, _____5B57_7B26_4E324, _____5E03_5C145, _____6574_65706, _____6574_65707, _____6574_65708)
    return _____539F_751F_51FD_6570_8868.RequestExtraStringData(
        _____6570_636E_7C7B_578B,
        _____73A9_5BB6,
        _____5B57_7B26_4E323,
        _____5B57_7B26_4E324,
        _____5E03_5C145,
        _____6574_65706,
        _____6574_65707,
        _____6574_65708
    )
end
return ____exports
