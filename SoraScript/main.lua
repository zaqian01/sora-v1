-- Nama Script: Sora V1 (Bunny Compatible)
-- Executor: Bunny

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- == Konfigurasi Fitur ==
local IsFlying = false
local IsNoClip = false
local OriginalWalkSpeed = 16 
local SpeedMultiplier = 2.5 
local NoClipParts = {} 
local FlyUpKey = Enum.KeyCode.E 
local FlyDownKey = Enum.KeyCode.Q 
local ToggleUIKey = Enum.KeyCode.LeftControl 
local IsUIHidden = false

-- Tunggu Humanoid untuk mendapatkan kecepatan awal
LocalPlayer.CharacterAdded:Connect(function(char)
    local humanoid = char:WaitForChild("Humanoid")
    OriginalWalkSpeed = humanoid.WalkSpeed
    -- Memastikan kecepatan reset jika perlu
    if humanoid.WalkSpeed > 16 then
        humanoid.WalkSpeed = 16
    end
end)

-- == Fungsi Utama Fitur ==

-- A. UI Hider
local function ToggleAllUI(shouldHide)
    local CoreGui = game:GetService("CoreGui")
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    for _, gui in ipairs({PlayerGui, CoreGui}) do
        for _, child in ipairs(gui:GetChildren()) do
            -- Abaikan GUI ini (SoraV1Frame) dan CoreGui penting
            if child.Name ~= "SoraV1Frame" and child:IsA("ScreenGui") then
                child.Enabled = not shouldHide
            end
        end
    end
end

-- B. Fly Logic
local function ToggleFly(state)
    IsFlying = state
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.PlatformStand = state
        if not state then
            char.Humanoid.PlatformStand = false
        end
    end
end

-- C. No-Clip Logic
local function ToggleNoClip(state)
    IsNoClip = state
    if not state then
        -- Kembalikan Collide ke semua bagian yang diubah
        for part in pairs(NoClipParts) do
            -- Menggunakan pcall untuk keamanan
            pcall(function() part.CanCollide = true end)
        end
        NoClipParts = {}
    end
end

-- D. Speed Hack Logic
local function SetSpeed(state)
    local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if state then
            humanoid.WalkSpeed = OriginalWalkSpeed * SpeedMultiplier
        else
            humanoid.WalkSpeed = OriginalWalkSpeed
        end
    end
end

-- == Logic Loop (Heartbeat) ==

RunService.Heartbeat:Connect(function(dt)
    local Character = LocalPlayer.Character
    local Root = Character and Character:FindFirstChild("HumanoidRootPart")
    
    if not Character or not Root then return end
    
    -- Fly Logic Loop
    if IsFlying then
        local velocity = Vector3.new(0, 0, 0)
        
        -- Cek Input Gerakan WASD
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + Root.CFrame.lookVector * 30 * dt end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - Root.CFrame.lookVector * 30 * dt end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - Root.CFrame.rightVector * 30 * dt end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + Root.CFrame.rightVector * 30 * dt end
        
        -- Gerakan Vertikal
        if UserInputService:IsKeyDown(FlyUpKey) then velocity = velocity + Vector3.new(0, 30 * dt, 0) end
        if UserInputService:IsKeyDown(FlyDownKey) then velocity = velocity + Vector3.new(0, -30 * dt, 0) end
        
        Root.CFrame = Root.CFrame + velocity
        -- Mencegah gravitasi menarik RootPart
        Root.AssemblyLinearVelocity = Vector3.new(0,0,0) 
    end
    
    -- No-Clip Logic Loop (Bunny/Executor dasar biasanya lebih mengandalkan CanCollide)
    if IsNoClip then
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide == true then
                pcall(function() part.CanCollide = false end)
                NoClipParts[part] = true
            end
        end
    end
end)

-- == Keybind untuk Toggle UI Hider ==
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == ToggleUIKey and not gameProcessedEvent then
        IsUIHidden = not IsUIHidden
        ToggleAllUI(IsUIHidden)
        
        -- Update tampilan tombol UI Hider
        local button = MainFrame:FindFirstChild("Sidebar"):FindFirstChild("MiscButton")
        if button and button:FindFirstChild("HideAllUI(Ctrl)") then
            local uiButton = button:FindFirstChild("HideAllUI(Ctrl)")
            uiButton.Text = IsUIHidden and "HIDE UI: ON" or "HIDE UI: OFF"
            uiButton.BackgroundColor3 = IsUIHidden and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(150, 50, 50)
        end
    end
end)


-- ***************************************
-- == 3. UI Generator (Sora V1 Style) ==
-- ***************************************

-- ** Setup Dasar Frame **
local MainFrame = Instance.new("ScreenGui")
MainFrame.Name = "SoraV1Frame"
MainFrame.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 550, 0, 350)
Frame.Position = UDim2.new(0.5, -275, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
Frame.BorderSizePixel = 0
Frame.Parent = MainFrame

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

-- ** Title Bar (untuk Dragging) **
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 1, 0)
TitleLabel.Text = "Sora V1 | Bunny Edition"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.BackgroundColor3 = Color3.new(0, 0, 0, 0)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Parent = TitleBar

