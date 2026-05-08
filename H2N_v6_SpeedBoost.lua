-- H2N v6.0 - ENHANCED EDITION
-- دمج Auto Play من Silent + Auto Steal من OR
-- مع الحفاظ على جميع ميزات H2N الأصلية

repeat task.wait() until game:IsLoaded()
if not game.PlaceId then repeat task.wait(1) until game.PlaceId end

-- INTRO
task.spawn(function()
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "H2NIntro"
    introGui.ResetOnSpawn = false
    introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    introGui.DisplayOrder = 999
    local ok = pcall(function() introGui.Parent = game:GetService("CoreGui") end)
    if not ok then introGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

    local function playKey()
        pcall(function()
            local s = Instance.new("Sound", workspace)
            s.SoundId = "rbxassetid://9119713951"
            s.Volume = 0.35
            s.PlaybackSpeed = 0.85 + math.random() * 0.3
            s:Play()
            game:GetService("Debris"):AddItem(s, 0.6)
        end);
    end

    local lbl = Instance.new("TextLabel", introGui)
    lbl.Size        = UDim2.new(1, 0, 0, 60)
    lbl.Position    = UDim2.new(0, 0, 0.28, 0)
    lbl.BackgroundTransparency = 1
    lbl.ZIndex      = 200
    lbl.Font        = Enum.Font.GothamBlack
    lbl.TextSize    = 28
    lbl.TextColor3  = Color3.fromRGB(255, 255, 255)
    lbl.TextTransparency = 0
    lbl.Text        = ""
    lbl.TextXAlignment = Enum.TextXAlignment.Center
    lbl.TextStrokeTransparency = 0
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    lbl.Position = UDim2.new(0, 0, 0.12, 0)
    lbl.TextTransparency = 1
    TweenService:Create(lbl, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0.28, 0),
        TextTransparency = 0,
    }):Play()
    task.wait(0.35)

    local part1 = "Best Duels Script"
    local part2 = " > H2N v6.0"
    local full   = part1 .. part2

    for i = 1, #full do
        local ch = full:sub(i, i)
        if ch ~= " " then playKey() end
        if i <= #part1 then
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            lbl.TextColor3 = Color3.fromRGB(140, 140, 140)
        end
        lbl.Text = full:sub(1, i)
        task.wait(0.065)
    end

    task.wait(0.15)
    TweenService:Create(lbl, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    task.wait(0.12)
    TweenService:Create(lbl, TweenInfo.new(0.25), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
    task.wait(1.3)

    TweenService:Create(lbl, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(1.1, 0, 0.28, 0),
        TextTransparency = 1,
    }):Play()
    task.wait(0.45)
    introGui:Destroy()
end)

pcall(function()
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name and (v.Name:find("H2N_WP_") or v.Name:find("H2N_Duel_")) then
            v:Destroy()
        end
    end
end)

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Char, HRP, Hum
local isMobile = UIS.TouchEnabled and not UIS.MouseEnabled

-- ANTI LAG GLOBAL FLAG
AntiLagEnabled = false

local fireproximityprompt = fireproximityprompt or function(prompt)
    if not prompt then return end
    pcall(function()
        if prompt.InputHoldBegin then
            prompt.InputHoldBegin()
            task.wait(0.05)
            prompt.InputHoldEnd()
        end
    end)
end

local function SafeWriteFile(name, data)
    pcall(function() if writefile then writefile(name, data) end end)
end

local function SafeReadFile(name)
    local success, result = pcall(function() if readfile then return readfile(name) end end)
    if success and result then return result end
    return nil
end

-- H2N Theme: Royal Gold × Obsidian
local T = {
    A   = Color3.fromRGB(255, 215, 100),
    B   = Color3.fromRGB(230, 185, 60),
    C   = Color3.fromRGB(200, 155, 30),
    D   = Color3.fromRGB(255, 240, 180),
    Bg0 = Color3.fromRGB(4,   4,   8),
    Bg1 = Color3.fromRGB(8,   8,   14),
    Bg2 = Color3.fromRGB(13,  12,  22),
    Bg3 = Color3.fromRGB(18,  17,  30),
    Bg4 = Color3.fromRGB(26,  24,  42),
    Tx  = Color3.fromRGB(255, 240, 195),
    TxS = Color3.fromRGB(210, 185, 120),
    TxD = Color3.fromRGB(150, 125, 70),
    ON  = Color3.fromRGB(220, 175, 30),
    OFF = Color3.fromRGB(20,  18,  35),
    Suc = Color3.fromRGB(80,  230, 120),
    Err = Color3.fromRGB(255, 70,  70),
    Br  = Color3.fromRGB(255, 210, 60),
    BrS = Color3.fromRGB(180, 140, 30),
    BrD = Color3.fromRGB(80,  65,  15),
}
local Colors = {
    White = T.Bg1, LightGray = T.Bg2,
    MediumGray = T.A, DarkGray = T.C,
    VeryDark = T.Bg0, AlmostBlack = T.Bg0,
    Border = T.Br, Text = T.Tx,
    SubText = T.TxS, Success = T.Suc,
    Error = T.Err, DotOff = T.BrD,
    DotOn = T.A, DiscordBlue = T.B,
}

-- SHIMMER: UIGradient دوار على كل Border
local function makeGoldGradient()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(8,   6,   0)),
        ColorSequenceKeypoint.new(0.15, Color3.fromRGB(60,  45,  5)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(180, 135, 20)),
        ColorSequenceKeypoint.new(0.5,  Color3.fromRGB(255, 225, 80)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(180, 135, 20)),
        ColorSequenceKeypoint.new(0.85, Color3.fromRGB(60,  45,  5)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(8,   6,   0)),
    })
end

