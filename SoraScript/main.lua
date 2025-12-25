-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- ================= UTILS =================
local function formatFullNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_HUB_V5_LIVE"
gui.ResetOnSpawn = false

-- ================= 1. MY STATS PANEL (SMALL & CLEAR) =================
local initialCaught = 0
local statsData = player:FindFirstChild("leaderstats")
if statsData and statsData:FindFirstChild("Caught") then
    initialCaught = statsData.Caught.Value
end

local myStatsFrame = Instance.new("Frame", gui)
myStatsFrame.Size = UDim2.fromOffset(160, 100)
myStatsFrame.Position = UDim2.new(1, -170, 0.2, 0)
myStatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
myStatsFrame.Visible = false
myStatsFrame.Active = true
myStatsFrame.Draggable = true
Instance.new("UICorner", myStatsFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", myStatsFrame).Color = Color3.fromRGB(0, 255, 180)

local myTitle = Instance.new("TextLabel", myStatsFrame)
myTitle.Size = UDim2.new(1, 0, 0, 25); myTitle.Text = "MY STATS"; myTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
myTitle.Font = Enum.Font.GothamBold; myTitle.TextSize = 10; myTitle.BackgroundTransparency = 1

local caughtVal = Instance.new("TextLabel", myStatsFrame)
caughtVal.Size = UDim2.new(1, 0, 0, 35); caughtVal.Position = UDim2.fromOffset(0, 25)
caughtVal.Text = "0"; caughtVal.TextColor3 = Color3.new(1,1,1)
caughtVal.Font = Enum.Font.Code; caughtVal.TextSize = 22; caughtVal.BackgroundTransparency = 1

local sessionVal = Instance.new("TextLabel", myStatsFrame)
sessionVal.Size = UDim2.new(1, 0, 0, 20); sessionVal.Position = UDim2.fromOffset(0, 65)
sessionVal.Text = "Session: +0"; sessionVal.TextColor3 = Color3.fromRGB(255, 200, 0)
sessionVal.Font = Enum.Font.Gotham; sessionVal.TextSize = 11; sessionVal.BackgroundTransparency = 1

-- ================= 2. SERVER STATS PANEL =================
local serverStatsFrame = Instance.new("Frame", gui)
serverStatsFrame.Size = UDim2.fromOffset(200, 180)
serverStatsFrame.Position = UDim2.new(1, -210, 0.4, 0)
serverStatsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
serverStatsFrame.Visible = false
serverStatsFrame.Active = true
serverStatsFrame.Draggable = true
Instance.new("UICorner", serverStatsFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", serverStatsFrame).Color = Color3.fromRGB(0, 255, 180)

local svTitle = Instance.new("TextLabel", serverStatsFrame)
svTitle.Size = UDim2.new(1, 0, 0, 30); svTitle.Text = "SERVER TOP 5"; svTitle.TextColor3 = Color3.fromRGB(0, 255, 180)
svTitle.Font = Enum.Font.GothamBold; svTitle.TextSize = 13; svTitle.BackgroundTransparency = 1

local svList = Instance.new("ScrollingFrame", serverStatsFrame)
svList.Size = UDim2.new(1, -15, 1, -40); svList.Position = UDim2.fromOffset(10, 35)
svList.BackgroundTransparency = 1; svList.ScrollBarThickness = 0
Instance.new("UIListLayout", svList).Padding = UDim.new(0, 4)

-- ================= 3. PING PANEL (ALWAYS VISIBLE) =================
local pingPanel = Instance.new("Frame", gui)
pingPanel.Size = UDim2.fromOffset(100, 35)
pingPanel.Position = UDim2.new(1, -110, 0.1, 0)
pingPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
pingPanel.Visible = false
pingPanel.Active = true
pingPanel.Draggable = true
Instance.new("UICorner", pingPanel).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", pingPanel).Color = Color3.fromRGB(0, 255, 180)

local pingText = Instance.new("TextLabel", pingPanel)
pingText.Size = UDim2.new(1, 0, 1, 0); pingText.Text = "PING: 0 ms"; pingText.TextColor3 = Color3.fromRGB(0, 255, 180)
pingText.Font = Enum.Font.GothamBold; pingText.TextSize = 12; pingText.BackgroundTransparency = 1

-- ================= SORA MAIN PANEL (V5 BASE) =================
-- [Bagian FLOATING LOGO dan MAIN PANEL tetap sama seperti script sebelumnya]
local openLogo = Instance.new("ImageButton", gui)
openLogo.Name = "SoraLogo"; openLogo.Size = UDim2.fromOffset(60, 60); openLogo.Position = UDim2.fromScale(0.02, 0.5); openLogo.BackgroundTransparency = 1; openLogo.Visible = false; openLogo.Active = true; openLogo.Draggable = true; openLogo.Image = "rbxassetid://107169258644997" 
Instance.new("UICorner", openLogo).CornerRadius = UDim.new(0, 12)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(300, 480); frame.Position = UDim2.fromScale(0.35, 0.2); frame.BackgroundColor3 = Color3.fromRGB(18,18,18); frame.Active = true; frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

-- HEADER
local header = Instance.new("Frame", frame); header.Size = UDim2.new(1,0,0,40); header.BackgroundColor3 = Color3.fromRGB(25,25,25); Instance.new("UICorner", header).CornerRadius = UDim.new(0,10)
local title = Instance.new("TextLabel", header); title.Size = UDim2.new(1,-50,1,0); title.Position = UDim2.fromOffset(12,0); title.BackgroundTransparency = 1; title.Text = "SORA HUB"; title.TextColor3 = Color3.fromRGB(0,255,180); title.Font = Enum.Font.GothamBold; title.TextSize = 18; title.TextXAlignment = Enum.TextXAlignment.Left

local minimize = Instance.new("TextButton", header); minimize.Size = UDim2.fromOffset(36,26); minimize.Position = UDim2.new(1, -10, 0.5, 0); minimize.AnchorPoint = Vector2.new(1,0.5); minimize.BackgroundColor3 = Color3.fromRGB(40,40,40); minimize.Text = "–"; minimize.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", minimize).CornerRadius = UDim.new(0,6)

-- INFO & BUTTONS
local contentScroll = Instance.new("ScrollingFrame", frame); contentScroll.Position = UDim2.fromOffset(0, 50); contentScroll.Size = UDim2.new(1,0,1,-60); contentScroll.BackgroundTransparency = 1; contentScroll.ScrollBarThickness = 0; Instance.new("UIListLayout", contentScroll).HorizontalAlignment = Enum.HorizontalAlignment.Center; Instance.new("UIListLayout", contentScroll).Padding = UDim.new(0,8)

local function createBtn(text)
    local b = Instance.new("TextButton", contentScroll); b.Size = UDim2.new(0, 270, 0, 36); b.BackgroundColor3 = Color3.fromRGB(35,35,35); b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
    return b
end

local myStatsBtn = createBtn("My Stats: OFF")
local svStatsBtn = createBtn("Server Stats: OFF")
local pingBtn = createBtn("Ping Panel: OFF")

-- HANDLERS
myStatsBtn.MouseButton1Click:Connect(function() myStatsFrame.Visible = not myStatsFrame.Visible; myStatsBtn.Text = myStatsFrame.Visible and "My Stats: ON" or "My Stats: OFF" end)
svStatsBtn.MouseButton1Click:Connect(function() serverStatsFrame.Visible = not serverStatsFrame.Visible; svStatsBtn.Text = serverStatsFrame.Visible and "Server Stats: ON" or "Server Stats: OFF" end)
pingBtn.MouseButton1Click:Connect(function() pingPanel.Visible = not pingPanel.Visible; pingBtn.Text = pingPanel.Visible and "Ping Panel: ON" or "Ping Panel: OFF" end)

minimize.MouseButton1Click:Connect(function() frame.Visible = false; openLogo.Visible = true end)
openLogo.MouseButton1Click:Connect(function() openLogo.Visible = false; frame.Visible = true end)

-- ================= LOOPS =================
RunService.RenderStepped:Connect(function()
    if pingPanel.Visible then
        pingText.Text = "PING: " .. math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) .. " ms"
    end

    if myStatsFrame.Visible then
        local myStats = player:FindFirstChild("leaderstats")
        if myStats and myStats:FindFirstChild("Caught") then
            local current = myStats.Caught.Value
            caughtVal.Text = formatFullNumber(current)
            sessionVal.Text = "Session: +" .. formatFullNumber(current - initialCaught)
        end
    end
    
    if serverStatsFrame.Visible and tick() % 3 < 0.1 then
        for _,c in pairs(svList:GetChildren()) do if c:IsA("TextLabel") then c:Destroy() end end
        local allPlrs = {}
        for _,p in pairs(Players:GetPlayers()) do
            local ps = p:FindFirstChild("leaderstats")
            if ps and ps:FindFirstChild("Caught") then
                table.insert(allPlrs, {name = p.DisplayName, val = ps.Caught.Value})
            end
        end
        table.sort(allPlrs, function(a,b) return a.val > b.val end)
        for i=1, math.min(5, #allPlrs) do
            local pData = allPlrs[i]
            local tl = Instance.new("TextLabel", svList)
            tl.Size = UDim2.new(1, 0, 0, 25); tl.BackgroundTransparency = 1
            tl.Text = string.format("%d. %s: %s", i, pData.name, formatFullNumber(pData.val))
            tl.TextColor3 = (pData.name == player.DisplayName) and Color3.fromRGB(0,255,180) or Color3.new(1,1,1)
            tl.Font = Enum.Font.Gotham; tl.TextSize = 12; tl.TextXAlignment = Enum.TextXAlignment.Left
        end
    end
end)
