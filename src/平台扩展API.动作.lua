--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____5E73_53F0_539F_751F_8868 = require("jass.japi")
local _____539F_751F_51FD_6570_8868 = _____5E73_53F0_539F_751F_8868
____exports["设技能启用_禁用"] = function(_____6280_80FD, _____662F_5426_542F_7528, _____662F_5426_9690_85CF_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzAbilitySetEnable(_____6280_80FD, _____662F_5426_542F_7528, _____662F_5426_9690_85CF_754C_9762)
end
____exports["设技能数据_字符串"] = function(_____6280_80FD, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAbilitySetStringData(_____6280_80FD, _____952E_540D, _____503C)
end
____exports["地图_清理服务器数据"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_FlushStoredMission(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_上报本局游戏玩家数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GameResult_CommitData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_上报本局游戏模式"] = function(_____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GameResult_CommitGameMode(_____503C)
end
____exports["地图_上报本局游戏结果"] = function(_____73A9_5BB6, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GameResult_CommitGameResult(_____73A9_5BB6, _____503C)
end
____exports["地图_上报本局游戏结果不结束游戏"] = function(_____73A9_5BB6, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GameResult_CommitGameResultNoEnd(_____73A9_5BB6, _____503C)
end
____exports["地图_上报本局游戏玩家排名"] = function(_____73A9_5BB6, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GameResult_CommitPlayerRank(_____73A9_5BB6, _____503C)
end
____exports["地图_上报本局游戏玩家称号"] = function(_____73A9_5BB6, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_GameResult_CommitTitle(_____73A9_5BB6, _____503C)
end
____exports["地图_全局修改消息"] = function(_____89E6_53D1_5668)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Global_ChangeMsg(_____89E6_53D1_5668)
end
____exports["地图_保存全局存档"] = function(_____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Global_StoreString(_____952E_540D, _____503C)
end
____exports["地图_天梯设玩家统计"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SetPlayerStat(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯提交字符串数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SetStat(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯提交技能数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitAblityIdData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯提交布尔值数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitBooleanData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯提交整数数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitIntegerData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯提交物品数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitItemData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯提交物品数据_2"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitItemIdData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯设置玩家额外分"] = function(_____73A9_5BB6, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitPlayerExtraExp(_____73A9_5BB6, _____503C)
end
____exports["地图_天梯提交玩家排名"] = function(_____73A9_5BB6, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitPlayerRank(_____73A9_5BB6, _____503C)
end
____exports["地图_天梯提交获得称号"] = function(_____73A9_5BB6, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Ladder_SubmitTitle(_____73A9_5BB6, _____503C)
end
____exports["地图_任务完成"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_MissionComplete(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_触发BOSS击杀"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_OrpgTrigger(_____73A9_5BB6, _____952E_540D)
end
____exports["地图_保存服务器存档"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_SaveServerArchive(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_上报房间内显示的数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Stat_SetStat(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_统计提交单位数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Stat_SubmitUnitData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_天梯提交单位类型数据"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Stat_SubmitUnitIdData(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_上报埋点数据"] = function(_____73A9_5BB6, _____4E8B_4EF6_952E, _____4E8B_4EF6_7C7B_578B, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_Statistics(_____73A9_5BB6, _____4E8B_4EF6_952E, _____4E8B_4EF6_7C7B_578B, _____503C)
end
____exports["地图_保存布尔值变量至服务器"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_StoreBoolean(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_保存整数变量至服务器"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_StoreInteger(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_服务器存储整数"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_StoreIntegerEX(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_保存实数变量至服务器"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_StoreReal(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_保存字符串变量至服务器"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_StoreString(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_服务器存储字符串"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_StoreStringEX(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["地图_使用地图商城道具局数型"] = function(_____73A9_5BB6, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzAPI_Map_UseConsumablesItem(_____73A9_5BB6, _____952E_540D)
end
____exports["结束普攻技能CD"] = function(_____53E5_67C4)
    return _____539F_751F_51FD_6570_8868.DzAttackAbilityEndCooldown(_____53E5_67C4)
end
____exports["绑定特效"] = function(_____7236_754C_9762, _____9644_7740_70B9, _____7279_6548)
    return _____539F_751F_51FD_6570_8868.DzBindEffect(_____7236_754C_9762, _____9644_7740_70B9, _____7279_6548)
end
____exports["设整数的2进制的位值"] = function(_____6574_6570_503C, _____5B57_8282_5E8F_53F7, _____5B57_8282_503C)
    return _____539F_751F_51FD_6570_8868.DzBitSet(_____6574_6570_503C, _____5B57_8282_5E8F_53F7, _____5B57_8282_503C)
end
____exports["设整数的256进制的位值"] = function(_____6574_6570_503C, _____5B57_8282_5E8F_53F7, _____5B57_8282_503C)
    return _____539F_751F_51FD_6570_8868.DzBitSetByte(_____6574_6570_503C, _____5B57_8282_5E8F_53F7, _____5B57_8282_503C)
end
____exports["设魔兽窗口大小"] = function(_____5BBD_5EA6, _____9AD8_5EA6)
    return _____539F_751F_51FD_6570_8868.DzChangeWindowSize(_____5BBD_5EA6, _____9AD8_5EA6)
end
____exports["界面_创建"] = function(_____540D_79F0, _____7236_754C_9762, ID)
    return _____539F_751F_51FD_6570_8868.DzCreateFrame(_____540D_79F0, _____7236_754C_9762, ID)
end
____exports["界面_按标签创建"] = function(_____7C7B_578B, _____540D_79F0, _____7236_754C_9762, _____6A21_677F, ID)
    return _____539F_751F_51FD_6570_8868.DzCreateFrameByTagName(
        _____7C7B_578B,
        _____540D_79F0,
        _____7236_754C_9762,
        _____6A21_677F,
        ID
    )
end
____exports["游戏_禁用攻速限制"] = function()
    return _____539F_751F_51FD_6570_8868.DzDisableAttackSpeedLimit()
end
____exports["游戏_屏蔽按键游戏UI消息"] = function(_____73A9_5BB6, _____952E_7801)
    return _____539F_751F_51FD_6570_8868.DzDisableGameUIKeyboard(_____73A9_5BB6, _____952E_7801)
end
____exports["界面_屏蔽所有物品指向UI"] = function()
    return _____539F_751F_51FD_6570_8868.DzDisableItemPreselectUi()
end
____exports["界面_屏蔽所有单位指向UI跟血条"] = function()
    return _____539F_751F_51FD_6570_8868.DzDisableUnitPreselectUi()
end
____exports["游戏_屏蔽按键窗口消息"] = function(_____73A9_5BB6, _____952E_7801)
    return _____539F_751F_51FD_6570_8868.DzDisableWindowKeyboard(_____73A9_5BB6, _____952E_7801)
end
____exports["装饰物_删除装饰物"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadRemove(_____88C5_9970_7269)
end
____exports["装饰物_装饰物播放动画"] = function(_____88C5_9970_7269, _____52A8_753B_540D, _____662F_5426_968F_673A_52A8_753B)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetAnimation(_____88C5_9970_7269, _____52A8_753B_540D, _____662F_5426_968F_673A_52A8_753B)
end
____exports["装饰物_设装饰物颜色"] = function(_____88C5_9970_7269, _____989C_8272)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetColor(_____88C5_9970_7269, _____989C_8272)
end
____exports["装饰物_设装饰物模型"] = function(_____88C5_9970_7269, _____6A21_578B_8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetModel(_____88C5_9970_7269, _____6A21_578B_8DEF_5F84)
end
____exports["装饰物_装饰物重置大小"] = function(_____88C5_9970_7269)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetOrientMatrixResize(_____88C5_9970_7269)
end
____exports["装饰物_设装饰物旋转"] = function(_____88C5_9970_7269, _____89D2_5EA6, _____8F74x, _____8F74y, _____8F74z)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetOrientMatrixRotate(
        _____88C5_9970_7269,
        _____89D2_5EA6,
        _____8F74x,
        _____8F74y,
        _____8F74z
    )
end
____exports["装饰物_修改装饰物尺寸"] = function(_____88C5_9970_7269, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetOrientMatrixScale(_____88C5_9970_7269, x, y, z)
end
____exports["装饰物_设装饰物位置"] = function(_____88C5_9970_7269, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetPosition(_____88C5_9970_7269, x, y, z)
end
____exports["装饰物_改变装饰物队伍颜色"] = function(_____88C5_9970_7269, _____989C_8272)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetTeamColor(_____88C5_9970_7269, _____989C_8272)
end
____exports["装饰物_设装饰物动画播放速度"] = function(_____88C5_9970_7269, _____7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetTimeScale(_____88C5_9970_7269, _____7F29_653E)
end
____exports["装饰物_装饰物显示_隐藏"] = function(_____88C5_9970_7269, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzDoodadSetVisible(_____88C5_9970_7269, _____662F_5426_542F_7528)
end
____exports["特效_特效绑定特效"] = function(_____53E5_67C4, _____5B57_7B26_4E322, _____7279_6548)
    return _____539F_751F_51FD_6570_8868.DzEffectBindEffect(_____53E5_67C4, _____5B57_7B26_4E322, _____7279_6548)
end
____exports["允许查看指定单位技能"] = function(_____5355_4F4D, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzEnableDrawSkillPanel(_____5355_4F4D, _____662F_5426_542F_7528)
end
____exports["允许查看指定玩家单位技能"] = function(_____73A9_5BB6, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzEnableDrawSkillPanelByPlayer(_____73A9_5BB6, _____662F_5426_542F_7528)
end
____exports["哈希表_开启保存空值逆天设置null"] = function(_____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzEnableHashtableSetNull(_____662F_5426_542F_7528)
end
____exports["游戏_修复单位命令事件泄漏"] = function()
    return _____539F_751F_51FD_6570_8868.DzFixUnitEventMemoryLeak()
end
____exports["游戏_模拟按键游戏UI消息"] = function(_____73A9_5BB6, _____952E_7801, _____662F_5426_6309_4E0B)
    return _____539F_751F_51FD_6570_8868.DzForceUiKeyboard(_____73A9_5BB6, _____952E_7801, _____662F_5426_6309_4E0B)
end
____exports["界面_世界坐标_为绑定的Frame添加隐藏区域"] = function(_____754C_9762, _____5DE6, _____4E0B, _____53F3, _____4E0A, _____5BBD_5EA6, _____9AD8_5EA6)
    return _____539F_751F_51FD_6570_8868.DzFrameBindAddHideRect(
        _____754C_9762,
        _____5DE6,
        _____4E0B,
        _____53F3,
        _____4E0A,
        _____5BBD_5EA6,
        _____9AD8_5EA6
    )
end
____exports["界面_世界坐标_绑定Frame到单位实时位置"] = function(_____754C_9762, _____5355_4F4D, _____4E16_754Cx, _____4E16_754Cy, _____4E16_754Cz, _____5C4F_5E55x, _____5C4F_5E55y, _____96FE_4E2D_53EF_89C1, _____5355_4F4D_53EF_89C1, _____6B7B_4EA1_53EF_89C1)
    return _____539F_751F_51FD_6570_8868.DzFrameBindWidget(
        _____754C_9762,
        _____5355_4F4D,
        _____4E16_754Cx,
        _____4E16_754Cy,
        _____4E16_754Cz,
        _____5C4F_5E55x,
        _____5C4F_5E55y,
        _____96FE_4E2D_53EF_89C1,
        _____5355_4F4D_53EF_89C1,
        _____6B7B_4EA1_53EF_89C1
    )
end
____exports["界面_世界坐标_绑定Frame到世界坐标实时位置"] = function(_____754C_9762, _____4E16_754Cx, _____4E16_754Cy, _____4E16_754Cz, _____5C4F_5E55x, _____5C4F_5E55y, _____96FE_4E2D_53EF_89C1)
    return _____539F_751F_51FD_6570_8868.DzFrameBindWorldPos(
        _____754C_9762,
        _____4E16_754Cx,
        _____4E16_754Cy,
        _____4E16_754Cz,
        _____5C4F_5E55x,
        _____5C4F_5E55y,
        _____96FE_4E2D_53EF_89C1
    )
end
____exports["界面_游戏界面限制设置"] = function(_____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzFrameEnableClipRect(_____662F_5426_542F_7528)
end
____exports["界面_血条刷新事件"] = function(_____56DE_8C03)
    return _____539F_751F_51FD_6570_8868.DzFrameHookHpBar(_____56DE_8C03)
end
____exports["界面_移除模型特效"] = function(_____6A21_578B_754C_9762, _____7279_6548_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameRemoveModelEffect(_____6A21_578B_754C_9762, _____7279_6548_754C_9762)
end
____exports["界面_设绝对点位"] = function(_____754C_9762, _____70B9_4F4D, x, y)
    return _____539F_751F_51FD_6570_8868.DzFrameSetAbsolutePoint(_____754C_9762, _____70B9_4F4D, x, y)
end
____exports["界面_设透明度"] = function(_____754C_9762, _____900F_660E_5EA6)
    return _____539F_751F_51FD_6570_8868.DzFrameSetAlpha(_____754C_9762, _____900F_660E_5EA6)
end
____exports["界面_设模型界面播放动画编号"] = function(_____754C_9762, _____5E8F_53F7, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.DzFrameSetAnimateByIndex(_____754C_9762, _____5E8F_53F7, _____6574_65703)
end
____exports["界面_设置复选框勾选状态"] = function(_____52FE_9009_6846_754C_9762, _____662F_5426_52FE_9009)
    return _____539F_751F_51FD_6570_8868.DzFrameSetCheckBoxState(_____52FE_9009_6846_754C_9762, _____662F_5426_52FE_9009)
end
____exports["界面_设控件视口"] = function(_____754C_9762, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzFrameSetClip(_____754C_9762, _____662F_5426_542F_7528)
end
____exports["界面_设置编辑框激活状态"] = function(_____754C_9762, _____662F_5426_6FC0_6D3B)
    return _____539F_751F_51FD_6570_8868.DzFrameSetEditBoxActive(_____754C_9762, _____662F_5426_6FC0_6D3B)
end
____exports["界面_设置编辑框禁用输入法"] = function(_____754C_9762, _____662F_5426_7981_7528)
    return _____539F_751F_51FD_6570_8868.DzFrameSetEditBoxDisableIme(_____754C_9762, _____662F_5426_7981_7528)
end
____exports["界面_设字体"] = function(_____754C_9762, _____53C2_65702, _____9AD8_5EA6, _____53C2_65704)
    return _____539F_751F_51FD_6570_8868.DzFrameSetFont(_____754C_9762, _____53C2_65702, _____9AD8_5EA6, _____53C2_65704)
end
____exports["界面_设置Frame控件忽略点击事件"] = function(_____754C_9762, _____5E03_5C142)
    return _____539F_751F_51FD_6570_8868.DzFrameSetIgnoreTrackEvents(_____754C_9762, _____5E03_5C142)
end
____exports["界面_设模型2"] = function(_____6A21_578B_754C_9762, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272ID)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModel2(_____6A21_578B_754C_9762, _____6A21_578B_8DEF_5F84, _____961F_4F0D_989C_8272ID)
end
____exports["界面_设模型动画"] = function(_____6A21_578B_754C_9762, _____52A8_753B)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelAnimation(_____6A21_578B_754C_9762, _____52A8_753B)
end
____exports["界面_设模型动画按序号"] = function(_____6A21_578B_754C_9762, _____6574_65702)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelAnimationByIndex(_____6A21_578B_754C_9762, _____6574_65702)
end
____exports["界面_设模型镜头源"] = function(_____6A21_578B_754C_9762, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelCameraSource(_____6A21_578B_754C_9762, x, y, z)
end
____exports["界面_设模型镜头目标"] = function(_____6A21_578B_754C_9762, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelCameraTarget(_____6A21_578B_754C_9762, x, y, z)
end
____exports["界面_设模型颜色"] = function(_____6A21_578B_754C_9762, _____989C_8272)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelColor(_____6A21_578B_754C_9762, _____989C_8272)
end
____exports["界面_设模型启用宽屏幕"] = function(_____754C_9762, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelEnableWideScreen(_____754C_9762, _____662F_5426_542F_7528)
end
____exports["界面_设模型矩阵重置"] = function(_____6A21_578B_754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelMatReset(_____6A21_578B_754C_9762)
end
____exports["界面_设模型粒子2大小"] = function(_____6A21_578B_754C_9762, _____7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelParticle2Size(_____6A21_578B_754C_9762, _____7F29_653E)
end
____exports["界面_设模型位置"] = function(_____6A21_578B_754C_9762, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelPosition(_____6A21_578B_754C_9762, x, y, z)
end
____exports["界面_设模型旋转横坐标"] = function(_____6A21_578B_754C_9762, x)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelRotateX(_____6A21_578B_754C_9762, x)
end
____exports["界面_设模型旋转纵坐标"] = function(_____6A21_578B_754C_9762, y)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelRotateY(_____6A21_578B_754C_9762, y)
end
____exports["界面_设模型旋转高度"] = function(_____6A21_578B_754C_9762, z)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelRotateZ(_____6A21_578B_754C_9762, z)
end
____exports["界面_设模型缩放"] = function(_____6A21_578B_754C_9762, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelScale(_____6A21_578B_754C_9762, x, y, z)
end
____exports["界面_设模型大小"] = function(_____6A21_578B_754C_9762, _____5927_5C0F)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelSize(_____6A21_578B_754C_9762, _____5927_5C0F)
end
____exports["界面_设模型速度"] = function(_____6A21_578B_754C_9762, _____901F_5EA6)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelSpeed(_____6A21_578B_754C_9762, _____901F_5EA6)
end
____exports["界面_设模型贴图"] = function(_____6A21_578B_754C_9762, _____5B57_7B26_4E322, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelTexture(_____6A21_578B_754C_9762, _____5B57_7B26_4E322, _____6574_65703)
end
____exports["界面_设模型横坐标"] = function(_____6A21_578B_754C_9762, x)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelX(_____6A21_578B_754C_9762, x)
end
____exports["界面_设模型纵坐标"] = function(_____6A21_578B_754C_9762, y)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelY(_____6A21_578B_754C_9762, y)
end
____exports["界面_设模型高度"] = function(_____6A21_578B_754C_9762, z)
    return _____539F_751F_51FD_6570_8868.DzFrameSetModelZ(_____6A21_578B_754C_9762, z)
end
____exports["界面_设置控件全局名字跟绑定整数"] = function(_____754C_9762, _____540D_79F0, _____4E0A_4E0B_6587)
    return _____539F_751F_51FD_6570_8868.DzFrameSetNameContext(_____754C_9762, _____540D_79F0, _____4E0A_4E0B_6587)
end
____exports["界面_设点位"] = function(_____754C_9762, _____70B9_4F4D, _____76F8_5BF9_754C_9762, _____76F8_5BF9_70B9_4F4D, x, y)
    return _____539F_751F_51FD_6570_8868.DzFrameSetPoint(
        _____754C_9762,
        _____70B9_4F4D,
        _____76F8_5BF9_754C_9762,
        _____76F8_5BF9_70B9_4F4D,
        x,
        y
    )
end
____exports["界面_设优先级"] = function(_____754C_9762, _____4F18_5148_7EA7)
    return _____539F_751F_51FD_6570_8868.DzFrameSetPriority(_____754C_9762, _____4F18_5148_7EA7)
end
____exports["界面_设大小"] = function(_____754C_9762, _____5BBD_5EA6, _____9AD8_5EA6)
    return _____539F_751F_51FD_6570_8868.DzFrameSetSize(_____754C_9762, _____5BBD_5EA6, _____9AD8_5EA6)
end
____exports["界面_设界面纹理坐标"] = function(_____754C_9762, _____5DE6, _____4E0A, _____53F3, _____4E0B)
    return _____539F_751F_51FD_6570_8868.DzFrameSetTexCoord(
        _____754C_9762,
        _____5DE6,
        _____4E0A,
        _____53F3,
        _____4E0B
    )
end
____exports["界面_设文本"] = function(_____754C_9762, _____6587_672C)
    return _____539F_751F_51FD_6570_8868.DzFrameSetText(_____754C_9762, _____6587_672C)
end
____exports["界面_设文本对齐"] = function(_____754C_9762, _____53C2_65702)
    return _____539F_751F_51FD_6570_8868.DzFrameSetTextAlignment(_____754C_9762, _____53C2_65702)
end
____exports["界面_设文本颜色"] = function(_____754C_9762, _____53C2_65702, _____5355_4F4D_7EC4, _____503CB, _____503CA)
    return _____539F_751F_51FD_6570_8868.DzFrameSetTextColor(
        _____754C_9762,
        _____53C2_65702,
        _____5355_4F4D_7EC4,
        _____503CB,
        _____503CA
    )
end
____exports["界面_设置文本控件字间距"] = function(_____6587_672C_754C_9762, _____5B57_8DDD)
    return _____539F_751F_51FD_6570_8868.DzFrameSetTextFontSpacing(_____6587_672C_754C_9762, _____5B57_8DDD)
end
____exports["界面_设贴图"] = function(_____754C_9762, _____8D34_56FE_8DEF_5F84, _____53C2_65703)
    return _____539F_751F_51FD_6570_8868.DzFrameSetTexture(_____754C_9762, _____8D34_56FE_8DEF_5F84, _____53C2_65703)
end
____exports["界面_显示"] = function(_____754C_9762, _____662F_5426_663E_793A)
    return _____539F_751F_51FD_6570_8868.DzFrameShow(_____754C_9762, _____662F_5426_663E_793A)
end
____exports["界面_世界坐标_解除Frame的绑定"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzFrameUnBind(_____754C_9762)
end
____exports["界面_解锁右下角区域鼠标焦点限制"] = function(_____662F_5426_89E3_9501)
    return _____539F_751F_51FD_6570_8868.DzFrameUnlockMouseRectLimit(_____662F_5426_89E3_9501)
end
____exports["物品_模型重置旋转缩"] = function(_____7269_54C1)
    return _____539F_751F_51FD_6570_8868.DzItemMatReset(_____7269_54C1)
end
____exports["物品_模型按照横坐标轴旋转"] = function(_____7269_54C1, x)
    return _____539F_751F_51FD_6570_8868.DzItemMatRotateX(_____7269_54C1, x)
end
____exports["物品_模型按照纵坐标轴旋转"] = function(_____7269_54C1, y)
    return _____539F_751F_51FD_6570_8868.DzItemMatRotateY(_____7269_54C1, y)
end
____exports["物品_模型按照高度轴旋转"] = function(_____7269_54C1, z)
    return _____539F_751F_51FD_6570_8868.DzItemMatRotateZ(_____7269_54C1, z)
end
____exports["物品_模型按照横坐标纵坐标高度轴缩放"] = function(_____7269_54C1, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzItemMatScale(_____7269_54C1, x, y, z)
end
____exports["物品_设物品透明度0_255"] = function(_____7269_54C1, _____989C_8272)
    return _____539F_751F_51FD_6570_8868.DzItemSetAlpha(_____7269_54C1, _____989C_8272)
end
____exports["物品_设物品模型"] = function(_____7269_54C1, _____5B57_7B26_4E322)
    return _____539F_751F_51FD_6570_8868.DzItemSetModel(_____7269_54C1, _____5B57_7B26_4E322)
end
____exports["物品_设物品头像"] = function(_____7269_54C1, _____5B57_7B26_4E322)
    return _____539F_751F_51FD_6570_8868.DzItemSetPortrait(_____7269_54C1, _____5B57_7B26_4E322)
end
____exports["物品_物品大小"] = function(_____7269_54C1, _____5927_5C0F)
    return _____539F_751F_51FD_6570_8868.DzItemSetSize(_____7269_54C1, _____5927_5C0F)
end
____exports["物品_设物品颜色"] = function(_____7269_54C1, _____989C_8272)
    return _____539F_751F_51FD_6570_8868.DzItemSetVertexColor(_____7269_54C1, _____989C_8272)
end
____exports["加载界面目录"] = function(_____8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzLoadToc(_____8DEF_5F84)
end
____exports["清除所有模型内存缓存"] = function()
    return _____539F_751F_51FD_6570_8868.DzModelRemoveAllFromCache()
end
____exports["清除模型内存缓存"] = function(_____8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzModelRemoveFromCache(_____8DEF_5F84)
end
____exports["打开_群聊群链接"] = function(_____94FE_63A5)
    return _____539F_751F_51FD_6570_8868.DzOpenQQGroupUrl(_____94FE_63A5)
end
____exports["设特效播放动画"] = function(_____7279_6548, _____52A8_753B, _____94FE_63A5)
    return _____539F_751F_51FD_6570_8868.DzPlayEffectAnimation(_____7279_6548, _____52A8_753B, _____94FE_63A5)
end
____exports["玩家_发送聊天消息触发同步事件"] = function(_____73A9_5BB6, _____6D88_606F, _____63A5_6536_8005)
    return _____539F_751F_51FD_6570_8868.DzPlayerSendChat(_____73A9_5BB6, _____6D88_606F, _____63A5_6536_8005)
end
____exports["添加中介命令到队列无目标"] = function(_____5F52_5C5E_73A9_5BB6, _____4E2D_7ACB_5EFA_7B51, _____5355_4F4DID)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueNeutralImmediateOrderById(_____5F52_5C5E_73A9_5BB6, _____4E2D_7ACB_5EFA_7B51, _____5355_4F4DID)
end
____exports["添加中介命令到队列指定坐标"] = function(_____5F52_5C5E_73A9_5BB6, _____4E2D_7ACB_5EFA_7B51, _____5355_4F4DID, x, y)
    return _____539F_751F_51FD_6570_8868.DzQueueIssueNeutralPointOrderById(
        _____5F52_5C5E_73A9_5BB6,
        _____4E2D_7ACB_5EFA_7B51,
        _____5355_4F4DID,
        x,
        y
    )
end
____exports["监听建筑选位置"] = function(_____56DE_8C03)
    return _____539F_751F_51FD_6570_8868.DzRegisterOnBuildLocal(_____56DE_8C03)
end
____exports["监听技能预选目标"] = function(_____56DE_8C03)
    return _____539F_751F_51FD_6570_8868.DzRegisterOnTargetLocal(_____56DE_8C03)
end
____exports["降低玩家科技等级"] = function(_____73A9_5BB6, _____6574_65702, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.DzRemovePlayerTechResearched(_____73A9_5BB6, _____6574_65702, _____6574_65703)
end
____exports["复活单位"] = function(_____5355_4F4D, _____73A9_5BB6, _____8840, _____5B9E_65704, x, y)
    return _____539F_751F_51FD_6570_8868.DzReviveUnit(
        _____5355_4F4D,
        _____73A9_5BB6,
        _____8840,
        _____5B9E_65704,
        x,
        y
    )
end
____exports["游戏_模拟按键窗口消息"] = function(_____73A9_5BB6, _____952E_7801, _____662F_5426_6309_4E0B)
    return _____539F_751F_51FD_6570_8868.DzSendKeyboard(_____73A9_5BB6, _____952E_7801, _____662F_5426_6309_4E0B)
end
____exports["设剪切板"] = function(_____5B57_7B26_4E321)
    return _____539F_751F_51FD_6570_8868.DzSetClipboard(_____5B57_7B26_4E321)
end
____exports["装饰物_设置地形装饰物矩阵重置"] = function(_____6574_65701)
    return _____539F_751F_51FD_6570_8868.DzSetDoodadsMatReset(_____6574_65701)
end
____exports["装饰物_设置地形装饰物矩阵旋转横坐标轴"] = function(_____6574_65701, x)
    return _____539F_751F_51FD_6570_8868.DzSetDoodadsMatRotateX(_____6574_65701, x)
end
____exports["装饰物_设置地形装饰物矩阵旋转纵坐标轴"] = function(_____6574_65701, y)
    return _____539F_751F_51FD_6570_8868.DzSetDoodadsMatRotateY(_____6574_65701, y)
end
____exports["装饰物_设置装饰物矩阵旋转高度轴"] = function(_____6574_65701, z)
    return _____539F_751F_51FD_6570_8868.DzSetDoodadsMatRotateZ(_____6574_65701, z)
end
____exports["装饰物_设置地形装饰物矩阵缩放"] = function(_____6574_65701, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzSetDoodadsMatScale(_____6574_65701, x, y, z)
end
____exports["设特效播放动画_2"] = function(_____7279_6548, _____5E8F_53F7, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.DzSetEffectAnimation(_____7279_6548, _____5E8F_53F7, _____6574_65703)
end
____exports["特效_设置特效迷雾可见"] = function(_____7279_6548, _____662F_5426_53EF_89C1)
    return _____539F_751F_51FD_6570_8868.DzSetEffectFogVisible(_____7279_6548, _____662F_5426_53EF_89C1)
end
____exports["特效_设置特效黑色阴影可见"] = function(_____7279_6548, _____662F_5426_53EF_89C1)
    return _____539F_751F_51FD_6570_8868.DzSetEffectMaskVisible(_____7279_6548, _____662F_5426_53EF_89C1)
end
____exports["设特效模型"] = function(_____7279_6548, _____6A21_578B_8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzSetEffectModel(_____7279_6548, _____6A21_578B_8DEF_5F84)
end
____exports["设特效坐标"] = function(_____7279_6548, x, y, z)
    return _____539F_751F_51FD_6570_8868.DzSetEffectPos(_____7279_6548, x, y, z)
end
____exports["特效缩放"] = function(_____53E5_67C4, _____7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzSetEffectScale(_____53E5_67C4, _____7F29_653E)
end
____exports["设特效队伍颜色"] = function(_____53E5_67C4, _____73A9_5BB6ID)
    return _____539F_751F_51FD_6570_8868.DzSetEffectTeamColor(_____53E5_67C4, _____73A9_5BB6ID)
end
____exports["设特效透明度"] = function(_____7279_6548, _____900F_660E_5EA6)
    return _____539F_751F_51FD_6570_8868.DzSetEffectVertexAlpha(_____7279_6548, _____900F_660E_5EA6)
end
____exports["设特效颜色"] = function(_____7279_6548, _____989C_8272)
    return _____539F_751F_51FD_6570_8868.DzSetEffectVertexColor(_____7279_6548, _____989C_8272)
end
____exports["特效显示_隐藏"] = function(_____53E5_67C4, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzSetEffectVisible(_____53E5_67C4, _____662F_5426_542F_7528)
end
____exports["游戏_设置全局移速上_下限"] = function(_____5EFA_9020_6700_5C0F, _____5EFA_9020_6700_5927, _____5355_4F4D_6700_5C0F, _____5355_4F4D_6700_5927, _____5B9E_65705, _____5B9E_65706, _____5B9E_65707, _____5B9E_65708, _____5B9E_65709, _____5B9E_657010)
    return _____539F_751F_51FD_6570_8868.DzSetGlobalUnitMinMaxMoveSpeed(
        _____5EFA_9020_6700_5C0F,
        _____5EFA_9020_6700_5927,
        _____5355_4F4D_6700_5C0F,
        _____5355_4F4D_6700_5927,
        _____5B9E_65705,
        _____5B9E_65706,
        _____5B9E_65707,
        _____5B9E_65708,
        _____5B9E_65709,
        _____5B9E_657010
    )
end
____exports["英雄_设置主属性"] = function(_____5355_4F4D, _____5C5E_6027)
    return _____539F_751F_51FD_6570_8868.DzSetHeroPrimaryAttribute(_____5355_4F4D, _____5C5E_6027)
end
____exports["英雄_设置属性成长"] = function(_____5355_4F4D, _____6574_65702, _____503C, _____4FDD_7559_5F53_524D_52A0_6210)
    return _____539F_751F_51FD_6570_8868.DzSetHeroPrimaryAttributePlus(_____5355_4F4D, _____6574_65702, _____503C, _____4FDD_7559_5F53_524D_52A0_6210)
end
____exports["英雄_设置主属性类型"] = function(_____5355_4F4D, _____5C5E_6027, _____4FDD_7559_4E3B_5C5E_6027_52A0_6210)
    return _____539F_751F_51FD_6570_8868.DzSetHeroPrimaryAttributeType(_____5355_4F4D, _____5C5E_6027, _____4FDD_7559_4E3B_5C5E_6027_52A0_6210)
end
____exports["设英雄类型专名"] = function(_____5355_4F4DID, _____540D_79F0)
    return _____539F_751F_51FD_6570_8868.DzSetHeroTypeProperName(_____5355_4F4DID, _____540D_79F0)
end
____exports["物品_修改物品碰撞体积"] = function(_____7269_54C1, _____5927_5C0F)
    return _____539F_751F_51FD_6570_8868.DzSetItemCollisionSize(_____7269_54C1, _____5927_5C0F)
end
____exports["游戏_限制最高帧数"] = function(_____6700_5927FPS)
    return _____539F_751F_51FD_6570_8868.DzSetMaxFps(_____6700_5927FPS)
end
____exports["游戏_设置攻速上限"] = function(_____5B9E_65701, _____5B9E_65702)
    return _____539F_751F_51FD_6570_8868.DzSetMinMaxAttackSpeedFactor(_____5B9E_65701, _____5B9E_65702)
end
____exports["游戏_设置移速可叠加"] = function(_____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzSetMoveSpeedBonusesStack(_____662F_5426_542F_7528)
end
____exports["设粒子2大小"] = function(_____63A7_4EF6, _____7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzSetPariticle2Size(_____63A7_4EF6, _____7F29_653E)
end
____exports["技能_设置技能施法范围"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityArea(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能图标"] = function(_____5355_4F4D, _____6280_80FDID, _____5B57_7B26_4E323)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityArt(_____5355_4F4D, _____6280_80FDID, _____5B57_7B26_4E323)
end
____exports["技能_设置技能魔法施放回复后摇_2"] = function(_____5355_4F4D, _____6280_80FDID, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityBackSwing(_____5355_4F4D, _____6280_80FDID, _____503C)
end
____exports["技能_设置建造技能模型象牙塔"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____6A21_578B_8DEF_5F84, _____6A21_578B_7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityBuildModel(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____6A21_578B_8DEF_5F84, _____6A21_578B_7F29_653E)
end
____exports["技能_设置建造技能命令编号象牙塔"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityBuildOrderId(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能按钮位置"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, x, y)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityButtonPos(_____5355_4F4D, _____6280_80FD_4EE3_7801, x, y)
end
____exports["技能_设置技能魔法施放点前摇"] = function(_____5355_4F4D, _____6280_80FDID, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityCastPoint(_____5355_4F4D, _____6280_80FDID, _____503C)
end
____exports["技能_设置技能魔法施法时间"] = function(_____5355_4F4D, _____6280_80FDID, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityCastTime(_____5355_4F4D, _____6280_80FDID, _____503C)
end
____exports["技能_设置技能冷却时间"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____51B7_5374, _____6700_5927_51B7_5374)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityCool(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____51B7_5374, _____6700_5927_51B7_5374)
end
____exports["技能_设置技能魔法消耗"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityCost(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能dataA"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityDataA(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能dataB"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityDataB(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能dataC"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityDataC(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能dataD"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityDataD(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能dataE"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityDataE(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能禁用"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityDisable(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_设置技能持续时间普通"] = function(_____5355_4F4D, _____6280_80FDID, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityDuration(_____5355_4F4D, _____6280_80FDID, _____503C)
end
____exports["技能_设置技能启用"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityEnable(_____5355_4F4D, _____6280_80FDID)
end
____exports["技能_工程升级_替换技能要相同模板"] = function(_____5355_4F4D, _____65E7ID, _____65B0ID, _____66F4_65B0_82F1_96C4_6280_80FD)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityEngineeringUpgrade(_____5355_4F4D, _____65E7ID, _____65B0ID, _____66F4_65B0_82F1_96C4_6280_80FD)
end
____exports["技能_工程升级_取消替换技能"] = function(_____5355_4F4D, _____65E7ID)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityEngineeringUpgradeCancel(_____5355_4F4D, _____65E7ID)
end
____exports["技能_设置技能持续时间英雄"] = function(_____5355_4F4D, _____6280_80FDID, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityHeroDuration(_____5355_4F4D, _____6280_80FDID, _____503C)
end
____exports["技能_设置技能快捷键"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____952E_540D)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityHotkey(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____952E_540D)
end
____exports["技能_设置技能投射物弧度"] = function(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_5F27_5EA6)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityMissileArc(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_5F27_5EA6)
end
____exports["技能_设置技能投射物模型"] = function(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_7F8E_672F)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityMissileArt(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_7F8E_672F)
end
____exports["技能_设置技能投射物数量弹幕攻击"] = function(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_6570_91CF)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityMissileCount(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_6570_91CF)
end
____exports["技能_设置技能投射物伤害弹幕攻击"] = function(_____5355_4F4D, _____6280_80FDID, _____4F24_5BB3, _____6700_5927_4F24_5BB3, _____53C2_65705, _____53C2_65706)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityMissileDamage(
        _____5355_4F4D,
        _____6280_80FDID,
        _____4F24_5BB3,
        _____6700_5927_4F24_5BB3,
        _____53C2_65705,
        _____53C2_65706
    )
end
____exports["技能_设置技能投射物允许自导"] = function(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_8FFD_8E2A)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityMissileHoming(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_8FFD_8E2A)
end
____exports["技能_设置技能投射物速度"] = function(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_901F_5EA6)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityMissileSpeed(_____5355_4F4D, _____6280_80FDID, _____5F39_9053_901F_5EA6)
end
____exports["技能_设置技能命令编号"] = function(_____5355_4F4D, _____6280_80FDID, _____547D_4EE4ID)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityOrderId(_____5355_4F4D, _____6280_80FDID, _____547D_4EE4ID)
end
____exports["技能_设置技能施法距离"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityRange(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能等级要求"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityReqLevel(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置魔法书技能列表添加新技能"] = function(_____5355_4F4D, _____6280_80FDID, _____6DFB_52A0_6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilitySpellBookAddAbility(_____5355_4F4D, _____6280_80FDID, _____6DFB_52A0_6280_80FDID)
end
____exports["技能_设置魔法书的技能列表"] = function(_____5355_4F4D, _____6280_80FDID, _____6280_80FD_5217_8868, _____4FDD_5B58_51B7_5374)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilitySpellBookList(_____5355_4F4D, _____6280_80FDID, _____6280_80FD_5217_8868, _____4FDD_5B58_51B7_5374)
end
____exports["技能_设置魔法书技能列表移除指定技能"] = function(_____5355_4F4D, _____6280_80FDID, _____79FB_9664_6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilitySpellBookRemoveAbility(_____5355_4F4D, _____6280_80FDID, _____79FB_9664_6280_80FDID)
end
____exports["技能_设置技能目标允许"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityTargs(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置技能科技条件达成"] = function(_____5355_4F4D, _____6280_80FDID, _____8FBE_6210)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityTechReach(_____5355_4F4D, _____6280_80FDID, _____8FBE_6210)
end
____exports["技能_设置技能科技条件文本"] = function(_____5355_4F4D, _____6280_80FDID, _____63D0_793A)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityTechReachTip(_____5355_4F4D, _____6280_80FDID, _____63D0_793A)
end
____exports["技能_设置技能提示"] = function(_____5355_4F4D, _____6280_80FDID, _____63D0_793A)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityTip(_____5355_4F4D, _____6280_80FDID, _____63D0_793A)
end
____exports["技能_设置技能提示扩展"] = function(_____5355_4F4D, _____6280_80FDID, _____6269_5C55_63D0_793A)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityUberTip(_____5355_4F4D, _____6280_80FDID, _____6269_5C55_63D0_793A)
end
____exports["技能_设置建造技能单位编号象牙塔"] = function(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityUnitId(_____5355_4F4D, _____6280_80FD_4EE3_7801, _____503C)
end
____exports["技能_设置刷新数据"] = function(_____5355_4F4D, _____6280_80FDID)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAbilityUpdate(_____5355_4F4D, _____6280_80FDID)
end
____exports["单位_设置单位作为目标类型"] = function(_____5355_4F4D, _____76EE_6807_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAsAttackTargetType(_____5355_4F4D, _____76EE_6807_7C7B_578B)
end
____exports["单位_设置单位攻击1目标允许"] = function(_____5355_4F4D, _____76EE_6807_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAttack1TargetType(_____5355_4F4D, _____76EE_6807_7C7B_578B)
end
____exports["单位_设置单位攻击2目标允许"] = function(_____5355_4F4D, _____76EE_6807_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAttack2TargetType(_____5355_4F4D, _____76EE_6807_7C7B_578B)
end
____exports["单位_设置攻击最大目标数"] = function(_____5355_4F4D, _____5E8F_53F7, _____76EE_6807_6570_91CF)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAttackTargetCount(_____5355_4F4D, _____5E8F_53F7, _____76EE_6807_6570_91CF)
end
____exports["设单位攻击类型"] = function(_____5355_4F4D, _____5E8F_53F7, _____653B_51FB_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzSetUnitAttackType(_____5355_4F4D, _____5E8F_53F7, _____653B_51FB_7C7B_578B)
end
____exports["单位_设置魔法施放回复后摇"] = function(_____5355_4F4D, _____5B9E_65702)
    return _____539F_751F_51FD_6570_8868.DzSetUnitBackSwing(_____5355_4F4D, _____5B9E_65702)
end
____exports["单位_设置魔法施放点前摇"] = function(_____5355_4F4D, _____65BD_6CD5_70B9_4F4D)
    return _____539F_751F_51FD_6570_8868.DzSetUnitCastPoint(_____5355_4F4D, _____65BD_6CD5_70B9_4F4D)
end
____exports["单位_修改单位碰撞体积"] = function(_____5355_4F4D, _____5927_5C0F)
    return _____539F_751F_51FD_6570_8868.DzSetUnitCollisionSize(_____5355_4F4D, _____5927_5C0F)
end
____exports["设单位数据缓存整数"] = function(_____5355_4F4DID, ID, _____5E8F_53F7, _____6574_65704)
    return _____539F_751F_51FD_6570_8868.DzSetUnitDataCacheInteger(_____5355_4F4DID, ID, _____5E8F_53F7, _____6574_65704)
end
____exports["设单位防御类型"] = function(_____5355_4F4D, _____9632_5FA1_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzSetUnitDefenseType(_____5355_4F4D, _____9632_5FA1_7C7B_578B)
end
____exports["设单位描述"] = function(_____5355_4F4D, _____503C)
    return _____539F_751F_51FD_6570_8868.DzSetUnitDescription(_____5355_4F4D, _____503C)
end
____exports["单位_设置单位屏蔽控制命令模拟失控"] = function(_____5355_4F4D, _____662F_5426_7981_7528)
    return _____539F_751F_51FD_6570_8868.DzSetUnitDisableControlOrder(_____5355_4F4D, _____662F_5426_7981_7528)
end
____exports["单位_设置单位屏蔽本地命令模拟失控"] = function(_____5355_4F4D, _____662F_5426_7981_7528)
    return _____539F_751F_51FD_6570_8868.DzSetUnitDisableLocalOrder(_____5355_4F4D, _____662F_5426_7981_7528)
end
____exports["单位_设置单位禁用攻击"] = function(_____5355_4F4D, _____662F_5426_7981_7528)
    return _____539F_751F_51FD_6570_8868.DzUnitDisableAttack(_____5355_4F4D, _____662F_5426_7981_7528)
end
____exports["单位_设置单位是否忽略点击"] = function(_____5355_4F4D, _____5E03_5C142)
    return _____539F_751F_51FD_6570_8868.DzSetUnitHitIgnore(_____5355_4F4D, _____5E03_5C142)
end
____exports["单位_设置每秒生命恢复"] = function(_____5355_4F4D, _____56DE_590D)
    return _____539F_751F_51FD_6570_8868.DzSetUnitLifeRegen(_____5355_4F4D, _____56DE_590D)
end
____exports["单位_设置每秒魔法恢复"] = function(_____5355_4F4D, _____56DE_590D)
    return _____539F_751F_51FD_6570_8868.DzSetUnitManaRegen(_____5355_4F4D, _____56DE_590D)
end
____exports["单位_设置最高移动速度"] = function(_____5355_4F4D, _____901F_5EA6, _____5FFD_7565_53D8_5F62)
    return _____539F_751F_51FD_6570_8868.DzSetUnitMaxSpeed(_____5355_4F4D, _____901F_5EA6, _____5FFD_7565_53D8_5F62)
end
____exports["单位_设置最低移动速度"] = function(_____5355_4F4D, _____901F_5EA6, _____5FFD_7565_53D8_5F62)
    return _____539F_751F_51FD_6570_8868.DzSetUnitMinSpeed(_____5355_4F4D, _____901F_5EA6, _____5FFD_7565_53D8_5F62)
end
____exports["设单位普攻弹道弧度"] = function(_____5355_4F4D, _____5F27_5EA6)
    return _____539F_751F_51FD_6570_8868.DzSetUnitMissileArc(_____5355_4F4D, _____5F27_5EA6)
end
____exports["设单位普攻弹道自导允许"] = function(_____5355_4F4D, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzSetUnitMissileHoming(_____5355_4F4D, _____662F_5426_542F_7528)
end
____exports["设单位普攻弹道模型"] = function(_____5355_4F4D, _____6A21_578B_8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzSetUnitMissileModel(_____5355_4F4D, _____6A21_578B_8DEF_5F84)
end
____exports["设单位普攻弹道速度"] = function(_____5355_4F4D, _____901F_5EA6)
    return _____539F_751F_51FD_6570_8868.DzSetUnitMissileSpeed(_____5355_4F4D, _____901F_5EA6)
end
____exports["设单位名字"] = function(_____5355_4F4D, _____540D_79F0)
    return _____539F_751F_51FD_6570_8868.DzSetUnitName(_____5355_4F4D, _____540D_79F0)
end
____exports["设单位头像模型"] = function(_____5355_4F4D, _____6A21_578B_8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzSetUnitPortrait(_____5355_4F4D, _____6A21_578B_8DEF_5F84)
end
____exports["设单位的鼠标指向UI和血条显示_隐藏"] = function(_____5355_4F4D, _____662F_5426_663E_793A)
    return _____539F_751F_51FD_6570_8868.DzSetUnitPreselectUIVisible(_____5355_4F4D, _____662F_5426_663E_793A)
end
____exports["设英雄称谓"] = function(_____5355_4F4D, _____540D_79F0)
    return _____539F_751F_51FD_6570_8868.DzSetUnitProperName(_____5355_4F4D, _____540D_79F0)
end
____exports["单位_修改单位选择圈缩放"] = function(_____5355_4F4D, _____7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzSetUnitSelectScale(_____5355_4F4D, _____7F29_653E)
end
____exports["设单位类型名称"] = function(_____5355_4F4DID, _____540D_79F0)
    return _____539F_751F_51FD_6570_8868.DzSetUnitTypeName(_____5355_4F4DID, _____540D_79F0)
end
____exports["单位_设置横坐标纵坐标坐标不打断命令"] = function(_____5355_4F4D, x, y)
    return _____539F_751F_51FD_6570_8868.DzSetUnitXY(_____5355_4F4D, x, y)
end
____exports["单位缩放"] = function(_____5355_4F4D, _____7F29_653E)
    return _____539F_751F_51FD_6570_8868.DzSetWidgetSpriteScale(_____5355_4F4D, _____7F29_653E)
end
____exports["设控件贴图"] = function(_____53E5_67C4, _____5B57_7B26_4E322, _____66FF_6362ID)
    return _____539F_751F_51FD_6570_8868.DzSetWidgetTexture(_____53E5_67C4, _____5B57_7B26_4E322, _____66FF_6362ID)
end
____exports["简单消息界面_显示游戏提示信息"] = function(_____754C_9762, _____6587_672C, _____989C_8272, _____6301_7EED_65F6_95F4, _____5E03_5C145)
    return _____539F_751F_51FD_6570_8868.DzSimpleMessageFrameAddMessage(
        _____754C_9762,
        _____6587_672C,
        _____989C_8272,
        _____6301_7EED_65F6_95F4,
        _____5E03_5C145
    )
end
____exports["简单消息界面_清理游戏提示信息"] = function(_____754C_9762)
    return _____539F_751F_51FD_6570_8868.DzSimpleMessageFrameClear(_____754C_9762)
end
____exports["漂浮字_设漂浮文字字体"] = function(_____6587_4EF6_540D)
    return _____539F_751F_51FD_6570_8868.DzTextTagSetFont(_____6587_4EF6_540D)
end
____exports["漂浮字_设漂浮文字阴影颜色"] = function(_____7C7B_578B, _____989C_8272)
    return _____539F_751F_51FD_6570_8868.DzTextTagSetShadowColor(_____7C7B_578B, _____989C_8272)
end
____exports["漂浮字_设漂浮文字透明度"] = function(_____7C7B_578B, _____900F_660E_5EA6)
    return _____539F_751F_51FD_6570_8868.DzTextTagSetStartAlpha(_____7C7B_578B, _____900F_660E_5EA6)
end
____exports["设帧率显示_隐藏"] = function(_____663E_793A)
    return _____539F_751F_51FD_6570_8868.DzToggleFPS(_____663E_793A)
end
____exports["平台_触发注册按键事件按代码"] = function(_____89E6_53D1_5668, _____6309_952E_4EE3_7801, _____53C2_65703, _____540C_6B65, _____53C2_65705)
    return _____539F_751F_51FD_6570_8868.DzTriggerRegisterKeyEventByCode(
        _____89E6_53D1_5668,
        _____6309_952E_4EE3_7801,
        _____53C2_65703,
        _____540C_6B65,
        _____53C2_65705
    )
end
____exports["解除绑定特效"] = function(_____7279_6548)
    return _____539F_751F_51FD_6570_8868.DzUnbindEffect(_____7279_6548)
end
____exports["单位_清除单位命令队列"] = function(_____5355_4F4D, _____5E03_5C142)
    return _____539F_751F_51FD_6570_8868.DzUnitOrdersClear(_____5355_4F4D, _____5E03_5C142)
end
____exports["单位_执行单位的命令队列"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzUnitOrdersExec(_____5355_4F4D)
end
____exports["单位_强制停止单位当前命令"] = function(_____5355_4F4D, _____6E05_7A7A_961F_5217)
    return _____539F_751F_51FD_6570_8868.DzUnitOrdersForceStop(_____5355_4F4D, _____6E05_7A7A_961F_5217)
end
____exports["单位_反转单位命令队列"] = function(_____5355_4F4D)
    return _____539F_751F_51FD_6570_8868.DzUnitOrdersReverse(_____5355_4F4D)
end
____exports["单位_设单位实例的移动类型"] = function(_____5355_4F4D, _____79FB_52A8_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.DzUnitSetMoveType(_____5355_4F4D, _____79FB_52A8_7C7B_578B)
end
____exports["单位_界面添加等级数组整数"] = function(_____5355_4F4DID, ID, _____6574_65703, _____6574_65704)
    return _____539F_751F_51FD_6570_8868.DzUnitUIAddLevelArrayInteger(_____5355_4F4DID, ID, _____6574_65703, _____6574_65704)
end
____exports["解锁BLP像素限制"] = function(_____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzUnlockBlpSizeLimit(_____662F_5426_542F_7528)
end
____exports["解锁JASS字节码限制"] = function(_____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzUnlockOpCodeLimit(_____662F_5426_542F_7528)
end
____exports["自定义指定单位的小地图图标"] = function(_____5355_4F4D, _____8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzWidgetSetMinimapIcon(_____5355_4F4D, _____8DEF_5F84)
end
____exports["开启_关闭自定义指定单位的小地图图标"] = function(_____5355_4F4D, _____662F_5426_542F_7528)
    return _____539F_751F_51FD_6570_8868.DzWidgetSetMinimapIconEnable(_____5355_4F4D, _____662F_5426_542F_7528)
end
____exports["硬件_设置游戏窗口位置"] = function(x, y)
    return _____539F_751F_51FD_6570_8868.DzWindowSetPoint(x, y)
end
____exports["硬件_设置游戏窗口大小"] = function(_____5BBD_5EA6, _____9AD8_5EA6)
    return _____539F_751F_51FD_6570_8868.DzWindowSetSize(_____5BBD_5EA6, _____9AD8_5EA6)
end
____exports["打印调试信息到平台日志"] = function(_____6D88_606F)
    return _____539F_751F_51FD_6570_8868.DzWriteLog(_____6D88_606F)
end
____exports["关闭_工作表"] = function(_____6574_65701)
    return _____539F_751F_51FD_6570_8868.DzXlsxClose(_____6574_65701)
end
____exports["打开_Excel文件"] = function(_____6587_4EF6_8DEF_5F84)
    return _____539F_751F_51FD_6570_8868.DzXlsxOpen(_____6587_4EF6_8DEF_5F84)
end
____exports["扩展_禁用单位碰撞"] = function(_____5355_4F4D, _____7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXDisableUnitCollision(_____5355_4F4D, _____7C7B_578B)
end
____exports["扩展_特效矩阵旋转高度"] = function(E, _____89D2_5EA6)
    return _____539F_751F_51FD_6570_8868.EXEffectMatRotateZ(E, _____89D2_5EA6)
end
____exports["扩展_特效矩阵缩放"] = function(E, x, y, z)
    return _____539F_751F_51FD_6570_8868.EXEffectMatScale(E, x, y, z)
end
____exports["扩展_启用单位碰撞"] = function(_____5355_4F4D, _____7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXEnableUnitCollision(_____5355_4F4D, _____7C7B_578B)
end
____exports["单位扩展_暂停"] = function(_____5355_4F4D, _____53C2_65702)
    return _____539F_751F_51FD_6570_8868.EXPauseUnit(_____5355_4F4D, _____53C2_65702)
end
____exports["技能扩展_设杂项DataA"] = function(_____6280_80FD, _____5355_4F4DID)
    return _____539F_751F_51FD_6570_8868.EXSetAbilityAEmeDataA(_____6280_80FD, _____5355_4F4DID)
end
____exports["技能扩展_设整数数据"] = function(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B, _____503C)
    return _____539F_751F_51FD_6570_8868.EXSetAbilityDataInteger(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B, _____503C)
end
____exports["技能扩展_设实数数据"] = function(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B, _____503C)
    return _____539F_751F_51FD_6570_8868.EXSetAbilityDataReal(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B, _____503C)
end
____exports["技能扩展_设字符串数据"] = function(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B, _____503C)
    return _____539F_751F_51FD_6570_8868.EXSetAbilityDataString(_____6280_80FD, _____7B49_7EA7, _____6570_636E_7C7B_578B, _____503C)
end
____exports["技能扩展_设状态"] = function(_____6280_80FD, _____72B6_6001_7C7B_578B, _____503C)
    return _____539F_751F_51FD_6570_8868.EXSetAbilityState(_____6280_80FD, _____72B6_6001_7C7B_578B, _____503C)
end
____exports["扩展_设特效大小"] = function(E, _____5927_5C0F)
    return _____539F_751F_51FD_6570_8868.EXSetEffectSize(E, _____5927_5C0F)
end
____exports["扩展_设特效速度"] = function(E, _____901F_5EA6)
    return _____539F_751F_51FD_6570_8868.EXSetEffectSpeed(E, _____901F_5EA6)
end
____exports["扩展_设特效高度"] = function(_____7279_6548, z)
    return _____539F_751F_51FD_6570_8868.EXSetEffectZ(_____7279_6548, z)
end
____exports["物品扩展_设字符串数据"] = function(_____7269_54C1_7F16_7801, _____6570_636E_7C7B_578B, _____503C)
    return _____539F_751F_51FD_6570_8868.EXSetItemDataString(_____7269_54C1_7F16_7801, _____6570_636E_7C7B_578B, _____503C)
end
____exports["单位扩展_设数组字符串"] = function(_____5355_4F4DID, ID, _____6574_65703, _____540D_79F0)
    return _____539F_751F_51FD_6570_8868.EXSetUnitArrayString(_____5355_4F4DID, ID, _____6574_65703, _____540D_79F0)
end
____exports["单位扩展_设碰撞类型"] = function(_____662F_5426_542F_7528, _____5355_4F4D, _____7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXSetUnitCollisionType(_____662F_5426_542F_7528, _____5355_4F4D, _____7C7B_578B)
end
____exports["单位扩展_设朝向"] = function(_____5355_4F4D, _____89D2_5EA6)
    return _____539F_751F_51FD_6570_8868.EXSetUnitFacing(_____5355_4F4D, _____89D2_5EA6)
end
____exports["单位扩展_设整数"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.EXSetUnitInteger(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["单位扩展_设移动类型"] = function(_____5355_4F4D, _____7C7B_578B)
    return _____539F_751F_51FD_6570_8868.EXSetUnitMoveType(_____5355_4F4D, _____7C7B_578B)
end
____exports["平台扩展_批量存档添加条目"] = function(_____73A9_5BB6, _____952E_540D, _____503C, _____5E03_5C144)
    return _____539F_751F_51FD_6570_8868.KKApiAddBatchSaveArchive(_____73A9_5BB6, _____952E_540D, _____503C, _____5E03_5C144)
end
____exports["平台扩展_添加条目_布尔值"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.KKApiAddBatchSaveArchiveBoolean(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["平台扩展_添加条目_整数"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.KKApiAddBatchSaveArchiveInteger(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["平台扩展_添加条目_实数"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.KKApiAddBatchSaveArchiveReal(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["平台扩展_添加条目_字符串"] = function(_____73A9_5BB6, _____952E_540D, _____503C)
    return _____539F_751F_51FD_6570_8868.KKApiAddBatchSaveArchiveString(_____73A9_5BB6, _____952E_540D, _____503C)
end
____exports["平台扩展_批量存档开始保存"] = function(_____73A9_5BB6)
    return _____539F_751F_51FD_6570_8868.KKApiBeginBatchSaveArchive(_____73A9_5BB6)
end
____exports["平台扩展_批量存档结束保存"] = function(_____73A9_5BB6, _____5E03_5C142)
    return _____539F_751F_51FD_6570_8868.KKApiEndBatchSaveArchive(_____73A9_5BB6, _____5E03_5C142)
end
____exports["平台扩展_初始化平台键位显示设置"] = function(_____73A9_5BB6, _____6574_65702, _____5B57_7B26_4E323, _____6570_636E)
    return _____539F_751F_51FD_6570_8868.KKApiInitializeGameKey(_____73A9_5BB6, _____6574_65702, _____5B57_7B26_4E323, _____6570_636E)
end
____exports["平台扩展_随机只读存档生成随机数"] = function(_____73A9_5BB6, _____952E_540D, _____5206_7EC4_952E)
    return _____539F_751F_51FD_6570_8868.KKApiRequestBackendLogic(_____73A9_5BB6, _____952E_540D, _____5206_7EC4_952E)
end
____exports["平台扩展_技能按钮_鼠标点击技能按钮"] = function(_____6574_65701, _____9F20_6807_7C7B_578B)
    return _____539F_751F_51FD_6570_8868.KKCommandButtonClick(_____6574_65701, _____9F20_6807_7C7B_578B)
end
____exports["平台扩展_界面_设置技能_物品按钮的冷却模型缩放大小"] = function(_____6574_65701, _____5927_5C0F)
    return _____539F_751F_51FD_6570_8868.KKCommandSetCooldownModelSize(_____6574_65701, _____5927_5C0F)
end
____exports["平台扩展_界面_设置技能_物品按钮的冷却模型缩放指定宽高比例"] = function(_____6574_65701, _____5BBD_5EA6, _____9AD8_5EA6)
    return _____539F_751F_51FD_6570_8868.KKCommandSetCooldownModelSize2(_____6574_65701, _____5BBD_5EA6, _____9AD8_5EA6)
end
____exports["平台扩展_技能按钮_删除技能按钮"] = function(_____6574_65701)
    return _____539F_751F_51FD_6570_8868.KKDestroyCommandButton(_____6574_65701)
end
____exports["平台扩展_世界坐标_绑定Frame到物品实时位置"] = function(_____754C_9762, _____5355_4F4D, _____4E16_754Cx, _____4E16_754Cy, _____4E16_754Cz, _____5C4F_5E55x, _____5C4F_5E55y, _____96FE_4E2D_53EF_89C1, _____7269_54C1_53EF_89C1)
    return _____539F_751F_51FD_6570_8868.KKFrameBindItem(
        _____754C_9762,
        _____5355_4F4D,
        _____4E16_754Cx,
        _____4E16_754Cy,
        _____4E16_754Cz,
        _____5C4F_5E55x,
        _____5C4F_5E55y,
        _____96FE_4E2D_53EF_89C1,
        _____7269_54C1_53EF_89C1
    )
end
____exports["平台扩展_技能按钮_绑定单位技能"] = function(_____6574_65701, _____5355_4F4D, _____6280_80FD_4EE3_7801)
    return _____539F_751F_51FD_6570_8868.KKSetCommandUnitAbility(_____6574_65701, _____5355_4F4D, _____6280_80FD_4EE3_7801)
end
____exports["平台扩展_设单位整数物编数据"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWESetUnitDataCacheInteger(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据农民可建造建筑"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddBuildsIds(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据制造的物品"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddMakesItemIds(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据科技需求值"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddRequiresAmounts(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据科技需求"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddRequiresTechcode(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据科技需求_2"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddRequiresUnitCode(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据可研究的科技"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddResearchesIds(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据出售的物品"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddSellsItemIds(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据出售的单位"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddSellsUnitIds(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据可训练的单位"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddTrainsIds(_____5355_4F4DID, ID, _____6574_65703)
end
____exports["平台扩展_设单位物编数据建筑升级"] = function(_____5355_4F4DID, ID, _____6574_65703)
    return _____539F_751F_51FD_6570_8868.KKWEUnitUIAddUpgradesIds(_____5355_4F4DID, ID, _____6574_65703)
end
return ____exports