local function applySpinningGoldStroke(parent, thickness, speed)
    thickness = thickness or 2
    speed = speed or 1.4
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = thickness
    stroke.Parent = parent
    local grad = Instance.new("UIGradient", stroke)
    grad.Color = makeGoldGradient()
    grad.Rotation = math.random(0, 360)
    local GC = {
        Color3.fromRGB(255,215,100), Color3.fromRGB(255,245,180),
        Color3.fromRGB(220,165, 30), Color3.fromRGB(255,200, 60),
        Color3.fromRGB(255,255,220),
    }
    task.spawn(function()
        local t = math.random()*10
        local waitTime = 0.12
        while parent and parent.Parent do
            t = t + waitTime
            if not AntiLagEnabled then
                grad.Rotation = (grad.Rotation + speed) % 360
                local i = math.floor(t*1.5) % #GC + 1
                stroke.Color     = GC[i]:Lerp(GC[i%#GC+1], (t*1.5)%1)
                stroke.Thickness = thickness + math.abs(math.sin(t*2)) * 1.0
            end
            task.wait(waitTime)
        end
    end)
    return stroke
end

local function addBgShimmer(parent, speed, alpha)
    local ov = Instance.new("Frame", parent)
    ov.Size = UDim2.new(1,0,1,0)
    ov.BackgroundColor3 = Color3.fromRGB(200,150,20)
    ov.BackgroundTransparency = alpha or 0.82
    ov.BorderSizePixel = 0
    ov.ZIndex = (parent.ZIndex or 1) + 1
    ov.Active = false
    ov.Selectable = false
    local c = parent:FindFirstChildOfClass("UICorner")
    if c then
        Instance.new("UICorner", ov).CornerRadius = c.CornerRadius
    end
    local g = Instance.new("UIGradient", ov)
    g.Color    = makeGoldGradient()
    g.Rotation = math.random(0, 360)
    task.spawn(function()
        while ov and ov.Parent do
            if not AntiLagEnabled then
                g.Rotation = (g.Rotation + (speed or 1.4)) % 360
            end
            task.wait(0.12)
        end
    end)
    return ov
end

local _notifyQueue = {}
local gui = nil

local function Notify(txt)
    if gui then
        local f = Instance.new("Frame", gui)
        f.Size = UDim2.new(0, 203, 0, 32)
        f.Position = UDim2.new(1, -218, 1, -80)
        f.AnchorPoint = Vector2.new(0, 1)
        f.BackgroundColor3 = T.Bg2
        f.BackgroundTransparency = 0.05
        f.ZIndex = 70
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local ns = applySpinningGoldStroke(f, 1.5, 1.8)
        addBgShimmer(f, 1.6, 0.88)
        local notifAccent = Instance.new("Frame", f)
        notifAccent.Size = UDim2.new(0, 3, 1, -6)
        notifAccent.Position = UDim2.new(0, 4, 0, 3)
        notifAccent.BackgroundColor3 = T.Br
        notifAccent.BorderSizePixel = 0
        notifAccent.ZIndex = 72
        Instance.new("UICorner", notifAccent).CornerRadius = UDim.new(1, 0)
        local fl = Instance.new("TextLabel", f)
        fl.Size = UDim2.new(1, -14, 1, 0)
        fl.Position = UDim2.new(0, 13, 0, 0)
        fl.BackgroundTransparency = 1
        fl.Text = txt
        fl.TextColor3 = T.Tx
        fl.Font = Enum.Font.GothamBold
        fl.TextSize = 11
        fl.ZIndex = 73
        fl.TextXAlignment = Enum.TextXAlignment.Left
        fl.TextTruncate = Enum.TextTruncate.AtEnd
        f.Position = UDim2.new(1, 10, 1, -80)
        game:GetService("TweenService"):Create(f,
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            { Position = UDim2.new(1, -218, 1, -80) }
        ):Play()
        task.spawn(function()
            task.wait(AntiLagEnabled and 1.5 or 3)
            game:GetService("TweenService"):Create(f,
                TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In),
                { Position = UDim2.new(1, 10, 1, -80), BackgroundTransparency = 1 }
            ):Play()
            task.wait(0.26)
            f:Destroy()
        end)
    else
        table.insert(_notifyQueue, txt)
    end
end

local function Setup(c)
    Char = c
    HRP = c:WaitForChild("HumanoidRootPart")
    Hum = c:WaitForChild("Humanoid")
    pcall(function() HRP:SetNetworkOwner(LP) end)
end

if LP.Character then Setup(LP.Character) end
LP.CharacterAdded:Connect(function(c)
    task.wait(0.1)
    Setup(c)
end)

local _switchingModes = false

local State = {
    AutoPlayLeft = false, AutoPlayRight = false,
    AntiRagdoll = false, InfiniteJump = false, XrayBase = false,
    ESP = false, AntiSentry = false, SpinBody = false, FloatEnabled = false,
    Optimizer = false, SpamBat = false, AutoSteal = false,
    RightSteal = false, LeftSteal = false,
    SpeedBoost = false,
}

-- ============================================
-- AUTO STEAL (من OR's Auto Steal Hub)
-- ============================================
local STEAL_RADIUS = 9
local STEAL_DURATION = 0.2
local isStealing = false
local stealStartTime = 0
local stealConn = nil
local progressConn = nil

local animalCache = {}
local promptCache = {}
local stealCache = {}

local grabBarFill = nil
local grabBarPercent = nil
local stealBarFrame = nil

local function resetStealBar()
    if grabBarFill    then grabBarFill.Size = UDim2.fromScale(0, 1) end
    if grabBarPercent then grabBarPercent.Text = "READY" end
end

local function isMyPlot(plotName)
    local plot = workspace.Plots and workspace.Plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign"); if not sign then return false end
    local yb = sign:FindFirstChild("YourBase")
    return yb and yb:IsA("BillboardGui") and yb.Enabled == true
end

local function scanPlot(plot)
    if not plot or not plot:IsA("Model") then return end
    if isMyPlot(plot.Name) then return end
    local podiums = plot:FindFirstChild("AnimalPodiums"); if not podiums then return end
    for _, pod in ipairs(podiums:GetChildren()) do
        if pod:IsA("Model") and pod:FindFirstChild("Base") then
            local uid = plot.Name .. "_" .. pod.Name
            for _, ex in ipairs(animalCache) do if ex.uid == uid then return end end
            table.insert(animalCache, {
                name = pod.Name, plot = plot.Name, slot = pod.Name,
                worldPosition = pod:GetPivot().Position, uid = uid,
            })
        end
    end
end

local function findPromptCached(ad)
    if not ad then return nil end
    local cp = promptCache[ad.uid]
    if cp and cp.Parent then return cp end
    local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
    local plot  = plots:FindFirstChild(ad.plot);    if not plot  then return nil end
    local pods  = plot:FindFirstChild("AnimalPodiums"); if not pods then return nil end
    local pod   = pods:FindFirstChild(ad.slot);     if not pod   then return nil end
    local base  = pod:FindFirstChild("Base");        if not base  then return nil end
    local sp    = base:FindFirstChild("Spawn");      if not sp    then return nil end
    local function searchPrompt(obj)
        for _, ch in ipairs(obj:GetDescendants()) do
            if ch:IsA("ProximityPrompt") then return ch end
        end
    end
    local att = sp:FindFirstChild("PromptAttachment")
    local prompt = nil
    if att then
        for _, p in ipairs(att:GetChildren()) do
            if p:IsA("ProximityPrompt") then prompt = p; break end
        end
    end
    if not prompt then prompt = searchPrompt(sp) end
    if prompt then promptCache[ad.uid] = prompt end
    return prompt
end

local function buildCallbacks(prompt)
    if stealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(c1) == "table" then
        for _, conn in ipairs(c1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(c2) == "table" then
        for _, conn in ipairs(c2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
        stealCache[prompt] = data
    end
end

local function nearestAnimal()
    local char = LP.Character; if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestD = nil, math.huge
    for _, ad in ipairs(animalCache) do
        if not isMyPlot(ad.plot) and ad.worldPosition then
            local d = (hrp.Position - ad.worldPosition).Magnitude
            if d < bestD then bestD = d; best = ad end
        end
    end
    return best, bestD
end

local function execSteal(prompt, animalName)
    local data = stealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false; isStealing = true
    stealStartTime = tick()
    if grabBarPercent then grabBarPercent.Text = animalName or "STEAL..." end
    if progressConn then progressConn:Disconnect() end
    progressConn = RunService.Heartbeat:Connect(function()
        if not isStealing then progressConn:Disconnect(); return end
        local prog = math.clamp((tick() - stealStartTime) / STEAL_DURATION, 0, 1)
        if grabBarFill then grabBarFill.Size = UDim2.fromScale(prog, 1) end
        if grabBarPercent then grabBarPercent.Text = math.floor(prog*100).."%" end
    end)
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        local elapsed = 0
        while elapsed < STEAL_DURATION do elapsed = elapsed + task.wait() end
        for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
        task.wait(0.01)
        if progressConn then progressConn:Disconnect(); progressConn = nil end
        resetStealBar()
        task.wait(0.01)
        data.ready = true; isStealing = false
    end)
    return true
end

local function startAutoSteal()
    if stealConn then return end
    stealConn = RunService.Heartbeat:Connect(function()
        if not State.AutoSteal or isStealing then return end
        local target, dist = nearestAnimal()
        if not target then return end
        local char = LP.Character
        local hrp  = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
        if not hrp then return end
        if dist > STEAL_RADIUS then return end
        local prompt = promptCache[target.uid]
        if not prompt or not prompt.Parent then prompt = findPromptCached(target) end
        if prompt then buildCallbacks(prompt); execSteal(prompt, target.name) end
    end)
end

local function stopAutoSteal()
    if stealConn then stealConn:Disconnect(); stealConn = nil end
    isStealing = false
    resetStealBar()
end

task.spawn(function()
    task.wait(2)
    local plots = workspace:WaitForChild("Plots", 10); if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") then scanPlot(plot) end
    end
    plots.ChildAdded:Connect(function(plot)
        if plot:IsA("Model") then task.wait(0.5); scanPlot(plot) end
    end)
    task.spawn(function()
        while task.wait(5) do
            animalCache = {}; promptCache = {}
            for _, plot in ipairs(plots:GetChildren()) do
                if plot:IsA("Model") then scanPlot(plot) end
            end
        end
    end)
end)

-- ============================================
-- SPEED BOOST
-- ============================================
local SpeedBoostMover = nil
local SpeedBoostConn  = nil
local SPEED_BOOST_VAL = 57

local function makeSpeedMover(char, hrp)
    pcall(function()
        if SpeedBoostMover and SpeedBoostMover.Parent then
            SpeedBoostMover:Destroy()
        end
    end)
    local mover = Instance.new("Part")
    mover.Size        = Vector3.new(2, 1, 2)
    mover.Transparency = 1
    mover.CanCollide  = false
    mover.Anchored    = false
    mover.Massless    = true
    mover.Name        = "H2N_SpeedMover"
    mover.Parent      = char
    local w = Instance.new("Weld")
    w.Part0  = hrp
    w.Part1  = mover
    w.C0     = CFrame.new(0, 0, -3)
    w.Parent = mover
    SpeedBoostMover = mover
end

local function startSpeedBoost()
    if State.SpeedBoost then return end
    State.SpeedBoost = true
    local char = LP.Character; if not char then return end
    local hrp  = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local hum  = char:FindFirstChildOfClass("Humanoid");  if not hum then return end
    local baseSpd = hum.WalkSpeed
    makeSpeedMover(char, hrp)
    if SpeedBoostConn then SpeedBoostConn:Disconnect() end
    SpeedBoostConn = RunService.Heartbeat:Connect(function()
        if not State.SpeedBoost then return end
        -- لا تشتغل أثناء Auto Play أو Steal Path
        if pathActive then return end
        local c = LP.Character; if not c then return end
        local r = c:FindFirstChild("HumanoidRootPart"); if not r then return end
        local h = c:FindFirstChildOfClass("Humanoid");  if not h then return end
        local m = SpeedBoostMover
        if not m or not m.Parent then makeSpeedMover(c, r); m = SpeedBoostMover end
        local dir = h.MoveDirection
        if dir.Magnitude > 0 then
            h.WalkSpeed = SPEED_BOOST_VAL
            m.AssemblyLinearVelocity = Vector3.new(dir.X * SPEED_BOOST_VAL, m.AssemblyLinearVelocity.Y, dir.Z * SPEED_BOOST_VAL)
        else
            h.WalkSpeed = baseSpd
            m.AssemblyLinearVelocity = Vector3.new(0, m.AssemblyLinearVelocity.Y, 0)
        end
    end)
    Notify("SPEED BOOST ON")
end

local function stopSpeedBoost()
    if not State.SpeedBoost then return end
    State.SpeedBoost = false
    if SpeedBoostConn then SpeedBoostConn:Disconnect(); SpeedBoostConn = nil end
    pcall(function()
        if SpeedBoostMover and SpeedBoostMover.Parent then
            SpeedBoostMover:Destroy(); SpeedBoostMover = nil
        end
    end)
    local char = LP.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = 16 end
    end
    Notify("SPEED BOOST OFF")
end

-- إعادة إنشاء المover عند respawn
LP.CharacterAdded:Connect(function(c)
    if State.SpeedBoost then
        task.wait(0.3)
        local r = c:WaitForChild("HumanoidRootPart")
        makeSpeedMover(c, r)
    end
end)

-- ============================================
-- AUTO PLAY RIGHT/LEFT
-- سرعة المشي (L1↔L2): AP_WALK_SPEED
-- سرعة السرقة (L1→L3): AP_STEAL_SPEED
-- تباطؤ فقط عند L3/R3
-- ============================================
local pathActive  = false
local lastFlatVel = Vector3.zero

-- سرعات قابلة للتعديل
local AP_WALK_SPEED  = 58.0   -- سرعة المشي بين L1↔L2
local AP_STEAL_SPEED = 32.0   -- سرعة السرقة من L1→L3

local AP_SLOWDOWN_R  = 5.8
local AP_STOP_R      = 2.2
local AP_SMOOTH      = 0.09
local AP_JITTER_AMP  = 0.40
local AP_JITTER_FREQ = 7.2

-- النقاط الأساسية
local WP_L1 = Vector3.new(-473, -6,  28)
local WP_L2 = Vector3.new(-484, -4,  27)
local WP_L3 = Vector3.new(-474, -6, 110)

local WP_R1 = Vector3.new(-474, -6,  93)
local WP_R2 = Vector3.new(-484, -4,  93)
local WP_R3 = Vector3.new(-474, -6,  17)

-- المسارات: L1↔L2 بدون توقف، L1→L3 مع تباطؤ عند L3 فقط
local stealPathLeft = {
    { pos = WP_L1, speed = AP_WALK_SPEED, slowdown = false },   -- L1 → L2: مشي سريع، بدون تباطؤ
    { pos = WP_L2, speed = AP_WALK_SPEED, slowdown = false },   -- L2 → L1: رجوع سريع، بدون تباطؤ
    { pos = WP_L1, speed = AP_STEAL_SPEED, slowdown = false },  -- L1 → L3: سرعة سرقة، تباطؤ فقط عند L3
    { pos = WP_L3, speed = AP_STEAL_SPEED, slowdown = true },   -- الوصول للصناديق: تباطؤ وتوقف
}
local stealPathRight = {
    { pos = WP_R1, speed = AP_WALK_SPEED, slowdown = false },
    { pos = WP_R2, speed = AP_WALK_SPEED, slowdown = false },
    { pos = WP_R1, speed = AP_STEAL_SPEED, slowdown = false },
    { pos = WP_R3, speed = AP_STEAL_SPEED, slowdown = true },
}

-- دالة الحركة لنقطة واحدة
local function apMoveToPoint(hrp, target3D, baseSpeed, useSlowdown)
    local speed = baseSpeed
    local done  = false
    local t     = math.random() * 100

    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not pathActive then
            conn:Disconnect()
            hrp.AssemblyLinearVelocity = Vector3.zero
            done = true
            return
        end

        t = t + dt * AP_JITTER_FREQ
        local pos  = hrp.Position
        local flat = Vector3.new(pos.X, 0, pos.Z)
        local tgt  = Vector3.new(target3D.X, 0, target3D.Z)
        local dir  = tgt - flat
        local dist = dir.Magnitude

        if dist <= AP_STOP_R then
            conn:Disconnect()
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
            done = true
            return
        end

        local moveDir = dir.Unit

        if lastFlatVel.Magnitude > 0.1 then
            moveDir = (moveDir * (1 - AP_SMOOTH) + lastFlatVel.Unit * AP_SMOOTH).Unit
        end

        local perp   = Vector3.new(-moveDir.Z, 0, moveDir.X)
        
        -- jitter فقط إذا ما في تباطؤ
        if useSlowdown then
            local jitter = math.sin(t) * AP_JITTER_AMP * math.clamp(dist / AP_SLOWDOWN_R, 0, 1)
            moveDir = (moveDir + perp * jitter * 0.08).Unit
        end

        -- تباطؤ فقط إذا مطلوب (عند L3/R3)
        local finalSpeed = speed
        if useSlowdown and dist < AP_SLOWDOWN_R then
            local ratio = dist / AP_SLOWDOWN_R
            finalSpeed = speed * (0.22 + 0.78 * (ratio * ratio))
            
            if dist < 2 then
                finalSpeed = speed * math.clamp(dist / 2, 0.28, 1)
            end
        end

        local vel = Vector3.new(
            moveDir.X * finalSpeed,
            hrp.AssemblyLinearVelocity.Y,
            moveDir.Z * finalSpeed
        )
        hrp.AssemblyLinearVelocity = vel
        lastFlatVel = Vector3.new(vel.X, 0, vel.Z)
    end)

    while not done do
        RunService.Heartbeat:Wait()
    end
end

-- تشغيل مسار كامل
local function runStealPath(path)
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hrp  = char:WaitForChild("HumanoidRootPart")
    for i, wp in ipairs(path) do
        if not pathActive then return end
        apMoveToPoint(hrp, wp.pos, wp.speed, wp.slowdown)
    end
end

local function startStealPath(path)
    pathActive = true
    lastFlatVel = Vector3.zero
    task.spawn(function()
        while pathActive do
            runStealPath(path)
        end
    end)
end

local function stopStealPath()
    pathActive = false
    lastFlatVel = Vector3.zero
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
end

-- ============================================
-- FLOAT
-- ============================================
local FloatConn = nil
local floatJumping = false
local FLOAT_TARGET_HEIGHT = 9.5

local function startFloat()
    if State.FloatEnabled then return end
    State.FloatEnabled = true
    if FloatConn then FloatConn:Disconnect(); FloatConn = nil end
    FloatConn = RunService.Heartbeat:Connect(function()
        if not State.FloatEnabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {char}; rp.FilterType = Enum.RaycastFilterType.Exclude
        local rr = workspace:Raycast(root.Position, Vector3.new(0, -200, 0), rp)
        if rr then
            local diff = (rr.Position.Y + FLOAT_TARGET_HEIGHT) - root.Position.Y
            if floatJumping then
                if root.AssemblyLinearVelocity.Y <= 0 and diff >= -2 then floatJumping = false else return end
            end
            if math.abs(diff) > 0.3 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, diff * 15, root.AssemblyLinearVelocity.Z)
            else
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
            end
        end
    end)
    Notify("FLOAT ON")
end

local function stopFloat()
    if not State.FloatEnabled then return end
    State.FloatEnabled = false
    if FloatConn then FloatConn:Disconnect(); FloatConn = nil end
    local char = LP.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
        end
    end
    Notify("FLOAT OFF")
end

UIS.JumpRequest:Connect(function() if State.FloatEnabled then floatJumping = true end end)

-- DROP
local DropState = { active = false, lastTime = 0, COOLDOWN = 1.0 }
local _dropBlockAutoPlay = false
local DAD = 0.2

local _dropFlingConns = {}
local _dropFlingActive = false

local function _startDropFling(char)
    _dropFlingActive = true
    local stepped = RunService.Stepped:Connect(function()
        if not _dropFlingActive then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                for _, part in ipairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end)
    table.insert(_dropFlingConns, stepped)
    local co = coroutine.create(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then return end
        local vel = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = vel * 8000 + Vector3.new(0, 8000, 0)
        RunService.RenderStepped:Wait()
        if r and r.Parent then r.AssemblyLinearVelocity = vel end
        RunService.Stepped:Wait()
        if r and r.Parent then r.AssemblyLinearVelocity = vel + Vector3.new(0, 0.1, 0) end
    end)
    coroutine.resume(co)
end

local function _stopDropFling()
    _dropFlingActive = false
    for _, c in ipairs(_dropFlingConns) do
        if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
    end
    _dropFlingConns = {}
end

local function executeDrop()
    if DropState.active then return end
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local floatWas = State.FloatEnabled
    if floatWas then State.FloatEnabled = false; stopFloat() end
    DropState.active = true
    _dropBlockAutoPlay = true
    _startDropFling(char)
    task.delay(0.35, function() _stopDropFling() end)
    local t0 = tick(); local conn
    conn = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then conn:Disconnect(); DropState.active = false; return end
        if tick() - t0 >= DAD then
            conn:Disconnect()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {char}; rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.zero
            end
            DropState.active = false
            task.wait(1.0)
            _dropBlockAutoPlay = false
            if floatWas then State.FloatEnabled = true; startFloat() end
            Notify("DROP!")
            return
        end
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, 150, r.AssemblyLinearVelocity.Z)
    end)
