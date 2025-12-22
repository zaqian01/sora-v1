-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser") -- Untuk Anti-AFK

local player = Players.LocalPlayer

-- ================= ANTI AFK (SILENT) =================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_V3"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 380) -- Ukuran pas untuk semua tombol
frame.Position = UDim2.fromScale(0.05, 0.2)
frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- ================= HEADER =================
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(25,25,25)

Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,-50,1,0)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "SORA PREMIUM"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(0,255,180)

local minimize = Instance.new("TextButton", header)
minimize.Size = UDim2.fromOffset(36,26)
minimize.Position = UDim2.new(1, -10, 0.5, 0)
minimize.AnchorPoint = Vector2.new(1,0.5)
minimize.BackgroundColor3 = Color3.fromRGB(40,40,40)
minimize.Text = "–"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 22
minimize.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- ================= CONTENT CONTAINER =================
local contentFrame = Instance.new("Frame", frame)
contentFrame.Position = UDim2.fromOffset(0,40)
contentFrame.Size = UDim2.new(1,0,1,-40)
contentFrame.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", contentFrame)
listLayout.Padding = UDim.new(0,8)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ================= PLAYER LIST PANEL (UI BARU) =================
local playerListOpen = false
local playerListFrame = Instance.new("Frame", frame)
playerListFrame.Size = UDim2.fromOffset(260, 240)
playerListFrame.Position = UDim2.fromScale(0.5, 0.53)
playerListFrame.AnchorPoint = Vector2.new(0.5, 0.5)
playerListFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
playerListFrame.BorderSizePixel = 0
playerListFrame.Visible = false
playerListFrame.ZIndex = 20
Instance.new("UICorner", playerListFrame).CornerRadius = UDim.new(0,10)

local plTitle = Instance.new("TextLabel", playerListFrame)
plTitle.Size = UDim2.new(1,0,0,35)
plTitle.Text = "Teleport To Player"
plTitle.Font = Enum.Font.GothamBold
plTitle.TextSize = 14
plTitle.TextColor3 = Color3.fromRGB(0,255,180)
plTitle.BackgroundTransparency = 1

local closeBtn = Instance.new("TextButton", playerListFrame)
closeBtn.Size = UDim2.fromOffset(30,24)
closeBtn.Position = UDim2.new(1, -5, 0, 5)
closeBtn.AnchorPoint = Vector2.new(1,0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150,50,50)
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)

local scroll = Instance.new("ScrollingFrame", playerListFrame)
scroll.Position = UDim2.fromOffset(10,40)
scroll.Size = UDim2.new(1,-20,1,-50)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 4

local scrollList = Instance.new("UIListLayout", scroll)
scrollList.Padding = UDim.new(0,5)

-- ================= UTILS =================
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function createBtn(text)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(280, 36)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.Text = text
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

-- ================= REFRESH PLAYER LIST FUNCTION =================
local function refreshPlayerList()
    for _,c in pairs(scroll:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local b = Instance.new("TextButton", scroll)
            b.Size = UDim2.new(1, 0, 0, 30)
            b.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
            b.Font = Enum.Font.Gotham
            b.TextSize = 12
            b.TextColor3 = Color3.new(1,1,1)
            b.BackgroundColor3 = Color3.fromRGB(45,45,45)
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)

            b.MouseButton1Click:Connect(function()
                local hrp = HRP()
                local char = plr.Character
                local targetHRP = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and targetHRP then
                    hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
                end
                playerListFrame.Visible = false
                playerListOpen = false
            end)
        end
    end
end

-- ================= FEATURE BUTTONS =================

-- 1. MINIMIZE
local minimized = false
local fullSize = frame.Size
local miniSize = UDim2.fromOffset(300, 40)
minimize.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame:TweenSize(minimized and miniSize or fullSize, "Out", "Quad", 0.2, true)
    contentFrame.Visible = not minimized
    minimize.Text = minimized and "+" or "–"
end)

-- 2. FLY
local fly, speed, bv, bg = false, 60, nil, nil
local keys = {W=false, A=false, S=false, D=false, Space=false, Ctrl=false}
local flyBtn = createBtn("Fly: OFF")

flyBtn.MouseButton1Click:Connect(function()
    fly = not fly
    flyBtn.Text = fly and "Fly: ON" or "Fly: OFF"
    local hrp = HRP()
    if not hrp then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = fly end
    if fly then
        bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- 3. NOCLIP
local noclip = false
local noclipBtn = createBtn("Noclip: OFF")
noclipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
    noclipBtn.Text = noclip and "Noclip: ON" or "Noclip: OFF"
end)

-- 4. TELEPORT TO PLAYER (MODIFIED)
local tpBtn = createBtn("Teleport To Player")
tpBtn.MouseButton1Click:Connect(function()
    playerListOpen = not playerListOpen
    playerListFrame.Visible = playerListOpen
    if playerListOpen then refreshPlayerList() end
end)

closeBtn.MouseButton1Click:Connect(function()
    playerListFrame.Visible = false
    playerListOpen = false
end)

-- 5. AUTO CHRISTMAS & HIDE UI
local autoXmas = false
local xmasBtn = createBtn("Auto Christmas: OFF")
xmasBtn.MouseButton1Click:Connect(function()
    autoXmas = not autoXmas
    xmasBtn.Text = autoXmas and "Auto Christmas: ON" or "Auto Christmas: OFF"
end)

local hideBtn = createBtn("Hide Game UI")
hideBtn.MouseButton1Click:Connect(function()
    for _,ui in pairs(player.PlayerGui:GetChildren()) do
        if ui ~= gui and ui:IsA("ScreenGui") then ui.Enabled = not ui.Enabled end
    end
end)

-- ================= LOOPS =================
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if keys[i.KeyCode.Name] ~= nil then keys[i.KeyCode.Name] = true end
end)
UIS.InputEnded:Connect(function(i)
    if keys[i.KeyCode.Name] ~= nil then keys[i.KeyCode.Name] = false end
end)

RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    if fly and bv and bg then
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
        bg.CFrame = cam.CFrame
    end
    -- Update PING (Label ditanam langsung di Render)
end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    -- Logic Auto Christmas tetap sama
end)
