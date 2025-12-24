-- ================= SORA RECORDER V4 (ULTIMATE) =================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local fileName = "SORA_MAP_" .. placeId .. ".json"

local recordedPoints = {}
local flying = false
local speeds = {50, 100, 200, 500}
local currentSpeedIdx = 1
local flySpeed = speeds[currentSpeedIdx]

local delays = {10, 30, 60, 100, 160, 320, 500}
local currentDelayIdx = 1
local rushDelay = delays[currentDelayIdx]

-- FUNGSI SAVE/LOAD
local function saveToFile()
    local data = {}
    for _, cf in ipairs(recordedPoints) do
        table.insert(data, {cf:GetComponents()})
    end
    writefile(fileName, HttpService:JSONEncode(data))
end

local function loadFromFile()
    if isfile(fileName) then
        local content = readfile(fileName)
        local data = HttpService:JSONDecode(content)
        recordedPoints = {}
        for _, components in ipairs(data) do
            table.insert(recordedPoints, CFrame.new(unpack(components)))
        end
        return true
    end
    return false
end

-- ================= UI SETUP =================
local gui = Instance.new("ScreenGui")
gui.Name = "SoraRecorderV4"
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false -- AGAR TIDAK HILANG SAAT MATI

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260, 420) -- Ukuran disesuaikan
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "SORA RECORDER V4"
title.TextColor3 = Color3.fromRGB(0, 255, 180)
title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.94, 0)
status.Text = "Status: Ready"
status.TextColor3 = Color3.new(0.7, 0.7, 0.7)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 10

-- BUTTON CREATOR
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 220, 0, 32); b.Position = pos; b.AnchorPoint = Vector2.new(0.5, 0); b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 12; Instance.new("UICorner", b)
    return b
end

local recBtn    = createBtn("RECORD POINT (0)", UDim2.new(0.5, 0, 0.10, 0), Color3.fromRGB(45, 45, 90))
local flyBtn    = createBtn("FLY: OFF", UDim2.new(0.5, 0, 0.20, 0), Color3.fromRGB(60, 60, 60))
local speedBtn  = createBtn("FLY SPEED: 50", UDim2.new(0.5, 0, 0.30, 0), Color3.fromRGB(140, 100, 20))
local delayBtn  = createBtn("RUSH DELAY: 10s", UDim2.new(0.5, 0, 0.43, 0), Color3.fromRGB(100, 60, 120))
local rushBtn   = createBtn("START AUTO RUSH", UDim2.new(0.5, 0, 0.53, 0), Color3.fromRGB(30, 100, 30))
local saveBtn   = createBtn("SAVE TO FILE", UDim2.new(0.5, 0, 0.70, 0), Color3.fromRGB(50, 50, 50))
local clearBtn  = createBtn("CLEAR DATA", UDim2.new(0.5, 0, 0.82, 0), Color3.fromRGB(120, 30, 30))

-- TOGGLE LOGIC
speedBtn.MouseButton1Click:Connect(function()
    currentSpeedIdx = currentSpeedIdx + 1
    if currentSpeedIdx > #speeds then currentSpeedIdx = 1 end
    flySpeed = speeds[currentSpeedIdx]
    speedBtn.Text = "FLY SPEED: " .. flySpeed
end)

delayBtn.MouseButton1Click:Connect(function()
    currentDelayIdx = currentDelayIdx + 1
    if currentDelayIdx > #delays then currentDelayIdx = 1 end
    rushDelay = delays[currentDelayIdx]
    delayBtn.Text = "RUSH DELAY: " .. rushDelay .. "s"
end)

-- FLY LOGIC
local bodyVelocity, bodyGyro
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "FLY: ON" or "FLY: OFF"
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    
    if flying then
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        hum.PlatformStand = true
        
        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 100
        
        task.spawn(function()
            while flying do
                local camCF = workspace.CurrentCamera.CFrame
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0,1,0) end
                
                bodyVelocity.Velocity = dir * flySpeed
                bodyGyro.CFrame = camCF
                task.wait()
            end
            hum.PlatformStand = false
            if bodyVelocity then bodyVelocity:Destroy() end
            if bodyGyro then bodyGyro:Destroy() end
        end)
    end
end)

-- HANDLERS
recBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        table.insert(recordedPoints, hrp.CFrame)
        recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")"
        status.Text = "Point recorded!"
    end
end)

local rushing = false
rushBtn.MouseButton1Click:Connect(function()
    if #recordedPoints == 0 then status.Text = "No points recorded!"; return end
    rushing = not rushing
    rushBtn.Text = rushing and "STOP RUSH" or "START AUTO RUSH"
    rushBtn.BackgroundColor3 = rushing and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(30, 100, 30)
    
    if rushing then
        if flying then flying = false flyBtn.Text = "FLY: OFF" end 
        task.spawn(function()
            for i, cf in ipairs(recordedPoints) do
                if not rushing then break end
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = cf
                    status.Text = "Rush: Point " .. i .. "/" .. #recordedPoints .. " (Wait " .. rushDelay .. "s)"
                    task.wait(rushDelay)
                end
            end
            rushing = false
            rushBtn.Text = "START AUTO RUSH"
            rushBtn.BackgroundColor3 = Color3.fromRGB(30, 100, 30)
            status.Text = "Rush Finished!"
        end)
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    saveToFile()
    status.Text = "File Saved!"
end)

clearBtn.MouseButton1Click:Connect(function()
    recordedPoints = {}
    recBtn.Text = "RECORD POINT (0)"
    if isfile(fileName) then delfile(fileName) end
    status.Text = "Data Wiped!"
end)

-- AUTO LOAD
if loadFromFile() then
    recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")"
    status.Text = "Map Data Loaded."
end
