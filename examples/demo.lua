-- ============================================================================
-- demo.lua — CDMUI 示例：还原考试面板的四页结构
-- ============================================================================

local UI = getgenv().CDMUI or loadstring(game:HttpGet("https://mock.local/CDMUI.lua"))()

local win = UI.Create({
    Title = "控制面板",
    -- 不设 ToggleKey：避免和游戏按键冲突，只通过屏幕上的按钮开关
})

-- ── 基础 ───────────────────────────────────────────────────────────────
local base = win:Tab("基础")

base:Toggle({
    Key = "stamina",
    Name = "无限体力",
    Desc = "让体力永远保持满状态",
    Default = true,
})

base:Expand({
    Key = "esp",
    Name = "敌人透视",
    Desc = "给所有 AI 加高亮",
    Default = true,
    Children = {
        { Kind = "toggle", Key = "espName", Name = "显示名称", Default = true },
        { Kind = "toggle", Key = "espHP", Name = "显示血量", Default = true },
    },
})

base:Expand({
    Key = "headHitbox",
    Name = "头部 Hitbox 放大",
    Desc = "自定义头部碰撞体积大小",
    Children = {
        { Kind = "number", Key = "headSizeVal", Name = "头部大小", Min = 1, Max = 20, Default = 4 },
    },
})

base:Toggle({ Key = "autoInteract", Name = "及时交互", Desc = "与可互动的物体进行秒交互" })
base:Toggle({ Key = "forceReset", Name = "无条件重置", Desc = "随时可以重置角色" })

base:Expand({
    Key = "slide",
    Name = "滑铲距离修改",
    Desc = "调整滑铲距离倍率",
    Children = {
        { Kind = "number", Key = "slideDistanceMult", Name = "滑铲距离倍率", Min = 1, Max = 10, Default = 2 },
    },
})

base:Expand({
    Key = "slideSteer",
    Name = "滑铲变向",
    Desc = "滑铲时根据方向变向",
    Children = {
        { Kind = "cycle", Key = "slideSteerMode", Name = "变向模式", Options = { "视角控制", "移动控制" } },
    },
})

base:Toggle({ Key = "nvg", Name = "无限电量夜视仪", Desc = "夜视仪电量无限" })
base:Toggle({ Key = "elephantImmune", Name = "免疫象脚", Desc = "免疫象脚和致死区" })
base:Toggle({ Key = "muzzle", Name = "去除枪口遮挡", Desc = "贴墙时不会挡住枪口" })
base:Toggle({ Key = "recoil", Name = "无后坐力", Desc = "消除枪械后坐力" })
base:Toggle({ Key = "forceHeadshot", Name = "强制爆头", Desc = "命中四肢/身体判定为爆头" })
base:Toggle({ Key = "autoQTE", Name = "自动 QTE", Desc = "QTE 自动完美完成" })

-- ── 魔法子弹 ───────────────────────────────────────────────────────────
local magic = win:Tab("魔法子弹")

magic:Expand({
    Key = "magicBullet",
    Name = "启用魔法子弹",
    Desc = "自动锁定准星内最近的敌人",
    Children = {
        { Kind = "toggle", Key = "mbShowBox", Name = "显示 3D 头框" },
        { Kind = "toggle", Key = "mbRequireVisible", Name = "掩体检测", Default = true },
        { Kind = "toggle", Key = "pierceShield", Name = "穿透盾牌", Default = true },
        { Kind = "toggle", Key = "pierceHelmet", Name = "穿透 SIN 头盔", Default = true },
        { Kind = "toggle", Key = "pierceTeammate", Name = "穿透队友", Default = true },
        { Kind = "toggle", Key = "pierceCorpse", Name = "穿透尸体", Default = true },
    },
})

magic:Expand({
    Key = "mbTargetMode",
    Name = "锁定模式",
    Desc = "切换目标选择方式",
    Children = {
        { Kind = "cycle", Key = "mbTargetModeVal", Name = "模式",
          Options = { "锁定FOV内准星模式", "锁定FOV内最近距离模式", "360°模式" } },
        { Kind = "toggle", Key = "mbShowRadius", Name = "360°锁定半径显示" },
    },
})

magic:Toggle({ Key = "autoFire", Name = "自动开火", Desc = "锁定后自动开火" })

magic:Input({
    Key = "mbWorldDistMax",
    Name = "最大锁定距离",
    Desc = "锁定目标的最远距离（studs）",
    Default = "200",
    Quick = { 50, 200 },
})

-- ── 雷达 ───────────────────────────────────────────────────────────────
local radar = win:Tab("雷达")

radar:Toggle({ Key = "radar", Name = "雷达探敌", Desc = "小地图上显示所有敌人", Default = true })
radar:Toggle({ Key = "radarFast", Name = "高刷新率", Desc = "雷达刷新更频繁（耗性能）" })
radar:Toggle({ Key = "radarArrow", Name = "朝向箭头", Desc = "显示敌人的朝向", Default = true })
radar:Toggle({ Key = "radarBoost", Name = "信号增幅器", Desc = "去除无信号区域干扰" })

-- ── 其他 ───────────────────────────────────────────────────────────────
local other = win:Tab("其他")

other:Slider({
    Key = "volume",
    Name = "音量",
    Desc = "拖动调整",
    Min = 0, Max = 100, Step = 5, Default = 65,
})

other:Keybind({
    Key = "panicKey",
    Name = "紧急关闭键",
    Desc = "一键隐藏面板",
    Default = Enum.KeyCode.RightShift,
})

other:MultiSelect({
    Key = "notifyOn",
    Name = "通知类型",
    Desc = "可多选",
    Options = { "拾取", "击杀", "警告" },
    Default = { "拾取" },
})

other:Label({ Name = "占位符", Desc = "后续功能将陆续加入" })

win:Notify("控制面板已加载")
return win
