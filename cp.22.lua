--[[
    EXC FREEMIUM HUB
    Developed by: Exc
    Version: 3.5 (Free Edition)
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- [1] CONFIGURATION
--------------------------------------------------------------------------------

local ScriptLinks = {
    ["Mount Funny"]     = "https://raw.githubusercontent.com/exc2222/funny/main/funny.lua",
    ["Mount Ragon"]     = "https://raw.githubusercontent.com/exc2222/ragon/main/ragon.lua",
    ["Mount Molti"]     = "https://raw.githubusercontent.com/exc2222/molti/main/molti.lua",
    ["Mount Wasabi"]    = "https://raw.githubusercontent.com/exc2222/wasabi/main/wasabi.lua",
    ["Mount Freestyle"] = "https://raw.githubusercontent.com/exc2222/freestyle/main/freestyle.lua",
    ["Mount Gemi"]      = "https://raw.githubusercontent.com/exc2222/gemi/main/gemi.lua",
    ["Mount Aethria"]   = "https://raw.githubusercontent.com/exc2222/aethria/main/aethria.lua",
    ["Mount Velora"]    = "https://raw.githubusercontent.com/exc2222/velora/main/velora.lua",
    ["Mount Age"]       = "https://raw.githubusercontent.com/exc2222/age/main/age.lua",
    ["Mount Runia"]     = "https://raw.githubusercontent.com/exc2222/runia/main/runia.lua",
    ["Mount Tali"]      = "https://raw.githubusercontent.com/exc2222/tali/main/tali.lua",
    ["Mount Yahayuk"]   = "https://raw.githubusercontent.com/exc2222/yahayuk/main/yahayuk.lua",
    ["Mount Antartika"] = "https://raw.githubusercontent.com/exc2222/antartika/main/antartika.lua",
    ["Mount Fells"]     = "https://raw.githubusercontent.com/exc2222/fells/main/fells.lua",
    ["Mount Bagendah"]  = "https://raw.githubusercontent.com/exc2222/bagendah/main/bagendah.lua",
    ["Mount Luna"]      = "https://raw.githubusercontent.com/exc2222/luna/main/luna.lua"
}

--------------------------------------------------------------------------------
-- [2] HELPER FUNCTIONS
--------------------------------------------------------------------------------

-- Fungsi untuk menyensor nama (hanya huruf depan dan belakang)
local function CensorName(name)
    if #name <= 2 then
        return name
    end
    local firstChar = string.sub(name, 1, 1)
    local lastChar = string.sub(name, -1)
    local middleLength = #name - 2
    local censored = string.rep("*", middleLength)
    return firstChar .. censored .. lastChar
end

-- Fungsi untuk sort A-Z
local function GetSortedMountNames()
    local names = {}
    for name, _ in pairs(ScriptLinks) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

-- Fungsi untuk mendapatkan list player yang BISA di-teleport (sudah spawn)
local function GetSpawnedPlayerList()
    local playerNames = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Hanya tampilkan player yang punya character dan HumanoidRootPart
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(playerNames, player.Name)
            end
        end
    end
    table.sort(playerNames)
    return playerNames
end

--------------------------------------------------------------------------------
-- [3] RAYFIELD UI SETUP
--------------------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "EXC FREEMIUM | " .. CensorName(LocalPlayer.DisplayName),
    LoadingTitle = "Welcome to Freemium...",
    LoadingSubtitle = "Welcome to Exc Hub",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ExcHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false, 
        Invite = "noinvitelink", 
        RememberJoins = true 
    },
    KeySystem = false -- Key system dinonaktifkan untuk freemium
})

Rayfield.Theme = "Amethyst" 

--------------------------------------------------------------------------------
-- [4] TABS & FEATURES
--------------------------------------------------------------------------------

-- == AUTO WALK (TAB PERTAMA) ==
local TabMounts = Window:CreateTab("Auto Walk", 4483362458)
TabMounts:CreateSection("Select Mount Location")

local SortedMounts = GetSortedMountNames()

-- Membuat button untuk setiap mount (A-Z sorted)
for _, mountName in ipairs(SortedMounts) do
    TabMounts:CreateButton({
        Name = mountName,
        Callback = function()
            local targetURL = ScriptLinks[mountName]
            
            if targetURL then
                Rayfield:Notify({
                    Title = "Injecting...",
                    Content = "Loading " .. mountName,
                    Duration = 2,
                    Image = 4483362458,
                })
                
                task.wait(1) 
                
                local success, err = pcall(function()
                    loadstring(game:HttpGet(targetURL))()
                end)
                
                if success then
                    Rayfield:Notify({Title = "Success", Content = "Script Loaded!", Duration = 3})
                else
                    Rayfield:Notify({Title = "Error", Content = "Script Not Found (404)", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "Error", Content = "Link Config Missing", Duration = 3})
            end
        end,
    })
