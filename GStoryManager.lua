-- print('require GStoryManager')

------ private function ----->

local coroutine_map = {}

local function _createContext( user_id, story_id, steps, data )
	local context = {_switch = steps}

	local mt = {
		user_id = user_id, 
		story_id = story_id
	}

	if nil ~= data then
		-- load
		for k,v in pairs(data) do
			mt[k] = v
		end
	else
		-- init
		mt.step = 1
	end

	mt.__index = mt
	mt.__newindex = function ( t,k,new_v )
		local old_v = rawget(mt, k)
		if old_v ~= new_v then
			rawset(mt, k, new_v)
			Ghost.apiStoryContextDirtyProc(context)
		end
	end

	setmetatable(context, mt)

	return context
end

local function _loadContext( user_id, story_id, steps )
	return _createContext(
		user_id, 
		story_id, 
		steps, 
		Ghost.apiLoadStoryContextData(user_id, story_id))
end

local function _storyProc( context )
	local switch = context._switch
	gassert(nil ~= switch, 'no steps')

	local step = context.step
	repeat
		gassert(#switch >= step, 'invalid step')
		-- wait one frame
		Ghost.apiWait('ONE_FRAME', context)
		switch[step](context)

		step = context.step
	until 0 >= step

	gprint(string.format('sample end: uid=%s, sid=%s', 
			tostring(context.user_id),
			tostring(context.story_id)))
	-- remove coroutine
	coroutine_map[context] = nil
end

------ private function -----<

-------------- public interface -------------->

function Ghost.getStoryStatus( context )
	local co = coroutine_map[context]
	gassert(nil ~= co, 'story is not loaded')
	return coroutine.status(co)
end

function Ghost.loadStory( user_id, story_id, steps )
	local context = _loadContext( user_id, story_id, steps )
	local co = coroutine_map[context]
	if nil == co then
		co = coroutine.create(_storyProc)
		coroutine_map[context] = co
	end
	return context
end

function Ghost.awakeStory( context, ... )
	local co = coroutine_map[context]
	gassert(nil ~= co, 'story is not loaded')
	return coroutine.resume(co, context, ...)
end

function Ghost.sleepStory( context, ... )
	local co = coroutine_map[context]
	gassert(nil ~= co, 'story is not loaded')
	return coroutine.yield(...)
end

-------------- public interface --------------<