end

-- ============================================
-- AUTO TP DOWN
-- ============================================
local TPSettings = {
    Enabled = true, TPHeight = 12.5, LastTPTime = 0, TP_COOLDOWN = 0.15,
    SavedLandingX = nil, SavedLandingZ = nil, WasAboveThreshold = false, MonitorConnection = nil,
}
local function getHRPTP()
    local char = LP.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function findEmptySpot(hrp)
    if not hrp then return nil end
    local startX = hrp.Position.X; local startZ = hrp.Position.Z; local startY = hrp.Position.Y
    for y = -50, startY + 5, 2 do
        local checkPos = Vector3.new(startX, y, startZ)
        local rayParams = RaycastParams.new()
        rayParams.FilterDescendantsInstances = {LP.Character}
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        local result = workspace:Raycast(checkPos, Vector3.new(0, 0.5, 0), rayParams)
        if not result then
            local radiusCheck = workspace:Raycast(checkPos, Vector3.new(0.5, 0, 0), rayParams)
            if not radiusCheck then return checkPos.Y end
        end
    end
    return hrp.Position.Y - 10
end

local function getGroundPositionTP(hrp)
    if not hrp then return nil end
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LP.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(hrp.Position, Vector3.new(0, -200, 0), rayParams)
    if result then return result.Position.Y end
    return hrp.Position.Y - 10
end

local function TeleportToGround()
    local hrp = getHRPTP()
    if not hrp then return false end
    local now = tick()
    if now - TPSettings.LastTPTime < TPSettings.TP_COOLDOWN then return false end
    if TPSettings.SavedLandingX == nil or TPSettings.SavedLandingZ == nil then
        TPSettings.SavedLandingX = hrp.Position.X
        TPSettings.SavedLandingZ = hrp.Position.Z
    end
    local safeY = findEmptySpot(hrp)
    if not safeY then safeY = getGroundPositionTP(hrp) end
    if not safeY then return false end
    local targetPos = Vector3.new(TPSettings.SavedLandingX, safeY + 1.5, TPSettings.SavedLandingZ)
    TPSettings.LastTPTime = now
    pcall(function() hrp.CFrame = CFrame.new(targetPos) end)
    return true
end

local function StartTPMonitoring()
    if TPSettings.MonitorConnection then return end
    TPSettings.MonitorConnection = RunService.Heartbeat:Connect(function()
        if not TPSettings.Enabled then return end
        local hrp = getHRPTP()
        if not hrp then TPSettings.WasAboveThreshold = false; return end
        local currentHeight = hrp.Position.Y
        local isAbove = currentHeight >= TPSettings.TPHeight
        if isAbove and not TPSettings.WasAboveThreshold then
            TPSettings.SavedLandingX = hrp.Position.X
            TPSettings.SavedLandingZ = hrp.Position.Z
            TPSettings.WasAboveThreshold = true
        end
        if isAbove then TeleportToGround() end
        if not isAbove and TPSettings.WasAboveThreshold then
            TPSettings.WasAboveThreshold = false
        end
    end)
end

local function StopTPMonitoring()
    if TPSettings.MonitorConnection then
        TPSettings.MonitorConnection:Disconnect()
        TPSettings.MonitorConnection = nil
    end
    TPSettings.WasAboveThreshold = false
end

function ToggleAutoTPDown()
    if TPSettings.Enabled then
        TPSettings.Enabled = false
        StopTPMonitoring()
        Notify("AUTO TP DOWN OFF")
    else
        TPSettings.Enabled = true
        StartTPMonitoring()
        Notify("AUTO TP DOWN ON")
    end
end

local function ExecuteTPDown()
    local char = LP.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {char}; rp.FilterType = Enum.RaycastFilterType.Exclude
    local rr = workspace:Raycast(hrp.Position, Vector3.new(0, -2000, 0), rp)
    if rr then
        local hum = char:FindFirstChildOfClass("Humanoid")
        local off = (hum and hum.HipHeight or 2) + (hrp.Size.Y / 2)
        hrp.CFrame = CFrame.new(rr.Position.X, rr.Position.Y + off, rr.Position.Z)
        hrp.AssemblyLinearVelocity = Vector3.zero
    end
    Notify("TP DOWN!")
end

-- ============================================
-- SPAM BAT
-- ============================================
local SpamBatState = { conn = nil, lastSwing = 0, COOLDOWN = 0.12, enabled = false }
local SlapList = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

local function _findBat()
    local c = LP.Character if not c then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    for _, name in ipairs(SlapList) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    return nil
end

local function StartSpamBat()
    if SpamBatState.enabled then return end
    SpamBatState.enabled = true
    if SpamBatState.conn then SpamBatState.conn:Disconnect() end
    SpamBatState.conn = RunService.Heartbeat:Connect(function()
        if not SpamBatState.enabled then return end
        local c = LP.Character if not c then return end
        local bat = _findBat() if not bat then return end
        if bat.Parent ~= c then
            local hum = c:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(bat) end) end
        end
        local now = tick()
        if now - SpamBatState.lastSwing < SpamBatState.COOLDOWN then return end
        SpamBatState.lastSwing = now
        pcall(function() bat:Activate() end)
    end)
    Notify("SPAM BAT ON")
end

local function StopSpamBat()
    if not SpamBatState.enabled then return end
    SpamBatState.enabled = false
    if SpamBatState.conn then SpamBatState.conn:Disconnect(); SpamBatState.conn = nil end
    Notify("SPAM BAT OFF")
end

-- ============================================
-- BAT AIMBOT
-- ============================================
local BatAimbotState = { conn = nil, enabled = false }
local autoBatSpd = 55
local autoBatDistThreshold = 1.5

local function findBatForAimbot()
    local char = LP.Character; if not char then return nil end
    local bp = LP:FindFirstChildOfClass("Backpack")
    for _, ch in ipairs(char:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
    if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
    for _, name in ipairs(SlapList) do
        local t = char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
end

local function findNearestEnemyForBat(myHRP)
    local nearest, nearestDist, nearestTorso = nil, math.huge, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local eh = p.Character:FindFirstChild("HumanoidRootPart")
            local torso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if eh and hum and hum.Health > 0 then
                local d = (eh.Position - myHRP.Position).Magnitude
                if d < nearestDist then
                    nearestDist = d
                    nearest = eh
                    nearestTorso = torso or eh
                end
            end
        end
    end
    return nearest, nearestDist, nearestTorso
end

local function StartBatAimbot()
    if BatAimbotState.conn then return end
    BatAimbotState.enabled = true
    BatAimbotState.conn = RunService.Heartbeat:Connect(function()
        if not BatAimbotState.enabled then return end
        local c = LP.Character; if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not h or not hum then return end
        local bat = findBatForAimbot()
        if bat and bat.Parent ~= c then pcall(function() hum:EquipTool(bat) end) end
        local target, dist, torso = findNearestEnemyForBat(h)
        if target and torso then
            local dir = torso.Position - h.Position
            local flatDist = dir.Magnitude
            if flatDist > autoBatDistThreshold then
                local moveDir = dir.Unit
                h.AssemblyLinearVelocity = Vector3.new(moveDir.X * autoBatSpd, moveDir.Y * autoBatSpd, moveDir.Z * autoBatSpd)
            else
                local tv = target.AssemblyLinearVelocity
                h.AssemblyLinearVelocity = Vector3.new(tv.X, tv.Y, tv.Z)
            end
        end
    end)
    Notify("AUTO BAT ON")
end

local function StopBatAimbot()
    if not BatAimbotState.enabled then return end
    BatAimbotState.enabled = false
    if BatAimbotState.conn then BatAimbotState.conn:Disconnect(); BatAimbotState.conn = nil end
    local c = LP.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if h then h.AssemblyLinearVelocity = Vector3.zero end
    Notify("AUTO BAT OFF")
end

-- ============================================
-- OPTIMIZER
-- ============================================
local function startOptimizer()
    if State.Optimizer then return end
    State.Optimizer = true
    AntiLagEnabled = true
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        game:GetService("Lighting").GlobalShadows = false
        game:GetService("Lighting").Brightness = 3
    end)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            pcall(function()
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then obj:Destroy()
                elseif obj:IsA("BasePart") then obj.CastShadow = false; obj.Material = Enum.Material.Plastic end
            end)
        end
    end)
    Notify("ANTI LAG ON")
end

