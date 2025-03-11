


local Library = {}

function Library.Create(name,parent,Title,SaveManager,default)
    local shopUI = {}

    local Settings = SaveManager.Data;
    shopUI.List = {}
    shopUI.Select = {}

    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = parent;
    screenGui.Enabled = false;
    screenGui.Name = name or ''

    shopUI['screenGui'] = screenGui;
    -- new UI
    local shopFrame = Instance.new("Frame")
    shopFrame.Size = UDim2.new(0, 600, 0, 400)
    shopFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    shopFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    shopFrame.BorderSizePixel = 0
    shopFrame.Active = true
    shopFrame.Draggable = true -- ทำให้สามารถลาก UI ได้
    shopFrame.Parent = screenGui
    
    -- ป้ายชื่อร้านค้า
    local shopTitle = Instance.new("TextLabel")
    shopTitle.Size = UDim2.new(1, 0, 0, 50)
    shopTitle.Position = UDim2.new(0, 0, 0, 0)
    shopTitle.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    shopTitle.Text = Title
    shopTitle.Font = Enum.Font.GothamBold
    shopTitle.TextSize = 24
    shopTitle.Parent = shopFrame
    
    -- ปุ่มปิดกลมๆ ด้านบนขวา
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -45, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = shopFrame
    closeButton.BorderSizePixel = 0
    closeButton.ClipsDescendants = true
    closeButton.AutoButtonColor = true
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui.Enabled = false
    end)
    
    -- สร้าง ScrollingFrame สำหรับรายการสินค้า
    local itemContainer = Instance.new("ScrollingFrame")
    itemContainer.Size = UDim2.new(0.7, -15, 1, -70)
    itemContainer.Position = UDim2.new(0, 10, 0, 60)
    itemContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    itemContainer.ScrollBarThickness = 4
    itemContainer.Parent = shopFrame
    itemContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y  -- ให้ Canvas ปรับขนาดอัตโนมัติ
    
    -- เพิ่ม UIListLayout เพื่อจัดเรียงสินค้า
    local itemLayout = Instance.new("UIListLayout")
    itemLayout.Parent = itemContainer
    itemLayout.SortOrder = Enum.SortOrder.LayoutOrder
    itemLayout.Padding = UDim.new(0, 5)
    
    -- แถบแสดงรายการสินค้าที่เลือกซื้อ
    local selectedItemsFrame = Instance.new("Frame")
    selectedItemsFrame.Size = UDim2.new(0.3, -10, 1, -70)
    selectedItemsFrame.Position = UDim2.new(0.7, 5, 0, 60)
    selectedItemsFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    selectedItemsFrame.Parent = shopFrame
    
    local selectedTitle = Instance.new("TextLabel")
    selectedTitle.Size = UDim2.new(1, 0, 0, 35)
    selectedTitle.Text = "รายการ"
    selectedTitle.Font = Enum.Font.GothamBold
    selectedTitle.TextSize = 18
    selectedTitle.Parent = selectedItemsFrame
    
    local selectedContainer = Instance.new("ScrollingFrame")
    selectedContainer.Size = UDim2.new(1, 0, 1, -40)
    selectedContainer.Position = UDim2.new(0, 0, 0, 40)
    selectedContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    selectedContainer.ScrollBarThickness = 4
    selectedContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y -- เปิดใช้งานการปรับขนาดอัตโนมัติ
    selectedContainer.Parent = selectedItemsFrame
    
    local selectedLayout = Instance.new("UIListLayout")
    selectedLayout.Parent = selectedContainer
    selectedLayout.SortOrder = Enum.SortOrder.LayoutOrder
    selectedLayout.Padding = UDim.new(0, 5)


    local function CreateList(itemName,imageId)

        warn('itemName', itemName)
        if table.find(shopUI.Select,itemName) then return end;

        local selectedItemFrame = Instance.new("TextButton")
        selectedItemFrame.Size =  UDim2.new(1, 0, 0, 40)
        selectedItemFrame.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        selectedItemFrame.Text = ""
        selectedItemFrame.Parent = selectedContainer
        
        local selectedItemImage = Instance.new("ImageLabel")
        selectedItemImage.Size = UDim2.new(0, 30, 0, 30)
        selectedItemImage.Position = UDim2.new(0, 5, 0, 5)
        selectedItemImage.BackgroundTransparency = 1
        selectedItemImage.Image = "rbxassetid://" .. imageId
        selectedItemImage.Parent = selectedItemFrame
        
        local selectedItemLabel = Instance.new("TextLabel")
        selectedItemLabel.Size = UDim2.new(1, -40, 1, 0)
        selectedItemLabel.Position = UDim2.new(0, 40, 0, 0)
        selectedItemLabel.BackgroundTransparency = 1
        selectedItemLabel.Text = itemName
        selectedItemLabel.Font = Enum.Font.GothamBold
        selectedItemLabel.TextSize = 16
        selectedItemLabel.Parent = selectedItemFrame
        
        selectedItemFrame.MouseButton1Click:Connect(function()

            local key = table.find(Settings[default], itemName)
            local key2 = table.find(shopUI.Select, itemName)

            if key and key2 then 
                table.remove(Settings[default], key)
                table.remove(shopUI.Select, key2)
                selectedItemFrame:Destroy()
            end;

            SaveManager.Set[default] = Settings[default]
        end)

        selectedContainer.CanvasSize = UDim2.new(0, 0, 0, selectedLayout.AbsoluteContentSize.Y + 10)

        if not table.find(Settings[default], itemName) then 
            table.insert(Settings[default], itemName)
            SaveManager.Set[default] = Settings[default]
        end;

        table.insert(shopUI.Select,itemName)
        warn('insert')
    end;

    function shopUI.new(itemName, description, price,imageId)
        local itemFrame = Instance.new("Frame")
        itemFrame.Size = UDim2.new(1, 0, 0, 100)
        itemFrame.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
        itemFrame.BorderSizePixel = 0
        itemFrame.Parent = itemContainer
        
        local itemImage = Instance.new("ImageLabel")
        itemImage.Size = UDim2.new(0, 80, 0, 80)
        itemImage.Position = UDim2.new(0, 10, 0.5, -40)
        itemImage.BackgroundTransparency = 1
        itemImage.Image = "rbxassetid://" .. imageId
        itemImage.Parent = itemFrame
        
        local itemLabel = Instance.new("TextLabel")
        itemLabel.Size = UDim2.new(1, -140, 0, 30)
        itemLabel.Position = UDim2.new(0, 100, 0, 10)
        itemLabel.BackgroundTransparency = 1

        if price then 
            itemLabel.Text = itemName .. " - ฿" .. tostring(price)
        else 
            itemLabel.Text = itemName
        end;

    
        itemLabel.Font = Enum.Font.GothamBold
        itemLabel.TextSize = 18
        itemLabel.Parent = itemFrame
        itemLabel.TextXAlignment = Enum.TextXAlignment.Left
        
        -- if price then 
        --     local priceLabel = Instance.new("TextLabel")
        --     priceLabel.Size = UDim2.new(0, 100, 0, 25)
        --     priceLabel.Position = UDim2.new(1, -120, 0, 95)
        --     priceLabel.BackgroundTransparency = 1
        --     priceLabel.Text = "฿" .. price
        --     priceLabel.Font = Enum.Font.GothamBold
        --     priceLabel.TextSize = 18
        --     priceLabel.TextColor3 = Color3.fromRGB(255, 170, 0)
        --     priceLabel.Parent = itemFrame
        -- end;
        local descriptionLabel = Instance.new("TextLabel")
        descriptionLabel.Size = UDim2.new(1, -140, 0, 40)
        descriptionLabel.Position = UDim2.new(0, 100, 0, 40)
        descriptionLabel.BackgroundTransparency = 1
        descriptionLabel.Text = description
        descriptionLabel.Font = Enum.Font.Gotham
        descriptionLabel.TextSize = 14
        descriptionLabel.TextWrapped = true
        descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
        descriptionLabel.Parent = itemFrame
        
        local buyButton = Instance.new("TextButton")
        buyButton.Size = UDim2.new(0, 80, 0, 30)
        buyButton.Position = UDim2.new(1, -90, 0, 35)
        buyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        buyButton.Text = "เลือก"
        buyButton.Font = Enum.Font.GothamBold
        buyButton.TextSize = 18
        buyButton.Parent = itemFrame
        
        buyButton.MouseButton1Click:Connect(function()
            CreateList(itemName,imageId)
        end)

        shopUI.List[itemName] = imageId
    end

    function shopUI.LoadDefault()
        for i,v in next, Settings[default] do 
            local imageId = shopUI.List[v]
            if imageId then 
                CreateList(v,imageId)
            end;
        end;
    end;

    return shopUI;
end;

return Library;







