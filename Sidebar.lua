Sidebar = class('Sidebar')

function Sidebar:initialize(scene)
    self.scene = scene
    self.state = self.scene.state

    self.panel = loveframes.Create('panel')
    self.panel:SetState(self.state)
    self.panel:SetPos(992, 0)
    self.panel:SetSize(288, 720)

    self.tabs = loveframes.Create('tabs', self.panel)
    self.tabs:SetPos(0, 100)
    self.tabs:SetSize(288, 620)

    self.tabs:AddTab("Inv", self:generic_tab('Inventory'))
    self.tabs:AddTab("Char", self:generic_tab('Character sheet'))
    self.tabs:AddTab("Log", self:generic_tab('Messages'))
    self.tabs:AddTab("Map", self:generic_tab('Dungeon map'))
    self.tabs:AddTab("Skills", self:generic_tab('Skills & spells'))
end

function Sidebar:generic_tab(text)
    local panel = loveframes.Create('panel')
    panel:SetSize(288, 620)

    local label = loveframes.Create('text', panel)
    label:SetText(text)
    label:SetDefaultColor(255, 255, 255, 255)
    label:SetFont(GameFont)
    label:Center()

    return panel
end