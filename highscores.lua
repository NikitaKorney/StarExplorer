
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local json = require("json") -- библиотека для работы с данными

local scoresTable = {};

local filePath = system.pathForFile("scores.json",system.DocumentsDirectory)-- создали файл 

local function loadScores() 

	local file = io.open(filePath, "r"); --  открыли файл scores.json "r " говорит, чтоб открыть файл с доступом для чтения ток
	if (file) then
		local contents = file:read("*a"); --  если файл существует, его содержимое сваливается в переменую contents
		io.close(file); -- закрыли файл
		scoresTable = json.decode(contents); -- декодируем contents и сохраняем значение в массив
	end
	if (scoresTable == nil or #scoresTable == 0) then
		scoresTable = {0,0,0,0,0,0,0,0,0,0,};
	end


end

local function saveScores()
	for i = #scoresTable, 11, -1 do  -- пока i <=11 
		table.remove(scoresTable,i)
	end

	local file = io.open(filePath, "w"); -- w - говорит Corona создать (написать) новый файл или перезаписать файл, если он уже существует.

	if (file) then
		file:write(json.encode(scoresTable))
		io.close(file)
	end
end


local function gotoMenu() 
	composer.gotoScene("menu", {time = 800, effect = "crossFade"});
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	 loadScores();
	 table.insert(scoresTable, composer.getVariable("finalScore"));
	 composer.setVariable("finalScore",0);

end

local function compare(a,b)
	return a>b;
end

table.sort(scoresTable, compare);
saveScores();

	local background = display.newImageRect(sceneGroup, "photos/background.png",800,1400)
	background.x = display.contentCenterX;
	background.y = display.contentCenterY;

	local highScoresHeader = display.newText(sceneGroup, "High Scores ", display.contentCenterX,100,native.systemFont,44);
	for i = 1,10 do 
		if(scoresTable[i]) then
			local yPos = 150 + (i*56);

			local runkNum = display.newText(sceneGroup, i .. ")", display.contentCenterX-50,yPos,native.systemFont,36);
			runkNum:setFillColor(0.8);
			rankNum.anchorX = 1;

			local thisScore = display.newText(sceneGroup, scoresTable[i], display.contentCenterX-30,yPos,native.systemFont,36)
			thisScore.anchorX = 0;
			
		end
end

	local menuButton  = display.newText(sceneGroup, "Menu ", display.contentCenterX,810,native.systemFont,44);
	menuButton:setFillColor(0.75,0.78,1);
	menuButton:addEventListener("tap",gotoMenu);

end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene("highscores");

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
