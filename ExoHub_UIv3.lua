-- ╔═══════════════════════════════════╗
--   EXO HUB UI v3.0
--   100% Self Contained — No Loads
--   discord.gg/6QzV9pTWs
-- ╚═══════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local lp               = Players.LocalPlayer

-- ══════════════════════════════════════
--  THEME
-- ══════════════════════════════════════
local T = {
    Accent      = Color3.fromRGB(0, 85, 170),
    AccentLight = Color3.fromRGB(0, 180, 255),
    Bg          = Color3.fromRGB(8, 10, 20),
    SidebarBg   = Color3.fromRGB(6, 8, 18),
    RowBg       = Color3.fromRGB(13, 16, 30),
    RowHover    = Color3.fromRGB(16, 20, 38),
    Border      = Color3.fromRGB(0, 45, 100),
    Text        = Color3.fromRGB(210, 225, 255),
    SubText     = Color3.fromRGB(70, 95, 150),
    ToggleOff   = Color3.fromRGB(30, 35, 60),
    SecLabel    = Color3.fromRGB(50, 75, 130),
}

local ICON_ID  = "rbxassetid://71483961072989"
local SIDE_W   = 150
local W_W, W_H = 530, 420

-- ══════════════════════════════════════
--  DESTROY OLD
-- ══════════════════════════════════════
if lp.PlayerGui:FindFirstChild("ExoHubUI") then
    lp.PlayerGui.ExoHubUI:Destroy()
end

-- ══════════════════════════════════════
--  SCREEN GUI
-- ══════════════════════════════════════
local SG = Instance.new("ScreenGui")
SG.Name             = "ExoHubUI"
SG.ResetOnSpawn     = false
SG.DisplayOrder     = 999
SG.IgnoreGuiInset   = true
SG.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
SG.Parent           = lp.PlayerGui

-- ══════════════════════════════════════
--  WINDOW
-- ══════════════════════════════════════
local win = Instance.new("Frame")
win.Size              = UDim2.new(0, W_W, 0, 0)
win.Position          = UDim2.new(0.5, -(W_W/2), 0.5, -(W_H/2))
win.BackgroundColor3  = T.Bg
win.BorderSizePixel   = 0
win.ClipsDescendants  = true
win.Active            = true
win.Draggable         = true
win.Parent            = SG
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 12)
local winStroke = Instance.new("UIStroke", win)
winStroke.Color     = T.Border
winStroke.Thickness = 1.2

-- shimmer top bar
local shimmer = Instance.new("Frame", win)
shimmer.Size             = UDim2.new(1, 0, 0, 2)
shimmer.BackgroundColor3 = T.Accent
shimmer.BorderSizePixel  = 0
shimmer.ZIndex           = 10
local sGrad = Instance.new("UIGradient", shimmer)
sGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.3, T.Accent),
    ColorSequenceKeypoint.new(0.7, T.AccentLight),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,0,0)),
})
task.spawn(function()
    local t = 0
    while SG.Parent do
        t += 0.03
        sGrad.Offset = Vector2.new(math.sin(t) * 0.8, 0)
        task.wait(0.03)
    end
end)

-- ══════════════════════════════════════
--  SIDEBAR
-- ══════════════════════════════════════
local sidebar = Instance.new("Frame", win)
sidebar.Size             = UDim2.new(0, SIDE_W, 1, 0)
sidebar.BackgroundColor3 = T.SidebarBg
sidebar.BorderSizePixel  = 0
sidebar.ZIndex           = 2
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
local patch = Instance.new("Frame", sidebar)
patch.Size             = UDim2.new(0, 12, 1, 0)
patch.Position         = UDim2.new(1, -12, 0, 0)
patch.BackgroundColor3 = T.SidebarBg
patch.BorderSizePixel  = 0
local sbLine = Instance.new("Frame", sidebar)
sbLine.Size             = UDim2.new(0, 1, 1, 0)
sbLine.Position         = UDim2.new(1, 0, 0, 0)
sbLine.BackgroundColor3 = T.Border
sbLine.BorderSizePixel  = 0
sbLine.ZIndex           = 3

-- logo
local logoArea = Instance.new("Frame", sidebar)
logoArea.Size                = UDim2.new(1, 0, 0, 54)
logoArea.BackgroundTransparency = 1
logoArea.ZIndex              = 4