local function stopOptimizer()
    if not State.Optimizer then return end
    State.Optimizer = false
    AntiLagEnabled = false
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level08
        game:GetService("Lighting").GlobalShadows = true
        game:GetService("Lighting").Brightness = 2
    end)
    Notify("ANTI LAG OFF")
end

-- ============================================
-- XRAY BASE
-- ============================================
local baseOT = {}; local plotConns = {}; local xrayCon = nil
local XRAY_TRANSPARENCY = 0.68

local function applyXray(plot)
    if baseOT[plot] then return end; baseOT[plot] = {}
    for _, p in ipairs(plot:GetDescendants()) do
        if p:IsA("BasePart") and p.Transparency < 0.6 then baseOT[plot][p] = p.Transparency; p.Transparency = XRAY_TRANSPARENCY end
    end
    plotConns[plot] = plot.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") and d.Transparency < 0.6 then baseOT[plot][d] = d.Transparency; d.Transparency = XRAY_TRANSPARENCY end
    end)
end

local function StartXrayBase()
    if State.XrayBase then return end
    State.XrayBase = true
    local plots = workspace:FindFirstChild("Plots"); if not plots then return end
    for _, plot in ipairs(plots:GetChildren()) do applyXray(plot) end
    xrayCon = plots.ChildAdded:Connect(function(p) task.wait(0.2); applyXray(p) end)
    Notify("XRAY BASE ON")
end

local function StopXrayBase()
    if not State.XrayBase then return end
    State.XrayBase = false
    for _, conn in pairs(plotConns) do conn:Disconnect() end; plotConns = {}
    if xrayCon then xrayCon:Disconnect(); xrayCon = nil end
    for _, parts in pairs(baseOT) do
        for part, orig in pairs(parts) do if part and part.Parent then part.Transparency = orig end end
    end
    baseOT = {}
    Notify("XRAY BASE OFF")
end

-- ============================================
-- ESP
-- ============================================
ESPState = { hl = {} }
local function ClearESP() for _, h in pairs(ESPState.hl) do if h and h.Parent then h:Destroy() end end; ESPState.hl = {} end
local function StartESP() if State.ESP then return end; State.ESP = true; Notify("ESP ON") end
local function StopESP() if not State.ESP then return end; State.ESP = false; ClearESP(); Notify("ESP OFF") end
local function updateESP()
    if not State.ESP then return end
    for player, h in pairs(ESPState.hl) do
        if not player or not player.Character then if h and h.Parent then h:Destroy() end; ESPState.hl[player] = nil end
    end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and (not ESPState.hl[p] or not ESPState.hl[p].Parent) then
            local h = Instance.new("Highlight")
            h.FillColor = Colors.DarkGray; h.OutlineColor = Colors.White
            h.FillTransparency = 0.5; h.OutlineTransparency = 0; h.Adornee = p.Character; h.Parent = p.Character
            ESPState.hl[p] = h
        end
    end
end

-- ============================================
-- ANTI SENTRY
-- ============================================
SentryState = { target = nil, DETECT_DIST = 60, PULL_DIST = -5 }
local function findSentryTarget()
    local char = LP.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local rootPos = char.HumanoidRootPart.Position
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name:find("Sentry") and not obj.Name:lower():find("bullet") then
            local part = (obj:IsA("BasePart") and obj) or (obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")))
            if part and (rootPos - part.Position).Magnitude <= SentryState.DETECT_DIST then return obj end
        end
    end
end
local function moveSentry(obj)
    local char = LP.Character; if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    for _, p in pairs(obj:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    local root = char.HumanoidRootPart; local cf = root.CFrame * CFrame.new(0,0,SentryState.PULL_DIST)
    if obj:IsA("BasePart") then obj.CFrame = cf
    elseif obj:IsA("Model") then local m = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart"); if m then m.CFrame = cf end end
end
local function attackSentry()
    local char = LP.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local weapon = LP.Backpack:FindFirstChild("Bat") or (char:FindFirstChild("Bat"))
    if not weapon then return end
    if weapon.Parent == LP.Backpack then hum:EquipTool(weapon); task.wait(0.1) end
    pcall(function() weapon:Activate() end)
end
local function StartAntiSentry() if State.AntiSentry then return end; State.AntiSentry = true; Notify("ANTI SENTRY ON") end
local function StopAntiSentry() if not State.AntiSentry then return end; State.AntiSentry = false; SentryState.target = nil; Notify("ANTI SENTRY OFF") end
local function updateAntiSentry() if not State.AntiSentry then return end; if SentryState.target and SentryState.target.Parent == workspace then moveSentry(SentryState.target); attackSentry() else SentryState.target = findSentryTarget() end end

-- ============================================
-- SPIN BODY
-- ============================================
SpinState = { force = nil, SPEED = 25 }
local function StartSpinBody()
    if State.SpinBody then return end
    State.SpinBody = true
    local char = LP.Character; if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root or SpinState.force then return end
    SpinState.force = Instance.new("BodyAngularVelocity")
    SpinState.force.Name = "SpinForce"; SpinState.force.AngularVelocity = Vector3.new(0,SpinState.SPEED,0)
    SpinState.force.MaxTorque = Vector3.new(0,math.huge,0); SpinState.force.P = 1250; SpinState.force.Parent = root
    Notify("SPIN BODY ON")
end
local function StopSpinBody()
    if not State.SpinBody then return end
    State.SpinBody = false; if SpinState.force then SpinState.force:Destroy(); SpinState.force = nil end
    Notify("SPIN BODY OFF")
end

-- ============================================
-- ANTI RAGDOLL
-- ============================================
ARState = { conn = nil }
local ANTI_FLING_MAX_XZ = 80
local ANTI_FLING_MAX_Y  = 120

local function StartAntiRagdoll()
    if State.AntiRagdoll then return end
    State.AntiRagdoll = true
    if ARState.conn then ARState.conn:Disconnect() end
    ARState.conn = RunService.Heartbeat:Connect(function()
        if not State.AntiRagdoll then return end
        if BatAimbotState.enabled then return end
        local char = LP.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local st = hum:GetState()
        local isRag = st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.GettingUp
        if isRag then
            hum:ChangeState(Enum.HumanoidStateType.Running)
            workspace.CurrentCamera.CameraSubject = hum
            pcall(function()
                local pm = LP.PlayerScripts:FindFirstChild("PlayerModule")
                if pm then require(pm):GetControls():Enable() end
            end)
            if root then root.AssemblyLinearVelocity = Vector3.zero; root.AssemblyAngularVelocity = Vector3.zero end
        end
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled = true end
        end
        if root then
            local vel = root.AssemblyLinearVelocity
            local xzMag = Vector3.new(vel.X, 0, vel.Z).Magnitude
            local cx, cz = vel.X, vel.Z
            if xzMag > ANTI_FLING_MAX_XZ then
                local sc = ANTI_FLING_MAX_XZ / xzMag; cx = vel.X*sc; cz = vel.Z*sc
            end
            local cy = math.clamp(vel.Y, -ANTI_FLING_MAX_Y, ANTI_FLING_MAX_Y)
            if math.abs(cx-vel.X) > 0.5 or math.abs(cz-vel.Z) > 0.5 or math.abs(cy-vel.Y) > 0.5 then
                root.AssemblyLinearVelocity = Vector3.new(cx, cy, cz)
                root.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end)
    Notify("ANTI RAGDOLL ON")
end

local function StopAntiRagdoll()
    if not State.AntiRagdoll then return end
    State.AntiRagdoll = false
    if ARState.conn then ARState.conn:Disconnect(); ARState.conn = nil end
    Notify("ANTI RAGDOLL OFF")
end

-- ============================================
-- INFINITE JUMP
-- ============================================
JumpState = { jumpConn = nil, fallConn = nil }
local INF_JUMP_FORCE = 54
local CLAMP_FALL = 80

local function StartInfiniteJump()
    if State.InfiniteJump then return end
    State.InfiniteJump = true
    if JumpState.jumpConn then JumpState.jumpConn:Disconnect() end
    if JumpState.fallConn then JumpState.fallConn:Disconnect() end
    JumpState.jumpConn = UIS.JumpRequest:Connect(function()
        if not State.InfiniteJump then return end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, INF_JUMP_FORCE, root.AssemblyLinearVelocity.Z) end
    end)
    JumpState.fallConn = RunService.Heartbeat:Connect(function()
        if not State.InfiniteJump then return end
        local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if root and root.AssemblyLinearVelocity.Y < -CLAMP_FALL then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -CLAMP_FALL, root.AssemblyLinearVelocity.Z)
        end
    end)
    Notify("INFINITE JUMP ON")
end

local function StopInfiniteJump()
    State.InfiniteJump = false
    if JumpState.jumpConn then JumpState.jumpConn:Disconnect(); JumpState.jumpConn = nil end
    if JumpState.fallConn then JumpState.fallConn:Disconnect(); JumpState.fallConn = nil end
    Notify("INFINITE JUMP OFF")
end

-- ============================================
-- ANTI DIE
-- ============================================
AntiDieState = { conn = nil }
local function startPermanentAntiDie()
    if AntiDieState.conn then AntiDieState.conn:Disconnect() end
    AntiDieState.conn = RunService.Heartbeat:Connect(function()
        if not Hum or not Hum.Parent then return end
        if Hum.Health <= 0 then pcall(function() Hum.Health = Hum.MaxHealth * 0.9 end) end
        pcall(function() Hum.RequiresNeck = false end)
        if HRP and HRP.Position.Y < -10 then HRP.CFrame = CFrame.new(HRP.Position.X, -4, HRP.Position.Z) end
    end)
end
task.spawn(function() task.wait(0.5); startPermanentAntiDie() end)

-- ============================================
-- DAMAGE TRACKING
-- ============================================
DmgState = { conn = nil, cooldown = false, lastHealth = nil, cooldownTimer = nil, COOLDOWN = 2.8 }

local function stopFeaturesOnDamage()
    if DmgState.cooldown then return end
    DmgState.cooldown = true
    _switchingModes = true
    if State.RightSteal then stopStealPath(); State.RightSteal = false end
    if State.LeftSteal then stopStealPath(); State.LeftSteal = false end
    _switchingModes = false
    if State.FloatEnabled then stopFloat() end
    if DmgState.cooldownTimer then pcall(function() task.cancel(DmgState.cooldownTimer) end) end
    DmgState.cooldownTimer = task.delay(DmgState.COOLDOWN, function() DmgState.cooldown = false end)
end

local function setupDamageTracking()
    if DmgState.conn then DmgState.conn:Disconnect(); DmgState.conn = nil end
    local char = LP.Character if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") if not hum then return end
    DmgState.lastHealth = hum.Health
    DmgState.conn = RunService.Heartbeat:Connect(function()
        if not LP.Character or not hum or hum.Parent ~= LP.Character then
            if DmgState.conn then DmgState.conn:Disconnect(); DmgState.conn = nil end
            return
        end
        local currentHealth = hum.Health
        if DmgState.lastHealth and currentHealth < DmgState.lastHealth - 0.5 and hum.Health > 0 then
            if not DmgState.cooldown then stopFeaturesOnDamage() end
        end
        local currentState = hum:GetState()
        if currentState == Enum.HumanoidStateType.Physics or currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown then
            if not DmgState.cooldown then stopFeaturesOnDamage() end
        end
        if currentHealth > 0 then DmgState.lastHealth = currentHealth end
    end)
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    DmgState.cooldown = false
    DmgState.lastHealth = nil
    if DmgState.cooldownTimer then pcall(function() task.cancel(DmgState.cooldownTimer) end) end
    setupDamageTracking()
end)

-- ============================================
-- KEYBINDS
-- ============================================
Keys = {
    TPDown = Enum.KeyCode.J, 
    AntiRagdoll = Enum.KeyCode.K, 
    Float = Enum.KeyCode.F, 
    AutoTPDown = Enum.KeyCode.T,
    RightSteal = Enum.KeyCode.G,
    LeftSteal = Enum.KeyCode.H,
}
KeyEnabled = {
    TPDown = true, AntiRagdoll = true,
    Float = true, AutoTPDown = true,
    RightSteal = true, LeftSteal = true,
}

