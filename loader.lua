-- [[ APEX TEAM - SHOPAI OFFICIAL LOADER ]]
-- Version: 1.0.5 | Sync: Active | Redundancy: Enabled

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local CURRENT_VERSION = "V1.0" -- Versão atual deste Loader

-- URLs de Infraestrutura
local REPO = "https://raw.githubusercontent.com/joaorqqq/ShopHub/refs/heads/main/"
local MAIN_URL = REPO .. "main.lua"
local BACKUP_URL = REPO .. "Backup.lua"
local VERSION_URL = REPO .. "Version.md"

-- [[ INTERFACE DE CARREGAMENTO ]]
local Screen = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(0, 300, 0, 100)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
Instance.new("UICorner", MainFrame)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 1, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 13
Status.Text = "Checking Version..."

-- [[ LÓGICA DE CARREGAMENTO ]]
task.spawn(function()
    -- 1. Checagem de Versão
    local vSuccess, vContent = pcall(function() 
        return game:HttpGet(VERSION_URL .. "?t=" .. tick()) 
    end)
    
    local latestVersion = vSuccess and vContent:gsub("%s+", "") or "Unknown"
    
    if latestVersion ~= CURRENT_VERSION and latestVersion ~= "Unknown" then
        Status.Text = "Update Required: v" .. latestVersion
        Status.TextColor3 = Color3.fromRGB(255, 50, 80)
        warn("Apex Team: Sua versão (v" .. CURRENT_VERSION .. ") está desatualizada. Versão atual: v" .. latestVersion)
        task.wait(2) -- Dá tempo do usuário ver que precisa atualizar
    else
        Status.Text = "Version v" .. CURRENT_VERSION .. " Verified"
        Status.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.wait(0.5)
    end

    -- 2. Função de Loadstring com Failover
    local function TryLoad(url, isBackup)
        Status.Text = isBackup and "Loading Backup Protocol..." or "Downloading Main Core..."
        Status.TextColor3 = isBackup and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 255, 255)

        local success, content = pcall(function()
            return game:HttpGet(url .. "?t=" .. tick())
        end)

        if success and content and #content > 50 then
            local loadCode = loadstring(content)
            if loadCode then
                Screen:Destroy()
                print("-----------------------------------------")
                print("APEX TEAM: LOADED SUCCESSFUL")
                print("Source: " .. (isBackup and "Backup.lua" or "main.lua"))
                print("-----------------------------------------")
                loadCode()
                return true
            end
        end
        return false
    end

    -- Tenta o Main. Se falhar, tenta o Backup.
    if not TryLoad(MAIN_URL, false) then
        if not TryLoad(BACKUP_URL, true) then
            Status.Text = "Critical Error: All servers offline."
            Status.TextColor3 = Color3.fromRGB(255, 50, 80)
            task.wait(3)
            Screen:Destroy()
        end
    end
end)
