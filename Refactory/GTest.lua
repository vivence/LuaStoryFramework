
require('GHeader')
require('math')
require('io')

local sleep_map = {}
local function _sleep(seconds)
	local str = sleep_map[seconds]
	if nil == str then
		str = 'sleep '..seconds
		sleep_map[seconds] = str
	end
	os.execute(str)
end

local input = {4, 2, 2, 2, 1}
local input_opt = 1

local function _tick( frame )
	-- print(string.format('frame: %d', frame))

	Ghost.signal('waitOneFrame')
	Ghost.signal('waitCondition')

	if 10 > math.random(1,100) then
		local n = math.floor(math.random(1,3))
		Ghost.signal('waitKill', n)
	end

	local waitInput = Ghost.getAPI('waitInput')
	if nil ~= waitInput then
		local options = waitInput:getOptions()
		if nil ~= options and 0 < #options then
			if 10 > math.random(1,100) then
				local opt = input[input_opt]
				input_opt = input_opt+1
				gprint('input: '..opt)
				Ghost.signal('waitInput', opt)
			end
		end
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
	until not story.running
	story_data:historyPrint()

	gdebug('----data---->')
	local data_proxy = story_data:getProxy()
	for k,v in pairs(data_proxy) do
		gdebug(string.format('%s = %s',tostring(k),tostring(v)))
	end
	gdebug('----data----<')
end

_run()


script = {
	[0] = "action_杀3个怪",
	[1] = "action_yyy"
}
step = 0
function on_sign(sig)
	do_script(scrip, sig)
end

-- 把script翻译成一个函数列表
function do_script(script,sig)
	for i=step, #script do
		local sig = do_step(script, 0)
		if nil ~= sig then
			step = i
			return sig
		end
	end
end

function do_step(script, index)
	return script[index]()
end




