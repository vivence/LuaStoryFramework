
local MAIN_THREAD_NAME = '_main'

-------------- private interface -------------->
local story_stack = GStack.new()
local function _storyPush(story)
	story_stack:push(story)
end
local function _storyPop()
	return story_stack:pop()
end
local function _storyPeek()
	return story_stack:peek()
end

local function _storyProc(story, ...)
	story:_run(...)
end
-------------- private interface --------------<

------ static function ----->
function Ghost.getCurrentStory()
	return _storyPeek()
end
------ static function ----->


GStory = Ghost.class("GStory")

local MODE_NORMAL = 'normal'
local MODE_RESTORE = 'restore'
local MODE_CLOSE = 'close'

-- info = {
-- 	NAME = '',
-- 	VERSION = '',
-- 	proc = function(data)
		
-- 	end
-- }

-- data is GData
function GStory:ctor(info, data)
	gassert(nil ~= info, 'info is nil')
	gassert(nil ~= data, 'data is nil')

	data:setStory(self)

	self.mode = MODE_NORMAL

	self.info = info
	self.data = data

	self.thread_map = {}
	self.thread_name_stack = GStack.new()

	self.running = false
	self:_loadThread(MAIN_THREAD_NAME)
end

function GStory:isModeNormal()
	return MODE_NORMAL == self.mode
end
function GStory:setModeNormal()
	self.mode = MODE_NORMAL
	-- self:debugLog('set mode normal')
end

function GStory:isModeRestore()
	return MODE_RESTORE == self.mode
end
function GStory:setModeRestore()
	self.mode = MODE_RESTORE
	-- self:debugLog('set mode restore')
end

function GStory:isModeClose()
	return MODE_CLOSE == self.mode
end
function GStory:setModeClose()
	self.mode = MODE_CLOSE
	-- self:debugLog('set mode close')
end

function GStory:awake(...)
	return self:_awakeThread(MAIN_THREAD_NAME, ...)
end

function GStory:sleep(...)
	return self:_sleepThread(MAIN_THREAD_NAME, ...)
end

function GStory:awakeThread(name, ...)
	return self:_awakeThread(name, ...)
end

function GStory:sleepThread(name, ...)
	return self:_awakeThread(name, ...)
end

function GStory:getCurrentThreadName()
	return self.thread_name_stack:peek()
end

function GStory:getDataProxy()
	return self.data:getProxy()
end

function GStory:recordAPICall()
	local data = self.data
	data:historyEnd()
	data:historyBegin()
end

function GStory:debugLog(str)
	local info = self.info
	gprint(string.format('[%s, %s]<%s, mode-%s>: %s', 
		info.NAME,
		info.VERSION,
		self.thread_name_stack:peek(),
		self.mode,
		str))
end

-------------- private interface -------------->
function GStory:_run()
	self.running = true
	self.data:historyBegin()
	local data_proxy = self.data:getProxy()
	self.info.proc(data_proxy)
	self.data:historyEnd()
	self.running = false
end


function GStory:_loadThread(name)
	local t = self.thread_map[name]
	if nil ==  t then
		t = coroutine.create(_storyProc)
		self.thread_map[name] = t
	end
	return t
end

function GStory:_awakeThread(name, ...)
	local t = self.thread_map[name]
	gassert(nil ~= t, 'thread is not loaded')

	self.thread_name_stack:push(name)

	_storyPush(self)

	self:debugLog('awake')
	if self.running then
		return coroutine.resume(t, ...)
	else
		return coroutine.resume(t, self, ...)
	end
end

function GStory:_sleepThread(name, ...)
	self:debugLog('sleep')

	local test_story = _storyPeek()
	gassert(test_story == self, 'sleep story is not current story')

	_storyPop()

	local test_name = self.thread_name_stack:peek()
	gassert(test_name == name, 'sleep thread is not current thread')
	
	self.thread_name_stack:pop()
	return coroutine.yield(...)
end
-------------- private interface --------------<



