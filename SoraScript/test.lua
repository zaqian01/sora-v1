-- ================= SORA RECORDER V2 + FLY =================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local placeId = game.PlaceId
local fileName = "SORA_MAP_" .. placeId .. ".json"

local recordedPoints = {}
local flying = false
local flySpeed = 50

-- FUNGSI SAVE KE FILE
local function saveToFile()
    local data = {}
    for _, cf in ipairs(recordedPoints) do
        table.insert(data, {cf:GetComponents()})
    end
    writefile(fileName, HttpService:JSONEncode(data))
end

-- FUNGSI LOAD DARI FILE
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

-- ================= UI & LOGIC =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SoraRecorderV3_Fly"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(260, 330) -- Ukuran ditambah sedikit
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 35)
title.Text = "SORA RECORDER V2 + FLY"
title.TextColor3 = Color3.fromRGB(0, 255, 180)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Font = Enum.Font.GothamBold
Instance.new("UICorner", title)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 0.92, 0)
status.Text = "Checking for save data..."
status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 10

-- BUTTON CREATOR UTILS
local function createBtn(text, pos, color)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 220, 0, 32); b.Position = pos; b.AnchorPoint = Vector2.new(0.5, 0); b.Text = text; b.BackgroundColor3 = color; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    return b
end

local recBtn   = createBtn("RECORD POINT (0)", UDim2.new(0.5, 0, 0.13, 0), Color3.fromRGB(45, 45, 90))
local flyBtn   = createBtn("FLY: OFF", UDim2.new(0.5, 0, 0.26, 0), Color3.fromRGB(70, 70, 70))
local rushBtn  = createBtn("START AUTO RUSH", UDim2.new(0.5, 0, 0.43, 0), Color3.fromRGB(45, 90, 45))
local saveBtn  = createBtn("SAVE TO FILE", UDim2.new(0.5, 0, 0.60, 0), Color3.fromRGB(120, 80, 20))
local clearBtn = createBtn("CLEAR DATA", UDim2.new(0.5, 0, 0.77, 0), Color3.fromRGB(100, 30, 30))

-- LOGIC FLY
local bodyVelocity, bodyGyro
runFly = RunService.RenderStepped:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local camera = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        
        -- Basic fly movement logic
        hrp.Velocity = Vector3.new(0,0.1,0) -- Anti-falling
        
        local lookVector = camera.CFrame.LookVector
        local rightVector = camera.CFrame.RightVector
        
        -- Sederhana: Karakter akan bergerak ke arah kamera
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + lookVector)
    end
end)

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "FLY: ON" or "FLY: OFF"
    flyBtn.BackgroundColor3 = flying and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 70, 70)
    
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if flying then
        hum.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity", hrp)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyGyro.D = 100
        bodyGyro.P = 10000
        
        task.spawn(function()
            while flying do
                local camCF = workspace.CurrentCamera.CFrame
                local dir = Vector3.new()
                -- Control Check (Sederhana)
                local UserInputService = game:GetService("UserInputService")
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
        end)
    else
        hum.PlatformStand = false
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

-- HANDLERS LAINNYA
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
    
    if rushing then
        -- Matikan fly otomatis jika sedang rushing
        if flying then flyBtn.MouseButton1Click:Fire() end 
        
        task.spawn(function()
            for i, cf in ipairs(recordedPoints) do
                if not rushing then break end
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = cf
                    status.Text = "Teleporting to Point " .. i
                    task.wait(1.5)
                end
            end
            rushing = false
            rushBtn.Text = "START AUTO RUSH"
            status.Text = "Rush Finished!"
        end)
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    saveToFile()
    status.Text = "Saved to: " .. fileName
end)

clearBtn.MouseButton1Click:Connect(function()
    recordedPoints = {}
    recBtn.Text = "RECORD POINT (0)"
    if isfile(fileName) then delfile(fileName) end
    status.Text = "Data and File Deleted!"
end)

-- AUTO LOAD ON STARTUP
task.spawn(function()
    if loadFromFile() then
        recBtn.Text = "RECORD POINT (" .. #recordedPoints .. ")"
        status.Text = "Loaded data for Map: " .. placeId
    else
        status.Text = "No previous data for this map."
    end
end)
