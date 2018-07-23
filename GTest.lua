
require('GHeader')
require('GSample')
require('math')

local sleep_map = {
	
}
local function _sleep(seconds)
	local str = sleep_map[seconds]
	if nil == str then
		str = 'sleep '..seconds
		sleep_map[seconds] = str
	end
	os.execute(str)
end

local function _tick( frame )
	print(string.format('frame: %d', frame))
	GSingalMap['ONE_FRAME']:signal()
	if 10 > math.random(1,100) then
		GSingalMap['TEST']:signal()
	end
end

local function _run(  )
	-- load user task story
	local story_context = Ghost.loadStory( 1, 1, GSampleXXXX )
	Ghost.awakeStory( story_context )

	local frame = 0
	repeat
		_sleep(0.2)
		frame = frame+1
		_tick(frame)
	until false
end

_run()