local logoImg = Instance.new("ImageLabel", logoArea)
logoImg.Size                 = UDim2.new(0, 26, 0, 26)
logoImg.Position             = UDim2.new(0, 8, 0.5, -13)
logoImg.BackgroundTransparency = 1
logoImg.Image                = ICON_ID
logoImg.ZIndex               = 5
Instance.new("UICorner", logoImg).CornerRadius = UDim.new(0, 6)

local hubTitle = Instance.new("TextLabel", logoArea)
hubTitle.Size               = UDim2.new(1, -40, 0, 15)
hubTitle.Position           = UDim2.new(0, 38, 0, 10)
hubTitle.BackgroundTransparency = 1
hubTitle.Text               = "EXO HUB"
hubTitle.Font               = Enum.Font.GothamBlack
hubTitle.TextSize           = 13
hubTitle.TextColor3         = T.Text
hubTitle.TextXAlignment     = Enum.TextXAlignment.Left
hubTitle.ZIndex             = 5
Instance.new("UIGradient", hubTitle).Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, T.AccentLight),
    ColorSequenceKeypoint.new(1, T.Text),
})

local discLbl = Instance.new("TextLabel", logoArea)
discLbl.Size               = UDim2.new(1, -40, 0, 10)
discLbl.Position           = UDim2.new(0, 38, 0, 28)
discLbl.BackgroundTransparency = 1
discLbl.Text               = "discord.gg/6QzV9pTWs"
discLbl.Font               = Enum.Font.GothamMedium
discLbl.TextSize           = 8
discLbl.TextColor3         = T.SubText
discLbl.TextXAlignment     = Enum.TextXAlignment.Left
discLbl.ZIndex             = 5

local div1 = Instance.new("Frame", sidebar)
div1.Size             = UDim2.new(1, -10, 0, 1)
div1.Position         = UDim2.new(0, 5, 0, 54)
div1.BackgroundColor3 = T.Border
div1.BorderSizePixel  = 0
div1.ZIndex           = 3

-- search
local searchF = Instance.new("Frame", sidebar)
searchF.Size             = UDim2.new(1, -10, 0, 26)
searchF.Position         = UDim2.new(0, 5, 0, 61)
searchF.BackgroundColor3 = T.RowBg
searchF.BorderSizePixel  = 0
searchF.ZIndex           = 4
Instance.new("UICorner", searchF).CornerRadius = UDim.new(0, 7)
Instance.new("UIStroke", searchF).Color        = T.Border

local searchLbl = Instance.new("TextLabel", searchF)
searchLbl.Size               = UDim2.new(0, 20, 1, 0)
searchLbl.BackgroundTransparency = 1
searchLbl.Text               = "🔍"
searchLbl.TextSize           = 10
searchLbl.Font               = Enum.Font.GothamBold
searchLbl.ZIndex             = 5

