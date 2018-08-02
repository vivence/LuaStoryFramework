-- print('require GStoryManager')

------ private function ----->

local function _createContext( story, data )
	local context = {
		_story = story,
		_co_name = '',
		_closed=false,
		_sub_proc_map={},
	}

	local mt = {}

	function context:debugLog( str )
		print(string.format('[%s,%s,%s] %s', 
			self._story.NAME, 
			self._story.VERSION, 
			self._co_name,
			str))
	end

	function context:init( k,v )
		if self:isClosed() then
			return
		end

		local old_v = rawget(mt, k)
		if nil == old_v then
			rawset(mt, k, v)
		end
	end

	function context:close()
		self._closed = true
	end

	function context:isClosed()
		return self._closed
	end

	function context:getCoName()
		return self._co_name
	end

	if nil ~= data then
		-- load
		for k,v in pairs(data) do
			mt[k] = v
		end
	end

	mt.__index = mt
	mt.__newindex = function ( t,k,new_v )
		if t:isClosed() then
			return
		end

		local old_v = rawget(mt, k)
		gassert(nil ~= old_v, "data is not inited")
		if old_v ~= new_v then
			rawset(mt, k, new_v)
			t:debugLog(string.format('<set data> %s: %s --> %s', 
				tostring(k), tostring(old_v), tostring(new_v)))
			Ghost._apiStoryContextDirtyProc(context)
		end
	end

	setmetatable(context, mt)

	return context
end

local MAIN_CO_NAME = '_main'
local coroutine_map = {}
local story_map = {}

local function _storyProc( context )
	-- 1. run
	context._story.proc(context)
	-- 2. close context(ignore set data, ignore api call)
	context:close()
	-- 3. awake all sub co, finish them
	local co_map = coroutine_map[context]
	co_map[MAIN_CO_NAME] = nil
	for name, co in pairs(co_map) do
		coroutine.resume(co, context)
		co_map[name] = nil
	end

	coroutine_map[context] = nil
end

local function _storySubProc( context )
	-- 1. run
	local proc = context._sub_proc_map[context:getCoName()]
	proc(context)
	
	local co_map = coroutine_map[context]
	co_map[context:getCoName()] = nil
end

------ private function -----<

-------------- public interface -------------->

function Ghost.registerStory( story )
	story_versions = story_map[story.NAME]
	if nil == story_versions then
		story_versions = {}
		story_map[story.NAME] = story_versions
	end
	story_versions[story.VERSION] = story
end

function Ghost.loadStory( name, version, data )
	gassert(nil ~= story_map[name], 'story is not registered')
	gassert(nil ~= story_map[name][version], 'story version is not registered')
	local story = story_map[name][version]
	local context = _createContext(story, data)

	local co_map = coroutine_map[context]
	if nil == co_map then
		co_map = {}
		coroutine_map[context] = co_map
	end
	local co = co_map[MAIN_CO_NAME]
	if nil == co then
		co = coroutine.create(_storyProc)
		co_map[MAIN_CO_NAME] = co
	end

	return context
end

function Ghost.loadSubStory( context, name, proc )
	local co_map = coroutine_map[context]
	gassert(nil ~= co_map, 'story is not loaded')
	gassert(MAIN_CO_NAME ~= name, 'sub story name is invalid')
	
	context:debugLog('load sub story: '..name)

	local co = co_map[name]
	if nil == co then
		co = coroutine.create(_storySubProc)
		co_map[name] = co
	end

	context._sub_proc_map[name] = proc
end

function Ghost.awakeStory( context, name, ... )
	if nil == name or '' == name then
		name = MAIN_CO_NAME
	end

	context:debugLog('awake story: '..name)

	local co_map = coroutine_map[context]
	gassert(nil ~= co_map, 'story is not loaded')
	local co = co_map[name]
	gassert(nil ~= co, 'story is not loaded')

	local prev_co_name = context._co_name
	context._co_name = name

	context:debugLog('coroutine: '..prev_co_name..' --> '..name)

	Ghost.cur_context = context
	local ret1,ret2,ret3,ret4,ret5 = coroutine.resume(co, context, ...)
	Ghost.cur_context = context

	context:debugLog('coroutine: '..name..' --> '..prev_co_name)

	context._co_name = prev_co_name

	return ret1,ret2,ret3,ret4,ret5
end

function Ghost.sleepStory( context, ... )
	gassert(Ghost.cur_context == context, 'context is not current context')
	Ghost.cur_context = nil

	context:debugLog('coroutine sleep')

	return coroutine.yield(...)
end

function Ghost.getStoryStatus( context )
	local co_map = coroutine_map[context]
	gassert(nil ~= co_map, 'story is not loaded')
	local co = co_map[MAIN_CO_NAME]
	return coroutine.status(co)
end

-------------- public interface --------------<



