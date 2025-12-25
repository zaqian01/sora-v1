local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local FlyBtn = Instance.new("TextButton")
local SpeedInput = Instance.new("TextBox")
local SpeedLabel = Instance.new("TextLabel")

-- Setup UI Utama
ScreenGui.Name = "FlyGui"
ScreenGui.Parent = game.CoreGui -- Agar tidak hilang saat reset (jika pakai executor)
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.Position = UDim2.new(0.1, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 150, 0, 180)
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser

Title.Text = "FLY MENU"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = MainFrame

FlyBtn.Name = "FlyBtn"
FlyBtn.Parent = MainFrame
FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
FlyBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
FlyBtn.Size = UDim2.new(0.8, 0, 0, 40)
FlyBtn.Text = "Fly: OFF"
FlyBtn.TextColor3 = Color3.new(1, 1, 1)

SpeedLabel.Text = "Set Speed:"
SpeedLabel.Position = UDim2.new(0.1, 0, 0.55, 0)
SpeedLabel.Size = UDim2.new(0.8, 0, 0, 20)
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Parent = MainFrame

SpeedInput.Parent = MainFrame
SpeedInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SpeedInput.Position = UDim2.new(0.1, 0, 0.7, 0)
SpeedInput.Size = UDim2.new(0.8, 0, 0, 30)
SpeedInput.Text = "50"
SpeedInput.TextColor3 = Color3.new(1, 1, 1)

--- LOGIC FLY ---

local player = game.Players.LocalPlayer
local flying = false
local speed = 50
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
                bv.Velocity = game.Workspace.CurrentCamera.CFrame.LookVector * speed
                bg.CFrame = game.Workspace.CurrentCamera.CFrame
                task.wait()
            end
        end)
    else
        FlyBtn.Text = "Fly: OFF"
        FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        char.Humanoid.PlatformStand = false
        bv.Parent = nil
        bg.Parent = nil
    end
end

FlyBtn.MouseButton1Click:Connect(toggleFly)

SpeedInput.FocusLost:Connect(function()
    local val = tonumber(SpeedInput.Text)
    if val then
        speed = val
    else
        SpeedInput.Text = tostring(speed)
    end
end)