local searchBox = Instance.new("TextBox", searchF)
searchBox.Size               = UDim2.new(1, -22, 1, 0)
searchBox.Position           = UDim2.new(0, 20, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.Text               = ""
searchBox.PlaceholderText    = "Search..."
searchBox.Font               = Enum.Font.GothamMedium
searchBox.TextSize           = 10
searchBox.TextColor3         = T.Text
searchBox.PlaceholderColor3  = T.SubText
searchBox.TextXAlignment     = Enum.TextXAlignment.Left
searchBox.ZIndex             = 5
searchBox.ClearTextOnFocus   = false

-- tab list
local tabScroll = Instance.new("ScrollingFrame", sidebar)
tabScroll.Size                 = UDim2.new(1, 0, 1, -94)
tabScroll.Position             = UDim2.new(0, 0, 0, 94)
tabScroll.BackgroundTransparency = 1
tabScroll.BorderSizePixel      = 0
tabScroll.ScrollBarThickness   = 0
tabScroll.CanvasSize           = UDim2.new(0, 0, 0, 0)
tabScroll.AutomaticCanvasSize  = Enum.AutomaticSize.Y
tabScroll.ZIndex               = 4
local tabLL = Instance.new("UIListLayout", tabScroll)
tabLL.SortOrder  = Enum.SortOrder.LayoutOrder
tabLL.Padding    = UDim.new(0, 2)
local tabPad = Instance.new("UIPadding", tabScroll)
tabPad.PaddingLeft   = UDim.new(0, 4)
tabPad.PaddingRight  = UDim.new(0, 4)
tabPad.PaddingTop    = UDim.new(0, 4)

-- ══════════════════════════════════════
--  CONTENT
-- ══════════════════════════════════════
local content = Instance.new("Frame", win)
content.Size             = UDim2.new(1, -SIDE_W, 1, -38)
content.Position         = UDim2.new(0, SIDE_W, 0, 38)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.ZIndex           = 3

-- topbar
local topBarF = Instance.new("Frame", win)
topBarF.Size             = UDim2.new(1, -SIDE_W, 0, 38)
topBarF.Position         = UDim2.new(0, SIDE_W, 0, 0)
topBarF.BackgroundTransparency = 1
topBarF.ZIndex           = 8

local pageLbl = Instance.new("TextLabel", topBarF)
pageLbl.Size             = UDim2.new(1, -70, 1, 0)
pageLbl.Position         = UDim2.new(0, 12, 0, 0)
pageLbl.BackgroundTransparency = 1
pageLbl.Text             = ""
pageLbl.Font             = Enum.Font.GothamBold
pageLbl.TextSize         = 12
pageLbl.TextColor3       = T.SubText
pageLbl.TextXAlignment   = Enum.TextXAlignment.Left
pageLbl.ZIndex           = 9

local hDiv = Instance.new("Frame", win)
hDiv.Size             = UDim2.new(1, -SIDE_W, 0, 1)
hDiv.Position         = UDim2.new(0, SIDE_W, 0, 37)
hDiv.BackgroundColor3 = T.Border
hDiv.BorderSizePixel  = 0
hDiv.ZIndex           = 8

-- window buttons
local function mkBtn(txt, col, xOff)
    local b = Instance.new("TextButton", topBarF)
    b.Size             = UDim2.new(0, 20, 0, 20)
    b.Position         = UDim2.new(1, xOff, 0.5, -10)
    b.BackgroundColor3 = col
    b.Text             = txt
    b.TextColor3       = Color3.fromRGB(200, 200, 210)
    b.Font             = Enum.Font.GothamBold
    b.TextSize         = 8
    b.BorderSizePixel  = 0
    b.ZIndex           = 10
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
    return b
end
local closeBtn = mkBtn("✕", Color3.fromRGB(180, 40, 55), -22)
local miniBtn  = mkBtn("─", Color3.fromRGB(18, 22, 40),  -46)
Instance.new("UIStroke", miniBtn).Color = T.Border

local mini = false
miniBtn.MouseButton1Click:Connect(function()
    mini = not mini
    miniBtn.Text = mini and "+" or "─"
    TweenService:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, W_W, 0, mini and 38 or W_H)
    }):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(win, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, W_W, 0, 0)
    }):Play()
    task.wait(0.3)
    SG:Destroy()
end)

-- ══════════════════════════════════════
--  NOTIFY
-- ══════════════════════════════════════
local notifY = -70
local function Notify(cfg)
    cfg = cfg or {}
    local n = Instance.new("Frame", SG)
    n.Size             = UDim2.new(0, 255, 0, 58)
    n.Position         = UDim2.new(1, 10, 1, notifY)
    n.BackgroundColor3 = T.SidebarBg
    n.BorderSizePixel  = 0
    n.ZIndex           = 100
    Instance.new("UICorner", n).CornerRadius = UDim.new(0, 10)
    local ns = Instance.new("UIStroke", n)
    ns.Color     = T.Accent
    ns.Thickness = 1.2
    local ab = Instance.new("Frame", n)
    ab.Size             = UDim2.new(0, 3, 1, -12)
    ab.Position         = UDim2.new(0, 7, 0, 6)
    ab.BackgroundColor3 = T.Accent
    ab.BorderSizePixel  = 0
    Instance.new("UICorner", ab).CornerRadius = UDim.new(1, 0)
    local nt = Instance.new("TextLabel", n)
    nt.Size             = UDim2.new(1, -22, 0, 16)
    nt.Position         = UDim2.new(0, 16, 0, 9)
    nt.BackgroundTransparency = 1
    nt.Text             = cfg.Title or "EXO HUB"
    nt.Font             = Enum.Font.GothamBold
    nt.TextSize         = 12
    nt.TextColor3       = T.Text
    nt.TextXAlignment   = Enum.TextXAlignment.Left
    nt.ZIndex           = 101
    local nd = Instance.new("TextLabel", n)
    nd.Size             = UDim2.new(1, -22, 0, 14)
    nd.Position         = UDim2.new(0, 16, 0, 29)
    nd.BackgroundTransparency = 1
    nd.Text             = cfg.Content or ""
    nd.Font             = Enum.Font.GothamMedium
    nd.TextSize         = 10
    nd.TextColor3       = T.SubText
    nd.TextXAlignment   = Enum.TextXAlignment.Left
    nd.ZIndex           = 101
    TweenService:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -265, 1, notifY)
    }):Play()
    task.delay(cfg.Duration or 3, function()
        TweenService:Create(n, TweenInfo.new(0.25), {
            Position = UDim2.new(1, 10, 1, notifY)
        }):Play()
        task.wait(0.3)
        n:Destroy()
    end)
