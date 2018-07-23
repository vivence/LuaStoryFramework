-- print('require GStoryManager')

------ private function ----->

local coroutine_map = {}

local function _createContext( user_id, story_id, stoy, data )
	local context = {_switch = stoy}

	local mt = {
		user_id = user_id, 
		story_id = story_id
	}

	function context:init( k,v )
		local old_v = rawget(mt, k)
		if nil == old_v then
			rawset(mt, k, v)
		end
	end

	if nil ~= data then
		-- load
		for k,v in pairs(data) do
			mt[k] = v
		end
	else
		-- init
		mt.version = stoy.VERSION
		mt._step = 1
	end

	mt.__index = mt
	mt.__newindex = function ( t,k,new_v )
		local old_v = rawget(mt, k)
		gassert(nil ~= old_v, "data is not inited")
		if old_v ~= new_v then
			rawset(mt, k, new_v)
			Ghost.apiStoryContextDirtyProc(context)
		end
	end

	setmetatable(context, mt)

	return context
end

local function _loadContext( user_id, story_id, stoy )
	return _createContext(
		user_id, 
		story_id, 
		stoy, 
		Ghost.apiLoadStoryContextData(user_id, story_id))
end

local function _rollbackContext( context, rollback_step, rollback_search )
	Ghost.apiRollbackStoryContextData( 
		context.user_id, 
		context.story_id, 
		rollback_step, 
		rollback_search )
end

local function _storyProc( context )
	local switch = context._switch
	gassert(nil ~= switch, 'no steps')

	local step = context._step
	repeat
		gassert(#switch >= step, 'invalid step')
		-- wait one frame
		Ghost.apiWait('ONE_FRAME', context)

		local next_step, rollback_search = switch[step](context)
		next_step = next_step or 0
		rollback_search = rollback_search or 0
		if 0 ~= rollback_search then
			_rollbackContext(context, step, rollback_search)
		end

		context._step = next_step
		step = context._step
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

function Ghost.loadStory( user_id, story_id, stoy )
	local context = _loadContext( user_id, story_id, stoy )
	
	-- check version
	if context.version ~= stoy.VERSION then
		-- rollback invalid steps
		local step = context._step
		local invalid_steps = stoy.INVALID_STEPS
		for i_step, opt in pairs(invalid_steps) do
			if step == i_step then
				-- invalid step, do rollback
				_rollbackContext(context, opt.rollback_step, opt.rollback_search)
				break
			end
		end
	end

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