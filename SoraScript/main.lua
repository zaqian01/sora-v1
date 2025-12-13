--========================================
-- SORA v1 | Fly + NoClip (FINAL)
--========================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

--========================================
-- STATE
--========================================
local FlyEnabled = false
local NoClipEnabled = false
local FlySpeed = 60

local BV, BG

--========================================
-- FLY FUNCTIONS
--========================================
local function StartFly()
	if BV then return end

	BG = Instance.new("BodyGyro")
	BG.P = 9e4
	BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
	BG.CFrame = hrp.CFrame
	BG.Parent = hrp

	BV = Instance.new("BodyVelocity")
	BV.MaxForce = Vector3.new(9e9,9e9,9e9)
	BV.Parent = hrp

	RunService:BindToRenderStep("SoraFly", 200, function()
		if not FlyEnabled then return end

		local cam = workspace.CurrentCamera
		local dir = Vector3.zero

		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

		if dir.Magnitude > 0 then
			BV.Velocity = dir.Unit * FlySpeed
		else
			BV.Velocity = Vector3.zero
		end

		BG.CFrame = cam.CFrame
	end)
end

local function StopFly()
	RunService:UnbindFromRenderStep("SoraFly")
	if BV then BV:Destroy() BV = nil end
	if BG then BG:Destroy() BG = nil end
end

--========================================
-- NOCLIP
--========================================
RunService.Stepped:Connect(function()
	if not NoClipEnabled then return end
	for _,v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
end)

--========================================
-- UI
--========================================
local gui = Instance.new("ScreenGui")
gui.Name = "SoraUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,260,0,170)
main.Position = UDim2.new(0.05,0,0.4,0)
main.BackgroundColor3 = Color3.fromRGB(20,20,25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,30)
top.BackgroundColor3 = Color3.fromRGB(15,15,20)
top.BorderSizePixel = 0

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-40,1,0)
title.Position = UDim2.new(0,10,0,0)
title.Text = "Sora v1"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local min = Instance.new("TextButton", top)
min.Size = UDim2.new(0,30,0,22)
min.Position = UDim2.new(1,-35,0,4)
min.Text = "-"
min.BackgroundColor3 = Color3.fromRGB(40,40,45)
min.TextColor3 = Color3.new(1,1,1)
min.BorderSizePixel = 0
min.Font = Enum.Font.SourceSansBold
min.TextSize = 18

local body = Instance.new("Frame", main)
body.Position = UDim2.new(0,0,0,30)
body.Size = UDim2.new(1,0,1,-30)
body.BackgroundTransparency = 1

--========================================
-- BUTTON CREATOR
--========================================
local function MakeButton(text, yOffset)
	local b = Instance.new("TextButton")
	b.Parent = body
	b.Size = UDim2.new(0,200,0,30)
	b.Position = UDim2.new(0,30,0,yOffset)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(45,45,50)
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 14
	return b
end

local FlyBtn = MakeButton("Fly : OFF", 20)
local NoClipBtn = MakeButton("NoClip : OFF", 60)

--========================================
-- BUTTON LOGIC
--========================================
FlyBtn.MouseButton1Click:Connect(function()
	FlyEnabled = not FlyEnabled
	FlyBtn.Text = FlyEnabled and "Fly : ON" or "Fly : OFF"
	if FlyEnabled then
		StartFly()
	else
		StopFly()
	end
end)

NoClipBtn.MouseButton1Click:Connect(function()
	NoClipEnabled = not NoClipEnabled
	NoClipBtn.Text = NoClipEnabled and "NoClip : ON" or "NoClip : OFF"
end)

--========================================
-- MINIMIZE
--========================================
local minimized = false
local normalSize = main.Size

min.MouseButton1Click:Connect(function()
	minimized = not minimized
	body.Visible = not minimized
	main.Size = minimized and UDim2.new(0,260,0,30) or normalSize
	min.Text = minimized and "+" or "-"
end)
