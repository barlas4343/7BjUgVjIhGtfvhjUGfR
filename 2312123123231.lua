local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create detection Decal if not exists
if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local stopFling = false
local FLING_FORCE = 50000 -- Insanely high force for instant flinging
local DETECTION_RANGE = 5 -- Range to detect nearby players (adjustable)
local COOLDOWN = 0.05 -- Ultra-fast cooldown for continuous flinging

local function fling()
	local lp = Players.LocalPlayer
	local lastFlingTime = 0

	-- Cache character and HRP
	local c, hrp
	lp.CharacterAdded:Connect(function(char)
		c = char
		hrp = char:WaitForChild("HumanoidRootPart", 2) -- Reduced wait time
	end)

	if lp.Character then
		c = lp.Character
		hrp = c:FindFirstChild("HumanoidRootPart")
	end

	-- Main fling loop using Heartbeat for maximum responsiveness
	while not stopFling do
		if c and hrp then
			local currentTime = tick()
			if currentTime - lastFlingTime >= COOLDOWN then
				local hum = c:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 then
					-- Get nearby players
					for _, player in ipairs(Players:GetPlayers()) do
						if player ~= lp and player.Character then
							local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
							local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
							if targetHrp and targetHum and targetHum.Health > 0 then
								local distance = (hrp.Position - targetHrp.Position).Magnitude
								if distance <= DETECTION_RANGE then
									-- Apply massive fling force instantly
									local flingDirection = (targetHrp.Position - hrp.Position).Unit * FLING_FORCE
									targetHrp.Velocity = flingDirection + Vector3.new(0, FLING_FORCE * 0.5, 0)
									-- Add BodyVelocity for extra power
									local bv = Instance.new("BodyVelocity")
									bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
									bv.Velocity = flingDirection + Vector3.new(0, FLING_FORCE * 0.3, 0)
									bv.Parent = targetHrp
									-- Clean up BodyVelocity after brief duration
									game:GetService("Debris"):AddItem(bv, 0.1)
								end
							end
						end
					end
				end
				lastFlingTime = currentTime
			end
			-- Apply slight movement to local player to maintain stability
			hrp.Velocity = hrp.Velocity + Vector3.new(0, 0.1 * (math.random() > 0.5 and 1 or -1), 0)
		end
		RunService.Heartbeat:Wait() -- Ultra-fast loop
	end
end

-- API
return {
	fling = function()
		stopFling = false
		return coroutine.create(fling)
	end,
	stop = function()
		stopFling = true
	end,
	enableGui = function() end,
	disableGui = function() end
}