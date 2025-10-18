local CORRECT_KEY = "adminuser" -- la key/contraseña esperada
local KEY_URL = "https://www.blogger.com/u/1/blog/post/edit/8306916689349056671/6157746686628981759"

local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local starterGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HubSeguro"
screenGui.ResetOnSpawn = false
screenGui.Parent = starterGui

-- Marco principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.4, -110)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Hub Seguro (Ejemplo educativo)"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Cerrado"
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 16
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Botones
local function makeButton(name, text, y)
	local b = Instance.new("TextButton")
	b.Name = name
	b.Size = UDim2.new(0, 300, 0, 36)
	b.Position = UDim2.new(0, 25, 0, y)
	b.Text = text
	b.Font = Enum.Font.SourceSansSemibold
	b.TextSize = 18
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.BorderSizePixel = 0
	b.Parent = mainFrame
	return b
end

local enterBtn = makeButton("EnterButton", "Entrar (introducir contraseña)", 85)
local getKeyBtn = makeButton("GetKeyButton", "Conseguir la key", 130)
local openBtn = makeButton("OpenButton", "Abrir", 175)

-- Modal para introducir contraseña
local modal = Instance.new("Frame")
modal.Name = "Modal"
modal.Size = UDim2.new(0, 300, 0, 140)
modal.Position = UDim2.new(0.5, -150, 0.5, -70)
modal.AnchorPoint = Vector2.new(0.5, 0.5)
modal.BackgroundColor3 = Color3.fromRGB(30,30,30)
modal.BorderSizePixel = 0
modal.Visible = false
modal.Parent = screenGui

local popTitle = Instance.new("TextLabel")
popTitle.Size = UDim2.new(1, 0, 0, 30)
popTitle.Position = UDim2.new(0, 0, 0, 8)
popTitle.BackgroundTransparency = 1
popTitle.Text = "Introduce la contraseña"
popTitle.Font = Enum.Font.SourceSansBold
popTitle.TextSize = 16
popTitle.TextColor3 = Color3.fromRGB(255,255,255)
popTitle.Parent = modal

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0, 260, 0, 36)
inputBox.Position = UDim2.new(0, 20, 0, 45)
inputBox.PlaceholderText = "Escribe la contraseña aquí..."
inputBox.Font = Enum.Font.SourceSans
inputBox.TextSize = 16
inputBox.Text = ""
inputBox.Parent = modal

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0, 120, 0, 32)
submitBtn.Position = UDim2.new(0, 30, 0, 90)
submitBtn.Text = "Enviar"
submitBtn.Font = Enum.Font.SourceSansSemibold
submitBtn.TextSize = 16
submitBtn.Parent = modal

local cancelBtn = Instance.new("TextButton")
cancelBtn.Size = UDim2.new(0, 120, 0, 32)
cancelBtn.Position = UDim2.new(0, 150, 0, 90)
cancelBtn.Text = "Cancelar"
cancelBtn.Font = Enum.Font.SourceSansSemibold
cancelBtn.TextSize = 16
cancelBtn.Parent = modal

-- Popup para mostrar la URL (fallback) y permitir copia manual
local urlPopup = Instance.new("Frame")
urlPopup.Name = "UrlPopup"
urlPopup.Size = UDim2.new(0, 380, 0, 160)
urlPopup.Position = UDim2.new(0.5, -190, 0.45, -80)
urlPopup.AnchorPoint = Vector2.new(0.5, 0.5)
urlPopup.BackgroundColor3 = Color3.fromRGB(30,30,30)
urlPopup.BorderSizePixel = 0
urlPopup.Visible = false
urlPopup.Parent = screenGui

local urlTitle = Instance.new("TextLabel")
urlTitle.Size = UDim2.new(1, -20, 0, 28)
urlTitle.Position = UDim2.new(0, 10, 0, 8)
urlTitle.BackgroundTransparency = 1
urlTitle.Text = "No se pudo abrir automáticamente. Copia la URL y ábrela en tu navegador:"
urlTitle.Font = Enum.Font.SourceSans
urlTitle.TextSize = 14
urlTitle.TextColor3 = Color3.fromRGB(255,255,255)
urlTitle.TextWrapped = true
urlTitle.Parent = urlPopup

local urlBox = Instance.new("TextBox")
urlBox.Size = UDim2.new(1, -40, 0, 40)
urlBox.Position = UDim2.new(0, 20, 0, 48)
urlBox.Text = KEY_URL
urlBox.ClearTextOnFocus = false
urlBox.TextEditable = true -- permite seleccionar y copiar en algunos clientes
urlBox.Font = Enum.Font.SourceSans
urlBox.TextSize = 16
urlBox.TextColor3 = Color3.fromRGB(220,220,220)
urlBox.Parent = urlPopup

