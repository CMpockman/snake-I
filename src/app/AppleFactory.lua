local AppleFactory = class("AppleFactory")



function AppleFactory:ctor(bound,node)
    self.bound = bound
    self.node = node

    math.randomseed(os.time())

    self:Generate()
end

local function getPos( bound )      
    return math.random(-bound,bound)
end

function AppleFactory:Generate()

    if self.appleSpirite ~= nil then
        self.node:removeChild(self.appleSpirite)
    end

    local  sp = cc.Sprite:create( "apple.png" )

    local genBoundLimit = self.bound - 1

    local  x,y = getPos(genBoundLimit),getPos(genBoundLimit)
    local finalX,finalY = Grid2Pos(x,y)

    sp:setPosition(finalX,finalY)
    self.node:addChild(sp)
    self.appleX = x
    self.appleY = y

    self.appleSpirite = sp
end

function  AppleFactory:CheckCollide(x,y)

   -- print(self.appleX,self.appleY,x,y)
    if x == self.appleX and y == self.appleY then
        --print("CheckCollide--ture")
        return true
    else 
        --print("CheckCollide--false")
        return false
    end
end

function AppleFactory:Reset()   
    self.node:removeChild(self.appleSpirite)
end

return AppleFactory

