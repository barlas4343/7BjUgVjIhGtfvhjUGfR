local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
	local detection = Instance.new("Decal")
	detection.Name = "juisdfj0i32i0eidsuf0iok"
	detection.Parent = ReplicatedStorage
end

local function fling()
	local lp = Players.LocalPlayer
	local active = true
	local hrp

	local function getHRP()
		local c = lp.Character
		if c then
			return c:FindFirstChild("HumanoidRootPart")
		end
	end

	lp.CharacterAdded:Connect(function(char)
		hrp = char:WaitForChild("HumanoidRootPart")
	end)

	hrp = getHRP()

	-- ultra güçlü fling loop
	while active do
		RunService.Heartbeat:Wait()
		hrp = getHRP()
		if not hrp then continue end

		local cf = hrp.CFrame
		local vel = hrp.Velocity

		-- yakınındaki herkesi aşırı güçlü şekilde uçur
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local targetHRP = plr.Character.HumanoidRootPart
				local distance = (targetHRP.Position - hrp.Position).Magnitude
				if distance < 10 then -- 10 stud çevresinde uçur
					targetHRP.Velocity = Vector3.new(
						math.random(-1e6, 1e6),
						math.random(5e6, 7e6),
						math.random(-1e6, 1e6)
					)
				end
			end
		end

		-- kendi hareketine güç ver (stabil tut)
		hrp.AssemblyLinearVelocity = Vector3.new(
			math.random(-50000, 50000),
			math.random(100000, 150000),
			math.random(-50000, 50000)
		)
	end
end

return {
	fling = coroutine.wrap(fling)
}