UIS.InputBegan:Connect(function(input, gpe)
    if gpe or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    local k = input.KeyCode
    if KeyEnabled.TPDown and k == Keys.TPDown then
        ExecuteTPDown()
    elseif KeyEnabled.AntiRagdoll and k == Keys.AntiRagdoll then
        if State.AntiRagdoll then StopAntiRagdoll() else StartAntiRagdoll() end
    elseif KeyEnabled.Float and k == Keys.Float then
        if State.FloatEnabled then stopFloat() else startFloat() end
    elseif KeyEnabled.AutoTPDown and k == Keys.AutoTPDown then
        ToggleAutoTPDown()
    elseif KeyEnabled.RightSteal and k == Keys.RightSteal then
        stopStealPath()
        State.LeftSteal = false
        State.RightSteal = not State.RightSteal
        if State.RightSteal then startStealPath(stealPathRight) end
    elseif KeyEnabled.LeftSteal and k == Keys.LeftSteal then
        stopStealPath()
        State.RightSteal = false
        State.LeftSteal = not State.LeftSteal
        if State.LeftSteal then startStealPath(stealPathLeft) end
    end
end)

discordLink = "discord.gg/wsUuRQYVB"

-- ============================================
-- GUI
-- ============================================
gui = Instance.new("ScreenGui")
gui.Name = "H2N"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = LP:WaitForChild("PlayerGui")

-- INFO BAR
do
    local infoSG = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
    infoSG.Name = "H2N_InfoBar"
    infoSG.ResetOnSpawn = false
    infoSG.ZIndexBehavior = Enum.ZIndexBehavior.Global
    infoSG.DisplayOrder = 998

    local bar = Instance.new("Frame", infoSG)
    bar.Size = UDim2.new(0, 220, 0, 32)
    bar.Position = UDim2.new(0.5, -110, 0, -4)
    bar.BackgroundColor3 = T.Bg1
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 10)
    local barStroke = applySpinningGoldStroke(bar, 1.8, 1.2)
    local titleLbl = Instance.new("TextLabel", bar)
    titleLbl.Size = UDim2.new(1, 0, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "H2N"
    titleLbl.TextColor3 = T.Tx
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 16
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.TextYAlignment = Enum.TextYAlignment.Center
    titleLbl.ZIndex = 2
    local fpsLbl = Instance.new("TextLabel", bar)
    fpsLbl.Size = UDim2.new(0, 46, 0, 12)
    fpsLbl.Position = UDim2.new(0, 6, 1, -14)
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Text = "FPS:--"
    fpsLbl.TextColor3 = T.TxS
    fpsLbl.Font = Enum.Font.GothamBold
    fpsLbl.TextSize = 10
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
    fpsLbl.ZIndex = 2
    local discLbl = Instance.new("TextLabel", bar)
    discLbl.Size = UDim2.new(0, 108, 0, 12)
    discLbl.Position = UDim2.new(1, -113, 1, -14)
    discLbl.BackgroundTransparency = 1
    discLbl.Text = "discord.gg/wsUuRQYVB"
    discLbl.TextColor3 = T.TxD
    discLbl.Font = Enum.Font.GothamBold
    discLbl.TextSize = 9
    discLbl.TextXAlignment = Enum.TextXAlignment.Right
    discLbl.ZIndex = 2

    local fpsAcum, fpsFrames, fpsTimer = 0, 0, 0
    RunService.RenderStepped:Connect(function(dt)
        if dt <= 0 then return end
        fpsAcum = fpsAcum + (1/dt)
        fpsFrames = fpsFrames + 1
        fpsTimer = fpsTimer + dt
        if fpsTimer >= 0.5 then
            fpsLbl.Text = "FPS:" .. math.floor(fpsAcum / fpsFrames)
            fpsAcum = 0; fpsFrames = 0; fpsTimer = 0
        end
    end)
end

task.spawn(function()
    task.wait(0.1)
    for _, msg in ipairs(_notifyQueue) do
        Notify(msg)
        task.wait(0.3)
    end
    _notifyQueue = {}
end)

local menuW, menuH = 350, 350
local menu = nil
local numberBoxReferences = {}
local toggleUpdaters = {}

local CFG = "H2N_Config.json"

local function Save()
    local menuPos = {X=0.5, XO=0, Y=0.52, YO=0}
    if menu then
        menuPos = {X = menu.Position.X.Scale, XO = menu.Position.X.Offset, Y = menu.Position.Y.Scale, YO = menu.Position.Y.Offset}
    end
    local stealBarPos = {X=0.5, XO=-110, Y=1, YO=-45}
    if stealBarFrame and stealBarFrame.Parent then
        stealBarPos = {X = stealBarFrame.Position.X.Scale, XO = stealBarFrame.Position.X.Offset, Y = stealBarFrame.Position.Y.Scale, YO = stealBarFrame.Position.Y.Offset}
    end
    local data = {
        menuW = menuW, menuH = menuH, menuPos = menuPos, stealBarPos = stealBarPos,
        STEAL_RADIUS = STEAL_RADIUS, STEAL_DURATION = STEAL_DURATION,
        AP_WALK_SPEED = AP_WALK_SPEED, AP_STEAL_SPEED = AP_STEAL_SPEED,
        Keys = {
            TPDown = Keys.TPDown.Name, AntiRagdoll = Keys.AntiRagdoll.Name,
            Float = Keys.Float.Name, AutoTPDown = Keys.AutoTPDown.Name,
            RightSteal = Keys.RightSteal.Name, LeftSteal = Keys.LeftSteal.Name,
        },
        KeyEnabled = {
            TPDown = KeyEnabled.TPDown, AntiRagdoll = KeyEnabled.AntiRagdoll,
            Float = KeyEnabled.Float, AutoTPDown = KeyEnabled.AutoTPDown,
            RightSteal = KeyEnabled.RightSteal, LeftSteal = KeyEnabled.LeftSteal,
        },
        ST_AntiSentry = State.AntiSentry, ST_SpinBody = State.SpinBody,
        ST_AntiRagdoll = State.AntiRagdoll, ST_InfiniteJump = State.InfiniteJump,
        ST_FloatEnabled = State.FloatEnabled, ST_XrayBase = State.XrayBase,
        ST_ESP = State.ESP, ST_Optimizer = State.Optimizer,
        ST_SpamBat = SpamBatState.enabled, ST_BatAimbot = BatAimbotState.enabled,
        ST_BatAimbotSpeed = autoBatSpd, ST_AutoSteal = State.AutoSteal,
        TPSettings = {Enabled = TPSettings.Enabled, TPHeight = TPSettings.TPHeight},
        FloatRiseHeight = FLOAT_TARGET_HEIGHT,
    }
    SafeWriteFile(CFG, HttpService:JSONEncode(data))
end

local function Load()
    local raw = SafeReadFile(CFG)
    if not raw or raw == "" then return end
    local ok2, d = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok2 or type(d) ~= "table" then return end
    if d.menuW then menuW = d.menuW end
    if d.menuH then menuH = d.menuH end
    if d.STEAL_RADIUS then STEAL_RADIUS = d.STEAL_RADIUS end
    if d.STEAL_DURATION then STEAL_DURATION = d.STEAL_DURATION end
    if d.AP_WALK_SPEED then AP_WALK_SPEED = d.AP_WALK_SPEED end
    if d.AP_STEAL_SPEED then AP_STEAL_SPEED = d.AP_STEAL_SPEED end
    if type(d.Keys) == "table" then for k, v in pairs(d.Keys) do local e = Enum.KeyCode[v]; if e and Keys[k] ~= nil then Keys[k] = e end end end
    if type(d.KeyEnabled) == "table" then for k, v in pairs(d.KeyEnabled) do if KeyEnabled[k] ~= nil then KeyEnabled[k] = v end end end
    if d.ST_AntiSentry ~= nil then State.AntiSentry = d.ST_AntiSentry end
    if d.ST_SpinBody ~= nil then State.SpinBody = d.ST_SpinBody end
    if d.ST_AntiRagdoll ~= nil then State.AntiRagdoll = d.ST_AntiRagdoll end
    if d.ST_InfiniteJump ~= nil then State.InfiniteJump = d.ST_InfiniteJump end
    if d.ST_FloatEnabled ~= nil then State.FloatEnabled = d.ST_FloatEnabled end
    if d.ST_XrayBase ~= nil then State.XrayBase = d.ST_XrayBase end
    if d.ST_ESP ~= nil then State.ESP = d.ST_ESP end
    if d.ST_Optimizer ~= nil then State.Optimizer = d.ST_Optimizer end
    if d.ST_SpamBat ~= nil then SpamBatState.enabled = d.ST_SpamBat end
    if d.ST_BatAimbot ~= nil then BatAimbotState.enabled = d.ST_BatAimbot; if d.ST_BatAimbot then task.defer(StartBatAimbot) end end
    if d.ST_BatAimbotSpeed ~= nil then autoBatSpd = d.ST_BatAimbotSpeed end
    if d.ST_AutoSteal ~= nil then State.AutoSteal = d.ST_AutoSteal; if d.ST_AutoSteal then task.defer(startAutoSteal) end end
    if d.TPSettings then
        if d.TPSettings.Enabled ~= nil then TPSettings.Enabled = d.TPSettings.Enabled end
        if d.TPSettings.TPHeight then TPSettings.TPHeight = d.TPSettings.TPHeight end
    end
    if d.FloatRiseHeight then FLOAT_TARGET_HEIGHT = math.clamp(d.FloatRiseHeight, 1, 50) end
    if type(d.menuPos) == "table" then task.defer(function() if menu then menu.Position = UDim2.new(d.menuPos.X, d.menuPos.XO, d.menuPos.Y, d.menuPos.YO) end end) end
    if type(d.stealBarPos) == "table" then task.defer(function() if stealBarFrame then stealBarFrame.Position = UDim2.new(d.stealBarPos.X, d.stealBarPos.XO, d.stealBarPos.Y, d.stealBarPos.YO) end end) end
end

-- STEAL BAR
stealBarFrame = Instance.new("Frame", gui)
stealBarFrame.Name = "StealBar"
stealBarFrame.Size = UDim2.new(0, 220, 0, 28)
stealBarFrame.Position = UDim2.new(0.5, -110, 1, -45)
stealBarFrame.BackgroundColor3 = T.Bg2
stealBarFrame.BackgroundTransparency = 0.05
stealBarFrame.ZIndex = 50
stealBarFrame.Active = true
Instance.new("UICorner", stealBarFrame).CornerRadius = UDim.new(0, 10)
applySpinningGoldStroke(stealBarFrame, 1.8, 1.3)
addBgShimmer(stealBarFrame, 1.6, 0.88)

do
    local sbDrag, sbDS, sbPS, sbActiveInput = false, nil, nil, nil
    stealBarFrame.InputBegan:Connect(function(inp)
        local t = inp.UserInputType
        if (t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch) and not sbDrag then
            sbDrag = true; sbActiveInput = inp; sbDS = inp.Position; sbPS = stealBarFrame.Position
        end
    end)
    stealBarFrame.InputChanged:Connect(function(inp)
        if not sbDrag or inp ~= sbActiveInput then return end
        local t = inp.UserInputType
        if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then return end
        local d = inp.Position - sbDS
        stealBarFrame.Position = UDim2.new(sbPS.X.Scale, sbPS.X.Offset + d.X, sbPS.Y.Scale, sbPS.Y.Offset + d.Y)
    end)
    stealBarFrame.InputEnded:Connect(function(inp)
        local t = inp.UserInputType
        if (t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch) and inp == sbActiveInput then
            sbDrag = false; sbActiveInput = nil; Save()
        end
    end)
end

local sbLabel = Instance.new("TextLabel", stealBarFrame)
sbLabel.Size = UDim2.new(0, 80, 1, 0)
sbLabel.Position = UDim2.new(0, 6, 0, 0)
sbLabel.BackgroundTransparency = 1
sbLabel.Text = "READY"
sbLabel.TextColor3 = T.A
sbLabel.Font = Enum.Font.GothamBold
sbLabel.TextSize = 10
sbLabel.TextXAlignment = Enum.TextXAlignment.Left
sbLabel.ZIndex = 51
grabBarPercent = sbLabel

local sbBG = Instance.new("Frame", stealBarFrame)
sbBG.Size = UDim2.new(1, -120, 0, 10)
sbBG.Position = UDim2.new(0, 80, 0.5, -5)
sbBG.BackgroundColor3 = T.Bg0
sbBG.ZIndex = 51
Instance.new("UICorner", sbBG).CornerRadius = UDim.new(0, 5)

local sbFill = Instance.new("Frame", sbBG)
sbFill.Size = UDim2.new(0, 0, 1, 0)
sbFill.BackgroundColor3 = T.Br
sbFill.ZIndex = 52
Instance.new("UICorner", sbFill).CornerRadius = UDim.new(0, 6)
grabBarFill = sbFill

local sbPct = Instance.new("TextLabel", stealBarFrame)
sbPct.Size = UDim2.new(0, 28, 1, 0)
sbPct.Position = UDim2.new(1, -34, 0, 0)
sbPct.BackgroundTransparency = 1
sbPct.Text = ""
sbPct.TextColor3 = T.Tx
sbPct.Font = Enum.Font.GothamBold
sbPct.TextSize = 10
sbPct.ZIndex = 51

-- MENU BUTTON
local menuBtn = Instance.new("Frame", gui)
menuBtn.Size = UDim2.new(0, 110, 0, 44)
menuBtn.Position = UDim2.new(0.5, -55, 0.07, 0)
menuBtn.BackgroundColor3 = T.Bg3
menuBtn.BackgroundTransparency = 0
menuBtn.Active = true
menuBtn.ZIndex = 60
Instance.new("UICorner", menuBtn).CornerRadius = UDim.new(0, 12)
local mbStroke = applySpinningGoldStroke(menuBtn, 2, 1.8)

local menuBtnLabel = Instance.new("TextLabel", menuBtn)
menuBtnLabel.Size = UDim2.new(1, 0, 1, 0)
menuBtnLabel.BackgroundTransparency = 1
menuBtnLabel.Text = "H2N"
menuBtnLabel.TextColor3 = T.A
menuBtnLabel.Font = Enum.Font.GothamBlack
menuBtnLabel.TextSize = 19
menuBtnLabel.ZIndex = 61

local menuGlowOverlay = Instance.new("Frame", menuBtn)
menuGlowOverlay.Size = UDim2.new(1, 0, 1, 0)
menuGlowOverlay.BackgroundColor3 = T.D
menuGlowOverlay.BackgroundTransparency = 1
menuGlowOverlay.ZIndex = 60
menuGlowOverlay.BorderSizePixel = 0
Instance.new("UICorner", menuGlowOverlay).CornerRadius = UDim.new(0, 12)

task.spawn(function()
    local t = 0
    local purpleColors = {
        Color3.fromRGB(255, 215, 100), Color3.fromRGB(255, 245, 180),
        Color3.fromRGB(220, 165, 30), Color3.fromRGB(255, 200, 60),
        Color3.fromRGB(255, 255, 220),
    }
    while true do
        t = t + 0.04
        local ci = math.floor(t * 1.5) % #purpleColors + 1
        local cn = ci % #purpleColors + 1
        local f = (t * 1.5) % 1
        local col = purpleColors[ci]:Lerp(purpleColors[cn], f)
        menuBtnLabel.TextColor3 = col
        mbStroke.Color = col
        local shimmer = math.abs(math.sin(t * 2.5))
        menuGlowOverlay.BackgroundTransparency = 1 - (shimmer * 0.13)
        task.wait(0.04)
    end
end)

do
    local mbDragging, mbMoved, mbDragStart, mbStartPos, mbActiveInput = false, false, nil, nil, nil
    menuBtn.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if (t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseButton1) and not mbDragging then
            mbDragging = true; mbMoved = false; mbActiveInput = input; mbDragStart = input.Position; mbStartPos = menuBtn.Position
        end
    end)
    menuBtn.InputChanged:Connect(function(input)
        if not mbDragging or input ~= mbActiveInput then return end
        local t = input.UserInputType
        if t ~= Enum.UserInputType.Touch and t ~= Enum.UserInputType.MouseMovement then return end
        local delta = input.Position - mbDragStart
        if delta.Magnitude > 6 then
            mbMoved = true
            menuBtn.Position = UDim2.new(mbStartPos.X.Scale, mbStartPos.X.Offset + delta.X, mbStartPos.Y.Scale, mbStartPos.Y.Offset + delta.Y)
        end
    end)
    menuBtn.InputEnded:Connect(function(input)
        local t = input.UserInputType
        if (t ~= Enum.UserInputType.Touch and t ~= Enum.UserInputType.MouseButton1) then return end
        if input ~= mbActiveInput then return end
        local didMove = mbMoved; mbDragging = false; mbMoved = false; mbActiveInput = nil
        if not didMove then
            if menu.Visible then menu.Visible = false else menu.Size = UDim2.new(0, menuW, 0, menuH); menu.BackgroundTransparency = 0; menu.Visible = true end
        else Save() end
    end)
