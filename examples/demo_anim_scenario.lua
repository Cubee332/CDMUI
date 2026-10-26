-- ============================================================================
-- demo_anim_scenario.lua — 进场动画采样（配合 --capture 0.04 --anim）
-- ============================================================================

local win = loadstring(game:HttpGet("https://mock.local/demo.lua"))()
pump(0.7)

-- 收起再展开，让进场动画重新播放
win:SetVisible(false)
pump(0.4)

local tabBtn = findByName("Tab_移动")
if tabBtn then
    tapUI(tabBtn)
    pump(0.3)
end

win:SetVisible(true)
pump(0.55)
Snapshot("进场完成")

__HARNESS.summary()
