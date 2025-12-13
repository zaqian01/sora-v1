-- ===============================================
-- Sora v1 - Core Script (GitHub: zradian01/sora-v1)
-- Mengimplementasikan UI, Fly, NoClip, dan Totem Logic
-- ===============================================

-- LAYANAN INTI
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- KONSTANTA TOTEM (Didasarkan pada Radius R=54 dan Pusat P= (87, 9, 2737))
local R = 54 -- Radius setiap Totem (unit)
local P_CENTER_X = 87
local P_CENTER_Y = 9
local P_CENTER_Z = 2737
local PARTIAL_R = 38 -- Digunakan untuk offset diagonal (sekitar R/sqrt(2) untuk distribusi merata)

-- 12 KOORDINAT TOTEM OPTIMAL (Semua berjarak R=54 dari Titik Pusat P)
-- Totem ini harus ditempatkan secara presisi menggunakan fitur Fly/NoClip
local TOTEM_POSITIONS = {
    -- 6 Totem di sekitar sumbu X/Z (Lapisan Tengah 2D)
    Vector3.new(P_CENTER_X + R, P_CENTER_Y, P_CENTER_Z),           -- T1 (+X)
    Vector3.new(P_CENTER_X - R, P_CENTER_Y, P_CENTER_Z),           -- T2 (-X)
    Vector3.new(P_CENTER_X, P_CENTER_Y, P_CENTER_Z + R),           -- T3 (+Z)
    Vector3.new(P_CENTER_X, P_CENTER_Y, P_CENTER_Z - R),           -- T4 (-Z)
    Vector3.new(P_CENTER_X + PARTIAL_R, P_CENTER_Y, P_CENTER_Z + PARTIAL_R), -- T5 (+X, +Z diagonal)
    Vector3.new(P_CENTER_X - PARTIAL_R, P_CENTER_Y, P_CENTER_Z - PARTIAL_R), -- T6 (-X, -Z diagonal)

    -- 6 Totem untuk 3D Stacking (Lapisan Atas/Bawah & Diagonal)
    Vector3.new(P_CENTER_X, P_CENTER_Y + R, P_CENTER_Z),           -- T7 (+Y, Totem Udara)
    Vector3.new(P_CENTER_X, P_CENTER_Y - R, P_CENTER_Z),           -- T8 (-Y, Totem Bawah Tanah)
    Vector3.new(P_CENTER_X + PARTIAL_R, P_CENTER_Y + PARTIAL_R, P_CENTER_Z), -- T9 (+X, +Y)
    Vector3.new(P_CENTER_X - PARTIAL_R, P_CENTER_Y - PARTIAL_R, P_CENTER_Z), -- T10 (-X, -Y)
    Vector3.new(P_CENTER_X, P_CENTER_Y + PARTIAL_R, P_CENTER_Z - PARTIAL_R), -- T11 (+Y, -Z)
    Vector3.new(P_CENTER_X, P_CENTER_Y - PARTIAL_R, P_CENTER_Z + PARTIAL_R), -- T12 (-Y, +Z)
}

-- VARIABEL STATUS
local isFlying = false
local isNoclipping = false
local originalGravity = Workspace.Gravity
local originalWalkSpeed = 16 -- Kecepatan default Roblox

-- Fungsi untuk mendapatkan karakter dan HumanoidRootPart (HRP)
local function getHRP()
    local character = LocalPlayer.Character
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
end

-- ===============================================
-- 1. FUNGSI NOCLIP
-- ===============================================

local function toggleNoclip()
    isNoclipping = not isNoclipping
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        if isNoclipping then
            -- Set semua part karakter ke CanCollide = false
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        else
            -- Reset CanCollide (Perlu dilakukan sekali saja)
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- ===============================================
-- 2. FUNGSI FLY (Gerakan 3D Presisi)
-- ===============================================

local function startFly()
    isFlying = true
    Workspace.Gravity = 0 -- Nonaktifkan gravitasi
    LocalPlayer.Character.Humanoid.PlatformStand = true -- Jangan biarkan humanoid bergerak
    LocalPlayer.Character.Humanoid.WalkSpeed = 0 -- Nonaktifkan gerakan tanah
end

local function stopFly()
    isFlying = false
    Workspace.Gravity = originalGravity -- Kembalikan gravitasi
    LocalPlayer.Character.Humanoid.PlatformStand = false
    LocalPlayer.Character.Humanoid.WalkSpeed = originalWalkSpeed -- Kembalikan kecepatan
end

