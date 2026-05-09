--[[
ObjEditing notes:
1. This file is executed by ObjEditing.exe only.
2. Do not require runtime libraries here.
3. Use raw ids and minimal verified setters.
4. If deletion does not sync, run Clean Project and save again.
5. Chinese hover docs are in objediting/objediting_zh_docs.lua.
6. dofile 只能用相对文件名（同目录），不能用路径（arg 不可用）。
]]
  -- 这套 ObjEditing 的真实单位 API 需要去 `.def/def/` 查定义：
  -- 例如单位图标字段 `uico` 对应 `.def/def/UnitOrBuildingOrHeroDefinition.lua`
  -- 真实 setter 是 `setIconGameInterface(...)`。
dofile('abilities.lua')
dofile('units.lua')
