local snake = class("snake")
local  Body = require("app.Body")

local cInitLen = 9


function snake:ctor(node)
    print("snake:ctor")
    self.BodyArray = {}
    self.node = node

    for i=1, cInitLen  do
        self:Grow(i == 1)
    end
    self:SetDir("left")
    --print("snake:ctor--------",self:moveDir)
end

--取尾巴的位置
function snake:GetTailGrid()
    if #self.BodyArray == 0 then
        return 0,0
    end

    local tail = self.BodyArray[#self.BodyArray]
    return tail.X,tail.Y
end

--取头的位置
function snake:GetHeadGrid()
    if #self.BodyArray == 0 then
        return 0,0
    end

    local head = self.BodyArray[1]
    return head.X,head.Y
end

function snake:Grow(ishead)
    local tailX,tailY = self:GetTailGrid()
    --print("snake-----Grow---",tailX,tailY)
    local body = Body.new(self,tailX,tailY,self.node,ishead)

    table.insert(self.BodyArray,body)
end

function snake:OffsetGridByDir( x,y,dir )
    --print("OffsetGridByDir----",dir)
    local scalRate = 1 / display.contentScaleFactor
    local cGridSize = 33 * scalRate
    local visibleSize = cc.Director:getInstance():getVisibleSize()
    local leftBorder = -visibleSize.width / 2 / cGridSize
    local rightBorder = visibleSize.width / 2 / cGridSize
    local topBorder = visibleSize.height / 2 / cGridSize
    local bottomBorder = -visibleSize.height / 2 / cGridSize
    local X,Y = x,y
    
    if dir == "left" then 
        X = x - 1
        if X < leftBorder then
           X = rightBorder
        end
    elseif dir == "right" then
        X = x + 1
        if X > rightBorder then
            X = leftBorder
        end
    elseif dir == "up" then
        Y = y + 1
        if Y > topBorder then
            Y = bottomBorder
        end
    elseif dir == "down" then
        Y = y - 1
        if Y < bottomBorder then
            Y = topBorder
        end
    end
    return X,Y
end

function snake:SetDir( dir )
    --防止180度转弯
    local  table =  {
    ["left"] = "h",
    ["right"] = "h",
    ["up"] = "v",
    ["down"] = "v",
    }
    if table[dir] == table[self.moveDir] then
        return
    end

    self.moveDir = dir

    --扭转蛇头方向
    local tableHead = {
    ["left"] = 180,
    ["right"] = 0,
    ["up"] = -90,
    ["down"] = 90,
    }
    local  head = self.BodyArray[1]
    head.sp:setRotation(tableHead[dir])

    
end

function snake:Update(isHead)
    if #self.BodyArray == 0 then
        return
    end 

    for i=#self.BodyArray,1,-1 do
        local  body = self.BodyArray[i]

        if i == 1 then
            body.X,body.Y = self:OffsetGridByDir(body.X,body.Y,self.moveDir)
        else 

            local front  = self.BodyArray[i - 1]
            body.X,body.Y = front.X,front.Y
        end
        body:Update()
    end 
end

--判断是否咬住蛇身
function snake:CheckSelfCollide()   
    if #self.BodyArray < 2 then
        return false
    end
    local  headX,headY = self:GetHeadGrid()
    for i=2,#self.BodyArray do
        local body = self.BodyArray[i]
        if body.X == headX and body.Y == headY then
            return true
        end
    end
    return false
end

function snake:Kill()
    for  _,body in ipairs(self.BodyArray) do
        self.node:removeChild(body.sp)
    end
end

function snake:Blink(callBack)
    for index,body in ipairs(self.BodyArray) do
        local  blink = cc.Blink:create(3,5)

        if index == 1 then
            local  a = cc.Sequence:create(blink,cc.CallFunc:create(callBack))
            body.sp:runAction(a)    
        else
            body.sp:runAction(blink)
        end
        
    end
end


return snake

