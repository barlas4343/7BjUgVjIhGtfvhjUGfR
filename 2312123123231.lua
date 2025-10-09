local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- GUI Oluşturma
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Enabled = false
print("sub to DuplexScripts")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.3885, 0, 0.4278, 0)
Frame.Size = UDim2.new(0, 158, 0, 110)

local Frame_2 = Instance.new("Frame")
Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 25)

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = Frame_2
TextLabel.BackgroundTransparency = 1
TextLabel.Position = UDim2.new(0.112, 0, -0.015, 0)
TextLabel.Size = UDim2.new(0, 121, 0, 26)
TextLabel.Font = Enum.Font.Sarpanch
TextLabel.Text = "Touch Fling"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 25

local TextButton = Instance.new("TextButton")
TextButton.Parent = Frame
TextButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextButton.BorderSizePixel = 0
TextButton.Position = UDim2.new(0.1139, 0, 0.4181, 0)
TextButton.Size = UDim2.new(0, 121, 0, 37)
TextButton.Font = Enum.Font.SourceSansItalic
TextButton.Text = "OFF"
TextButton.TextColor3 = Color3.fromRGB(0, 0, 0)
TextButton.TextSize = 20

-- Draggable
local dragScript = Instance.new('LocalScript', Frame)
dragScript.Parent.Active = true
dragScript.Parent.Draggable = true

-- Detection
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end

-- Fling fonksiyonu
local function fling()
    local lp = Players.LocalPlayer
    local active = false
    local movel = 0.1
    local c, hrp, vel

    -- Karakter yeniden doğarsa güncelle
    lp.CharacterAdded:Connect(function(char)
        c = char
        hrp = char:WaitForChild("HumanoidRootPart", 5)
    end)

    TextButton.MouseButton1Click:Connect(function()
        active = not active
        TextButton.Text = active and "ON" or "OFF"
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Touch Fling",
            Text = active and "Fling turned ON" or "Fling turned OFF",
            Duration = 3
        })
    end)

    -- Sonsuz döngü (ölse bile asla durmaz)
    while true do
        RunService.Heartbeat:Wait()
        if not active then
            continue
        end

        c = lp.Character
        if c then
            hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")

            -- Karakter ölse bile bekle, sonra yeniden doğunca devam et
            if hum and hum.Health <= 0 then
                hrp = nil
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
end

-- API
return {
    fling = coroutine.wrap(fling),
    enableGui = function()
        ScreenGui.Enabled = true
    end,
    disableGui = function()
        ScreenGui.Enabled = false
    end
}
