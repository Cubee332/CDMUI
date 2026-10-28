--[[
    ╔══════════════════════════════════════════════════════════════╗
    ║  CDMUI 1.6.0                                                 ║
    ║  Roblox 控制面板 UI 库 · 单文件 · 无依赖 · PC/手机自适应      ║
    ╚══════════════════════════════════════════════════════════════╝

    ┌──────────────────────────────────────────────────────────────┐
    │  快速开始                                                     │
    └──────────────────────────────────────────────────────────────┘

        local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Cubee332/CDMUI/main/CDMUI.lua"))()

        local win = UI.Create({ Title = "我的面板" })
        local tab = win:Tab("基础")

        tab:Toggle({
            Key = "enabled",
            Name = "启用功能",
            Desc = "点一下试试",
            Default = false,
            Callback = function(v) print("开关 =", v) end,
        })

    ┌──────────────────────────────────────────────────────────────┐
    │  UI.Create 参数                                               │
    └──────────────────────────────────────────────────────────────┘

        Title            面板标题（默认 "控制面板"）
        TopbarText       顶栏按钮文字
        AutoOpen         创建后是否自动显示（默认 true）
        AutoUnlockMouse  面板打开时是否解锁鼠标（默认 true）
        TopbarButton     是否生成左上角顶栏按钮（默认 true）

    ┌──────────────────────────────────────────────────────────────┐
    │  Window 方法                                                  │
    └──────────────────────────────────────────────────────────────┘

        win:Tab(name)               新建 Tab，返回 Tab 对象
        win:SelectTab(i, instant)   切到第 i 个 Tab（instant=true 不播动画）
        win:SetVisible(bool)        显示 / 隐藏面板
        win:Toggle()                切换显示状态
        win:Notify(text, sec)       弹一条提示
        win:Destroy()               销毁面板

        ── 状态读写 ──
        win:Get(key)                读当前值
        win:Set(key, value)         设置值 + 重绘 + 触发 OnToggle
        win:SetSilent(key, value)   设置值 + 重绘，不触发回调
        win:SetMany({k1=v1, k2=v2}) 批量设置
        win:RepaintAll()            把 State 全量同步到控件

    ┌──────────────────────────────────────────────────────────────┐
    │  控件清单（全部挂在 tab 上）                                   │
    └──────────────────────────────────────────────────────────────┘

    ── tab:Toggle ──────────────────────────────────────────────
        Key, Name, Desc, Default, Callback(v)
        最简单的开关，右侧勾选框。

    ── tab:Section ─────────────────────────────────────────────
        Name
        分组标题，纯视觉分隔。

    ── tab:Label ───────────────────────────────────────────────
        Name, Desc
        只显示文字，不可交互。

    ── tab:Divider ─────────────────────────────────────────────
        水平分隔线，无参数。

    ── tab:Input ───────────────────────────────────────────────
        Key, Name, Desc, Default, Min, Max, Callback(v)
        数字输入框，失焦提交。有 Min/Max 会自动夹取值。

    ── tab:Slider ──────────────────────────────────────────────
        Key, Name, Desc, Min, Max, Default, Callback(v)
        拖动条。

    ── tab:Cycle ───────────────────────────────────────────────
        Key, Name, Desc, Options={"A","B"}, DefaultIndex, Callback(idx, text)
        ⚠ 回调第一个参数是【索引数字】，第二个才是文字。
        ⚠ 默认值必须写 DefaultIndex，写 Default 无效。

    ── tab:Expand ──────────────────────────────────────────────
        Key, Name, Desc, Default, Callback(v)
        Children = { ... }     子项列表
        Cycle = { Key, Options, DefaultIndex, Callback(idx) }   可选右侧切换

        子项 Kind 支持四种（必须显式写）：
            { Kind = "toggle", Key="k", Name="开关", Default=false, Callback=fn }
            { Kind = "number", Key="k", Name="数值", Min=1, Max=10, Default=5, Callback=fn }
            { Kind = "cycle",  Key="k", Name="选项", Options={"A","B"}, DefaultIndex=1, Callback=fn }
            { Kind = "slider", Key="k", Name="滑条", Min=0, Max=100, Default=50, Callback=fn }

    ── tab:Buttons ─────────────────────────────────────────────
        Buttons = { { Name="按钮1", Callback=fn }, ... }
        一行并排多个按钮。

    ── tab:ClickableRow ────────────────────────────────────────
        Name, Desc, Arrow, Callback
        整行可点击，带右箭头。

    ── tab:RowButton ───────────────────────────────────────────
        Name, Callback
        单个按钮行。

    ── tab:Dropdown ────────────────────────────────────────────
        Key, Name, Desc, Options, Default, Callback(v)

    ── tab:ColorPicker ─────────────────────────────────────────
        Key, Name, Desc, Default, Callback(color)

    ── tab:TextBox ─────────────────────────────────────────────
        Key, Name, Desc, Default, Callback(text)

    ── tab:Progress ────────────────────────────────────────────
        Name, Value, Max
        进度条，用 ctrl.Set(v) 更新。

    ── tab:MultiSelect ─────────────────────────────────────────
        Key, Name, Desc, Options, Default, Callback(tbl)

    ── tab:Keybind ─────────────────────────────────────────────
        Key, Name, Desc, Default, Callback(keyCode)

    ── tab:Body2D ──────────────────────────────────────────────
        Key, Name, Desc, Default, Callback(idx), Parts
        Parts = { { Key=1, Name="头部" }, ... }
        可折叠的人体部位选择器，默认收起，点标题行展开。
        内部比例按 R6：头 60x60、躯干 90x90、四肢 45x90。

    ┌──────────────────────────────────────────────────────────────┐
    │  控件对象（tab.Rows[key]）                                     │
    └──────────────────────────────────────────────────────────────┘

        每个控件都登记到 tab.Rows[key]，可事后操作：

            tab.Rows.k1.Set(v)        设置值（会触发 Callback）
            tab.Rows.k1.SetSilent(v)  只更新显示，不触发 Callback
            tab.Rows.k1.Get()         读取当前值

        用途：做功能互斥时，A 打开后把 B 的勾选框刷掉。

    ┌──────────────────────────────────────────────────────────────┐
    │  功能互斥示例                                                  │
    └──────────────────────────────────────────────────────────────┘

        local aCtrl = tab:Toggle({ Key = "a", Name = "功能A", Callback = function(v)
            if v and win.State.b then
                tab.Rows.b.SetSilent(false)   -- 界面关掉
                win.State.b = false            -- 逻辑也关掉
            end
        end })

    ┌──────────────────────────────────────────────────────────────┐
    │  主题 / 尺寸自定义                                             │
    └──────────────────────────────────────────────────────────────┘

        在 UI.Create 之前改：

            UI.Theme.panel   = Color3.fromRGB(15, 15, 18)
            UI.Theme.accent  = Color3.fromRGB(0, 170, 255)
            UI.Layout.panelH = 600
            UI.Size.radius   = 6

    ┌──────────────────────────────────────────────────────────────┐
    │  动画 / 错误处理（高级）                                        │
    └──────────────────────────────────────────────────────────────┘

        UI.Anim.to(inst, props, dur, style, dir, delay)
            补间动画。同一实例同一属性的旧动画会自动取消。

        UI.Anim.cancel(inst)      立即取消该实例所有动画
        UI.Anim.snap(inst, props) 立即设到终态（不走动画）

        UI.safeCall(fn, ...)      安全调用（捕获错误，不中断 UI）
        UI.GetErrorStats()        读取错误统计
        UI.ClearErrors()          清空统计

    ┌──────────────────────────────────────────────────────────────┐
    │  重载 / 清理                                                   │
    └──────────────────────────────────────────────────────────────┘

        重复 loadstring 时会自动：
            ① 播退出动画（面板 + 顶栏按钮淡出）
            ② 等动画播完再建新面板
            ③ 断开所有连接、还原鼠标 hook

        手动清理：
            if _G._CDMUILastCleanup then _G._CDMUILastCleanup() end

    ╔══════════════════════════════════════════════════════════════╗
    ║  接入新脚本必读（踩过的坑）                                     ║
    ╚══════════════════════════════════════════════════════════════╝

    ① Cycle / Expand.Cycle 的回调，第一个参数是【索引数字】。
       写成 function(text) 会拿到数字，判断全失效。

    ② Expand 的 Children 必须写 Kind 字段，支持四种：
           toggle / cycle / number / slider
       漏写或写错 Kind，子项会被静默忽略（不报错、不显示）。

    ③ Cycle 子项的默认值必须写 DefaultIndex：
           { Kind="cycle", ..., Options={"A","B"}, DefaultIndex=2 }
       只写 Default 不会生效，UI 永远显示第 1 项。

    ④ Body2D 默认收起，点标题行或箭头展开。
       Callback 收到的是选中的 Key（数字）。

    ⑤ 所有可点击元素的音效由 bindTap 统一播放。
       自制按钮请用 bindTap(btn, fn)，不要直接连 MouseButton1Click。

    ⑥ 外部同步界面用 SetSilent()，不会触发 Callback，避免死循环。
       需要业务逻辑也响应时用 Set()。

    ⑦ 反复重载是安全的，cleanup 会完整还原所有状态。

    ⑧ 鼠标 hook 是全局单例 + 引用计数，最后一个窗口销毁时才真正卸载。

    ⑨ 不要覆盖 _G._CDMUILastCleanup / _G._CDMUILiveWindows，
       那是库的内部状态；需要清理时调 win:Destroy()。

    ⑩ 控件 Key 在同一 Tab 内必须唯一，重复会打警告并覆盖。

    ┌──────────────────────────────────────────────────────────────┐
    │  手机端说明                                                    │
    └──────────────────────────────────────────────────────────────┘

        自动检测（TouchEnabled 且非 KeyboardEnabled），相关尺寸在
        LAYOUT 里已放大：行高 88、Tab 高 62、字号 +2、滚动条 5px。
        退出动画 0.28s（PC 0.24s）。

--]]
-- CDMUI v1.6.2  修复点击音效双响（ClickableRow 双通道触发 + 5 处重复 playClick）

local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")

local LocalPlayer = Players.LocalPlayer

local UI = {}
UI.Version = "1.6.2"

-- 播放退出动画（面板 + 顶栏按钮），不销毁任何东西
-- 返回一个函数：调用它会等动画播完（yield）
function UI.PlayExitAnim(duration)
    -- 手机端动画稍微长一点，触屏看起来更顺
    if not duration then
        local uis = game:GetService("UserInputService")
        local mobile = uis.TouchEnabled and not uis.KeyboardEnabled
        duration = mobile and 0.28 or 0.24
    end
    local wins = _G._CDMUILiveWindows or {}
    for _, w in ipairs(wins) do
        if type(w) == "table" then
            pcall(function()
                local panel = w.Panel
                local sc = w.Scale
                local gui = w.Gui

                if panel and panel.Parent then
                    local basePos = panel.Position
                    TweenService:Create(panel, TweenInfo.new(duration * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        BackgroundTransparency = 1,
                    }):Play()
                    TweenService:Create(panel, TweenInfo.new(duration * 0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                        Position = UDim2.new(basePos.X.Scale, basePos.X.Offset,
                                              basePos.Y.Scale, basePos.Y.Offset - 20),
                    }):Play()
                    if sc then
                        TweenService:Create(sc, TweenInfo.new(duration * 0.9, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                            Scale = 0.85,
                        }):Play()
                    end
                    -- 所有元素一起淡出（Frame 的底色、描边、文字、图片全都要）
                    local fadeT = TweenInfo.new(duration * 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                    for _, d in ipairs(panel:GetDescendants()) do
                        pcall(function()
                            if d:IsA("Frame") or d:IsA("ScrollingFrame") then
                                TweenService:Create(d, fadeT, { BackgroundTransparency = 1 }):Play()
                                -- ScrollingFrame 的滚动条是内置属性，要单独淡化
                                if d:IsA("ScrollingFrame") then
                                    pcall(function()
                                        d.ScrollBarImageTransparency = 1   -- 立即隐藏滚动条
                                    end)
                                end
                            elseif d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                                TweenService:Create(d, fadeT, {
                                    TextTransparency = 1,
                                    BackgroundTransparency = 1,
                                }):Play()
                            elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
                                TweenService:Create(d, fadeT, {
                                    ImageTransparency = 1,
                                    BackgroundTransparency = 1,
                                }):Play()
                            elseif d:IsA("UIStroke") then
                                TweenService:Create(d, fadeT, { Transparency = 1 }):Play()
                            end
                        end)
                    end
                end

                -- 引导提示也要淡出
                local guide = w._guideGui
                if guide and guide.Parent then
                    pcall(function()
                        local gFade = TweenInfo.new(duration * 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                        for _, d in ipairs(guide:GetDescendants()) do
                            pcall(function()
                                if d:IsA("Frame") or d:IsA("ScrollingFrame") then
                                    TweenService:Create(d, gFade, { BackgroundTransparency = 1 }):Play()
                                elseif d:IsA("TextLabel") or d:IsA("TextButton") then
                                    TweenService:Create(d, gFade, {
                                        TextTransparency = 1,
                                        BackgroundTransparency = 1,
                                    }):Play()
                                elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
                                    TweenService:Create(d, gFade, {
                                        ImageTransparency = 1,
                                        BackgroundTransparency = 1,
                                    }):Play()
                                elseif d:IsA("UIStroke") then
                                    TweenService:Create(d, gFade, { Transparency = 1 }):Play()
                                end
                            end)
                        end
                    end)
                end

                -- 顶栏按钮一起淡出（缩小 + 所有子元素淡化）
                -- 注意：这只是视觉淡出，真正销毁由 cleanup 的 task.delay 负责；
                -- 如果那个销毁被跳过，下次创建时必须能恢复，所以这里记录原始值
                local tb = w.TopbarBtn
                if tb and tb.Parent then
                    -- 先取消该按钮上所有进行中的动画
                    pcall(function() UI.Anim.cancel(tb) end)
                    if w._topbarOriginalTrans == nil then
                        local inner0 = tb:FindFirstChild("IconButton")
                        w._topbarOriginalTrans = inner0 and inner0.BackgroundTransparency or GAME_BTN_TRANS
                    end
                    pcall(function()
                        local inner = tb:FindFirstChild("IconButton")
                        if inner then
                            TweenService:Create(inner, TweenInfo.new(duration * 0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                                BackgroundTransparency = 1,
                            }):Play()
                        end
                        local spot = tb:FindFirstChild("IconSpot", true)
                        if spot then
                            TweenService:Create(spot, TweenInfo.new(duration * 0.75), {
                                BackgroundTransparency = 1,
                            }):Play()
                        end
                        for _, d in ipairs(tb:GetDescendants()) do
                            if d:IsA("TextLabel") or d:IsA("ImageLabel") then
                                pcall(function()
                                    TweenService:Create(d, TweenInfo.new(duration * 0.7), {
                                        TextTransparency = 1,
                                        ImageTransparency = 1,
                                    }):Play()
                                end)
                            end
                        end
                        -- 整体缩小消失（用 Quad 而不是 Back，避免结尾回弹过冲）
                        TweenService:Create(tb, TweenInfo.new(duration * 0.85, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                            Size = UDim2.new(0, 0, 0, 44),
                        }):Play()

                        -- 兜底：动画结束后强制归零，杜绝残留
                        task.delay(duration * 0.85 + 0.04, function()
                            if tb and tb.Parent then
                                pcall(function()
                                    tb.Size = UDim2.new(0, 0, 0, 44)
                                    local inner2 = tb:FindFirstChild("IconButton")
                                    if inner2 then inner2.BackgroundTransparency = 1 end
                                    for _, d in ipairs(tb:GetDescendants()) do
                                        if d:IsA("GuiObject") then
                                            pcall(function() d.BackgroundTransparency = 1 end)
                                        end
                                        if d:IsA("TextLabel") or d:IsA("TextButton") then
                                            pcall(function() d.TextTransparency = 1 end)
                                        end
                                        if d:IsA("ImageLabel") or d:IsA("ImageButton") then
                                            pcall(function() d.ImageTransparency = 1 end)
                                        end
                                        if d:IsA("UIStroke") then
                                            pcall(function() d.Transparency = 1 end)
                                        end
                                    end
                                end)
                            end
                        end)
                    end)
                end
            end)
        end
    end

    -- 动画播放到 80% 时把面板和引导整个隐藏，彻底杜绝残影
    task.delay(duration * 0.8, function()
        for _, w in ipairs(wins) do
            pcall(function()
                if w.Panel and w.Panel.Parent then w.Panel.Visible = false end
                if w._guideGui and w._guideGui.Parent then w._guideGui.Enabled = false end
            end)
        end
    end)

    -- 返回等待函数，调用方 await 它就能准确知道什么时候销毁
    return function()
        local t0 = os.clock()
        while os.clock() - t0 < duration + 0.02 do
            RunService.RenderStepped:Wait()
        end
    end
end

-- ============================================================
-- 重新运行时的自清理
-- ============================================================
-- 每次加载时，如果上次的实例还在，先把它完整销毁（断开连接、移除 UI），
-- 避免重复运行导致面板叠加、功能重复触发。
-- 运行代际：每次加载自增，异步任务靠它判断自己是否已被新的运行取代
_G._CDMUIRunGen = (_G._CDMUIRunGen or 0) + 1
local RUN_GEN = _G._CDMUIRunGen

if type(_G._CDMUILastCleanup) == "function" then
    -- 先让旧面板播退出动画（这个调用会启动动画）
    pcall(_G._CDMUILastCleanup)
    -- 等动画播完再往下建新面板，避免两个画面叠在一起
    task.wait(0.28)
end
_G._CDMUILastCleanup = nil

-- 实例登记表：Window:Destroy 时会把清理函数塞进来
_G._CDMUILiveWindows = {}

-- 对外暴露：判断当前加载是否已被取代
UI.IsStale = function()
    return _G._CDMUIRunGen ~= RUN_GEN
end

-- 主题色
local T = {
    -- 面板
    panel       = Color3.fromRGB(15, 15, 18),
    panelStroke = Color3.fromRGB(60, 60, 70),

    -- 行（主行 / 子行同一套色阶，靠明度区分层级）
    row         = Color3.fromRGB(25, 25, 30),
    rowHover    = Color3.fromRGB(34, 34, 41),
    rowChild    = Color3.fromRGB(21, 21, 26),
    childHover  = Color3.fromRGB(30, 30, 36),

    -- 文字
    text        = Color3.fromRGB(240, 240, 245),
    textDim     = Color3.fromRGB(130, 130, 140),
    textChild   = Color3.fromRGB(220, 220, 225),

    -- Tab
    tabIdle     = Color3.fromRGB(30, 30, 35),
    tabActive   = Color3.fromRGB(255, 255, 255),
    tabText     = Color3.fromRGB(220, 220, 220),
    tabTextOn   = Color3.fromRGB(15, 15, 18),

    -- 控件底色
    ctrl        = Color3.fromRGB(38, 38, 45),
    ctrlHover   = Color3.fromRGB(50, 50, 58),
    ctrlStroke  = Color3.fromRGB(70, 70, 82),
    ctrlText    = Color3.fromRGB(215, 215, 225),

    -- 强调
    accent      = Color3.fromRGB(255, 255, 255),
    accentBar   = Color3.fromRGB(200, 205, 215),   -- 子行左侧竖条（浅灰，跟强调色同系但不刺眼）
    hint        = Color3.fromRGB(150, 150, 160),
    danger      = Color3.fromRGB(226, 96, 96),
}

-- 旧字段名兼容
T.box        = T.ctrl
T.boxStroke  = T.ctrlStroke
T.arrowBg    = T.ctrl
T.arrowHover = T.ctrlHover
T.arrowText  = T.ctrlText
T.cycleBg    = T.ctrl
T.cycleHover = T.ctrlHover

-- 尺寸
local SIZE = {
    radius     = 6,    -- 控件圆角
    radiusRow  = 4,    -- 行圆角
    ctrlH      = 28,   -- 控件标准高
    arrow      = 34,   -- 展开箭头
    checkbox   = 28,   -- 主行勾选框
    checkboxSm = 22,   -- 子行勾选框
}
UI.Theme = T
UI.Layout = LAYOUT
UI.Size = SIZE

local FONT        = Enum.Font.Gotham
local FONT_BOLD   = Enum.Font.GothamBold
local FONT_BLACK  = Enum.Font.GothamBlack

-- 平台判定
-- 有触摸且没键盘算移动端
local IS_TOUCH = UserInputService.TouchEnabled
local IS_MOBILE = IS_TOUCH and not UserInputService.KeyboardEnabled

-- 移动端：面板更宽更矮、行更高（手指点得准）、Tab 平分整行、字号加大
local LAYOUT = {
    panelW      = IS_MOBILE and 540 or 540,
    panelH      = IS_MOBILE and 620 or 600,
    rowH        = IS_MOBILE and 88 or 76,
    titleSize   = IS_MOBILE and 36 or 32,
    tabHeight   = IS_MOBILE and 62 or 54,
    tabWidth    = IS_MOBILE and 0 or 88,      -- 0 = 平分整行
    tabTextSize = IS_MOBILE and 21 or 19,
    rowTitle    = IS_MOBILE and 22 or 20,
    rowDesc     = IS_MOBILE and 19 or 17,
    boxSize     = IS_MOBILE and 32 or 28,
    inputW      = IS_MOBILE and 84 or 70,
    inputH      = IS_MOBILE and 36 or 30,
    btnH        = IS_MOBILE and 36 or 30,
    btnText     = IS_MOBILE and 15 or 13,
    hintSize    = IS_MOBILE and 14 or 13,
    listTop     = IS_MOBILE and 146 or 130,
    padX        = IS_MOBILE and 16 or 20,
    padGap      = IS_MOBILE and 8 or 6,
    childH      = IS_MOBILE and 48 or 42,

    -- 控件尺寸
    sliderW     = IS_MOBILE and 170 or 150,   -- 滑动条轨道宽
    sliderH     = IS_MOBILE and 8 or 6,       -- 轨道高
    knobSize    = IS_MOBILE and 18 or 14,     -- 拖柄直径
    keybindW    = IS_MOBILE and 130 or 110,   -- 键位按钮宽
    keybindH    = IS_MOBILE and 34 or 28,     -- 键位按钮高
    cycleW      = IS_MOBILE and 195 or 172,   -- 循环选择宽（字变大了跟着加宽）
    cycleH      = IS_MOBILE and 36 or 32,     -- 循环选择高
    chipW       = IS_MOBILE and 76 or 64,     -- 多选 chip 宽
    chipH       = IS_MOBILE and 30 or 24,     -- 多选 chip 高
    ctrlText    = IS_MOBILE and 16 or 15,     -- 控件字号（PC 上原来 12 太小）
    arrowSize   = IS_MOBILE and 38 or 34,     -- 展开箭头
    rowDescY    = IS_MOBILE and 42 or 38,     -- 行描述文字 Y 偏移
    tabY        = IS_MOBILE and 84 or 74,     -- Tab 栏 Y 位置
    tabItemW    = IS_MOBILE and 100 or 88,    -- 单个 Tab 宽
    cycleArrowW = IS_MOBILE and 30 or 24,     -- 循环按钮两侧箭头宽
    cycleArrowText = IS_MOBILE and 17 or 15,  -- 循环按钮箭头字号
    arrowText   = IS_MOBILE and 16 or 14,     -- 展开箭头字号
    subBoxSize  = IS_MOBILE and 26 or 22,     -- 子行勾选框尺寸

    -- 自适应缩放边距（移动端留更多给刘海/手势区）
    scaleMarginX = IS_MOBILE and 0.94 or 0.92,
    scaleMarginY = IS_MOBILE and 0.86 or 0.85,
    scaleMin     = IS_MOBILE and 0.55 or 0.45,
    scaleMax     = IS_MOBILE and 1.10 or 1.15,
}

local PANEL_W, PANEL_H = LAYOUT.panelW, LAYOUT.panelH
local ROW_H = LAYOUT.rowH

local CLICK_SFX = "rbxassetid://8617766509"

-- 工具函数
local function mk(class, props, parent)
    local inst = Instance.new(class)
    if props then
        for k, v in pairs(props) do inst[k] = v end
    end
    if parent then inst.Parent = parent end
    return inst
end

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function tween(inst, time, props, style, dir, delay)
    local info = TweenInfo.new(time or 0.16,
        style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out, 0, false, delay or 0)
    local t = TweenService:Create(inst, info, props)
    t:Play()
    return t
end

local function guiParent()
    local ok, hui = pcall(function() return gethui and gethui() end)
    if ok and hui then return hui end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then return core end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function playClick()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = CLICK_SFX
        s.Volume = 0.5
        s:SetAttribute("__CP_SFX", true)
        s.Parent = SoundService
        s:Play()
        Debris:AddItem(s, 2)
    end)
end

-- ============================================================
-- 错误隔离
-- 任何用户回调抛错都不能中断 UI，更不能让整个面板卡死
-- ============================================================
local errorCount = 0
local lastErrorMsg = nil

-- 安全调用：返回 ok, err
function UI.safeCall(fn, ...)
    if type(fn) ~= "function" then return false, "not a function" end
    local ok, err = pcall(fn, ...)
    if not ok then
        errorCount = errorCount + 1
        lastErrorMsg = tostring(err)
        -- 只在控制台提示一次，避免刷屏
        if errorCount <= 3 then
            warn("[CDMUI] Callback error: " .. lastErrorMsg)
        end
    end
    return ok, err
end

-- 读取错误统计（调试用）
function UI.GetErrorStats()
    return { count = errorCount, last = lastErrorMsg }
end

-- 清空错误统计
function UI.ClearErrors()
    errorCount = 0
    lastErrorMsg = nil
end

-- tap 判定：位移 < 12 才算点击（避免拖滚动条时误触）
-- 用 pcall 包住位置运算，无头运行时里 InputObject.Position 可能不是 Vector2
-- 统一的点击绑定
--   · 音效只在这里播一次（控件内部不要再调 playClick）
--   · 位移超过阈值视为拖动，不触发
--   · 必须在本控件上按下并在本控件上抬起才算点击
--   · 回调走 safeCall，单个出错不影响其它控件
local function bindTap(btn, fn)
    local startPos = nil
    local started = false

    local function posOf(input)
        local ok, p = pcall(function() return input.Position end)
        if ok and typeof(p) == "Vector2" then return p end
        return nil
    end

    btn.InputBegan:Connect(function(input)
        local ut = input.UserInputType
        if ut == Enum.UserInputType.Touch or ut == Enum.UserInputType.MouseButton1 then
            startPos = posOf(input)
            started = true
        end
    end)

    btn.InputEnded:Connect(function(input)
        local ut = input.UserInputType
        if ut ~= Enum.UserInputType.Touch and ut ~= Enum.UserInputType.MouseButton1 then
            return
        end

        -- 没有在本次控件上按下过，忽略（防止滑动经过时误触）
        if not started then return end
        started = false

        local endPos = posOf(input)
        local moved = 0
        if startPos and endPos then
            local ok, mag = pcall(function() return (endPos - startPos).Magnitude end)
            if ok and type(mag) == "number" then moved = mag end
        end
        startPos = nil

        if moved < 12 then
            playClick()
            UI.safeCall(fn)
        end
    end)

end

local function adaptiveScale()
    local cam = workspace.CurrentCamera
    local vs = cam and cam.ViewportSize or Vector2.new(800, 600)
    local s = math.min((vs.X * LAYOUT.scaleMarginX) / PANEL_W,
                       (vs.Y * LAYOUT.scaleMarginY) / PANEL_H)
    return math.clamp(s, LAYOUT.scaleMin, LAYOUT.scaleMax)
end

-- ============================================================
-- 动画管理器
-- 核心保证：同一实例同一属性上的新旧动画不会打架
--   （历史上「折叠收不起来」「尺寸抖动」都是并发动画互相覆盖导致的）
-- ============================================================
local Anim = {}

-- inst -> { [propName] = Tween }
local activeTweens = setmetatable({}, { __mode = "k" })

local function cancelConflicts(inst, props)
    local per = activeTweens[inst]
    if not per then return end
    for prop in pairs(props) do
        local old = per[prop]
        if old then
            pcall(function() old:Cancel() end)
            per[prop] = nil
        end
    end
end

-- 基础补间：自动取消冲突动画
function Anim.to(inst, props, dur, style, dir, delay)
    if not inst or not inst.Parent then return nil end

    cancelConflicts(inst, props)

    local info = TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out, 0, false, delay or 0)
    local ok, t = pcall(function() return TweenService:Create(inst, info, props) end)
    if not ok or not t then return nil end

    local per = activeTweens[inst]
    if not per then per = {}; activeTweens[inst] = per end
    for prop in pairs(props) do per[prop] = t end

    -- 播完清掉登记
    t.Completed:Connect(function()
        local p2 = activeTweens[inst]
        if not p2 then return end
        for prop, cur in pairs(p2) do
            if cur == t then p2[prop] = nil end
        end
    end)

    pcall(function() t:Play() end)
    return t
