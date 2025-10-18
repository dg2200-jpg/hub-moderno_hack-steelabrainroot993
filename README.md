

local Frame = script.Parent
local Boton_Toggle = Frame:FindFirstChild("Boton_Toggle")
local TweenService = game:GetService("TweenService")


local OPEN_SIZE = UDim2.new(0.2, 0, 0.2, 0)       -- Tamaño Abierto (ajusta si quieres un HUD más grande)
local CLOSED_SIZE = UDim2.new(0.05, 0, 0.05, 0)   -- Tamaño Miniatura (pequeño y redondo)


local isOpened = false


local tweenInfo = TweenInfo.new(
    0.3,                                  -- Duración: 0.3 segundos
    Enum.EasingStyle.Quint,               -- Estilo de transición (suave y moderno)
    Enum.EasingDirection.Out
)



local function toggleHUD()
    isOpened = not isOpened
    

end


Boton_Toggle.MouseButton1Click:Connect(toggleHUD)



isOpened = false
Frame.Size = CLOSED_SIZE
Boton_Toggle.Text = "[ + ]"