end

-- ══════════════════════════════════════
--  TAB + SECTION SYSTEM
-- ══════════════════════════════════════
local allTabs  = {}
local tabCount = 0
local isFirst  = true

-- icon map (no external loads needed)
local ICONS = {
    sword        = "⚔️",
    zap          = "⚡",
    eye          = "👁",
    settings     = "⚙️",
    fish         = "🎣",
    map          = "🗺️",
    plane        = "✈️",
    shield       = "🛡️",
    star         = "⭐",
    target       = "🎯",
    bolt         = "⚡",
    skull        = "💀",
    ghost        = "👻",
    fire         = "🔥",
    lock         = "🔒",
    unlock       = "🔓",
    user         = "👤",
    users        = "👥",
    home         = "🏠",
    search       = "🔍",
    bell         = "🔔",
    heart        = "❤️",
    clock        = "⏰",
    trash        = "🗑️",
    edit         = "✏️",
    check        = "✅",
    x            = "❌",
    info         = "ℹ️",
    warning      = "⚠️",
    ["arrow-up"] = "⬆️",
    money        = "💰",
    diamond      = "💎",
    crown        = "👑",
    robot        = "🤖",
    circle       = "●",
}

local function getEmoji(icon)
    return ICONS[icon] or "◆"
end

local function makeTab(cfg)
    tabCount += 1
    local key  = tostring(tabCount)
    local first = isFirst
    isFirst = false

    -- sidebar button
    local btn = Instance.new("TextButton", tabScroll)
    btn.Size             = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
    btn.BackgroundTransparency = 1
    btn.Text             = ""
    btn.BorderSizePixel  = 0
    btn.ZIndex           = 5
    btn.LayoutOrder      = tabCount
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)

    local emoLbl = Instance.new("TextLabel", btn)
    emoLbl.Size             = UDim2.new(0, 22, 1, 0)
    emoLbl.Position         = UDim2.new(0, 6, 0, 0)
    emoLbl.BackgroundTransparency = 1
    emoLbl.Text             = getEmoji(cfg.Icon)
    emoLbl.TextSize         = 13
    emoLbl.Font             = Enum.Font.GothamBold
    emoLbl.TextColor3       = T.SubText
    emoLbl.ZIndex           = 6

    local tabLbl = Instance.new("TextLabel", btn)
    tabLbl.Size             = UDim2.new(1, -30, 1, 0)
    tabLbl.Position         = UDim2.new(0, 30, 0, 0)
    tabLbl.BackgroundTransparency = 1
    tabLbl.Text             = cfg.Title or "Tab"
    tabLbl.Font             = Enum.Font.GothamBold
    tabLbl.TextSize         = 11
    tabLbl.TextColor3       = T.SubText
    tabLbl.TextXAlignment   = Enum.TextXAlignment.Left
    tabLbl.ZIndex           = 6

    -- page scroll
    local scroll = Instance.new("ScrollingFrame", content)
    scroll.Size                = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel     = 0
    scroll.ScrollBarThickness  = 3
    scroll.ScrollBarImageColor3 = T.Accent
    scroll.CanvasSize          = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Visible             = false
    scroll.ZIndex              = 4
    local sl = Instance.new("UIListLayout", scroll)
    sl.SortOrder = Enum.SortOrder.LayoutOrder
    sl.Padding   = UDim.new(0, 4)
    local sp = Instance.new("UIPadding", scroll)
    sp.PaddingLeft   = UDim.new(0, 8)
    sp.PaddingRight  = UDim.new(0, 12)
    sp.PaddingTop    = UDim.new(0, 8)
    sp.PaddingBottom = UDim.new(0, 8)

    allTabs[key] = {btn=btn, scroll=scroll, emo=emoLbl, lbl=tabLbl}

    local function activate()
        for k, d in pairs(allTabs) do
            local on = k == key
            TweenService:Create(d.btn, TweenInfo.new(0.15), {
                BackgroundColor3       = on and T.Accent or Color3.fromRGB(0,0,0),
                BackgroundTransparency = on and 0 or 1,
            }):Play()
            TweenService:Create(d.lbl, TweenInfo.new(0.15), {TextColor3 = on and Color3.fromRGB(255,255,255) or T.SubText}):Play()
            TweenService:Create(d.emo, TweenInfo.new(0.15), {TextColor3 = on and Color3.fromRGB(255,255,255) or T.SubText}):Play()
            d.scroll.Visible = on
        end
        pageLbl.Text = cfg.Title or ""
    end

    btn.MouseButton1Click:Connect(activate)
    if first then activate() end

    -- search filter
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = searchBox.Text:lower()
        for _, child in ipairs(scroll:GetChildren()) do
            if child:IsA("Frame") and child:FindFirstChild("_key") then
                child.Visible = q == "" or child._key:lower():find(q, 1, true) ~= nil
            end
        end
    end)

    local rowN = 0

    local function mkRow(h)
        rowN += 1
        local row = Instance.new("Frame", scroll)
        row.Size             = UDim2.new(1, 0, 0, h)
        row.BackgroundColor3 = T.RowBg
        row.BorderSizePixel  = 0
        row.ZIndex           = 5
        row.LayoutOrder      = rowN
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 9)
        local rs = Instance.new("UIStroke", row)
        rs.Color     = T.Border
        rs.Thickness = 1
        return row, rs
    end

    local tObj = {}

    function tObj:Section(sCfg)
        sCfg = sCfg or {}
        rowN += 1
        local hdr = Instance.new("Frame", scroll)
        hdr.Size             = UDim2.new(1, 0, 0, 22)
        hdr.BackgroundTransparency = 1
        hdr.ZIndex           = 5
        hdr.LayoutOrder      = rowN
        local hL = Instance.new("TextLabel", hdr)
        hL.Size             = UDim2.new(1, 0, 1, 0)
        hL.BackgroundTransparency = 1
        hL.Text             = (sCfg.Title or ""):upper()
        hL.Font             = Enum.Font.GothamBold
        hL.TextSize         = 9
        hL.LetterSpacing    = 1
        hL.TextColor3       = T.SecLabel
        hL.TextXAlignment   = Enum.TextXAlignment.Left
        hL.ZIndex           = 6

        local sObj = {}

        function sObj:Toggle(cfg)
            local row, rs = mkRow(50)
            -- search key
            local sk = Instance.new("StringValue", row)
            sk.Name  = "_key"
            sk.Value = cfg.Title or ""
            -- icon
            local iL = Instance.new("TextLabel", row)
            iL.Size             = UDim2.new(0, 20, 1, 0)
            iL.Position         = UDim2.new(0, 8, 0, 0)
            iL.BackgroundTransparency = 1
            iL.Text             = getEmoji(cfg.Icon)
            iL.TextSize         = 13
            iL.Font             = Enum.Font.GothamBold
            iL.TextColor3       = T.SubText
            iL.ZIndex           = 6
            -- title
            local nL = Instance.new("TextLabel", row)
            nL.Size             = UDim2.new(1, -68, 0, 16)
            nL.Position         = UDim2.new(0, 32, 0, 8)
            nL.BackgroundTransparency = 1
            nL.Text             = cfg.Title or ""
            nL.Font             = Enum.Font.GothamBold
            nL.TextSize         = 12
            nL.TextColor3       = T.Text
            nL.TextXAlignment   = Enum.TextXAlignment.Left
            nL.ZIndex           = 6
            -- desc
            local dL = Instance.new("TextLabel", row)
            dL.Size             = UDim2.new(1, -68, 0, 12)
            dL.Position         = UDim2.new(0, 32, 0, 28)
            dL.BackgroundTransparency = 1
            dL.Text             = cfg.Desc or ""
            dL.Font             = Enum.Font.GothamMedium
            dL.TextSize         = 9
            dL.TextColor3       = T.SubText
            dL.TextXAlignment   = Enum.TextXAlignment.Left
            dL.ZIndex           = 6
            -- pill
            local pill = Instance.new("Frame", row)
            pill.Size             = UDim2.new(0, 40, 0, 22)
            pill.AnchorPoint      = Vector2.new(1, 0.5)
            pill.Position         = UDim2.new(1, -10, 0.5, 0)
            pill.BackgroundColor3 = T.ToggleOff
            pill.BorderSizePixel  = 0
            pill.ZIndex           = 6
            Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
            local ps = Instance.new("UIStroke", pill)
            ps.Color     = T.Border
            ps.Thickness = 1
            local dot = Instance.new("Frame", pill)
            dot.Size             = UDim2.new(0, 14, 0, 14)
            dot.AnchorPoint      = Vector2.new(0.5, 0.5)
            dot.Position         = UDim2.new(0.28, 0, 0.5, 0)
            dot.BackgroundColor3 = T.SubText
            dot.BorderSizePixel  = 0
            dot.ZIndex           = 7
            Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
            local cb = Instance.new("TextButton", row)
            cb.Size             = UDim2.new(1, 0, 1, 0)
            cb.BackgroundTransparency = 1
            cb.Text             = ""
            cb.ZIndex           = 8
            local on = cfg.Value or false
            local ti = TweenInfo.new(0.18, Enum.EasingStyle.Quart)
            local function set(v)
                on = v
                TweenService:Create(pill, ti, {BackgroundColor3 = on and T.Accent or T.ToggleOff}):Play()
                TweenService:Create(ps,   ti, {Color = on and T.Accent or T.Border, Transparency = on and 0.5 or 0}):Play()
                TweenService:Create(dot,  ti, {
                    Position         = on and UDim2.new(0.72, 0, 0.5, 0) or UDim2.new(0.28, 0, 0.5, 0),
                    BackgroundColor3 = on and Color3.fromRGB(255,255,255) or T.SubText
                }):Play()
                TweenService:Create(rs, ti, {Color = on and T.Accent or T.Border, Transparency = on and 0.5 or 0}):Play()
                if cfg.Callback then cfg.Callback(on) end
            end
            if on then task.defer(function() set(true) end) end
            cb.MouseButton1Click:Connect(function() set(not on) end)
            local o = {}
            function o:Set(v) set(v) end
            return o
        end

        function sObj:Button(cfg)
            local row, rs = mkRow(50)
            local sk = Instance.new("StringValue", row)
            sk.Name  = "_key"
            sk.Value = cfg.Title or ""
            local iL = Instance.new("TextLabel", row)
            iL.Size             = UDim2.new(0, 20, 1, 0)
            iL.Position         = UDim2.new(0, 8, 0, 0)
            iL.BackgroundTransparency = 1
            iL.Text             = getEmoji(cfg.Icon)
            iL.TextSize         = 13
            iL.Font             = Enum.Font.GothamBold
            iL.TextColor3       = T.SubText
            iL.ZIndex           = 6
            local nL = Instance.new("TextLabel", row)
            nL.Size             = UDim2.new(1, -58, 0, 16)
            nL.Position         = UDim2.new(0, 32, 0, 8)
            nL.BackgroundTransparency = 1
            nL.Text             = cfg.Title or ""
            nL.Font             = Enum.Font.GothamBold
            nL.TextSize         = 12
            nL.TextColor3       = T.Text
            nL.TextXAlignment   = Enum.TextXAlignment.Left
            nL.ZIndex           = 6
            local dL = Instance.new("TextLabel", row)
            dL.Size             = UDim2.new(1, -58, 0, 12)
            dL.Position         = UDim2.new(0, 32, 0, 28)
            dL.BackgroundTransparency = 1
            dL.Text             = cfg.Desc or ""
            dL.Font             = Enum.Font.GothamMedium
            dL.TextSize         = 9
            dL.TextColor3       = T.SubText
            dL.TextXAlignment   = Enum.TextXAlignment.Left
            dL.ZIndex           = 6
            local ib = Instance.new("Frame", row)
            ib.Size             = UDim2.new(0, 24, 0, 24)
            ib.AnchorPoint      = Vector2.new(1, 0.5)
            ib.Position         = UDim2.new(1, -10, 0.5, 0)
            ib.BackgroundColor3 = T.ToggleOff
            ib.BorderSizePixel  = 0
            ib.ZIndex           = 6
            Instance.new("UICorner", ib).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", ib).Color        = T.Border
            local il = Instance.new("TextLabel", ib)
            il.Size             = UDim2.new(1, 0, 1, 0)
            il.BackgroundTransparency = 1
            il.Text             = "▶"
            il.TextSize         = 8
            il.Font             = Enum.Font.GothamBold
            il.TextColor3       = T.Accent
            il.ZIndex           = 7
            local cb = Instance.new("TextButton", row)
            cb.Size             = UDim2.new(1, 0, 1, 0)
            cb.BackgroundTransparency = 1
            cb.Text             = ""
            cb.ZIndex           = 8
            cb.MouseButton1Click:Connect(function()
                TweenService:Create(row, TweenInfo.new(0.1),  {BackgroundColor3 = T.RowHover}):Play()
                task.wait(0.12)
                TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = T.RowBg}):Play()
                if cfg.Callback then cfg.Callback() end
            end)
        end

        function sObj:Slider(cfg)
            local row, rs = mkRow(58)
            local sk = Instance.new("StringValue", row)
            sk.Name  = "_key"
            sk.Value = cfg.Title or ""
            local iL = Instance.new("TextLabel", row)
            iL.Size             = UDim2.new(0, 20, 0, 20)
            iL.Position         = UDim2.new(0, 8, 0, 8)
            iL.BackgroundTransparency = 1
            iL.Text             = getEmoji(cfg.Icon)
            iL.TextSize         = 13
            iL.Font             = Enum.Font.GothamBold
            iL.TextColor3       = T.SubText
            iL.ZIndex           = 6
            local nL = Instance.new("TextLabel", row)
            nL.Size             = UDim2.new(1, -68, 0, 16)
            nL.Position         = UDim2.new(0, 32, 0, 8)
            nL.BackgroundTransparency = 1
            nL.Text             = cfg.Title or ""
            nL.Font             = Enum.Font.GothamBold
            nL.TextSize         = 12
            nL.TextColor3       = T.Text
            nL.TextXAlignment   = Enum.TextXAlignment.Left
            nL.ZIndex           = 6
            local vL = Instance.new("TextLabel", row)
            vL.Size             = UDim2.new(0, 46, 0, 16)
            vL.Position         = UDim2.new(1, -54, 0, 8)
            vL.BackgroundTransparency = 1
            vL.Text             = tostring(cfg.Value or cfg.Min or 0)
            vL.Font             = Enum.Font.GothamBold
            vL.TextSize         = 11
            vL.TextColor3       = T.Accent
            vL.TextXAlignment   = Enum.TextXAlignment.Right
            vL.ZIndex           = 6
            local track = Instance.new("Frame", row)
            track.Size             = UDim2.new(1, -22, 0, 4)
            track.Position         = UDim2.new(0, 11, 0, 42)
            track.BackgroundColor3 = T.ToggleOff
            track.BorderSizePixel  = 0
            track.ZIndex           = 6
            Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
            local mn, mx = cfg.Min or 0, cfg.Max or 100
            local pct    = ((cfg.Value or mn) - mn) / (mx - mn)
            local fill = Instance.new("Frame", track)
            fill.Size             = UDim2.new(pct, 0, 1, 0)
            fill.BackgroundColor3 = T.Accent
            fill.BorderSizePixel  = 0
            fill.ZIndex           = 7
            Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
            Instance.new("UIGradient", fill).Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, T.Accent),
                ColorSequenceKeypoint.new(1, T.AccentLight),
            })
            local thumb = Instance.new("Frame", track)
            thumb.Size             = UDim2.new(0, 14, 0, 14)
            thumb.AnchorPoint      = Vector2.new(0.5, 0.5)
            thumb.Position         = UDim2.new(pct, 0, 0.5, 0)
            thumb.BackgroundColor3 = Color3.fromRGB(220, 235, 255)
            thumb.BorderSizePixel  = 0
            thumb.ZIndex           = 8
            Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)
            local drag = false
            thumb.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if not drag then return end
                if i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch then return end
                local rel = math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                local val = math.floor(mn + rel * (mx - mn))
                fill.Size      = UDim2.new(rel, 0, 1, 0)
                thumb.Position = UDim2.new(rel, 0, 0.5, 0)
                vL.Text        = tostring(val)
                if cfg.Callback then cfg.Callback(val) end
            end)
        end

        function sObj:Paragraph(cfg)
            local row = mkRow(54)
            local tL = Instance.new("TextLabel", row)
            tL.Size             = UDim2.new(1, -18, 0, 16)
            tL.Position         = UDim2.new(0, 10, 0, 9)
            tL.BackgroundTransparency = 1
            tL.Text             = cfg.Title or ""
            tL.Font             = Enum.Font.GothamBold
            tL.TextSize         = 12
            tL.TextColor3       = T.Text
            tL.TextXAlignment   = Enum.TextXAlignment.Left
            tL.ZIndex           = 6
            local dL = Instance.new("TextLabel", row)
            dL.Size             = UDim2.new(1, -18, 0, 22)
            dL.Position         = UDim2.new(0, 10, 0, 27)
            dL.BackgroundTransparency = 1
            dL.Text             = cfg.Desc or ""
            dL.Font             = Enum.Font.GothamMedium
            dL.TextSize         = 9
            dL.TextColor3       = T.SubText
            dL.TextXAlignment   = Enum.TextXAlignment.Left
            dL.TextWrapped      = true
            dL.ZIndex           = 6
        end

        return sObj
    end

    return tObj
