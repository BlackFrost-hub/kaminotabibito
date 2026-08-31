--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 技能喊话是全局 3D 语音：所有客户端都能听到，声源位于施法英雄单位处。
-- 资源已统一为 44.1 kHz、单声道、CBR 80 kbps MP3，供 CreateSound 的 3D 模式使用。
____exports["英雄技能喊话配置列表"] = {
    {
        ["英雄名"] = "伊蕾娜",
        ["技能ID"] = "AIQ1",
        ["技能槽"] = "Q",
        ["候选台词"] = {"逃がしませんよ、追尾魔法です。", "さて、当たるまで追いかけましょうか。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_Q01.mp3", "Sound\\HeroVoice\\Irena\\Irena_Q02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "伊蕾娜",
        ["技能ID"] = "AIW1",
        ["技能槽"] = "W",
        ["候选台词"] = {"鏡界よ、すべてを映し返しなさい。", "触れないほうが身のためですよ。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_W01.mp3", "Sound\\HeroVoice\\Irena\\Irena_W02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "伊蕾娜",
        ["技能ID"] = "AIE1",
        ["技能槽"] = "E",
        ["候选台词"] = {"それでは、ひとっ飛びです。", "風に乗りますよ、ついてきてくださいね。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_E01.mp3", "Sound\\HeroVoice\\Irena\\Irena_E02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "伊蕾娜",
        ["技能ID"] = "AIR1",
        ["技能槽"] = "R",
        ["候选台词"] = {"少しだけ、派手にいきましょうか。", "灰の魔女の魔法、とくとご覧ください。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_R01.mp3", "Sound\\HeroVoice\\Irena\\Irena_R02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 1.2,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "伊蕾娜",
        ["技能ID"] = "AID1",
        ["技能槽"] = "D",
        ["候选台词"] = {"さて、次はどの魔法にしましょうか。", "旅の途中ですし、魔法を変えましょう。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_D01.mp3", "Sound\\HeroVoice\\Irena\\Irena_D02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "爱蜜莉雅",
        ["技能ID"] = "AEQ1",
        ["技能槽"] = "Q",
        ["候选台词"] = {"氷の矢よ、まっすぐ進んで！", "お願い、当たって！ 氷の矢！"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Emilia\\Emilia_Q01.mp3", "Sound\\HeroVoice\\Emilia\\Emilia_Q02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "爱蜜莉雅",
        ["技能ID"] = "AEW1",
        ["技能槽"] = "W",
        ["候选台词"] = {"氷の花よ、きれいに咲いて！", "ここで止めるね、凍って！"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Emilia\\Emilia_W01.mp3", "Sound\\HeroVoice\\Emilia\\Emilia_W02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "爱蜜莉雅",
        ["技能ID"] = "AEE1",
        ["技能槽"] = "E",
        ["候选台词"] = {"氷の盾、私を守って！", "大丈夫、みんなは私が守るから！"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Emilia\\Emilia_E01.mp3", "Sound\\HeroVoice\\Emilia\\Emilia_E02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "爱蜜莉雅",
        ["技能ID"] = "AER1",
        ["技能槽"] = "R",
        ["候选台词"] = {"凍てつく庭よ、静かに広がって！", "みんなを守るために……凍って！"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Emilia\\Emilia_R01.mp3", "Sound\\HeroVoice\\Emilia\\Emilia_R02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 1.2,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "爱蜜莉雅",
        ["技能ID"] = "AED1",
        ["技能槽"] = "D",
        ["候选台词"] = {"パック、お願い！", "パック、力を貸して！"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Emilia\\Emilia_D01.mp3", "Sound\\HeroVoice\\Emilia\\Emilia_D02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院红叶",
        ["技能ID"] = "AMQ1",
        ["技能槽"] = "Q",
        ["候选台词"] = {"はいはい、さっさと終わらせましょうか。", "逃げてもいいですけど、追うのは面倒なんですよ。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Momiji\\Momiji_Q01.mp3", "Sound\\HeroVoice\\Momiji\\Momiji_Q02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院红叶",
        ["技能ID"] = "AMW1",
        ["技能槽"] = "W",
        ["候选台词"] = {"そこ、触らないでくださいね。", "受け流します。動くのは、それからで。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Momiji\\Momiji_W01.mp3", "Sound\\HeroVoice\\Momiji\\Momiji_W02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院红叶",
        ["技能ID"] = "AME1",
        ["技能槽"] = "E",
        ["候选台词"] = {"三回も斬るなんて、働き者でしょう？", "まとめて済ませます。楽ですから。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Momiji\\Momiji_E01.mp3", "Sound\\HeroVoice\\Momiji\\Momiji_E02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院红叶",
        ["技能ID"] = "AMR1",
        ["技能槽"] = "R",
        ["候选台词"] = {"少し本気を出しますね。", "これで終われば、休めますか？"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Momiji\\Momiji_R01.mp3", "Sound\\HeroVoice\\Momiji\\Momiji_R02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 1.2,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院红叶",
        ["技能ID"] = "AMD1",
        ["技能槽"] = "D",
        ["候选台词"] = {"少しだけ、力を借りますね。", "面倒ですが、片づけましょうか。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Momiji\\Momiji_D01.mp3", "Sound\\HeroVoice\\Momiji\\Momiji_D02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院椿",
        ["技能ID"] = "ATQ1",
        ["技能槽"] = "Q",
        ["候选台词"] = {"では、参りますね。", "抜けば、終わりです。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Tsubaki\\Tsubaki_Q01.mp3", "Sound\\HeroVoice\\Tsubaki\\Tsubaki_Q02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院椿",
        ["技能ID"] = "ATW1",
        ["技能槽"] = "W",
        ["候选台词"] = {"受けます。焦らないで。", "そこです。返します。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Tsubaki\\Tsubaki_W01.mp3", "Sound\\HeroVoice\\Tsubaki\\Tsubaki_W02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院椿",
        ["技能ID"] = "ATE1",
        ["技能槽"] = "E",
        ["候选台词"] = {"間合いを詰めます。", "この距離、いただきます。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Tsubaki\\Tsubaki_E01.mp3", "Sound\\HeroVoice\\Tsubaki\\Tsubaki_E02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院椿",
        ["技能ID"] = "ATR1",
        ["技能槽"] = "R",
        ["候选台词"] = {"ここで決めます。", "最後まで、私が斬ります。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Tsubaki\\Tsubaki_R01.mp3", "Sound\\HeroVoice\\Tsubaki\\Tsubaki_R02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 1.2,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "朱雀院椿",
        ["技能ID"] = "ATD1",
        ["技能槽"] = "D",
        ["候选台词"] = {"少しだけ、攻めに出ますね。", "大丈夫です。私が道を開きます。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Tsubaki\\Tsubaki_D01.mp3", "Sound\\HeroVoice\\Tsubaki\\Tsubaki_D02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "塞莉亚·克莱尔",
        ["技能ID"] = "AKQ1",
        ["技能槽"] = "Q",
        ["候选台词"] = {"術式、展開。撃ち抜くわ。", "計算は終わりよ。そこね。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Celia\\Celia_Q01.mp3", "Sound\\HeroVoice\\Celia\\Celia_Q02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "塞莉亚·克莱尔",
        ["技能ID"] = "AKW1",
        ["技能槽"] = "W",
        ["候选台词"] = {"結界を展開するわ。", "触れないでちょうだい。解析して返すから。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Celia\\Celia_W01.mp3", "Sound\\HeroVoice\\Celia\\Celia_W02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "塞莉亚·克莱尔",
        ["技能ID"] = "AKE1",
        ["技能槽"] = "E",
        ["候选台词"] = {"座標を固定するわ。", "逃がさない。ここで止めるわ。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Celia\\Celia_E01.mp3", "Sound\\HeroVoice\\Celia\\Celia_E02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "塞莉亚·克莱尔",
        ["技能ID"] = "AKR1",
        ["技能槽"] = "R",
        ["候选台词"] = {"高位術式、展開。", "閉じるわ。これで終わりよ。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Celia\\Celia_R01.mp3", "Sound\\HeroVoice\\Celia\\Celia_R02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 1.2,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "塞莉亚·克莱尔",
        ["技能ID"] = "AKD1",
        ["技能槽"] = "D",
        ["候选台词"] = {"術式を書き換えるわ。", "配置を変えるわ。少し待って。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Celia\\Celia_D01.mp3", "Sound\\HeroVoice\\Celia\\Celia_D02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "芙莉莲",
        ["技能ID"] = "AFQ1",
        ["技能槽"] = "Q",
        ["候选台词"] = {"撃ち抜くよ。", "そこにいるなら、当てる。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Frieren\\Frieren_Q01.mp3", "Sound\\HeroVoice\\Frieren\\Frieren_Q02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "芙莉莲",
        ["技能ID"] = "AFW1",
        ["技能槽"] = "W",
        ["候选台词"] = {"防御魔法。", "無駄だよ。ここは通さない。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Frieren\\Frieren_W01.mp3", "Sound\\HeroVoice\\Frieren\\Frieren_W02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "芙莉莲",
        ["技能ID"] = "AFE1",
        ["技能槽"] = "E",
        ["候选台词"] = {"少し、高いところへ。", "まあ、上から見ておこう。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Frieren\\Frieren_E01.mp3", "Sound\\HeroVoice\\Frieren\\Frieren_E02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "芙莉莲",
        ["技能ID"] = "AFR1",
        ["技能槽"] = "R",
        ["候选台词"] = {"じゃあ、終わらせよう。", "これで、終わり。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Frieren\\Frieren_R01.mp3", "Sound\\HeroVoice\\Frieren\\Frieren_R02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 1.2,
        ["三D裁断距离"] = 4000
    },
    {
        ["英雄名"] = "芙莉莲",
        ["技能ID"] = "AFD1",
        ["技能槽"] = "D",
        ["候选台词"] = {"花畑を作ろう。", "ここは、いい場所だね。"},
        ["候选语音列表"] = {"Sound\\HeroVoice\\Frieren\\Frieren_D01.mp3", "Sound\\HeroVoice\\Frieren\\Frieren_D02.mp3"},
        ["随机播放"] = true,
        ["语音冷却秒"] = 0.8,
        ["三D裁断距离"] = 4000
    }
}
--- 伊蕾娜 D 切换成功后的专用喊话，每个变式各两条随机候选。
____exports["伊蕾娜D变式喊话配置"] = {["迅行"] = {
    ["英雄名"] = "伊蕾娜",
    ["技能ID"] = "AID1",
    ["技能槽"] = "D",
    ["候选台词"] = {"迅速な魔法にしましょう。", "風のように、軽やかに。"},
    ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_D_Swift_01.mp3", "Sound\\HeroVoice\\Irena\\Irena_D_Swift_02.mp3"},
    ["随机播放"] = true,
    ["语音冷却秒"] = 0.8,
    ["三D裁断距离"] = 4000
}, ["镜界"] = {
    ["英雄名"] = "伊蕾娜",
    ["技能ID"] = "AID1",
    ["技能槽"] = "D",
    ["候选台词"] = {"守りの魔法にしましょう。", "備えは大切ですよ。"},
    ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_D_Mirror_01.mp3", "Sound\\HeroVoice\\Irena\\Irena_D_Mirror_02.mp3"},
    ["随机播放"] = true,
    ["语音冷却秒"] = 0.8,
    ["三D裁断距离"] = 4000
}, ["灰烬"] = {
    ["英雄名"] = "伊蕾娜",
    ["技能ID"] = "AID1",
    ["技能槽"] = "D",
    ["候选台词"] = {"灰の魔法にしましょうか。", "少し焦がしてみましょう。"},
    ["候选语音列表"] = {"Sound\\HeroVoice\\Irena\\Irena_D_Ash_01.mp3", "Sound\\HeroVoice\\Irena\\Irena_D_Ash_02.mp3"},
    ["随机播放"] = true,
    ["语音冷却秒"] = 0.8,
    ["三D裁断距离"] = 4000
}}
return ____exports