end

-- == PLAYER MENU ==
local TabPlayer = Window:CreateTab("Player", 4483362458)
TabPlayer:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Studs",
    CurrentValue = 16,
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})
TabPlayer:CreateToggle({
    Name = "Infinity Jump",
    CurrentValue = false,
    Callback = function(Value) _G.InfJump = Value end,
})
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)
TabPlayer:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value) _G.Noclip = Value end,
})
RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
end)

-- == FPS BOOSTER ==
local TabPerf = Window:CreateTab("Performance", 4483362458)
local function Optimize(Level)
    for _, v in pairs(Workspace:GetDescendants()) do
        if Level >= 1 and (v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter")) then 
            if v:IsA("ParticleEmitter") then v.Enabled = false else v:Destroy() end
        end
        if Level >= 2 and v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
            Lighting.GlobalShadows = false
        end
        if Level >= 3 and v:IsA("BasePart") then
            v.Color = Color3.new(1, 1, 1)
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end
end
TabPerf:CreateButton({Name = "Expert (White Mode)", Callback = function() Optimize(3) end})

-- == DISCORD ==
local TabDiscord = Window:CreateTab("Discord", 4483362458)
TabDiscord:CreateSection("Join Our Community")
TabDiscord:CreateParagraph({
    Title = "Discord Server",
    Content = "Click the button below to copy Discord invite link"
})

local DiscordInvite = "https://discord.gg/yourserver" -- Ganti dengan link Discord kamu

TabDiscord:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        setclipboard(DiscordInvite)
        Rayfield:Notify({
            Title = "Success!",
            Content = "Discord link copied to clipboard!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

TabDiscord:CreateButton({
    Name = "Join Discord (Browser)",
    Callback = function()
        local success = pcall(function()
            -- Mencoba membuka browser dengan link Discord
            game:GetService("GuiService"):OpenBrowserWindow(DiscordInvite)
        end)
        
        if success then
            Rayfield:Notify({
                Title = "Opening...",
                Content = "Opening Discord in browser",
                Duration = 2,
                Image = 4483362458,
            })
        else
            -- Jika gagal, copy ke clipboard
            setclipboard(DiscordInvite)
            Rayfield:Notify({
                Title = "Link Copied",
                Content = "Discord link copied to clipboard!",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

-- == MISC ==
local TabMisc = Window:CreateTab("Misc", 4483362458)
TabMisc:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = true,
    Callback = function(Value)
        _G.AntiAFK = Value
        if Value then
            LocalPlayer.Idled:Connect(function()
                if _G.AntiAFK then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        end
    end,
})
TabMisc:CreateButton({Name = "Rejoin Server", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end})

-- Teleport to Player
TabMisc:CreateSection("Teleport to Player")

local SelectedPlayerName = ""

-- Dropdown untuk pilih player (hanya yang spawned)
local PlayerDropdown = TabMisc:CreateDropdown({
    Name = "Select Player to Teleport",
    Options = GetSpawnedPlayerList(),
    CurrentOption = {},
    MultipleOptions = false,
    Flag = "TeleportPlayer",
    Callback = function(Option)
        if Option[1] then
            SelectedPlayerName = Option[1]
        end
    end,
})

-- Button untuk teleport
TabMisc:CreateButton({
    Name = "Teleport to Selected Player",
    Callback = function()
        if SelectedPlayerName == "" then
            Rayfield:Notify({
                Title = "Error",
                Content = "Please select a player first!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        local targetPlayer = Players:FindFirstChild(SelectedPlayerName)
        
        if not targetPlayer then
            Rayfield:Notify({
                Title = "Error",
                Content = "Player not found or left!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        -- Check your character
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Error",
                Content = "You have no character!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        -- Check target character
        if not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({
                Title = "Error",
                Content = SelectedPlayerName .. " is no longer spawned!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        -- Teleport
        local success = pcall(function()
            local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(3, 1, 0)
        end)
        
        if success then
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to " .. SelectedPlayerName,
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to teleport!",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

-- Button untuk refresh list
TabMisc:CreateButton({
    Name = "Refresh Player List",
    Callback = function()
        local spawnedPlayers = GetSpawnedPlayerList()
        
        Rayfield:Notify({
            Title = "Refreshed",
            Content = "Found " .. #spawnedPlayers .. " spawned players. Reopen dropdown to see list.",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- == BOOMBOX MUSIC PLAYER ==
TabMisc:CreateSection("🎵 Boombox Music Player")

local CurrentSound = nil
local BoomboxID = ""

TabMisc:CreateInput({
    Name = "Enter Boombox ID",
    PlaceholderText = "Example: 1837849285",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        BoomboxID = Text
    end,
})

TabMisc:CreateButton({
    Name = "▶️ Play Music",
    Callback = function()
        if BoomboxID == "" or BoomboxID == nil then
            Rayfield:Notify({
                Title = "Error",
                Content = "Please enter a Boombox ID first!",
                Duration = 2,
                Image = 4483362458,
            })
            return
        end
        
        -- Stop current sound if playing
        if CurrentSound then
            CurrentSound:Stop()
            CurrentSound:Destroy()
            CurrentSound = nil
        end
        
        -- Create new sound
        pcall(function()
            CurrentSound = Instance.new("Sound")
            CurrentSound.Parent = LocalPlayer.Character or Workspace
            CurrentSound.SoundId = "rbxassetid://" .. BoomboxID
            CurrentSound.Volume = 0.5
            CurrentSound.Looped = true
            CurrentSound:Play()
            
            Rayfield:Notify({
                Title = "🎵 Music Playing",
                Content = "Playing ID: " .. BoomboxID,
                Duration = 3,
                Image = 4483362458,
            })
        end)
    end,
})

TabMisc:CreateButton({
    Name = "⏸️ Stop Music",
    Callback = function()
        if CurrentSound then
            CurrentSound:Stop()
            CurrentSound:Destroy()
            CurrentSound = nil
            
            Rayfield:Notify({
                Title = "Music Stopped",
                Content = "Music has been stopped",
                Duration = 2,
                Image = 4483362458,
            })
        else
            Rayfield:Notify({
                Title = "No Music",
                Content = "No music is currently playing",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end,
})

TabMisc:CreateSlider({
    Name = "🔊 Volume",
    Range = {0, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 0.5,
    Callback = function(Value)
        if CurrentSound then
            CurrentSound.Volume = Value
        end
    end,
})

TabMisc:CreateToggle({
    Name = "🔁 Loop Music",
    CurrentValue = true,
    Callback = function(Value)
        if CurrentSound then
            CurrentSound.Looped = Value
        end
    end,
})

-- Preset Music IDs
TabMisc:CreateSection("🎼 Popular Music IDs")

local PopularSongs = {
    {name = "Tor Monitor", id = "70633665224310"},
    {name = "Hide A Seek But You", id = "106948989756646"},
    {name = "Bintang 5", id = "134435445558993"},
    {name = "DJ 1", id = "139825186779265"},
    {name = "DJ 2", id = "96077163288111"},
}

for _, song in ipairs(PopularSongs) do
    TabMisc:CreateButton({
        Name = "🎵 " .. song.name,
        Callback = function()
            BoomboxID = song.id
            
            -- Stop current sound
            if CurrentSound then
                CurrentSound:Stop()
                CurrentSound:Destroy()
                CurrentSound = nil
            end
            
            -- Play new sound
            pcall(function()
                CurrentSound = Instance.new("Sound")
                CurrentSound.Parent = LocalPlayer.Character or Workspace
                CurrentSound.SoundId = "rbxassetid://" .. song.id
                CurrentSound.Volume = 0.5
                CurrentSound.Looped = true
                CurrentSound:Play()
                
                Rayfield:Notify({
                    Title = "🎵 Now Playing",
                    Content = song.name,
                    Duration = 3,
                    Image = 4483362458,
                })
            end)
        end,
    })
end

TabMisc:CreateSection("UI Control")
TabMisc:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        -- Stop music before closing
        if CurrentSound then
            CurrentSound:Stop()
            CurrentSound:Destroy()
        end
        
        Rayfield:Notify({
            Title = "Closing...",
            Content = "UI will be destroyed in 2 seconds",
            Duration = 2,
            Image = 4483362458,
        })
        
        task.wait(2)
        Rayfield:Destroy()
    end,
})

-- == ABOUT ==
local TabAbout = Window:CreateTab("About", 4483362458)
TabAbout:CreateLabel("EXC FREEMIUM Script")
TabAbout:CreateParagraph({Title = "Credits", Content = "Developed by Exc "})
TabAbout:CreateParagraph({Title = "Version", Content = "Freemium V0.1"})

-- == DASHBOARD (TAB TERAKHIR) ==
local TabDashboard = Window:CreateTab("Dashboard", 4483362458)
TabDashboard:CreateSection("User Info")
TabDashboard:CreateParagraph({Title = "Display Name", Content = CensorName(LocalPlayer.DisplayName)})
TabDashboard:CreateParagraph({Title = "Username", Content = CensorName(LocalPlayer.Name)})
TabDashboard:CreateParagraph({Title = "Status", Content = "Freemium Active"})

Rayfield:LoadConfiguration()
