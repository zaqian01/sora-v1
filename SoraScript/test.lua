-- ================= SORA RECORDER V6 (AUTO-GLIDE) =================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local placeId = game.PlaceId
local fileName = "SORA_MAP_" .. placeId .. ".json"

local recordedPoints = {}
local flying = false
local autoGliding = false
local speeds = {50, 100, 200, 500}
local currentSpeedIdx = 1
local flySpeed = speeds[currentSpeedIdx]

-- FUNGSI SAVE/LOAD
local function saveToFile()
    local data = {}
    for _, cf in ipairs(recordedPoints) do table.insert(data, {cf:GetComponents()}) end
    writefile(fileName, HttpService:JSONEncode(data))
end

local function loadFromFile()
    if isfile(fileName) then
        local data = HttpService:JSONDecode(readfile(fileName))
        recordedPoints = {}
        for _, comp in ipairs(data) do table.insert(recordedPoints, CFrame.new(unpack(comp))) end
        return true
    end
    return false
end

-- ================= UI SETUP =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraV6_AutoGlide"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260, 380)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "SORA RECORDER V6"
title.TextColor3 = Color3.fromRGB(0, 255, 180)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.93, 0)
status.Text = "Mode: Auto-Glide Ready"
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 10

-- BUTTON UTILS
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 220, 0, 35); b.Position = pos; b.AnchorPoint = Vector2.new(0.5, 0); b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 12; Instance.new("UICorner", b)
    return b
end

local recBtn    = createBtn("RECORD POINT (0)", UDim2.new(0.5, 0, 0.12, 0), Color3.fromRGB(45, 45, 90))
local speedBtn  = createBtn("GLIDE SPEED: 50", UDim2.new(0.5, 0, 0.25, 0), Color3.fromRGB(140, 100, 20))
local glideBtn  = createBtn("START AUTO GLIDE", UDim2.new(0.5, 0, 0.42, 0), Color3.fromRGB(0, 150, 150))
local manualFly = createBtn("MANUAL FLY: OFF", UDim2.new(0.5, 0, 0.55, 0), Color3.fromRGB(60, 60, 60))
local saveBtn   = createBtn("SAVE TO FILE", UDim2.new(0.5, 0, 0.72, 0), Color3.fromRGB(50, 50, 50))
local clearBtn  = createBtn("CLEAR DATA", UDim2.new(0.5, 0, 0.85, 0), Color3.fromRGB(120, 30, 30))

-- TOGGLE SPEED
speedBtn.MouseButton1Click:Connect(function()
    currentSpeedIdx = (currentSpeedIdx % #speeds) + 1
    flySpeed = speeds[currentSpeedIdx]
    speedBtn.Text = "GLIDE SPEED: " .. flySpeed
end)

-- AUTO GLIDE LOGIC (Terbang Otomatis ke Checkpoints)
glideBtn.MouseButton1Click:Connect(function()
    if #recordedPoints == 0 then status.Text = "No Points!"; return end
    autoGliding = not autoGliding
    glideBtn.Text = autoGliding and "STOP GLIDE" or "START AUTO GLIDE"
    glideBtn.BackgroundColor3 = autoGliding and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 150, 150)
    
    if autoGliding then
        task.spawn(function()
            for i, targetCF in ipairs(recordedPoints) do
                if not autoGliding then break end
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    status.Text = "Gliding to Point " .. i .. "/" .. #recordedPoints
                    
                    -- Hitung durasi berdasarkan jarak dan kecepatan agar konstan
                    local distance = (hrp.Position - targetCF.Position).Magnitude
                    local duration = distance / flySpeed
                    
                    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCF})
                    tween:Play()
                    tween.Completed:Wait()
                end
            end
            autoGliding = false
            glideBtn.Text = "START AUTO GLIDE"
            glideBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
            status.Text = "Finished Glide!"
        end)
    end
end)

-- MANUAL FLY (Tetap disediakan untuk recording)
local bv, bg
manualFly.MouseButton1Click:Connect(function()
    flying = not flying
    manualFly.Text = flying and "MANUAL FLY: ON" or "MANUAL FLY: OFF"
    manualFly.BackgroundColor3 = flying and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(60, 60, 60)
    
    if flying then
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        hum.PlatformStand = true
        bv = Instance.new("BodyVelocity", hrp); bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bg = Instance.new("BodyGyro", hrp); bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        
        task.spawn(function()
            while flying and char.Parent do
                local camCF = workspace.CurrentCamera.CFrame
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - camCF.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - camCF.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + camCF.RightVector end
                bv.Velocity = dir * flySpeed
                bg.CFrame = camCF
                task.wait()
            end
            if hum then hum.PlatformStand = false end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end)
    end
end)

-- BUTTON HANDLERS LAIN
recBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        table.insert(recordedPoints, hrp.CFrame)
        recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")"
        status.Text = "Point " .. #recordedPoints .. " Recorded"
    end
end)

saveBtn.MouseButton1Click:Connect(function() saveToFile(); status.Text = "File Saved!" end)
clearBtn.MouseButton1Click:Connect(function()
    recordedPoints = {}
    recBtn.Text = "RECORD POINT (0)"
    status.Text = "Data Cleared!"
end)

if loadFromFile() then recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")" end