end

-- 立即取消某实例上的动画（可选择只取消某些属性）
function Anim.cancel(inst, propList)
    if not inst then return end
    local per = activeTweens[inst]
    if not per then return end
    if propList then
        for _, prop in ipairs(propList) do
            local t = per[prop]
            if t then pcall(function() t:Cancel() end); per[prop] = nil end
        end
    else
        for prop, t in pairs(per) do
            pcall(function() t:Cancel() end)
            per[prop] = nil
        end
    end
end

-- 立即把实例设到终态（不走动画），用于 destroy 或强制归位
function Anim.snap(inst, props)
    if not inst or not inst.Parent then return end
    cancelConflicts(inst, props)
    for k, v in pairs(props) do
        pcall(function() inst[k] = v end)
    end
end

-- 悬停反馈（颜色过渡，不改变透明度造成闪烁）
function Anim.hover(frame, fromColor, toColor, speed)
    if not frame then return end
    local base = fromColor or frame.BackgroundColor3
    local target = toColor or base
    frame.MouseEnter:Connect(function()
        Anim.to(frame, { BackgroundColor3 = target }, speed or 0.12)
    end)
    frame.MouseLeave:Connect(function()
        Anim.to(frame, { BackgroundColor3 = base }, speed or 0.12)
    end)
end

