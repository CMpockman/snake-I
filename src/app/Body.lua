local Body = class("Body")


function Body:ctor(snak,x,y,node,isHead)
    self.snak = snak
    self.X = x
    self.Y = y
    --print(self.X,self.Y)

    if isHead then
    	self.sp = cc.Sprite:create("head.png")
    else
    	self.sp = cc.Sprite:create("body.png")
    end

    node:addChild(self.sp)
    self:Update()
end

function Body:Update()
	local  posx,posy = Grid2Pos(self.X,self.Y)
	self.sp:setPosition(posx,posy)
    --print("Body:Update---",posx,posy)
end

return Body
