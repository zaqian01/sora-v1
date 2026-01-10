local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyBtn = Instance.new("TextButton")
local TPBtn = Instance.new("TextButton") -- Tombol Baru: Auto Checkpoint
local SpeedInput = Instance.new("TextBox")
local SpeedLabel = Instance.new("TextLabel")

-- Setup UI (Sesuai script kamu dengan tambahan tombol TP)
ScreenGui.Name = "SmartMountGui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 230) -- Ukuran ditambah
MainFrame.Active = true
MainFrame.Draggable = true

Title.Text = "MOUNT HELPER"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame

FlyBtn.Name = "FlyBtn"
FlyBtn.Parent = MainFrame
FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
FlyBtn.Position = UDim2.new(0.1, 0, 0.18, 0)
FlyBtn.Size = UDim2.new(0.8, 0, 0, 35)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.new(1, 1, 1)

TPBtn.Name = "TPBtn"
TPBtn.Parent = MainFrame
TPBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
TPBtn.Position = UDim2.new(0.1, 0, 0.38, 0)
TPBtn.Size = UDim2.new(0.8, 0, 0, 35)
TPBtn.Text = "Next Checkpoint"
TPBtn.TextColor3 = Color3.new(1, 1, 1)

SpeedLabel.Text = "Travel Speed:"
SpeedLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 20)
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent = MainFrame

SpeedInput.Parent = MainFrame
SpeedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedInput.Position = UDim2.new(0.1, 0, 0.75, 0)
SpeedInput.Size = UDim2.new(0.8, 0, 0, 30)
SpeedInput.Text = "30" -- Default speed lebih pelan agar aman dari ban
SpeedInput.TextColor3 = Color3.new(1, 1, 1)

--- LOGIC CORE ---

local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local flying = false
local speed = 30
local currentStage = 1

-- 1. FUNGSI TWEEN (Teleport Halus agar tidak dideteksi Exploit)
local function safeTween(targetPart)
    local char = player.Character
    if not char or not targetPart then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    
    local dist = (root.Position - targetPart.Position).Magnitude
    local duration = dist / speed
    
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, info, {CFrame = targetPart.CFrame + Vector3.new(0, 3, 0)})
    
    TPBtn.Text = "Traveling..."
    TPBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    
    tween:Play()
    tween.Completed:Connect(function()
        TPBtn.Text = "Next Checkpoint"
        TPBtn.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    end)
end

-- 2. LOGIC MENCARI CHECKPOINT (Gunakan Dark Dex untuk verifikasi Folder)
TPBtn.MouseButton1Click:Connect(function()
    -- Coba cari folder umum checkpoint (Sesuaikan jika di Dark Dex namanya beda)
    local checkpointFolder = workspace:FindFirstChild("Checkpoints") or workspace:FindFirstChild("Stages")
    
    if checkpointFolder then
        -- Mencari part berdasarkan angka stage
        local target = checkpointFolder:FindFirstChild(tostring(currentStage))
        if target then
            safeTween(target)
            currentStage = currentStage + 1
        else
            -- Jika Stage 1 tidak ketemu, mungkin start dari 0
            currentStage = 0 
        end
    else
        warn("Folder Checkpoint tidak ditemukan! Cek nama di Dark Dex.")
    end
end)

-- 3. LOGIC FLY (DISEMPURNAKAN)
local bv = Instance.new("BodyVelocity")
local bg = Instance.new("BodyGyro")

local function toggleFly()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    flying = not flying
    if flying then
        FlyBtn.Text = "Fly: ON"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
        char.Humanoid.PlatformStand = true
        bv.Parent = char.HumanoidRootPart
        bg.Parent = char.HumanoidRootPart
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while flying do
                -- Bergerak hanya saat kamera menghadap depan agar kontrol lebih presisi
                bv.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * speed
                bg.CFrame = game.Workspace.CurrentCamera.CFrame
                task.wait()
            end
        end)
    else
        FlyBtn.Text = "Fly: OFF"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        char.Humanoid.PlatformStand = false
        bv.Parent = nil
        bg.Parent = nil
    end
end

FlyBtn.MouseButton1Click:Connect(toggleFly)

SpeedInput.FocusLost:Connect(function()
    speed = tonumber(SpeedInput.Text) or 30
end)