local closeUrlBtn = Instance.new("TextButton")
closeUrlBtn.Size = UDim2.new(0, 140, 0, 32)
closeUrlBtn.Position = UDim2.new(0.5, -70, 1, -40)
closeUrlBtn.Text = "Cerrar"
closeUrlBtn.Font = Enum.Font.SourceSansSemibold
closeUrlBtn.TextSize = 16
closeUrlBtn.Parent = urlPopup

-- Estado desbloqueado
local unlocked = false

local function showModal(show)
	modal.Visible = show
	if show then
		inputBox.Text = ""
		inputBox:CaptureFocus()
	else
		-- intentar liberar foco
		pcall(function() UserInputService.MouseIconEnabled = UserInputService.MouseIconEnabled end)
	end
end

local function showUrlPopup(show)
	urlPopup.Visible = show
	if show then
		-- aseguramos que el textbox tenga la URL
		urlBox.Text = KEY_URL
	end
end

-- Acciones de botones
enterBtn.Activated:Connect(function()
	showModal(true)
end)

-- Aquí está la parte que pediste: intentar abrir la URL; si falla, mostrar popup con la URL para copiar.
getKeyBtn.Activated:Connect(function()
	-- Intento de abrir la URL en un navegador integrado
	local ok, err = pcall(function()
		-- OpenBrowserWindow puede fallar/estar restringido según plataforma/cliente.
		if GuiService and GuiService.OpenBrowserWindow then
			GuiService:OpenBrowserWindow(KEY_URL)
		else
			error("OpenBrowserWindow no disponible")
		end
	end)

	if ok then
		-- si se abrió correctamente, informar brevemente al usuario
		statusLabel.Text = "Estado: Se intentó abrir la página en el navegador."
		-- mostrar mensaje temporal
		local notice = Instance.new("TextLabel")
		notice.Size = UDim2.new(0, 300, 0, 36)
		notice.Position = UDim2.new(0.5, -150, 0.15, 0)
		notice.AnchorPoint = Vector2.new(0.5, 0)
		notice.BackgroundTransparency = 0.3
		notice.BackgroundColor3 = Color3.fromRGB(40, 90, 160)
		notice.Text = "Se abrió la página (si tu cliente lo permite)."
		notice.Font = Enum.Font.SourceSansBold
		notice.TextSize = 16
		notice.TextColor3 = Color3.fromRGB(255,255,255)
		notice.Parent = screenGui
		delay(2.5, function()
			if notice and notice.Parent then notice:Destroy() end
		end)
	else
		-- fallback: mostrar la URL para copiar manualmente
		statusLabel.Text = "Estado: No se pudo abrir automáticamente — copia la URL."
		showUrlPopup(true)
	end
end)

openBtn.Activated:Connect(function()
	if unlocked then
		statusLabel.Text = "Estado: Abierto ✅"
		local openedNotice = Instance.new("TextLabel")
		openedNotice.Size = UDim2.new(0, 300, 0, 40)
		openedNotice.Position = UDim2.new(0.5, -150, 0.15, 0)
		openedNotice.AnchorPoint = Vector2.new(0.5, 0)
		openedNotice.BackgroundTransparency = 0.3
		openedNotice.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
		openedNotice.Text = "¡Se abrió correctamente!"
		openedNotice.Font = Enum.Font.SourceSansBold
		openedNotice.TextSize = 18
		openedNotice.TextColor3 = Color3.fromRGB(255,255,255)
		openedNotice.Parent = screenGui
		delay(2.5, function() 
			if openedNotice and openedNotice.Parent then openedNotice:Destroy() end
		end)
	else
		statusLabel.Text = "Estado: Cerrado (contraseña requerida)"
		local original = mainFrame.BackgroundColor3
		mainFrame.BackgroundColor3 = Color3.fromRGB(100,20,20)
		delay(0.3, function() mainFrame.BackgroundColor3 = original end)
	end
end)

-- Modal: enviar / cancelar
submitBtn.Activated:Connect(function()
	local attempt = inputBox.Text or ""
	if attempt == CORRECT_KEY then
		unlocked = true
		statusLabel.Text = "Estado: Desbloqueado (puedes abrir)"
		showModal(false)
	else
		unlocked = false
		statusLabel.Text = "Estado: Incorrecto — intenta de nuevo"
		inputBox.Text = ""
		inputBox.PlaceholderText = "Contraseña incorrecta..."
	end
end)

cancelBtn.Activated:Connect(function()
	showModal(false)
end)

closeUrlBtn.Activated:Connect(function()
	showUrlPopup(false)
end)

-- Mensaje inicial
statusLabel.Text = "Estado: Cerrado"
