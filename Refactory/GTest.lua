
require('GHeader')
require('math')

local sleep_map = {}
local function _sleep(seconds)
	local str = sleep_map[seconds]
	if nil == str then
		str = 'sleep '..seconds
		sleep_map[seconds] = str
	end
	os.execute(str)
end

local function _tick( frame )
	-- print(string.format('frame: %d', frame))

	Ghost.getAPI('waitOneFrame'):signal()
	-- Ghost.getAPI('waitCondition'):signal()

	if 10 > math.random(1,100) then
		local n = math.floor(math.random(1,3))
		Ghost.getAPI('waitKill'):signal(n)
	end
end

local story_info = require('GSampleStory')

local function _run()
	-- 1.
	Ghost.registerAPIAll()
	-- 2.
	local story_data = GData.new()
	local story = GStory.new(story_info, story_data)
	story:setModeNormal()
	story:awake()

	-- 3.
	local frame = 0
	repeat
		_sleep(0.2)
		frame = frame+1
		_tick(frame)
	until false
end

_run()