end

-- MAIN MENU
menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, menuW, 0, menuH)
menu.Position = UDim2.new(0.5, -menuW/2, 0.5, -menuH/2)
menu.BackgroundColor3 = T.Bg1
menu.BackgroundTransparency = 0
menu.Visible = false
menu.Active = true
menu.ZIndex = 55
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 14)
applySpinningGoldStroke(menu, 2.2, 1.6)
addBgShimmer(menu, 1.1, 0.83)

local header = Instance.new("Frame", menu)
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = T.ON
header.BackgroundTransparency = 0
header.BorderSizePixel = 0
header.ZIndex = 56
local hCorner = Instance.new("UICorner", header); hCorner.CornerRadius = UDim.new(0, 14)
local hFix = Instance.new("Frame", header); hFix.Size = UDim2.new(1, 0, 0.5, 0); hFix.Position = UDim2.new(0, 0, 0.5, 0); hFix.BackgroundColor3 = T.ON; hFix.BorderSizePixel = 0; hFix.ZIndex = 56
addBgShimmer(header, 2.0, 0.62)

local tl = Instance.new("TextLabel", header)
tl.Size = UDim2.new(1, -20, 1, 0); tl.Position = UDim2.new(0, 14, 0, 0); tl.BackgroundTransparency = 1
tl.Text = "H2N v6.0"; tl.TextColor3 = Color3.fromRGB(255, 240, 195); tl.Font = Enum.Font.GothamBlack; tl.TextSize = 17
tl.TextXAlignment = Enum.TextXAlignment.Left; tl.ZIndex = 57

do
    local dragging, dragStart, startPos, activeInput = false, nil, nil, nil
    header.InputBegan:Connect(function(input)
        local t = input.UserInputType
        if (t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch) and not dragging then
            dragging = true; activeInput = input; dragStart = input.Position; startPos = menu.Position
        end
    end)
    header.InputChanged:Connect(function(input)
        if not dragging or input ~= activeInput then return end
        local t = input.UserInputType
        if t ~= Enum.UserInputType.MouseMovement and t ~= Enum.UserInputType.Touch then return end
        local delta = input.Position - dragStart
        menu.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end)
    header.InputEnded:Connect(function(input)
        local t = input.UserInputType
        if (t ~= Enum.UserInputType.MouseButton1 and t ~= Enum.UserInputType.Touch) then return end
        if input ~= activeInput then return end
        dragging = false; activeInput = nil; Save()
    end)
end

local tabBar = Instance.new("Frame", menu)
tabBar.Size = UDim2.new(0, 108, 1, -48); tabBar.Position = UDim2.new(0, 6, 0, 48)
tabBar.BackgroundColor3 = T.Bg2; tabBar.BackgroundTransparency = 0; tabBar.ZIndex = 56
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 10)
applySpinningGoldStroke(tabBar, 1.5, 0.9)

local tabNames = {"Combat", "Protect", "Visual", "Settings"}
local tabFrames = {}
local tabBtns = {}

for i, name in ipairs(tabNames) do
    local tb = Instance.new("TextButton", tabBar)
    tb.Size = UDim2.new(1, -12, 0, 38); tb.Position = UDim2.new(0, 6, 0, (i-1)*44+8)
    tb.BackgroundColor3 = T.Bg3; tb.Text = name; tb.TextColor3 = T.TxD
    tb.Font = Enum.Font.GothamBold; tb.TextSize = 13; tb.ZIndex = 57
    tb.TextXAlignment = Enum.TextXAlignment.Left; tb.AutoButtonColor = false
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 8)
    applySpinningGoldStroke(tb, 1.2, 1.0)
    local pad = Instance.new("UIPadding", tb); pad.PaddingLeft = UDim.new(0, 8)
    tabBtns[name] = tb
    local sf = Instance.new("ScrollingFrame", menu)
    sf.Size = UDim2.new(1, -124, 1, -50); sf.Position = UDim2.new(0, 118, 0, 48)
    sf.BackgroundTransparency = 1; sf.Visible = (i==1)
    sf.ScrollBarThickness = 3; sf.ScrollBarImageColor3 = T.Br
    sf.CanvasSize = UDim2.new(0, 0, 0, 0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y; sf.ZIndex = 57
    tabFrames[name] = sf
    tb.MouseButton1Click:Connect(function()
        for _, f in pairs(tabFrames) do f.Visible = false end
        for _, b in pairs(tabBtns) do b.BackgroundColor3 = T.Bg3; b.TextColor3 = T.TxD end
        sf.Visible = true; tb.BackgroundColor3 = T.ON; tb.TextColor3 = T.A
    end)
end
tabBtns["Combat"].BackgroundColor3 = T.ON; tabBtns["Combat"].TextColor3 = T.A

local function MakeToggle(parent, text, order, cb, getState, featureName)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -10, 0, 40); row.Position = UDim2.new(0, 5, 0, order*44+4)
    row.BackgroundColor3 = T.Bg3; row.BackgroundTransparency = 0; row.ZIndex = 58
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    applySpinningGoldStroke(row, 1.2, 1.1); addBgShimmer(row, 1.0, 0.91)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.58, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = T.Tx; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, 70, 0, 26); btn.Position = UDim2.new(1, -78, 0.5, -13)
    btn.BackgroundColor3 = T.OFF; btn.BackgroundTransparency = 0; btn.Text = "OFF"; btn.TextColor3 = T.TxD
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 12; btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    local btnStk = applySpinningGoldStroke(btn, 1.2, 1.3); addBgShimmer(btn, 1.3, 0.87)
    local function UpdateButton()
        if getState() then btn.Text = "ON"; btn.BackgroundColor3 = T.ON; btn.TextColor3 = T.Bg0; btnStk.Thickness = 2
        else btn.Text = "OFF"; btn.BackgroundColor3 = T.OFF; btn.TextColor3 = T.TxD; btnStk.Thickness = 1.2 end
    end
    UpdateButton()
    btn.MouseButton1Click:Connect(function() cb(not getState()); UpdateButton(); Save() end)
    RunService.RenderStepped:Connect(UpdateButton)
    if featureName then toggleUpdaters[featureName] = function(state) cb(state); UpdateButton() end end
    return btn
end