-- 按压回弹（缩放，不影响布局）
function Anim.press(btn, scaleDown)
    if not btn then return end
    local baseSize = btn.Size
    scaleDown = scaleDown or 0.96
    btn.MouseButton1Down:Connect(function()
        btn.Size = UDim2.new(
            baseSize.X.Scale, math.floor(baseSize.X.Offset * scaleDown),
            baseSize.Y.Scale, math.floor(baseSize.Y.Offset * scaleDown))
    end)
    btn.MouseButton1Up:Connect(function()
        Anim.to(btn, { Size = baseSize }, 0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
end

-- 错开序列：对一组实例依次播放
function Anim.stagger(list, fn, interval)
    interval = interval or 0.02
    local delay = 0
    for _, inst in ipairs(list) do
        if inst and inst.Parent then
            fn(inst, delay)
        end
        delay = delay + interval
    end
end

UI.Anim = Anim

-- 触屏
function UI.ApplyTouchTweaks(gui)
    if not IS_TOUCH then return end

    local panel = gui:FindFirstChild("Panel")
    local list = panel and panel:FindFirstChild("List")
    if list then
        list.ScrollBarThickness = 6
        list.ScrollBarImageTransparency = 0.45
        list.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
        list.Active = true
    end

    local title = panel and panel:FindFirstChild("BigTitle")
    if title then
        local dragging, dragStart, startPos = false, nil, nil
        title.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = panel.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                panel.Position = UDim2.new(0.5, startPos.X.Offset + delta.X,
                                           0.5, startPos.Y.Offset + delta.Y)
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end
end

-- ============================================================
-- 控件工厂
-- ============================================================

-- 勾选框（原版方块样式 + 弹动动画）
local function makeCheckbox(parent, size, rightOffset, onChange)
    local hit = mk("TextButton", {
        Name = "CheckHit",
        Size = UDim2.new(0, size + 16, 0, size + 16),
        Position = UDim2.new(1, rightOffset - (size + 16), 0.5, -(size + 16) / 2),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 20,
        AutoButtonColor = false,
        Active = true,
    }, parent)

    local box = mk("Frame", {
        Name = "Box",
        Size = UDim2.new(0, size, 0, size),
        Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2),
        BackgroundColor3 = T.box,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 5,
        Active = false,
    }, hit)
    corner(box, 4)
    local st = stroke(box, T.boxStroke, 1, 0.3)

    -- 对勾
    local mark = mk("TextLabel", {
        Name = "Mark",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "✓",
        TextColor3 = T.tabTextOn,
        Font = FONT_BOLD,
        TextSize = math.floor(size * 0.85),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        Visible = false,
        ZIndex = 6,
        Active = false,
    }, box)
    local value = false

    local function render(animated)
        if value then
            -- 勾选：底色渐白 + 对勾从 0 缩放弹出
            if animated then
                Anim.to(box, { BackgroundColor3 = T.accent, BackgroundTransparency = 0 }, 0.14)
                Anim.to(st, { Transparency = 1 }, 0.14)
                mark.Visible = true
                mark.TextTransparency = 0
                mark.Size = UDim2.fromScale(0.2, 0.2)
                mark.Position = UDim2.fromScale(0.5, 0.5)
                local t = tween(mark, 0.22, {
                    Size = UDim2.fromScale(1, 1),
                    Position = UDim2.fromScale(0, 0),
                }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                box.BackgroundColor3 = T.accent
                box.BackgroundTransparency = 0
                st.Transparency = 1
                mark.Visible = true
                mark.TextTransparency = 0
                mark.Size = UDim2.fromScale(1, 1)
                mark.Position = UDim2.fromScale(0, 0)
            end
        else
            -- 取消：对勾缩回消失 + 底色恢复
            if animated then
                Anim.to(box, { BackgroundColor3 = T.ctrl, BackgroundTransparency = 0.15 }, 0.14)
                Anim.to(st, { Transparency = 0.35 }, 0.14)
                tween(mark, 0.12, {
                    Size = UDim2.fromScale(0.2, 0.2),
                    Position = UDim2.fromScale(0.5, 0.5),
                    TextTransparency = 1,
                }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                task.delay(0.13, function()
                    if not value and mark then
                        mark.Visible = false
                        mark.Size = UDim2.fromScale(1, 1)
                        mark.Position = UDim2.fromScale(0, 0)
                    end
                end)
            else
                box.BackgroundColor3 = T.ctrl
                box.BackgroundTransparency = 0.15
                st.Transparency = 0.35
                mark.Visible = false
                mark.TextTransparency = 1
            end
        end
    end
    hit.MouseEnter:Connect(function()
        if not value then tween(box, 0.12, { BackgroundColor3 = T.rowHover }) end
    end)
    hit.MouseLeave:Connect(function()
        if not value then tween(box, 0.12, { BackgroundColor3 = T.box }) end
    end)

    -- 按压回弹
    hit.MouseButton1Down:Connect(function()
        tween(box, 0.06, { Size = UDim2.new(0, size - 3, 0, size - 3),
                           Position = UDim2.new(0.5, -(size - 3) / 2, 0.5, -(size - 3) / 2) })
    end)
    hit.MouseButton1Up:Connect(function()
        tween(box, 0.1, { Size = UDim2.new(0, size, 0, size),
                          Position = UDim2.new(0.5, -size / 2, 0.5, -size / 2) }, Enum.EasingStyle.Back)
    end)

    -- 主触发：Activated（点击成立才触发）
    hit.Activated:Connect(function()
        value = not value
        render(true)
        playClick()
        if onChange then onChange(value) end
    end)

    return {
        Set = function(v, silent)
            value = v and true or false
            render(true)
            if not silent and onChange then onChange(value) end
        end,
        Get = function() return value end,
        SetSilent = function(v)
            value = v and true or false
            render(false)
        end,
    }
end

-- 按钮样式
local function makeButton(parent, cfg)
    local variant = cfg.Variant or "secondary"
    local w = cfg.Width or 88
    local h = cfg.Height or 30

    local bg, bgHover, fg, border
    if variant == "primary" then
        bg, bgHover, fg, border = T.tabActive, Color3.fromRGB(235, 235, 240), T.tabTextOn, nil
    elseif variant == "danger" then
        bg, bgHover, fg, border = Color3.fromRGB(42, 22, 24), Color3.fromRGB(58, 28, 30), T.danger, Color3.fromRGB(80, 38, 40)
    elseif variant == "ghost" then
        bg, bgHover, fg, border = T.panel, T.row, T.textDim, T.panelStroke
    else
        bg, bgHover, fg, border = T.tabIdle, T.rowHover, T.tabText, T.panelStroke
    end

    local btn = mk("TextButton", {
        Name = "Btn_" .. tostring(cfg.Text or cfg.Name or ""),
        Size = UDim2.new(0, w, 0, h),
        BackgroundColor3 = bg,
        BorderSizePixel = 0,
        Text = cfg.Text or cfg.Name or "按钮",
        Font = FONT_BOLD,
        TextSize = 13,
        TextColor3 = fg,
        AutoButtonColor = false,
        ZIndex = 6,
        Active = true,
    }, parent)
    corner(btn, 6)
    if border then stroke(btn, border, 1, 0.35) end

    btn.MouseEnter:Connect(function() tween(btn, 0.12, { BackgroundColor3 = bgHover }) end)
    btn.MouseLeave:Connect(function() tween(btn, 0.12, { BackgroundColor3 = bg }) end)
    btn.MouseButton1Down:Connect(function()
        tween(btn, 0.06, { Size = UDim2.new(0, w - 2, 0, h - 2) })
    end)
    btn.MouseButton1Up:Connect(function()
        tween(btn, 0.1, { Size = UDim2.new(0, w, 0, h) }, Enum.EasingStyle.Back)
    end)
    bindTap(btn, function()
        if cfg.Callback then UI.safeCall(cfg.Callback) end
    end)

    return btn
end

-- 数字输入
local function makeNumberInput(parent, cfg, onChange)
    local holder = mk("Frame", {
        Name = "NumInput",
        Size = UDim2.new(0, LAYOUT.inputW, 0, LAYOUT.inputH),
        Position = UDim2.new(1, -(LAYOUT.inputW + 8), 0.5, -LAYOUT.inputH / 2),
        BackgroundColor3 = T.box,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 20,
    }, parent)
    corner(holder, 4)
    local st = stroke(holder, T.boxStroke, 1, 0.3)

    local box = mk("TextBox", {
        Name = "Input",
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(cfg.Default or ""),
        TextColor3 = T.text,
        Font = FONT,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Center,
        ClearTextOnFocus = false,
        ZIndex = 21,
    }, holder)

    local function commit()
        local v = tonumber(box.Text)
        if v then
            if cfg.Min then v = math.max(cfg.Min, v) end
            if cfg.Max then v = math.min(cfg.Max, v) end
            box.Text = tostring(v)
            if onChange then onChange(v) end
        else
            box.Text = tostring(cfg.Default or "")
        end
    end

    if box.Focused then
        box.Focused:Connect(function()
            tween(st, 0.12, { Color = T.accent, Transparency = 0 })
        end)
    end
    box.FocusLost:Connect(function()
        tween(st, 0.12, { Color = T.boxStroke, Transparency = 0.3 })
        commit()
    end)

-- 快捷值按钮
    if cfg.Quick then
        local qw, gap = 46, 4
        local startX = -(LAYOUT.inputW + 8) - (#cfg.Quick) * (46 + 4) - 6
        for i, v in ipairs(cfg.Quick) do
            local qb = makeButton(parent, {
                Text = tostring(v),
                Variant = "ghost",
                Width = qw,
                Height = 30,
                Callback = function()
                    box.Text = tostring(v)
                    if onChange then onChange(v) end
                end,
            })
            qb.Position = UDim2.new(1, startX + (i - 1) * (qw + gap), 0.5, -15)
        end
    end

    return {
        Set = function(v) box.Text = tostring(v) end,
        Get = function() return tonumber(box.Text) end,
    }
end

-- 循环选择
-- 移动端加宽，方便点两侧箭头
local function makeCycle(parent, options, index, onChange)
    index = index or 1
    local w = LAYOUT.cycleW
    local h = LAYOUT.cycleH
    local arrowW = LAYOUT.cycleArrowW

    local holder = mk("Frame", {
        Name = "Cycle",
        Size = UDim2.new(0, w, 0, h),
        Position = UDim2.new(1, -(w + 8), 0.5, -h / 2),
        BackgroundColor3 = T.box,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        ZIndex = 20,
        Active = true,
    }, parent)
    corner(holder, 5)
    stroke(holder, T.boxStroke, 1, 0.3)

    local left = mk("TextButton", {
        Name = "Prev",
        Size = UDim2.fromOffset(arrowW, h),
        BackgroundTransparency = 1,
        Text = "<",
        Font = FONT_BOLD,
        TextSize = LAYOUT.cycleArrowText,
        TextColor3 = T.textDim,
        AutoButtonColor = false,
        ZIndex = 21,
        Active = true,
    }, holder)

    local label = mk("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, -arrowW * 2, 1, 0),
        Position = UDim2.fromOffset(arrowW, 0),
        BackgroundTransparency = 1,
        Font = FONT,
        Text = tostring(options[index] or ""),
        TextSize = LAYOUT.ctrlText,
        TextColor3 = T.text,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 21,
        Active = false,
    }, holder)

    local right = mk("TextButton", {
        Name = "Next",
        Size = UDim2.fromOffset(arrowW, h),
        Position = UDim2.new(1, -arrowW, 0, 0),
        BackgroundTransparency = 1,
        Text = ">",
        Font = FONT_BOLD,
        TextSize = LAYOUT.cycleArrowText,
        TextColor3 = T.textDim,
        AutoButtonColor = false,
        ZIndex = 21,
        Active = true,
    }, holder)

    local function apply(delta)
        index = ((index - 1 + delta) % #options) + 1
        -- 文字横向滑出，换字后从另一侧滑入
        local outX = delta > 0 and -10 or 10
        local inX = -outX
        local basePos = UDim2.fromOffset(arrowW, 0)
        tween(label, 0.1, {
            Position = UDim2.new(0, arrowW + outX, 0.5, -6),
            TextTransparency = 1,
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.1, function()
            if not label or not label.Parent then return end
            label.Text = tostring(options[index])
            label.Position = UDim2.new(0, arrowW + inX, 0.5, 6)
            tween(label, 0.16, {
                Position = basePos,
                TextTransparency = 0,
            }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        end)
        playClick()
        if onChange then onChange(options[index], index) end
    end

    bindTap(left, function() apply(-1) end)
    bindTap(right, function() apply(1) end)
    left.MouseEnter:Connect(function() tween(left, 0.1, { TextColor3 = T.text }) end)
    left.MouseLeave:Connect(function() tween(left, 0.1, { TextColor3 = T.textDim }) end)
    right.MouseEnter:Connect(function() tween(right, 0.1, { TextColor3 = T.text }) end)
    right.MouseLeave:Connect(function() tween(right, 0.1, { TextColor3 = T.textDim }) end)

    return {
        Set = function(v)
            for i, o in ipairs(options) do
                if o == v then index = i break end
            end
            label.Text = tostring(options[index])
        end,
        Get = function() return options[index], index end,
    }
end
-- ============================================================
-- 窗口
-- ============================================================
-- 顶栏按钮配色（和游戏自带按钮一致）
--   深色底 + 轻微透明；hover 时内圈变亮
local GAME_BTN_BG    = Color3.fromRGB(18, 18, 21)
local GAME_BTN_TRANS = 0.08
local GAME_BTN_HOVER = 0.30

local Window = {}
Window.__index = Window
local Tab = {

}
Tab.__index = Tab

local function createTopbarButton(self, labelText)
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    local topbar = playerGui:FindFirstChild("TopbarStandard")
    local holders = topbar and topbar:FindFirstChild("Holders")
    local left = holders and holders:FindFirstChild("Left")
    if not left then return end

    local text = labelText or "控制面板"

    -- 宽度照原版：90x44
    local widgetW = 90

    -- 先清掉可能残留的旧按钮，避免两个叠在一起 / 透明度被上一个动画带坏
    local oldWidget = left:FindFirstChild("CDMUIWidget")
    if oldWidget then pcall(function() oldWidget:Destroy() end) end

    local widget = mk("Frame", {
        Name = "CDMUIWidget",
        Size = UDim2.new(0, widgetW, 0, 44),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 20,
        LayoutOrder = 90,
    }, left)
    -- 明确重置：上一轮退出动画可能把它留在透明状态
    widget.Size = UDim2.new(0, widgetW, 0, 44)

    -- 外圈：游戏自带同款深色底（hover 时不变）
    local bg = mk("Frame", {
        Name = "IconButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = GAME_BTN_BG,
        BackgroundTransparency = GAME_BTN_TRANS,
        BorderSizePixel = 0,
        ZIndex = 2,
    }, widget)
    -- 强制写一次，防止被上一轮的淡出动画残留影响
    bg.BackgroundTransparency = GAME_BTN_TRANS
    corner(bg, 999)

    -- 内圈：hover 时这个变白（游戏自带行为）
    local iconSpot = mk("Frame", {
        Name = "IconSpot",
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(225, 225, 230),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 4,
    }, bg)
    corner(iconSpot, 999)

    local hover = mk("Frame", {
        Name = "IconOverlay",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0.85,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 5,
    }, iconSpot)
    corner(hover, 999)

    -- 文字：原版 16 / GothamMedium
    mk("TextLabel", {
        Name = "IconLabel",
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 16,
        Font = Enum.Font.GothamMedium,
        TextWrapped = false,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 10,
    }, iconSpot)
    local click = mk("TextButton", {
        Name = "ClickRegion",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 20,
        Active = true,
    }, iconSpot)
    corner(click, 999)

    -- 三态：常态透明 / 悬浮淡白(0.82) / 激活亮白(0.70)+外圈
    local hovering = false
    local active = false

    local function applyVisual()
        if active then
            iconSpot.BackgroundTransparency = 0.7
            hover.Visible = true
        elseif hovering then
            iconSpot.BackgroundTransparency = 0.82
            hover.Visible = false
        else
            iconSpot.BackgroundTransparency = 1
            hover.Visible = false
        end
    end

    click.MouseEnter:Connect(function()
        hovering = true
        applyVisual()
    end)
    click.MouseLeave:Connect(function()
        hovering = false
        applyVisual()
    end)

    self.TopbarSetActive = function(on)
        active = on and true or false
        applyVisual()
    end

    self.TopbarResetHover = function()
        hovering = false
        applyVisual()
    end

    bindTap(click, function()
        if self.Visible then self._closedByTopbar = true end
        self:SetVisible(not self.Visible)
        if self.TopbarSetActive then self.TopbarSetActive(self.Visible) end
    end)

    -- 出现动画：从稍小 + 透明，弹到位
    widget.Visible = true
    local appearScale = Instance.new("UIScale")
    appearScale.Scale = 0.3
    appearScale.Parent = widget

    local parts = { bg }
    for _, c in ipairs(widget:GetChildren()) do
        if c:IsA("GuiObject") and c ~= bg and c:IsA("Frame") then
            table.insert(parts, c)
        end
    end
    for _, c in ipairs(parts) do
        c.BackgroundTransparency = 1
    end

    task.spawn(function()
        Anim.to(appearScale, { Scale = 1 }, 0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        task.wait(0.06)
        for _, c in ipairs(parts) do
            -- 回到各自原本的透明度
            local target = (c == bg) and GAME_BTN_TRANS or 1
            Anim.to(c, { BackgroundTransparency = target }, 0.3,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
        -- 兜底：确保外圈底色一定恢复（防止被上一轮淡出动画干扰）
        task.delay(0.4, function()
            if bg and bg.Parent then
                pcall(function() bg.BackgroundTransparency = GAME_BTN_TRANS end)
            end
        end)
    end)

    self.TopbarButton = widget
    -- 记到窗口上，退出动画时一起淡出
    self.TopbarBtn = widget
    return widget
end

-- ============================================================
-- 控件注册
-- 统一入口，带 key 冲突检测和接口校验
-- ============================================================
local function registerControl(tab, key, ctrl)
    if type(key) ~= "string" or key == "" then
        warn("[CDMUI] 控件缺少有效的 Key，已跳过注册")
        return ctrl
    end
    -- 检测重复 key（同一 Tab 内）
    if tab.Rows[key] ~= nil then
        warn("[CDMUI] Key '" .. key .. "' 在该 Tab 内重复，后者覆盖前者")
    end
    -- 保证至少有 Set / Get
    if type(ctrl) == "table" then
        if type(ctrl.Get) ~= "function" then
            warn("[CDMUI] 控件 '" .. key .. "' 缺少 Get 方法")
        end
        if type(ctrl.Set) ~= "function" then
            warn("[CDMUI] 控件 '" .. key .. "' 缺少 Set 方法")
        end
    end
    tab.Rows[key] = ctrl
    return ctrl
end

-- ============================================================
-- 折叠基类
-- Expand 和 Body2D 共用：
--   · 主行 + 箭头 + 子内容区
--   · 状态存 Window.State[expandKey]
--   · 切页时由 ExpandRestorers 统一恢复
--   · 收起时必须 Visible=false（否则 UIListLayout 会留 6px 间隙）
-- ============================================================
local function makeFoldable(tab, opts)
    local window = tab.Window
    local expandKey = opts.expandKey
    local row = opts.row
    local arrowBtn = opts.arrow
    local onState = opts.onState           -- function(open, animate, delay)
    local arrowSize = opts.arrowSize or LAYOUT.arrowSize
    local ARROW_W = arrowSize

    -- 状态初始化
    if window.State[expandKey] == nil then
        window.State[expandKey] = false
    end

    local function currentState()
        return window.State[expandKey] == true
    end

    -- 设置展开状态（唯一入口）
    local function setOpen(open, animate, delay)
        open = open and true or false
        window.State[expandKey] = open
        if onState then
            local ok, err = pcall(onState, open, animate, delay)
            if not ok then
                warn("[CDMUI] 折叠状态应用失败: " .. tostring(err))
            end
        end
        -- 箭头统一处理
        if arrowBtn and arrowBtn.Parent then
            if animate then
                Anim.to(arrowBtn, { Rotation = open and 180 or 0 }, 0.24,
                    Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            else
                Anim.snap(arrowBtn, { Rotation = open and 180 or 0 })
            end
        end
    end

    -- 切换
    local function toggle()
        setOpen(not currentState(), true, 0)
    end

    -- 注册到切页恢复器
    -- 注意：apply 只改界面，绝不写 State。
    -- setPage 会对「非当前页」调用 apply(false) 来隐藏内容，
    -- 如果这里顺手写了 State，切页会把用户的真实选择覆盖掉。
    table.insert(window.ExpandRestorers, {
        tab = tab,
        expandKey = expandKey,
        panelRow = row,
        get = function() return window.State[expandKey] == true end,
        apply = function(open)
            local show = open == true
            if onState then
                local ok, err = pcall(onState, show, false, 0)
                if not ok then
                    warn("[CDMUI] 折叠状态应用失败: " .. tostring(err))
                end
            end
            if arrowBtn and arrowBtn.Parent then
                Anim.snap(arrowBtn, { Rotation = show and 180 or 0 })
            end
        end,
    })

    return {
        key = expandKey,
        isOpen = currentState,
        setOpen = setOpen,
        toggle = toggle,
    }
end
-- 遮罩点击：只有点在面板矩形之外才关闭（原版逻辑）
local function bindShieldClose(self)
    self.Shield.MouseButton1Click:Connect(function()
        playClick()
        -- 加载动画期间不许关
        if self.Busy then return end

        local mp = UserInputService:GetMouseLocation()
        local ap = self.Panel.AbsolutePosition
        local asz = self.Panel.AbsoluteSize
        if mp.X >= ap.X and mp.X <= ap.X + asz.X
            and mp.Y >= ap.Y and mp.Y <= ap.Y + asz.Y then
            return
        end
        -- 标记：这次关闭来自点击边界外（由 SetVisible 内部消费）
        self._closedByShield = true
        self:SetVisible(false)
    end)
end
-- 自清理：销毁上一次加载留下的所有实例（GUI + 顶栏按钮），避免重复加载时叠影子
local function purgePrevious()
    local removed = 0

    -- 1) CoreGui / PlayerGui 下的面板
    local ok, hui = pcall(function() return gethui and gethui() end)
    local containers = {}
    if ok and hui then containers[#containers + 1] = hui end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then containers[#containers + 1] = core end
    local pg = nil
    pcall(function()
        local candidate = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        if candidate then pg = candidate end
    end)
    if typeof(pg) == "Instance" then containers[#containers + 1] = pg else pg = nil end

    for _, container in ipairs(containers) do
        if typeof(container) == "Instance" then
            pcall(function()
                for _, d in ipairs(container:GetDescendants()) do
                    if d and (d.Name == "ControlPanelUI" or d.Name == "CDMUIRoot"
                              or d.Name == "CDMUIGuide" or d.Name == "CDMUIWidget"
                              or d.Name == "ControlPanelBtn") then
                        pcall(function() d:Destroy() end)
                        removed = removed + 1
                    end
                end
            end)
        end
    end

    -- 2) 各顶栏的 Widget
    if typeof(pg) == "Instance" then
        for _, tbName in ipairs({ "TopbarStandard", "TopbarCentered", "TopbarStandardClipped", "TopbarCenteredClipped" }) do
            local tb = pg:FindFirstChild(tbName)
            local holders = tb and tb:FindFirstChild("Holders")
            if holders then
                for _, side in ipairs(holders:GetChildren()) do
                    for _, c in ipairs(side:GetChildren()) do
                        if c.Name == "CDMUIWidget" or c.Name == "ControlPanelBtn" or c.Name == "CDMUIButton" then
                            pcall(function() c:Destroy() end)
                            removed = removed + 1
                        end
                    end
                end
            end
        end
    end

    return removed
end
function UI.Create(opts)
    opts = opts or {}
    purgePrevious()
    local self = setmetatable({}, Window)
    self.Title = opts.Title or "控制面板"
    self.ToggleKey = opts.ToggleKey   -- nil = 不注册快捷键（避免和游戏按键冲突）
    self.Hint = opts.Hint or "点击边界之外以关闭"
    self.Tabs = {}
    self.State = {}
    self.ExpandRestorers = {}
    self.Rows = {}
    self.Connections = {}
    self.Visible = false
    self.TabIndex = 1
    self.Destroyed = false

    local gui = mk("ScreenGui", {
        Name = opts.GuiName or "ControlPanelUI",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = opts.DisplayOrder or 101,
        Enabled = false,
    }, guiParent())
    self.Gui = gui

    -- 自适应缩放（原版做法）
    local baseScale = adaptiveScale()
    local scale = mk("UIScale", { Scale = baseScale }, gui)
    self.Scale = scale
    self.BaseScale = baseScale
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam and cam.GetPropertyChangedSignal then
            table.insert(self.Connections, cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                scale.Scale = adaptiveScale()
            end))
        end
    end)

    -- 点击遮罩：必须在面板之下（ZIndex 1 < 面板 2），且要判断点击是否真的在面板外
    local shield = mk("TextButton", {
        Name = "Shield",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 1,
        Active = true,
    }, gui)
    self.Shield = shield

    -- 主面板
    local panel = mk("Frame", {
        Name = "Panel",
        Size = UDim2.new(0, PANEL_W, 0, PANEL_H),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 10),   -- 略微上移，视觉更平衡
        BackgroundColor3 = T.panel,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ZIndex = 2,
        Active = true,
    }, gui)
    corner(panel, 8)
    stroke(panel, T.panelStroke, 1, 0.5)
    self.Panel = panel

    -- 大标题
    local bigTitle = mk("TextLabel", {
        Name = "BigTitle",
        Size = UDim2.new(1, 0, 0, 56),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundTransparency = 1,
        Text = self.Title,
        TextColor3 = Color3.new(1, 1, 1),
        Font = FONT_BLACK,
        TextSize = LAYOUT.titleSize,
        ZIndex = 3,
    }, panel)

    -- Tab 栏
    local tabBar = mk("ScrollingFrame", {
        Name = "TabBar",
        Size = UDim2.new(1, -LAYOUT.padX * 2, 0, LAYOUT.tabHeight + 6),
        Position = UDim2.new(0, LAYOUT.padX, 0, LAYOUT.tabY),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollBarThickness = IS_MOBILE and 5 or 3,
        ScrollBarImageColor3 = Color3.fromRGB(120, 120, 130),
        ScrollBarImageTransparency = 0.35,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        Active = true,
        ClipsDescendants = true,
    }, panel)

    self.TabBar = tabBar
    tabBar:SetAttribute("__basePos", tabBar.Position)
    tabBar:SetAttribute("__baseTrans", tabBar.BackgroundTransparency)
    -- 布局尺寸变化后重新等分（首次 AbsoluteSize 可能为 0）
    table.insert(self.Connections, tabBar:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:LayoutTabs()
    end))

    -- Tab 栏拖动：只有从 Tab 栏范围内起手才生效
    do
        local bar = tabBar
        local dragging, dragMoved = false, false
        local dragStartX, dragStartY, dragStartCanvas = 0, 0, 0
        local lastDragX = 0

        local function inBar(px, py)
            local ap, sz = bar.AbsolutePosition, bar.AbsoluteSize
            return px >= ap.X and px <= ap.X + sz.X
               and py >= ap.Y and py <= ap.Y + sz.Y
        end

        -- 拖动期间把 Tab 按钮全禁掉，松手就不会触发 Activated
        local function setTabsActive(on)
            for _, tb in ipairs(self.Tabs) do
                pcall(function() tb.Button.Active = on end)
            end
        end

        local function onBegin(input)
            if not bar.ScrollingEnabled then return end
            local it = input.UserInputType
            if it ~= Enum.UserInputType.Touch and it ~= Enum.UserInputType.MouseButton1 then return end
            if not inBar(input.Position.X, input.Position.Y) then return end
            dragging = true
            dragMoved = false
            dragStartX = input.Position.X
            dragStartY = input.Position.Y
            lastDragX = input.Position.X
            dragStartCanvas = bar.CanvasPosition.X
        end

        local function onMove(input)
            if not dragging then return end
            local it = input.UserInputType
            if it ~= Enum.UserInputType.Touch and it ~= Enum.UserInputType.MouseMovement then return end
            local curX = input.Position.X
            local dy = input.Position.Y - dragStartY
            local dx = curX - dragStartX

            -- 手机手指滑动的起始抖动比鼠标大，阈值放低一点更好拖
            local DRAG_TH = IS_MOBILE and 12 or 18
            if not dragMoved
               and math.abs(dx) > DRAG_TH
               and math.abs(dx) > math.abs(dy) * (IS_MOBILE and 1.2 or 1.5) then
                dragMoved = true
                setTabsActive(false)
                -- 判定成拖动这一刻重新取基准，别把判定距离补上去
                dragStartX = curX
                lastDragX = curX
                return
            end
            if not dragMoved then return end

            local sc2 = (self.Scale and self.Scale.Scale) or 1
            if sc2 <= 0 then sc2 = 1 end
            local maxX = math.max(0, bar.CanvasSize.X.Offset * sc2 - bar.AbsoluteSize.X)
            -- 手指移动 1px（已缩放），内容要移动 1px（已缩放）
            -- 但 CanvasPosition 是未缩放坐标，所以要乘 sc2 才对得上
            local step = (lastDragX - curX)
            lastDragX = curX
            local target = math.clamp(bar.CanvasPosition.X + step, 0, maxX)
            bar.CanvasPosition = Vector2.new(target, 0)
        end

        local function onEnd(input)
            if not dragging then return end
            local it = input.UserInputType
            if it == Enum.UserInputType.Touch or it == Enum.UserInputType.MouseButton1 then
                dragging = false
                if dragMoved then
                    getgenv()._CDMUITabDragBlock = os.clock() + 0.15
                end
                dragMoved = false
                lastDragX = 0
                -- 延迟恢复，确保这次松手已经处理完
                task.delay(0.15, function()
                    setTabsActive(true)
                end)
            end
        end

        table.insert(self.Connections, UserInputService.InputBegan:Connect(onBegin))
        table.insert(self.Connections, UserInputService.InputChanged:Connect(onMove))
        table.insert(self.Connections, UserInputService.InputEnded:Connect(onEnd))
    end

    -- 列表
    local list = mk("ScrollingFrame", {
        Name = "List",
        Size = UDim2.new(1, -LAYOUT.padX * 2, 1, -200),
        Position = UDim2.new(0, LAYOUT.padX, 0, LAYOUT.listTop),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 110),
        ScrollBarImageTransparency = 0.3,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
        Active = true,
    }, panel)
    local pad = mk("UIPadding", {
        PaddingTop = UDim.new(0, 2),
        PaddingBottom = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 0),
    }, list)
    mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, list)
    self.List = list
    list:SetAttribute("__basePos", list.Position)
    list:SetAttribute("__baseTrans", list.BackgroundTransparency)

    -- 底部提示
    local hint = mk("TextLabel", {
        Name = "Hint",
        Size = UDim2.new(1, 0, 0, 24),
        Position = UDim2.new(0, 0, 1, -30),
        BackgroundTransparency = 1,
        Text = self.Hint,
        TextColor3 = T.hint,
        Font = FONT,
        TextSize = LAYOUT.hintSize,
        ZIndex = 3,
    }, panel)

    -- 快捷键（仅在显式传了 ToggleKey 时注册，避免和游戏按键冲突）
    if self.ToggleKey then
        table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, processed)
            if processed then return end
            if input.KeyCode == self.ToggleKey then
                self:SetVisible(not self.Visible)
            end
        end))
    end
    -- 进场初始态：只改透明度，不动 Size（否则会永久缩小）
    panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    panel.BackgroundTransparency = 1

    -- 打开面板时自动解锁鼠标（默认开启，可传 AutoUnlockMouse = false 关闭）
    self.AutoUnlockMouse = (opts.AutoUnlockMouse ~= false)

    bindShieldClose(self)

    -- 左上角按钮：先记下选项，等加载动画放完再创建，
    -- 否则开局就跟面板一起弹出来，显得很突然。
    self._topbarPending = (opts.TopbarButton ~= false)
    self._topbarText = opts.TopbarText

    -- 触屏适配（仅移动端生效）
    pcall(UI.ApplyTouchTweaks, gui)

    -- 登记到全局：下次加载库时会自动销毁这个窗口
    if type(_G._CDMUILiveWindows) ~= "table" then _G._CDMUILiveWindows = {} end
    table.insert(_G._CDMUILiveWindows, self)
    -- 重载时：先播退出动画，再延迟销毁
    _G._CDMUILastCleanup = function()
        local old = _G._CDMUILiveWindows or {}
        _G._CDMUILiveWindows = {}

        for _, w in ipairs(old) do
            if type(w) == "table" and w.Destroyed ~= true then
                pcall(function()
                    w.Busy = false
                    -- 断开所有连接，让交互先停掉
                    for _, c in ipairs(w.Connections or {}) do
                        pcall(function() c:Disconnect() end)
                    end
                    w.Connections = {}
                    -- 注意：不要在这里设 Destroyed=true，
                    -- 否则 PlayExitAnim 会跳过这个窗口
                end)
            end
        end

        -- 重载/卸载前先把鼠标还原，否则 hook 留下会卡住鼠标
        for _, w in ipairs(old) do
            pcall(function()
                if type(w) == "table" and w._RestoreMouse then
                    w:_RestoreMouse()
                end
            end)
        end

        -- 播动画（用刚清空前的列表，所以直接传进去）
        _G._CDMUILiveWindows = old
        UI.PlayExitAnim(0.22)
        _G._CDMUILiveWindows = {}

        -- 延迟销毁：先全部设 Visible=false 兜底，再销毁
        task.delay(0.26, function()
            for _, w in ipairs(old) do
                pcall(function()
                    local gui = w.Gui
                    if gui and gui.Parent then
                        -- 兜底：先把所有可见元素按住，防止动画漏掉的元素闪一下
                        for _, d in ipairs(gui:GetDescendants()) do
                            pcall(function()
                                if d:IsA("Frame") or d:IsA("TextLabel")
                                   or d:IsA("TextButton") or d:IsA("TextBox")
                                   or d:IsA("ImageLabel") or d:IsA("ImageButton")
                                   or d:IsA("ScrollingFrame") then
                                    d.Visible = d.Visible
                                end
                            end)
                        end
                        gui.Enabled = false
                        gui:Destroy()
                    end
                    local btn = w.TopbarBtn
                    if btn and btn.Parent then btn:Destroy() end
                    local g = w._guideGui
                    if g and g.Parent then g:Destroy() end

                    -- 释放鼠标 hook 引用；最后一个释放的会把 __newindex 完全还原
                    pcall(function()
                        if w._HardLockMouse then w:_HardLockMouse(false) end
                    end)
                end)
            end
        end)

        -- 返回等待函数，让新脚本知道动画还要播多久
        return function()
            local t0 = os.clock()
            while os.clock() - t0 < 0.28 do
                RunService.RenderStepped:Wait()
            end
        end
    end

    -- 默认直接显示（原版是点顶栏按钮才弹，这里给个 AutoOpen 选项）
    -- 不自动打开时，按钮立刻就建（没有加载动画要等）
    if opts.AutoOpen == false and self._topbarPending then
        self._topbarPending = false
        pcall(createTopbarButton, self, self._topbarText)
    end

    if opts.AutoOpen ~= false then
        self.Visible = true
        self.Gui.Enabled = true
        self.Panel.Visible = false
        task.defer(function()
            if not self.Destroyed and not UI.IsStale() then self:_PlayIntro() end
        end)
    end

    return self
end

