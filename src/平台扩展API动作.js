/** @noSelfInFile */
const 平台原生表 = require("jass.japi");
const 原生函数表 = 平台原生表;
export function 设技能启用_禁用(技能, 是否启用, 是否隐藏界面) {
    return 原生函数表["DzAbilitySetEnable"](技能, 是否启用, 是否隐藏界面);
}
export function 设技能数据_字符串(技能, 键名, 值) {
    return 原生函数表["DzAbilitySetStringData"](技能, 键名, 值);
}
export function 地图_清理服务器数据(玩家, 键名) {
    return 原生函数表["DzAPI_Map_FlushStoredMission"](玩家, 键名);
}
export function 地图_上报本局游戏玩家数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_GameResult_CommitData"](玩家, 键名, 值);
}
export function 地图_上报本局游戏模式(值) {
    return 原生函数表["DzAPI_Map_GameResult_CommitGameMode"](值);
}
export function 地图_上报本局游戏结果(玩家, 值) {
    return 原生函数表["DzAPI_Map_GameResult_CommitGameResult"](玩家, 值);
}
export function 地图_上报本局游戏结果不结束游戏(玩家, 值) {
    return 原生函数表["DzAPI_Map_GameResult_CommitGameResultNoEnd"](玩家, 值);
}
export function 地图_上报本局游戏玩家排名(玩家, 值) {
    return 原生函数表["DzAPI_Map_GameResult_CommitPlayerRank"](玩家, 值);
}
export function 地图_上报本局游戏玩家称号(玩家, 值) {
    return 原生函数表["DzAPI_Map_GameResult_CommitTitle"](玩家, 值);
}
export function 地图_全局修改消息(触发器) {
    return 原生函数表["DzAPI_Map_Global_ChangeMsg"](触发器);
}
export function 地图_保存全局存档(键名, 值) {
    return 原生函数表["DzAPI_Map_Global_StoreString"](键名, 值);
}
export function 地图_天梯设玩家统计(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SetPlayerStat"](玩家, 键名, 值);
}
export function 地图_天梯提交字符串数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SetStat"](玩家, 键名, 值);
}
export function 地图_天梯提交技能数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitAblityIdData"](玩家, 键名, 值);
}
export function 地图_天梯提交布尔值数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitBooleanData"](玩家, 键名, 值);
}
export function 地图_天梯提交整数数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitIntegerData"](玩家, 键名, 值);
}
export function 地图_天梯提交物品数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitItemData"](玩家, 键名, 值);
}
export function 地图_天梯提交物品数据_2(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitItemIdData"](玩家, 键名, 值);
}
export function 地图_天梯设置玩家额外分(玩家, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitPlayerExtraExp"](玩家, 值);
}
export function 地图_天梯提交玩家排名(玩家, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitPlayerRank"](玩家, 值);
}
export function 地图_天梯提交获得称号(玩家, 值) {
    return 原生函数表["DzAPI_Map_Ladder_SubmitTitle"](玩家, 值);
}
export function 地图_任务完成(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_MissionComplete"](玩家, 键名, 值);
}
export function 地图_触发BOSS击杀(玩家, 键名) {
    return 原生函数表["DzAPI_Map_OrpgTrigger"](玩家, 键名);
}
export function 地图_保存服务器存档(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_SaveServerArchive"](玩家, 键名, 值);
}
export function 地图_上报房间内显示的数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Stat_SetStat"](玩家, 键名, 值);
}
export function 地图_统计提交单位数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Stat_SubmitUnitData"](玩家, 键名, 值);
}
export function 地图_天梯提交单位类型数据(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_Stat_SubmitUnitIdData"](玩家, 键名, 值);
}
export function 地图_上报埋点数据(玩家, 事件键, 事件类型, 值) {
    return 原生函数表["DzAPI_Map_Statistics"](玩家, 事件键, 事件类型, 值);
}
export function 地图_保存布尔值变量至服务器(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_StoreBoolean"](玩家, 键名, 值);
}
export function 地图_保存整数变量至服务器(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_StoreInteger"](玩家, 键名, 值);
}
export function 地图_服务器存储整数(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_StoreIntegerEX"](玩家, 键名, 值);
}
export function 地图_保存实数变量至服务器(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_StoreReal"](玩家, 键名, 值);
}
export function 地图_保存字符串变量至服务器(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_StoreString"](玩家, 键名, 值);
}
export function 地图_服务器存储字符串(玩家, 键名, 值) {
    return 原生函数表["DzAPI_Map_StoreStringEX"](玩家, 键名, 值);
}
export function 地图_使用地图商城道具局数型(玩家, 键名) {
    return 原生函数表["DzAPI_Map_UseConsumablesItem"](玩家, 键名);
}
export function 结束普攻技能CD(句柄) {
    return 原生函数表["DzAttackAbilityEndCooldown"](句柄);
}
export function 绑定特效(父界面, 附着点, 特效) {
    return 原生函数表["DzBindEffect"](父界面, 附着点, 特效);
}
export function 设整数的2进制的位值(整数值, 字节序号, 字节值) {
    return 原生函数表["DzBitSet"](整数值, 字节序号, 字节值);
}
export function 设整数的256进制的位值(整数值, 字节序号, 字节值) {
    return 原生函数表["DzBitSetByte"](整数值, 字节序号, 字节值);
}
export function 设魔兽窗口大小(宽度, 高度) {
    return 原生函数表["DzChangeWindowSize"](宽度, 高度);
}
export function 界面_创建(名称, 父界面, ID) {
    return 原生函数表["DzCreateFrame"](名称, 父界面, ID);
}
export function 界面_按标签创建(类型, 名称, 父界面, 模板, ID) {
    return 原生函数表["DzCreateFrameByTagName"](类型, 名称, 父界面, 模板, ID);
}
export function 游戏_禁用攻速限制() {
    return 原生函数表["DzDisableAttackSpeedLimit"]();
}
export function 游戏_屏蔽按键游戏UI消息(玩家, 键码) {
    return 原生函数表["DzDisableGameUIKeyboard"](玩家, 键码);
}
export function 界面_屏蔽所有物品指向UI() {
    return 原生函数表["DzDisableItemPreselectUi"]();
}
export function 界面_屏蔽所有单位指向UI跟血条() {
    return 原生函数表["DzDisableUnitPreselectUi"]();
}
export function 游戏_屏蔽按键窗口消息(玩家, 键码) {
    return 原生函数表["DzDisableWindowKeyboard"](玩家, 键码);
}
export function 装饰物_删除装饰物(装饰物) {
    return 原生函数表["DzDoodadRemove"](装饰物);
}
export function 装饰物_装饰物播放动画(装饰物, 动画名, 是否随机动画) {
    return 原生函数表["DzDoodadSetAnimation"](装饰物, 动画名, 是否随机动画);
}
export function 装饰物_设装饰物颜色(装饰物, 颜色) {
    return 原生函数表["DzDoodadSetColor"](装饰物, 颜色);
}
export function 装饰物_设装饰物模型(装饰物, 模型路径) {
    return 原生函数表["DzDoodadSetModel"](装饰物, 模型路径);
}
export function 装饰物_装饰物重置大小(装饰物) {
    return 原生函数表["DzDoodadSetOrientMatrixResize"](装饰物);
}
export function 装饰物_设装饰物旋转(装饰物, 角度, 轴x, 轴y, 轴z) {
    return 原生函数表["DzDoodadSetOrientMatrixRotate"](装饰物, 角度, 轴x, 轴y, 轴z);
}
export function 装饰物_修改装饰物尺寸(装饰物, x, y, z) {
    return 原生函数表["DzDoodadSetOrientMatrixScale"](装饰物, x, y, z);
}
export function 装饰物_设装饰物位置(装饰物, x, y, z) {
    return 原生函数表["DzDoodadSetPosition"](装饰物, x, y, z);
}
export function 装饰物_改变装饰物队伍颜色(装饰物, 颜色) {
    return 原生函数表["DzDoodadSetTeamColor"](装饰物, 颜色);
}
export function 装饰物_设装饰物动画播放速度(装饰物, 缩放) {
    return 原生函数表["DzDoodadSetTimeScale"](装饰物, 缩放);
}
export function 装饰物_装饰物显示_隐藏(装饰物, 是否启用) {
    return 原生函数表["DzDoodadSetVisible"](装饰物, 是否启用);
}
export function 特效_特效绑定特效(句柄, 字符串2, 特效) {
    return 原生函数表["DzEffectBindEffect"](句柄, 字符串2, 特效);
}
export function 允许查看指定单位技能(单位, 是否启用) {
    return 原生函数表["DzEnableDrawSkillPanel"](单位, 是否启用);
}
export function 允许查看指定玩家单位技能(玩家, 是否启用) {
    return 原生函数表["DzEnableDrawSkillPanelByPlayer"](玩家, 是否启用);
}
export function 哈希表_开启保存空值逆天设置null(是否启用) {
    return 原生函数表["DzEnableHashtableSetNull"](是否启用);
}
export function 游戏_修复单位命令事件泄漏() {
    return 原生函数表["DzFixUnitEventMemoryLeak"]();
}
export function 游戏_模拟按键游戏UI消息(玩家, 键码, 是否按下) {
    return 原生函数表["DzForceUiKeyboard"](玩家, 键码, 是否按下);
}
export function 界面_世界坐标_为绑定的Frame添加隐藏区域(界面, 左, 下, 右, 上, 宽度, 高度) {
    return 原生函数表["DzFrameBindAddHideRect"](界面, 左, 下, 右, 上, 宽度, 高度);
}
export function 界面_世界坐标_绑定Frame到单位实时位置(界面, 单位, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见, 单位可见, 死亡可见) {
    return 原生函数表["DzFrameBindWidget"](界面, 单位, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见, 单位可见, 死亡可见);
}
export function 界面_世界坐标_绑定Frame到世界坐标实时位置(界面, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见) {
    return 原生函数表["DzFrameBindWorldPos"](界面, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见);
}
export function 界面_游戏界面限制设置(是否启用) {
    return 原生函数表["DzFrameEnableClipRect"](是否启用);
}
export function 界面_血条刷新事件(回调) {
    return 原生函数表["DzFrameHookHpBar"](回调);
}
export function 界面_移除模型特效(模型界面, 特效界面) {
    return 原生函数表["DzFrameRemoveModelEffect"](模型界面, 特效界面);
}
export function 界面_设绝对点位(界面, 点位, x, y) {
    return 原生函数表["DzFrameSetAbsolutePoint"](界面, 点位, x, y);
}
export function 界面_设透明度(界面, 透明度) {
    return 原生函数表["DzFrameSetAlpha"](界面, 透明度);
}
export function 界面_设模型界面播放动画编号(界面, 序号, 整数3) {
    return 原生函数表["DzFrameSetAnimateByIndex"](界面, 序号, 整数3);
}
export function 界面_设置复选框勾选状态(勾选框界面, 是否勾选) {
    return 原生函数表["DzFrameSetCheckBoxState"](勾选框界面, 是否勾选);
}
export function 界面_设控件视口(界面, 是否启用) {
    return 原生函数表["DzFrameSetClip"](界面, 是否启用);
}
export function 界面_设置编辑框激活状态(界面, 是否激活) {
    return 原生函数表["DzFrameSetEditBoxActive"](界面, 是否激活);
}
export function 界面_设置编辑框禁用输入法(界面, 是否禁用) {
    return 原生函数表["DzFrameSetEditBoxDisableIme"](界面, 是否禁用);
}
export function 界面_设字体(界面, 参数2, 高度, 参数4) {
    return 原生函数表["DzFrameSetFont"](界面, 参数2, 高度, 参数4);
}
export function 界面_设置Frame控件忽略点击事件(界面, 布尔2) {
    return 原生函数表["DzFrameSetIgnoreTrackEvents"](界面, 布尔2);
}
export function 界面_设模型2(模型界面, 模型路径, 队伍颜色ID) {
    return 原生函数表["DzFrameSetModel2"](模型界面, 模型路径, 队伍颜色ID);
}
export function 界面_设模型动画(模型界面, 动画) {
    return 原生函数表["DzFrameSetModelAnimation"](模型界面, 动画);
}
export function 界面_设模型动画按序号(模型界面, 整数2) {
    return 原生函数表["DzFrameSetModelAnimationByIndex"](模型界面, 整数2);
}
export function 界面_设模型镜头源(模型界面, x, y, z) {
    return 原生函数表["DzFrameSetModelCameraSource"](模型界面, x, y, z);
}
export function 界面_设模型镜头目标(模型界面, x, y, z) {
    return 原生函数表["DzFrameSetModelCameraTarget"](模型界面, x, y, z);
}
export function 界面_设模型颜色(模型界面, 颜色) {
    return 原生函数表["DzFrameSetModelColor"](模型界面, 颜色);
}
export function 界面_设模型启用宽屏幕(界面, 是否启用) {
    return 原生函数表["DzFrameSetModelEnableWideScreen"](界面, 是否启用);
}
export function 界面_设模型矩阵重置(模型界面) {
    return 原生函数表["DzFrameSetModelMatReset"](模型界面);
}
export function 界面_设模型粒子2大小(模型界面, 缩放) {
    return 原生函数表["DzFrameSetModelParticle2Size"](模型界面, 缩放);
}
export function 界面_设模型位置(模型界面, x, y, z) {
    return 原生函数表["DzFrameSetModelPosition"](模型界面, x, y, z);
}
export function 界面_设模型旋转横坐标(模型界面, x) {
    return 原生函数表["DzFrameSetModelRotateX"](模型界面, x);
}
export function 界面_设模型旋转纵坐标(模型界面, y) {
    return 原生函数表["DzFrameSetModelRotateY"](模型界面, y);
}
export function 界面_设模型旋转高度(模型界面, z) {
    return 原生函数表["DzFrameSetModelRotateZ"](模型界面, z);
}
export function 界面_设模型缩放(模型界面, x, y, z) {
    return 原生函数表["DzFrameSetModelScale"](模型界面, x, y, z);
}
export function 界面_设模型大小(模型界面, 大小) {
    return 原生函数表["DzFrameSetModelSize"](模型界面, 大小);
}
export function 界面_设模型速度(模型界面, 速度) {
    return 原生函数表["DzFrameSetModelSpeed"](模型界面, 速度);
}
export function 界面_设模型贴图(模型界面, 字符串2, 整数3) {
    return 原生函数表["DzFrameSetModelTexture"](模型界面, 字符串2, 整数3);
}
export function 界面_设模型横坐标(模型界面, x) {
    return 原生函数表["DzFrameSetModelX"](模型界面, x);
}
export function 界面_设模型纵坐标(模型界面, y) {
    return 原生函数表["DzFrameSetModelY"](模型界面, y);
}
export function 界面_设模型高度(模型界面, z) {
    return 原生函数表["DzFrameSetModelZ"](模型界面, z);
}
export function 界面_设置控件全局名字跟绑定整数(界面, 名称, 上下文) {
    return 原生函数表["DzFrameSetNameContext"](界面, 名称, 上下文);
}
export function 界面_设点位(界面, 点位, 相对界面, 相对点位, x, y) {
    return 原生函数表["DzFrameSetPoint"](界面, 点位, 相对界面, 相对点位, x, y);
}
export function 界面_设优先级(界面, 优先级) {
    return 原生函数表["DzFrameSetPriority"](界面, 优先级);
}
export function 界面_设大小(界面, 宽度, 高度) {
    return 原生函数表["DzFrameSetSize"](界面, 宽度, 高度);
}
export function 界面_设界面纹理坐标(界面, 左, 上, 右, 下) {
    return 原生函数表["DzFrameSetTexCoord"](界面, 左, 上, 右, 下);
}
export function 界面_设文本(界面, 文本) {
    return 原生函数表["DzFrameSetText"](界面, 文本);
}
export function 界面_设文本对齐(界面, 参数2) {
    return 原生函数表["DzFrameSetTextAlignment"](界面, 参数2);
}
export function 界面_设文本颜色(界面, 参数2, 单位组, 值B, 值A) {
    return 原生函数表["DzFrameSetTextColor"](界面, 参数2, 单位组, 值B, 值A);
}
export function 界面_设置文本控件字间距(文本界面, 字距) {
    return 原生函数表["DzFrameSetTextFontSpacing"](文本界面, 字距);
}
export function 界面_设贴图(界面, 贴图路径, 参数3) {
    return 原生函数表["DzFrameSetTexture"](界面, 贴图路径, 参数3);
}
export function 界面_显示(界面, 是否显示) {
    return 原生函数表["DzFrameShow"](界面, 是否显示);
}
export function 界面_世界坐标_解除Frame的绑定(界面) {
    return 原生函数表["DzFrameUnBind"](界面);
}
export function 界面_解锁右下角区域鼠标焦点限制(是否解锁) {
    return 原生函数表["DzFrameUnlockMouseRectLimit"](是否解锁);
}
export function 物品_模型重置旋转缩(物品) {
    return 原生函数表["DzItemMatReset"](物品);
}
export function 物品_模型按照横坐标轴旋转(物品, x) {
    return 原生函数表["DzItemMatRotateX"](物品, x);
}
export function 物品_模型按照纵坐标轴旋转(物品, y) {
    return 原生函数表["DzItemMatRotateY"](物品, y);
}
export function 物品_模型按照高度轴旋转(物品, z) {
    return 原生函数表["DzItemMatRotateZ"](物品, z);
}
export function 物品_模型按照横坐标纵坐标高度轴缩放(物品, x, y, z) {
    return 原生函数表["DzItemMatScale"](物品, x, y, z);
}
export function 物品_设物品透明度0_255(物品, 颜色) {
    return 原生函数表["DzItemSetAlpha"](物品, 颜色);
}
export function 物品_设物品模型(物品, 字符串2) {
    return 原生函数表["DzItemSetModel"](物品, 字符串2);
}
export function 物品_设物品头像(物品, 字符串2) {
    return 原生函数表["DzItemSetPortrait"](物品, 字符串2);
}
export function 物品_物品大小(物品, 大小) {
    return 原生函数表["DzItemSetSize"](物品, 大小);
}
export function 物品_设物品颜色(物品, 颜色) {
    return 原生函数表["DzItemSetVertexColor"](物品, 颜色);
}
export function 加载界面目录(路径) {
    return 原生函数表["DzLoadToc"](路径);
}
export function 清除所有模型内存缓存() {
    return 原生函数表["DzModelRemoveAllFromCache"]();
}
export function 清除模型内存缓存(路径) {
    return 原生函数表["DzModelRemoveFromCache"](路径);
}
export function 打开_群聊群链接(链接) {
    return 原生函数表["DzOpenQQGroupUrl"](链接);
}
export function 设特效播放动画(特效, 动画, 链接) {
    return 原生函数表["DzPlayEffectAnimation"](特效, 动画, 链接);
}
export function 玩家_发送聊天消息触发同步事件(玩家, 消息, 接收者) {
    return 原生函数表["DzPlayerSendChat"](玩家, 消息, 接收者);
}
export function 添加中介命令到队列无目标(归属玩家, 中立建筑, 单位ID) {
    return 原生函数表["DzQueueIssueNeutralImmediateOrderById"](归属玩家, 中立建筑, 单位ID);
}
export function 添加中介命令到队列指定坐标(归属玩家, 中立建筑, 单位ID, x, y) {
    return 原生函数表["DzQueueIssueNeutralPointOrderById"](归属玩家, 中立建筑, 单位ID, x, y);
}
export function 监听建筑选位置(回调) {
    return 原生函数表["DzRegisterOnBuildLocal"](回调);
}
export function 监听技能预选目标(回调) {
    return 原生函数表["DzRegisterOnTargetLocal"](回调);
}
export function 降低玩家科技等级(玩家, 整数2, 整数3) {
    return 原生函数表["DzRemovePlayerTechResearched"](玩家, 整数2, 整数3);
}
export function 复活单位(单位, 玩家, 血, 实数4, x, y) {
    return 原生函数表["DzReviveUnit"](单位, 玩家, 血, 实数4, x, y);
}
export function 游戏_模拟按键窗口消息(玩家, 键码, 是否按下) {
    return 原生函数表["DzSendKeyboard"](玩家, 键码, 是否按下);
}
export function 设剪切板(字符串1) {
    return 原生函数表["DzSetClipboard"](字符串1);
}
export function 装饰物_设置地形装饰物矩阵重置(整数1) {
    return 原生函数表["DzSetDoodadsMatReset"](整数1);
}
export function 装饰物_设置地形装饰物矩阵旋转横坐标轴(整数1, x) {
    return 原生函数表["DzSetDoodadsMatRotateX"](整数1, x);
}
export function 装饰物_设置地形装饰物矩阵旋转纵坐标轴(整数1, y) {
    return 原生函数表["DzSetDoodadsMatRotateY"](整数1, y);
}
export function 装饰物_设置装饰物矩阵旋转高度轴(整数1, z) {
    return 原生函数表["DzSetDoodadsMatRotateZ"](整数1, z);
}
export function 装饰物_设置地形装饰物矩阵缩放(整数1, x, y, z) {
    return 原生函数表["DzSetDoodadsMatScale"](整数1, x, y, z);
}
export function 设特效播放动画_2(特效, 序号, 整数3) {
    return 原生函数表["DzSetEffectAnimation"](特效, 序号, 整数3);
}
export function 特效_设置特效迷雾可见(特效, 是否可见) {
    return 原生函数表["DzSetEffectFogVisible"](特效, 是否可见);
}
export function 特效_设置特效黑色阴影可见(特效, 是否可见) {
    return 原生函数表["DzSetEffectMaskVisible"](特效, 是否可见);
}
export function 设特效模型(特效, 模型路径) {
    return 原生函数表["DzSetEffectModel"](特效, 模型路径);
}
export function 设特效坐标(特效, x, y, z) {
    return 原生函数表["DzSetEffectPos"](特效, x, y, z);
}
export function 特效缩放(句柄, 缩放) {
    return 原生函数表["DzSetEffectScale"](句柄, 缩放);
}
export function 设特效队伍颜色(句柄, 玩家ID) {
    return 原生函数表["DzSetEffectTeamColor"](句柄, 玩家ID);
}
export function 设特效透明度(特效, 透明度) {
    return 原生函数表["DzSetEffectVertexAlpha"](特效, 透明度);
}
export function 设特效颜色(特效, 颜色) {
    return 原生函数表["DzSetEffectVertexColor"](特效, 颜色);
}
export function 特效显示_隐藏(句柄, 是否启用) {
    return 原生函数表["DzSetEffectVisible"](句柄, 是否启用);
}
export function 游戏_设置全局移速上_下限(建造最小, 建造最大, 单位最小, 单位最大, 实数5, 实数6, 实数7, 实数8, 实数9, 实数10) {
    return 原生函数表["DzSetGlobalUnitMinMaxMoveSpeed"](建造最小, 建造最大, 单位最小, 单位最大, 实数5, 实数6, 实数7, 实数8, 实数9, 实数10);
}
export function 英雄_设置主属性(单位, 属性) {
    return 原生函数表["DzSetHeroPrimaryAttribute"](单位, 属性);
}
export function 英雄_设置属性成长(单位, 整数2, 值, 保留当前加成) {
    return 原生函数表["DzSetHeroPrimaryAttributePlus"](单位, 整数2, 值, 保留当前加成);
}
export function 英雄_设置主属性类型(单位, 属性, 保留主属性加成) {
    return 原生函数表["DzSetHeroPrimaryAttributeType"](单位, 属性, 保留主属性加成);
}
export function 设英雄类型专名(单位ID, 名称) {
    return 原生函数表["DzSetHeroTypeProperName"](单位ID, 名称);
}
export function 物品_修改物品碰撞体积(物品, 大小) {
    return 原生函数表["DzSetItemCollisionSize"](物品, 大小);
}
export function 游戏_限制最高帧数(最大FPS) {
    return 原生函数表["DzSetMaxFps"](最大FPS);
}
export function 游戏_设置攻速上限(实数1, 实数2) {
    return 原生函数表["DzSetMinMaxAttackSpeedFactor"](实数1, 实数2);
}
export function 游戏_设置移速可叠加(是否启用) {
    return 原生函数表["DzSetMoveSpeedBonusesStack"](是否启用);
}
export function 设粒子2大小(控件, 缩放) {
    return 原生函数表["DzSetPariticle2Size"](控件, 缩放);
}
export function 技能_设置技能施法范围(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityArea"](单位, 技能代码, 值);
}
export function 技能_设置技能图标(单位, 技能ID, 字符串3) {
    return 原生函数表["DzSetUnitAbilityArt"](单位, 技能ID, 字符串3);
}
export function 技能_设置技能魔法施放回复后摇_2(单位, 技能ID, 值) {
    return 原生函数表["DzSetUnitAbilityBackSwing"](单位, 技能ID, 值);
}
export function 技能_设置建造技能模型象牙塔(单位, 技能代码, 模型路径, 模型缩放) {
    return 原生函数表["DzSetUnitAbilityBuildModel"](单位, 技能代码, 模型路径, 模型缩放);
}
export function 技能_设置建造技能命令编号象牙塔(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityBuildOrderId"](单位, 技能代码, 值);
}
export function 技能_设置技能按钮位置(单位, 技能代码, x, y) {
    return 原生函数表["DzSetUnitAbilityButtonPos"](单位, 技能代码, x, y);
}
export function 技能_设置技能魔法施放点前摇(单位, 技能ID, 值) {
    return 原生函数表["DzSetUnitAbilityCastPoint"](单位, 技能ID, 值);
}
export function 技能_设置技能魔法施法时间(单位, 技能ID, 值) {
    return 原生函数表["DzSetUnitAbilityCastTime"](单位, 技能ID, 值);
}
export function 技能_设置技能冷却时间(单位, 技能代码, 冷却, 最大冷却) {
    return 原生函数表["DzSetUnitAbilityCool"](单位, 技能代码, 冷却, 最大冷却);
}
export function 技能_设置技能魔法消耗(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityCost"](单位, 技能代码, 值);
}
export function 技能_设置技能dataA(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityDataA"](单位, 技能代码, 值);
}
export function 技能_设置技能dataB(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityDataB"](单位, 技能代码, 值);
}
export function 技能_设置技能dataC(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityDataC"](单位, 技能代码, 值);
}
export function 技能_设置技能dataD(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityDataD"](单位, 技能代码, 值);
}
export function 技能_设置技能dataE(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityDataE"](单位, 技能代码, 值);
}
export function 技能_设置技能禁用(单位, 技能ID) {
    return 原生函数表["DzSetUnitAbilityDisable"](单位, 技能ID);
}
export function 技能_设置技能持续时间普通(单位, 技能ID, 值) {
    return 原生函数表["DzSetUnitAbilityDuration"](单位, 技能ID, 值);
}
export function 技能_设置技能启用(单位, 技能ID) {
    return 原生函数表["DzSetUnitAbilityEnable"](单位, 技能ID);
}
export function 技能_工程升级_替换技能要相同模板(单位, 旧ID, 新ID, 更新英雄技能) {
    return 原生函数表["DzSetUnitAbilityEngineeringUpgrade"](单位, 旧ID, 新ID, 更新英雄技能);
}
export function 技能_工程升级_取消替换技能(单位, 旧ID) {
    return 原生函数表["DzSetUnitAbilityEngineeringUpgradeCancel"](单位, 旧ID);
}
export function 技能_设置技能持续时间英雄(单位, 技能ID, 值) {
    return 原生函数表["DzSetUnitAbilityHeroDuration"](单位, 技能ID, 值);
}
export function 技能_设置技能快捷键(单位, 技能代码, 键名) {
    return 原生函数表["DzSetUnitAbilityHotkey"](单位, 技能代码, 键名);
}
export function 技能_设置技能投射物弧度(单位, 技能ID, 弹道弧度) {
    return 原生函数表["DzSetUnitAbilityMissileArc"](单位, 技能ID, 弹道弧度);
}
export function 技能_设置技能投射物模型(单位, 技能ID, 弹道美术) {
    return 原生函数表["DzSetUnitAbilityMissileArt"](单位, 技能ID, 弹道美术);
}
export function 技能_设置技能投射物数量弹幕攻击(单位, 技能ID, 弹道数量) {
    return 原生函数表["DzSetUnitAbilityMissileCount"](单位, 技能ID, 弹道数量);
}
export function 技能_设置技能投射物伤害弹幕攻击(单位, 技能ID, 伤害, 最大伤害, 参数5, 参数6) {
    return 原生函数表["DzSetUnitAbilityMissileDamage"](单位, 技能ID, 伤害, 最大伤害, 参数5, 参数6);
}
export function 技能_设置技能投射物允许自导(单位, 技能ID, 弹道追踪) {
    return 原生函数表["DzSetUnitAbilityMissileHoming"](单位, 技能ID, 弹道追踪);
}
export function 技能_设置技能投射物速度(单位, 技能ID, 弹道速度) {
    return 原生函数表["DzSetUnitAbilityMissileSpeed"](单位, 技能ID, 弹道速度);
}
export function 技能_设置技能命令编号(单位, 技能ID, 命令ID) {
    return 原生函数表["DzSetUnitAbilityOrderId"](单位, 技能ID, 命令ID);
}
export function 技能_设置技能施法距离(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityRange"](单位, 技能代码, 值);
}
export function 技能_设置技能等级要求(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityReqLevel"](单位, 技能代码, 值);
}
export function 技能_设置魔法书技能列表添加新技能(单位, 技能ID, 添加技能ID) {
    return 原生函数表["DzSetUnitAbilitySpellBookAddAbility"](单位, 技能ID, 添加技能ID);
}
export function 技能_设置魔法书的技能列表(单位, 技能ID, 技能列表, 保存冷却) {
    return 原生函数表["DzSetUnitAbilitySpellBookList"](单位, 技能ID, 技能列表, 保存冷却);
}
export function 技能_设置魔法书技能列表移除指定技能(单位, 技能ID, 移除技能ID) {
    return 原生函数表["DzSetUnitAbilitySpellBookRemoveAbility"](单位, 技能ID, 移除技能ID);
}
export function 技能_设置技能目标允许(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityTargs"](单位, 技能代码, 值);
}
export function 技能_设置技能科技条件达成(单位, 技能ID, 达成) {
    return 原生函数表["DzSetUnitAbilityTechReach"](单位, 技能ID, 达成);
}
export function 技能_设置技能科技条件文本(单位, 技能ID, 提示) {
    return 原生函数表["DzSetUnitAbilityTechReachTip"](单位, 技能ID, 提示);
}
export function 技能_设置技能提示(单位, 技能ID, 提示) {
    return 原生函数表["DzSetUnitAbilityTip"](单位, 技能ID, 提示);
}
export function 技能_设置技能提示扩展(单位, 技能ID, 扩展提示) {
    return 原生函数表["DzSetUnitAbilityUberTip"](单位, 技能ID, 扩展提示);
}
export function 技能_设置建造技能单位编号象牙塔(单位, 技能代码, 值) {
    return 原生函数表["DzSetUnitAbilityUnitId"](单位, 技能代码, 值);
}
export function 技能_设置刷新数据(单位, 技能ID) {
    return 原生函数表["DzSetUnitAbilityUpdate"](单位, 技能ID);
}
export function 单位_设置单位作为目标类型(单位, 目标类型) {
    return 原生函数表["DzSetUnitAsAttackTargetType"](单位, 目标类型);
}
export function 单位_设置单位攻击1目标允许(单位, 目标类型) {
    return 原生函数表["DzSetUnitAttack1TargetType"](单位, 目标类型);
}
export function 单位_设置单位攻击2目标允许(单位, 目标类型) {
    return 原生函数表["DzSetUnitAttack2TargetType"](单位, 目标类型);
}
export function 单位_设置攻击最大目标数(单位, 序号, 目标数量) {
    return 原生函数表["DzSetUnitAttackTargetCount"](单位, 序号, 目标数量);
}
export function 设单位攻击类型(单位, 序号, 攻击类型) {
    return 原生函数表["DzSetUnitAttackType"](单位, 序号, 攻击类型);
}
export function 单位_设置魔法施放回复后摇(单位, 实数2) {
    return 原生函数表["DzSetUnitBackSwing"](单位, 实数2);
}
export function 单位_设置魔法施放点前摇(单位, 施法点位) {
    return 原生函数表["DzSetUnitCastPoint"](单位, 施法点位);
}
export function 单位_修改单位碰撞体积(单位, 大小) {
    return 原生函数表["DzSetUnitCollisionSize"](单位, 大小);
}
export function 设单位数据缓存整数(单位ID, ID, 序号, 整数4) {
    return 原生函数表["DzSetUnitDataCacheInteger"](单位ID, ID, 序号, 整数4);
}
export function 设单位防御类型(单位, 防御类型) {
    return 原生函数表["DzSetUnitDefenseType"](单位, 防御类型);
}
export function 设单位描述(单位, 值) {
    return 原生函数表["DzSetUnitDescription"](单位, 值);
}
export function 单位_设置单位屏蔽控制命令模拟失控(单位, 是否禁用) {
    return 原生函数表["DzSetUnitDisableControlOrder"](单位, 是否禁用);
}
export function 单位_设置单位屏蔽本地命令模拟失控(单位, 是否禁用) {
    return 原生函数表["DzSetUnitDisableLocalOrder"](单位, 是否禁用);
}
export function 单位_设置单位禁用攻击(单位, 是否禁用) {
    return 原生函数表["DzUnitDisableAttack"](单位, 是否禁用);
}
export function 单位_设置单位是否忽略点击(单位, 布尔2) {
    return 原生函数表["DzSetUnitHitIgnore"](单位, 布尔2);
}
export function 单位_设置每秒生命恢复(单位, 回复) {
    return 原生函数表["DzSetUnitLifeRegen"](单位, 回复);
}
export function 单位_设置每秒魔法恢复(单位, 回复) {
    return 原生函数表["DzSetUnitManaRegen"](单位, 回复);
}
export function 单位_设置最高移动速度(单位, 速度, 忽略变形) {
    return 原生函数表["DzSetUnitMaxSpeed"](单位, 速度, 忽略变形);
}
export function 单位_设置最低移动速度(单位, 速度, 忽略变形) {
    return 原生函数表["DzSetUnitMinSpeed"](单位, 速度, 忽略变形);
}
export function 设单位普攻弹道弧度(单位, 弧度) {
    return 原生函数表["DzSetUnitMissileArc"](单位, 弧度);
}
export function 设单位普攻弹道自导允许(单位, 是否启用) {
    return 原生函数表["DzSetUnitMissileHoming"](单位, 是否启用);
}
export function 设单位普攻弹道模型(单位, 模型路径) {
    return 原生函数表["DzSetUnitMissileModel"](单位, 模型路径);
}
export function 设单位普攻弹道速度(单位, 速度) {
    return 原生函数表["DzSetUnitMissileSpeed"](单位, 速度);
}
export function 设单位名字(单位, 名称) {
    return 原生函数表["DzSetUnitName"](单位, 名称);
}
export function 设单位头像模型(单位, 模型路径) {
    return 原生函数表["DzSetUnitPortrait"](单位, 模型路径);
}
export function 设单位的鼠标指向UI和血条显示_隐藏(单位, 是否显示) {
    return 原生函数表["DzSetUnitPreselectUIVisible"](单位, 是否显示);
}
export function 设英雄称谓(单位, 名称) {
    return 原生函数表["DzSetUnitProperName"](单位, 名称);
}
export function 单位_修改单位选择圈缩放(单位, 缩放) {
    return 原生函数表["DzSetUnitSelectScale"](单位, 缩放);
}
export function 设单位类型名称(单位ID, 名称) {
    return 原生函数表["DzSetUnitTypeName"](单位ID, 名称);
}
export function 单位_设置横坐标纵坐标坐标不打断命令(单位, x, y) {
    return 原生函数表["DzSetUnitXY"](单位, x, y);
}
export function 单位缩放(单位, 缩放) {
    return 原生函数表["DzSetWidgetSpriteScale"](单位, 缩放);
}
export function 设控件贴图(句柄, 字符串2, 替换ID) {
    return 原生函数表["DzSetWidgetTexture"](句柄, 字符串2, 替换ID);
}
export function 简单消息界面_显示游戏提示信息(界面, 文本, 颜色, 持续时间, 布尔5) {
    return 原生函数表["DzSimpleMessageFrameAddMessage"](界面, 文本, 颜色, 持续时间, 布尔5);
}
export function 简单消息界面_清理游戏提示信息(界面) {
    return 原生函数表["DzSimpleMessageFrameClear"](界面);
}
export function 漂浮字_设漂浮文字字体(文件名) {
    return 原生函数表["DzTextTagSetFont"](文件名);
}
export function 漂浮字_设漂浮文字阴影颜色(类型, 颜色) {
    return 原生函数表["DzTextTagSetShadowColor"](类型, 颜色);
}
export function 漂浮字_设漂浮文字透明度(类型, 透明度) {
    return 原生函数表["DzTextTagSetStartAlpha"](类型, 透明度);
}
export function 设帧率显示_隐藏(显示) {
    return 原生函数表["DzToggleFPS"](显示);
}
export function 平台_触发注册按键事件按代码(触发器, 按键代码, 参数3, 同步, 参数5) {
    return 原生函数表["DzTriggerRegisterKeyEventByCode"](触发器, 按键代码, 参数3, 同步, 参数5);
}
export function 解除绑定特效(特效) {
    return 原生函数表["DzUnbindEffect"](特效);
}
export function 单位_清除单位命令队列(单位, 布尔2) {
    return 原生函数表["DzUnitOrdersClear"](单位, 布尔2);
}
export function 单位_执行单位的命令队列(单位) {
    return 原生函数表["DzUnitOrdersExec"](单位);
}
export function 单位_强制停止单位当前命令(单位, 清空队列) {
    return 原生函数表["DzUnitOrdersForceStop"](单位, 清空队列);
}
export function 单位_反转单位命令队列(单位) {
    return 原生函数表["DzUnitOrdersReverse"](单位);
}
export function 单位_设单位实例的移动类型(单位, 移动类型) {
    return 原生函数表["DzUnitSetMoveType"](单位, 移动类型);
}
export function 单位_界面添加等级数组整数(单位ID, ID, 整数3, 整数4) {
    return 原生函数表["DzUnitUIAddLevelArrayInteger"](单位ID, ID, 整数3, 整数4);
}
export function 解锁BLP像素限制(是否启用) {
    return 原生函数表["DzUnlockBlpSizeLimit"](是否启用);
}
export function 解锁JASS字节码限制(是否启用) {
    return 原生函数表["DzUnlockOpCodeLimit"](是否启用);
}
export function 自定义指定单位的小地图图标(单位, 路径) {
    return 原生函数表["DzWidgetSetMinimapIcon"](单位, 路径);
}
export function 开启_关闭自定义指定单位的小地图图标(单位, 是否启用) {
    return 原生函数表["DzWidgetSetMinimapIconEnable"](单位, 是否启用);
}
export function 硬件_设置游戏窗口位置(x, y) {
    return 原生函数表["DzWindowSetPoint"](x, y);
}
export function 硬件_设置游戏窗口大小(宽度, 高度) {
    return 原生函数表["DzWindowSetSize"](宽度, 高度);
}
export function 打印调试信息到平台日志(消息) {
    return 原生函数表["DzWriteLog"](消息);
}
export function 关闭_工作表(整数1) {
    return 原生函数表["DzXlsxClose"](整数1);
}
export function 打开_Excel文件(文件路径) {
    return 原生函数表["DzXlsxOpen"](文件路径);
}
export function 扩展_禁用单位碰撞(单位, 类型) {
    return 原生函数表["EXDisableUnitCollision"](单位, 类型);
}
export function 扩展_特效矩阵旋转高度(E, 角度) {
    return 原生函数表["EXEffectMatRotateZ"](E, 角度);
}
export function 扩展_特效矩阵缩放(E, x, y, z) {
    return 原生函数表["EXEffectMatScale"](E, x, y, z);
}
export function 扩展_启用单位碰撞(单位, 类型) {
    return 原生函数表["EXEnableUnitCollision"](单位, 类型);
}
export function 单位扩展_暂停(单位, 参数2) {
    return 原生函数表["EXPauseUnit"](单位, 参数2);
}
export function 技能扩展_设杂项DataA(技能, 单位ID) {
    return 原生函数表["EXSetAbilityAEmeDataA"](技能, 单位ID);
}
export function 技能扩展_设整数数据(技能, 等级, 数据类型, 值) {
    return 原生函数表["EXSetAbilityDataInteger"](技能, 等级, 数据类型, 值);
}
export function 技能扩展_设实数数据(技能, 等级, 数据类型, 值) {
    return 原生函数表["EXSetAbilityDataReal"](技能, 等级, 数据类型, 值);
}
export function 技能扩展_设字符串数据(技能, 等级, 数据类型, 值) {
    return 原生函数表["EXSetAbilityDataString"](技能, 等级, 数据类型, 值);
}
export function 技能扩展_设状态(技能, 状态类型, 值) {
    return 原生函数表["EXSetAbilityState"](技能, 状态类型, 值);
}
export function 扩展_设特效大小(E, 大小) {
    return 原生函数表["EXSetEffectSize"](E, 大小);
}
export function 扩展_设特效速度(E, 速度) {
    return 原生函数表["EXSetEffectSpeed"](E, 速度);
}
export function 扩展_设特效高度(特效, z) {
    return 原生函数表["EXSetEffectZ"](特效, z);
}
export function 物品扩展_设字符串数据(物品编码, 数据类型, 值) {
    return 原生函数表["EXSetItemDataString"](物品编码, 数据类型, 值);
}
export function 单位扩展_设数组字符串(单位ID, ID, 整数3, 名称) {
    return 原生函数表["EXSetUnitArrayString"](单位ID, ID, 整数3, 名称);
}
export function 单位扩展_设碰撞类型(是否启用, 单位, 类型) {
    return 原生函数表["EXSetUnitCollisionType"](是否启用, 单位, 类型);
}
export function 单位扩展_设朝向(单位, 角度) {
    return 原生函数表["EXSetUnitFacing"](单位, 角度);
}
export function 单位扩展_设整数(单位ID, ID, 整数3) {
    return 原生函数表["EXSetUnitInteger"](单位ID, ID, 整数3);
}
export function 单位扩展_设移动类型(单位, 类型) {
    return 原生函数表["EXSetUnitMoveType"](单位, 类型);
}
export function 平台扩展_批量存档添加条目(玩家, 键名, 值, 布尔4) {
    return 原生函数表["KKApiAddBatchSaveArchive"](玩家, 键名, 值, 布尔4);
}
export function 平台扩展_添加条目_布尔值(玩家, 键名, 值) {
    return 原生函数表["KKApiAddBatchSaveArchiveBoolean"](玩家, 键名, 值);
}
export function 平台扩展_添加条目_整数(玩家, 键名, 值) {
    return 原生函数表["KKApiAddBatchSaveArchiveInteger"](玩家, 键名, 值);
}
export function 平台扩展_添加条目_实数(玩家, 键名, 值) {
    return 原生函数表["KKApiAddBatchSaveArchiveReal"](玩家, 键名, 值);
}
export function 平台扩展_添加条目_字符串(玩家, 键名, 值) {
    return 原生函数表["KKApiAddBatchSaveArchiveString"](玩家, 键名, 值);
}
export function 平台扩展_批量存档开始保存(玩家) {
    return 原生函数表["KKApiBeginBatchSaveArchive"](玩家);
}
export function 平台扩展_批量存档结束保存(玩家, 布尔2) {
    return 原生函数表["KKApiEndBatchSaveArchive"](玩家, 布尔2);
}
export function 平台扩展_初始化平台键位显示设置(玩家, 整数2, 字符串3, 数据) {
    return 原生函数表["KKApiInitializeGameKey"](玩家, 整数2, 字符串3, 数据);
}
export function 平台扩展_随机只读存档生成随机数(玩家, 键名, 分组键) {
    return 原生函数表["KKApiRequestBackendLogic"](玩家, 键名, 分组键);
}
export function 平台扩展_技能按钮_鼠标点击技能按钮(整数1, 鼠标类型) {
    return 原生函数表["KKCommandButtonClick"](整数1, 鼠标类型);
}
export function 平台扩展_界面_设置技能_物品按钮的冷却模型缩放大小(整数1, 大小) {
    return 原生函数表["KKCommandSetCooldownModelSize"](整数1, 大小);
}
export function 平台扩展_界面_设置技能_物品按钮的冷却模型缩放指定宽高比例(整数1, 宽度, 高度) {
    return 原生函数表["KKCommandSetCooldownModelSize2"](整数1, 宽度, 高度);
}
export function 平台扩展_技能按钮_删除技能按钮(整数1) {
    return 原生函数表["KKDestroyCommandButton"](整数1);
}
export function 平台扩展_世界坐标_绑定Frame到物品实时位置(界面, 单位, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见, 物品可见) {
    return 原生函数表["KKFrameBindItem"](界面, 单位, 世界x, 世界y, 世界z, 屏幕x, 屏幕y, 雾中可见, 物品可见);
}
export function 平台扩展_技能按钮_绑定单位技能(整数1, 单位, 技能代码) {
    return 原生函数表["KKSetCommandUnitAbility"](整数1, 单位, 技能代码);
}
export function 平台扩展_设单位整数物编数据(单位ID, ID, 整数3) {
    return 原生函数表["KKWESetUnitDataCacheInteger"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据农民可建造建筑(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddBuildsIds"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据制造的物品(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddMakesItemIds"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据科技需求值(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddRequiresAmounts"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据科技需求(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddRequiresTechcode"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据科技需求_2(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddRequiresUnitCode"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据可研究的科技(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddResearchesIds"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据出售的物品(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddSellsItemIds"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据出售的单位(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddSellsUnitIds"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据可训练的单位(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddTrainsIds"](单位ID, ID, 整数3);
}
export function 平台扩展_设单位物编数据建筑升级(单位ID, ID, 整数3) {
    return 原生函数表["KKWEUnitUIAddUpgradesIds"](单位ID, ID, 整数3);
}
