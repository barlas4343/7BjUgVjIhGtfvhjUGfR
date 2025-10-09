local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
    local active = false -- Fling kontrolü için boolean

    -- Ana kodun fling boolean'ını izlemek için
    local connection
    connection = game:GetService("Players").LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
        if not lp.Character or (lp.Character and lp.Character:FindFirstChild("Humanoid") and lp.Character.Humanoid.Health <= 0) then
            active = false
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Touch Fling",
                Text = "Fling stopped due to character death",
                Duration = 3
            })
        end
    end)

    -- Ana kodun fling boolean'ını izlemek için
    -- (Bu, dışarıdan erişilecek bir fonksiyonla kontrol edilecek)
    local function setActive(state)
        active = state
    end

    while true do 
        RunService.Heartbeat:Wait()
        if not active then
            continue -- Fling kapalıyken bekle
        end

        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        -- Hata kontrolü
        if not hrp or (c and c:FindFirstChild("Humanoid") and c.Humanoid.Health <= 0) then
            connection:Disconnect()
            active = false
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

-- API: Fling fonksiyonu ve active kontrolü
return {
    fling = coroutine.wrap(fling),
    setActive = function(state)
        _G.flingActive = state -- Global değişkenle active kontrolü
    end
}