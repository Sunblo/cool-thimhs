local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {
	Flags = {},
	Unloaded = false,
	Theme = {
		Background = Color3.fromRGB(14, 14, 18),
		Sidebar = Color3.fromRGB(18, 18, 24),
		Card = Color3.fromRGB(22, 22, 30),
		CardHover = Color3.fromRGB(28, 28, 38),
		Accent = Color3.fromRGB(99, 102, 241),
		AccentGlow = Color3.fromRGB(129, 140, 248),
		TextPrimary = Color3.fromRGB(240, 240, 245),
		TextSecondary = Color3.fromRGB(140, 140, 160),
		Border = Color3.fromRGB(35, 35, 48),
		ToggleOff = Color3.fromRGB(32, 32, 42)
	}
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
	local TitleText = WindowConfig.Name or "UI LIBRARY"
	local SubtitleText = WindowConfig.Subtitle or "v2.0 Premium Edition"

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
	mainFrame.Size = UDim2.new(0, 680, 0, 460)
	mainFrame.Position = UDim2.new(0.5, -340, 0.5, -230)
	mainFrame.BackgroundColor3 = Library.Theme.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 10)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Library.Theme.Border
	mainStroke.Thickness = 1
	mainStroke.Parent = mainFrame

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 180, 1, 0)
	sidebar.BackgroundColor3 = Library.Theme.Sidebar
	sidebar.BorderSizePixel = 0
	sidebar.Parent = mainFrame

	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.CornerRadius = UDim.new(0, 10)
	sidebarCorner.Parent = sidebar

	local sidebarFix = Instance.new("Frame")
	sidebarFix.Name = "SidebarFix"
	sidebarFix.Size = UDim2.new(0, 10, 1, 0)
	sidebarFix.Position = UDim2.new(1, -10, 0, 0)
	sidebarFix.BackgroundColor3 = Library.Theme.Sidebar
	sidebarFix.BorderSizePixel = 0
	sidebarFix.Parent = sidebar

	local headerArea = Instance.new("Frame")
	headerArea.Name = "HeaderArea"
	headerArea.Size = UDim2.new(1, 0, 0, 60)
	headerArea.BackgroundTransparency = 1
	headerArea.Parent = sidebar

	MakeDraggable(headerArea, mainFrame)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "TitleLabel"
	titleLabel.Size = UDim2.new(1, -20, 0, 22)
	titleLabel.Position = UDim2.new(0, 15, 0, 14)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = TitleText
	titleLabel.TextColor3 = Library.Theme.TextPrimary
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = headerArea

	local subtitleLabel = Instance.new("TextLabel")
	subtitleLabel.Name = "SubtitleLabel"
	subtitleLabel.Size = UDim2.new(1, -20, 0, 14)
	subtitleLabel.Position = UDim2.new(0, 15, 0, 36)
	subtitleLabel.BackgroundTransparency = 1
	subtitleLabel.Text = SubtitleText
	subtitleLabel.TextColor3 = Library.Theme.TextSecondary
	subtitleLabel.TextSize = 11
	subtitleLabel.Font = Enum.Font.Gotham
	subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	subtitleLabel.Parent = headerArea

	local sidebarSeparator = Instance.new("Frame")
	sidebarSeparator.Name = "SidebarSeparator"
	sidebarSeparator.Size = UDim2.new(1, -30, 0, 1)
	sidebarSeparator.Position = UDim2.new(0, 15, 0, 58)
	sidebarSeparator.BackgroundColor3 = Library.Theme.Border
	sidebarSeparator.BorderSizePixel = 0
	sidebarSeparator.Parent = sidebar

	local tabButtonContainer = Instance.new("ScrollingFrame")
	tabButtonContainer.Name = "TabButtonContainer"
	tabButtonContainer.Size = UDim2.new(1, 0, 1, -70)
	tabButtonContainer.Position = UDim2.new(0, 0, 0, 65)
	tabButtonContainer.BackgroundTransparency = 1
	tabButtonContainer.BorderSizePixel = 0
	tabButtonContainer.ScrollBarThickness = 0
	tabButtonContainer.Parent = sidebar

	local tabListLayout = Instance.new("UIListLayout")
	tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabListLayout.Padding = UDim.new(0, 6)
	tabListLayout.Parent = tabButtonContainer

	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingLeft = UDim.new(0, 12)
	tabPadding.PaddingRight = UDim.new(0, 12)
	tabPadding.PaddingTop = UDim.new(0, 4)
	tabPadding.Parent = tabButtonContainer

	local contentContainer = Instance.new("Frame")
	contentContainer.Name = "ContentContainer"
	contentContainer.Size = UDim2.new(1, -190, 1, -20)
	contentContainer.Position = UDim2.new(0, 185, 0, 10)
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
		tabBtn.Size = UDim2.new(1, 0, 0, 36)
		tabBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		tabBtn.BackgroundTransparency = 1
		tabBtn.BorderSizePixel = 0
		tabBtn.Text = "  " .. TabName
		tabBtn.TextColor3 = Library.Theme.TextSecondary
		tabBtn.Font = Enum.Font.GothamMedium
		tabBtn.TextSize = 13
		tabBtn.TextXAlignment = Enum.TextXAlignment.Left
		tabBtn.Parent = tabButtonContainer

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = tabBtn

		local indicator = Instance.new("Frame")
		indicator.Name = "Indicator"
		indicator.Size = UDim2.new(0, 3, 0, 18)
		indicator.Position = UDim2.new(0, 0, 0.5, -9)
		indicator.BackgroundColor3 = Library.Theme.Accent
		indicator.BorderSizePixel = 0
		indicator.Visible = false
		indicator.Parent = tabBtn

		local indicatorCorner = Instance.new("UICorner")
		indicatorCorner.CornerRadius = UDim.new(0, 2)
		indicatorCorner.Parent = indicator

		local tabFrame = Instance.new("Frame")
		tabFrame.Name = TabName .. "_TabFrame"
		tabFrame.Size = UDim2.new(1, 0, 1, 0)
		tabFrame.BackgroundTransparency = 1
		tabFrame.Visible = false
		tabFrame.Parent = contentContainer

		local subTabHeader = Instance.new("Frame")
		subTabHeader.Name = "SubTabHeader"
		subTabHeader.Size = UDim2.new(1, 0, 0, 32)
		subTabHeader.BackgroundTransparency = 1
		subTabHeader.Parent = tabFrame

		local subTabListLayout = Instance.new("UIListLayout")
		subTabListLayout.FillDirection = Enum.FillDirection.Horizontal
		subTabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		subTabListLayout.Padding = UDim.new(0, 8)
		subTabListLayout.Parent = subTabHeader

		local bodyFrame = Instance.new("Frame")
		bodyFrame.Name = "BodyFrame"
		bodyFrame.Size = UDim2.new(1, 0, 1, -38)
		bodyFrame.Position = UDim2.new(0, 0, 0, 38)
		bodyFrame.BackgroundTransparency = 1
		bodyFrame.Parent = tabFrame

		local function SwitchTab()
			for _, t in pairs(Window.Tabs) do
				t.Frame.Visible = false
				t.Button.BackgroundTransparency = 1
				t.Button.TextColor3 = Library.Theme.TextSecondary
				t.Indicator.Visible = false
			end
			tabFrame.Visible = true
			tabBtn.BackgroundTransparency = 0.8
			tabBtn.BackgroundColor3 = Library.Theme.Accent
			tabBtn.TextColor3 = Library.Theme.TextPrimary
			indicator.Visible = true
			Window.ActiveTab = tab
		end

		tabBtn.MouseButton1Click:Connect(SwitchTab)

		if #Window.Tabs == 0 then
			SwitchTab()
		end

		tab.Frame = tabFrame
		tab.Button = tabBtn
		tab.Indicator = indicator

		function tab:CreateSubTab(SubTabName)
			local subTab = {}

			local subTabBtn = Instance.new("TextButton")
			subTabBtn.Name = SubTabName .. "_SubTabBtn"
			subTabBtn.Size = UDim2.new(0, 100, 1, 0)
			subTabBtn.BackgroundColor3 = Library.Theme.Card
			subTabBtn.BorderSizePixel = 0
			subTabBtn.Text = SubTabName
			subTabBtn.TextColor3 = Library.Theme.TextSecondary
			subTabBtn.Font = Enum.Font.GothamMedium
			subTabBtn.TextSize = 12
			subTabBtn.Parent = subTabHeader

			local subTabCorner = Instance.new("UICorner")
			subTabCorner.CornerRadius = UDim.new(0, 6)
			subTabCorner.Parent = subTabBtn

			local subTabStroke = Instance.new("UIStroke")
			subTabStroke.Color = Library.Theme.Border
			subTabStroke.Thickness = 1
			subTabStroke.Parent = subTabBtn

			local subTabFrame = Instance.new("Frame")
			subTabFrame.Name = SubTabName .. "_SubTabFrame"
			subTabFrame.Size = UDim2.new(1, 0, 1, 0)
			subTabFrame.BackgroundTransparency = 1
			subTabFrame.Visible = false
			subTabFrame.Parent = bodyFrame

			local leftBox = Instance.new("Frame")
			leftBox.Name = "LeftBox"
			leftBox.Size = UDim2.new(0.5, -6, 1, 0)
			leftBox.Position = UDim2.new(0, 0, 0, 0)
			leftBox.BackgroundTransparency = 1
			leftBox.Parent = subTabFrame

			local leftScroll = Instance.new("ScrollingFrame")
			leftScroll.Name = "LeftScroll"
			leftScroll.Size = UDim2.new(1, 0, 1, 0)
			leftScroll.BackgroundTransparency = 1
			leftScroll.BorderSizePixel = 0
			leftScroll.ScrollBarThickness = 2
			leftScroll.ScrollBarImageColor3 = Library.Theme.Border
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
			rightBox.BackgroundTransparency = 1
			rightBox.Parent = subTabFrame

			local rightScroll = Instance.new("ScrollingFrame")
			rightScroll.Name = "RightScroll"
			rightScroll.Size = UDim2.new(1, 0, 1, 0)
			rightScroll.BackgroundTransparency = 1
			rightScroll.BorderSizePixel = 0
			rightScroll.ScrollBarThickness = 2
			rightScroll.ScrollBarImageColor3 = Library.Theme.Border
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
					st.Button.TextColor3 = Library.Theme.TextSecondary
					st.Button.BackgroundColor3 = Library.Theme.Card
					st.Stroke.Color = Library.Theme.Border
				end
				subTabFrame.Visible = true
				subTabBtn.TextColor3 = Library.Theme.TextPrimary
				subTabBtn.BackgroundColor3 = Library.Theme.CardHover
				subTabStroke.Color = Library.Theme.Accent
				tab.ActiveSubTab = subTab
			end

			subTabBtn.MouseButton1Click:Connect(SwitchSubTab)

			if #tab.SubTabs == 0 then
				SwitchSubTab()
			end

			subTab.Frame = subTabFrame
			subTab.Button = subTabBtn
			subTab.Stroke = subTabStroke

			local function GetTargetContainer(side)
				if string.lower(tostring(side)) == "right" then
					return rightScroll
				end
				return leftScroll
			end

			function subTab:CreateButton(Config)
				Config = Config or {}
				local Name = Config.Name or "Button"
				local Callback = Config.Callback or function() end
				local Side = Config.Side or Config.Column or "Left"

				local container = GetTargetContainer(Side)

				local btnFrame = Instance.new("Frame")
				btnFrame.Name = Name .. "_Button"
				btnFrame.Size = UDim2.new(1, -6, 0, 40)
				btnFrame.BackgroundColor3 = Library.Theme.Card
				btnFrame.BorderSizePixel = 0
				btnFrame.Parent = container

				local cardCorner = Instance.new("UICorner")
				cardCorner.CornerRadius = UDim.new(0, 8)
				cardCorner.Parent = btnFrame

				local cardStroke = Instance.new("UIStroke")
				cardStroke.Color = Library.Theme.Border
				cardStroke.Thickness = 1
				cardStroke.Parent = btnFrame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -40, 1, 0)
				label.Position = UDim2.new(0, 12, 0, 0)
				label.BackgroundTransparency = 1
				label.Text = Name
				label.TextColor3 = Library.Theme.TextPrimary
				label.Font = Enum.Font.GothamMedium
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = btnFrame

				local icon = Instance.new("TextLabel")
				icon.Size = UDim2.new(0, 24, 0, 24)
				icon.Position = UDim2.new(1, -30, 0.5, -12)
				icon.BackgroundTransparency = 1
				icon.Text = "➜"
				icon.TextColor3 = Library.Theme.Accent
				icon.Font = Enum.Font.GothamBold
				icon.TextSize = 14
				icon.Parent = btnFrame

				local button = Instance.new("TextButton")
				button.Size = UDim2.new(1, 0, 1, 0)
				button.BackgroundTransparency = 1
				button.Text = ""
				button.Parent = btnFrame

				button.MouseEnter:Connect(function()
					TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.CardHover}):Play()
					TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = Library.Theme.Accent}):Play()
				end)

				button.MouseLeave:Connect(function()
					TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Card}):Play()
					TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = Library.Theme.Border}):Play()
				end)

				button.MouseButton1Click:Connect(function()
					pcall(Callback)
				end)

				local Element = {}
				function Element:Set(NewName)
					label.Text = NewName
				end
				return Element
			end

			function subTab:CreateToggle(Config)
				Config = Config or {}
				local Name = Config.Name or "Toggle"
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
				toggleFrame.Size = UDim2.new(1, -6, 0, 40)
				toggleFrame.BackgroundColor3 = Library.Theme.Card
				toggleFrame.BorderSizePixel = 0
				toggleFrame.Parent = container

				local cardCorner = Instance.new("UICorner")
				cardCorner.CornerRadius = UDim.new(0, 8)
				cardCorner.Parent = toggleFrame

				local cardStroke = Instance.new("UIStroke")
				cardStroke.Color = Library.Theme.Border
				cardStroke.Thickness = 1
				cardStroke.Parent = toggleFrame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -60, 1, 0)
				label.Position = UDim2.new(0, 12, 0, 0)
				label.BackgroundTransparency = 1
				label.Text = Name
				label.TextColor3 = Library.Theme.TextPrimary
				label.Font = Enum.Font.GothamMedium
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = toggleFrame

				local toggleTrack = Instance.new("Frame")
				toggleTrack.Size = UDim2.new(0, 38, 0, 20)
				toggleTrack.Position = UDim2.new(1, -48, 0.5, -10)
				toggleTrack.BackgroundColor3 = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff
				toggleTrack.BorderSizePixel = 0
				toggleTrack.Parent = toggleFrame

				local trackCorner = Instance.new("UICorner")
				trackCorner.CornerRadius = UDim.new(1, 0)
				trackCorner.Parent = toggleTrack

				local toggleKnob = Instance.new("Frame")
				toggleKnob.Size = UDim2.new(0, 14, 0, 14)
				toggleKnob.Position = CurrentValue and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
				toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				toggleKnob.BorderSizePixel = 0
				toggleKnob.Parent = toggleTrack

				local knobCorner = Instance.new("UICorner")
				knobCorner.CornerRadius = UDim.new(1, 0)
				knobCorner.Parent = toggleKnob

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
					local knobPos = CurrentValue and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
					local trackCol = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff

					TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = knobPos}):Play()
					TweenService:Create(toggleTrack, TweenInfo.new(0.2), {BackgroundColor3 = trackCol}):Play()

					pcall(Callback, CurrentValue)
				end

				button.MouseButton1Click:Connect(function()
					UpdateToggle(not CurrentValue)
				end)

				toggleFrame.MouseEnter:Connect(function()
					TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.CardHover}):Play()
				end)
				toggleFrame.MouseLeave:Connect(function()
					TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Card}):Play()
				end)

				local Element = {}
				function Element:Set(Value)
					UpdateToggle(Value)
				end
				return Element
			end

			function subTab:CreateSlider(Config)
				Config = Config or {}
				local Name = Config.Name or "Slider"
				local Min = Config.Min or 0
				local Max = Config.Max or 100
				local CurrentValue = Config.CurrentValue or Config.Default or Min
				local Callback = Config.Callback or function() end
				local Flag = Config.Flag
				local Side = Config.Side or Config.Column or "Left"

				local container = GetTargetContainer(Side)

				if Flag then
					Library.Flags[Flag] = CurrentValue
				end

				local sliderFrame = Instance.new("Frame")
				sliderFrame.Name = Name .. "_Slider"
				sliderFrame.Size = UDim2.new(1, -6, 0, 50)
				sliderFrame.BackgroundColor3 = Library.Theme.Card
				sliderFrame.BorderSizePixel = 0
				sliderFrame.Parent = container

				local cardCorner = Instance.new("UICorner")
				cardCorner.CornerRadius = UDim.new(0, 8)
				cardCorner.Parent = sliderFrame

				local cardStroke = Instance.new("UIStroke")
				cardStroke.Color = Library.Theme.Border
				cardStroke.Thickness = 1
				cardStroke.Parent = sliderFrame

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(0.7, 0, 0, 20)
				label.Position = UDim2.new(0, 12, 0, 6)
				label.BackgroundTransparency = 1
				label.Text = Name
				label.TextColor3 = Library.Theme.TextPrimary
				label.Font = Enum.Font.GothamMedium
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = sliderFrame

				local valueLabel = Instance.new("TextLabel")
				valueLabel.Size = UDim2.new(0.3, -12, 0, 20)
				valueLabel.Position = UDim2.new(0.7, 0, 0, 6)
				valueLabel.BackgroundTransparency = 1
				valueLabel.Text = tostring(CurrentValue)
				valueLabel.TextColor3 = Library.Theme.AccentGlow
				valueLabel.Font = Enum.Font.GothamBold
				valueLabel.TextSize = 12
				valueLabel.TextXAlignment = Enum.TextXAlignment.Right
				valueLabel.Parent = sliderFrame

				local track = Instance.new("Frame")
				track.Size = UDim2.new(1, -24, 0, 6)
				track.Position = UDim2.new(0, 12, 0, 32)
				track.BackgroundColor3 = Library.Theme.ToggleOff
				track.BorderSizePixel = 0
				track.Parent = sliderFrame

				local trackCorner = Instance.new("UICorner")
				trackCorner.CornerRadius = UDim.new(1, 0)
				trackCorner.Parent = track

				local fill = Instance.new("Frame")
				fill.Size = UDim2.new((CurrentValue - Min) / (Max - Min), 0, 1, 0)
				fill.BackgroundColor3 = Library.Theme.Accent
				fill.BorderSizePixel = 0
				fill.Parent = track

				local fillCorner = Instance.new("UICorner")
				fillCorner.CornerRadius = UDim.new(1, 0)
				fillCorner.Parent = fill

				local isDragging = false

				local function UpdateSlider(input)
					local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					local val = math.floor(Min + ((Max - Min) * pos))
					CurrentValue = val
					if Flag then
						Library.Flags[Flag] = CurrentValue
					end
					valueLabel.Text = tostring(CurrentValue)
					TweenService:Create(fill, TweenInfo.new(0.05), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
					pcall(Callback, CurrentValue)
				end

				track.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isDragging = true
						UpdateSlider(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						isDragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						UpdateSlider(input)
					end
				end)

				local Element = {}
				function Element:Set(Val)
					Val = math.clamp(Val, Min, Max)
					CurrentValue = Val
					if Flag then
						Library.Flags[Flag] = CurrentValue
					end
					valueLabel.Text = tostring(CurrentValue)
					local pos = (CurrentValue - Min) / (Max - Min)
					TweenService:Create(fill, TweenInfo.new(0.15), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
					pcall(Callback, CurrentValue)
				end
				return Element
			end

			function subTab:CreateDropdown(Config)
				Config = Config or {}
				local Name = Config.Name or "Dropdown"
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
				dropdownMain.Size = UDim2.new(1, -6, 0, 40)
				dropdownMain.BackgroundColor3 = Library.Theme.Card
				dropdownMain.BorderSizePixel = 0
				dropdownMain.ClipsDescendants = true
				dropdownMain.Parent = container

				local cardCorner = Instance.new("UICorner")
				cardCorner.CornerRadius = UDim.new(0, 8)
				cardCorner.Parent = dropdownMain

				local cardStroke = Instance.new("UIStroke")
				cardStroke.Color = Library.Theme.Border
				cardStroke.Thickness = 1
				cardStroke.Parent = dropdownMain

				local headerBtn = Instance.new("TextButton")
				headerBtn.Size = UDim2.new(1, 0, 0, 40)
				headerBtn.BackgroundTransparency = 1
				headerBtn.Text = ""
				headerBtn.Parent = dropdownMain

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(0.5, 0, 1, 0)
				label.Position = UDim2.new(0, 12, 0, 0)
				label.BackgroundTransparency = 1
				label.Text = Name
				label.TextColor3 = Library.Theme.TextPrimary
				label.Font = Enum.Font.GothamMedium
				label.TextSize = 13
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = headerBtn

				local selectedLabel = Instance.new("TextLabel")
				selectedLabel.Size = UDim2.new(0.5, -35, 1, 0)
				selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
				selectedLabel.BackgroundTransparency = 1
				selectedLabel.Text = tostring(CurrentOption)
				selectedLabel.TextColor3 = Library.Theme.AccentGlow
				selectedLabel.Font = Enum.Font.Gotham
				selectedLabel.TextSize = 12
				selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
				selectedLabel.Parent = headerBtn

				local arrow = Instance.new("TextLabel")
				arrow.Size = UDim2.new(0, 24, 1, 0)
				arrow.Position = UDim2.new(1, -28, 0, 0)
				arrow.BackgroundTransparency = 1
				arrow.Text = "▼"
				arrow.TextColor3 = Library.Theme.TextSecondary
				arrow.Font = Enum.Font.GothamBold
				arrow.TextSize = 10
				arrow.Parent = headerBtn

				local optionHolder = Instance.new("Frame")
				optionHolder.Size = UDim2.new(1, -16, 0, #Options * 30)
				optionHolder.Position = UDim2.new(0, 8, 0, 40)
				optionHolder.BackgroundTransparency = 1
				optionHolder.Parent = dropdownMain

				local optionLayout = Instance.new("UIListLayout")
				optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
				optionLayout.Padding = UDim.new(0, 4)
				optionLayout.Parent = optionHolder

				local function ToggleDropdown()
					isOpen = not isOpen
					local targetHeight = isOpen and (46 + (#Options * 34)) or 40
					arrow.Text = isOpen and "▲" or "▼"
					TweenService:Create(dropdownMain, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, -6, 0, targetHeight)}):Play()
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
						optBtn.Size = UDim2.new(1, 0, 0, 30)
						optBtn.BackgroundColor3 = (opt == CurrentOption) and Library.Theme.Accent or Library.Theme.Sidebar
						optBtn.BackgroundTransparency = (opt == CurrentOption) and 0.8 or 0
						optBtn.BorderSizePixel = 0
						optBtn.Text = "   " .. tostring(opt)
						optBtn.TextColor3 = (opt == CurrentOption) and Library.Theme.AccentGlow or Library.Theme.TextSecondary
						optBtn.Font = Enum.Font.GothamMedium
						optBtn.TextSize = 12
						optBtn.TextXAlignment = Enum.TextXAlignment.Left
						optBtn.Parent = optionHolder

						local optCorner = Instance.new("UICorner")
						optCorner.CornerRadius = UDim.new(0, 6)
						optCorner.Parent = optBtn

						optBtn.MouseButton1Click:Connect(function()
							CurrentOption = opt
							selectedLabel.Text = tostring(CurrentOption)
							if Flag then
								Library.Flags[Flag] = CurrentOption
							end

							for _, child in ipairs(optionHolder:GetChildren()) do
								if child:IsA("TextButton") then
									child.BackgroundTransparency = 0
									child.BackgroundColor3 = Library.Theme.Sidebar
									child.TextColor3 = Library.Theme.TextSecondary
								end
							end
							optBtn.BackgroundTransparency = 0.8
							optBtn.BackgroundColor3 = Library.Theme.Accent
							optBtn.TextColor3 = Library.Theme.AccentGlow

							ToggleDropdown()
							pcall(Callback, CurrentOption)
						end)
					end
				end

				RefreshButtons()

				local Element = {}
				function Element:Set(NewOption)
					CurrentOption = NewOption
					selectedLabel.Text = tostring(CurrentOption)
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

return Library
