@ -1,38 +1,38 @@
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local stopFling = false -- dışarıdan kontrol için

local function fling()
	local lp = Players.LocalPlayer

	local movel = 0
	local c, hrp, vel

	lp.CharacterAdded:Connect(function(char)
		c = char
		hrp = char:WaitForChild("HumanoidRootPart", 5)
	end)

	if lp.Character then
		c = lp.Character
		hrp = c:FindFirstChild("HumanoidRootPart")
	end

	while not stopFling do
		RunService.Heartbeat:Wait()
		c = lp.Character
		if c then
			hrp = c:FindFirstChild("HumanoidRootPart")
			local hum = c:FindFirstChildOfClass("Humanoid")

			if hum and hum.Health <= 0 then
				hrp = nil
			end

