local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {
    Flags = {},
    Unloaded = false,
    Theme = {
        Background = Color3.fromRGB(20, 20, 23),
        Sidebar = Color3.fromRGB(25, 25, 30),
        Card = Color3.fromRGB(32, 32, 38),
        CardHover = Color3.fromRGB(42, 42, 48),
        Accent = Color3.fromRGB(85, 255, 170), -- Bright Mint Green
        AccentDark = Color3.fromRGB(40, 160, 100),
        TextPrimary = Color3.fromRGB(240, 240, 245),
        TextSecondary = Color3.fromRGB(130, 130, 140),
        Border = Color3.fromRGB(40, 40, 45),
        ToggleOff = Color3.fromRGB(45, 45, 52)
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
    local ScriptName = WindowConfig.Name or "UNLOCK BY HARITY"

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
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Library.Theme.Border
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = Library.Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    sidebarCorner.Parent = sidebar

    local sidebarFix = Instance.new("Frame")
    sidebarFix.Size = UDim2.new(0, 10, 1, 0)
    sidebarFix.Position = UDim2.new(1, -10, 0, 0)
    sidebarFix.BackgroundColor3 = Library.Theme.Sidebar
    sidebarFix.BorderSizePixel = 0
    sidebarFix.Parent = sidebar

    MakeDraggable(sidebar, mainFrame)

    local tabButtonContainer = Instance.new("ScrollingFrame")
    tabButtonContainer.Name = "TabButtonContainer"
    tabButtonContainer.Size = UDim2.new(1, 0, 1, -20)
    tabButtonContainer.Position = UDim2.new(0, 0, 0, 10)
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
    contentContainer.Size = UDim2.new(1, -210, 1, -20)
    contentContainer.Position = UDim2.new(0, 205, 0, 10)
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
        tabBtn.Size = UDim2.new(1, 0, 0, 38)
        tabBtn.BackgroundColor3 = Library.Theme.Card
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = "    " .. TabName
        tabBtn.TextColor3 = Library.Theme.TextSecondary
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 14
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Parent = tabButtonContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn

        local tabFrame = Instance.new("Frame")
        tabFrame.Name = TabName .. "_TabFrame"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = contentContainer

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

        local bodyFrame = Instance.new("Frame")
        bodyFrame.Name = "BodyFrame"
        bodyFrame.Size = UDim2.new(1, 0, 1, -45)
        bodyFrame.Position = UDim2.new(0, 0, 0, 45)
        bodyFrame.BackgroundTransparency = 1
        bodyFrame.Parent = tabFrame

        local function SwitchTab()
            for _, t in pairs(Window.Tabs) do
                t.Frame.Visible = false
                t.Button.BackgroundTransparency = 1
                t.Button.TextColor3 = Library.Theme.TextSecondary
            end
            tabFrame.Visible = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Library.Theme.TextPrimary
            Window.ActiveTab = tab
        end

        tabBtn.MouseButton1Click:Connect(SwitchTab)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= tab then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tab then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
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
            subTabBtn.Size = UDim2.new(0, 120, 1, 0)
            subTabBtn.BackgroundColor3 = Library.Theme.Card
            subTabBtn.BorderSizePixel = 0
            subTabBtn.Text = SubTabName
            subTabBtn.TextColor3 = Library.Theme.TextSecondary
            subTabBtn.Font = Enum.Font.GothamMedium
            subTabBtn.TextSize = 13
            subTabBtn.Parent = subTabHeader

            local subTabCorner = Instance.new("UICorner")
            subTabCorner.CornerRadius = UDim.new(0, 6)
            subTabCorner.Parent = subTabBtn

            local subTabFrame = Instance.new("Frame")
            subTabFrame.Name = SubTabName .. "_SubTabFrame"
            subTabFrame.Size = UDim2.new(1, 0, 1, 0)
            subTabFrame.BackgroundTransparency = 1
            subTabFrame.Visible = false
            subTabFrame.Parent = bodyFrame

            -- Large Title Header (Like "unlock by Harity")
            local mainTitle = Instance.new("TextLabel")
            mainTitle.Size = UDim2.new(1, 0, 0, 30)
            mainTitle.Position = UDim2.new(0, 4, 0, 0)
            mainTitle.BackgroundTransparency = 1
            mainTitle.Text = SubTabName:upper()
            mainTitle.TextColor3 = Library.Theme.TextPrimary
            mainTitle.Font = Enum.Font.GothamBold
            mainTitle.TextSize = 20
            mainTitle.TextXAlignment = Enum.TextXAlignment.Left
            mainTitle.Parent = subTabFrame

            local leftBox = Instance.new("Frame")
            leftBox.Name = "LeftBox"
            leftBox.Size = UDim2.new(0.5, -6, 1, -40)
            leftBox.Position = UDim2.new(0, 0, 0, 40)
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
            rightBox.Size = UDim2.new(0.5, -6, 1, -40)
            rightBox.Position = UDim2.new(0.5, 6, 0, 40)
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
                    st.Button.BackgroundColor3 = Library.Theme.Card
                end
                subTabFrame.Visible = true
                subTabBtn.TextColor3 = Library.Theme.Accent
                subTabBtn.BackgroundColor3 = Library.Theme.CardHover
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

            function subTab:CreateLabel(Config)
                Config = Config or {}
                local Name = Config.Name or "LABEL"
                local Side = Config.Side or Config.Column or "Left"

                local container = GetTargetContainer(Side)

                local labelFrame = Instance.new("TextLabel")
                labelFrame.Size = UDim2.new(1, 0, 0, 25)
                labelFrame.BackgroundTransparency = 1
                labelFrame.Text = Name
                labelFrame.TextColor3 = Library.Theme.TextSecondary
                labelFrame.Font = Enum.Font.GothamBold
                labelFrame.TextSize = 12
                labelFrame.TextXAlignment = Enum.TextXAlignment.Left
                labelFrame.Parent = container

                local Element = {}
                function Element:Set(NewName)
                    labelFrame.Text = NewName
                end
                return Element
            end

            function subTab:CreateButton(Config)
                Config = Config or {}
                local Name = Config.Name or "BUTTON"
                local Callback = Config.Callback or function() end
                local Side = Config.Side or Config.Column or "Left"
                local IsPrimary = Config.Primary or false

                local container = GetTargetContainer(Side)

                local btnFrame = Instance.new("Frame")
                btnFrame.Name = Name .. "_Button"
                btnFrame.Size = UDim2.new(1, 0, 0, 42)
                btnFrame.BackgroundColor3 = IsPrimary and Library.Theme.Accent or Library.Theme.Card
                btnFrame.BorderSizePixel = 0
                btnFrame.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 6)
                cardCorner.Parent = btnFrame

                local cardStroke = Instance.new("UIStroke")
                cardStroke.Color = Library.Theme.Border
                cardStroke.Thickness = 1
                cardStroke.Transparency = IsPrimary and 1 or 0
                cardStroke.Parent = btnFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -20, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = IsPrimary and Color3.fromRGB(20, 20, 23) or Library.Theme.TextPrimary
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Center
                label.Parent = btnFrame

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 1, 0)
                button.BackgroundTransparency = 1
                button.Text = ""
                button.Parent = btnFrame

                button.MouseEnter:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = IsPrimary and Color3.fromRGB(120, 255, 190) or Library.Theme.CardHover}):Play()
                end)

                button.MouseLeave:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = IsPrimary and Library.Theme.Accent or Library.Theme.Card}):Play()
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
                local Name = Config.Name or "TOGGLE"
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
                toggleFrame.Size = UDim2.new(1, 0, 0, 42)
                toggleFrame.BackgroundColor3 = Library.Theme.Card
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 6)
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
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = toggleFrame

                local toggleTrack = Instance.new("Frame")
                toggleTrack.Size = UDim2.new(0, 40, 0, 22)
                toggleTrack.Position = UDim2.new(1, -52, 0.5, -11)
                toggleTrack.BackgroundColor3 = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff
                toggleTrack.BorderSizePixel = 0
                toggleTrack.Parent = toggleFrame

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = toggleTrack

                local toggleKnob = Instance.new("Frame")
                toggleKnob.Size = UDim2.new(0, 16, 0, 16)
                toggleKnob.Position = CurrentValue and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
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
                    local knobPos = CurrentValue and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                    local trackCol = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff

                    TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = knobPos}):Play()
                    TweenService:Create(toggleTrack, TweenInfo.new(0.2), {BackgroundColor3 = trackCol}):Play()

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

            function subTab:CreateDropdown(Config)
                Config = Config or {}
                local Name = Config.Name or "DROPDOWN"
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
                dropdownMain.Size = UDim2.new(1, 0, 0, 42)
                dropdownMain.BackgroundColor3 = Library.Theme.Card
                dropdownMain.BorderSizePixel = 0
                dropdownMain.ClipsDescendants = true
                dropdownMain.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 6)
                cardCorner.Parent = dropdownMain

                local cardStroke = Instance.new("UIStroke")
                cardStroke.Color = Library.Theme.Border
                cardStroke.Thickness = 1
                cardStroke.Parent = dropdownMain

                local headerBtn = Instance.new("TextButton")
                headerBtn.Size = UDim2.new(1, 0, 0, 42)
                headerBtn.BackgroundTransparency = 1
                headerBtn.Text = ""
                headerBtn.Parent = dropdownMain

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.5, 0, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = Library.Theme.TextSecondary
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = headerBtn

                local selectedLabel = Instance.new("TextLabel")
                selectedLabel.Size = UDim2.new(0.5, -40, 1, 0)
                selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
                selectedLabel.BackgroundTransparency = 1
                selectedLabel.Text = tostring(CurrentOption)
                selectedLabel.TextColor3 = Library.Theme.TextPrimary
                selectedLabel.Font = Enum.Font.GothamMedium
                selectedLabel.TextSize = 13
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
                optionHolder.Size = UDim2.new(1, -16, 0, #Options * 34)
                optionHolder.Position = UDim2.new(0, 8, 0, 46)
                optionHolder.BackgroundTransparency = 1
                optionHolder.Parent = dropdownMain

                local optionLayout = Instance.new("UIListLayout")
                optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                optionLayout.Padding = UDim.new(0, 4)
                optionLayout.Parent = optionHolder

                local function ToggleDropdown()
                    isOpen = not isOpen
                    local targetHeight = isOpen and (42 + 8 + (#Options * 34)) or 42
                    TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = isOpen and 180 or 0}):Play()
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
                        optBtn.Size = UDim2.new(1, 0, 0, 30)
                        optBtn.BackgroundColor3 = (opt == CurrentOption) and Library.Theme.AccentDark or Library.Theme.Background
                        optBtn.BorderSizePixel = 0
                        optBtn.Text = "   " .. tostring(opt)
                        optBtn.TextColor3 = (opt == CurrentOption) and Color3.fromRGB(255, 255, 255) or Library.Theme.TextSecondary
                        optBtn.Font = Enum.Font.GothamMedium
                        optBtn.TextSize = 13
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.Parent = optionHolder

                        local optCorner = Instance.new("UICorner")
                        optCorner.CornerRadius = UDim.new(0, 4)
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
                            RefreshButtons()
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

return Librarylocal TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Library = {
    Flags = {},
    Unloaded = false,
    Theme = {
        Background = Color3.fromRGB(20, 20, 23),
        Sidebar = Color3.fromRGB(25, 25, 30),
        Card = Color3.fromRGB(32, 32, 38),
        CardHover = Color3.fromRGB(42, 42, 48),
        Accent = Color3.fromRGB(85, 255, 170), -- Bright Mint Green
        AccentDark = Color3.fromRGB(40, 160, 100),
        TextPrimary = Color3.fromRGB(240, 240, 245),
        TextSecondary = Color3.fromRGB(130, 130, 140),
        Border = Color3.fromRGB(40, 40, 45),
        ToggleOff = Color3.fromRGB(45, 45, 52)
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
    local ScriptName = WindowConfig.Name or "UNLOCK BY HARITY"

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
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Library.Theme.Border
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame

    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.BackgroundColor3 = Library.Theme.Sidebar
    sidebar.BorderSizePixel = 0
    sidebar.Parent = mainFrame

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    sidebarCorner.Parent = sidebar

    local sidebarFix = Instance.new("Frame")
    sidebarFix.Size = UDim2.new(0, 10, 1, 0)
    sidebarFix.Position = UDim2.new(1, -10, 0, 0)
    sidebarFix.BackgroundColor3 = Library.Theme.Sidebar
    sidebarFix.BorderSizePixel = 0
    sidebarFix.Parent = sidebar

    MakeDraggable(sidebar, mainFrame)

    local tabButtonContainer = Instance.new("ScrollingFrame")
    tabButtonContainer.Name = "TabButtonContainer"
    tabButtonContainer.Size = UDim2.new(1, 0, 1, -20)
    tabButtonContainer.Position = UDim2.new(0, 0, 0, 10)
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
    contentContainer.Size = UDim2.new(1, -210, 1, -20)
    contentContainer.Position = UDim2.new(0, 205, 0, 10)
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
        tabBtn.Size = UDim2.new(1, 0, 0, 38)
        tabBtn.BackgroundColor3 = Library.Theme.Card
        tabBtn.BackgroundTransparency = 1
        tabBtn.BorderSizePixel = 0
        tabBtn.Text = "    " .. TabName
        tabBtn.TextColor3 = Library.Theme.TextSecondary
        tabBtn.Font = Enum.Font.GothamMedium
        tabBtn.TextSize = 14
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.Parent = tabButtonContainer

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = tabBtn

        local tabFrame = Instance.new("Frame")
        tabFrame.Name = TabName .. "_TabFrame"
        tabFrame.Size = UDim2.new(1, 0, 1, 0)
        tabFrame.BackgroundTransparency = 1
        tabFrame.Visible = false
        tabFrame.Parent = contentContainer

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

        local bodyFrame = Instance.new("Frame")
        bodyFrame.Name = "BodyFrame"
        bodyFrame.Size = UDim2.new(1, 0, 1, -45)
        bodyFrame.Position = UDim2.new(0, 0, 0, 45)
        bodyFrame.BackgroundTransparency = 1
        bodyFrame.Parent = tabFrame

        local function SwitchTab()
            for _, t in pairs(Window.Tabs) do
                t.Frame.Visible = false
                t.Button.BackgroundTransparency = 1
                t.Button.TextColor3 = Library.Theme.TextSecondary
            end
            tabFrame.Visible = true
            tabBtn.BackgroundTransparency = 0
            tabBtn.TextColor3 = Library.Theme.TextPrimary
            Window.ActiveTab = tab
        end

        tabBtn.MouseButton1Click:Connect(SwitchTab)
        
        tabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= tab then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= tab then
                TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
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
            subTabBtn.Size = UDim2.new(0, 120, 1, 0)
            subTabBtn.BackgroundColor3 = Library.Theme.Card
            subTabBtn.BorderSizePixel = 0
            subTabBtn.Text = SubTabName
            subTabBtn.TextColor3 = Library.Theme.TextSecondary
            subTabBtn.Font = Enum.Font.GothamMedium
            subTabBtn.TextSize = 13
            subTabBtn.Parent = subTabHeader

            local subTabCorner = Instance.new("UICorner")
            subTabCorner.CornerRadius = UDim.new(0, 6)
            subTabCorner.Parent = subTabBtn

            local subTabFrame = Instance.new("Frame")
            subTabFrame.Name = SubTabName .. "_SubTabFrame"
            subTabFrame.Size = UDim2.new(1, 0, 1, 0)
            subTabFrame.BackgroundTransparency = 1
            subTabFrame.Visible = false
            subTabFrame.Parent = bodyFrame

            -- Large Title Header (Like "unlock by Harity")
            local mainTitle = Instance.new("TextLabel")
            mainTitle.Size = UDim2.new(1, 0, 0, 30)
            mainTitle.Position = UDim2.new(0, 4, 0, 0)
            mainTitle.BackgroundTransparency = 1
            mainTitle.Text = SubTabName:upper()
            mainTitle.TextColor3 = Library.Theme.TextPrimary
            mainTitle.Font = Enum.Font.GothamBold
            mainTitle.TextSize = 20
            mainTitle.TextXAlignment = Enum.TextXAlignment.Left
            mainTitle.Parent = subTabFrame

            local leftBox = Instance.new("Frame")
            leftBox.Name = "LeftBox"
            leftBox.Size = UDim2.new(0.5, -6, 1, -40)
            leftBox.Position = UDim2.new(0, 0, 0, 40)
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
            rightBox.Size = UDim2.new(0.5, -6, 1, -40)
            rightBox.Position = UDim2.new(0.5, 6, 0, 40)
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
                    st.Button.BackgroundColor3 = Library.Theme.Card
                end
                subTabFrame.Visible = true
                subTabBtn.TextColor3 = Library.Theme.Accent
                subTabBtn.BackgroundColor3 = Library.Theme.CardHover
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

            function subTab:CreateLabel(Config)
                Config = Config or {}
                local Name = Config.Name or "LABEL"
                local Side = Config.Side or Config.Column or "Left"

                local container = GetTargetContainer(Side)

                local labelFrame = Instance.new("TextLabel")
                labelFrame.Size = UDim2.new(1, 0, 0, 25)
                labelFrame.BackgroundTransparency = 1
                labelFrame.Text = Name
                labelFrame.TextColor3 = Library.Theme.TextSecondary
                labelFrame.Font = Enum.Font.GothamBold
                labelFrame.TextSize = 12
                labelFrame.TextXAlignment = Enum.TextXAlignment.Left
                labelFrame.Parent = container

                local Element = {}
                function Element:Set(NewName)
                    labelFrame.Text = NewName
                end
                return Element
            end

            function subTab:CreateButton(Config)
                Config = Config or {}
                local Name = Config.Name or "BUTTON"
                local Callback = Config.Callback or function() end
                local Side = Config.Side or Config.Column or "Left"
                local IsPrimary = Config.Primary or false

                local container = GetTargetContainer(Side)

                local btnFrame = Instance.new("Frame")
                btnFrame.Name = Name .. "_Button"
                btnFrame.Size = UDim2.new(1, 0, 0, 42)
                btnFrame.BackgroundColor3 = IsPrimary and Library.Theme.Accent or Library.Theme.Card
                btnFrame.BorderSizePixel = 0
                btnFrame.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 6)
                cardCorner.Parent = btnFrame

                local cardStroke = Instance.new("UIStroke")
                cardStroke.Color = Library.Theme.Border
                cardStroke.Thickness = 1
                cardStroke.Transparency = IsPrimary and 1 or 0
                cardStroke.Parent = btnFrame

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -20, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = IsPrimary and Color3.fromRGB(20, 20, 23) or Library.Theme.TextPrimary
                label.Font = Enum.Font.GothamBold
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Center
                label.Parent = btnFrame

                local button = Instance.new("TextButton")
                button.Size = UDim2.new(1, 0, 1, 0)
                button.BackgroundTransparency = 1
                button.Text = ""
                button.Parent = btnFrame

                button.MouseEnter:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = IsPrimary and Color3.fromRGB(120, 255, 190) or Library.Theme.CardHover}):Play()
                end)

                button.MouseLeave:Connect(function()
                    TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = IsPrimary and Library.Theme.Accent or Library.Theme.Card}):Play()
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
                local Name = Config.Name or "TOGGLE"
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
                toggleFrame.Size = UDim2.new(1, 0, 0, 42)
                toggleFrame.BackgroundColor3 = Library.Theme.Card
                toggleFrame.BorderSizePixel = 0
                toggleFrame.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 6)
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
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = toggleFrame

                local toggleTrack = Instance.new("Frame")
                toggleTrack.Size = UDim2.new(0, 40, 0, 22)
                toggleTrack.Position = UDim2.new(1, -52, 0.5, -11)
                toggleTrack.BackgroundColor3 = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff
                toggleTrack.BorderSizePixel = 0
                toggleTrack.Parent = toggleFrame

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = toggleTrack

                local toggleKnob = Instance.new("Frame")
                toggleKnob.Size = UDim2.new(0, 16, 0, 16)
                toggleKnob.Position = CurrentValue and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
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
                    local knobPos = CurrentValue and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
                    local trackCol = CurrentValue and Library.Theme.Accent or Library.Theme.ToggleOff

                    TweenService:Create(toggleKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = knobPos}):Play()
                    TweenService:Create(toggleTrack, TweenInfo.new(0.2), {BackgroundColor3 = trackCol}):Play()

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

            function subTab:CreateDropdown(Config)
                Config = Config or {}
                local Name = Config.Name or "DROPDOWN"
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
                dropdownMain.Size = UDim2.new(1, 0, 0, 42)
                dropdownMain.BackgroundColor3 = Library.Theme.Card
                dropdownMain.BorderSizePixel = 0
                dropdownMain.ClipsDescendants = true
                dropdownMain.Parent = container

                local cardCorner = Instance.new("UICorner")
                cardCorner.CornerRadius = UDim.new(0, 6)
                cardCorner.Parent = dropdownMain

                local cardStroke = Instance.new("UIStroke")
                cardStroke.Color = Library.Theme.Border
                cardStroke.Thickness = 1
                cardStroke.Parent = dropdownMain

                local headerBtn = Instance.new("TextButton")
                headerBtn.Size = UDim2.new(1, 0, 0, 42)
                headerBtn.BackgroundTransparency = 1
                headerBtn.Text = ""
                headerBtn.Parent = dropdownMain

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(0.5, 0, 1, 0)
                label.Position = UDim2.new(0, 12, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = Name
                label.TextColor3 = Library.Theme.TextSecondary
                label.Font = Enum.Font.GothamMedium
                label.TextSize = 13
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = headerBtn

                local selectedLabel = Instance.new("TextLabel")
                selectedLabel.Size = UDim2.new(0.5, -40, 1, 0)
                selectedLabel.Position = UDim2.new(0.5, 0, 0, 0)
                selectedLabel.BackgroundTransparency = 1
                selectedLabel.Text = tostring(CurrentOption)
                selectedLabel.TextColor3 = Library.Theme.TextPrimary
                selectedLabel.Font = Enum.Font.GothamMedium
                selectedLabel.TextSize = 13
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
                optionHolder.Size = UDim2.new(1, -16, 0, #Options * 34)
                optionHolder.Position = UDim2.new(0, 8, 0, 46)
                optionHolder.BackgroundTransparency = 1
                optionHolder.Parent = dropdownMain

                local optionLayout = Instance.new("UIListLayout")
                optionLayout.SortOrder = Enum.SortOrder.LayoutOrder
                optionLayout.Padding = UDim.new(0, 4)
                optionLayout.Parent = optionHolder

                local function ToggleDropdown()
                    isOpen = not isOpen
                    local targetHeight = isOpen and (42 + 8 + (#Options * 34)) or 42
                    TweenService:Create(arrow, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = isOpen and 180 or 0}):Play()
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
                        optBtn.Size = UDim2.new(1, 0, 0, 30)
                        optBtn.BackgroundColor3 = (opt == CurrentOption) and Library.Theme.AccentDark or Library.Theme.Background
                        optBtn.BorderSizePixel = 0
                        optBtn.Text = "   " .. tostring(opt)
                        optBtn.TextColor3 = (opt == CurrentOption) and Color3.fromRGB(255, 255, 255) or Library.Theme.TextSecondary
                        optBtn.Font = Enum.Font.GothamMedium
                        optBtn.TextSize = 13
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.Parent = optionHolder

                        local optCorner = Instance.new("UICorner")
                        optCorner.CornerRadius = UDim.new(0, 4)
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
                            RefreshButtons()
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
