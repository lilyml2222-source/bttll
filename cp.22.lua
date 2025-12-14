--[[
    PREMIUM RAYFIELD HUB - PURPLE EDITION
    Developed by: Exc
    Version: 3.3 (Fixed Missing Tabs & Links)
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

-- Link RAW JSON Auth
local AuthURL = "https://raw.githubusercontent.com/lilyml2222-source/L/main/ww.json" 

-- SEMUA LINK MAP (Format: github/exc2222/nama/main/nama.lua)
local ScriptLinks = {
    -- Map Lama
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

    -- Map Baru
    ["Mount Yahayuk"]   = "https://raw.githubusercontent.com/exc2222/yahayuk/main/yahayuk.lua",
    ["Mount Antartika"] = "https://raw.githubusercontent.com/exc2222/antartika/main/antartika.lua",
    ["Mount Fells"]     = "https://raw.githubusercontent.com/exc2222/fells/main/fells.lua",
    ["Mount Bagendah"]  = "https://raw.githubusercontent.com/exc2222/bagendah/main/bagendah.lua"
}

--------------------------------------------------------------------------------
-- [2] AUTHENTICATION LOGIC (ANTI-DELAY)
--------------------------------------------------------------------------------
local UserKey = ""

local function GetAuthKey()
    local success, response = pcall(function()
        -- Anti-Cache (Update Realtime)
        return game:HttpGet(AuthURL .. "?v=" .. tostring(math.random(1, 999999)))
    end)

    if not success then
        LocalPlayer:Kick("Connection Error: Gagal menghubungi Database.")
        return nil
    end

    local data = HttpService:JSONDecode(response)

    if data.users and data.users[LocalPlayer.Name] then
        UserKey = data.users[LocalPlayer.Name]
        return UserKey
    else
        LocalPlayer:Kick("Access Denied: Akun '" .. LocalPlayer.Name .. "' tidak terdaftar.")
        return nil
    end
end

local ValidKey = GetAuthKey()
if not ValidKey then return end 

--------------------------------------------------------------------------------
-- [3] RAYFIELD UI SETUP
--------------------------------------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "EXC V1 | " .. LocalPlayer.DisplayName,
    LoadingTitle = "Verifying...",
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
    KeySystem = true, 
    KeySettings = {
        Title = "Security System",
        Subtitle = "Database Check",
        Note = "Hubungi Admin untuk Key",
        FileName = "ExcKeyAuth", 
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = { ValidKey } 
    }
})

Rayfield.Theme = "Amethyst" 

--------------------------------------------------------------------------------
-- [4] TABS & FEATURES
--------------------------------------------------------------------------------

-- == DASHBOARD ==
local TabDashboard = Window:CreateTab("Dashboard", 4483362458)
TabDashboard:CreateSection("User Info")
TabDashboard:CreateParagraph({Title = "Display Name", Content = LocalPlayer.DisplayName})
TabDashboard:CreateParagraph({Title = "Username", Content = LocalPlayer.Name})
TabDashboard:CreateParagraph({Title = "Roblox ID", Content = tostring(LocalPlayer.UserId)})
TabDashboard:CreateParagraph({Title = "Account Age", Content = tostring(LocalPlayer.AccountAge) .. " Days"})
TabDashboard:CreateParagraph({Title = "Status", Content = "Premium Active"})

-- == AUTO WALK (ALL MAPS) ==
local TabMounts = Window:CreateTab("Auto Walk", 4483362458)
TabMounts:CreateSection("Select Mount")

local SelectedMount = "Mount Yahayuk" -- Default

TabMounts:CreateDropdown({
    Name = "Mount Location",
    Options = {
        "Mount Funny", "Mount Ragon", "Mount Molti", "Mount Wasabi", 
        "Mount Freestyle", "Mount Gemi", "Mount Aethria", "Mount Velora", 
        "Mount Age", "Mount Runia", "Mount Tali",
        "Mount Yahayuk", "Mount Antartika", "Mount Fells", "Mount Bagendah"
    },
    CurrentOption = {"Mount Yahayuk"},
    MultipleOptions = false,
    Flag = "MountSelect",
    Callback = function(Option)
        SelectedMount = Option[1]
    end,
})