end

-- ══════════════════════════════════════
--  OPEN ANIMATION
-- ══════════════════════════════════════
TweenService:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, W_W, 0, W_H)
}):Play()

-- ══════════════════════════════════════
--  TEST CONTENT
-- ══════════════════════════════════════
local Tab1 = makeTab({ Title = "Combat",   Icon = "sword"    })
local Tab2 = makeTab({ Title = "Movement", Icon = "zap"      })
local Tab3 = makeTab({ Title = "Visuals",  Icon = "eye"      })
local Tab4 = makeTab({ Title = "Misc",     Icon = "settings" })

local S1 = Tab1:Section({ Title = "Test Features" })
S1:Toggle({
    Title = "Toggle Test",
    Desc  = "Dark blue pill toggle",
    Icon  = "check",
    Value = false,
    Callback = function(state)
        Notify({ Title="EXO HUB", Content="Toggle: "..(state and "ON 🔥" or "OFF"), Duration=2 })
    end
})
S1:Button({
    Title = "Button Test",
    Desc  = "Tap to test",
    Icon  = "star",
    Callback = function()
        Notify({ Title="EXO HUB", Content="Button works! 🔥", Duration=3 })
    end
})
S1:Slider({
    Title = "Slider Test",
    Icon  = "bolt",
    Min   = 0, Max = 100, Value = 50,
    Callback = function(v) print("Slider:", v) end
})

local S2 = Tab2:Section({ Title = "Movement" })
S2:Toggle({ Title="Speed Hack", Desc="Boosts walk speed", Icon="zap",   Value=false, Callback=function() end })
S2:Toggle({ Title="Fly",        Desc="Fly around",        Icon="plane", Value=false, Callback=function() end })
S2:Slider({ Title="Fly Speed",  Icon="bolt", Min=10, Max=200, Value=50, Callback=function() end })

local S3 = Tab3:Section({ Title = "ESP" })
S3:Toggle({ Title="Player ESP", Desc="See players through walls", Icon="eye", Value=false, Callback=function() end })

local S4 = Tab4:Section({ Title = "EXO HUB" })
S4:Paragraph({ Title="EXO HUB v3.0", Desc="Free forever.\ndiscord.gg/6QzV9pTWs" })

task.wait(0.5)
Notify({ Title="EXO HUB", Content="v3.0 loaded! 🔥 discord.gg/6QzV9pTWs", Duration=4 })
print("[EXO HUB] UI v3.0 | discord.gg/6QzV9pTWs")
