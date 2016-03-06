
local cGridSize = 33
local scalRate = 1 / display.contentScaleFactor

--格子数转为像素点的位置
function Grid2Pos(x,y)
	local visibleSize = cc.Director:getInstance():getVisibleSize()
	local origin = cc.Director:getInstance():getVisibleOrigin()
	local finalX = origin.x + visibleSize.width/2 + x * cGridSize * scalRate
	local finalY = origin.y + visibleSize.height/2 + y * cGridSize * scalRate
	return finalX,finalY
end

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)


local cMoveSpeed = 0.3
local cBound = 7

local Snake = require("app.snake")
local AppleFactory = require("app.AppleFactory")

function MainScene:onEnter()

	self:Reset()

	self:ProcessInput()

	local  tick = function()
		if self.stage == "running" then
			self.snake:Update()

			local headX,headY = self.snake:GetHeadGrid()

			if self.snake:CheckSelfCollide() then

					self.stage = "dead"
					self.snake:Blink(function()
						self:Reset()
					end)
					--self:Reset()
					print("CheckSelfCollide")
			end

			if self.AppleFactory:CheckCollide(headX,headY) then 
				self.AppleFactory:Generate()
				self.snake:Grow()
			end
		end

	end
	--调度器，每0.3秒调用一次tick函数
	cc.Director:getInstance():getScheduler():scheduleScriptFunc(tick,cMoveSpeed,false)
	
end

function MainScene:Reset()
	if self.snake ~= nil then
		self.snake:Kill()
	end

	if self.AppleFactory ~=nil then
		self.AppleFactory:Reset()
	end

	self.snake = Snake.new(self)
	self.AppleFactory = AppleFactory.new(cBound,self)
	self.stage = "running"
	
end


local function vector2Dir(x,y)
	local dir = "down"
	if math.abs(x) > math.abs(y) then
		if x < 0 then
			dir = "left"
		else 
			dir = "right"
		end
	else 
		if y > 0 then
			dir = "up"
		else 
			dir = "down"
		end
	end
	--print("vector2Dir--:",dir)
	return dir
end 

function  MainScene:ProcessInput()
	local function  onTouchBegan(touch,envent)
		local location = touch:getLocation()
		local visibleSize = cc.Director:getInstance():getVisibleSize()
		local origin = cc.Director:getInstance():getVisibleOrigin()

		local finalX = location.x - (origin.x + visibleSize.width/2)
		local finalY = location.y - (origin.y + visibleSize.height/2)
		--print("finalX,finalY",finalX,finalY)
		local dir = vector2Dir(finalX,finalY)
		self.snake:SetDir(dir)
	end 
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
	local eventDispatcher = self:getEventDispatcher()
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end

return MainScene
