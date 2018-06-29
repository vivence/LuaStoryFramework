
------ private function ----->

local waitEnum = GSingalMap

------ private function -----<

-------------- public interface -------------->

function Ghost.apiWait(enum, context, ...)
	local api = waitEnum[enum]
	gassert(nil ~= api, 'invalid wait_enum')
	api:register(context, Ghost.awakeStory, ...)
	return Ghost.sleepStory(context)
end

-------------- public interface --------------<