-- ** Minimize Button **
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -25, 0, 5)
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextSize = 18
MinimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinimizeButton.Parent = TitleBar

-- ** Sidebar/Menu Kiri **
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 150, 1, -30)
Sidebar.Position = UDim2.new(0, 0, 0, 30)
Sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Sidebar.Parent = Frame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Padding = UDim.new(0, 2)
SidebarList.Parent = Sidebar

-- ** Content/Halaman Kanan **
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -150, 1, -30)
ContentFrame.Position = UDim2.new(0, 150, 0, 30)
ContentFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ContentFrame.Parent = Frame

local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 10)
ContentPadding.PaddingBottom = UDim.new(0, 10)
ContentPadding.PaddingLeft = UDim.new(0, 10)
ContentPadding.PaddingRight = UDim.new(0, 10)
ContentPadding.Parent = ContentFrame

local ContentListLayout = Instance.new("UIListLayout")
ContentListLayout.Padding = UDim.new(0, 10)
ContentListLayout.Parent = ContentFrame

-- == 4. Helper UI Functions ==

local ActiveTab = nil

-- Helper untuk membuat Tombol Sidebar
local function createSidebarButton(name)
    local Button = Instance.new("TextButton")
    Button.Name = name .. "Button"
    Button.Size = UDim2.new(1, 0, 0, 40)
    Button.Text = name
    Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 16
    Button.BackgroundColor3 = Color3.new(0, 0, 0, 0)
    Button.Parent = Sidebar
    
    local Page = Instance.new("Frame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundColor3 = Color3.new(0, 0, 0, 0)
    Page.Parent = ContentFrame
    Page.Visible = false
    
    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 5)
    PageList.Parent = Page
    
    Button.MouseButton1Click:Connect(function()
        for _, child in ipairs(ContentFrame:GetChildren()) do
            if child:IsA("Frame") and child.Name:match("Page$") then
                child.Visible = false
            end
        end
        Page.Visible = true
        
        -- Update highlight
        for _, btn in ipairs(Sidebar:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.TextColor3 = Color3.fromRGB(200, 200, 200)
                btn.BackgroundColor3 = Color3.new(0, 0, 0, 0)
            end
        end
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        ActiveTab = Button
    end)
    
    return Page
end

-- Helper untuk membuat Tombol Toggle Fitur
local function createFeatureToggle(parentPage, text, command)
    local Button = Instance.new("TextButton")
    Button.Name = text:gsub(" ", ""):gsub("%W", "")
    Button.Size = UDim2.new(1, 0, 0, 30)
    Button.Text = text .. ": OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 14
    Button.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- Merah (OFF)
    Button.Parent = parentPage
    
    local isActive = false
    
    Button.MouseButton1Click:Connect(function()
        isActive = not isActive
        command(isActive)
        if isActive then
            Button.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Hijau (ON)
            Button.Text = text .. ": ON"
        else
            Button.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- Merah (OFF)
            Button.Text = text .. ": OFF"
        end
    end)
    
    return Button
end

-- == 5. Inisialisasi Halaman & Fitur ==

-- Halaman 1: Main (Movement)
local MainPage = createSidebarButton("Main")
createFeatureToggle(MainPage, "Fly", ToggleFly)
createFeatureToggle(MainPage, "No-Clip", ToggleNoClip)
createFeatureToggle(MainPage, "Speed Hack", SetSpeed)

-- Halaman 2: Misc
local MiscPage = createSidebarButton("Misc")
createFeatureToggle(MiscPage, "Hide All UI (Ctrl)", function(state)
    IsUIHidden = state
    ToggleAllUI(state)
end)

-- Halaman default (Main)
if Sidebar:FindFirstChild("MainButton") then
    Sidebar:FindFirstChild("MainButton"):Click()
end

-- ** Dragging Logic **
local isDragging = false
local dragStartPos
TitleBar.MouseButton1Down:Connect(function(x, y)
    isDragging = true
    dragStartPos = Vector2.new(x, y) - Vector2.new(Frame.AbsolutePosition.X, Frame.AbsolutePosition.Y)
end)
UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        Frame.Position = UDim2.new(0, input.Position.X - dragStartPos.X, 0, input.Position.Y - dragStartPos.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ** Minimize Logic **
local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Frame.Size = UDim2.new(0, 550, 0, 30)
        MinimizeButton.Text = "+"
        Sidebar.Visible = false
        ContentFrame.Visible = false
    else
        Frame.Size = UDim2.new(0, 550, 0, 350)
        MinimizeButton.Text = "—"
        Sidebar.Visible = true
        ContentFrame.Visible = true
    end
end)

print("Sora V1 (Bunny Edition) berhasil dimuat.")
