local blue = loveframes.skins.available.Blue

local skin = {}

skin.controls = loveframes.util.Copy(blue.controls)

skin.name = 'Rogue'
skin.author = 'Ross Andrews'
skin.version = '1.0'

function skin:OnRegister()
	local images = loveframes.util.GetDirectoryContents("skin")
	self.images = {}

    for k, v in ipairs(images) do
        self.images[v.name .. "." .. v.extension] = love.graphics.newImage(v.fullpath)
    end
end

skin.controls.frame_name_font = GameFont
skin.controls.button_text_font = GameFont
skin.controls.imagebutton_text_font = GameFont
skin.controls.progressbar_text_font = GameFont
skin.controls.tab_text_font = GameFont
skin.controls.multichoice_text_font = GameFont
skin.controls.multichoicerow_text_font = GameFont
skin.controls.checkbox_text_font = GameFont
skin.controls.columnlistheader_text_font = GameFont

local bg = {0x30, 0x30, 0x30, 255}
skin.controls.panel_body_color = bg
skin.controls.tabpanel_body_color = bg

skin.controls.button_text_hover_color = {255, 255, 255, 255}
skin.controls.button_text_nohover_color = {255, 255, 255, 255}

loveframes.skins.Register(skin)

loveframes.config.ACTIVESKIN = 'Rogue'