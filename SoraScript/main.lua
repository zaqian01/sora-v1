-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

-- UI CONST
local HEADER_HEIGHT = 35
local INFO_HEIGHT = 70
local INITIAL_HEIGHT = 300
local FRAME_WIDTH = 300

-- UTILS
local function HRP()
    local c = player.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- ================= GUI =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(FRAME_WIDTH, INITIAL_HEIGHT)
frame.Position = UDim2.fromOffset(200, 200)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.ClipsDescendants = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,HEADER_HEIGHT)
title.Text = "SORA"
title.TextColor3 = Color3.fromRGB(0,255,180)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Font = Enum.Font.Code
title.TextSize = 18
title.BorderSizePixel = 0

local contentFrame = Instance.new("Frame", frame)
contentFrame.Size = UDim2.new(1,0,1,-HEADER_HEIGHT)
contentFrame.Position = UDim2.fromOffset(0, HEADER_HEIGHT)
contentFrame.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", contentFrame)
list.Padding = UDim.new(0,8)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.SortOrder = Enum.SortOrder.LayoutOrder

local function btn(text, cb)
    local b = Instance.new("TextButton", contentFrame)
    b.Size = UDim2.fromOffset(FRAME_WIDTH - 20,40)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18
    b.BorderSizePixel = 0
    b.MouseButton1Click:Connect(cb)
    return b
end

-- INFO
local infoFrame = Instance.new("Frame", contentFrame)
infoFrame.Size = UDim2.fromOffset(FRAME_WIDTH - 20, INFO_HEIGHT)
infoFrame.BackgroundTransparency = 1
infoFrame.LayoutOrder = 1

local infoList = Instance.new("UIListLayout", infoFrame)
infoList.Padding = UDim.new(0,5)

local coord = Instance.new("TextLabel", infoFrame)
coord.Size = UDim2.new(1,0,0,30)
coord.BackgroundTransparency = 1
coord.TextXAlignment = Enum.TextXAlignment.Left
coord.Text = "POS: X: 0.0 | Y: 0.0 | Z: 0.0"
coord.Font = Enum.Font.GothamBold
coord.TextSize = 16
coord.TextColor3 = Color3.fromRGB(220,220,220)

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1,0,0,25)
pingLabel.BackgroundTransparency = 1
pingLabel.TextXAlignment = Enum.TextXAlignment.Left
pingLabel.Text = "PING: -- ms"
pingLabel.Font = Enum.Font.GothamBold
pingLabel.TextSize = 20
pingLabel.TextColor3 = Color3.fromRGB(0,255,180)

local sep = Instance.new("Frame", contentFrame)
sep.Size = UDim2.fromOffset(FRAME_WIDTH - 20, 2)
sep.BackgroundColor3 = Color3.fromRGB(60,60,60)
sep.LayoutOrder = 2

local order = 3

-- ================= FLY =================
local fly = false
local speed = 60
local bv, bg
local keys = {}

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    keys[i.KeyCode] = true
end)
UIS.InputEnded:Connect(function(i)
    keys[i.KeyCode] = false
end)

btn("Fly ON / OFF", function()
    fly = not fly
    local hrp = HRP()
    if not hrp then return end

    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = fly end

    if fly then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)

        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end).LayoutOrder = order
order += 1

-- ================= NOCLIP =================
local noclip = false
btn("Noclip ON / OFF", function()
    noclip = not noclip
end).LayoutOrder = order
order += 1

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _,v in pairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ================= HIDE UI =================
local hidden = false
btn("Hide Game UI ON / OFF", function()
    hidden = not hidden
    for _,ui in pairs(player.PlayerGui:GetChildren()) do
        if ui ~= gui and ui:IsA("ScreenGui") then
            ui.Enabled = not hidden
        end
    end
end).LayoutOrder = order
order += 1

-- ================= AUTO EVENT CHRISTMAS =================
local autoChristmas = false

local ORIGINAL_CFRAME = CFrame.new(1173.1, 23.4, 1565.1)
local EVENT_CFRAME    = CFrame.new(606.0, -580.6, 8923.3)

local EVENT_HOURS = {
    [0]=true,[2]=true,[4]=true,[6]=true,[8]=true,[10]=true
}

local teleported = false
local returned = false

btn("Auto Event Christmas ON / OFF", function()
    autoChristmas = not autoChristmas
end).LayoutOrder = order

RunService.Heartbeat:Connect(function()
    if not autoChristmas then return end
    local hrp = HRP()
    if not hrp then return end

    local t = os.date("!*t", workspace:GetServerTimeNow())
    local h,m,s = t.hour, t.min, t.sec

    if EVENT_HOURS[h] and m == 0 and s >= 30 and not teleported then
        hrp.CFrame = EVENT_CFRAME
        teleported = true
        returned = false
    end

    if EVENT_HOURS[h] and m == 29 and s >= 30 and teleported and not returned then
        hrp.CFrame = ORIGINAL_CFRAME
        returned = true
    end

    if not EVENT_HOURS[h] then
        teleported = false
        returned = false
    end
end)

-- ================= RENDER =================
RunService.RenderStepped:Connect(function()
    local hrp = HRP()
    if hrp then
        local p = hrp.Position
        coord.Text = string.format("POS: X: %.1f | Y: %.1f | Z: %.1f", p.X, p.Y, p.Z)
    end

    local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    pingLabel.Text = string.format("PING: %d ms", ping)
end)
