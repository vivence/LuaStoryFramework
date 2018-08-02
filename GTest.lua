
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
	Ghost.getAPI('ONE_FRAME'):signal()
	Ghost.getAPI('CONDITION'):signal()
	if 10 > math.random(1,100) then
		local n = math.floor(math.random(1,3))
		Ghost.getAPI('TEST'):signal(n)
	end
end

local sample_story = require('GSampleStory')

local function _run(  )
	Ghost.registerStory(sample_story)

	-- load user task story
	local story_context = Ghost.loadStory(sample_story.NAME, sample_story.VERSION)
	Ghost.awakeStory( story_context )

	local frame = 0
	repeat
		_sleep(0.2)
		frame = frame+1
		_tick(frame)
	until false
end

_run()

