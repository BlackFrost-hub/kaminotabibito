--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5E73_53F0_539F_751F_8868 = require("jass.japi")
local _____539F_751F_51FD_6570_8868 = _____5E73_53F0_539F_751F_8868
____exports["地图_关闭U币快速购买界面"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_CancelQuickBuy(_____73A9_5BB6)
end
____exports["地图_使用地图商城道具数量型"] = function(_____73A9_5BB6, _____952E_540D, _____6570_91CF)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_ConsumeMallItem(_____73A9_5BB6, _____952E_540D, _____6570_91CF)
end
____exports["地图_开启_关闭游戏内辅助功能"] = function(_____73A9_5BB6, _____9009_9879, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_EnablePlatformSettings(_____73A9_5BB6, _____9009_9879, _____662F_5426_542F_7528)
end
____exports["地图_取服务器上的布尔变量"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GetStoredBoolean(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_玩家是否拥有地图商城道具"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_HasMallItem(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_玩家是否当前地图作者"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsAuthor(_____73A9_5BB6)
end
____exports["地图_玩家是否平台认证的主播"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsBlueVIP(_____73A9_5BB6)
end
____exports["地图_玩家是否平台认证的鉴赏家"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsConnoisseur(_____73A9_5BB6)
end
____exports["地图_本局游戏是否处于平台自测服"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsMapTest()
end
____exports["地图_玩家是否平台尊享会员"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsPlatformVIP(_____73A9_5BB6)
end
____exports["地图_玩家是否为真实玩家"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsPlayer(_____73A9_5BB6)
end
____exports["地图_玩家是否装备指定平台装饰"] = function(_____73A9_5BB6, _____76AE_80A4_7C7B_578B, ID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsPlayerUsingSkin(_____73A9_5BB6, _____76AE_80A4_7C7B_578B, ID)
end
____exports["地图_玩家是否平台认证的职业选手"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsRedVIP(_____73A9_5BB6)
end
____exports["地图_本局游戏是否天梯排位赛"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsRPGLadder()
end
____exports["地图_本局游戏是否处于角色扮演游戏大厅"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsRPGLobby()
end
____exports["地图_本局游戏是否快速匹配"] = function()
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_IsRPGQuickMatch()
end
____exports["地图_玩家在指定地图累计消费金额区间1到199"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsConsumeLv1(_____73A9_5BB6, _____5730_56FEID)
end
____exports["地图_玩家在指定地图累计消费金额区间200到499"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsConsumeLv2(_____73A9_5BB6, _____5730_56FEID)
end
____exports["地图_玩家在指定地图累计消费金额区间500到999"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsConsumeLv3(_____73A9_5BB6, _____5730_56FEID)
end
____exports["地图_玩家在指定地图累计消费金额区间1000以上"] = function(_____73A9_5BB6, _____5730_56FEID)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MapsConsumeLv4(_____73A9_5BB6, _____5730_56FEID)
end
____exports["地图_打开地图商城道具购买界面"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_OpenMall(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_玩家标记"] = function(_____73A9_5BB6, _____6807_7B7E)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_PlayerFlags(_____73A9_5BB6, _____6807_7B7E)
end
____exports["地图_玩家地图商城道具是否读取成功"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_PlayerLoadedItems(_____73A9_5BB6)
end
____exports["地图_使用U币快速购买地图商城道具"] = function(_____73A9_5BB6, _____952E_540D, _____6570_91CF, _____79D2_6570)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_QuickBuy(_____73A9_5BB6, _____952E_540D, _____6570_91CF, _____79D2_6570)
end
____exports["地图_是否回流_收藏过地图的用户"] = function(_____73A9_5BB6, _____6807_7B7E)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Returns(_____73A9_5BB6, _____6807_7B7E)
end
____exports["地图_保存服务器存档组"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_SavePublicArchive(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_保存服务器存档_2"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_SaveServerValue(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["界面_获取复选框勾选状态"] = function(_____52FE_9009_6846_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameGetCheckBoxState(_____52FE_9009_6846_754C_9762)
end
____exports["界面_是否有指定锚点"] = function(_____754C_9762, _____951A_70B9)
    return _____539F_751F_51FD_6570_8868.DzFrameGetPointValid(_____754C_9762, _____951A_70B9)
end
____exports["界面_获取控件是否焦点"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameIsFocus(_____754C_9762)
end
____exports["聊天框是否打开"] = function()
    return _____539F_751F_51FD_6570_8868.DzIsChatBoxOpen()
end
____exports["是否闰年"] = function(_____5E74)
    return _____539F_751F_51FD_6570_8868.DzIsLeapYear(_____5E74)
end
____exports["是否单位攻击类型"] = function(_____5355_4F4D, _____5E8F_53F7, _____653B_51FB_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzIsUnitAttackType(_____5355_4F4D, _____5E8F_53F7, _____653B_51FB_7C7B_578B)
end
____exports["是否单位防御类型"] = function(_____5355_4F4D, _____9632_5FA1_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzIsUnitDefenseType(_____5355_4F4D, _____9632_5FA1_7C7B_578B)
end
____exports["硬件_当前游戏窗口是否活动窗口"] = function()
    return _____539F_751F_51FD_6570_8868.DzIsWindowActive()
end
____exports["硬件_当前游戏是否窗口化模式"] = function()
    return _____539F_751F_51FD_6570_8868.DzIsWindowMode()
end
____exports["单位_杀死指定凶手"] = function(_____5355_4F4D, _____5355_4F4D2)
    return _____539F_751F_51FD_6570_8868.DzKillUnit(_____5355_4F4D, _____5355_4F4D2)
end
____exports["投射物_发射炮火"] = function(_____6765_6E90, _____76EE_6807, _____5B9E_65703, _____5B9E_65704, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272, _____989C_8272, x, y, z, _____7F29_653E, _____901F_5EA6, _____653B_51FB_7C7B_578B, _____4F24_5BB3_7C7B_578B, _____53C2_657015, _____4F24_5BB3, _____5F27_5EA6, _____653B_51FB, _____6807_8BB0, _____5B9E_657020, _____76EE_6807_6807_8BB0, _____5B9E_657022, _____5B9E_657023, _____5B9E_657024, _____5B9E_657025, _____5B9E_657026)
    return _____539F_751F_51FD_6570_8868.DzLaunchArtillery(
        _____6765_6E90,
        _____76EE_6807,
        _____5B9E_65703,
        _____5B9E_65704,
        _____6A21_578B_8DEF_5F84,
        _____961F_4F0D_989C_8272,
        _____989C_8272,
        x,
        y,
        z,
        _____7F29_653E,
        _____901F_5EA6,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____53C2_657015,
        _____4F24_5BB3,
        _____5F27_5EA6,
        _____653B_51FB,
        _____6807_8BB0,
        _____5B9E_657020,
        _____76EE_6807_6807_8BB0,
        _____5B9E_657022,
        _____5B9E_657023,
        _____5B9E_657024,
        _____5B9E_657025,
        _____5B9E_657026
    )
end
____exports["投射物_发射炮火穿透"] = function(_____6765_6E90, _____76EE_6807, _____5B9E_65703, _____5B9E_65704, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272, _____989C_8272, x, y, z, _____7F29_653E, _____901F_5EA6, _____653B_51FB_7C7B_578B, _____4F24_5BB3_7C7B_578B, _____53C2_657015, _____4F24_5BB3, _____5F27_5EA6, _____653B_51FB, _____6807_8BB0, _____5B9E_657020, _____76EE_6807_6807_8BB0, _____5B9E_657022, _____5B9E_657023, _____5B9E_657024, _____5B9E_657025, _____5B9E_657026, _____5B9E_657027, _____5B9E_657028, _____8303_56F4)
    return _____539F_751F_51FD_6570_8868.DzLaunchArtilleryLine(
        _____6765_6E90,
        _____76EE_6807,
        _____5B9E_65703,
        _____5B9E_65704,
        _____6A21_578B_8DEF_5F84,
        _____961F_4F0D_989C_8272,
        _____989C_8272,
        x,
        y,
        z,
        _____7F29_653E,
        _____901F_5EA6,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____53C2_657015,
        _____4F24_5BB3,
        _____5F27_5EA6,
        _____653B_51FB,
        _____6807_8BB0,
        _____5B9E_657020,
        _____76EE_6807_6807_8BB0,
        _____5B9E_657022,
        _____5B9E_657023,
        _____5B9E_657024,
        _____5B9E_657025,
        _____5B9E_657026,
        _____5B9E_657027,
        _____5B9E_657028,
        _____8303_56F4
    )
end
____exports["投射物_发射箭矢"] = function(_____6765_6E90, _____76EE_6807, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272, _____989C_8272, x, y, z, _____7F29_653E, _____901F_5EA6, _____653B_51FB_7C7B_578B, _____4F24_5BB3_7C7B_578B, _____53C2_657013, _____4F24_5BB3, _____5F27_5EA6, _____8FFD_8E2A, _____5E03_5C1417, _____5E03_5C1418, _____653B_51FB, _____6807_8BB0)
    return _____539F_751F_51FD_6570_8868.DzLaunchMissile(
        _____6765_6E90,
        _____76EE_6807,
        _____6A21_578B_8DEF_5F84,
        _____961F_4F0D_989C_8272,
        _____989C_8272,
        x,
        y,
        z,
        _____7F29_653E,
        _____901F_5EA6,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____53C2_657013,
        _____4F24_5BB3,
        _____5F27_5EA6,
        _____8FFD_8E2A,
        _____5E03_5C1417,
        _____5E03_5C1418,
        _____653B_51FB,
        _____6807_8BB0
    )
end
____exports["投射物_发射箭矢弹射"] = function(_____6765_6E90, _____76EE_6807, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272, _____989C_8272, x, y, z, _____7F29_653E, _____901F_5EA6, _____653B_51FB_7C7B_578B, _____4F24_5BB3_7C7B_578B, _____53C2_657013, _____4F24_5BB3, _____5F27_5EA6, _____8FFD_8E2A, _____5E03_5C1417, _____5E03_5C1418, _____653B_51FB, _____6807_8BB0, _____76EE_6807_6807_8BB0, _____76EE_6807_6570_91CF, _____5F39_8DF3_8303_56F4, _____5B9E_657024)
    return _____539F_751F_51FD_6570_8868.DzLaunchMissileBounce(
        _____6765_6E90,
        _____76EE_6807,
        _____6A21_578B_8DEF_5F84,
        _____961F_4F0D_989C_8272,
        _____989C_8272,
        x,
        y,
        z,
        _____7F29_653E,
        _____901F_5EA6,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____53C2_657013,
        _____4F24_5BB3,
        _____5F27_5EA6,
        _____8FFD_8E2A,
        _____5E03_5C1417,
        _____5E03_5C1418,
        _____653B_51FB,
        _____6807_8BB0,
        _____76EE_6807_6807_8BB0,
        _____76EE_6807_6570_91CF,
        _____5F39_8DF3_8303_56F4,
        _____5B9E_657024
    )
end
____exports["投射物_发射技能投射物腐臭蜂群"] = function(_____6765_6E90, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272, _____989C_8272, x, y, z, _____671D_5411, _____5B9E_65709, _____7F29_653E, _____901F_5EA6, _____653B_51FB_7C7B_578B, _____4F24_5BB3_7C7B_578B, _____53C2_657014, _____4F24_5BB3, _____6807_8BB0, _____76EE_6807_6807_8BB0, _____5B9E_657018, _____5B9E_657019, _____6700_5927_4F24_5BB3, _____589E_76CAID)
    return _____539F_751F_51FD_6570_8868.DzLaunchMissileCarrionSwarmEx(
        _____6765_6E90,
        _____6A21_578B_8DEF_5F84,
        _____961F_4F0D_989C_8272,
        _____989C_8272,
        x,
        y,
        z,
        _____671D_5411,
        _____5B9E_65709,
        _____7F29_653E,
        _____901F_5EA6,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____53C2_657014,
        _____4F24_5BB3,
        _____6807_8BB0,
        _____76EE_6807_6807_8BB0,
        _____5B9E_657018,
        _____5B9E_657019,
        _____6700_5927_4F24_5BB3,
        _____589E_76CAID
    )
end
____exports["投射物_发射箭矢穿透"] = function(_____6765_6E90, _____76EE_6807, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272, _____989C_8272, x, y, z, _____7F29_653E, _____901F_5EA6, _____653B_51FB_7C7B_578B, _____4F24_5BB3_7C7B_578B, _____53C2_657013, _____4F24_5BB3, _____5F27_5EA6, _____8FFD_8E2A, _____5E03_5C1417, _____5E03_5C1418, _____653B_51FB, _____6807_8BB0, _____76EE_6807_6807_8BB0, _____5B9E_657022, _____5B9E_657023, _____8303_56F4)
    return _____539F_751F_51FD_6570_8868.DzLaunchMissileLine(
        _____6765_6E90,
        _____76EE_6807,
        _____6A21_578B_8DEF_5F84,
        _____961F_4F0D_989C_8272,
        _____989C_8272,
        x,
        y,
        z,
        _____7F29_653E,
        _____901F_5EA6,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____53C2_657013,
        _____4F24_5BB3,
        _____5F27_5EA6,
        _____8FFD_8E2A,
        _____5E03_5C1417,
        _____5E03_5C1418,
        _____653B_51FB,
        _____6807_8BB0,
        _____76EE_6807_6807_8BB0,
        _____5B9E_657022,
        _____5B9E_657023,
        _____8303_56F4
    )
end
____exports["投射物_发射箭矢溅射"] = function(_____6765_6E90, _____76EE_6807, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272, _____989C_8272, x, y, z, _____7F29_653E, _____901F_5EA6, _____653B_51FB_7C7B_578B, _____4F24_5BB3_7C7B_578B, _____53C2_657013, _____4F24_5BB3, _____5F27_5EA6, _____8FFD_8E2A, _____5E03_5C1417, _____5E03_5C1418, _____653B_51FB, _____6807_8BB0, _____76EE_6807_6807_8BB0, _____5B9E_657022, _____5B9E_657023, _____5B9E_657024, _____5B9E_657025, _____5B9E_657026)
    return _____539F_751F_51FD_6570_8868.DzLaunchMissileSplash(
        _____6765_6E90,
        _____76EE_6807,
        _____6A21_578B_8DEF_5F84,
        _____961F_4F0D_989C_8272,
        _____989C_8272,
        x,
        y,
        z,
        _____7F29_653E,
        _____901F_5EA6,
        _____653B_51FB_7C7B_578B,
        _____4F24_5BB3_7C7B_578B,
        _____53C2_657013,
        _____4F24_5BB3,
        _____5F27_5EA6,
        _____8FFD_8E2A,
        _____5E03_5C1417,
        _____5E03_5C1418,
        _____653B_51FB,
        _____6807_8BB0,
        _____76EE_6807_6807_8BB0,
        _____5B9E_657022,
        _____5B9E_657023,
        _____5B9E_657024,
        _____5B9E_657025,
        _____5B9E_657026
    )
end
____exports["坐标_是否可以能够通过物体"] = function(x, y, _____78B0_649E_5927_5C0F, _____78B0_649E_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzPositionCanPlaceAround(x, y, _____78B0_649E_5927_5C0F, _____78B0_649E_7C7B_578B)
end
____exports["对单位组添加命令到队列无目标"] = function(_____5355_4F4D_7EC4, _____547D_4EE4ID)
    return _____539F_751F_51FD_6570_8868.DzQueueGroupImmediateOrderById(_____5355_4F4D_7EC4, _____547D_4EE4ID)
end
____exports["对单位组添加命令到队列指定坐标"] = function(_____5355_4F4D_7EC4, _____547D_4EE4ID, x, y)
    return _____539F_751F_51FD_6570_8868.DzQueueGroupPointOrderById(_____5355_4F4D_7EC4, _____547D_4EE4ID, x, y)
end
____exports["队列_单位组目标命令按编号"] = function(_____5355_4F4D_7EC4, _____547D_4EE4ID, _____76EE_6807_63A7_4EF6)
    return _____539F_751F_51FD_6570_8868.DzQueueGroupTargetOrderById(_____5355_4F4D_7EC4, _____547D_4EE4ID, _____76EE_6807_63A7_4EF6)
end
____exports["对单位添加建造命令到队列"] = function(_____519C_6C11, _____5355_4F4DID, x, y)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueBuildOrderById(_____519C_6C11, _____5355_4F4DID, x, y)
end
____exports["对单位添加命令到队列无目标"] = function(_____5355_4F4D, _____547D_4EE4ID)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueImmediateOrderById(_____5355_4F4D, _____547D_4EE4ID)
end
____exports["队列_下达瞬时点位命令按编号"] = function(_____5355_4F4D, _____547D_4EE4ID, x, y, _____77AC_65F6_76EE_6807_63A7_4EF6)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueInstantPointOrderById(
        _____5355_4F4D,
        _____547D_4EE4ID,
        x,
        y,
        _____77AC_65F6_76EE_6807_63A7_4EF6
    )
end
____exports["队列_下达瞬时目标命令按编号"] = function(_____5355_4F4D, _____547D_4EE4ID, _____76EE_6807_63A7_4EF6, _____77AC_65F6_76EE_6807_63A7_4EF6)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueInstantTargetOrderById(_____5355_4F4D, _____547D_4EE4ID, _____76EE_6807_63A7_4EF6, _____77AC_65F6_76EE_6807_63A7_4EF6)
end
____exports["队列_下达中立目标命令按编号"] = function(_____5F52_5C5E_73A9_5BB6, _____4E2D_7ACB_5EFA_7B51, _____5355_4F4DID, _____76EE_6807)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueNeutralTargetOrderById(_____5F52_5C5E_73A9_5BB6, _____4E2D_7ACB_5EFA_7B51, _____5355_4F4DID, _____76EE_6807)
end
____exports["对单位添加命令到队列指定坐标"] = function(_____5355_4F4D, _____547D_4EE4ID, x, y)
    return _____539F_751F_51FD_6570_8868.DzQueueIssuePointOrderById(_____5355_4F4D, _____547D_4EE4ID, x, y)
end
____exports["队列_下达目标命令按编号"] = function(_____5355_4F4D, _____547D_4EE4ID, _____76EE_6807_63A7_4EF6)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueTargetOrderById(_____5355_4F4D, _____547D_4EE4ID, _____76EE_6807_63A7_4EF6)
end
____exports["单位_是否可以被放置到坐标"] = function(_____5BF9_8C61, x, y)
    return _____539F_751F_51FD_6570_8868.DzUnitCanPlaceAround(_____5BF9_8C61, x, y)
end
____exports["单位_技能_判断单位是否拥有技能包含模版技能"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.DzUnitHasAbility(_____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["工作表的值布尔值"] = function(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
    return _____539F_751F_51FD_6570_8868.DzXlsxWorksheetGetCellBoolean(_____6574_65701, _____5B57_7B26_4E322, _____884C, _____5217)
end
____exports["平台扩展_是否随机数是否存在"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiCheckBackendLogicExists(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_玩家平台该地图成就是否完成"] = function(_____73A9_5BB6, ID)
    return _____539F_751F_51FD_6570_8868.KKApiIsAchievementCompleted(_____73A9_5BB6, ID)
end
____exports["平台扩展_是否在平台正常游戏中"] = function()
    return _____539F_751F_51FD_6570_8868.KKApiIsGameMode()
end
____exports["平台扩展_是否玩家当前地图在游戏大厅置顶状态"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiIsPinned(_____73A9_5BB6)
end
____exports["平台扩展_玩家地图任务状态"] = function(_____73A9_5BB6, _____6574_65702, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKApiIsTaskInProgress(_____73A9_5BB6, _____6574_65702, _____6574_65703)
end
____exports["平台扩展_发送云脚本数据"] = function(_____73A9_5BB6, _____4E8B_4EF6_540D_79F0, _____5B57_7B26_4E323)
    return _____539F_751F_51FD_6570_8868.KKApiMlScriptEvent(_____73A9_5BB6, _____4E8B_4EF6_540D_79F0, _____5B57_7B26_4E323)
end
____exports["平台扩展_判定测试大厅游戏时长区间"] = function(_____73A9_5BB6, _____6700_5C0F_65F6_957F, _____6700_5927_65F6_957F)
    return _____539F_751F_51FD_6570_8868.KKApiPlayedTime(_____73A9_5BB6, _____6700_5C0F_65F6_957F, _____6700_5927_65F6_957F)
end
____exports["平台扩展_取玩家身份类型"] = function(_____73A9_5BB6, ID)
    return _____539F_751F_51FD_6570_8868.KKApiPlayerIdentityType(_____73A9_5BB6, ID)
end
____exports["平台扩展_随机只读存档删除随机数"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.KKApiRemoveBackendLogicResult(_____73A9_5BB6, _____952E_540D)
end
____exports["平台扩展_技能按钮_目标指示器点击目标单位"] = function(_____9F20_6807_7C7B_578B, _____76EE_6807)
    return _____539F_751F_51FD_6570_8868.KKCommandTargetClick(_____9F20_6807_7C7B_578B, _____76EE_6807)
end
____exports["平台扩展_技能按钮_目标指示器点击地面坐标"] = function(_____9F20_6807_7C7B_578B, x, y, z)
    return _____539F_751F_51FD_6570_8868.KKCommandTerrainClick(_____9F20_6807_7C7B_578B, x, y, z)
end
____exports["平台扩展_点_是否可以能够通过物体"] = function(_____70B9, _____78B0_649E_5927_5C0F, _____78B0_649E_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.KKPositionCanPlaceAroundLoc(_____70B9, _____78B0_649E_5927_5C0F, _____78B0_649E_7C7B_578B)
end
____exports["平台扩展_界面_判断SimpleFrame类型控件是否显示"] = function(_____7B80_5355_754C_9762)
    return _____539F_751F_51FD_6570_8868.KKSimpleFrameIsVisible(_____7B80_5355_754C_9762)
end
____exports["平台扩展_单位_是否可以被放置到点"] = function(_____5BF9_8C61, _____70B9)
    return _____539F_751F_51FD_6570_8868.KKUnitCanPlaceAroundLoc(_____5BF9_8C61, _____70B9)
end
____exports["平台扩展_物品_是否可以被放置到点"] = function(_____5BF9_8C61, _____70B9)
    return _____539F_751F_51FD_6570_8868.KKUnitCanPlaceAroundLocItem(_____5BF9_8C61, _____70B9)
end
____exports["请求额外_布尔数据"] = function(_____6570_636E_7C7B_578B, _____73A9_5BB6, _____5B57_7B26_4E323, _____5B57_7B26_4E324, _____5E03_5C145, _____6574_65706, _____6574_65707, _____6574_65708)
    return _____539F_751F_51FD_6570_8868.RequestExtraBooleanData(
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
