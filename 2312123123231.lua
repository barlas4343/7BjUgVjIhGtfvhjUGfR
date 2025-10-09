local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false -- Başlangıçta GUI görünmez
print("sub to DuplexScripts")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 110)

local Frame_2 = Instance.new("Frame")
Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 25)

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Position = UDim2.new(0.112792775, 0, -0.0151660154, 0)
TextLabel.Size = UDim2.new(0, 121, 0, 26)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "Touch Fling"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 25.000

local TextButton = Instance.new("TextButton")
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.113924049, 0, 0.418181807, 0)
TextButton.Size = UDim2.new(0, 121, 0, 37)
TextButton.Font = Enum.Font.SourceSansItalic
TextButton.Text = "OFF"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 20.000

-- Draggable frame
local dragScript = Instance.new('LocalScript', Frame)
dragScript.Parent.Active = true
dragScript.Parent.Draggable = true

-- Detection nesnesi
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Fling fonksiyonu (orijinal mantık + hata kontrolü)
local function fling()
    local lp = Players.LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1
    local active = false -- GUI toggle için boolean

    -- Kapatma sinyali için bağlantı
    local connection
    connection = lp:GetPropertyChangedSignal("Character"):Connect(function()
        if not lp.Character or (lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health <= 0) then
            active = false
            TextButton.Text = "OFF"
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Touch Fling",
                Text = "Fling stopped due to character death",
                Duration = 3
            })
        end
    end)

    -- TextButton toggle mantığı
    TextButton.MouseButton1Click:Connect(function()
        active = not active
        TextButton.Text = active and "ON" or "OFF"
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Touch Fling",
            Text = active and "Fling turned ON" or "Fling turned OFF",
            Duration = 3
        })
    end)

    while true do 
        RunService.Heartbeat:Wait()
        if not active then
            continue
        end

        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        -- Hata kontrolü
        if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
            connection:Disconnect()
            active = false
            TextButton.Text = "OFF"
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Touch Fling",
                Text = "Fling stopped due to character death",
                Duration = 3
            })
            return 
        end

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end

-- API: Fling fonksiyonu ve GUI kontrolü
return {
    fling = coroutine.wrap(fling),
    enableGui = function()
        ScreenGui.Enabled = true
    end,
    disableGui = function()
        ScreenGui.Enabled = false
    end
}