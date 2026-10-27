# CDMUI

Roblox / Luau 单文件控制面板 UI 库。零依赖，`loadstring` 直载。

- **控件齐全** — Toggle / Slider / Cycle / Input / Keybind / MultiSelect / Expand / Body2D / Dropdown / ColorPicker / TextBox / Progress / Section / Label / Divider / Buttons
- **统一视觉** — 全库共用一套色阶与尺寸规范，改一处全局生效
- **完整动效** — 面板进出场、Tab 收起展开、子项逐行撑开、勾选框缩放弹出、按钮按压回弹
- **PC / 移动端自适应** — 统一管理两套尺寸，移动端放大点击区域、Tab 平分整行、支持拖动面板

---

## 目录

- [快速开始](#快速开始)
- [完整示例](#完整示例)
- [API 参考](#api-参考)
  - [UI.Create](#uicreateopts)
  - [Window 方法](#window-方法)
  - [Tab 方法](#tab-方法)
- [控件详解](#控件详解)
- [使用场景](#使用场景)
- [主题与自定义](#主题与自定义)
- [常见问题](#常见问题)

---

## 快速开始

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()

local win = UI.Create({ Title = "演示面板" })
local tab = win:Tab("演示页")

tab:Toggle({
    Key = "demo_toggle",
    Name = "演示开关",
    Desc = "这是一段演示说明文本",
    Default = false,
    Callback = function(v) print("demo_toggle", v) end,
})
```

三行核心概念：

1. `UI.Create()` 创建窗口
2. `win:Tab()` 创建分页
3. `tab:Toggle()` / `tab:Slider()` / ... 往分页里加控件

---

## 完整示例

下面是一个覆盖所有控件的完整例子：

```lua
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()

-- ============ 创建窗口 ============
local win = UI.Create({
    Title = "演示面板",            -- 顶部大标题
    TopbarText = "演示面板",       -- 左上角按钮文字（不传则不创建按钮）
    ToggleKey = Enum.KeyCode.RightShift,   -- 可选：快捷键（建议不设，避免冲突）
})

-- ============ 第一页：基础控件 ============
local page1 = win:Tab("基础")

page1:Label({ Name = "分组说明", Desc = "下面是一些基础控件" })

page1:Toggle({
    Key = "demo_toggle",
    Name = "演示开关",
    Desc = "开关类功能的说明文字",
    Default = false,
    Callback = function(v)
        print("开关状态:", v)
    end,
})

page1:Slider({
    Key = "demo_slider",
    Name = "演示滑条",
    Desc = "拖动或点击调整数值",
    Min = 0, Max = 100, Step = 5, Default = 50,
    Callback = function(v) print("滑条数值:", v) end,
})

page1:Cycle({
    Key = "demo_cycle",
    Name = "演示选择",
    Desc = "左右切换选项",
    Options = { "选项甲", "选项乙", "选项丙" },
    DefaultIndex = 1,
    Callback = function(option, index)
        print("选中:", option, index)
    end,
})

page1:Input({
    Key = "demo_input",
    Name = "演示输入",
    Desc = "输入数字后回车确认",
    Default = "100",
    Quick = { 50, 200 },          -- 可选：右侧快捷值按钮
    Callback = function(v) print("输入值:", v) end,
})

page1:Keybind({
    Key = "demo_keybind",
    Name = "演示按键",
    Desc = "点击后按下任意键绑定",
    Default = Enum.KeyCode.F,
    Callback = function(key) print("绑定:", key.Name) end,
})

-- ============ 第二页：可展开分组 ============
local page2 = win:Tab("分组")

page2:Expand({
    Key = "group_a",
    Name = "分组甲",
    Desc = "展开后有子项",
    Default = false,
    Callback = function(v) print("分组甲开关:", v) end,
    Children = {
        { Kind = "toggle", Key = "sub_a1", Name = "子开关 A", Default = true },
        { Kind = "toggle", Key = "sub_a2", Name = "子开关 B", Default = false },
        { Kind = "number", Key = "sub_a3", Name = "子数值", Min = 1, Max = 20, Default = 4 },
        { Kind = "cycle",  Key = "sub_a4", Name = "子选择", Options = { "甲", "乙" } },
        { Kind = "slider", Key = "sub_a5", Name = "子滑条", Min = 0, Max = 1, Step = 0.05, Default = 0.5 },
    },
})

page2:Divider()

page2:Expand({
    Key = "group_b",
    Name = "分组乙",
    Desc = "另一组子项",
    Children = {
        { Kind = "toggle", Key = "sub_b1", Name = "子开关 C", Default = true },
    },
})

-- ============ 第三页：多选与按钮 ============
local page3 = win:Tab("其他")

page3:MultiSelect({
    Key = "demo_multi",
    Name = "演示多选",
    Desc = "可以同时选中多个",
    Options = { "选项一", "选项二", "选项三" },
    Default = { "选项一" },        -- 默认选中的项
    Callback = function(selected)
        -- selected 是一个 table：{ ["选项一"] = true, ... }
        local list = {}
        for k, v in pairs(selected) do
            if v then table.insert(list, k) end
        end
        print("已选:", table.concat(list, ", "))
    end,
})

page3:Divider()

page3:Buttons({
    Buttons = {
        { Text = "重置", Variant = "secondary", Callback = function() print("重置") end },
        { Text = "应用", Variant = "primary",   Callback = function() print("应用") end },
    },
})

-- ============ 通知 ============
win:Notify("面板已加载", 3)     -- 第二个参数是持续时间（秒），默认 2.4

-- 暴露到全局方便调试
getgenv().DemoWin = win
```

---

## API 参考

### `UI.Create(opts)`

创建并返回一个 `Window`。

| 参数 | 类型 | 默认值 | 说明 |
|---|---|---|---|
| `Title` | string | `"控制面板"` | 顶部大标题文字 |
| `TopbarText` | string | `"控制面板"` | 左上角顶栏按钮的文字；传 `false` 则不创建 |
| `GuiName` | string | `"ControlPanelUI"` | ScreenGui 名称，调试时方便查找 |
| `DisplayOrder` | number | `101` | 显示层级，数值越大越靠前 |
| `AutoOpen` | bool | `true` | 创建后是否自动显示 |
| `ToggleKey` | Enum.KeyCode | `nil` | 快捷键；**建议不设**，避免与游戏按键冲突 |

```lua
-- 最小用法
local win = UI.Create()

-- 完整用法
local win = UI.Create({
    Title = "我的面板",
    TopbarText = "打开面板",
    GuiName = "MyPanel",
    DisplayOrder = 200,
    AutoOpen = false,
})
```

### `Window` 方法

| 方法 | 参数 | 说明 |
|---|---|---|
| `win:Tab(name)` | string | 创建分页，返回 `Tab` 对象 |
| `win:SelectTab(index, instant)` | number, bool | 切换分页；`instant=true` 跳过动画 |
| `win:SetVisible(bool, instant)` | bool, bool | 显示 / 隐藏面板 |
| `win:Toggle()` | - | 切换显示状态 |
| `win:Notify(text, duration)` | string, number | 右侧弹入通知 |
| `win:Get(key)` | string | 读取控件状态 |
| `win:Set(key, value)` | string, any | 设置控件状态（不触发 Callback） |
| `win:Destroy()` | - | 销毁面板并断开所有连接 |

```lua
win:SelectTab(2)              -- 切到第二页
win:SetVisible(false)         -- 隐藏面板
win:Notify("操作完成", 3)     -- 显示 3 秒通知
local v = win:Get("demo_toggle")   -- 读状态
win:Set("demo_toggle", true)       -- 写状态（不同步 UI 的 Callback）
```

### `Tab` 方法

所有方法都返回一个控件对象，带有 `Set(value)` / `Get()` 方法。

| 方法 | 说明 |
|---|---|
| `tab:Toggle(cfg)` | 勾选框开关 |
| `tab:Slider(cfg)` | 滑动条 |
| `tab:Cycle(cfg)` | 左右切换选择 |
| `tab:Input(cfg)` | 数字输入框 |
| `tab:Keybind(cfg)` | 按键绑定 |
| `tab:MultiSelect(cfg)` | 多选 chips |
| `tab:Expand(cfg)` | 可展开分组 |
| `tab:Body2D(cfg)` | 标准 Roblox 小人，点选身体部位 |
| `tab:Dropdown(cfg)` | 下拉选择 |
| `tab:ColorPicker(cfg)` | 颜色选择（色相条） |
| `tab:TextBox(cfg)` | 文本输入（非数字） |
| `tab:Progress(cfg)` | 进度条（只读展示） |
| `tab:Section(cfg)` | 分组标题 |
| `tab:Label(cfg)` | 纯文字说明行 |
| `tab:Divider()` | 分隔线 |
| `tab:Buttons(cfg)` | 按钮行 |

---

## 控件详解

### 通用字段

所有控件都支持这三个字段：

| 字段 | 说明 |
|---|---|
| `Key` | 唯一标识，用于 `win:Get/Set` |
| `Name` | 显示标题 |
| `Desc` | 副标题说明（可选） |

### Toggle — 勾选框

```lua
tab:Toggle({
    Key = "feature_on",
    Name = "功能名称",
    Desc = "功能说明",
    Default = false,              -- 默认是否勾选
    Callback = function(v)        -- v 是 true / false
        print(v)
    end,
})
```

### Slider — 滑动条

```lua
tab:Slider({
    Key = "volume",
    Name = "音量",
    Desc = "拖动调整",
    Min = 0, Max = 100, Step = 5, Default = 50,
    Callback = function(v) end,   -- v 是数字
})
```

`Step` 控制精度：`1` 整数，`0.05` 两位小数。

### Cycle — 左右切换

```lua
tab:Cycle({
    Key = "mode",
    Name = "模式",
    Options = { "模式A", "模式B", "模式C" },
    DefaultIndex = 1,
    Callback = function(option, index)
        print(option)   -- 当前选项的文字
        print(index)    -- 当前选项的序号
    end,
})
```

### Input — 数字输入

```lua
tab:Input({
    Key = "amount",
    Name = "数量",
    Desc = "输入后回车",
    Default = "100",
    Quick = { 50, 200 },          -- 右侧快捷值按钮（可选）
    Callback = function(v) end,   -- v 是数字
})
```

### Keybind — 按键绑定

```lua
tab:Keybind({
    Key = "hotkey",
    Name = "热键",
    Desc = "点击后按任意键",
    Default = Enum.KeyCode.F,
    Callback = function(keyCode)
        print(keyCode.Name)   -- "F"
    end,
})
```

### MultiSelect — 多选

```lua
tab:MultiSelect({
    Key = "filters",
    Name = "过滤项",
    Options = { "甲", "乙", "丙" },
    Default = { "甲" },           -- 默认选中
    Callback = function(selected)
        -- selected 结构：{ ["甲"] = true, ["乙"] = false, ... }
        for name, on in pairs(selected) do
            print(name, on)
        end
    end,
})
```

### Expand — 可展开分组

这是最常用的控件，用来收纳子选项，保持主界面简洁。

```lua
tab:Expand({
    Key = "esp_group",
    Name = "透视设置",
    Desc = "点击右侧箭头展开",
    Default = false,              -- 主开关默认状态
    Callback = function(v) end,
    Children = {
        -- 子开关
        { Kind = "toggle", Key = "esp_name", Name = "显示名称", Default = true },

        -- 子数值输入
        { Kind = "number", Key = "esp_range", Name = "显示距离",
          Min = 50, Max = 500, Default = 200 },

        -- 子选择
        { Kind = "cycle", Key = "esp_mode", Name = "显示模式",
          Options = { "简单", "详细" } },

        -- 子滑动条
        { Kind = "slider", Key = "esp_alpha", Name = "透明度",
          Min = 0, Max = 1, Step = 0.05, Default = 0.8 },
    },
})
```

子项类型：

| `Kind` | 说明 | 额外字段 |
|---|---|---|
| `"toggle"` | 勾选框 | `Default` |
| `"number"` | 数字输入框 | `Min` / `Max` / `Default` |
| `"cycle"` | 左右切换 | `Options` |
| `"slider"` | 滑动条 | `Min` / `Max` / `Step` / `Default` |

### Label — 文字说明

```lua
tab:Label({
    Name = "标题",
    Desc = "说明文字",
})
```

### Divider — 分隔线

```lua
tab:Divider()
```

### Buttons — 按钮行

```lua
tab:Buttons({
    Buttons = {
        { Text = "取消", Variant = "secondary", Width = 80, Callback = function() end },
        { Text = "确定", Variant = "primary",   Width = 80, Callback = function() end },
    },
})
```

按钮变体：

| Variant | 外观 | 用途 |
|---|---|---|
| `"primary"` | 白底黑字 | 主要操作 |
| `"secondary"` | 深灰底带描边 | 常规操作（默认） |
| `"danger"` | 暗红底红字 | 危险操作 |
| `"ghost"` | 极淡底 | 次要操作 |

---

## 使用场景

### 场景 1：纯开关面板

最常见的情况 —— 一堆功能开关。

```lua
local win = UI.Create({ Title = "功能面板" })
local tab = win:Tab("功能")

local features = {}

local function addFeature(name, desc, key)
    tab:Toggle({
        Key = key,
        Name = name,
        Desc = desc,
        Default = false,
        Callback = function(v)
            features[key] = v
            print(name, v and "开启" or "关闭")
        end,
    })
end

addFeature("功能一", "第一个功能的说明", "feat1")
addFeature("功能二", "第二个功能的说明", "feat2")
addFeature("功能三", "第三个功能的说明", "feat3")
```

### 场景 2：带配置开关（开关 + 子配置）

开关本身需要一个数值配置时用 `Expand`。

```lua
tab:Expand({
    Key = "aimbot",
    Name = "自动瞄准",
    Desc = "锁定视野内目标",
    Default = false,
    Callback = function(v) setAimbotEnabled(v) end,
    Children = {
        { Kind = "slider", Key = "aim_fov", Name = "瞄准范围",
          Min = 10, Max = 180, Step = 5, Default = 90 },
        { Kind = "cycle", Key = "aim_part", Name = "瞄准部位",
          Options = { "头部", "身体", "最近" } },
        { Kind = "toggle", Key = "aim_visible", Name = "仅可见目标", Default = true },
    },
})
```

子项的 Callback 需要在创建后单独挂：

```lua
-- Expand 的 Children 不支持直接写 Callback，
-- 用 win.State + 定时读，或者在外部监听
local aimFov = win:Get("aim_fov")
```

> **提示**：如果需要子项实时回调，建议在 `win` 创建后手动接管：
> ```lua
> local origSet = win.Set
> win.Set = function(self, key, value)
>     origSet(self, key, value)
>     if key == "aim_fov" then setFov(value) end
> end
> ```

### 场景 3：多分页管理

功能多的时候按类别分页。

```lua
local win = UI.Create({ Title = "多功能面板" })

local combat = win:Tab("战斗")
local visual = win:Tab("视觉")
local misc   = win:Tab("杂项")

-- 战斗页
combat:Expand({ Key = "aim", Name = "瞄准设置", Children = { ... } })
combat:Toggle({ Key = "trigger", Name = "自动扳机", Default = false })

-- 视觉页
visual:Toggle({ Key = "esp", Name = "透视", Default = false })
visual:Toggle({ Key = "crosshair", Name = "准星", Default = true })

-- 杂项页
misc:Slider({ Key = "volume", Name = "音量", Min = 0, Max = 100, Default = 100 })
misc:Buttons({
    Buttons = {
        { Text = "全部关闭", Variant = "danger", Callback = function()
            for _, key in ipairs({ "aim", "trigger", "esp", "crosshair" }) do
                win:Set(key, false)
            end
        end },
    },
})
```

### 场景 4：配置持久化

```lua
-- 保存
local function saveConfig()
    local cfg = {}
    for key, _ in pairs(win.State) do
        if type(key) == "string" and not key:find("^__") then
            cfg[key] = win:Get(key)
        end
    end
    writefile("my_config.json", game:GetService("HttpService"):JSONEncode(cfg))
end

-- 加载
local function loadConfig()
    if not isfile("my_config.json") then return end
    local cfg = game:GetService("HttpService"):JSONDecode(readfile("my_config.json"))
    for key, value in pairs(cfg) do
        win:Set(key, value)
    end
end

-- 在 Buttons 里调用
tab:Buttons({
    Buttons = {
        { Text = "保存", Variant = "primary", Callback = saveConfig },
        { Text = "加载", Variant = "secondary", Callback = loadConfig },
    },
})
```

### 场景 5：动态更新控件状态

```lua
-- 代码里改变某个开关的状态（比如检测到条件满足时自动开启）
win:Set("my_toggle", true)

-- 对应的 Callback 不会被触发，
-- 如果需要触发回调，手动调用
_G._MyCallbacks["my_toggle"](true)
```

---

## 主题与自定义

### 修改颜色

```lua
local UI = loadstring(game:HttpGet("..."))()

-- 直接改主题表（在 UI.Create 之前）
local T = UI.Theme
T.accent = Color3.fromRGB(100, 200, 255)   -- 强调色（原白色）
T.row = Color3.fromRGB(30, 30, 38)         -- 行背景
T.text = Color3.fromRGB(255, 255, 255)     -- 主文字色
```

### 内置主题色字段

| 字段 | 默认值 | 用途 |
|---|---|---|
| `panel` | `15,15,18` | 面板背景 |
| `row` | `25,25,30` | 行背景 |
| `rowChild` | `21,21,26` | 子项行背景 |
| `text` | `240,240,245` | 主文字 |
| `textDim` | `130,130,140` | 次要文字 |
| `accent` | `255,255,255` | 强调色（勾选 / 滑条 / Tab） |
| `ctrl` | `38,38,45` | 控件底色 |
| `danger` | `226,96,96` | 危险色 |

### 动画接口

```lua
local Anim = UI.Anim

-- 基础补间
Anim.to(instance, { Property = value }, 0.2, Enum.EasingStyle.Quad)

-- 悬停效果
Anim.hover(frame, fromColor, toColor)

-- 按钮按压
Anim.press(button, 0.95)
```

---

## 常见问题

**Q: 面板和游戏按键冲突怎么办？**

不设 `ToggleKey`，用左上角按钮开关：
```lua
local win = UI.Create({
    Title = "面板",
    TopbarText = "设置",     -- 左上角按钮
    -- 不传 ToggleKey
})
```

**Q: 如何隐藏左上角按钮？**

```lua
local win = UI.Create({
    Title = "面板",
    TopbarText = false,      -- 不创建按钮
    AutoOpen = true,         -- 直接显示
})
```

**Q: 修改了控件的 Key 后状态丢失？**

`Key` 是状态的唯一标识，改了 Key 就等于新控件，旧状态不会迁移。建议发布后不要改 Key。

**Q: Callback 不触发？**

- 用 `win:Set()` 设置时**不会**触发 Callback（设计如此，避免循环）
- 只有用户点 UI 时才触发

**Q: 子项（Expand 里的 Children）怎么加 Callback？**

`Children` 数组目前不支持直接写 `Callback` 字段。需要回调时：

```lua
-- 方案：创建后手动接管 setter
local originalSet = _G._ExamSetters["sub_key"]
_G._ExamSetters["sub_key"] = function(v)
    if originalSet then originalSet(v) end
    -- 你的回调逻辑
end
```

**Q: 移动端适配需要额外做什么？**

不需要。库会自动检测：
```lua
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
```
移动端会自动放大点击区域、Tab 平分整行、支持拖动标题栏移动面板。

**Q: 面板挡住了游戏 UI？**

调整 `DisplayOrder`：
```lua
local win = UI.Create({ DisplayOrder = 50 })   -- 数值越小越靠后
```

---

## 许可

MIT
