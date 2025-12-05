--[[  
    AUTO WALK HUB by ChatGPT  
    Fitur:
    - UI mirip premium hub
    - Dropdown "Pilih Gunung"
    - Execute script otomatis ketika dipilih
]]--

-- UI ROOT
local ui = Instance.new("ScreenGui", game.CoreGui)
ui.Name = "AutoWalkUI"

-- MAIN FRAME
local main = Instance.new("Frame", ui)
main.Size = UDim2.new(0, 480, 0, 300)
main.Position = UDim2.new(0.5, -240, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

-- SIDEBAR
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 140, 1, 0)
side.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", side).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", side)
title.Text = "AUTO WALK"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)

-- DROPDOWN FRAME
local dropFrame = Instance.new("Frame", main)
dropFrame.Size = UDim2.new(0, 280, 0, 50)
dropFrame.Position = UDim2.new(0, 160, 0, 50)
dropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
dropFrame.BorderSizePixel = 0
Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 10)

local dropLabel = Instance.new("TextLabel", dropFrame)
dropLabel.Text = "Pilih Gunung"
dropLabel.Font = Enum.Font.Gotham
dropLabel.TextSize = 16
dropLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
dropLabel.BackgroundTransparency = 1
dropLabel.Size = UDim2.new(1, -40, 1, 0)
dropLabel.Position = UDim2.new(0, 10, 0, 0)

local dropButton = Instance.new("TextButton", dropFrame)
dropButton.Size = UDim2.new(0, 30, 0, 30)
dropButton.Position = UDim2.new(1, -35, 0, 10)
dropButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
dropButton.Text = "▼"
dropButton.Font = Enum.Font.GothamBold
dropButton.TextSize = 16
dropButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dropButton).CornerRadius = UDim.new(0, 6)

-- DROPDOWN LIST
local list = Instance.new("Frame", main)
list.Size = UDim2.new(0, 280, 0, 0)
list.Position = dropFrame.Position + UDim2.new(0, 0, 0, 50)
list.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
list.BorderSizePixel = 0
list.Visible = false
Instance.new("UICorner", list).CornerRadius = UDim.new(0, 10)

local layout = Instance.new("UIListLayout", list)
layout.Padding = UDim.new(0, 5)

-- DAFTAR GUNUNG (ISI DI SINI)
local GunungList = {
    ["mt botol"] = "https://raw.githubusercontent.com/lilyml2222-source/bttll/refs/heads/main/botol.lua",
    ["Gunung 2"] = "https://raw.githubusercontent.com/xx/gunung2.lua",
    ["Gunung 3"] = "https://raw.githubusercontent.com/xx/gunung3.lua",
}

-- BUAT BUTTON LIST AUTOMATIS
for name, url in pairs(GunungList) do
    local btn = Instance.new("TextButton", list)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    btn.MouseButton1Click:Connect(function()
        dropLabel.Text = "Memuat: " .. name .. "..."
        list.Visible = false

        -- EXECUTE SCRIPT
        loadstring(game:HttpGet(url))()
        dropLabel.Text = "Dipilih: " .. name
    end)
end

-- DROPDOWN TOGGLE
dropButton.MouseButton1Click:Connect(function()
    list.Visible = not list.Visible

    if list.Visible then
        list.Size = UDim2.new(0, 280, 0, (#GunungList * 40) + 10)
    else
        list.Size = UDim2.new(0, 280, 0, 0)
    end
end)

-- BLUR
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 12
