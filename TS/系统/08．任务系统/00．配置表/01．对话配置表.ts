// 对话NPC配置数据 - 自动生成
// 生成时间: 2026-04-09 20:23:53

export interface DialogNPCData {
  NPC?: string;
  requireid?: number;
  DialogCondition?: string;
  Text?: string;
}

export const DIALOG_NPC_CONFIGS: DialogNPCData[] = [
  {
    NPC: "沙漠战斗商人",
    requireid: 1005,
    Text: "1.NPC：哟？新面孔嘛，来这里做什么的？\n2.Player：初次到来，冒昧打扰，请问你在这座小镇是？\n3.NPC：这还看不出来？这么明显的一个卖武器的商人\n4.Player：哦？让我看看您所贩卖的商品\n5.Player：.......果然都是好东西\n6.NPC：哈哈，那当然，都是上好的东西..若你有兴趣，可以找我购买，欢迎你来我这儿走一走看一看！\n7.NPC：好的....",
  },
  {
    NPC: "人类猎人",
    requireid: 1001,
    Text: "1.NPC：要不要考虑购买个奶酪..\n2.NPC：在我们猎人中传闻已久，这片森林的|cff00ffff水源处|r有森林特有的|cff00ff00生命鹿|r出没\n3.NPC：而它只会对任何发有|cff00ff00生命气息味道|r的东西感兴趣\n4.NPC：就算失败了，拿来食用也是绝品\n5.NPC：因此我便尝试用这块奶酪在水源处尝试捕捉\n6.NPC：但尝试了近大半月都没发现它的一点踪迹\n7.NPC：...现在我决定将这个|cffffff00机会|r让给你们年轻人，怎么样？\n8.NPC：嘿嘿...年轻人|cffccffcc,出了这片森林可就没这个机会了|r，你可要想清楚",
  },
  {
    NPC: "沙漠神秘刺客",
    requireid: 1004,
    Text: "1.NPC：阁下对挖宝感兴趣吗？\n2.NPC：嘿嘿..我这里有几章藏宝图，上面记录了详细的宝箱位置\n3.NPC：这个宝藏我曾经去挖过，结果被沙漠中的生物袭击了，现在怕是没实力去了\n4.NPC：现在将宝物大亏本卖给你，怎么样？考虑下？",
  },
  {
    NPC: "精灵村信使",
    requireid: 1002,
    Text: "1.NPC：客人，往前走就是我们精灵村的晶灵之树了\n2.NPC：若想使用我们精灵村的传送点，则需要提前前往晶灵之树一次",
  },
  {
    NPC: "精灵村村民",
    requireid: 1003,
    Text: "1.NPC：我身后的树木叫晶灵之树，是利用我们精灵一族信仰的净灵圣树数以万计中的其中一根树枝生长出来的。\n2.NPC：真想去族内看看那传说中的圣树是什么样子呀...\n\n",
  },
];

export default DIALOG_NPC_CONFIGS;
