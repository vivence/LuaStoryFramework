
------ private function ----->

local function _apiNewStory( context, steps  )
	local new_story_id = Ghost.apiBuildStoryID()
	local new_context = Ghost.loadStory( context.user_id, new_story_id, steps )
	return Ghost.awakeStory( new_context )
end

local function _apiPostPrint( context, str )
	return gprint(string.format('[%s,%s] %s', 
		tostring(context.user_id), 
		tostring(context.story_id), str))
end

local postEnum = {
	NEW_STORY = _apiNewStory,
	PRINT = _apiPostPrint,
}

------ private function -----<

-------------- public interface -------------->

function Ghost.apiPost(enum, context, ...)
	local api = postEnum[enum]
	gassert(nil ~= api, 'invalid post_enum')
	return api(context, ...)
end

-------------- public interface --------------<