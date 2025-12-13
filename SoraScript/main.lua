local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- AUTO CENTER (POSISI KAMU SAAT EXECUTE)
local center = hrp.Position
local R = 15 -- jarak totem dari center (ubah kalau perlu)

-- 12 POSISI TOTEM (3D)
local points = {
	Vector3.new( R,  0,  0),
	Vector3.new(-R,  0,  0),
	Vector3.new( 0,  0,  R),
	Vector3.new( 0,  0, -R),
	Vector3.new( 0,  R,  0),
	Vector3.new( 0, -R,  0),

	Vector3.new( R,  R,  0),
	Vector3.new(-R,  R,  0),
	Vector3.new( 0,  R,  R),
	Vector3.new( 0,  R, -R),

	Vector3.new( R, -R,  0),
	Vector3.new(-R, -R,  0),
}

-- UI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 260)
main.Position = UDim2.new(0.05, 0, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

-- TOP BAR
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 30)
top.BackgroundColor3 = Color3.fromRGB(15,15,20)
top.BorderSizePixel = 0

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Sora v1"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", top)
minBtn.Size = UDim2.new(0, 30, 0, 22)
minBtn.Position = UDim2.new(1, -35, 0, 4)
minBtn.Text = "-"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 18
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.BackgroundColor3 = Color3.fromRGB(40,40,45)
minBtn.BorderSizePixel = 0

-- CONTENT
local content = Instance.new("Frame", main)
content.Position = UDim2.new(0, 0, 0, 30)
content.Size = UDim2.new(1, 0, 1, -30)
content.BackgroundTransparency = 1

local layout = Instance.new("UIGridLayout", content)
layout.CellSize = UDim2.new(0, 110, 0, 30)
layout.CellPadding = UDim2.new(0, 10, 0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center

-- BUTTON TOTEM
for i = 1, 12 do
	local btn = Instance.new("TextButton")
	btn.Parent = content
	btn.Text = "Totem "..i
	btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BorderSizePixel = 0
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 14

	btn.MouseButton1Click:Connect(function()
		hrp.CFrame = CFrame.new(center + points[i])
	end)
end

-- MINIMIZE LOGIC
local minimized = false
local normalSize = main.Size

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		content.Visible = false
		main.Size = UDim2.new(0, 260, 0, 30)
		minBtn.Text = "+"
	else
		content.Visible = true
		main.Size = normalSize
		minBtn.Text = "-"
	end
end)