local function MakeNumberBox(parent, text, default, order, cb, minVal, maxVal, id)
    minVal = minVal or 1; maxVal = maxVal or 200
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -10, 0, 40); row.Position = UDim2.new(0, 5, 0, order*44+4)
    row.BackgroundColor3 = T.Bg3; row.BackgroundTransparency = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    applySpinningGoldStroke(row, 1.2, 1.1); addBgShimmer(row, 1.0, 0.91)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.55, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = text; lbl.TextColor3 = T.Tx; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0, 70, 0, 26); box.Position = UDim2.new(1, -78, 0.5, -13)
    box.BackgroundColor3 = T.Bg4; box.BackgroundTransparency = 0; box.Text = tostring(default)
    box.TextColor3 = T.Tx; box.Font = Enum.Font.GothamBold; box.TextSize = 15
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 7)
    applySpinningGoldStroke(box, 1.2, 1.4); addBgShimmer(box, 1.4, 0.87)
    if id then numberBoxReferences[id] = {TextBox = box, cb = cb, minVal = minVal, maxVal = maxVal} end
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then n = math.clamp(n, minVal, maxVal); cb(n); box.Text = tostring(n)
        else box.Text = tostring(default) end
        Save()
    end)
    return box
end

local function MakeKeybind(parent, labelText, keyName, order)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1, -10, 0, 40); row.Position = UDim2.new(0, 5, 0, order*44+4)
    row.BackgroundColor3 = T.Bg3; row.BackgroundTransparency = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    applySpinningGoldStroke(row, 1.2, 1.0); addBgShimmer(row, 1.0, 0.91)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.46, 0, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1
    lbl.Text = labelText; lbl.TextColor3 = T.Tx; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12; lbl.TextXAlignment = Enum.TextXAlignment.Left
    local keyBtn = Instance.new("TextButton", row)
    keyBtn.Size = UDim2.new(0, 52, 0, 26); keyBtn.Position = UDim2.new(0.47, 0, 0.5, -13)
    keyBtn.BackgroundColor3 = T.Bg4; keyBtn.BackgroundTransparency = 0; keyBtn.Text = Keys[keyName] and Keys[keyName].Name or "?"
    keyBtn.TextColor3 = T.Tx; keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 11; keyBtn.AutoButtonColor = false
    Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 7)
    applySpinningGoldStroke(keyBtn, 1.2, 1.5); addBgShimmer(keyBtn, 1.5, 0.87)
    local enableBtn = Instance.new("TextButton", row)
    enableBtn.Size = UDim2.new(0, 52, 0, 26); enableBtn.Position = UDim2.new(1, -60, 0.5, -13)
    enableBtn.BackgroundColor3 = KeyEnabled[keyName] and T.ON or T.Err
    enableBtn.Text = KeyEnabled[keyName] and "ON" or "OFF"; enableBtn.TextColor3 = T.Tx
    enableBtn.Font = Enum.Font.GothamBold; enableBtn.TextSize = 11; enableBtn.AutoButtonColor = false
    Instance.new("UICorner", enableBtn).CornerRadius = UDim.new(0, 7)
    applySpinningGoldStroke(enableBtn, 1.2, 1.7); addBgShimmer(enableBtn, 1.7, 0.87)
    local listening = false; local listenConn
    keyBtn.MouseButton1Click:Connect(function()
        if listening then return end
        listening = true; keyBtn.Text = "..."; keyBtn.BackgroundColor3 = T.Bg4
        if listenConn then listenConn:Disconnect() end
        listenConn = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                Keys[keyName] = input.KeyCode; keyBtn.Text = input.KeyCode.Name; keyBtn.BackgroundColor3 = T.Bg4
                listening = false; listenConn:Disconnect()
                Notify("Key "..labelText.." = "..input.KeyCode.Name); Save()
            end
        end)
    end)
    enableBtn.MouseButton1Click:Connect(function()
        KeyEnabled[keyName] = not KeyEnabled[keyName]
        enableBtn.Text = KeyEnabled[keyName] and "ON" or "OFF"
        enableBtn.BackgroundColor3 = KeyEnabled[keyName] and T.ON or T.Err; Save()
    end)
end


-- ============================================================
-- MOBILE BUTTON PANEL
-- ============================================================
local MB_BTN_SIZE = 68
local MB_PAD      = 8
local MB_CORNER   = 16

local MB_COLS = 2
local MB_ROWS = 3

local MB_W = MB_COLS * MB_BTN_SIZE + (MB_COLS + 1) * MB_PAD
local MB_H = MB_ROWS * MB_BTN_SIZE + (MB_ROWS + 1) * MB_PAD

local mbPanel = Instance.new("Frame", gui)
mbPanel.Name             = "MobilePanel"
mbPanel.Size             = UDim2.new(0, MB_W, 0, MB_H)
mbPanel.Position         = UDim2.new(1, -(MB_W + 16), 0.5, -(MB_H / 2))
mbPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
mbPanel.BackgroundTransparency = 0
mbPanel.BorderSizePixel  = 0
mbPanel.Active           = true
mbPanel.ZIndex           = 50

local mbCorner = Instance.new("UICorner", mbPanel)
mbCorner.CornerRadius = UDim.new(0, MB_CORNER + 4)

local mbStroke = applySpinningGoldStroke(mbPanel, 2, 1.8)
addBgShimmer(mbPanel, 1.5, 0.85)

do
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    mbPanel.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = inp.Position; startPos = mbPanel.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    mbPanel.InputChanged:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragInput = inp
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if inp == dragInput and dragging then
            local d = inp.Position - dragStart
            mbPanel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                         startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local mbState = { autoRight = false, autoLeft = false, autoBat = false }
local mbRefresh = {}

local function getBtnPosition(row, col, colSpan)
    colSpan = colSpan or 1
    local x = MB_PAD + col * (MB_BTN_SIZE + MB_PAD)
    local y = MB_PAD + row * (MB_BTN_SIZE + MB_PAD)
    local w = colSpan * MB_BTN_SIZE + (colSpan - 1) * MB_PAD
    return x, y, w, MB_BTN_SIZE
end

local function makeMobileBtn(label, row, col, colSpan, onClick)
    colSpan = colSpan or 1
    local x, y, w, h = getBtnPosition(row, col, colSpan)

    local btn = Instance.new("TextButton", mbPanel)
    btn.Size             = UDim2.new(0, w, 0, h)
    btn.Position         = UDim2.new(0, x, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    btn.BorderSizePixel  = 0
    btn.Text             = ""
    btn.ZIndex           = 52
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, MB_CORNER)

    local bs = Instance.new("UIStroke", btn)
    bs.Color     = Color3.fromRGB(0, 0, 0)
    bs.Thickness = 2

    local chrome = Instance.new("Frame", btn)
    chrome.Size                   = UDim2.new(1, 0, 1, 0)
    chrome.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    chrome.BackgroundTransparency = 0.70
    chrome.BorderSizePixel        = 0
    chrome.ZIndex                 = 53
    Instance.new("UICorner", chrome).CornerRadius = UDim.new(0, MB_CORNER)
    local chromeGrad = Instance.new("UIGradient", chrome)
    chromeGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 220, 80)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(200, 160, 40)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(80,  60,  10)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(30,  22,  4)),
        ColorSequenceKeypoint.new(1,    Color3.fromRGB(12,  9,   2)),
    })
    chromeGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,    0.40),
        NumberSequenceKeypoint.new(0.28, 0.55),
        NumberSequenceKeypoint.new(0.52, 0.65),
        NumberSequenceKeypoint.new(0.75, 0.55),
        NumberSequenceKeypoint.new(1,    0.45),
    })
    chromeGrad.Rotation = 145

    local topGlow = Instance.new("Frame", btn)
    topGlow.Size                   = UDim2.new(0.65, 0, 0, 2)
    topGlow.Position               = UDim2.new(0.175, 0, 0, 2)
    topGlow.BackgroundColor3       = Color3.fromRGB(240, 240, 240)
    topGlow.BackgroundTransparency = 0.45
    topGlow.BorderSizePixel        = 0
    topGlow.ZIndex                 = 54
    Instance.new("UICorner", topGlow).CornerRadius = UDim.new(0, 2)

    local lbl = Instance.new("TextLabel", btn)
    lbl.Size                   = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text                   = label
    lbl.TextColor3             = Color3.fromRGB(255, 215, 80)
    lbl.Font                   = Enum.Font.GothamBlack
    lbl.TextSize               = 13
    lbl.TextWrapped            = true
    lbl.TextXAlignment         = Enum.TextXAlignment.Center
    lbl.TextYAlignment         = Enum.TextYAlignment.Center
    lbl.ZIndex                 = 56
    lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0.45

    local BG_IDLE  = Color3.fromRGB(8, 8, 8)
    local BG_PRESS = Color3.fromRGB(40, 30, 0)
    local BG_HOVER = Color3.fromRGB(22, 18, 4)
    local BG_ON    = Color3.fromRGB(35, 26, 0)
    local GOLD     = Color3.fromRGB(255, 215, 80)

    local btnStroke = applySpinningGoldStroke(btn, 1.8, 1.4)

    btn.MouseButton1Down:Connect(function()
        TweenService:Create(btn,    TweenInfo.new(0.05), {BackgroundColor3 = BG_PRESS}):Play()
        TweenService:Create(chrome, TweenInfo.new(0.05), {BackgroundTransparency = 0.90}):Play()
    end)
    btn.MouseButton1Up:Connect(function()
        TweenService:Create(btn,    TweenInfo.new(0.10), {BackgroundColor3 = BG_IDLE}):Play()
        TweenService:Create(chrome, TweenInfo.new(0.10), {BackgroundTransparency = 0.60}):Play()
    end)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_HOVER}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = BG_IDLE}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if onClick then pcall(onClick) end
    end)

    local function refreshColor(isOn)
        TweenService:Create(btn, TweenInfo.new(0.18),
            {BackgroundColor3 = isOn and BG_ON or BG_IDLE}):Play()
        lbl.TextColor3 = isOn and GOLD or Color3.fromRGB(245, 245, 245)
    end

    return btn, refreshColor
end

-- الصف الأول: AUTO RIGHT | AUTO LEFT
local _, rfAutoRight = makeMobileBtn("AUTO\nRIGHT", 0, 0, 1, function()
    if mbState.autoLeft then
        mbState.autoLeft = false
        stopStealPath(); State.LeftSteal = false
        if mbRefresh.autoLeft then mbRefresh.autoLeft(false) end
    end
    if mbState.autoBat then
        mbState.autoBat = false
        StopBatAimbot()
        if mbRefresh.autoBat then mbRefresh.autoBat(false) end
    end
    mbState.autoRight = not mbState.autoRight
    State.RightSteal  = mbState.autoRight
    if mbState.autoRight then
        startStealPath(stealPathRight)
    else
        stopStealPath()
    end
    if mbRefresh.autoRight then mbRefresh.autoRight(mbState.autoRight) end
end)
mbRefresh.autoRight = rfAutoRight

local _, rfAutoLeft = makeMobileBtn("AUTO\nLEFT", 0, 1, 1, function()
    if mbState.autoRight then
        mbState.autoRight = false
        stopStealPath(); State.RightSteal = false
        if mbRefresh.autoRight then mbRefresh.autoRight(false) end
    end
    if mbState.autoBat then
        mbState.autoBat = false
        StopBatAimbot()
        if mbRefresh.autoBat then mbRefresh.autoBat(false) end
    end
    mbState.autoLeft = not mbState.autoLeft
    State.LeftSteal  = mbState.autoLeft
    if mbState.autoLeft then
        startStealPath(stealPathLeft)
    else
        stopStealPath()
    end
    if mbRefresh.autoLeft then mbRefresh.autoLeft(mbState.autoLeft) end
end)
mbRefresh.autoLeft = rfAutoLeft

-- الصف الثاني: AUTO BAT | DROP
local _, rfAutoBat = makeMobileBtn("AUTO\nBAT", 1, 0, 1, function()
    if mbState.autoRight then
        mbState.autoRight = false
        stopStealPath(); State.RightSteal = false
        if mbRefresh.autoRight then mbRefresh.autoRight(false) end
    end
    if mbState.autoLeft then
        mbState.autoLeft = false
        stopStealPath(); State.LeftSteal = false
        if mbRefresh.autoLeft then mbRefresh.autoLeft(false) end
    end
    mbState.autoBat = not mbState.autoBat
    if mbState.autoBat then
        StartBatAimbot()
    else
        StopBatAimbot()
    end
    if mbRefresh.autoBat then mbRefresh.autoBat(mbState.autoBat) end
end)
mbRefresh.autoBat = rfAutoBat

