
local titleScene = class("titleScene", function()
    return display.newScene("titleScene")
end)

function titleScene:ctor()
	display.newSprite("bg.png")
	    :pos(display.cx,display.cy)
        :addTo(self)
        
    cc.ui.UIPushButton.new({normal = "btn_start.png",pressed = "btn_start.png"})
    :onButtonClicked(function()
    	print("clicked")
    	local s = require("app.scenes.MainScene").new()
    	display.replaceScene(s,"fade",0.6,display.COLOR_BLACK)
    end)
    :pos(display.cx,display.cy - 100)
    :addTo(self)
end

function titleScene:onEnter()
end

function titleScene:onExit()
end

return titleScene