-- 面板显示/隐藏：
--   不再从 BackgroundTransparency = 1 起步（那会让面板变透明、游戏画面透出来）
--   改用「缩放 + 位移 + 轻微淡化」，底色始终存在，观感干净
-- 首次运行的加载 + 欢迎动画
function Window:_PlayIntro()
    -- 被新的运行取代了就别再播动画
    if UI.IsStale() or self.Destroyed then return end

    local gui = self.Gui
    local panel = self.Panel

    -- 加载期间锁住关闭入口
    self.Busy = true

    -- 隐藏主面板，先播加载
    panel.Visible = false

    local splash = mk("Frame", {
        Name = "Splash",
        Size = UDim2.new(0, 300, 0, 150),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = T.panel,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 100,
    }, gui)
    corner(splash, 10)
    local st = stroke(splash, T.panelStroke, 1, 1)
    local splashScale = mk("UIScale", { Scale = 0.85 }, splash)

    -- 标题
    local title = mk("TextLabel", {
        Name = "SplashTitle",
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.new(0, 0, 0, 34),
        BackgroundTransparency = 1,
        Text = "CDMUI",
        TextColor3 = T.text,
        Font = FONT_BLACK,
        TextSize = 26,
        ZIndex = 101,
    }, splash)

    -- 加载文字
    local status = mk("TextLabel", {
        Name = "SplashStatus",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 68),
        BackgroundTransparency = 1,
        Text = "正在加载",
        TextColor3 = T.textDim,
        Font = FONT,
        TextSize = 13,
        ZIndex = 101,
    }, splash)

    -- 进度条
    local track = mk("Frame", {
        Name = "SplashTrack",
        Size = UDim2.new(0, 220, 0, 4),
        Position = UDim2.new(0.5, -110, 0, 104),
        BackgroundColor3 = T.ctrl,
        BorderSizePixel = 0,
        ZIndex = 101,
    }, splash)
    corner(track, 2)

    local fill = mk("Frame", {
        Name = "SplashFill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.accent,
        BorderSizePixel = 0,
        ZIndex = 102,
    }, track)
    corner(fill, 2)

    -- 淡入
    Anim.to(splash, { BackgroundTransparency = 0.05 }, 0.22,
        Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    Anim.to(st, { Transparency = 0.4 }, 0.22)
    Anim.to(splashScale, { Scale = 1 }, 0.30,
        Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- 进度推进
    local steps = {
        { 0.18, 0.35, "正在加载界面" },
        { 0.38, 0.70, "正在初始化控件" },
        { 0.58, 1.00, "准备就绪" },
    }
    for _, s in ipairs(steps) do
        local at, prog, txt = s[1], s[2], s[3]
        task.delay(at, function()
            if not splash.Parent then return end
            Anim.to(fill, { Size = UDim2.new(prog, 0, 1, 0) }, 0.16,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            status.Text = txt
        end)
    end
    local acc = 0.58

    -- 播放完后切主面板
    task.delay(acc + 0.30, function()
        if not splash.Parent then return end

        -- 淡出 splash
        Anim.to(splash, { BackgroundTransparency = 1 }, 0.20,
            Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        Anim.to(st, { Transparency = 1 }, 0.20)
        if title then Anim.to(title, { TextTransparency = 1 }, 0.16) end
        if status then Anim.to(status, { TextTransparency = 1 }, 0.16) end
        Anim.to(track, { BackgroundTransparency = 1 }, 0.16)
        Anim.to(fill, { BackgroundTransparency = 1 }, 0.16)
        Anim.to(splashScale, { Scale = 0.94 }, 0.20,
            Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        task.delay(0.22, function()
            -- 已经被新的运行取代，收干净走人
            if UI.IsStale() or self.Destroyed then
                if splash.Parent then splash:Destroy() end
                return
            end
            if splash.Parent then splash:Destroy() end

            -- 显示主面板并播放入场
            panel.Visible = true
            self:_UnlockMouse()

            -- 加载动画到这里算放完了，这时才挂顶栏按钮
            if self._topbarPending then
                self._topbarPending = false
                pcall(createTopbarButton, self, self._topbarText)
                if self.TopbarSetActive then
                    pcall(self.TopbarSetActive, true)
                end
            end

            -- 加载完成后还有 1 秒保护期，避免刚出来就被手快的点掉
            task.delay(1.0, function()
                if not self.Destroyed and not UI.IsStale() then
                    self.Busy = false
                end
            end)
            -- 不要设 0（否则面板完全不可见，且难以恢复）
            if self.Scale then self.Scale.Scale = (self.BaseScale or 1) * 0.9 end
            panel.BackgroundTransparency = 1

            for _, w in ipairs(self:_ContentParts()) do
                if not w:GetAttribute("__basePos") then
                    w:SetAttribute("__basePos", w.Position)
                end
                local base = w:GetAttribute("__basePos")
                local bt = w:GetAttribute("__baseTrans") or 1
                w.Position = UDim2.new(base.X.Scale, base.X.Offset,
                                       base.Y.Scale, base.Y.Offset + 16)
                w.BackgroundTransparency = math.min(1, bt + 0.6)
            end

            panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
            Anim.to(panel, { BackgroundTransparency = 0.05 }, 0.24,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if self.Scale then
                Anim.to(self.Scale, { Scale = self.BaseScale or 1 }, 0.40,
                    Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end

            -- Tab 栏容器先出来
            local delay = 0.04
            for _, w in ipairs(self:_ContentParts()) do
                local base = w:GetAttribute("__basePos")
                Anim.to(w, {
                    Position = base,
                    BackgroundTransparency = w:GetAttribute("__baseTrans") or 0,
                }, 0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, delay)
                delay = delay + 0.08
            end

            -- Tab 栏整体滚动入场：
            --   「其他」先出现在最左边，然后整条 Tab 栏往右滚，
            --   依次带出 雷达 → 战斗 → 视觉 → 枪械 → 人物
            do
                local n = #self.Tabs
                if n > 0 then
                    pcall(function()
                        -- 先让布局算好位置
                        self:LayoutTabs()

                        -- Tab 太少（总宽撑不满一屏）就不滚动，改成柔和淡入
                        local bar = self.TabBar
                        local barW = bar and bar.AbsoluteSize.X or 0
                        local totalW = 0
                        for _, tb in ipairs(self.Tabs) do
                            if tb.Button then
                                totalW = totalW + tb.Button.Size.X.Offset + 7
                            end
                        end
                        if totalW <= barW + 4 or n < 3 then
                            -- Tab 撑不满一屏：不滚动，改成从左往右依次淡入
                            self._tabAnimating = true
                            -- 同样禁用交互，避免鼠标提前点亮
                            local savedTabActive = {}
                            for i, tb in ipairs(self.Tabs) do
                                if tb.Button then
                                    pcall(function()
                                        savedTabActive[i] = tb.Button.Active
                                        tb.Button.Active = false
                                    end)
                                end
                            end
                            local orig = {}
                            for i, tb in ipairs(self.Tabs) do
                                if tb.Button then
                                    orig[i] = {
                                        pos = tb.Button.Position,
                                        bg = tb.Button.BackgroundTransparency,
                                        tx = tb.Button.TextTransparency,
                                    }
                                    -- 起点：往左偏 24px + 全透明
                                    tb.Button.Position = UDim2.new(
                                        orig[i].pos.X.Scale, orig[i].pos.X.Offset - 24,
                                        orig[i].pos.Y.Scale, orig[i].pos.Y.Offset)
                                    tb.Button.BackgroundTransparency = 1
                                    tb.Button.TextTransparency = 1
                                end
                            end

                            for i, tb in ipairs(self.Tabs) do
                                if tb.Button and orig[i] then
                                    pcall(function()
                                        local d = 0.15 + (i - 1) * 0.10
                                        -- 滑回原位 + 淡入
                                        TweenService:Create(tb.Button, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, d), {
                                            Position = orig[i].pos,
                                        }):Play()
                                        TweenService:Create(tb.Button, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, d), {
                                            BackgroundTransparency = orig[i].bg,
                                            TextTransparency = orig[i].tx,
                                        }):Play()
                                    end)
                                end
                            end
                            -- 最后一个播完再放开布局
                            task.delay(0.15 + n * 0.10 + 0.60, function()
                                if self.Destroyed then return end
                                -- 动画期间画布保持「撑满」，避免滚动条在最后一帧跳动
                                -- 先解锁，再延迟一帧恢复布局，滚动条变化就不会被看到
                                self._tabAnimating = false
                                -- 动画结束，恢复滚动条显示
                                if self.TabBar and self.TabBar.Parent then
                                    pcall(function()
                                        self.TabBar.ScrollBarImageTransparency = 0.35
                                    end)
                                end
                                -- 恢复 Tab 交互
                                for i, tb in ipairs(self.Tabs) do
                                    if tb.Button then
                                        pcall(function()
                                            tb.Button.Active = savedTabActive[i] ~= false
                                        end)
                                    end
                                end
                                task.defer(function()
                                    if self.Destroyed then return end
                                    pcall(function() self:LayoutTabs() end)
                                    -- 布局稳定后再把滚动条淡回来
                                    if bar then
                                        pcall(function()
                                            bar.ScrollBarImageTransparency = 1
                                            TweenService:Create(bar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                                ScrollBarImageTransparency = 0.35,
                                            }):Play()
                                        end)
                                    end
                                end)
                            end)
                            return
                        end

                        -- 用闭包存基准位置（不依赖 SetAttribute）
                        local bases = {}
                        for i, tb in ipairs(self.Tabs) do
                            if tb.Button then
                                bases[i] = tb.Button.Position
                            end
                        end

                        -- 标记动画中，阻止 LayoutTabs 抢位置
                        self._tabAnimating = true
                        -- 动画期间把滚动条藏起来，动画结束时再淡入
                        if bar then
                            pcall(function() bar.ScrollBarImageTransparency = 1 end)
                        end

                        -- 动画期间禁用 Tab 按钮的鼠标响应，
                        -- 否则鼠标停在某个 Tab 上会提前点亮它
                        local savedTabActive = {}
                        for i, tb in ipairs(self.Tabs) do
                            if tb.Button then
                                pcall(function()
                                    savedTabActive[i] = tb.Button.Active
                                    tb.Button.Active = false
                                end)
                            end
                        end

                        -- 起点：最后一个 Tab 的左边缘刚好落在栏最左边
                        local lastBase = bases[n]
                        local startOffset = lastBase and (-lastBase.X.Offset) or (-n * 130)

                        for i, tb in ipairs(self.Tabs) do
                            if tb.Button and bases[i] then
                                tb.Button.Position = UDim2.new(
                                    bases[i].X.Scale, bases[i].X.Offset + startOffset,
                                    bases[i].Y.Scale, bases[i].Y.Offset)
                            end
                        end

                        local t0 = os.clock()
                        local dur = 1.15
                        local conn
                        conn = RunService.Heartbeat:Connect(function()
                            if self.Destroyed then
                                conn:Disconnect()
                                return
                            end
                            local a = math.clamp((os.clock() - t0) / dur, 0, 1)
                            -- 起步就带速度（ease-out cubic），避免迟滞感
                            local e = 1 - (1 - a) ^ 3
                            local offset = startOffset * (1 - e)
                            for i, tb in ipairs(self.Tabs) do
                                if tb.Button and bases[i] then
                                    pcall(function()
                                        tb.Button.Position = UDim2.new(
                                            bases[i].X.Scale, bases[i].X.Offset + offset,
                                            bases[i].Y.Scale, bases[i].Y.Offset)
                                    end)
                                end
                            end
                            if a >= 1 then
                                conn:Disconnect()
                                -- 收尾精确归位
                                for i, tb in ipairs(self.Tabs) do
                                    if tb.Button and bases[i] then
                                        pcall(function() tb.Button.Position = bases[i] end)
                                    end
                                end
                                self._tabAnimating = false
                                -- 动画结束，恢复滚动条显示
                                if self.TabBar and self.TabBar.Parent then
                                    pcall(function()
                                        self.TabBar.ScrollBarImageTransparency = 0.35
                                    end)
                                end
                                pcall(function() self:LayoutTabs() end)
                            end
                        end)
                    end)
                end
            end

            -- 功能内容：从左往右滑入，一个接一个（互相重叠）
            pcall(function()
                local curTab = self.Tabs[self.TabIndex or 1]
                local src = (curTab and curTab.Widgets) or {}
                local rows = {}
                for _, w in ipairs(src) do
                    if w and w.Parent and w.Visible then
                        rows[#rows + 1] = w
                    end
                end
                -- 按 LayoutOrder 排序（布局顺序稳定，不会随机）
                table.sort(rows, function(a, b)
                    local la, lb = a.LayoutOrder or 0, b.LayoutOrder or 0
                    if la ~= lb then return la < lb end
                    return a.Position.Y.Offset < b.Position.Y.Offset
                end)

                local maxRows = math.min(#rows, 14)

                -- 入场期间每行各自屏蔽悬停
                for i = 1, maxRows do
                    pcall(function() rows[i]:SetAttribute("__introBusy", true) end)
                end

                -- 顺便把可交互元素按住
                local savedActive = {}
                local function setRowActive(w, on)
                    pcall(function()
                        local list = savedActive[w]
                        if not list then
                            list = {}
                            savedActive[w] = list
                            local all = {w}
                            for _, d in ipairs(w:GetDescendants()) do
                                if d:IsA("GuiObject") then all[#all + 1] = d end
                            end
                            for k, o in ipairs(all) do
                                list[k] = { obj = o, active = o.Active }
                            end
                        end
                        for _, ent in ipairs(list) do
                            pcall(function() ent.obj.Active = on and ent.active or false end)
                        end
                    end)
                end
                for i = 1, maxRows do
                    setRowActive(rows[i], false)
                end

                for i = 1, maxRows do
                    local w = rows[i]
                    pcall(function()
                        -- 记录原始状态
                        local basePos = w.Position
                        local baseT = w.BackgroundTransparency
                        local parts = {}
                        for _, d in ipairs(w:GetDescendants()) do
                            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                                parts[#parts + 1] = { obj = d, prop = "TextTransparency", base = d.TextTransparency }
                            elseif d:IsA("Frame") then
                                parts[#parts + 1] = { obj = d, prop = "BackgroundTransparency", base = d.BackgroundTransparency }
                            elseif d:IsA("UIStroke") then
                                parts[#parts + 1] = { obj = d, prop = "Transparency", base = d.Transparency }
                            end
                        end

                        -- 起点：往左偏 40px + 全透明
                        w.Position = UDim2.new(basePos.X.Scale, basePos.X.Offset - 40,
                                               basePos.Y.Scale, basePos.Y.Offset)
                        w.BackgroundTransparency = 1
                        for _, p2 in ipairs(parts) do
                            pcall(function() p2.obj[p2.prop] = 1 end)
                        end

                        -- 等 Tab 动画播完，然后每行间隔 0.08 秒依次滑入
                        -- 单行动画 0.42 秒，间隔 0.08 -> 前一行刚播 20% 后一行就起步
                        -- Tab 滚动 1.15 秒，行动画从 0.30 秒（约 26%）就起步，
                        -- 两条动画大部分时间并行，衔接更紧
                        local startAt = 0.28 + (i - 1) * 0.055
                        task.delay(startAt, function()
                            if self.Destroyed or UI.IsStale() then return end
                            -- 滑回原位
                            TweenService:Create(w, TweenInfo.new(0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                                Position = basePos,
                                BackgroundTransparency = baseT,
                            }):Play()
                            -- 内容一起淡入
                            for _, p2 in ipairs(parts) do
                                pcall(function()
                                    TweenService:Create(p2.obj, TweenInfo.new(0.32, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                        [p2.prop] = p2.base,
                                    }):Play()
                                end)
                            end

                            -- 这一行播完就恢复交互
                            task.delay(0.34, function()
                                if self.Destroyed then return end
                                setRowActive(w, true)
                                -- 这一行播完就允许悬停，不用等别的行
                                pcall(function() w:SetAttribute("__introBusy", false) end)
                            end)
                        end)
                    end)
                end

                -- 兜底保险：正常情况下上面已经解除，这里只防止某行没跑到
                task.delay(0.28 + maxRows * 0.055 + 0.40, function()
                    if self.Destroyed then return end
                    for i = 1, maxRows do
                        if rows[i] then
                            setRowActive(rows[i], true)
                            pcall(function() rows[i]:SetAttribute("__introBusy", false) end)
                        end
                    end
                end)
            end)

        end)
    end)
end

function Window:_ContentParts()
    -- 记录原始透明度，动画结束后要还原（List 本身是透明的，不能改成 0）
    local parts = {}
    local function add(w)
        if not w then return end
        if w:GetAttribute("__basePos") == nil then
            w:SetAttribute("__basePos", w.Position)
        end
        if w:GetAttribute("__baseTrans") == nil then
            w:SetAttribute("__baseTrans", w.BackgroundTransparency)
        end
        table.insert(parts, w)
    end
    add(self.TabBar)
    add(self.List)
    return parts
end

-- 关闭面板后第一次，指示顶栏按钮的位置
-- 纯装饰，Active=false 不拦截任何输入
function Window:_ShowButtonGuide()
    if not self.TopbarButton or self.GuideShown then return end

    local btn = self.TopbarButton

    -- 等按钮位置稳定
    local waited = 0
    while waited < 1.0 do
        task.wait(0.1)
        waited = waited + 0.1
        if btn and btn.Parent and btn.AbsoluteSize.X > 0 then break end
    end
    if not btn or not btn.Parent then return end

    -- 移动端：按钮在折叠菜单里，位置不可靠，改成中央提示
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    local guideGui = Instance.new("ScreenGui")
    guideGui.Name = "CDMUIGuide"
    guideGui.DisplayOrder = 999
    -- 与 self.Gui 保持一致（false），坐标系天然对齐
    guideGui.IgnoreGuiInset = false
    guideGui.ResetOnSpawn = false
    guideGui.Enabled = true
    pcall(function() guideGui.Parent = CoreGui end)
    if not guideGui.Parent then
        pcall(function()
            guideGui.Parent = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        end)
    end
    if not guideGui.Parent then return end
    self.GuideShown = true
    self._guideGui = guideGui

    -- 光圈跟随按钮位置（每帧更新，处理按钮被挤后移的情况）
    local ring = mk("Frame", {
        Name = "Ring",
        Size = UDim2.fromOffset(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 201,
        Active = false,
    }, guideGui)
    local ringStroke = mk("UIStroke", {
        Color = T.accent,
        Thickness = 2,
        Transparency = 1,
    }, ring)
    corner(ring, 999)

    local pulse = mk("Frame", {
        Name = "Pulse",
        Size = UDim2.fromOffset(1, 1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = T.accent,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 200,
        Active = false,
    }, guideGui)
    corner(pulse, 999)

    local tip = mk("TextLabel", {
        Name = "Tip",
        Size = UDim2.fromOffset(IS_MOBILE and 160 or 180, IS_MOBILE and 26 or 30),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundTransparency = 0.3,
        BackgroundColor3 = T.panel,
        Text = "点击这里打开",
        TextColor3 = T.text,
        Font = FONT_BOLD,
        TextSize = LAYOUT.rowDesc + 2,
        TextStrokeTransparency = 0.4,
        TextTransparency = 1,
        ZIndex = 202,
        Active = false,
    }, guideGui)
    corner(tip, 4)

    -- 指向按钮的箭头（贴在提示框上方）
    local arrow = mk("TextLabel", {
        Name = "Arrow",
        Size = UDim2.fromOffset(28, 22),
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Text = "▲",
        TextColor3 = T.accent,
        Font = FONT_BOLD,
        TextSize = 20,
        TextStrokeTransparency = 0.4,
        TextTransparency = 1,
        Rotation = 0,
        ZIndex = 202,
        Active = false,
    }, guideGui)

    -- 同步位置到按钮
    local bouncing = true
    local bounceStart = tick()
    local BOUNCE_PERIOD = IS_MOBILE and 0.70 or 0.62   -- 弹跳周期
    local BOUNCE_UP = IS_MOBILE and 11 or 14   -- 弹跳高度

    -- 用缓动曲线算偏移，sync 每帧读它
    local function bounceOffset()
        if not bouncing then return 0 end
        local phase = ((tick() - bounceStart) % BOUNCE_PERIOD) / BOUNCE_PERIOD

        -- 0.00~0.18 快速上升
        -- 0.18~0.24 顶点停顿
        -- 0.24~0.55 落回（带一次小回弹）
        -- 0.55~1.00 静止
        if phase < 0.22 then
            local p = phase / 0.22
            return BOUNCE_UP * (1 - (1 - p) * (1 - p))   -- ease-out 上冲
        elseif phase < 0.30 then
            return BOUNCE_UP
        elseif phase < 0.72 then
            local p = (phase - 0.30) / 0.42
            local base = BOUNCE_UP * (1 - p) * (1 - p)
            local bump = math.sin(p * math.pi * 2) * BOUNCE_UP * 0.14
            return math.max(0, base + bump)
        end
        return 0
    end

    local function sync()
        if not guideGui.Parent then return end

        -- 移动端：不跟按钮，固定顶部中央提示点击左上角
        if isMobile then
            local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
            ring.Position = UDim2.fromOffset(vp.X / 2, 90)
            pulse.Position = UDim2.fromOffset(vp.X / 2, 90)
            pulse.Size = UDim2.fromOffset(0, 0)
            tip.AnchorPoint = Vector2.new(0.5, 0)
            tip.Text = "点左上角 ≡ 打开菜单"
            arrow.AnchorPoint = Vector2.new(0.5, 1)
            arrow.Rotation = 0
            arrow:SetAttribute("__bx", vp.X / 2)
            arrow:SetAttribute("__by", 106)
            tip:SetAttribute("__bx", vp.X / 2)
            tip:SetAttribute("__by", 108)
            local off0 = bounceOffset()
            arrow.Position = UDim2.fromOffset(vp.X / 2, 106 - off0)
            tip.Position = UDim2.fromOffset(vp.X / 2, 108 - off0)
            return
        end

        if not btn or not btn.Parent then return end
        local sz = btn.AbsoluteSize
        if sz.X <= 0 then return end

        -- ===== 自适应：不写死任何数值，全部运行时探测 =====

        -- 1) 顶栏高度：优先 GuiService，拿不到就取 max(视口高 * 0.06, 36)
        local TOPBAR_H = nil
        pcall(function()
            local ins = GuiService:GetGuiInset()
            if ins and ins.Y and ins.Y > 0 then TOPBAR_H = ins.Y end
        end)
        if not TOPBAR_H then
            local vpY = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.Y) or 720
            TOPBAR_H = math.max(36, math.floor(vpY * 0.06))
        end

        -- 2) 按钮 x：AbsolutePosition.X 是准的
        -- 3) 按钮 y：顶栏内垂直居中
        -- 直接用按钮的 AbsolutePosition 求中心，不做任何 inset 补偿。
        -- 实测：ScreenGui(IgnoreGuiInset=false) 与 TopbarStandard 的坐标系一致，
        -- 额外加 inset 会导致重复偏移。
        local cx = btn.AbsolutePosition.X + sz.X / 2
        local cy = btn.AbsolutePosition.Y + sz.Y / 2

        -- 4) 兜底：如果按钮 x 超出视口（极端情况），钳制回屏幕内
        local vpX = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X) or 1280
        cx = math.clamp(cx, sz.X / 2 + 8, vpX - sz.X / 2 - 8)

        -- 光圈/脉冲每帧强制对齐按钮中心（脉冲的放大靠 UIScale，不改 Size）
        ring.Position = UDim2.fromOffset(cx, cy)
        ring.Size = UDim2.fromOffset(sz.X, sz.Y)
        pulse.Position = UDim2.fromOffset(cx, cy)
        pulse.Size = UDim2.fromOffset(sz.X, sz.Y)

        -- 按钮底部 = 中心 + 半高
        local below = cy + sz.Y / 2 + 4
        if below > 0 then
            arrow.AnchorPoint = Vector2.new(0.5, 1)
            arrow.Rotation = 0
            tip.AnchorPoint = Vector2.new(0.5, 0)
            arrow:SetAttribute("__bx", cx)
            arrow:SetAttribute("__by", below + 20)
            tip:SetAttribute("__bx", cx)
            tip:SetAttribute("__by", below + 22)
        else
            arrow.AnchorPoint = Vector2.new(0.5, 0)
            arrow.Rotation = 180
            tip.AnchorPoint = Vector2.new(0.5, 1)
            arrow:SetAttribute("__bx", cx)
            arrow:SetAttribute("__by", pos.Y + oy - 16)
            tip:SetAttribute("__bx", cx)
            tip:SetAttribute("__by", pos.Y + oy - 18)
        end

        -- 再按基准 + 弹跳偏移应用位置
        local ax = arrow:GetAttribute("__bx")
        local ay = arrow:GetAttribute("__by")
        local tx = tip:GetAttribute("__bx")
        local ty = tip:GetAttribute("__by")
        local off = bounceOffset()
        if ax and ay then
            arrow.Position = UDim2.fromOffset(ax, ay - off)
        end
        if tx and ty then
            tip.Position = UDim2.fromOffset(tx, ty - off)
        end
    end

    sync()
    local syncConn = RunService.Heartbeat:Connect(function()
        pcall(sync)
    end)

    -- 箭头 + 文字向上弹跳，强化指向感

    -- 主光圈：脉冲式（每次脉冲重新亮起再淡出）
    local ringScale = mk("UIScale", { Scale = 1 }, ring)
    ringStroke.Transparency = 1

    -- 文字的出现时间线
    local TIP_START = 0.16
    local TIP_BOUNCES = 3        -- 文字多弹几下
    local BOUNCE_STEP = 0.28

    local finished = false
    local pulseActive = true
    local activeTweens = {}

    -- 脉冲
    local function doPulse(offset)
        task.delay(offset, function()
            if not guideGui.Parent or finished or not pulseActive then return end
            sync()

            ringScale.Scale = 1
            ringStroke.Transparency = 0.15
            local t1 = Anim.to(ringScale, { Scale = 1.55 }, 0.6,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local t2 = Anim.to(ringStroke, { Transparency = 1 }, 0.6,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if t1 then table.insert(activeTweens, t1) end
            if t2 then table.insert(activeTweens, t2) end
        end)
    end

    -- 脉冲循环：持续到结束，避免"光圈早消失、文字还在"的割裂感
    task.spawn(function()
        local wait0 = 0.05
        local idx = 0
        while not finished and guideGui.Parent and idx < 8 do
            idx = idx + 1
            doPulse(wait0)
            task.wait(0.63)
        end
    end)

    -- 文字淡入
    task.delay(TIP_START, function()
        if tip.Parent then
            Anim.to(tip, { TextTransparency = 0 }, 0.24,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            Anim.to(arrow, { TextTransparency = 0 }, 0.24,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    end)

    -- 结束：光圈和文字同时淡出
    local function fadeOutAll()
        if finished then return end
        finished = true
        if syncConn then pcall(function() syncConn:Disconnect() end) end
        bouncing = false

        -- 关键：先停掉所有脉冲动画和正在跑的补间，避免继续改 ringStroke
        pulseActive = false
        -- 停掉当前正在跑的补间
        for _, tw in ipairs(activeTweens) do
            pcall(function() tw:Cancel() end)
        end
        activeTweens = {}

        local D = 0.38   -- 统一时长

        -- 光圈：从当前透明度继续淡到 1（不突然变亮，保持脉冲的余韵）
        pcall(function()
            Anim.to(ringStroke, { Transparency = 1 }, D,
                Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            Anim.to(ringScale, { Scale = 1.25 }, D,
                Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end)
        -- 文字 + 箭头 + 背景
        pcall(function()
            Anim.to(tip, { TextTransparency = 1, BackgroundTransparency = 1 }, D,
                Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            Anim.to(arrow, { TextTransparency = 1 }, D,
                Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        end)

        task.delay(D + 0.02, function()
            if guideGui then pcall(function() guideGui:Destroy() end) end
        end)
    end

    -- 文字弹跳：多弹几下才停
    task.delay(TIP_START + 0.3, function()
        local n = 0
        while not finished and n < TIP_BOUNCES and guideGui.Parent do
            task.wait(BOUNCE_STEP)
            n = n + 1
        end
    end)

    -- 不再因为点击而提前中断，让它自然播完
    local endConn = nil

    -- 正常结束：停留 5 秒
    task.delay(5.0, function()
        if endConn then pcall(function() endConn:Disconnect() end) end
        fadeOutAll()
    end)

end

-- 解锁鼠标（记录原状态；游戏每帧可能强制锁定，所以持续覆盖）
-- 方案二：拦截写入。游戏想把 MouseBehavior 改回锁定，这里直接改成 Default
-- 全局唯一的鼠标 hook 状态，频繁重载时不会叠加
_G._CDMUIMouseHook = _G._CDMUIMouseHook or {
    installed = false,
    origNewIndex = nil,
    target = nil,          -- 目标 MouseBehavior（nil = 不干预）
    refCount = 0,          -- 有多少个窗口在用它
}

function Window:_HardLockMouse(on)
    local H = _G._CDMUIMouseHook
    if on then
        H.refCount = H.refCount + 1
        self._mouseHooked = true
        H.target = self.Visible and Enum.MouseBehavior.Default or nil

        if H.installed then return true end

        local ok = pcall(function()
            local mt = getrawmetatable(game)
            if not mt or mt.__newindex == nil then return end
            local old = mt.__newindex
            H.origNewIndex = old
            setreadonly(mt, false)
            mt.__newindex = newcclosure(function(obj, key, value)
                -- 只拦 MouseBehavior，其它一律透传
                if obj == UserInputService and key == "MouseBehavior" then
                    local want = H.target
                    if want ~= nil then
                        return old(obj, key, want)
                    end
                end
                return old(obj, key, value)
            end)
            setreadonly(mt, true)
            H.installed = true
        end)
        return ok
    else
        self._mouseHooked = false
        H.refCount = math.max(0, H.refCount - 1)
        if H.refCount > 0 then return end

        -- 最后一个使用者卸掉 hook，完全还原游戏原本的 __newindex
        if H.installed and H.origNewIndex then
            pcall(function()
                local mt = getrawmetatable(game)
                if not mt then return end
                setreadonly(mt, false)
                mt.__newindex = H.origNewIndex
                setreadonly(mt, true)
            end)
        end
        H.installed = false
        H.origNewIndex = nil
        H.target = nil
    end
end

function Window:_UnlockMouse()
    if not self.AutoUnlockMouse then return end

    -- 只在「第一次」打开面板时记录原始状态；
    -- 重复打开不覆盖，否则会把解锁态记成原始态
    if self._savedMouseBehavior == nil and not self._mouseEverOpened then
        pcall(function()
            self._savedMouseBehavior = UserInputService.MouseBehavior
            self._savedMouseIcon = UserInputService.MouseIconEnabled
        end)
    end
    self._mouseEverOpened = true

    -- 游戏每帧强推自己的 MouseBehavior，必须靠 hook 才能稳住
    _G._CDMUIMouseHook.target = Enum.MouseBehavior.Default
    if not self._mouseHooked then self:_HardLockMouse(true) end

    if self._mouseLoop then return end
    self._mouseLoop = true

    -- 方案一：每帧写 Default；连写几次都被改回去就切方案二
    task.spawn(function()
        local fails = 0
        while self._mouseLoop and not self.Destroyed do
            if self.Visible then
                pcall(function()
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                    UserInputService.MouseIconEnabled = true
                end)

                task.wait(0.05)

                -- hook 已经把目标固定住了，这里只需要保证状态对
                if self.Visible then
                    self._mouseTarget = Enum.MouseBehavior.Default
                end
            else
                fails = 0
            end
            task.wait(0.02)
        end
        if self._mouseHooked then self:_HardLockMouse(false) end
        self._mouseLoop = false
    end)
end

-- 恢复鼠标
--   _HardLockMouse 会劫持全局 __newindex，卸掉之后游戏不会再主动把
--   MouseBehavior 设回去，所以这里必须主动还原，否则关面板后鼠标会一直是解锁的
function Window:_RestoreMouse()
    self._mouseLoop = false

    -- 恢复成「打开面板之前」的状态，而不是强制锁回
    local want = self._savedMouseBehavior
    if want == nil then
        -- 没记录过就什么都不做，交给游戏自己管
        if self._mouseHooked then
            self._mouseTarget = nil
        end
        return
    end
    _G._CDMUIMouseHook.target = want

    -- hook 只在「有人写入」时才生效，所以这里自己写一次把它顶上去，
    -- 再连写几帧防止游戏下一帧又盖回来
    task.spawn(function()
        local H = _G._CDMUIMouseHook
        for i = 1, 30 do
            -- 中途又被打开 / 被销毁 / 被别人接管，立刻收手
            if self.Destroyed or self.Visible then break end
            if H.target ~= want then break end

            pcall(function()
                UserInputService.MouseBehavior = want
            end)
            local ok, cur = pcall(function() return UserInputService.MouseBehavior end)
            if ok and cur == want and i >= 3 then break end
            task.wait(0.03)
        end
        -- 图标也恢复
        if self._savedMouseIcon ~= nil then
            pcall(function()
                UserInputService.MouseIconEnabled = self._savedMouseIcon
            end)
        end
    end)
end

function Window:SetVisible(visible, instant)
    if self.Destroyed then return end
    -- 加载动画进行中，外部关闭请求一律忽略
    if self.Busy and not instant then return end

    if not instant and self.Visible ~= (visible and true or false) then
        playClick()
    end

    self.Visible = visible and true or false
    local panel = self.Panel

    if self.TopbarSetActive then
        pcall(self.TopbarSetActive, self.Visible)
    end

    local BASE_TRANS = 0.05

    -- 面板里的内容行（Tab 栏 + 滚动区）
    local function contentParts()
        local parts = {}
        if self.TabBar then table.insert(parts, self.TabBar) end
        if self.List then table.insert(parts, self.List) end
        return parts
    end

    if self.Visible then
        self.Gui.Enabled = true
        -- 加载动画会把 Panel 藏起来，这里必须恢复
        panel.Visible = true
        -- 恢复尺寸与缩放（关闭动画会把它们缩小）
        panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
        if self.Scale then self.Scale.Scale = self.BaseScale or 1 end

        -- 打开面板时自动解锁鼠标
        self:_UnlockMouse()

        -- 指引不销毁：让它自己播完，期间面板照常可用。
        -- 它 Active=false，不会拦截任何点击。
        local okc, containers = pcall(function()
            return { CoreGui, Players.LocalPlayer:FindFirstChildOfClass("PlayerGui") }
        end)
        if okc then
            for _, container in ipairs(containers) do
                if container then
                    local g = container:FindFirstChild("CDMUIGuide")
                    if g then pcall(function() g:Destroy() end) end
                end
            end
        end

        if instant then
            panel.Position = UDim2.new(0.5, 0, 0.5, 10)
            panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
            panel.BackgroundTransparency = BASE_TRANS
            if self.Scale then self.Scale.Scale = self.BaseScale or 1 end
            for _, w in ipairs(contentParts()) do
                local base = w:GetAttribute("__basePos")
                if base then w.Position = base end
                w.BackgroundTransparency = w:GetAttribute("__baseTrans") or 0
            end
            self.FirstShow = false
            return
        end

        -- 第一次显示：完整入场（弹性放大 + 内容依次滑入）
        -- 之后：快速浮现，不拖沓
        local isFirst = self.FirstShow
        self.FirstShow = false

        if isFirst then
            -- 首帧：完全收起到中心，透明
            panel.Position = UDim2.new(0.5, 0, 0.5, 24)
            panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
            panel.BackgroundTransparency = 0.4
            if self.Scale then self.Scale.Scale = (self.BaseScale or 1) * 0.82 end

            -- 内容先藏起来
            local parts0 = contentParts()
            for _, w in ipairs(parts0) do
                if not w:GetAttribute("__basePos") then
                    w:SetAttribute("__basePos", w.Position)
                end
                local base = w:GetAttribute("__basePos")
                w.Position = UDim2.new(base.X.Scale, base.X.Offset,
                                       base.Y.Scale, base.Y.Offset + 20)
                w.BackgroundTransparency = 1
            end

            -- 面板：上浮 + 淡入 + 弹性放大
            Anim.to(panel, {
                Position = UDim2.new(0.5, 0, 0.5, 10),
                BackgroundTransparency = BASE_TRANS,
            }, 0.38, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

            if self.Scale then
                Anim.to(self.Scale, { Scale = 1 }, 0.50,
                    Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end

            -- 内容：分三波滑入，有节奏感
            local parts = contentParts()
            local delay = 0.14
            for idx, w in ipairs(parts) do
                local base = w:GetAttribute("__basePos")
                Anim.to(w, {
                    Position = base,
                    BackgroundTransparency = w:GetAttribute("__baseTrans") or 0,
                }, 0.34, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, delay)
                delay = delay + 0.08
            end
            return
        end

        -- 起点：稍微缩小、稍微下移
        panel.Position = UDim2.new(0.5, 0, 0.5, 10)
        panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
        panel.BackgroundTransparency = BASE_TRANS
        if self.Scale then self.Scale.Scale = (self.BaseScale or 1) * 0.88 end

        -- 面板：弹性放大（Back 过冲）
        Anim.to(panel, { Position = UDim2.new(0.5, 0, 0.5, 10) }, 0.34,
            Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        if self.Scale then Anim.to(self.Scale, { Scale = self.BaseScale or 1 }, 0.42,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out) end

        -- 内容：上移 + 淡入，依次错开
        local parts = contentParts()
        local delay = 0.08
        for _, w in ipairs(parts) do
            if not w:GetAttribute("__basePos") then
                w:SetAttribute("__basePos", w.Position)
            end
            local base = w:GetAttribute("__basePos")
            w.Position = UDim2.new(base.X.Scale, base.X.Offset,
                                   base.Y.Scale, base.Y.Offset + 14)
            w.BackgroundTransparency = math.min(1, (w:GetAttribute("__baseTrans") or 0) + 0.6)

            Anim.to(w, {
                Position = base,
                BackgroundTransparency = w:GetAttribute("__baseTrans") or 0,
            }, 0.30, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, delay)
            delay = delay + 0.06
        end

    else
        -- 恢复鼠标状态
        self:_RestoreMouse()

        if instant then
            self.Gui.Enabled = false
            return
        end

        -- 收起：缩小 + 下沉 + 淡出
        local parts = contentParts()
        for i, w in ipairs(parts) do
            local base = w:GetAttribute("__basePos") or w.Position
            Anim.to(w, {
                Position = UDim2.new(base.X.Scale, base.X.Offset,
                                     base.Y.Scale, base.Y.Offset + 8),
                BackgroundTransparency = 1,
            }, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In,
                (i - 1) * 0.02)
        end

        if self.Scale then
            Anim.to(self.Scale, { Scale = (self.BaseScale or 1) * 0.94 }, 0.16,
                Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        end
        Anim.to(panel, {
            Position = UDim2.new(0.5, 0, 0.5, 8),
        }, 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        task.delay(0.17, function()
            if not self.Visible and self.Gui then
                self.Gui.Enabled = false
                if self.Panel then self.Panel.Visible = false end
                -- 有顶栏按钮，且不是点按钮关闭 → 指引按钮位置
                local byButton = self._closedByTopbar
                self._closedByTopbar = nil
                if not byButton and self.TopbarButton and not self.GuideShown then
                    task.spawn(function()
                        pcall(function() self:_ShowButtonGuide() end)
                    end)
                end
                self.Panel.Position = UDim2.new(0.5, 0, 0.5, 10)
                self.Panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
                if self.Scale then self.Scale.Scale = self.BaseScale or 1 end
                for _, w in ipairs(contentParts()) do
                    local base = w:GetAttribute("__basePos")
                    if base then w.Position = base end
                    w.BackgroundTransparency = 0
                end
            end
        end)
    end
end
function Window:Toggle()
    self:SetVisible(not self.Visible)
end

function Window:Tab(name)
    local tab = setmetatable({}, Tab)
    tab.Window = self
    tab.Name = name
    tab.Items = 0
    tab.Rows = {}
    tab.Widgets = {}
    tab.Container = self.List

    table.insert(self.Tabs, tab)
    local tabIndex = #self.Tabs

    -- Tab 按钮：等分整行，不依赖固定宽度（Tab 数量变化也不会错位）
    local btn = mk("TextButton", {
        Name = "Tab_" .. name,
        Size = UDim2.new(0, 88, 1, 0),
        BackgroundColor3 = T.tabIdle,
        Text = name,
        TextColor3 = T.tabText,
        Font = FONT_BOLD,
        TextSize = LAYOUT.tabTextSize,
        Active = true,
        AutoButtonColor = false,
        LayoutOrder = tabIndex,
        ZIndex = 4,
    }, self.TabBar)
    corner(btn, 6)

    tab.Button = btn

    btn.MouseEnter:Connect(function()
        -- 入场动画期间不响应悬停，避免提前亮起
        if self._tabAnimating then return end
        if self.TabIndex ~= tabIndex then
            tween(btn, 0.12, { BackgroundColor3 = T.rowHover })
        end
    end)
    btn.MouseLeave:Connect(function()
        if self._tabAnimating then return end
        if self.TabIndex ~= tabIndex then
            tween(btn, 0.12, { BackgroundColor3 = T.tabIdle })
        end
    end)
    -- Tab 点击：Activated 只在真正点击时触发，拖动不会误触
    table.insert(self.Connections, btn.Activated:Connect(function()
        local blockUntil = getgenv()._CDMUITabDragBlock
        if blockUntil and os.clock() < blockUntil then return end
        playClick()
        self:SelectTab(tabIndex)
    end))

    self:LayoutTabs()

    -- 布局就绪后重算一次（AbsoluteSize 在创建瞬间可能还是 0）
    task.defer(function()
        if not self.Destroyed then self:LayoutTabs() end
    end)

    if tabIndex == 1 then
        self:SelectTab(1, true)
    end
    return tab
end

-- Tab 宽度：按 Tab 数量平分整行，铺满且不换行
--   Tab 栏宽 = 面板宽 - padX*2，间距 = 6
--   每个 Tab = (栏宽 - 间距*(n-1)) / n
function Window:LayoutTabs()
    local n = #self.Tabs
    if n == 0 then return end

    local GAP = 7
    -- AbsoluteSize 是缩放后的像素；尺寸设置走未缩放坐标系，所以要除掉 UIScale
    local sc = (self.Scale and self.Scale.Scale) or 1
    if sc <= 0 then sc = 1 end
    local barW = self.TabBar.AbsoluteSize.X / sc
    if barW <= 10 then
        barW = PANEL_W - LAYOUT.padX * 2
    end

    -- 每个 Tab 按文字长度给足宽度，放不下就横向滚动
    local MIN_W = IS_MOBILE and 140 or 124
    local PAD_W = 40
    local widths, total = {}, 0
    for i, tb in ipairs(self.Tabs) do
        local label = tostring(tb.Name or "")
        local len = utf8.len(label) or #label
        local w = math.max(MIN_W, len * (IS_MOBILE and 17 or 15) + PAD_W)
        widths[i] = w
        total = total + w
    end
    total = total + GAP * (n - 1)

    local each = nil
    if total < barW then
        each = math.floor((barW - GAP * (n - 1)) / n)
    end

    for i, tb in ipairs(self.Tabs) do
        local w = each or widths[i]
        tb.Button.Size = UDim2.new(0, w, 1, -5)
        -- 入场动画期间不要抢位置，否则动画会被打断
        if not self._tabAnimating then
            tb.Button.Position = UDim2.new(0, (i - 1) * (w + GAP), 0, 0)
        end
        tb.Button.TextSize = LAYOUT.tabTextSize
        tb.Button.TextTruncate = Enum.TextTruncate.None
        tb.Button.LayoutOrder = i
    end

    self._tabBarW = barW
    self._tabEachW = each or MIN_W

    if self.TabBar then
        if total > barW then
            -- 画布正好等于最后一个 Tab 的右边缘，滚到头就是贴边，不留空白
            local lastBtn = self.Tabs[n].Button
            local contentRight = lastBtn.Position.X.Offset + lastBtn.Size.X.Offset
            -- 实测关系：maxX = CanvasSize * sc - 栏宽
            -- 要让 maxX 刚好等于「最后一个 Tab 滚到贴边所需的量」，
            --   needScroll 单位是未缩放坐标，maxX 也是未缩放
            --   => CanvasSize = (needScroll * sc + 栏宽) / sc
            local sc2 = (self.Scale and self.Scale.Scale) or 1
            if sc2 <= 0 then sc2 = 1 end
            local barW2 = self.TabBar.AbsoluteSize.X
            -- 实测：maxX = CanvasSize * sc - 栏宽
            -- 要让 maxX 等于 contentRight - 栏宽/sc（最后一个刚好贴右）
            --   contentRight * sc - 栏宽 + 栏宽 = contentRight * sc
            -- 直接按 contentRight 走，滚到底正好贴边
            self.TabBar.CanvasSize = UDim2.new(0, contentRight, 0, 0)
            self.TabBar.ScrollingEnabled = true
            -- 入场动画期间别改滚动条，避免最后一下抽搐
            if not self._tabAnimating then
                self.TabBar.ScrollBarThickness = IS_MOBILE and 5 or 3
            else
                self.TabBar.ScrollBarImageTransparency = 1
            end
        else
            self.TabBar.CanvasSize = UDim2.new(0, 0, 0, 0)
            self.TabBar.ScrollingEnabled = false
            self.TabBar.ScrollBarThickness = 0
            self.TabBar.CanvasPosition = Vector2.new(0, 0)
            for _, tbb in ipairs(self.Tabs) do
                tbb.Button.Size = UDim2.new(0, tbb.Button.Size.X.Offset, 1, 0)
            end
        end
    end
end

-- 切 Tab 时把它平滑滚到可视区中间
function Window:_ScrollTabIntoView(index)
    local bar = self.TabBar
    if not bar or not bar.ScrollingEnabled then return end
    local tb = self.Tabs[index]
    if not tb then return end

    local sc = (self.Scale and self.Scale.Scale) or 1
    if sc <= 0 then sc = 1 end

    local btn = tb.Button
    local barW = bar.AbsoluteSize.X
    local viewW = barW / sc - bar.ScrollBarThickness / sc
    -- 实测：maxX = CanvasSize * sc - 栏宽
    local maxX = math.max(0, bar.CanvasSize.X.Offset * sc - barW)

    -- 第一个直接到最左，最后一个直接到最右
    if index <= 1 then
        self:_TweenTabScroll(0)
        return
    end
    if index >= #self.Tabs then
        self:_TweenTabScroll(maxX)
        return
    end

    -- 中间：布局坐标算未缩放滚动量，再乘 sc 换成 CanvasPosition
    local bpos = btn.Position.X.Offset
    local bsize = btn.Size.X.Offset
    local needScroll = bpos + bsize / 2 - viewW / 2
    local target = math.clamp(needScroll, 0, maxX)

    self:_TweenTabScroll(target)
end

-- 平滑滚动到指定 CanvasPosition.X
function Window:_TweenTabScroll(target, onDone)
    local bar = self.TabBar
    if not bar then return end

    local from = bar.CanvasPosition.X
    if math.abs(target - from) < 1 then
        bar.CanvasPosition = Vector2.new(target, 0)
        if onDone then task.defer(onDone) end
        return
    end

    self._tabScrollToken = (self._tabScrollToken or 0) + 1
    local token = self._tabScrollToken
    local t0 = os.clock()

    task.spawn(function()
        while true do
            if self._tabScrollToken ~= token or self.Destroyed then return end
            local a = math.clamp((os.clock() - t0) / 0.26, 0, 1)
            a = 1 - (1 - a) ^ 3
            pcall(function()
                bar.CanvasPosition = Vector2.new(from + (target - from) * a, 0)
            end)
            if a >= 1 then
                if onDone then task.defer(onDone) end
                return
            end
            RunService.RenderStepped:Wait()
        end
    end)
end

-- ============================================================
-- Tab 切换：整体朝滚动区顶部收 / 从顶部展开
-- ============================================================
-- 约束：
--   1) 子项在 ScrollingFrame + UIListLayout 下，只能用 Size 动画（Position 会被布局覆盖）
--   2) 高度变化会重算 CanvasSize，若 CanvasPosition=0 则内容始终贴着顶部，观感正确
--   3) 不要手动冻结 AutomaticCanvasSize，容易算出错误的画布高度
--   4) 滚动位置只在「旧页已完全收起」的瞬间归零，避免可见跳变
-- 平滑滚动列表到顶部：从当前 CanvasPosition 缓动到 0
function Window:_ScrollToTop(duration)
    local list = self.List
    if not list then return end

    -- 已经在顶部就不折腾
    if list.CanvasPosition.Y <= 1 then return end

    local startY = list.CanvasPosition.Y
    local dur = duration or 0.34
    local t0 = tick()

    -- 取消上一次滚动
    if self._scrollConn then
        pcall(function() self._scrollConn:Disconnect() end)
        self._scrollConn = nil
    end

    self._scrollConn = RunService.RenderStepped:Connect(function()
        local p = math.clamp((tick() - t0) / dur, 0, 1)
        -- ease-out cubic，收尾更自然
        local eased = 1 - (1 - p) ^ 3
        if list and list.Parent then
            list.CanvasPosition = Vector2.new(list.CanvasPosition.X, startY * (1 - eased))
        end
        if p >= 1 then
            if self._scrollConn then
                pcall(function() self._scrollConn:Disconnect() end)
                self._scrollConn = nil
            end
        end
    end)
end

function Window:SelectTab(index, instant)
    local tab = self.Tabs[index]
    if not tab then return end
    local last = self.TabIndex
    self.TabIndex = index

    -- Tab 宽度重算，避免被别处覆盖
    self:LayoutTabs()

    -- Tab 按钮状态
    for i, t in ipairs(self.Tabs) do
        local active = (i == index)
        tween(t.Button, 0.18, {
            BackgroundColor3 = active and T.tabActive or T.tabIdle,
            TextColor3 = active and T.tabTextOn or T.tabText,
        }, Enum.EasingStyle.Quad)
    end

    -- 让选中的 Tab 平滑滚到可视区中间
    if self._ScrollTabIntoView then
        task.defer(function()
            if self.Destroyed then return end
            pcall(function() self:_ScrollTabIntoView(index) end)
        end)
    end

    -- 记录行原始高度
    local function rememberBase(w)
        if not w:GetAttribute("__baseH") or w:GetAttribute("__baseH") <= 0 then
            w:SetAttribute("__baseH", w.Size.Y.Offset)
        end
        return w:GetAttribute("__baseH")
    end

    -- 整页切换到 显示/隐藏 状态
    local function setPage(t, visible)
        for _, w in ipairs(t.Widgets) do
            -- BodyChildRow 自己管理显隐，不能被切页重置
            if w and w.Parent and w.Name ~= "ChildRow" and w.Name ~= "BodyChildRow" then
                local base = rememberBase(w)
                w.Visible = visible
                w.Size = UDim2.new(w.Size.X.Scale, w.Size.X.Offset, 0, visible and base or 0)
                if w.Name == "Row" then
                    w.BackgroundTransparency = 0.15
                end
            end
        end
        -- 子行：当前页按展开状态恢复，非当前页一律立即隐藏（不占位）
        for _, r in ipairs(self.ExpandRestorers) do
            if r.tab == t and r.apply then
                if visible then
                    r.apply(r.get() == true, false)
                else
                    r.apply(false, false)
                end
            end
        end

        -- 兜底：再扫一遍 BodyChildRow，确保 Visible 跟展开状态一致
        for _, w in ipairs(t.Widgets) do
            if w and w.Parent and w.Name == "BodyChildRow" then
                local ek = w:GetAttribute("__expandKey")
                local open = (ek ~= nil) and (self.State[ek] == true)
                local h = w:GetAttribute("__h") or 0
                if visible == true and open then
                    w.Size = UDim2.new(w.Size.X.Scale, w.Size.X.Offset, 0, h)
                    w.Visible = true
                else
                    w.Size = UDim2.new(w.Size.X.Scale, w.Size.X.Offset, 0, 0)
                    w.Visible = false
                end
            end
        end
    end

    local oldTab = self.Tabs[last]

    -- 首次 / 瞬间切换：直接完成
    if instant or last == index or not oldTab then
        local sameTab = (last == index)
        for i, t in ipairs(self.Tabs) do
            setPage(t, i == index)
        end

        if sameTab and not instant then
            -- 重复点同一个 Tab：平滑滚回顶部，别瞬移
            self:_ScrollToTop(0.34)
        else
            self.List.CanvasPosition = Vector2.new(0, 0)
        end
        return
    end

    -- 提速：收起 0.12s / 展开 0.18s，错开更小，减少等待感
    local COLLAPSE_TIME = 0.10
    local EXPAND_TIME = 0.16
    local STAGGER_OUT = 0.006
    local STAGGER_IN = 0.010

    -- 收集旧页可见行
    local oldRows = {}
    for _, w in ipairs(oldTab.Widgets) do
        if w and w.Parent and w.Visible and w:IsA("Frame") and w.Name ~= "BodyChildRow" then
            rememberBase(w)
            table.insert(oldRows, w)
        end
    end

    -- 换页动画：滚回顶部 + 收起 + 展开，三者重叠进行。
    -- 分得太开会有"等一下、再等一下"的顿挫感，所以这里让它们同时跑。
    local SCROLL_TIME = 0.20
    local collapseTotal = COLLAPSE_TIME + #oldRows * STAGGER_OUT

    -- ① 滚回顶部（同时进行）
    self:_ScrollToTop(SCROLL_TIME)

    -- ② 收起几乎同时开始，不等滚动停
    task.delay(0.02, function()
        if self.Destroyed or self.TabIndex ~= index then return end

        for idx, w in ipairs(oldRows) do
            local fromBottom = (#oldRows - idx) * STAGGER_OUT
            Anim.to(w, {
                Size = UDim2.new(w.Size.X.Scale, w.Size.X.Offset, 0, 0),
            }, COLLAPSE_TIME, Enum.EasingStyle.Quad, Enum.EasingDirection.In, fromBottom)
        end

        -- ③ 收起过半就开始展开，收尾和起头叠在一起
        task.delay(collapseTotal * 0.55, function()
            if self.Destroyed or self.TabIndex ~= index then return end

            -- 旧页彻底归零并隐藏
            setPage(oldTab, false)

            -- 位置兜底，确保新页从顶部开始
            self.List.CanvasPosition = Vector2.new(0, 0)

        -- 新页：统一走 setPage（和 instant 分支共用同一套逻辑，
        -- 避免「改一处忘另一处」）。先把高度归 0，再由下面的动画撑开。
        setPage(tab, true)

        local newRows = {}
        for _, w in ipairs(tab.Widgets) do
            if w and w.Parent and w.Name ~= "ChildRow" and w.Name ~= "BodyChildRow" then
                local base = rememberBase(w)
                w.Size = UDim2.new(w.Size.X.Scale, w.Size.X.Offset, 0, 0)
                table.insert(newRows, w)
            end
        end

        -- 主行按顺序撑开；展开中的子行紧跟在各自父行之后开始，
        -- 形成「主行 -> 子行」连贯的展开流
        local restorers = {}
        for _, r in ipairs(self.ExpandRestorers) do
            if r.tab == tab then
                table.insert(restorers, r)
            end
        end

        local showDelay = 0
        for idx, w in ipairs(newRows) do
            local base = w:GetAttribute("__baseH") or 0
            Anim.to(w, {
                Size = UDim2.new(w.Size.X.Scale, w.Size.X.Offset, 0, base),
            }, EXPAND_TIME, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, showDelay)

            showDelay = showDelay + STAGGER_IN

            -- 这一行如果有展开项且处于展开状态，让它比主行晚 0.06s 开始撑开
            local title = w:FindFirstChild("Title")
            if title then
                for _, r in ipairs(restorers) do
                    if r.get() == true and r.apply and r.panelRow == w then
                        r.apply(true, true, showDelay + 0.06)
                    end
                end
            end
        end

        -- 展开动画结束后再同步一次折叠状态（此时行高已稳定）
        task.delay(showDelay + EXPAND_TIME + 0.05, function()
            if self.Destroyed or self.TabIndex ~= index then return end
            for _, r in ipairs(restorers) do
                if r.apply and r.get then
                    pcall(r.apply, r.get())
                end
            end
        end)
        end)
    end)
end
function Window:Notify(text, duration)
    if self.Destroyed then return end
    duration = duration or 2.4
    local toast = mk("Frame", {
        Name = "Toast",
        Size = UDim2.new(0, 220, 0, 36),
        Position = UDim2.new(0.5, 110, 1, -90),
        BackgroundColor3 = T.row,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0,
        ZIndex = 40,
    }, self.Panel)
    corner(toast, 6)
    stroke(toast, T.panelStroke, 1, 0.3)

    mk("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        BackgroundTransparency = 1,
        Font = FONT,
        Text = text,
        TextSize = 15,
        TextColor3 = T.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, toast)

    toast.Position = UDim2.new(0.5, 130, 1, -90)
    tween(toast, 0.22, { Position = UDim2.new(0.5, 110, 1, -90) }, Enum.EasingStyle.Quint)
    task.delay(duration, function()
        if not toast or not toast.Parent then return end
        tween(toast, 0.18, {
            Position = UDim2.new(0.5, 130, 1, -90),
            BackgroundTransparency = 1,
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        task.delay(0.22, function()
            if toast then toast:Destroy() end
        end)
    end)
end

-- ============================================================
-- 状态读写
-- 约束：self.State 是唯一数据源；控件显示永远从 State 渲染
--   Set()   -> 写 State + 重绘控件（不触发 Callback）
--   Get()   -> 直接读 State
-- 这样「UI 显示」和「实际逻辑」永远不会漂移
-- ============================================================
function Window:Get(key)
    return self.State[key]
end

-- 查找某 key 对应的控件（跨所有 Tab）
function Window:_FindControl(key)
    for _, tab in ipairs(self.Tabs) do
        local row = tab.Rows and tab.Rows[key]
        if row then return row, tab end
    end
    return nil
end

-- 设置值
--   fireCallback = true（默认）：写 State + 重绘 + 触发 Callback（业务逻辑同步）
--   fireCallback = false       ：写 State + 重绘，不触发 Callback（纯界面同步）
function Window:Set(key, value, fireCallback)
    if fireCallback == nil then fireCallback = true end

    -- 1) 先写 State（即使后续失败，逻辑状态也是对的）
    self.State[key] = value

    -- 2) 重绘控件
    local ctrl = self:_FindControl(key)
    if ctrl and type(ctrl.Set) == "function" then
        local ok, err = pcall(ctrl.Set, ctrl, value, true)
        if not ok then
            warn("[CDMUI] Set(" .. tostring(key) .. ") 重绘失败: " .. tostring(err))
        end
    end

    -- 3) 触发业务回调（可关闭）
    if fireCallback then
        local cb = self.OnToggle
        if type(cb) == "function" then
            UI.safeCall(cb, key, value)
        end
    end

    return value
end

-- 只更新界面，不触发回调（等价于 Set(key, value, false)）
function Window:SetSilent(key, value)
    return self:Set(key, value, false)
end

-- 批量设置（一次性写多个 key）
function Window:SetMany(tbl)
    for k, v in pairs(tbl) do
        self:Set(k, v)
    end
end

-- 把 State 全量同步到控件（重载后恢复界面用）
function Window:RepaintAll()
    for _, tab in ipairs(self.Tabs) do
        for key, ctrl in pairs(tab.Rows or {}) do
            if type(ctrl.Set) == "function" and self.State[key] ~= nil then
                pcall(ctrl.Set, ctrl, self.State[key], true)
            end
        end
    end
end

function Window:Destroy()
    -- 清理切页恢复器，避免重载时泄漏
    self.ExpandRestorers = {}

    -- 从全局登记表移除
    if type(_G._CDMUILiveWindows) == "table" then
        for i = #_G._CDMUILiveWindows, 1, -1 do
            if _G._CDMUILiveWindows[i] == self then
                table.remove(_G._CDMUILiveWindows, i)
            end
        end
    end
    self.Destroyed = true

    -- 断开所有登记的连接
    for _, c in ipairs(self.Connections or {}) do
        pcall(function() c:Disconnect() end)
    end
    self.Connections = {}

    -- 销毁顶栏按钮（它挂在 TopbarStandard 下，不在 self.Gui 子树里）
    if self.TopbarButton then
        pcall(function() self.TopbarButton:Destroy() end)
        self.TopbarButton = nil
    end

    -- 销毁按钮指引（独立 ScreenGui）
    if self._guideGui then
        pcall(function() self._guideGui:Destroy() end)
        self._guideGui = nil
    end

    -- 销毁主面板
    if self.Gui then
        pcall(function() self.Gui:Destroy() end)
        self.Gui = nil
    end
end

-- 行构造
local function baseRow(tab, height)
    local row = mk("Frame", {
        Name = "Row",
        Size = UDim2.new(1, -12, 0, height or ROW_H),
        BackgroundColor3 = T.row,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 4,
        Active = false,
        ClipsDescendants = true,
        LayoutOrder = (tab.Items + 1) * 1000,
        Visible = (tab.Window.TabIndex == #tab.Window.Tabs),
    }, tab.Container)
    corner(row, SIZE.radiusRow)
    tab.Items = tab.Items + 1
    table.insert(tab.Widgets, row)

    -- 悬停高亮：入场动画期间直接忽略，
    -- 否则鼠标提前停在某行上时，那一行会在文字还不透明时就先亮出一块底色
    -- 每行自己的入场标志：播完这一行就立刻允许悬停，
    -- 不用等全部行播完
    row:SetAttribute("__introBusy", false)
    row.MouseEnter:Connect(function()
        if row:GetAttribute("__introBusy") then return end
        tween(row, 0.12, { BackgroundColor3 = T.rowHover, BackgroundTransparency = 0.1 })
    end)
    row.MouseLeave:Connect(function()
        if row:GetAttribute("__introBusy") then return end
        tween(row, 0.12, { BackgroundColor3 = T.row, BackgroundTransparency = 0.15 })
    end)
    return row
end

-- 标题 / 描述：按是否有描述决定垂直位置
--   没有描述 -> 整行垂直居中
--   有描述   -> 标题略上、描述略下，整体在行内居中
local function layoutRowText(row)
    local title = row:FindFirstChild("Title")
    local desc = row:FindFirstChild("Desc")
    if not title then return end

    -- 用行的实际高度算，不用固定偏移，
    -- 行高改了也不会偏
    local rowH = row.Size.Y.Offset
    if rowH <= 0 then rowH = LAYOUT.rowH end

    local titleH = math.floor(LAYOUT.rowTitle * 1.45)
    local descH = math.floor(LAYOUT.rowDesc * 1.45)

    if desc then
        -- 两行：上下段垂直分布，整体居中
        local gap = 2
        local totalH = titleH + gap + descH
        local top = math.max(0, (rowH - totalH) / 2)

        title.Size = UDim2.new(1, -80, 0, titleH)
        title.Position = UDim2.new(0, 12, 0, top)
        title.TextYAlignment = Enum.TextYAlignment.Top

        desc.Size = UDim2.new(1, -80, 0, descH)
        desc.Position = UDim2.new(0, 12, 0, top + titleH + gap)
        desc.TextYAlignment = Enum.TextYAlignment.Top
    else
        -- 单行：整行垂直居中
        title.Size = UDim2.new(1, -80, 1, 0)
        title.Position = UDim2.new(0, 12, 0, 0)
        title.TextYAlignment = Enum.TextYAlignment.Center
    end
end

local function addTitle(row, data, offset)
    mk("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 0, 26),
        Position = UDim2.new(0, 12, 0.5, -20),
        BackgroundTransparency = 1,
        Text = data.Name or data.name or data.Title or data.title or "",
        TextColor3 = T.text,
        Font = FONT_BOLD,
        TextSize = LAYOUT.rowTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 5,
        Active = false,
    }, row)
end

local function addDesc(row, data, y)
    local desc = data.Desc or data.desc or data.Description
    if not desc then
        layoutRowText(row)
        return
    end
    mk("TextLabel", {
        Name = "Desc",
        Size = UDim2.new(1, -80, 0, 22),
        Position = UDim2.new(0, 12, 0.5, 6),
        BackgroundTransparency = 1,
        Text = desc,
        TextColor3 = T.textDim,
        Font = FONT,
        TextSize = LAYOUT.rowDesc,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 5,
        Active = false,
    }, row)
    layoutRowText(row)
end

function Tab:Toggle(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key
    local initial = cfg.Default
    if initial == nil then initial = false end
    self.Window.State[key] = initial

    local ctrl = makeCheckbox(row, LAYOUT.boxSize, -6, function(v)
        self.Window.State[key] = v
        if cfg.Callback then UI.safeCall(cfg.Callback, v) end
    end)
    ctrl.SetSilent(initial)

    registerControl(self, key, ctrl)
    return ctrl
end

-- 行内按钮：标题/描述在左，按钮在右（类似 Toggle 的布局）
-- 整行可点击：和普通行一样的样式，但点击整行触发回调
function Tab:ClickableRow(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    -- 右侧提示箭头（可选）
    if cfg.Arrow then
        mk("TextLabel", {
            Name = "Arrow",
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.new(1, -26, 0.5, -10),
            BackgroundTransparency = 1,
            Text = "›",
            TextColor3 = T.textDim,
            Font = FONT_BOLD,
            TextSize = IS_MOBILE and 20 or 18,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 6,
            Active = false,
        }, row)
    end

    -- 整行做成按钮（覆盖在上层，透明）
    local hit = mk("TextButton", {
        Name = "RowHit",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = " ",              -- 非空文本，确保可点击
        TextTransparency = 1,
        AutoButtonColor = false,
        Selectable = true,
        ZIndex = 25,
        Active = true,
    }, row)

    local title = row:FindFirstChild("Title")
    local desc = row:FindFirstChild("Desc")
    local originalColor = row.BackgroundColor3

    hit.MouseEnter:Connect(function()
        Anim.to(row, { BackgroundColor3 = T.rowHover }, 0.12)
    end)
    hit.MouseLeave:Connect(function()
        Anim.to(row, { BackgroundColor3 = originalColor }, 0.12)
    end)
    hit.MouseButton1Down:Connect(function()
        Anim.to(row, { BackgroundTransparency = 0.05 }, 0.08)
    end)
    hit.MouseButton1Up:Connect(function()
        Anim.to(row, { BackgroundTransparency = 0.15 }, 0.12)
    end)

    local busy = false
    local lastFire = 0
    local function fire()
        -- 防重入 + 防双击（250ms 内只触发一次）
        if busy then return end
        local now = tick()
        if now - lastFire < 0.25 then return end
        lastFire = now
        -- 音效由 bindTap 播放，这里不再调
        if cfg.Callback then UI.safeCall(cfg.Callback) end
    end

    -- 只走 bindTap：它会统一处理音效、位移阈值和错误隔离
    -- 不要再额外连 MouseButton1Click，否则一次点击会触发两遍
    bindTap(hit, fire)

    local ctrl = {
        Frame = row,
        Hit = hit,
        Set = function(newTitle, newDesc, color)
            if title and newTitle then title.Text = tostring(newTitle) end
            if desc and newDesc then
                desc.Text = tostring(newDesc)
                if color then desc.TextColor3 = color end
            end
        end,
        SetBusy = function(on)
            busy = on and true or false
            hit.Active = not busy
        end,
        Get = function()
            return title and title.Text or "", desc and desc.Text or ""
        end,
    }
    if cfg.Key or cfg.key then
        self.Rows[cfg.Key or cfg.key] = ctrl
    end
    return ctrl
end

function Tab:RowButton(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local BW = cfg.Width or 76
    local BH = IS_MOBILE and 34 or 28

    local btn = mk("TextButton", {
        Name = "RowBtn",
        Size = UDim2.fromOffset(BW, BH),
        Position = UDim2.new(1, -(BW + 10), 0.5, -BH / 2),
        BackgroundColor3 = (cfg.Variant == "primary") and T.accent or T.ctrl,
        Text = cfg.Text or cfg.Name or "按钮",
        TextColor3 = (cfg.Variant == "primary") and T.tabTextOn or T.ctrlText,
        Font = FONT_BOLD,
        TextSize = LAYOUT.ctrlText,
        AutoButtonColor = false,
        ZIndex = 20,
        Active = true,
    }, row)
    corner(btn, 5)
    if cfg.Variant ~= "primary" then
        stroke(btn, T.ctrlStroke, 1, 0.4)
    end

    -- 悬停 / 按下反馈
    local baseColor = btn.BackgroundColor3
    btn.MouseEnter:Connect(function()
        Anim.to(btn, { BackgroundColor3 = (cfg.Variant == "primary") and T.accent or T.ctrlHover }, 0.12)
    end)
    btn.MouseLeave:Connect(function()
        Anim.to(btn, { BackgroundColor3 = baseColor }, 0.12)
    end)

    local originalText = btn.Text
    local busy = false
    bindTap(btn, function()
        if busy then return end
        -- 音效由 bindTap 统一播放，这里不要再调
        if cfg.Callback then UI.safeCall(cfg.Callback, btn) end
    end)

    local ctrl = {
        Frame = row,
        Button = btn,
        Set = function(newText)
            if newText then btn.Text = tostring(newText) end
        end,
        SetBusy = function(on)
            busy = on and true or false
            btn.Text = busy and "检测中…" or originalText
            btn.Active = not busy
        end,
        Get = function() return btn.Text end,
    }
    if cfg.Key or cfg.key then
        self.Rows[cfg.Key or cfg.key] = ctrl
    end
    return ctrl
end

function Tab:Label(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    -- 返回带 Set 方法的控件，方便动态更新文字
    local title = row:FindFirstChild("Title")
    local desc = row:FindFirstChild("Desc")
    local ctrl = {
        Frame = row,
        Set = function(newTitle, newDesc, color)
            if title and newTitle then title.Text = tostring(newTitle) end
            if desc and newDesc then desc.Text = tostring(newDesc) end
            if desc and color then desc.TextColor3 = color end
        end,
        Get = function()
            return title and title.Text or "", desc and desc.Text or ""
        end,
    }
    if cfg.Key or cfg.key then
        self.Rows[cfg.Key or cfg.key] = ctrl
    end
    return ctrl
end

-- 展开项：子项作为 List 的兄弟行插入，靠 UIListLayout 自然排版，不会有裁剪/重叠问题
function Tab:Expand(cfg)
    local key = cfg.Key or cfg.key
    local children = cfg.Children or cfg.children or {}

    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    -- 勾选框在最右，箭头在它左边
    -- makeCheckbox(size, rightOffset) 实际布局：
    --   hit 宽 = size + 16，右边缘在 rightOffset
--   box 在 hit 内居中，右边缘 = rightOffset - 8
    local ARROW_W = LAYOUT.arrowSize
    local CHECK_W = 28
    local CHECK_EDGE = 8                       -- 勾选框 hit 距行右
    local CHECK_BOX_RIGHT = CHECK_EDGE + 8     -- box 右边缘距行右 = 16
    local GAP = 12                             -- 箭头与勾选框可见间隙
    -- 箭头右边缘 = box 左边缘 - GAP
    local ARROW_RIGHT_OFFSET = CHECK_BOX_RIGHT + CHECK_W + GAP

    local ctrl
    local arrowOffset = ARROW_RIGHT_OFFSET   -- 默认（有勾选框）
    if cfg.Cycle then
        -- 循环模式：右侧放一个左右切换的按钮，不用勾选框
        local cy = cfg.Cycle
        local opts = cy.Options or {}
        local idx = cy.DefaultIndex or 1
        -- 宽度按最长选项估算，避免文字被挤小
        local widest = 0
        for _, o in ipairs(opts) do
            local len = utf8.len(tostring(o)) or #tostring(o)
            local w = len * (IS_MOBILE and 17 or 15) + 24
            if w > widest then widest = w end
        end
        local CW = math.clamp(widest, IS_MOBILE and 130 or 110, IS_MOBILE and 200 or 170)
        local CH = IS_MOBILE and 34 or 30

        -- 箭头放在循环按钮左侧，间距与其他行一致
        arrowOffset = CW + GAP + 10

        local cycBtn = mk("TextButton", {
            Name = "CycleBtn",
            Size = UDim2.fromOffset(CW, CH),
            Position = UDim2.new(1, -(CW + 10), 0.5, -CH / 2),
            BackgroundColor3 = T.cycleBg,
            Text = tostring(opts[idx] or ""),
            TextColor3 = T.ctrlText,
            Font = FONT_BOLD,
            TextSize = LAYOUT.ctrlText + 1,
            AutoButtonColor = false,
            ZIndex = 20,
            Active = true,
        }, row)
        corner(cycBtn, 4)
        stroke(cycBtn, T.ctrlStroke, 1, 0.4)

        local function apply(newIdx)
            idx = ((newIdx - 1) % #opts) + 1
            cycBtn.Text = tostring(opts[idx] or "")
            self.Window.State[key] = idx
            -- 同样把索引放第一位
            if cy.Callback then UI.safeCall(cy.Callback, idx, opts[idx]) end
        end

        bindTap(cycBtn, function()
            apply(idx + 1)
        end)

        ctrl = {
            Frame = row,
            Set = function(v) if type(v) == "number" then apply(v) end end,
            Get = function() return idx end,
            Cycle = apply,
        }
        self.Window.State[key] = idx
    else
        ctrl = makeCheckbox(row, CHECK_W, -CHECK_EDGE, function(v)
            self.Window.State[key] = v
            if cfg.Callback then UI.safeCall(cfg.Callback, v) end
        end)
        local initial = cfg.Default
        if initial == nil then initial = false end
        ctrl.SetSilent(initial)
        self.Window.State[key] = initial
    end
    registerControl(self, key, ctrl)

    local arrowBtn = mk("TextButton", {
        Name = "Arrow",
        Size = UDim2.fromOffset(ARROW_W, ARROW_W),
        Position = UDim2.new(1, -arrowOffset, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = T.arrowBg,
        Text = "▼",
        TextColor3 = T.arrowText,
        Font = FONT_BOLD,
        TextSize = LAYOUT.arrowText,
        Active = true,
        AutoButtonColor = false,
        ZIndex = 20,
    }, row)
    corner(arrowBtn, SIZE.radius)
    stroke(arrowBtn, T.boxStroke, 1, 0.45)
    arrowBtn.MouseEnter:Connect(function() tween(arrowBtn, 0.1, { BackgroundColor3 = T.arrowHover }) end)
    arrowBtn.MouseLeave:Connect(function() tween(arrowBtn, 0.1, { BackgroundColor3 = T.arrowBg }) end)

    -- 子项行：全部作为 List 的直接子元素，展开时只是显隐，不涉及尺寸计算
    local childRows = {}
    local orderBase = self.Items

    for i, child in ipairs(children) do
        local ckey = child.Key or child.key
        local kind = child.Kind or child.kind

        local ch = mk("Frame", {
            Name = "ChildRow",
            Size = UDim2.new(1, -12, 0, 0),   -- 初始高度 0，展开时再撑开
            BackgroundColor3 = T.rowChild,
            BackgroundTransparency = 0.15,
            BorderSizePixel = 0,
            LayoutOrder = orderBase * 1000 + i,
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 4,
            Active = false,
        }, self.Container)
        corner(ch, SIZE.radius)
        table.insert(self.Widgets, ch)
        table.insert(childRows, ch)

        -- 左侧绿色竖条（原版细节，保留）
        local bar = mk("Frame", {
            Name = "Bar",
            Size = UDim2.new(0, 2, 1, -14),
            Position = UDim2.new(0, 6, 0, 7),
            BackgroundColor3 = T.accentBar,
            BorderSizePixel = 0,
            ZIndex = 6,
        }, ch)
        corner(bar, 1)

        mk("TextLabel", {
            Name = "ChildTitle",
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 16, 0, 0),
            BackgroundTransparency = 1,
            Text = child.Name or child.name or "",
            TextColor3 = T.textChild,
            Font = FONT,
            TextSize = IS_MOBILE and 18 or 16,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 6,
            Active = false,
        }, ch)

        if kind == "slider" then
            -- 子项滑动条
            local SW = IS_MOBILE and 150 or 130
            local sh = mk("Frame", {
                Name = "SubSlider",
                Size = UDim2.new(0, SW + 46, 0, 24),
                Position = UDim2.new(1, -(SW + 46 + 8), 0.5, -12),
                BackgroundTransparency = 1,
            }, ch)

            local track = mk("Frame", {
                Size = UDim2.new(0, SW, 0, 6),
                Position = UDim2.new(0, 0, 0.5, -3),
                BackgroundColor3 = T.ctrl,
                BorderSizePixel = 0,
                ZIndex = 6,
            }, sh)
            corner(track, 3)

            local fill = mk("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = T.accent,
                BorderSizePixel = 0,
                ZIndex = 7,
            }, track)
            corner(fill, 3)

            local knob = mk("Frame", {
                Size = UDim2.fromOffset(12, 12),
                Position = UDim2.new(0, -6, 0.5, -6),
                BackgroundColor3 = Color3.fromRGB(245, 247, 251),
                BorderSizePixel = 0,
                ZIndex = 8,
            }, track)
            corner(knob, 6)

            local vlab = mk("TextLabel", {
                Size = UDim2.fromOffset(40, 18),
                Position = UDim2.new(0, SW + 6, 0.5, -9),
                BackgroundTransparency = 1,
                Text = tostring(child.Default or 0),
                TextColor3 = T.text,
                Font = FONT_BOLD,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 6,
            }, sh)

            local mn = child.Min or 0
            local mx = child.Max or 100
            local st = child.Step or 0.05
            local val = child.Default or mn

            local function renderSub()
                local a = (mx > mn) and ((val - mn) / (mx - mn)) or 0
                a = math.clamp(a, 0, 1)
                fill.Size = UDim2.new(a, 0, 1, 0)
                knob.Position = UDim2.new(a, -6, 0.5, -6)
                vlab.Text = string.format("%.2f", val)
            end

            local hit = mk("TextButton", {
                Size = UDim2.new(0, SW, 0, 24),
                Position = UDim2.new(0, 0, 0.5, -12),
                BackgroundTransparency = 1,
                Text = "",
                AutoButtonColor = false,
                ZIndex = 9,
            }, sh)

            local dragging = false
            local function setX(x)
                local ax = track.AbsolutePosition.X
                local a = math.clamp((x - ax) / SW, 0, 1)
                val = mn + (mx - mn) * a
                val = math.floor(val / st + 0.5) * st
                renderSub()
                self.Window.State[ckey] = val
                if child.Callback then UI.safeCall(child.Callback, val) end
            end
            hit.MouseButton1Down:Connect(function()
                dragging = true
                local ok, loc = pcall(function() return UserInputService:GetMouseLocation() end)
                if ok and loc then setX(loc.X) end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if not dragging then return end
                if input.UserInputType == Enum.UserInputType.MouseMovement
                    or input.UserInputType == Enum.UserInputType.Touch then
                    setX(input.Position.X)
                end
            end)

            renderSub()
            self.Rows[ckey] = {
                Set = function(v) val = math.clamp(v, mn, mx); renderSub() end,
                Get = function() return val end,
            }
            self.Window.State[ckey] = val

        elseif kind == "toggle" then
            -- 子项开关：右侧放勾选框
            -- 右边距要够大，否则会被 ChildRow 的 ClipsDescendants 裁掉
            local ctrl = makeCheckbox(ch, 22, -22, function(v)
                self.Window.State[ckey] = v
                if child.Callback then UI.safeCall(child.Callback, v) end
            end)
            ctrl.SetSilent(child.Default and true or false)
            self.Window.State[ckey] = child.Default and true or false
            registerControl(self, ckey, ctrl)

        elseif kind == "number" then
            local holder = mk("Frame", {
                Name = "NumInput",
                Size = UDim2.fromOffset(78, 28),
                Position = UDim2.new(1, -86, 0.5, -14),
                BackgroundColor3 = T.box,
                BackgroundTransparency = 0.1,
                BorderSizePixel = 0,
                ZIndex = 20,
            }, ch)
            corner(holder, 5)
            stroke(holder, T.boxStroke, 1, 0.4)
            local box = mk("TextBox", {
                Name = "Input",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = tostring(child.Default or child.min or 1),
                TextColor3 = T.text,
                Font = FONT,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClearTextOnFocus = false,
                ZIndex = 21,
            }, holder)
            box.FocusLost:Connect(function()
                local v = tonumber(box.Text)
                if v then
                    v = math.clamp(v, child.Min or child.min or 1, child.Max or child.max or 100)
                    box.Text = tostring(v)
                    self.Window.State[ckey] = v
                    if child.Callback then UI.safeCall(child.Callback, v) end
                else
                    box.Text = tostring(self.Window.State[ckey] or child.Default or 1)
                end
            end)
            self.Rows[ckey] = {
                Set = function(v) box.Text = tostring(v) end,
                Get = function() return tonumber(box.Text) end,
            }
            self.Window.State[ckey] = child.Default or child.min or 1

        elseif kind == "cycle" then
            -- 加宽的切换按钮：单键循环，整块可点，移动端也好按
            local options = child.Options or { "选项1", "选项2" }
            -- 支持 DefaultIndex：否则永远从第 1 项开始，和实际状态对不上
            local idx = self.Window.State[ckey]
            if type(idx) ~= "number" then
                idx = child.DefaultIndex or child.Default or 1
            end
            idx = math.clamp(idx, 1, #options)
            local cyc = mk("TextButton", {
                Name = "Cycle",
                Size = UDim2.new(0, LAYOUT.cycleW, 0, LAYOUT.cycleH),
                Position = UDim2.new(1, -(LAYOUT.cycleW + 8), 0.5, -LAYOUT.cycleH / 2),
                BackgroundColor3 = T.cycleBg,
                Text = tostring(options[idx] or "?"),
                TextColor3 = T.text,
                Font = FONT_BOLD,
                TextSize = LAYOUT.ctrlText,
                Active = true,
                AutoButtonColor = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 20,
            }, ch)
            corner(cyc, 5)
            stroke(cyc, T.boxStroke, 1, 0.4)
            bindTap(cyc, function()
                idx = idx % #options + 1
                cyc.Text = tostring(options[idx])
                self.Window.State[ckey] = idx
                -- 音效由 bindTap 统一播放
                if child.Callback then UI.safeCall(child.Callback, options[idx], idx) end
            end)
            cyc.MouseEnter:Connect(function() tween(cyc, 0.1, { BackgroundColor3 = T.cycleHover }) end)
            cyc.MouseLeave:Connect(function() tween(cyc, 0.1, { BackgroundColor3 = T.cycleBg }) end)
            self.Rows[ckey] = {
                Set = function(v)
                    for j, o in ipairs(options) do if o == v then idx = j break end end
                    cyc.Text = tostring(options[idx])
                end,
                Get = function() return options[idx], idx end,
            }

        else
            local sub = makeCheckbox(ch, LAYOUT.subBoxSize, -8, function(v)
                self.Window.State[ckey] = v
                if child.Callback then UI.safeCall(child.Callback, v) end
            end)
            local init = child.Default
            if init == nil then init = false end
            sub.SetSilent(init)
            self.Window.State[ckey] = init
            registerControl(self, ckey, sub)
        end
    end

    -- ===== 展开/收起 =====
    -- 状态必须挂在 Window 上，否则切 Tab 后闭包里的局部变量会丢失
    local expandKey = "__expand_" .. tostring(key)
    if self.Window.State[expandKey] == nil then
        self.Window.State[expandKey] = false
    end
    local expanded = self.Window.State[expandKey]

    local CHILD_H = 42

    -- 把子行设为「展开」或「收起」状态
    --   animate=true 时用补间，跟主行展开同步；false 时直接落终态
    local function applyState(show, animate, delay)
        for _, ch in ipairs(childRows) do
            if ch and ch.Parent then
                if show then
                    ch.Visible = true
                    if animate then
                        Anim.to(ch, { Size = UDim2.new(1, -12, 0, CHILD_H) },
                            0.20, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, delay or 0)
                    else
                        ch.Size = UDim2.new(1, -12, 0, CHILD_H)
                    end
                else
                    -- 收起时必须 Visible=false：UIListLayout 对可见元素都会算 Padding，
                    -- 高度 0 只要还可见就会贡献 6px 间隙（这就是「中间空一块」的来源）
                    if animate then
                        Anim.to(ch, { Size = UDim2.new(1, -12, 0, 0) },
                            0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                        -- 动画结束后一定隐藏，避免残留 6px 间距
                        task.delay(0.20, function()
                            if ch and ch.Parent then
                                ch.Visible = false
                            end
                        end)
                    else
                        ch.Size = UDim2.new(1, -12, 0, 0)
                        ch.Visible = false
                    end
                end
            end
        end
        -- 用 ▼ 旋转 180° 表示展开
        arrowBtn.Text = "▼"
        local fullSize = UDim2.fromOffset(ARROW_W, ARROW_W)
        if animate then
            -- 旋转用 Back 缓动（带过冲回弹），同时尺寸从 0.85 弹回 1
            Anim.to(arrowBtn, { Rotation = show and 180 or 0 }, 0.30,
                Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            arrowBtn.Size = UDim2.new(0, ARROW_W * 0.85, 0, ARROW_W * 0.85)
            Anim.to(arrowBtn, { Size = fullSize }, 0.28,
                Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            arrowBtn.Rotation = show and 180 or 0
            arrowBtn.Size = fullSize
        end
    end

    -- 注册恢复函数：SelectTab 切回本页时会调用
    table.insert(self.Window.ExpandRestorers, {
        tab = self,
        expandKey = expandKey,
        panelRow = row,
        apply = applyState,
        get = function() return self.Window.State[expandKey] end,
    })

    -- 初始状态
    applyState(expanded)

    bindTap(arrowBtn, function()
        expanded = not expanded
        self.Window.State[expandKey] = expanded
        -- 音效由 bindTap 统一播放
        -- 旋转带过冲回弹 + 尺寸弹性缩放
        Anim.to(arrowBtn, { Rotation = expanded and 180 or 0 }, 0.30,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        arrowBtn.Size = UDim2.new(0, ARROW_W * 0.85, 0, ARROW_W * 0.85)
        Anim.to(arrowBtn, { Size = UDim2.fromOffset(ARROW_W, ARROW_W) }, 0.28,
            Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        if expanded then
            local delay = 0
            for _, ch in ipairs(childRows) do
                ch.Visible = true
                ch.Size = UDim2.new(1, -12, 0, 0)
                ch.ClipsDescendants = true
                tween(ch, 0.22, { Size = UDim2.new(1, -12, 0, CHILD_H) },
                    Enum.EasingStyle.Quint, Enum.EasingDirection.Out, delay)
                delay = delay + 0.03
            end
        else
            local delay = 0
            for i = #childRows, 1, -1 do
                local ch = childRows[i]
                tween(ch, 0.16, { Size = UDim2.new(1, -12, 0, 0) },
                    Enum.EasingStyle.Quad, Enum.EasingDirection.In, delay)
                delay = delay + 0.02
                task.delay(0.18 + delay, function()
                    if not expanded and ch then ch.Visible = false end
                end)
            end
        end
    end)

    self.Items = self.Items + #children
    return ctrl
end
function Tab:Cycle(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key
    local options = cfg.Options or { "选项1", "选项2" }
    local idx = cfg.DefaultIndex or 1
    self.Window.State[key] = options[idx]

    local ctrl = makeCycle(row, options, idx, function(opt, i)
        self.Window.State[key] = i
        -- 第一个参数给索引，第二个给文字。
        -- 上游模块的 setter 基本都按索引判断，给文字会全部失效。
        if cfg.Callback then UI.safeCall(cfg.Callback, i, opt) end
    end)
    registerControl(self, key, ctrl)
    return ctrl
end

function Tab:Input(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key
    self.Window.State[key] = cfg.Default

    local ctrl = makeNumberInput(row, {
        Default = cfg.Default,
        Min = cfg.Min,
        Max = cfg.Max,
        Quick = cfg.Quick,
        RightOffset = cfg.RightOffset or -230,
    }, function(v)
        self.Window.State[key] = v
        if cfg.Callback then UI.safeCall(cfg.Callback, v) end
    end)
    registerControl(self, key, ctrl)
    return ctrl
end

function Tab:Buttons(cfg)
    local list = cfg.Buttons or {}
    local row = mk("Frame", {
        Name = "ButtonRow",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
        LayoutOrder = (self.Items + 1) * 1000,
        Visible = (self.Window.TabIndex == #self.Window.Tabs),
    }, self.Container)
    self.Items = self.Items + 1
    table.insert(self.Widgets, row)

    local flow = mk("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
    }, row)
    mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 8),
    }, flow)

    for i, item in ipairs(list) do
        local b = makeButton(flow, {
            Text = item.Text or item.Title,
            Variant = item.Variant,
            Width = item.Width or 88,
            Callback = item.Callback,
        })
        b.LayoutOrder = i
    end
    return row
end

-- ============================================================
-- 额外控件
-- ============================================================

-- 滑动条：拖动 + 点击跳转 + 数值显示
function Tab:Slider(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key
    local minV = cfg.Min or 0
    local maxV = cfg.Max or 100
    local step = cfg.Step or 1
    local value = cfg.Default or minV
    self.Window.State[key] = value

    local SLIDER_W = LAYOUT.sliderW
    local holder = mk("Frame", {
        Name = "SliderHolder",
        Size = UDim2.new(0, SLIDER_W + 52, 0, 22),
        Position = UDim2.new(1, -(SLIDER_W + 52 + 8), 0.5, -11),
        BackgroundTransparency = 1,
    }, row)

    local track = mk("Frame", {
        Name = "Track",
        Size = UDim2.new(0, SLIDER_W, 0, LAYOUT.sliderH),
        Position = UDim2.new(0, 0, 0.5, -LAYOUT.sliderH / 2),
        BackgroundColor3 = T.ctrl,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, holder)
    corner(track, 3)

    local fill = mk("Frame", {
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = T.accent,
        BorderSizePixel = 0,
        ZIndex = 7,
    }, track)
    corner(fill, 3)

    local knob = mk("Frame", {
        Name = "Knob",
        Size = UDim2.fromOffset(LAYOUT.knobSize, LAYOUT.knobSize),
        Position = UDim2.new(0, -LAYOUT.knobSize / 2, 0.5, -LAYOUT.knobSize / 2),
        BackgroundColor3 = Color3.fromRGB(245, 247, 251),
        BorderSizePixel = 0,
        ZIndex = 8,
    }, track)
    corner(knob, 7)

    local valueLabel = mk("TextLabel", {
        Name = "Value",
        Size = UDim2.fromOffset(46, 18),
        Position = UDim2.new(0, SLIDER_W + 6, 0.5, -9),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = T.text,
        Font = FONT_BOLD,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 6,
    }, holder)

    local function render()
        local alpha = (maxV > minV) and ((value - minV) / (maxV - minV)) or 0
        alpha = math.clamp(alpha, 0, 1)
        fill.Size = UDim2.new(alpha, 0, 1, 0)
        knob.Position = UDim2.new(alpha, -LAYOUT.knobSize / 2, 0.5, -LAYOUT.knobSize / 2)
        valueLabel.Text = (step >= 1) and tostring(math.floor(value + 0.5)) or string.format("%.2f", value)
    end

    local hit = mk("TextButton", {
        Name = "SliderHit",
        Size = UDim2.new(0, SLIDER_W, 0, 22),
        Position = UDim2.new(0, 0, 0.5, -11),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 9,
    }, holder)

    local function setFromX(x)
        local absX = track.AbsolutePosition.X
        local alpha = math.clamp((x - absX) / SLIDER_W, 0, 1)
        local raw = minV + (maxV - minV) * alpha
        if step >= 1 then
            raw = math.floor(raw / step + 0.5) * step
        end
        value = math.clamp(raw, minV, maxV)
        render()
        if cfg.Callback then UI.safeCall(cfg.Callback, value) end
        self.Window.State[key] = value
    end

    local dragging = false
    hit.MouseButton1Down:Connect(function()
        dragging = true
        local ok, loc = pcall(function() return UserInputService:GetMouseLocation() end)
        if ok and loc then setFromX(loc.X) end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            setFromX(input.Position.X)
        end
    end)

    render()

    local ctrl = {
        Set = function(v, silent)
            value = math.clamp(v, minV, maxV)
            render()
            self.Window.State[key] = value
            if not silent and cfg.Callback then cfg.Callback(value) end
        end,
        Get = function() return value end,
    }
    registerControl(self, key, ctrl)
    return ctrl
end

-- 按键绑定：点击后按下任意键
function Tab:Keybind(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key
    local current = cfg.Default
    self.Window.State[key] = current

    local btn = mk("TextButton", {
        Name = "KeybindBtn",
        Size = UDim2.new(0, LAYOUT.keybindW, 0, LAYOUT.keybindH),
        Position = UDim2.new(1, -(LAYOUT.keybindW + 8), 0.5, -LAYOUT.keybindH / 2),
        BackgroundColor3 = T.ctrl,
        Text = current and current.Name or "未绑定",
        TextColor3 = T.ctrlText,
        Font = FONT_BOLD,
        TextSize = LAYOUT.ctrlText,
        AutoButtonColor = false,
        ZIndex = 20,
        Active = true,
    }, row)
    corner(btn, 5)
    stroke(btn, T.ctrlStroke, 1, 0.4)

    local listening = false
    bindTap(btn, function()
        listening = true
        btn.Text = "按下按键…"
        btn.TextColor3 = T.accent
    end)

    UserInputService.InputBegan:Connect(function(input, processed)
        if not listening or processed then return end
        listening = false
        if input.UserInputType == Enum.UserInputType.Keyboard then
            current = input.KeyCode
            btn.Text = current.Name
            btn.TextColor3 = T.ctrlText
            self.Window.State[key] = current
            if cfg.Callback then UI.safeCall(cfg.Callback, current) end
        else
            btn.Text = current and current.Name or "未绑定"
            btn.TextColor3 = T.ctrlText
        end
    end)

    local ctrl = {
        Set = function(v) current = v; btn.Text = v and v.Name or "未绑定"; self.Window.State[key] = v end,
        Get = function() return current end,
    }
    registerControl(self, key, ctrl)
    return ctrl
end

-- 多选：一组小按钮，可多选
function Tab:MultiSelect(cfg)
    local row = baseRow(self, ROW_H + 20)
    addTitle(row, cfg, 8)

    local key = cfg.Key or cfg.key
    local options = cfg.Options or {}
    local selected = {}
    for _, o in ipairs(cfg.Default or {}) do selected[o] = true end
    self.Window.State[key] = selected

    local flow = mk("Frame", {
        Name = "Chips",
        Size = UDim2.new(1, -20, 0, 26),
        Position = UDim2.new(0, 10, 0, 32),
        BackgroundTransparency = 1,
    }, row)
    mk("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center,
    }, flow)

    for i, opt in ipairs(options) do
        local chip = mk("TextButton", {
            Name = "Chip",
            Size = UDim2.fromOffset(LAYOUT.chipW, LAYOUT.chipH),
            BackgroundColor3 = selected[opt] and T.accent or T.ctrl,
            Text = tostring(opt),
            TextColor3 = selected[opt] and T.tabTextOn or T.ctrlText,
            Font = FONT_BOLD,
            TextSize = LAYOUT.ctrlText,
            AutoButtonColor = false,
            LayoutOrder = i,
            ZIndex = 20,
            Active = true,
        }, flow)
        corner(chip, 4)
        bindTap(chip, function()
            selected[opt] = not selected[opt]
            Anim.to(chip, {
                BackgroundColor3 = selected[opt] and T.accent or T.ctrl,
                TextColor3 = selected[opt] and T.tabTextOn or T.ctrlText,
            }, 0.12)
            self.Window.State[key] = selected
            if cfg.Callback then UI.safeCall(cfg.Callback, selected) end
        end)
    end

    local ctrl = {
        Get = function() return selected end,
        Set = function(t)
            selected = t
            self.Window.State[key] = selected
        end,
    }
    registerControl(self, key, ctrl)
    return ctrl
end
-- 人体图选部位
-- 用方块拼出 R6 角色比例：
--     头部 1.0 : 躯干 2.0 宽 x 2.0 高 : 手臂 1.0 x 2.0 : 腿 1.0 x 2.0
-- 视觉上接近 Roblox 默认角色。
function Tab:Body2D(cfg)
    local key = cfg.Key or cfg.key
    local parts = cfg.Parts or {
        { Key = 1, Name = "头部" },
        { Key = 2, Name = "躯干" },
        { Key = 3, Name = "左臂" },
        { Key = 4, Name = "右臂" },
        { Key = 5, Name = "左腿" },
        { Key = 6, Name = "右腿" },
    }

    local selected = cfg.Default or 1
    self.Window.State[key] = selected

    -- ===== 主行：和 Expand 一样，标题 + 描述 + 箭头 =====
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    -- 右侧箭头
    local ARROW_W = LAYOUT.arrowSize
    local arrowBtn = mk("TextButton", {
        Name = "Arrow",
        Size = UDim2.fromOffset(ARROW_W, ARROW_W),
        Position = UDim2.new(1, -(ARROW_W + 8), 0.5, -ARROW_W / 2),
        BackgroundColor3 = T.arrowBg,
        Text = "▼",
        TextColor3 = T.arrowText,
        Font = FONT_BOLD,
        TextSize = 14,
        AutoButtonColor = false,
        ZIndex = 20,
        Active = true,
    }, row)
    corner(arrowBtn, 6)
    stroke(arrowBtn, T.ctrlStroke, 1, 0.5)

    -- ===== 子项：人体图（List 的直接子元素，靠高度 0 <-> N 展开）=====
    -- 尺寸先算出来，后面 CH_HEIGHT 和画布都要用
    --   总宽固定 240（臂60 + 躯干120 + 臂60）
    --   头/躯干/腿 竖着排
    local TOTAL_W = 180
    local S = math.floor(TOTAL_W / 4)              -- 45
    local TW, TH = 2 * S, 2 * S                    -- 躯干 90x90
    local HX, HY = math.floor(S * 1.35), math.floor(S * 1.35)   -- 头：正方形 60x60
    local AW, AH = 1 * S, 2 * S                    -- 臂 45x90
    local LW, LH = 1 * S, 2 * S                    -- 腿 45x90
    local GAP = 3                                  -- 部件之间留缝
    local totalW = AW + GAP + TW + GAP + AW
    local totalH = HY + GAP + TH + GAP + LH
    local CH_HEIGHT = totalH + 30
    local childRow = mk("Frame", {
        Name = "BodyChildRow",
        Size = UDim2.new(1, -12, 0, 0),
        BackgroundColor3 = T.rowChild,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        LayoutOrder = (self.Items + 1) * 1000 + 1,
        ClipsDescendants = true,
        Visible = false,
        ZIndex = 4,
        Active = false,
    }, self.Container)
    corner(childRow, SIZE.radiusRow)
    table.insert(self.Widgets, childRow)

    -- 左侧竖条
    local bar = mk("Frame", {
        Name = "Bar",
        Size = UDim2.new(0, 2, 1, -14),
        Position = UDim2.new(0, 6, 0, 7),
        BackgroundColor3 = T.accentBar,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, childRow)
    corner(bar, 1)

    local canvas = mk("Frame", {
        Name = "Canvas",
        Size = UDim2.fromOffset(totalW, totalH),
        Position = UDim2.new(0.5, -totalW / 2, 0, 16),
        BackgroundTransparency = 1,
        ZIndex = 5,
    }, childRow)

    local COL_IDLE = Color3.fromRGB(58, 58, 68)
    local COL_HOVER = Color3.fromRGB(78, 78, 92)
    local COL_ON = T.accent

    local buttons = {}

    local function mkPart(px, py, w, h, idx, label)
        local b = mk("TextButton", {
            Name = "Part" .. idx,
            Size = UDim2.fromOffset(w, h),
            Position = UDim2.fromOffset(px, py),
            BackgroundColor3 = COL_IDLE,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 6,
            Active = true,
        }, canvas)
        corner(b, 3)

        local lbl = mk("TextLabel", {
            Name = "Lbl",
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = label or "",
            TextColor3 = Color3.fromRGB(150, 150, 162),
            Font = FONT_BOLD,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 7,
            Active = false,
        }, b)

        buttons[idx] = { btn = b, lbl = lbl }
        return b
    end

    local xArmL = 0
    local xTorso = AW + GAP
    local xArmR = xTorso + TW + GAP
    local yHead = 0
    local yTorso = HY + GAP
    local yLegs = yTorso + TH + GAP

    mkPart(xTorso + (TW - HX) / 2, yHead, HX, HY, 1, "头")
    mkPart(xTorso, yTorso, TW, TH, 2, "躯干")
    mkPart(xArmL, yTorso, AW, AH, 3, "左臂")
    mkPart(xArmR, yTorso, AW, AH, 4, "右臂")
    local legsX = xTorso + (TW - LW * 2 - GAP) / 2
    mkPart(legsX, yLegs, LW, LH, 5, "左腿")
    mkPart(legsX + LW + GAP, yLegs, LW, LH, 6, "右腿")

    local function labelOf(idx)
        for _, pt in ipairs(parts) do
            if pt.Key == idx then return pt.Name end
        end
        return "?"
    end

    local render
    local function setSelected(idx)
        if not buttons[idx] then return end
        selected = idx
        self.Window.State[key] = idx
        render()
        if cfg.Callback then pcall(cfg.Callback, idx) end
    end

    render = function()
        for idx, entry in pairs(buttons) do
            if idx == selected then
                entry.btn.BackgroundColor3 = COL_ON
                pcall(function() entry.lbl.TextColor3 = Color3.fromRGB(18, 18, 22) end)
            else
                entry.btn.BackgroundColor3 = COL_IDLE
                pcall(function() entry.lbl.TextColor3 = Color3.fromRGB(150, 150, 162) end)
            end
        end
    end

    for idx, entry in pairs(buttons) do
        bindTap(entry.btn, function()
            setSelected(idx)
        end)
        entry.btn.MouseEnter:Connect(function()
            if idx ~= selected then
                tween(entry.btn, 0.1, { BackgroundColor3 = COL_HOVER })
            end
        end)
        entry.btn.MouseLeave:Connect(function()
            if idx ~= selected then
                tween(entry.btn, 0.1, { BackgroundColor3 = COL_IDLE })
            end
        end)
    end

    render()

    -- ===== 展开/收起（走统一的折叠基类）=====
    local fold = makeFoldable(self, {
        expandKey = "__body2d_" .. tostring(key),
        row = row,
        arrow = arrowBtn,
        arrowSize = ARROW_W,
        onState = function(open, animate, delay)
            if open then
                childRow.Visible = true
                if animate then
                    childRow.Size = UDim2.new(1, -12, 0, 0)
                    Anim.to(childRow, { Size = UDim2.new(1, -12, 0, CH_HEIGHT) },
                        0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, delay or 0)
                else
                    Anim.snap(childRow, { Size = UDim2.new(1, -12, 0, CH_HEIGHT) })
                end
            else
                -- 收起：动画结束后一定隐藏
                if animate then
                    Anim.to(childRow, { Size = UDim2.new(1, -12, 0, 0) },
                        0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                else
                    Anim.snap(childRow, { Size = UDim2.new(1, -12, 0, 0) })
                end
                -- 直接读 State 判断（不从闭包引用 fold，避免初始化顺序问题）
                local keyRef = "__body2d_" .. tostring(key)
                task.delay(animate and 0.22 or 0, function()
                    if not childRow or not childRow.Parent then return end
                    if self.Window.State[keyRef] ~= true then
                        childRow.Visible = false
                    end
                end)
            end
        end,
    })

    childRow:SetAttribute("__expandKey", fold.key)
    childRow:SetAttribute("__h", CH_HEIGHT)

    -- 走 bindTap：统一音效 + 位移保护 + 错误隔离
    bindTap(arrowBtn, function()
        fold.toggle()
    end)
    -- 整行点击也能切换（但不要在箭头重复触发）
    -- 点击区域：从左边到箭头左侧，避免和箭头重复触发
    local arrowW = LAYOUT.arrowSize
    local rowHit = mk("TextButton", {
        Name = "RowHit",
        Size = UDim2.new(1, -(arrowW + 16), 0, 52),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 3,
        Active = true,
    }, row)
    bindTap(rowHit, function()
        fold.toggle()
    end)

    -- 初始状态：按 State 里的值恢复（默认收起）
    fold.setOpen(fold.isOpen(), false, 0)

    -- 注册到切页恢复器，保证切回来时按当前状态恢复
    table.insert(self.Window.ExpandRestorers, {
        tab = self,
        expandKey = expandKey,
        panelRow = row,          -- 切页展开动画要对齐到主行
        get = function() return self.Window.State[expandKey] == true end,
        -- 注意：这里只改界面，不要改 State
        -- setPage 会对非当前页调用 apply(false) 来隐藏，那不能覆盖用户的真实选择
        apply = function(open)
            local show = open == true
            if show then
                childRow.Visible = true
                childRow.Size = UDim2.new(1, -12, 0, CH_HEIGHT)
            else
                childRow.Size = UDim2.new(1, -12, 0, 0)
                childRow.Visible = false
            end
            pcall(function() arrowBtn.Rotation = show and 180 or 0 end)
        end,
    })

    self.Items = self.Items + 1
    self.Rows[key] = {
        Set = function(v)
            if type(v) == "number" then setSelected(v) end
        end,
        SetSilent = function(v)
            if type(v) == "number" and buttons[v] then
                selected = v
                self.Window.State[key] = v
                render()
            end
        end,
        Get = function() return selected end,
        Expand = function(open) fold.setOpen(open, true, 0) end,
    }
    return self.Rows[key]
end

function Tab:Section(cfg)
    local row = mk("Frame", {
        Name = "SectionRow",
        Size = UDim2.new(1, -12, 0, 34),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 4,
        Active = false,
        LayoutOrder = (self.Items + 1) * 1000,
        Visible = (self.Window.TabIndex == #self.Window.Tabs),
    }, self.Container)
    self.Items = self.Items + 1
    table.insert(self.Widgets, row)

    mk("TextLabel", {
        Name = "SectionTitle",
        Size = UDim2.new(1, -8, 0, 20),
        Position = UDim2.new(0, 4, 0, 6),
        BackgroundTransparency = 1,
        Text = cfg.Name or cfg.name or "",
        TextColor3 = T.textDim,
        Font = FONT_BOLD,
        TextSize = LAYOUT.rowTitle,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 5,
        Active = false,
    }, row)

    local line = mk("Frame", {
        Name = "Line",
        Size = UDim2.new(1, -8, 0, 1),
        Position = UDim2.new(0, 4, 0, 31),
        BackgroundColor3 = T.panelStroke,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 5,
    }, row)
    return row
end

-- ============================================================
-- ColorPicker：颜色选择（色相条 + 饱和度亮度方块 + 预览）
-- ============================================================
function Tab:ColorPicker(cfg)
    local row = baseRow(self, ROW_H + 46)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key
    local col = cfg.Default or Color3.fromRGB(255, 255, 255)

    -- 兼容：部分环境可能没有 toHSV
    local function toHSV(c)
        if Color3.toHSV then
            local ok, hh, ss, vv = pcall(Color3.toHSV, c)
            if ok then return hh, ss, vv end
        end
        -- 简易 RGB -> HSV
        local r, g, b = c.R, c.G, c.B
        local mx = math.max(r, g, b)
        local mn = math.min(r, g, b)
        local d = mx - mn
        local hh = 0
        if d > 0 then
            if mx == r then hh = ((g - b) / d) % 6
            elseif mx == g then hh = (b - r) / d + 2
            else hh = (r - g) / d + 4 end
            hh = hh / 6
        end
        local ss = (mx > 0) and (d / mx) or 0
        return hh, ss, mx
    end

    local function fromHSV(hh, ss, vv)
        if Color3.fromHSV then
            local ok, cc = pcall(Color3.fromHSV, hh, ss, vv)
            if ok then return cc end
        end
        -- 简易 HSV -> RGB
        local i = math.floor(hh * 6)
        local f = hh * 6 - i
        local p1 = vv * (1 - ss)
        local q1 = vv * (1 - f * ss)
        local t1 = vv * (1 - (1 - f) * ss)
        i = i % 6
        if i == 0 then return Color3.new(vv, t1, p1)
        elseif i == 1 then return Color3.new(q1, vv, p1)
        elseif i == 2 then return Color3.new(p1, vv, t1)
        elseif i == 3 then return Color3.new(p1, q1, vv)
        elseif i == 4 then return Color3.new(t1, p1, vv)
        else return Color3.new(vv, p1, q1) end
    end

    local h, s, v = toHSV(col)
    self.Window.State[key] = col

    local SWATCH = 34
    local PREVIEW_W = 44
    local HUE_H = 10

    -- 预览色块
    local preview = mk("Frame", {
        Name = "Preview",
        Size = UDim2.fromOffset(PREVIEW_W, SWATCH),
        Position = UDim2.new(1, -(PREVIEW_W + 8), 0, 8),
        BackgroundColor3 = col,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, row)
    corner(preview, 5)
    stroke(preview, T.ctrlStroke, 1, 0.30)

    -- 色相条
    local hueBar = mk("Frame", {
        Name = "HueBar",
        Size = UDim2.new(1, -(PREVIEW_W + 8 + 8), 0, HUE_H),
        Position = UDim2.new(0, 8, 1, -18),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 6,
    }, row)
    corner(hueBar, HUE_H / 2)

    local grad = mk("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
            ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
            ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
            ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
        }),
    }, hueBar)

    local hueHit = mk("TextButton", {
        Name = "HueHit",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 8,
        Active = true,
    }, hueBar)

    local hueKnob = mk("Frame", {
        Name = "HueKnob",
        Size = UDim2.fromOffset(4, HUE_H + 6),
        Position = UDim2.new(h, -2, 0.5, -(HUE_H + 6) / 2),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
        ZIndex = 9,
    }, hueBar)
    corner(hueKnob, 2)

    local function apply()
        local c = fromHSV(h, s, v)
        preview.BackgroundColor3 = c
        hueKnob.Position = UDim2.new(h, -2, 0.5, -(HUE_H + 6) / 2)
        self.Window.State[key] = c
        if cfg.Callback then UI.safeCall(cfg.Callback, c) end
    end

    local dragging = false
    local function setHue(x)
        local ax = hueBar.AbsolutePosition.X
        local aw = hueBar.AbsoluteSize.X
        h = math.clamp((x - ax) / aw, 0, 1)
        apply()
    end

    hueHit.MouseButton1Down:Connect(function()
        dragging = true
        local ok, loc = pcall(function() return UserInputService:GetMouseLocation() end)
        if ok and loc then setHue(loc.X) end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch then setHue(i.Position.X) end
    end)

    local ctrl = {
        Get = function() return fromHSV(h, s, v) end,
        Set = function(c) local hh, ss, vv = toHSV(c); h, s, v = hh, ss, vv; apply() end,
    }
    registerControl(self, key, ctrl)
    return ctrl
end

-- ============================================================
-- Dropdown：下拉选择
-- ============================================================
function Tab:Dropdown(cfg)
    local options = cfg.Options or {}
    local key = cfg.Key or cfg.key
    local selected = cfg.Default or options[1]
    local rowH = ROW_H + (#options > 0 and 6 or 0)

    local row = baseRow(self, rowH)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)
    self.Window.State[key] = selected

    local btn = mk("TextButton", {
        Name = "DropdownBtn",
        Size = UDim2.new(0, IS_MOBILE and 150 or 130, 0, 28),
        Position = UDim2.new(1, -(IS_MOBILE and 158 or 138), 0.5, -14),
        BackgroundColor3 = T.ctrl,
        Text = tostring(selected),
        TextColor3 = T.ctrlText,
        Font = FONT_BOLD,
        TextSize = LAYOUT.ctrlText,
        AutoButtonColor = false,
        ZIndex = 20,
        Active = true,
    }, row)
    corner(btn, 5)
    stroke(btn, T.ctrlStroke, 1, 0.4)

    -- 下拉面板
    local listH = math.min(#options, 6) * 26
    local panel = mk("Frame", {
        Name = "DropdownList",
        Size = UDim2.new(0, IS_MOBILE and 150 or 130, 0, listH),
        Position = UDim2.new(1, -(IS_MOBILE and 158 or 138), 1, 2),
        BackgroundColor3 = T.row,
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 50,
    }, row)
    corner(panel, 5)
    stroke(panel, T.ctrlStroke, 1, 0.3)

    mk("UIListLayout", {
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, panel)
    local pad = mk("UIPadding", {
        PaddingTop = UDim.new(0, 3),
        PaddingBottom = UDim.new(0, 3),
        PaddingLeft = UDim.new(0, 3),
        PaddingRight = UDim.new(0, 3),
    }, panel)

    local open = false
    local function close()
        open = false
        panel.Visible = false
    end

    for i, opt in ipairs(options) do
        local item = mk("TextButton", {
            Name = "Opt",
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = (opt == selected) and T.ctrl or T.row,
            Text = tostring(opt),
            TextColor3 = (opt == selected) and T.accent or T.ctrlText,
            Font = FONT,
            TextSize = LAYOUT.rowDesc,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false,
            LayoutOrder = i,
            ZIndex = 51,
            Active = true,
        }, panel)
        corner(item, 3)
        local pd = mk("UIPadding", { PaddingLeft = UDim.new(0, 8) }, item)

        bindTap(item, function()
            selected = opt
            btn.Text = tostring(opt)
            self.Window.State[key] = selected
            close()
            if cfg.Callback then UI.safeCall(cfg.Callback, selected, i) end
        end)
    end

    bindTap(btn, function()
        open = not open
        panel.Visible = open
    end)

    local ctrl = {
        Get = function() return selected end,
        Set = function(v)
            selected = v
            btn.Text = tostring(v)
            self.Window.State[key] = v
        end,
    }
    registerControl(self, key, ctrl)
    return ctrl
end

-- ============================================================
-- TextBox：文本输入（非数字）
-- ============================================================
function Tab:TextBox(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key
    local value = cfg.Default or ""
    self.Window.State[key] = value

    local holder = mk("Frame", {
        Name = "TextHolder",
        Size = UDim2.new(0, IS_MOBILE and 150 or 130, 0, 28),
        Position = UDim2.new(1, -(IS_MOBILE and 158 or 138), 0.5, -14),
        BackgroundColor3 = T.ctrl,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 20,
    }, row)
    corner(holder, 5)
    stroke(holder, T.ctrlStroke, 1, 0.4)

    local box = mk("TextBox", {
        Name = "Input",
        Size = UDim2.new(1, -12, 1, 0),
        Position = UDim2.new(0, 6, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        PlaceholderText = cfg.Placeholder or "输入…",
        PlaceholderColor3 = T.textDim,
        TextColor3 = T.text,
        Font = FONT_BOLD,
        TextSize = LAYOUT.ctrlText,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        ZIndex = 21,
    }, holder)

    box.FocusLost:Connect(function()
        value = box.Text
        self.Window.State[key] = value
        if cfg.Callback then UI.safeCall(cfg.Callback, value) end
    end)

    local ctrl = {
        Get = function() return value end,
        Set = function(v) value = v; box.Text = tostring(v) end,
    }
    registerControl(self, key, ctrl)
    return ctrl
end

-- ============================================================
-- Progress：进度条（只读展示）
-- ============================================================
function Tab:Progress(cfg)
    local row = baseRow(self, ROW_H)
    addTitle(row, cfg, 8)
    addDesc(row, cfg, 30)

    local key = cfg.Key or cfg.key or "__progress"

    local track = mk("Frame", {
        Name = "Track",
        Size = UDim2.new(0, IS_MOBILE and 150 or 130, 0, 6),
        Position = UDim2.new(1, -(IS_MOBILE and 158 or 138), 0.5, -3),
        BackgroundColor3 = T.ctrl,
        BorderSizePixel = 0,
        ZIndex = 6,
    }, row)
    corner(track, 3)

    local fill = mk("Frame", {
        Name = "Fill",
        Size = UDim2.new(math.clamp(cfg.Value or 0, 0, 1), 0, 1, 0),
        BackgroundColor3 = cfg.Color or T.accent,
        BorderSizePixel = 0,
        ZIndex = 7,
    }, track)
    corner(fill, 3)

    local pct = mk("TextLabel", {
        Name = "Pct",
        Size = UDim2.fromOffset(40, 18),
        Position = UDim2.new(0, IS_MOBILE and 156 or 136, 0.5, -9),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = T.text,
        Font = FONT_BOLD,
        TextSize = LAYOUT.rowDesc,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 6,
    }, row)

    local function render(v)
        v = math.clamp(v, 0, 1)
        fill.Size = UDim2.new(v, 0, 1, 0)
        pct.Text = string.format("%d%%", math.floor(v * 100 + 0.5))
    end
    render(cfg.Value or 0)

    local ctrl = {
        Set = function(v) render(v) end,
        Get = function() return fill.Size.X.Scale end,
    }
    registerControl(self, key, ctrl)
    return ctrl
end

function Tab:Divider()
    local row = mk("Frame", {
        Name = "Divider",
        Size = UDim2.new(1, 0, 0, 9),
        BackgroundTransparency = 1,
        LayoutOrder = (self.Items + 1) * 1000,
        Visible = (self.Window.TabIndex == #self.Window.Tabs),
    }, self.Container)
    self.Items = self.Items + 1
    table.insert(self.Widgets, row)
    mk("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = T.panelStroke,
        BackgroundTransparency = 0.4,
        BorderSizePixel = 0,
    }, row)
    return row
end

function Tab:Get(key)
    return self.Window.State[key]
end

return UI