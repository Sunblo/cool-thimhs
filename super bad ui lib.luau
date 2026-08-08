local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {
	Flags = {},
	Unloaded = false
}

local function GetGuiParent()
	local success, coreGui = pcall(function()
		return game:GetService("CoreGui")
	end)
	if success and coreGui then
		return coreGui
	end
	return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function MakeDraggable(dragHandle, mainFrame)
	local dragging, dragInput, dragStart, startPos
	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

function Library:CreateWindow(WindowConfig)
	WindowConfig = WindowConfig or {}
	local TitleText = WindowConfig.Name or "SCRIPT NAME"

	local parent = GetGuiParent()
	if parent:FindFirstChild("PixelUILibrary") then
		parent:FindFirstChild("PixelUILibrary"):Destroy()
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PixelUILibrary"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = parent

	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 520, 0, 560)
	mainFrame.Position = UDim2.new(0.5, -260, 0.5, -280)
	mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	local headerFrame = Instance.new("Frame")
	headerFrame.Name = "HeaderFrame"
	headerFrame.Size = UDim2.new(1, 0, 0, 45)
	headerFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	headerFrame.BorderSizePixel = 0
	headerFrame.Parent = mainFrame

	MakeDraggable(headerFrame, mainFrame)

	local tabButtonContainer = Instance.new("Frame")
	tabButtonContainer.Name = "TabButtonContainer"
	tabButtonContainer.Size = UDim2.new(0.65, 0, 1, 0)
	tabButtonContainer.BackgroundTransparency = 1
	tabButtonContainer.Parent = headerFrame

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.FillDirection = Enum.FillDirection.Horizontal
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Padding = UDim.new(0, 5)
	tabListLayout.Parent = tabButtonContainer

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingLeft = UDim.new(0, 10)
	tabPadding.PaddingTop = UDim.new(0, 8)
	tabPadding.Parent = tabButtonContainer

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(0.35, -15, 1, 0)
	titleLabel.Position = UDim2.new(0.65, 0, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = string.upper(TitleText)
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 18
	titleLabel.Font = Enum.Font.Arcade
	titleLabel.TextXAlignment = Enum.TextXAlignment.Right
	titleLabel.Parent = headerFrame

	local topSeparator = Instance.new("Frame")
	topSeparator.Name = "TopSeparator"
	topSeparator.Size = UDim2.new(1, -20, 0, 2)
	topSeparator.Position = UDim2.new(0, 10, 0, 45)
	topSeparator.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	topSeparator.BorderSizePixel = 0
	topSeparator.Parent = mainFrame

	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1, -20, 1, -57)
	contentContainer.Position = UDim2.new(0, 10, 0, 52)
	contentContainer.BackgroundTransparency = 1
	contentContainer.Parent = mainFrame

	local Window = {
		Tabs = {},
		ActiveTab = nil,
		ScreenGui = screenGui
	}

	function Window:CreateTab(TabName)
		local tab = {
			SubTabs = {},
			ActiveSubTab = nil
		}

		local tabBtn = Instance.new("TextButton")
		tabBtn.Name = TabName .. "_TabBtn"
		tabBtn.Size = UDim2.new(0, 110, 0, 30)
		tabBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = string.upper(TabName)
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabBtn.Font = Enum.Font.Arcade
		tabBtn.TextSize = 14
		tabBtn.Parent = tabButtonContainer

		local tabFrame = Instance.new("Frame")
		tabFrame.Name = TabName .. "_TabFrame"
		tabFrame.Size = UDim2.new(1, 0, 1, 0)
		tabFrame.BackgroundTransparency = 1
		tabFrame.Visible = false
		tabFrame.Parent = contentContainer

		local subTabButtonContainer = Instance.new("Frame")
		subTabButtonContainer.Name = "SubTabButtonContainer"
		subTabButtonContainer.Size = UDim2.new(1, 0, 0, 25)
		subTabButtonContainer.BackgroundTransparency = 1
		subTabButtonContainer.Parent = tabFrame

		local subTabListLayout = Instance.new("UIListLayout")
		subTabListLayout.FillDirection = Enum.FillDirection.Horizontal
		subTabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		subTabListLayout.Padding = UDim.new(0, 5)
		subTabListLayout.Parent = subTabButtonContainer

		local bodyFrame = Instance.new("Frame")
		bodyFrame.Name = "BodyFrame"
		bodyFrame.Size = UDim2.new(1, 0, 1, -30)
		bodyFrame.Position = UDim2.new(0, 0, 0, 30)
		bodyFrame.BackgroundTransparency = 1
		bodyFrame.Parent = tabFrame

		local function SwitchTab()
			for _, t in pairs(Window.Tabs) do
				t.Frame.Visible = false
				t.Button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
			end
			tabFrame.Visible = true
			tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Window.ActiveTab = tab
		end

		tabBtn.MouseButton1Click:Connect(SwitchTab)

		if #Window.Tabs == 0 then
			SwitchTab()
		end

		tab.Frame = tabFrame
		tab.Button = tabBtn

		function tab:CreateSubTab(SubTabName)
			local subTab = {}

			local subTabBtn = Instance.new("TextButton")
			subTabBtn.Name = SubTabName .. "_SubTabBtn"
			subTabBtn.Size = UDim2.new(0, 90, 0, 20)
			subTabBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
			subTabBtn.BorderSizePixel = 0
			subTabBtn.Text = string.upper(SubTabName)
			subTabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
			subTabBtn.Font = Enum.Font.Arcade
			subTabBtn.TextSize = 12
			subTabBtn.Parent = subTabButtonContainer

			local subTabFrame = Instance.new("Frame")
			subTabFrame.Name = SubTabName .. "_SubTabFrame"
			subTabFrame.Size = UDim2.new(1, 0, 1, 0)
			subTabFrame.BackgroundTransparency = 1
			subTabFrame.Visible = false
			subTabFrame.Parent = bodyFrame

			local verticalSeparator = Instance.new("Frame")
			verticalSeparator.Name = "VerticalSeparator"
			verticalSeparator.Size = UDim2.new(0, 2, 1, 0)
			verticalSeparator.Position = UDim2.new(0.5, -1, 0, 0)
			verticalSeparator.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
			verticalSeparator.BorderSizePixel = 0
			verticalSeparator.Parent = subTabFrame

			local leftBox = Instance.new("Frame")
			leftBox.Name = "LeftBox"
			leftBox.Size = UDim2.new(0.5, -6, 1, 0)
			leftBox.Position = UDim2.new(0, 0, 0, 0)
			leftBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
			leftBox.BorderSizePixel = 0
			leftBox.Parent = subTabFrame

			local leftScroll = Instance.new("ScrollingFrame")
			leftScroll.Name = "LeftScroll"
			leftScroll.Size = UDim2.new(1, -10, 1, -10)
			leftScroll.Position = UDim2.new(0, 5, 0, 5)
			leftScroll.BackgroundTransparency = 1
			leftScroll.BorderSizePixel = 0
			leftScroll.ScrollBarThickness = 2
			leftScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
			leftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			leftScroll.Parent = leftBox

			local leftLayout = Instance.new("UIListLayout")
			leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
			leftLayout.Padding = UDim.new(0, 8)
			leftLayout.Parent = leftScroll

			leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				leftScroll.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
			end)

			local rightBox = Instance.new("Frame")
			rightBox.Name = "RightBox"
			rightBox.Size = UDim2.new(0.5, -6, 1, 0)
			rightBox.Position = UDim2.new(0.5, 6, 0, 0)
			rightBox.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
			rightBox.BorderSizePixel = 0
			rightBox.Parent = subTabFrame

			local rightScroll = Instance.new("ScrollingFrame")
			rightScroll.Name = "RightScroll"
			rightScroll.Size = UDim2.new(1, -10, 1, -10)
			rightScroll.Position = UDim2.new(0, 5, 0, 5)
			rightScroll.BackgroundTransparency = 1
			rightScroll.BorderSizePixel = 0
			rightScroll.ScrollBarThickness = 2
			rightScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
			rightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
			rightScroll.Parent = rightBox

			local rightLayout = Instance.new("UIListLayout")
			rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
			rightLayout.Padding = UDim.new(0, 8)
			rightLayout.Parent = rightScroll

			rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				rightScroll.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 10)
			end)

			local function SwitchSubTab()
				for _, st in pairs(tab.SubTabs) do
					st.Frame.Visible = false
					st.Button.TextColor3 = Color3.fromRGB(140, 140, 140)
				end
				subTabFrame.Visible = true
				subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				tab.ActiveSubTab = subTab
			end

			subTabBtn.MouseButton1Click:Connect(SwitchSubTab)

			if #tab.SubTabs == 0 then
				SwitchSubTab()
			end

			subTab.Frame = subTabFrame
			subTab.Button = subTabBtn

			local function GetTargetContainer(side)
				if string.lower(tostring(side)) == "right" then
					return rightScroll
				end
				return leftScroll
			end

			function subTab:CreateButton(Config)
				Config = Config or {}
				local Name = Config.Name or "Button Name"
				local Callback = Config.Callback or function() end
				local Side = Config.Side or Config.Column or "Left"

				local container = GetTargetContainer(Side)

				local btnFrame = Instance.new("Frame")
				btnFrame.Name = Name .. "_Button"
				btnFrame.Size = UDim2.new(1, 0, 0, 36)
				btnFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				btnFrame.BorderSizePixel = 0
				btnFrame.Parent = container

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -40, 1, 0)
				label.Position = UDim2.new(0, 10, 0, 0)
				label.BackgroundTransparency = 1
				label.Text = string.upper(Name)
				label.TextColor3 = Color3.fromRGB(240, 240, 240)
				label.Font = Enum.Font.Arcade
				label.TextSize = 14
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = btnFrame

				local icon = Instance.new("TextLabel")
				icon.Size = UDim2.new(0, 24, 0, 24)
				icon.Position = UDim2.new(1, -30, 0.5, -12)
				icon.BackgroundTransparency = 1
				icon.Text = "►"
				icon.TextColor3 = Color3.fromRGB(240, 240, 240)
				icon.Font = Enum.Font.Arcade
				icon.TextSize = 14
				icon.Parent = btnFrame

				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, 0, 1, 0)
				button.BackgroundTransparency = 1
				button.Text = ""
				button.Parent = btnFrame

				button.MouseButton1Down:Connect(function()
					btnFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				end)

				button.MouseButton1Up:Connect(function()
					btnFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				end)

				button.MouseButton1Click:Connect(function()
					pcall(Callback)
				end)

				local Element = {}
				function Element:Set(NewName)
					label.Text = string.upper(NewName)
				end
				return Element
			end

			function subTab:CreateToggle(Config)
				Config = Config or {}
				local Name = Config.Name or "Toggle Name"
				local CurrentValue = Config.CurrentValue or Config.Default or false
				local Callback = Config.Callback or function() end
				local Flag = Config.Flag
				local Side = Config.Side or Config.Column or "Left"

				local container = GetTargetContainer(Side)

				if Flag then
					Library.Flags[Flag] = CurrentValue
				end

				local toggleFrame = Instance.new("Frame")
				toggleFrame.Name = Name .. "_Toggle"
				toggleFrame.Size = UDim2.new(1, 0, 0, 36)
				toggleFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				toggleFrame.BorderSizePixel = 0
				toggleFrame.Parent = container

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -60, 1, 0)
				label.Position = UDim2.new(0, 10, 0, 0)
				label.BackgroundTransparency = 1
				label.Text = string.upper(Name)
				label.TextColor3 = Color3.fromRGB(240, 240, 240)
				label.Font = Enum.Font.Arcade
				label.TextSize = 14
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = toggleFrame

				local toggleTrack = Instance.new("Frame")
				toggleTrack.Size = UDim2.new(0, 42, 0, 20)
				toggleTrack.Position = UDim2.new(1, -50, 0.5, -10)
				toggleTrack.BackgroundColor3 = CurrentValue and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(10, 10, 10)
				toggleTrack.BorderSizePixel = 0
				toggleTrack.Parent = toggleFrame

				local toggleKnob = Instance.new("Frame")
				toggleKnob.Size = UDim2.new(0, 12, 0, 12)
				toggleKnob.Position = CurrentValue and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
				toggleKnob.BackgroundColor3 = CurrentValue and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 80, 80)
				toggleKnob.BorderSizePixel = 0
				toggleKnob.Parent = toggleTrack

				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, 0, 1, 0)
				button.BackgroundTransparency = 1
				button.Text = ""
				button.Parent = toggleFrame

				local function UpdateToggle(Value)
					CurrentValue = Value
					if Flag then
						Library.Flags[Flag] = CurrentValue
					end
					local knobPos = CurrentValue and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
					local trackCol = CurrentValue and Color3.fromRGB(50, 50, 50) or Color3.fromRGB(10, 10, 10)
					local knobCol = CurrentValue and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(80, 80, 80)

					TweenService:Create(toggleKnob, TweenInfo.new(0.15), {Position = knobPos, BackgroundColor3 = knobCol}):Play()
					TweenService:Create(toggleTrack, TweenInfo.new(0.15), {BackgroundColor3 = trackCol}):Play()

					pcall(Callback, CurrentValue)
				end

				button.MouseButton1Click:Connect(function()
					UpdateToggle(not CurrentValue)
				end)

				local Element = {}
				function Element:Set(Value)
					UpdateToggle(Value)
				end
				return Element
			end

			function subTab:CreateDropdown(Config)
				Config = Config or {}
				local Name = Config.Name or "Dropdown Name"
				local Options = Config.Options or {}
				local CurrentOption = Config.CurrentOption or Config.Default or Options[1] or ""
				local Callback = Config.Callback or function() end
				local Flag = Config.Flag
				local Side = Config.Side or Config.Column or "Left"

				local container = GetTargetContainer(Side)

				if Flag then
					Library.Flags[Flag] = CurrentOption
				end

				local isOpen = false

				local dropdownMain = Instance.new("Frame")
				dropdownMain.Name = Name .. "_Dropdown"
				dropdownMain.Size = UDim2.new(1, 0, 0, 36)
				dropdownMain.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
				dropdownMain.BorderSizePixel = 0
				dropdownMain.ClipsDescendants = true
				dropdownMain.Parent = container

				local headerBtn = Instance.new("TextButton")
				headerBtn.Size = UDim2.new(1, 0, 0, 36)
				headerBtn.BackgroundTransparency = 1
				headerBtn.Text = ""
				headerBtn.Parent = dropdownMain

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -40, 0, 36)
				label.Position = UDim2.new(0, 10, 0, 0)
				label.BackgroundTransparency = 1
				label.Text = string.upper(Name)
				label.TextColor3 = Color3.fromRGB(240, 240, 240)
				label.Font = Enum.Font.Arcade
				label.TextSize = 14
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = headerBtn

				local arrow = Instance.new("TextLabel")
				arrow.Size = UDim2.new(0, 24, 0, 36)
				arrow.Position = UDim2.new(1, -30, 0, 0)
				arrow.BackgroundTransparency = 1
				arrow.Text = "▼"
				arrow.TextColor3 = Color3.fromRGB(240, 240, 240)
				arrow.Font = Enum.Font.Arcade
				arrow.TextSize = 12
				arrow.Parent = headerBtn

				local optionHolder = Instance.new("Frame")
				optionHolder.Size = UDim2.new(1, 0, 0, #Options * 28)
				optionHolder.Position = UDim2.new(0, 0, 0, 36)
				optionHolder.BackgroundTransparency = 1
				optionHolder.Parent = dropdownMain

				local optionLayout = Instance.new("UIListLayout")
				optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
				optionLayout.Padding = UDim.new(0, 2)
				optionLayout.Parent = optionHolder

				local function ToggleDropdown()
					isOpen = not isOpen
					local targetHeight = isOpen and (36 + (#Options * 28)) or 36
					arrow.Text = isOpen and "▲" or "▼"
					TweenService:Create(dropdownMain, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
				end

				headerBtn.MouseButton1Click:Connect(ToggleDropdown)

				local function RefreshButtons()
					for _, child in ipairs(optionHolder:GetChildren()) do
						if child:IsA("TextButton") then
							child:Destroy()
						end
					end

					for _, opt in ipairs(Options) do
						local optBtn = Instance.new("TextButton")
						optBtn.Size = UDim2.new(1, 0, 0, 26)
						optBtn.BackgroundColor3 = (opt == CurrentOption) and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(12, 12, 12)
						optBtn.BorderSizePixel = 0
						optBtn.Text = "  " .. string.upper(opt)
						optBtn.TextColor3 = (opt == CurrentOption) and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
						optBtn.Font = Enum.Font.Arcade
						optBtn.TextSize = 12
						optBtn.TextXAlignment = Enum.TextXAlignment.Left
						optBtn.Parent = optionHolder

						optBtn.MouseButton1Click:Connect(function()
							CurrentOption = opt
							if Flag then
								Library.Flags[Flag] = CurrentOption
							end

							for _, child in ipairs(optionHolder:GetChildren()) do
								if child:IsA("TextButton") then
									child.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
									child.TextColor3 = Color3.fromRGB(160, 160, 160)
								end
							end
							optBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
							optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)

							ToggleDropdown()
							pcall(Callback, CurrentOption)
						end)
					end
					optionHolder.Size = UDim2.new(1, 0, 0, #Options * 28)
				end

				RefreshButtons()

				local Element = {}
				function Element:Set(NewOption)
					CurrentOption = NewOption
					if Flag then
						Library.Flags[Flag] = CurrentOption
					end
					RefreshButtons()
					pcall(Callback, CurrentOption)
				end
				function Element:Refresh(NewOptions)
					Options = NewOptions
					RefreshButtons()
				end
				return Element
			end

			table.insert(tab.SubTabs, subTab)
			return subTab
		end

		table.insert(Window.Tabs, tab)
		return tab
	end

	return Window
end

local Window = Library:CreateWindow({
	Name = "SCRIPT NAME"
})

local MainTab = Window:CreateTab("TAB NAME")
local SubTab = MainTab:CreateSubTab("SUBTAB NAME")

SubTab:CreateToggle({
	Name = "TOGGLE NAME",
	CurrentValue = false,
	Side = "Left",
	Flag = "Toggle1Flag",
	Callback = function(Value)
		print("Toggle 1 set to:", Value)
	end,
})

SubTab:CreateToggle({
	Name = "TOGGLE NAME",
	CurrentValue = true,
	Side = "Left",
	Flag = "Toggle2Flag",
	Callback = function(Value)
		print("Toggle 2 set to:", Value)
	end,
})

SubTab:CreateButton({
	Name = "BUTTON NAME",
	Side = "Left",
	Callback = function()
		print("Left Button clicked!")
	end,
})

SubTab:CreateDropdown({
	Name = "DROPDOWN NAME",
	Options = {"OPTION", "OPTION", "OPTION", "OPTION", "OPTION"},
	CurrentOption = "OPTION",
	Side = "Left",
	Flag = "Dropdown1Flag",
	Callback = function(Option)
		print("Left Dropdown selected:", Option)
	end,
})

SubTab:CreateToggle({
	Name = "TOGGLE NAME",
	CurrentValue = false,
	Side = "Right",
	Flag = "Toggle3Flag",
	Callback = function(Value)
		print("Right Toggle 1 set to:", Value)
	end,
})

SubTab:CreateToggle({
	Name = "TOGGLE NAME",
	CurrentValue = true,
	Side = "Right",
	Flag = "Toggle4Flag",
	Callback = function(Value)
		print("Right Toggle 2 set to:", Value)
	end,
})

SubTab:CreateButton({
	Name = "BUTTON NAME",
	Side = "Right",
	Callback = function()
		print("Right Button clicked!")
	end,
})

SubTab:CreateDropdown({
	Name = "DROPDOWN NAME",
	Options = {"OPTION", "OPTION", "OPTION", "OPTION", "OPTION"},
	CurrentOption = "OPTION",
	Side = "Right",
	Flag = "Dropdown2Flag",
	Callback = function(Option)
		print("Right Dropdown selected:", Option)
	end,
})