local function handleFlyMovement()
    local root = getHRP()
    if not root or not isFlying then return end

    local movementVector = Vector3.new(0, 0, 0)
    local moveSpeed = 2 -- Kecepatan perpindahan (bisa diubah untuk presisi)

    -- Kontrol Gerakan (Sesuai kesepakatan)
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then movementVector = movementVector + root.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then movementVector = movementVector - root.CFrame.LookVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then movementVector = movementVector - root.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then movementVector = movementVector + root.CFrame.RightVector end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then movementVector = movementVector + Vector3.new(0, 1, 0) end -- NAIK (Y+)
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then movementVector = movementVector - Vector3.new(0, 1, 0) end -- TURUN (Y-)
    
    if movementVector.Magnitude > 0 then
        root.CFrame = root.CFrame + movementVector.Unit * moveSpeed
    end
end

-- ===============================================
-- 3. FUNGSI AUTO-TELEPORT
-- ===============================================

local function autoTeleport()
    local root = getHRP()
    if not root then return end

    -- Teleport ke Titik Pusat Overlap (P_CENTER)
    local targetPos = Vector3.new(P_CENTER_X, P_CENTER_Y + 5, P_CENTER_Z) -- Ditambah 5 unit agar tidak tenggelam
    root.CFrame = CFrame.new(targetPos)

    print("Teleport berhasil ke pusat Overlap 12 Totem.")
    print(string.format("Pusat Efek: (%.0f, %.0f, %.0f)", P_CENTER_X, P_CENTER_Y, P_CENTER_Z))
    print("---------------------------------------")
    print("KOORDINAT 12 TITIK TOTEM UNTUK DITEMPATKAN (Jarak R="..R.." dari pusat):")
    for i, pos in ipairs(TOTEM_POSITIONS) do
        print(string.format("Totem %d: (%.0f, %.0f, %.0f)", i, pos.X, pos.Y, pos.Z))
    end
    print("---------------------------------------")
end

-- ===============================================
-- 4. SETUP UI MANUAL (Sora v1)
-- ===============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SoraV1_GUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 200)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -100) -- Posisi default di tengah
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = screenGui

-- Title Bar
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Sora v1"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

-- UI Drag Functionality
local isDragging = false
local dragStartPos = nil

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartPos = UserInputService:GetMouseLocation() - Vector2.new(mainFrame.AbsolutePosition.X, mainFrame.AbsolutePosition.Y)
        -- Masukkan Frame ke depan
        mainFrame:ZIndex(10)
    end
end)

titleLabel.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
        isDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        mainFrame.Position = UDim2.new(0, mousePos.X - dragStartPos.X, 0, mousePos.Y - dragStartPos.Y)
    end
end)

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Text = "—"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.Parent = titleLabel

minimizeButton.MouseButton1Click:Connect(function()
    local isVisible = container.Visible
    container.Visible = not isVisible
    mainFrame.Size = UDim2.new(0, 250, 0, isVisible and 30 or 200)
    minimizeButton.Text = isVisible and "□" or "—"
end)

-- Button Container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -20, 1, -40)
container.Position = UDim2.new(0, 10, 0, 35)
container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
container.Parent = mainFrame
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = container

-- Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Text = "Toggle Fly (OFF)"
flyButton.Size = UDim2.new(1, 0, 0, 30)
flyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.Parent = container

flyButton.MouseButton1Click:Connect(function()
    if isFlying then
        stopFly()
        flyButton.Text = "Toggle Fly (OFF)"
        flyButton.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
    else
        startFly()
        flyButton.Text = "Toggle Fly (ON)"
        flyButton.BackgroundColor3 = Color3.fromRGB(150, 80, 80)
    end
end)

-- NoClip Button
local noclipButton = Instance.new("TextButton")
noclipButton.Text = "Toggle NoClip (OFF)"
noclipButton.Size = UDim2.new(1, 0, 0, 30)
noclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipButton.Parent = container

noclipButton.MouseButton1Click:Connect(function()
    toggleNoclip()
    if isNoclipping then
        noclipButton.Text = "Toggle NoClip (ON)"
        noclipButton.BackgroundColor3 = Color3.fromRGB(150, 80, 80)
    else
        noclipButton.Text = "Toggle NoClip (OFF)"
        noclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
    end
end)

-- Teleport Button
local tpButton = Instance.new("TextButton")
tpButton.Text = "TP ke Pusat Overlap (87, 9, 2737)"
tpButton.Size = UDim2.new(1, 0, 0, 30)
tpButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
tpButton.Font = Enum.Font.SourceSansBold
tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
tpButton.Parent = container

tpButton.MouseButton1Click:Connect(autoTeleport)

-- RUN LOOP untuk Fly Movement
RunService.Heartbeat:Connect(handleFlyMovement)

print("Sora v1 - Loader UI dan Movement Aktif.")