makeMobileBtn("DROP", 1, 1, 1, function()
    task.spawn(executeDrop)
end)

-- الصف الثالث: TP DOWN
makeMobileBtn("TP DOWN", 2, 0, 2, function()
    task.spawn(ExecuteTPDown)
end)

-- COMBAT TAB
local ci = 0
local combat = tabFrames["Combat"]
MakeToggle(combat, "RIGHT STEAL (G)", ci, function(s)
    stopStealPath(); State.LeftSteal = false
    State.RightSteal = s; if s then startStealPath(stealPathRight) end
end, function() return State.RightSteal end, "RightSteal")
ci = ci + 1
MakeToggle(combat, "LEFT STEAL (H)", ci, function(s)
    stopStealPath(); State.RightSteal = false
    State.LeftSteal = s; if s then startStealPath(stealPathLeft) end
end, function() return State.LeftSteal end, "LeftSteal")
ci = ci + 1
MakeToggle(combat, "AUTO STEAL", ci, function(s)
    State.AutoSteal = s
    if s then startAutoSteal() else stopAutoSteal() end
end, function() return State.AutoSteal end, "AutoSteal")
ci = ci + 1
MakeNumberBox(combat, "Steal Radius", STEAL_RADIUS, ci, function(v) STEAL_RADIUS = math.clamp(v, 1, 200) end, 1, 200, "StealRadius")
ci = ci + 1
MakeNumberBox(combat, "Steal Duration", STEAL_DURATION, ci, function(v) STEAL_DURATION = math.clamp(v, 0.05, 5) end, 0.05, 5, "StealDuration")
ci = ci + 1
MakeNumberBox(combat, "Walk Speed", AP_WALK_SPEED, ci, function(v) AP_WALK_SPEED = math.clamp(v, 10, 150) end, 10, 150, "WalkSpeed")
ci = ci + 1
MakeNumberBox(combat, "Steal Speed", AP_STEAL_SPEED, ci, function(v) AP_STEAL_SPEED = math.clamp(v, 10, 80) end, 10, 80, "StealSpeed")
ci = ci + 1
MakeToggle(combat, "ANTI SENTRY", ci, function(s) if s then StartAntiSentry() else StopAntiSentry() end end, function() return State.AntiSentry end, "AntiSentry")
ci = ci + 1
MakeToggle(combat, "SPIN BODY", ci, function(s) if s then StartSpinBody() else StopSpinBody() end end, function() return State.SpinBody end, "SpinBody")
ci = ci + 1
MakeToggle(combat, "DROP", ci, function(s) if s then executeDrop() end end, function() return false end, "DROP")
ci = ci + 1
MakeToggle(combat, "SPAM BAT", ci, function(s) if s then StartSpamBat() else StopSpamBat() end end, function() return SpamBatState.enabled end, "SpamBat")
ci = ci + 1
MakeToggle(combat, "AUTO BAT", ci, function(s) if s then StartBatAimbot() else StopBatAimbot() end end, function() return BatAimbotState.enabled end, "AutoBat")
ci = ci + 1
MakeNumberBox(combat, "Bat Speed", autoBatSpd, ci, function(v) autoBatSpd = math.clamp(v, 10, 300) end, 10, 300, "BatAimbotSpeed")
ci = ci + 1
MakeToggle(combat, "ANTI LAG", ci, function(s) if s then startOptimizer() else stopOptimizer() end end, function() return State.Optimizer end, "Optimizer")
ci = ci + 1
MakeToggle(combat, "SPEED BOOST", ci, function(s) if s then startSpeedBoost() else stopSpeedBoost() end end, function() return State.SpeedBoost end, "SpeedBoost")
ci = ci + 1
MakeNumberBox(combat, "Boost Speed", SPEED_BOOST_VAL, ci, function(v) SPEED_BOOST_VAL = math.clamp(v, 16, 150) end, 16, 150, "SpeedBoostVal")

-- PROTECT TAB
local pi = 0
local protect = tabFrames["Protect"]
MakeToggle(protect, "ANTI RAGDOLL", pi, function(s) if s then StartAntiRagdoll() else StopAntiRagdoll() end end, function() return State.AntiRagdoll end, "AntiRagdoll")
pi = pi + 1
MakeToggle(protect, "INFINITE JUMP", pi, function(s) if s then StartInfiniteJump() else StopInfiniteJump() end end, function() return State.InfiniteJump end, "InfiniteJump")
pi = pi + 1
MakeToggle(protect, "FLOAT", pi, function(s) if s then startFloat() else stopFloat() end end, function() return State.FloatEnabled end, "FloatEnabled")
pi = pi + 1
MakeNumberBox(protect, "Float Height", FLOAT_TARGET_HEIGHT, pi, function(v) FLOAT_TARGET_HEIGHT = math.clamp(v, 1, 50) end, 1, 50, "FloatHeight")
pi = pi + 1
MakeToggle(protect, "AUTO TP DOWN", pi, function(s) if s then TPSettings.Enabled = true; StartTPMonitoring() else ToggleAutoTPDown() end end, function() return TPSettings.Enabled end, "AutoTPDown")
pi = pi + 1
MakeNumberBox(protect, "TP Down Height", TPSettings.TPHeight, pi, function(v) TPSettings.TPHeight = math.clamp(v, 1, 500) end, 1, 500, "TPHeight")
pi = pi + 1
MakeToggle(protect, "TP DOWN", pi, function(s) if s then ExecuteTPDown() end end, function() return false end, "TPDown")

-- VISUAL TAB
local vi = 0
local visual = tabFrames["Visual"]
MakeToggle(visual, "ESP", vi, function(s) if s then StartESP() else StopESP() end end, function() return State.ESP end, "ESP")
vi = vi + 1
MakeToggle(visual, "XRAY BASE", vi, function(s) if s then StartXrayBase() else StopXrayBase() end end, function() return State.XrayBase end, "XrayBase")
vi = vi + 1
MakeNumberBox(visual, "Menu Width", menuW, vi, function(v) menuW = math.clamp(v, 200, 750); menu.Size = UDim2.new(0, menuW, 0, menuH) end, 200, 750, "MenuWidth")
vi = vi + 1
MakeNumberBox(visual, "Menu Height", menuH, vi, function(v) menuH = math.clamp(v, 200, 750); menu.Size = UDim2.new(0, menuW, 0, menuH) end, 200, 750, "MenuHeight")

-- SETTINGS TAB
local si = 0
local sTab = tabFrames["Settings"]
local copyBtn = Instance.new("TextButton", sTab)
copyBtn.Size = UDim2.new(1, -10, 0, 40); copyBtn.Position = UDim2.new(0, 5, 0, si*44+4)
copyBtn.BackgroundColor3 = T.ON; copyBtn.AutoButtonColor = false
copyBtn.Text = "COPY DISCORD LINK"; copyBtn.TextColor3 = T.Tx
copyBtn.Font = Enum.Font.GothamBold; copyBtn.TextSize = 13
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)
copyBtn.MouseButton1Click:Connect(function()
    setclipboard("discord.gg/wsUuRQYVB")
    Notify("Discord link copied!")
end)
si = si + 1
local sep = Instance.new("Frame", sTab)
sep.Size = UDim2.new(1, -10, 0, 28); sep.Position = UDim2.new(0, 5, 0, si*44+4)
sep.BackgroundColor3 = T.Bg3; sep.BackgroundTransparency = 0
Instance.new("UICorner", sep).CornerRadius = UDim.new(0, 6)
local sepLbl = Instance.new("TextLabel", sep)
sepLbl.Size = UDim2.new(1, 0, 1, 0); sepLbl.BackgroundTransparency = 1
sepLbl.Text = "KEYBINDS"; sepLbl.TextColor3 = T.A; sepLbl.Font = Enum.Font.GothamBold; sepLbl.TextSize = 13
si = si + 1
MakeKeybind(sTab, "TP Down (J)", "TPDown", si); si = si + 1
MakeKeybind(sTab, "Right Steal (G)", "RightSteal", si); si = si + 1
MakeKeybind(sTab, "Left Steal (H)", "LeftSteal", si); si = si + 1
MakeKeybind(sTab, "Anti Ragdoll (K)", "AntiRagdoll", si); si = si + 1
MakeKeybind(sTab, "Float (F)", "Float", si); si = si + 1
MakeKeybind(sTab, "Auto TP Down (T)", "AutoTPDown", si)

-- INITIALIZATION
RunService.Heartbeat:Connect(function(dt)
    if State.AntiSentry then updateAntiSentry() end
    if State.ESP then updateESP() end
end)

Load()
menu.Size = UDim2.new(0, menuW, 0, menuH)

task.spawn(function()
    task.wait(1)
    setupDamageTracking()
end)

task.spawn(function()
    while not (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character:FindFirstChildOfClass("Humanoid")) do
        task.wait(0.2)
    end
    task.wait(0.5)
    
    local savedSentry = State.AntiSentry; local savedSpin = State.SpinBody
    local savedRagdoll = State.AntiRagdoll; local savedJump = State.InfiniteJump
    local savedFloat = State.FloatEnabled; local savedXray = State.XrayBase
    local savedESP = State.ESP; local savedTP = TPSettings.Enabled
    local savedOptimizer = State.Optimizer; local savedSpamBat = SpamBatState.enabled
    local savedBatAimbot = BatAimbotState.enabled; local savedAutoSteal = State.AutoSteal
    local savedSpeedBoost = State.SpeedBoost

    State.AntiSentry = false; State.SpinBody = false; State.InfiniteJump = false
    State.FloatEnabled = false; State.XrayBase = false; State.ESP = false
    State.AntiRagdoll = false; State.Optimizer = false; TPSettings.Enabled = false
    SpamBatState.enabled = false; State.AutoSteal = false; State.SpeedBoost = false
    if BatAimbotState.enabled then StopBatAimbot() end
    if SpeedBoostConn then SpeedBoostConn:Disconnect(); SpeedBoostConn = nil end
    StopTPMonitoring()
    
    local function safeStart(fn, name)
        task.spawn(function() pcall(function() fn(); print("Auto-activated: "..name) end) end)
        task.wait(0.05)
    end
    
    if savedSentry then safeStart(StartAntiSentry, "Anti Sentry") end
    if savedSpin then safeStart(StartSpinBody, "Spin Body") end
    if savedRagdoll then safeStart(StartAntiRagdoll, "Anti Ragdoll") end
    if savedJump then safeStart(StartInfiniteJump, "Infinite Jump") end
    if savedFloat then safeStart(startFloat, "Float") end
    if savedXray then safeStart(StartXrayBase, "Xray Base") end
    if savedESP then safeStart(StartESP, "ESP") end
    if savedOptimizer then safeStart(startOptimizer, "Anti Lag")
    elseif isMobile and not savedOptimizer then safeStart(startOptimizer, "Anti Lag (Auto Mobile)") end
    if savedSpamBat then safeStart(StartSpamBat, "Spam Bat") end
    if savedBatAimbot then safeStart(StartBatAimbot, "Auto Bat") end
    if savedAutoSteal then safeStart(startAutoSteal, "Auto Steal") end
    if savedSpeedBoost then safeStart(startSpeedBoost, "Speed Boost") end
    
    if savedTP then TPSettings.Enabled = true; StartTPMonitoring() end
    
    task.wait(0.3)
end)

Notify("H2N v6.0 LOADED")
print("===============================================================")
print("H2N v6.0 - ENHANCED EDITION")
print("Auto Play from Silent + Auto Steal from OR")
print("===============================================================")