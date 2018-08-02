
------ private function ----->

local function _apiPostPrint( context, str )
	return context:debugLog(str)
end

------ private function -----<

-------------- public interface -------------->

local apiEnum = {
	PRINT = GAPIPost.new(_apiPostPrint),
	PARALLEL = GAPIPostParallel.new(),
	ONE_FRAME = GAPIWait.new('one_frame'),
	CONDITION = GAPIWaitCondition.new('condition'),
	TEST = GAPIWaitTest.new('test'),
}

function Ghost.apiCall(enum, ...)
	local context = Ghost.cur_context
	if context:isClosed() then
		return
	end

	local api = apiEnum[enum]
	gassert(nil ~= api, 'invalid api enum')
	-- TODO context._call_num, api check status(alive?dead?)
	return api:call(context, ...)
end

function Ghost.getAPI( enum )
	return apiEnum[enum]
end

-------------- public interface --------------<