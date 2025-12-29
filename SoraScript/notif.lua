-- REPOSITORY: FISH-UI-RESTORER
local Player = game:GetService("Players").LocalPlayer
local TextNotifications = Player:WaitForChild("PlayerGui"):WaitForChild("Text Notifications")
local TargetDuration = 5.5

print("--- [GITHUB LOADED: UI IMMORTAL SYSTEM] ---")

local function makeImmortal(obj)
    -- Target berdasarkan hasil Hunter: Tile & Header
    if obj.Name == "Tile" or obj.Name == "Header" then
        local canDestroy = false
        
        -- Kunci Parent agar tidak dipindah ke NULL oleh Seraphine
        local connection
        connection = obj:GetPropertyChangedSignal("Parent"):Connect(function()
            if not canDestroy and obj.Parent ~= TextNotifications.Frame then
                obj.Parent = TextNotifications.Frame
            end
        end)

        task.delay(TargetDuration, function()
            canDestroy = true
            if connection then connection:Disconnect() end
            obj:Destroy()
        end)
    end
end

TextNotifications.Frame.DescendantAdded:Connect(makeImmortal)
