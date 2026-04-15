#ifndef LibraryXIncluded
#define LibraryXIncluded

library  X initializer Init
//X_GDBC : 坐标间距离 x1 y1 x2 y2
//X_GAFC : 坐标间角度 x1 y1 x2 y2
//X_SetUnitMovable 设置单位是否可以移动
//X_GetAbleX 在检测可通行性之后 获取可通行的X坐标
//X_GetAbleY 在检测可通行性之后 获取可通行的Y坐标
//R2I2 转换实数为整数[四舍五入]
//X_IsTerrainWalkable x y  坐标可通行
//========================
globals
    public hashtable ht = InitHashtable()
    private constant real    MAX_RANGE     = 10.
    private constant integer DUMMY_ITEM_ID = 'wolg'
endglobals

globals
    private item       Item   = null
    private rect       Find   = null
    private item array Hid
    private integer    HidMax = 0
    public  real       X      = 0.
    public  real       Y      = 0.
endglobals

public function IsTerrainDeepWater takes real x, real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
endfunction
public function IsTerrainShallowWater takes real x, real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
endfunction
public function IsTerrainLand takes real x, real y returns boolean
    return IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
endfunction
public function IsTerrainPlatform takes real x, real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
endfunction

private function HideItem takes nothing returns nothing
    if IsItemVisible(GetEnumItem()) then
        set Hid[HidMax] = GetEnumItem()
        call SetItemVisible(Hid[HidMax], false)
        set HidMax = HidMax + 1
    endif
endfunction
public function IsTerrainWalkable takes real x, real y returns boolean
    #ifdef FLANDRE
        if(Item == null) then
            set Item = CreateItem(DUMMY_ITEM_ID, 0, 0)
        endif
    #endif
    //隐藏这个区域内的其他物品，防止物品间的碰撞导致bug
    call MoveRectTo(Find, x, y)
    call EnumItemsInRect(Find ,null, function HideItem)
    //物品法检测
    call SetItemPosition(Item, x, y) //Unhides the item
    set X = GetItemX(Item)
    set Y = GetItemY(Item)
    static if LIBRARY_X then
        set X_X = X
        set X_Y = Y
    endif
    call SetItemVisible(Item, false)//隐藏用来检测的物品 （怀特的另一条腿）
    //显示这个区域的物品
    loop
        exitwhen HidMax <= 0
        set HidMax = HidMax - 1
        call SetItemVisible(Hid[HidMax], true)
        set Hid[HidMax] = null
    endloop
    //返回是否可以通行
    return (X-x)*(X-x)+(Y-y)*(Y-y) <= MAX_RANGE*MAX_RANGE and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
endfunction


//设置单位可移动性
public function SetUnitMovable takes unit u,boolean b returns nothing
if b then
    call SetUnitPropWindow(u, GetUnitDefaultPropWindow(u))
else
    call SetUnitPropWindow(u, 0)
endif
endfunction
//坐标间距离 x1 y1 x2 y2
public function GDBC takes real x1,real y1,real x2,real y2 returns real
    return SquareRoot((y1-y2)*(y1-y2)+(x1-x2)*(x1-x2))
endfunction
//坐标间角度 x1 y1 x2 y2
public function GAFC takes real x1,real y1,real x2,real y2 returns real
return Rad2Deg(Atan2(y2-y1,x2-x1))
endfunction
//可通行X坐标
public function GetAbleX takes nothing returns real
return X
endfunction
//可通行Y坐标
public function GetAbleY takes nothing returns real
return Y
endfunction
//转换实数为整数(四舍五入)
public function X_R2I2 takes real r returns integer
    return R2I(r+0.5)
endfunction
//转换实数为整数(四舍五入)
function R2I2 takes real r returns integer
    return R2I(r+0.5)
endfunction


//碰撞检测初始化
private function Init takes nothing returns nothing
    set Find = Rect(0., 0., 128., 128.)
    set Item = CreateItem(DUMMY_ITEM_ID, 0, 0)
    call SetItemVisible(Item, false)
endfunction



endlibrary

#endif


