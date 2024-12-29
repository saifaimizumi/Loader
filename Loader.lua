local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local gameId = 16732694052

if game.PlaceId == gameId then

	local Window = Fluent:CreateWindow({
		Title = "Fisch",
		SubTitle = "sigma boy",
		TabWidth = 160,
		Size = UDim2.fromOffset(580, 460),
		Acrylic = true,
		Theme = "Dark",
		MinimizeKey = Enum.KeyCode.LeftControl
	})

	local Tabs = {
		Main = Window:AddTab({ Title = "Main", Icon = "menu" }),
        Teleport = Window:AddTab({ Title = "Teleport", Icon = "gauge" }),
        Shop = Window:AddTab({Title = "Shop", Icon = "shopping-cart"}),
		Misc = Window:AddTab({ Title = "Misc", Icon = "folder" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
	}

	local Options = Fluent.Options

    local Player = game:GetService("Players")
    local LocalPlayer = Player.LocalPlayer
    local Char = LocalPlayer.Character
    local Humanoid = Char.Humanoid
    local VirtualInputManager = game:GetService("VirtualInputManager")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local GuiService = game:GetService("GuiService")
    local currentRod = nil
    local rodEquipped = false
    local teleportLocation = nil


	do
		
        _G.AutoCast = false
        task.spawn(function()
            while wait() do
                if _G.AutoCast and rodEquipped and LocalPlayer.Character:FindFirstChildOfClass('Tool') and LocalPlayer.Character:FindFirstChildOfClass('Tool'):FindFirstChild("values") and LocalPlayer.Character:FindFirstChildOfClass('Tool').values.casted and LocalPlayer.Character:FindFirstChildOfClass('Tool').values.casted.Value == false then
                    local args = {
                        [1] = 100
                    }
                    
                    LocalPlayer.Character:FindFirstChildOfClass('Tool').events.cast:FireServer(unpack(args))
                    wait(2)
                end
            end
        end)


        _G.AutoShake = false
        task.spawn(function()
            while true do
                task.wait(.01)
                if _G.AutoShake then
                    pcall(function()
                        if LocalPlayer.Character:FindFirstChildOfClass('Tool') and LocalPlayer.Character:FindFirstChildOfClass('Tool'):FindFirstChild("values") and LocalPlayer.Character:FindFirstChildOfClass('Tool').values.casted and LocalPlayer.Character:FindFirstChildOfClass('Tool').values.casted.Value == true then
                            GuiService.SelectedObject = LocalPlayer.PlayerGui.shakeui.safezone.button
                            if GuiService.SelectedObject == LocalPlayer.PlayerGui.shakeui.safezone.button then
                                VirtualInputManager:SendKeyEvent(true, 13, false, LocalPlayer.Character.HumanoidRootPart)
                                VirtualInputManager:SendKeyEvent(false, 13, false, LocalPlayer.Character.HumanoidRootPart)
                            end
                        end
                    end)
                end
            end
        end)
        -- AutoReel
        _G.AutoReel = false
        task.spawn(function()
            while true do
                task.wait()
                if _G.AutoReel then
                    pcall(function()
                        for i,v in pairs(LocalPlayer.PlayerGui:GetChildren()) do
                            if v:IsA "ScreenGui" and v.Name == "reel"then
                                if v:FindFirstChild "bar" then
                                    task.wait(.15)
                                        ReplicatedStorage.events.reelfinished:FireServer(100,true)
                                end
                            end
                        end
                    end)
                end
            end
        end)

        

        task.spawn(function()
            while true do
                task.wait(1)
                currentRod = Char:FindFirstChildOfClass("Tool")
                if currentRod and currentRod.Name:lower():find("rod") then
                    rodEquipped = true
                else
                    rodEquipped = false
                end
            end
        end)

		local AutoCastToggle = Tabs.Main:AddToggle("AutoCast", {Title = "Auto Cast", Default = false})
		AutoCastToggle:OnChanged(function()
			_G.AutoCast = Options.AutoCast.Value
		end)
		
		Tabs.Main:AddButton({
			Title = "Perfect Cast",
			Description = "Cast your rod",
			Callback = function()
                if currentRod then
					local args = {
                        [1] = 100,
                        [2] = 1
                    }
					currentRod.events.cast:FireServer(unpack(args))
				end
			end
		})

		local AutoReelToggle = Tabs.Main:AddToggle("AutoReel", {Title = "Auto Reel", Default = false})
		AutoReelToggle:OnChanged(function()
			_G.AutoReel = Options.AutoReel.Value
		end)
        
        local AutoShakeToggle = Tabs.Main:AddToggle("AutoShake", {Title = "Auto Shake", Default = false})
        AutoShakeToggle:OnChanged(function()
            _G.AutoShake = Options.AutoShake.Value
        end)
		



        local clientFolder = workspace:WaitForChild("X7N6Y"):WaitForChild("client")
        if clientFolder then
            local disableOxygenToggle = Tabs.Misc:AddToggle("disableOxygen", {Title = "disable oxygen", Default = false})
            disableOxygenToggle:OnChanged(function()
                local oxygenScript = clientFolder:FindFirstChild("oxygen")
                if oxygenScript and oxygenScript:IsA("LocalScript") then
                    oxygenScript.Disabled = Options.disableOxygen.Value
                     if  Options.disableOxygen.Value and oxygenScript:FindFirstChild("Value") then
                         oxygenScript.Value.Value = false
                    end
                end
            end)
            local disableOxygenPeaksToggle = Tabs.Misc:AddToggle("disableOxygen(peaks)", {Title = "disable oxygen(peaks)", Default = false})
           disableOxygenPeaksToggle:OnChanged(function()
                 local oxygenPeaksScript = clientFolder:FindFirstChild("oxygen(peaks)")
                if oxygenPeaksScript and oxygenPeaksScript:IsA("LocalScript") then
                     oxygenPeaksScript.Disabled = Options["disableOxygen(peaks)"].Value
                     if Options["disableOxygen(peaks)"].Value and oxygenPeaksScript:FindFirstChild("Value")  then
                         oxygenPeaksScript.Value.Value = false
                     end
                end
            end)
            local disableTemperatureToggle = Tabs.Misc:AddToggle("disableTemperature", {Title = "disable temperature", Default = false})
            disableTemperatureToggle:OnChanged(function()
                local temperatureScript = clientFolder:FindFirstChild("temperature")
                if temperatureScript and temperatureScript:IsA("LocalScript") then
                    temperatureScript.Disabled = Options.disableTemperature.Value
                    if Options.disableTemperature.Value and temperatureScript:FindFirstChild("Value") then
                        temperatureScript.Value.Value = false
                   end
                end
            end)
        end
		
	end

	SaveManager:SetLibrary(Fluent)
	InterfaceManager:SetLibrary(Fluent)

	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes({})
	InterfaceManager:SetFolder("FluentScriptHub")
	SaveManager:SetFolder("FluentScriptHub/specific-game")

	InterfaceManager:BuildInterfaceSection(Tabs.Settings)
	SaveManager:BuildConfigSection(Tabs.Settings)
    
	Window:SelectTab(1)

	Fluent:Notify({
		Title = "Fluent",
		Content = "The script has been loaded.",
		Duration = 8
	})
    local CoreGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui")
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "CustomScreenGui"
    ScreenGui.Parent = CoreGui
    local CloseOpen = Instance.new("TextButton")
    CloseOpen.Name = "CloseOpenButton"
    CloseOpen.Text = ""
    CloseOpen.Parent = ScreenGui
    CloseOpen.Size = UDim2.new(0, 30, 0, 30)
    CloseOpen.Position = UDim2.new(0.95, -30, 0.5, -15)
	CloseOpen.AnchorPoint = Vector2.new(1,0.5)
    CloseOpen.BackgroundColor3 = Color3.fromRGB(255, 164, 164)
    CloseOpen.BackgroundTransparency = 0
    CloseOpen.BorderSizePixel = 0
    CloseOpen.Text = ""
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = CloseOpen
    local function CloseOpenFunc()
        for i,v in pairs(game:GetService("CoreGui"):FindFirstChild("ScreenGui"):GetChildren()) do
            if v.Name == "Frame" and v:FindFirstChild("TextLabel") then
                if v.Visible then
                    v.Visible = false
                    game:GetService("CoreGui"):FindFirstChild("ScreenGui").Enabled = false
                else
                    v.Visible = true
                    game:GetService("CoreGui"):FindFirstChild("ScreenGui").Enabled = true
                end
            end
        end
    end
    CloseOpen.Activated:Connect(CloseOpenFunc)
	
	local tpButton = Fluent.New("TextButton")
	tpButton.Size = UDim2.new(0, 100, 0, 30)
	tpButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	tpButton.TextColor3 = Color3.new(1,1,1)
	tpButton.Text = "Teleport"
	tpButton.Font = Enum.Font.SourceSans
	tpButton.Parent = game.Players.LocalPlayer.PlayerGui
	tpButton.MouseButton1Click:Connect(function()
		if teleportLocation and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
			    humanoidRootPart.CFrame = teleportLocation
            end
        end
	end)

    local teleportDropdown = Tabs.Teleport:AddDropdown("teleportDropdown", {Title = "Choose a Spot", Values = {"None","ancientarchives","forsaken","altar","ancient","ancientarchivesentrance"}})
    teleportDropdown:OnChanged(function()
        if Options.teleportDropdown.Value == "None" then
             teleportLocation = nil
        elseif Options.teleportDropdown.Value == "ancientarchives" then
            teleportLocation = CFrame.new(-3155.02222, -750.667847, 2193.13696, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        elseif Options.teleportDropdown.Value == "forsaken" then
            teleportLocation = CFrame.new(-2498.24585, 133.71489, 1624.8551, 1, 0, 0, 0, 1, 0, 0, 0, 1)
        elseif Options.teleportDropdown.Value == "altar" then
            teleportLocation = CFrame.new(1296.32007, -808.551941, -298.918171, 0.0735510588, -0, -0.997291446, 0, 1, -0, 0.997291446, 0, 0.0735510588)
		elseif Options.teleportDropdown.Value == "ancient" then
			teleportLocation = CFrame.new(6056.05322, 192.225922, 278.566803, 0.573598742, 0.000578988635, 0.819136202, -0.000339840539, 0.999999821, -0.000468855433, -0.819136322, -9.44083149e-06, 0.573598862)
		elseif Options.teleportDropdown.Value == "ancientarchivesentrance" then
			teleportLocation = CFrame.new(5948.79053, 157.230042, 482.23584, 0.764405072, 0, 0.644736409, 0, 1, 0, -0.644736409, 0, 0.764405072)
        end
    end)
     Tabs.Teleport:AddParagraph({
        Title = "Click here to teleport",
        Content = ""
    })
    local clientFolder = workspace:WaitForChild("X7N6Y"):WaitForChild("client")
        if clientFolder then
            local disableOxygenToggle = Tabs.Misc:AddToggle("disableOxygen", {Title = "disable oxygen", Default = false})
            disableOxygenToggle:OnChanged(function()
                local oxygenScript = clientFolder:FindFirstChild("oxygen")
                if oxygenScript and oxygenScript:IsA("LocalScript") then
                    oxygenScript.Disabled = Options.disableOxygen.Value
                     if  Options.disableOxygen.Value and oxygenScript:FindFirstChild("Value") then
                         oxygenScript.Value.Value = false
                    end
                end
            end)
            local disableOxygenPeaksToggle = Tabs.Misc:AddToggle("disableOxygen(peaks)", {Title = "disable oxygen(peaks)", Default = false})
           disableOxygenPeaksToggle:OnChanged(function()
                 local oxygenPeaksScript = clientFolder:FindFirstChild("oxygen(peaks)")
                if oxygenPeaksScript and oxygenPeaksScript:IsA("LocalScript") then
                     oxygenPeaksScript.Disabled = Options["disableOxygen(peaks)"].Value
                     if Options["disableOxygen(peaks)"].Value and oxygenPeaksScript:FindFirstChild("Value")  then
                         oxygenPeaksScript.Value.Value = false
                     end
                end
            end)
            local disableTemperatureToggle = Tabs.Misc:AddToggle("disableTemperature", {Title = "disable temperature", Default = false})
            disableTemperatureToggle:OnChanged(function()
                local temperatureScript = clientFolder:FindFirstChild("temperature")
                if temperatureScript and temperatureScript:IsA("LocalScript") then
                    temperatureScript.Disabled = Options.disableTemperature.Value
                    if Options.disableTemperature.Value and temperatureScript:FindFirstChild("Value") then
                        temperatureScript.Value.Value = false
                   end
                end
            end)
        end

	SaveManager:LoadAutoloadConfig()
else
	game.Players.LocalPlayer:Kick("Game not supported")
end
