local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {
    Flags = {},
    Unloaded = false,
    Theme = {
        Background = Color3.fromRGB(20, 20, 24),
        Card = Color3.fromRGB(28, 28, 34),
        CardHover = Color3.fromRGB(35, 35, 42),
        Accent = Color3.fromRGB(85, 132, 255),
        AccentGlow = Color3.fromRGB(120, 160, 255),
        TextPrimary = Color3.fromRGB(240, 240, 245),
        TextSecondary = Color3.fromRGB(140, 140, 155),
        Border = Color3.fromRGB(45, 45, 55),
        ToggleOff = Color3.fromRGB(40, 40, 48)
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
    mainFrame.Size = UDim2.new(0, 720, 0, 480)
    mainFrame.Position = UDim2.new(0.5, -360, 0.5, -240)
    mainFrame.BackgroundColor3 = Library.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Library.Theme.Border
    mainStroke.Thickness = 1
    mainStroke.Transparency = 0.2
    mainStroke.Parent = mainFrame

    local mainGradient = Instance.new("UIGradient")
    mainGradient.Rotation = 90
    mainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 18))
    })
    mainGradient.Parent = mainFrame

    -- Top Bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundTransparency = 1
    topBar.Parent = mainFrame

    MakeDraggable(topBar, mainFrame)

    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0.6, 0, 1, 0)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = topBar

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.FillDirection = Enum.FillDirection.Horizontal
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Padding = UDim.new(0, 6)
    tabListLayout.Parent = tabContainer

    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingLeft = UDim.new(0, 14)
    tabPadding.PaddingTop = UDim.new(0, 14)
    tabPadding.Parent = tabContainer

    local scriptNameLabel = Instance.new("TextLabel")
    scriptNameLabel.Size = UDim2.new(0.4, -20, 1, 0)
    scriptNameLabel.Position = UDim2.new(0.6, 0, 0, 0)
    scriptNameLabel.BackgroundTransparency = 1
    scriptNameLabel.Text = TitleText
    scriptNameLabel.TextColor3 = Library.Theme.TextSecondary
    scriptNameLabel.Font = Enum.Font.GothamBold
    scriptNameLabel.TextSize = 14
    scriptNameLabel.TextXAlignment = Enum.TextXAlignment.Right
    scriptNameLabel.Parent = topBar

    local scriptNamePadding = Instance.new("UIPadding")
    scriptNamePadding.PaddingRight = UDim.new(0, 14)
    scriptNamePadding.Parent = scriptNameLabel

    local topSeparator = Instance.new("Frame")
    topSeparator.Size = UDim2.new(1, 0, 0, 1)
    topSeparator.Position = UDim2.new(0, 0, 1, -1)
    topSeparator.BackgroundColor3 = Library.Theme.Border
    topSeparator.BorderSizePixel = 0
    topSeparator.Parent = topBar

    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, 0, 1, -45)
    contentArea.Position = UDim2.new(0, 0, 0, 45)
    contentArea.BackgroundTransparency = 1
    contentArea.Parent = mainFrame

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
        tabBtn.Size = UDim2.new(0, 100, 1, -14)
        tabBtn.BackgroundColor3 = Library.Theme.Card
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = TabName
        tabBtn.TextColor3 = Library.Theme.TextSecondary
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 13
        tabBtn.Parent = tabContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn

        local tabFrame = Instance.new("Frame")
        tabFrame.Name = TabName .. "_TabFrame"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = contentArea

        local subTabHeader = Instance.new("Frame")
        subTabHeader.Name = "SubTabHeader"
        subTabHeader.Size = UDim2.new(1, 0, 0, 40)
        subTabHeader.BackgroundTransparency = 1
        subTabHeader.Parent = tabFrame

        local subTabListLayout = Instance.new("UIListLayout")
        subTabListLayout.FillDirection = Enum.FillDirection.Horizontal
        subTabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        subTabListLayout.Padding = UDim.new(0, 8)
        subTabListLayout.Parent = subTabHeader

        local subTabPadding = Instance.new("UIPadding")
        subTabPadding.PaddingLeft = UDim.new(0, 14)
        subTabPadding.PaddingTop = UDim.new(0, 10)
        subTabPadding.Parent = subTabHeader

        local bodyFrame = Instance.new("Frame")
        bodyFrame.Name = "BodyFrame"
        bodyFrame.Size = UDim2.new(1, 0, 1, -40)
        bodyFrame.Position = UDim2.new(0, 0, 0, 40)
        bodyFrame.BackgroundTransparency = 1
        bodyFrame.Parent = tabFrame

        local function SwitchTab()
            for _, t in pairs(Window.Tabs) do
                t.Frame.Visible = false
                t.Button.BackgroundColor3 = Library.Theme.Card
                t.Button.TextColor3 = Library.Theme.TextSecondary
            end
            tabFrame.Visible = true
            tabBtn.BackgroundColor3 = Library.Theme.Accent
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            Window.ActiveTab = tab
        end

        tabBtn.MouseButton1Click:Connect(SwitchTab)
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= tab then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.CardHover}):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tab then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Card}):Play()
            end
        end)

        if #Window.Tabs == 0 then
            SwitchTab()
        end

        tab.Frame = tabFrame
        tab.Button = tabBtn

        function tab:CreateSubTab(SubTabName)
            local subTab = {}

            local subTabBtn = Instance.new("TextButton")
            subTabBtn.Name = SubTabName .. "_SubTabBtn"
            subTabBtn.Size = UDim2.new(0, 110, 1, 0)
            subTabBtn.BackgroundColor3 = Library.Theme.Background
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
            leftBox.Size = UDim2.new(0.5, -8, 1, -14)
            leftBox.Position = UDim2.new(0, 14, 0, 0)
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
            leftLayout.Padding = UDim.new(0, 10)
            leftLayout.Parent = leftScroll

            leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                leftScroll.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 10)
            end)

            local rightBox = Instance.new("Frame")
            rightBox.Name = "RightBox"
            rightBox.Size = UDim2.new(0.5, -8, 1, -14)
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
            rightLayout.Padding = UDim.new(0, 10)
            rightLayout.Parent = rightScroll

            rightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                rightScroll.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 10)
            end)

            local function SwitchSubTab()
                for _, st in pairs(tab.SubTabs) do
                    st.Frame.Visible = false
                    st.Button.TextColor3 = Library.Theme.TextSecondary
                    st.Button.BackgroundColor3 = Library.Theme.Background
                    st.Stroke.Color = Library.Theme.Border
                end
                subTabFrame.Visible = true
                subTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                subTabBtn.BackgroundColor3 = Library.Theme.Card
                subTabStroke.Color = Library.Theme.Accent
                tab.ActiveSubTab = subTab
            end

            subTabBtn.MouseButton1Click:Connect(SwitchSubTab)
            subTabBtn.MouseEnter:Connect(function()
                if tab.ActiveSubTab ~= subTab then
                    TweenService:Create(subTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Card}):Play()
                end
            end)
            subTabBtn.MouseLeave:Connect(function()
                if tab.ActiveSubTab ~= subTab then
                    TweenService:Create(subTabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Background}):Play()
                end
            end)

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
                btnFrame.Size = UDim2.new(1, 0, 0, 40)
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
                label.Size = UDim2.new(1, -50, 1, 0)
                label.Position = UDim2.new(0, 14, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = Library.Theme.TextPrimary
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = btnFrame

                local icon = Instance.new("TextLabel")
                icon.Size = UDim2.new(0, 24, 0, 24)
                icon.Position = UDim2.new(1, -34, 0.5, -12)
                icon.BackgroundTransparency = 1
                icon.Text = "→"
                icon.TextColor3 = Library.Theme.TextSecondary
                icon.Font = Enum.Font.GothamBold
                icon.TextSize = 16
                icon.Parent = btnFrame

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 1, 0)
                button.BackgroundTransparency = 1
                button.Text = ""
                button.Parent = btnFrame

                button.MouseEnter:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.CardHover}):Play()
                    TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = Library.Theme.Accent}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.2), {TextColor3 = Library.Theme.Accent, Position = UDim2.new(1, -30, 0.5, -12)}):Play()
                end)

                button.MouseLeave:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Card}):Play()
                    TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = Library.Theme.Border}):Play()
                    TweenService:Create(icon, TweenInfo.new(0.2), {TextColor3 = Library.Theme.TextSecondary, Position = UDim2.new(1, -34, 0.5, -12)}):Play()
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
                toggleFrame.Size = UDim2.new(1, 0, 0, 40)
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
                label.Position = UDim2.new(0, 14, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = Library.Theme.TextPrimary
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = toggleFrame

                -- Checkbox style to match reference image
                local checkbox = Instance.new("Frame")
                checkbox.Size = UDim2.new(0, 22, 0, 22)
                checkbox.Position = UDim2.new(1, -34, 0.5, -11)
                checkbox.BackgroundColor3 = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff
                checkbox.BorderSizePixel = 0
                checkbox.Parent = toggleFrame

                local checkCorner = Instance.new("UICorner")
                checkCorner.CornerRadius = UDim.new(0, 6)
                checkCorner.Parent = checkbox

                local checkStroke = Instance.new("UIStroke")
                checkStroke.Color = CurrentValue and Library.Theme.Accent or Library.Theme.Border
                checkStroke.Thickness = 1
                checkStroke.Parent = checkbox

                local checkIcon = Instance.new("TextLabel")
                checkIcon.Size = UDim2.new(1, 0, 1, 0)
                checkIcon.BackgroundTransparency = 1
                checkIcon.Text = "✓"
                checkIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
                checkIcon.Font = Enum.Font.GothamBold
                checkIcon.TextSize = 14
                checkIcon.TextTransparency = CurrentValue and 0 or 1
                checkIcon.Parent = checkbox

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

                    local bgCol = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff
                    local strokeCol = CurrentValue and Library.Theme.Accent or Library.Theme.Border
                    
                    TweenService:Create(checkbox, TweenInfo.new(0.2), {BackgroundColor3 = bgCol}):Play()
                    TweenService:Create(checkStroke, TweenInfo.new(0.2), {Color = strokeCol}):Play()
                    
                    if CurrentValue then
                        checkIcon.TextTransparency = 1
                        checkIcon.Rotation = -45
                        TweenService:Create(checkIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0, Rotation = 0}):Play()
                    else
                        TweenService:Create(checkIcon, TweenInfo.new(0.1), {TextTransparency = 1}):Play()
                    end

                    pcall(Callback, CurrentValue)
                end

                button.MouseButton1Click:Connect(function()
                    UpdateToggle(not CurrentValue)
                end)

                button.MouseEnter:Connect(function()
                    TweenService:Create(toggleFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.CardHover}):Play()
                end)
                button.MouseLeave:Connect(function()
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
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
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
                label.Position = UDim2.new(0, 14, 0, 8)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = Library.Theme.TextPrimary
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = sliderFrame

                local valueLabel = Instance.new("TextLabel")
                valueLabel.Size = UDim2.new(0.3, -14, 0, 20)
                valueLabel.Position = UDim2.new(0.7, 0, 0, 8)
                valueLabel.BackgroundTransparency = 1
                valueLabel.Text = tostring(CurrentValue)
                valueLabel.TextColor3 = Library.Theme.AccentGlow
                valueLabel.Font = Enum.Font.GothamBold
                valueLabel.TextSize = 13
                valueLabel.TextXAlignment = Enum.TextXAlignment.Right
                valueLabel.Parent = sliderFrame

                local track = Instance.new("Frame")
                track.Size = UDim2.new(1, -28, 0, 6)
                track.Position = UDim2.new(0, 14, 0, 36)
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

                local fillGradient = Instance.new("UIGradient")
                fillGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Library.Theme.Accent),
                    ColorSequenceKeypoint.new(1, Library.Theme.AccentGlow)
                })
                fillGradient.Parent = fill

                local sliderKnob = Instance.new("Frame")
                sliderKnob.Size = UDim2.new(0, 14, 0, 14)
                sliderKnob.Position = UDim2.new(1, -7, 0.5, -7)
                sliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderKnob.BorderSizePixel = 0
                sliderKnob.Parent = fill

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = sliderKnob

                local knobStroke = Instance.new("UIStroke")
                knobStroke.Color = Library.Theme.Accent
                knobStroke.Thickness = 2
                knobStroke.Parent = sliderKnob

                local sliderHitbox = Instance.new("TextButton")
                sliderHitbox.Size = UDim2.new(1, 0, 0, 30)
                sliderHitbox.Position = UDim2.new(0, 0, 0, 24)
                sliderHitbox.BackgroundTransparency = 1
                sliderHitbox.Text = ""
                sliderHitbox.Parent = sliderFrame

                local isDragging = false

                local function UpdateSlider(input)
                    local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local val = math.floor(Min + ((Max - Min) * pos))
                    CurrentValue = val
                    if Flag then
                        Library.Flags[Flag] = CurrentValue
                    end
                    valueLabel.Text = tostring(CurrentValue)
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    pcall(Callback, CurrentValue)
                end

                sliderHitbox.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isDragging = true
                        TweenService:Create(sliderKnob, TweenInfo.new(0.1), {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -9, 0.5, -9)}):Play()
                        UpdateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        if isDragging then
                            isDragging = false
                            TweenService:Create(sliderKnob, TweenInfo.new(0.1), {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)}):Play()
                        end
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
                dropdownMain.Size = UDim2.new(1, 0, 0, 40)
                dropdownMain.BackgroundColor3 = Library.Theme.Card
                dropdownMain.BorderSizePixel = 0
                dropdownMain.ClipsDescendants = true
                dropdownMain.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 8)
                cardCorner.Parent = dropdownMain

                local cardStroke = Instance.new("UIStroke")
                cardStroke.Color = isOpen and Library.Theme.Accent or Library.Theme.Border
                cardStroke.Thickness = 1
                cardStroke.Parent = dropdownMain

                local headerBtn = Instance.new("TextButton")
                headerBtn.Size = UDim2.new(1, 0, 0, 40)
                headerBtn.BackgroundTransparency = 1
                headerBtn.Text = ""
                headerBtn.Parent = dropdownMain

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.5, 0, 1, 0)
                label.Position = UDim2.new(0, 14, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = Library.Theme.TextPrimary
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = headerBtn

                local selectedLabel = Instance.new("TextLabel")
                selectedLabel.Size = UDim2.new(0.5, -40, 1, 0)
                selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
                selectedLabel.BackgroundTransparency = 1
                selectedLabel.Text = tostring(CurrentOption)
                selectedLabel.TextColor3 = Library.Theme.AccentGlow
                selectedLabel.Font = Enum.Font.GothamMedium
                selectedLabel.TextSize = 12
                selectedLabel.TextXAlignment = Enum.TextXAlignment.Right
                selectedLabel.Parent = headerBtn

                local arrow = Instance.new("ImageButton")
                arrow.Size = UDim2.new(0, 20, 0, 20)
                arrow.Position = UDim2.new(1, -30, 0.5, -10)
                arrow.BackgroundTransparency = 1
                arrow.Image = "rbxassetid://6031094670" -- Down arrow
                arrow.ImageColor3 = Library.Theme.TextSecondary
                arrow.Parent = headerBtn

                local optionHolder = Instance.new("Frame")
                optionHolder.Size = UDim2.new(1, -16, 0, #Options * 32)
                optionHolder.Position = UDim2.new(0, 8, 0, 44)
                optionHolder.BackgroundTransparency = 1
                optionHolder.Parent = dropdownMain

                local optionLayout = Instance.new("UIListLayout")
                optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                optionLayout.Padding = UDim.new(0, 4)
                optionLayout.Parent = optionHolder

                local function ToggleDropdown()
                    isOpen = not isOpen
                    local targetHeight = isOpen and (40 + 8 + (#Options * 32)) or 40
                    
                    TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = isOpen and 180 or 0}):Play()
                    TweenService:Create(arrow, TweenInfo.new(0.2), {ImageColor3 = isOpen and Library.Theme.Accent or Library.Theme.TextSecondary}):Play()
                    TweenService:Create(cardStroke, TweenInfo.new(0.2), {Color = isOpen and Library.Theme.Accent or Library.Theme.Border}):Play()
                    TweenService:Create(dropdownMain, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
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
                        optBtn.Size = UDim2.new(1, 0, 0, 28)
                        optBtn.BackgroundColor3 = (opt == CurrentOption) and Library.Theme.Accent or Library.Theme.Background
                        optBtn.BorderSizePixel = 0
                        optBtn.Text = "   " .. tostring(opt)
                        optBtn.TextColor3 = (opt == CurrentOption) and Color3.fromRGB(255, 255, 255) or Library.Theme.TextSecondary
                        optBtn.Font = Enum.Font.GothamMedium
                        optBtn.TextSize = 12
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.Parent = optionHolder

                        local optCorner = Instance.new("UICorner")
                        optCorner.CornerRadius = UDim.new(0, 6)
                        optCorner.Parent = optBtn

                        optBtn.MouseEnter:Connect(function()
                            if opt ~= CurrentOption then
                                TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.CardHover, TextColor3 = Library.Theme.TextPrimary}):Play()
                            end
                        end)
                        optBtn.MouseLeave:Connect(function()
                            if opt ~= CurrentOption then
                                TweenService:Create(optBtn, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Background, TextColor3 = Library.Theme.TextSecondary}):Play()
                            end
                        end)

                        optBtn.MouseButton1Click:Connect(function()
                            CurrentOption = opt
                            selectedLabel.Text = tostring(CurrentOption)
                            if Flag then
                                Library.Flags[Flag] = CurrentOption
                            end

                            ToggleDropdown()
                            pcall(Callback, CurrentOption)
                            
                            -- Defer refresh to allow dropdown close animation to feel smooth
                            task.defer(RefreshButtons)
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
