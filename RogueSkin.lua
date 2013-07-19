local blue = loveframes.skins.available.Blue

local skin = {}

skin.controls = loveframes.util.Copy(blue.controls)
skin.OnRegister = blue.OnRegister

skin.name = 'Rogue'
skin.author = 'Ross Andrews'
skin.version = '1.0'
skin.directory = 'loveframes/skins/Blue'

skin.controls.frame_name_font = GameFont
skin.controls.button_text_font = GameFont
skin.controls.imagebutton_text_font = GameFont
skin.controls.progressbar_text_font = GameFont
skin.controls.tab_text_font = GameFont
skin.controls.multichoice_text_font = GameFont
skin.controls.multichoicerow_text_font = GameFont
skin.controls.checkbox_text_font = GameFont
skin.controls.columnlistheader_text_font = GameFont

local bg = {46, 40, 49, 255}
skin.controls.panel_body_color = bg
skin.controls.tabpanel_body_color = bg

loveframes.skins.Register(skin)

loveframes.config.ACTIVESKIN = 'Orange'