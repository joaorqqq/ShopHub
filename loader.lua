-- [[ APEX TEAM - OFFICIAL UNIVERSAL LOADER ]]
-- Powered by ShopHub & Apex Infrastructure

local function _d(s)
    local o = ""
    for i = 1, #s do o = o .. string.char(string.byte(s, i) - 1) end
    return o
end

-- Configurações de Boot
local CONFIG = {
    Main = "https://raw.githubusercontent.com/joaorqqq/ShopHub/refs/heads/main/main.lua",
    Version = "https://raw.githubusercontent.com/joaorqqq/ShopHub/refs/heads/main/Version.md"
}

-- Interface de Carregamento Rápida
local CoreGui = game:GetService("CoreGui")
local Screen = Instance.new("ScreenGui", CoreGui)
Screen.Name = "ApexLoader"

local Main = Instance.new("Frame", Screen)
Main.Size = UDim2.new(0, 320, 0, 80)
Main.Position = UDim2.new(0.5, -160, 0.5, -40)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(0, 150, 255)

local Label = Instance.new("TextLabel", Main)
Label.Size = UDim2.new(1, 0, 1, 0)
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.Font = Enum.Font.GothamMedium
Label.TextSize = 14
Label.Text = "Initializing Apex Core..."

-- [ PROCESSO DE CARREGAMENTO ]
task.spawn(function()
    -- 1. Check de Versão
    local vSuccess, vContent = pcall(function() return game:HttpGet(CONFIG.Version) end)
    if vSuccess then
        Label.Text = "Apex ShopAI v" .. vContent:gsub("%s+", "")
        task.wait(0.5)
    end

    -- 2. Download do Script Principal (Dependent)
    Label.Text = "Downloading Main Module..."
    local sSuccess, sContent = pcall(function() 
        -- Adicionamos um tick() no final para evitar cache do GitHub
        return game:HttpGet(CONFIG.Main .. "?t=" .. tick()) 
    end)

    if sSuccess then
        Label.Text = "Booting ShopAI..."
        Label.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.wait(0.5)
        
        Screen:Destroy()
        
        -- Execução Segura na Memória
        local finalScript = loadstring(sContent)
        if finalScript then
            finalScript()
        else
            warn("Apex Error: Syntax error in main module.")
        end
    else
        Label.Text = "Connection Failed. Check GitHub Status."
        Label.TextColor3 = Color3.fromRGB(255, 50, 80)
        task.wait(3)
        Screen:Destroy()
    end
end)
