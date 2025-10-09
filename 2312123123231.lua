-- Touch fling gui

-- Gui to Lua (VIP VERSION)
-- Version: 6.9

-- Instances:

local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")
local TextButton = Instance.new("TextButton")

-- Properties:

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
print("sub to DuplexScripts")

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0.388539821, 0, 0.427821517, 0)
Frame.Size = UDim2.new(0, 158, 0, 110)

Frame_2.Parent = Frame
Frame_2.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Size = UDim2.new(0, 158, 0, 25)

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

-- Scripts:

local function IIMAWH_fake_script() -- TextButton.LocalScript 
    local script = Instance.new('LocalScript', TextButton)

    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    local toggleButton = script.Parent
    local flingThread = nil

    -- Detection object for ReplicatedStorage
    if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
        local detection = Instance.new("Decal")
        detection.Name = "juisdfj0i32i0eidsuf0iok"
        detection.Parent = ReplicatedStorage
    end

    -- New fling logic
    local function fling()
        local lp = Players.LocalPlayer
        local c, hrp, vel, movel = nil, nil, nil, 0.1

        while true do 
            RunService.Heartbeat:Wait()
            c = lp.Character
            hrp = c and c:FindFirstChild("HumanoidRootPart")

            -- Error handling: Stop if character is dead or HumanoidRootPart is missing
            if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
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

    -- Toggle button logic
    toggleButton.MouseButton1Click:Connect(function()
        if not flingThread or coroutine.status(flingThread) == "dead" then
            -- Start fling
            flingThread = coroutine.wrap(fling)()
            toggleButton.Text = "ON"
        else
            -- Stop fling by creating a new thread (since we can't directly terminate coroutines)
            flingThread = nil
            toggleButton.Text = "OFF"
        end
    end)
end
coroutine.wrap(IIMAWH_fake_script)()

local function QCJQJL_fake_script() -- Frame.LocalScript 
    local script = Instance.new('LocalScript', Frame)
    script.Parent.Active = true
    script.Parent.Draggable = true
end
coroutine.wrap(QCJQJL_fake_script)()