TabMounts:CreateButton({
    Name = "Inject Script",
    Callback = function()
        local targetURL = ScriptLinks[SelectedMount]
        
        if targetURL then
            Rayfield:Notify({
                Title = "Injecting...",
                Content = "Loading " .. SelectedMount,
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

-- == ANIMATION ==
local TabAnim = Window:CreateTab("Animation", 4483362458)
local AnimData = {Run = "", Jump = "", Idle = ""}
TabAnim:CreateInput({Name = "Run ID", PlaceholderText = "ID...", Callback = function(Text) AnimData.Run = Text end})
TabAnim:CreateInput({Name = "Jump ID", PlaceholderText = "ID...", Callback = function(Text) AnimData.Jump = Text end})
TabAnim:CreateInput({Name = "Idle ID", PlaceholderText = "ID...", Callback = function(Text) AnimData.Idle = Text end})
TabAnim:CreateButton({
    Name = "Apply Anim",
    Callback = function()
        local Char = LocalPlayer.Character
        if Char and Char:FindFirstChild("Animate") then
            pcall(function() 
                if AnimData.Run ~= "" then Char.Animate.run.RunAnim.AnimationId = "rbxassetid://"..AnimData.Run end
                if AnimData.Jump ~= "" then Char.Animate.jump.JumpAnim.AnimationId = "rbxassetid://"..AnimData.Jump end
                if AnimData.Idle ~= "" then 
                    Char.Animate.idle.Animation1.AnimationId = "rbxassetid://"..AnimData.Idle 
                    Char.Animate.idle.Animation2.AnimationId = "rbxassetid://"..AnimData.Idle 
                end
            end)
            Rayfield:Notify({Title = "Done", Content = "Animation Applied", Duration = 2})
        end
    end,
})

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
TabPerf:CreateButton({Name = "Medium (No Textures)", Callback = function() Optimize(1) end})
TabPerf:CreateButton({Name = "Hard (Smooth Plastic)", Callback = function() Optimize(2) end})
TabPerf:CreateButton({Name = "Expert (White Mode)", Callback = function() Optimize(3) end})

-- == MISC ==
local TabMisc = Window:CreateTab("Misc", 4483362458)
TabMisc:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
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
TabMisc:CreateToggle({
    Name = "Auto Kick Admin",
    CurrentValue = false,
    Callback = function(Value) _G.AutoKick = Value end,
})
Players.PlayerAdded:Connect(function(plr)
    if _G.AutoKick and plr:GetRankInGroup(00000) > 2 then -- Ganti 00000 dengan ID Group
        LocalPlayer:Kick("Admin Detected")
    end
end)
TabMisc:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local success, servers = pcall(function()
            return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        end)
        if success and servers.data then
            for _, Server in pairs(servers.data) do
                if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, LocalPlayer)
                    break
                end
            end
        end
    end,
})
TabMisc:CreateButton({Name = "Rejoin", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end})

-- == ABOUT (SAYA KEMBALIKAN BAGIAN INI) ==
local TabAbout = Window:CreateTab("About", 4483362458)
TabAbout:CreateLabel("Premium Script Hub v1")
TabAbout:CreateParagraph({Title = "Credits", Content = "Developed by Exc"})
TabAbout:CreateButton({
    Name = "Copy Discord Link",
    Callback = function()
        -- Ganti link discord di bawah ini
        setclipboard("https://discord.gg/GANTI_DENGAN_LINK_MU")
        Rayfield:Notify({Title = "Success", Content = "Discord Link Copied!", Duration = 2})
    end,
})

Rayfield:LoadConfiguration()

