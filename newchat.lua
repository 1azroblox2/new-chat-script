local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local chatGui
local chatFrame
local textBox
local layout

local dragging = false
local dragStart
local startPos

local CHAT_COLORS = {
    Background = Color3.fromRGB(30,30,35),
    Border = Color3.fromRGB(70,70,80),
    Name = Color3.fromRGB(150,200,255),
    Message = Color3.fromRGB(255,255,255)
}

function createChat()

    chatGui = Instance.new("ScreenGui")
    chatGui.Name = "CustomChat"
    chatGui.ResetOnSpawn = false

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0,420,0,300)
    main.Position = UDim2.new(0,20,1,-320)
    main.BackgroundColor3 = CHAT_COLORS.Background
    main.BorderColor3 = CHAT_COLORS.Border
    main.Parent = chatGui

    -- Drag alanı
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1,0,0,30)
    topBar.BackgroundColor3 = CHAT_COLORS.Border
    topBar.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,1,0)
    title.Text = "Custom Chat"
    title.TextColor3 = Color3.new(1,1,1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 16
    title.Parent = topBar

    chatFrame = Instance.new("ScrollingFrame")
    chatFrame.Size = UDim2.new(1,-20,1,-80)
    chatFrame.Position = UDim2.new(0,10,0,35)
    chatFrame.BackgroundTransparency = 1
    chatFrame.ScrollBarThickness = 6
    chatFrame.Parent = main

    layout = Instance.new("UIListLayout")
    layout.Parent = chatFrame
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,4)

    textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1,-20,0,35)
    textBox.Position = UDim2.new(0,10,1,-40)
    textBox.PlaceholderText = "Mesaj yaz..."
    textBox.ClearTextOnFocus = false
    textBox.TextColor3 = CHAT_COLORS.Message
    textBox.BackgroundColor3 = CHAT_COLORS.Border
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 16
    textBox.TextWrapped = true
    textBox.Parent = main

    chatGui.Parent = player:WaitForChild("PlayerGui")

    enableDragging(main, topBar)
end


-- Mesaj ekleme
function addMessage(name,msg)

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundTransparency = 1

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0,90,0,0)
    nameLabel.AutomaticSize = Enum.AutomaticSize.Y
    nameLabel.Text = name..":"
    nameLabel.TextColor3 = CHAT_COLORS.Name
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 15
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = frame

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1,-95,0,0)
    msgLabel.Position = UDim2.new(0,95,0,0)
    msgLabel.AutomaticSize = Enum.AutomaticSize.Y
    msgLabel.Text = msg
    msgLabel.TextWrapped = true
    msgLabel.TextColor3 = CHAT_COLORS.Message
    msgLabel.BackgroundTransparency = 1
    msgLabel.Font = Enum.Font.SourceSans
    msgLabel.TextSize = 15
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = frame

    frame.Parent = chatFrame

    chatFrame.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
    chatFrame.CanvasPosition = Vector2.new(0, chatFrame.CanvasSize.Y.Offset)
end


-- Mesaj gönderme
function connectChat()

    textBox.FocusLost:Connect(function(enter)

        if enter then

            local msg = textBox.Text

            if msg ~= "" then
                addMessage(player.Name,msg)
                textBox.Text = ""
            end

        end

    end)

end


-- Sürükleme sistemi
function enableDragging(frame,dragArea)

    dragArea.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end

    end)

    dragArea.InputEnded:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end

    end)

    UserInputService.InputChanged:Connect(function(input)

        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

            local delta = input.Position - dragStart

            frame.Position =
                UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )

        end

    end)

end


createChat()
connectChat()

addMessage("System","Chat hazır!")
