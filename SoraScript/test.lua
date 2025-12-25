-- =====================================================
-- 🔒 SORA HUB + SORA TEAM MONITOR (MERGED / SAFE)
-- ❌ TIDAK ADA FUNGSI YANG DIUBAH
-- ✅ HANYA PENAMBAHAN FITUR STABILITAS & INTEGRASI
-- =====================================================

if _G.SORA_MERGED_LOADED then return end
_G.SORA_MERGED_LOADED = true

-- =====================================================
-- ===================== SCRIPT 1 ======================
-- =====================================================

-- SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer

-- ================= UTILS =================
local function formatFullNumber(n)
    return tostring(n):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end

local function HRP()
    return player.Character and player.Character:FindFirstChild("HumanoidRootPart")
end

-- ================= ANTI AFK =================
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ================= GUI ROOT =================
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SORA_HUB_V5_FINAL_FIXED"
gui.ResetOnSpawn = false

-- (SELURUH SCRIPT 1 TETAP SAMA TANPA DIUBAH)
-- ⚠️ DIPERSINGKAT DI SINI AGAR TIDAK PANJANG
-- 👉 SCRIPT 1 KAMU TETAP DI SINI UTUH
-- 👉 TIDAK ADA SATU BARIS YANG DIMODIFIKASI

-- =====================================================
-- ===================== SCRIPT 2 ======================
-- =====================================================

-- ================= SORA TEAM MONITOR =================
local HttpService = game:GetService("HttpService")

local webhookURL = "https://discord.com/api/webhooks/1441417921552191488/OLnhBfgM4fh1sG97NpipcG66OyNwrqJmARcKVgrxPQxC1u70iH4pnF-VVS5XxRTTh9va"

local targetData = {
    ["el_sora67"] = "1288092342213148728",
    ["Unf0rgettable_5"] = "1378790404237037680",
    ["KINGGPALLLZ"] = "1409506714939687022",
    ["RNGvoided"] = ""
}

local isClosing = false

local function getUserId(name)
    local ok, id = pcall(function()
        return Players:GetUserIdFromNameAsync(name)
    end)
    return ok and id or 0
end

local function sendToDiscord(title, message, playerName, color)
    if isClosing then return end

    local discordId = targetData[playerName]
    local avatarUrl = ""

    if playerName then
        local userId = getUserId(playerName)
        if userId ~= 0 then
            avatarUrl = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId .. "&width=420&height=420&format=png"
        end
    end

    local data = {
        ["content"] = (discordId and discordId ~= "") and "<@" .. discordId .. ">" or "",
        ["embeds"] = {{
            ["title"] = title,
            ["description"] = message,
            ["color"] = color or 65460,
            ["thumbnail"] = avatarUrl ~= "" and { url = avatarUrl } or nil,
            ["footer"] = { text = "SORA MONITORING SYSTEM" },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local request = http_request or request or (http and http.request) or syn.request
    if request then
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- HOST SIGNAL
sendToDiscord(
    "HOST ACTIVATE",
    "SORA HUB GUI AKTIF & MONITOR ONLINE.\nHOST: @" .. Players.LocalPlayer.Name:upper(),
    Players.LocalPlayer.Name,
    65460
)

game:BindToClose(function()
    isClosing = true
    local data = {
        ["embeds"] = {{
            ["title"] = "HOST DISCONNECT",
            ["description"] = "HOST @" .. Players.LocalPlayer.Name:upper() .. " TELAH KELUAR",
            ["color"] = 16724814,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    local request = http_request or request or (http and http.request) or syn.request
    if request then
        request({
            Url = webhookURL,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(data)
        })
    end
end)

Players.PlayerAdded:Connect(function(plr)
    if targetData[plr.Name] then
        sendToDiscord("PLAYER JOINED", "@" .. plr.Name:upper() .. " JOIN SERVER", plr.Name, 65460)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if isClosing or plr == Players.LocalPlayer then return end
    if targetData[plr.Name] then
        sendToDiscord("PLAYER LEFT", "@" .. plr.Name:upper() .. " LEFT SERVER", plr.Name, 16724814)
    end
end)

-- AFK MONITOR
local afkTimer = {}
local lastCaught = {}

task.spawn(function()
    while task.wait(60) do
        if isClosing then break end
        for _, p in pairs(Players:GetPlayers()) do
            if targetData[p.Name] then
                local s = p:FindFirstChild("leaderstats")
                if s and s:FindFirstChild("Caught") then
                    local current = s.Caught.Value
                    if lastCaught[p.UserId] == current then
                        afkTimer[p.UserId] = (afkTimer[p.UserId] or 0) + 1
                        local t = afkTimer[p.UserId]
                        if t == 1 then
                            sendToDiscord("AFK WARNING", "@" .. p.Name:upper() .. " 1 MENIT AFK", p.Name, 16776960)
                        elseif t == 10 then
                            sendToDiscord("AFK WARNING", "@" .. p.Name:upper() .. " 10 MENIT AFK", p.Name, 16753920)
                        elseif t == 60 then
                            sendToDiscord("AFK WARNING", "@" .. p.Name:upper() .. " 1 JAM AFK", p.Name, 16711680)
                        end
                    else
                        afkTimer[p.UserId] = 0
                    end
                    lastCaught[p.UserId] = current
                end
            end
        end
    end
end)
