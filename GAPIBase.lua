
------ private function ----->


------ private function -----<

-------------- public interface -------------->

function Ghost.apiBuildStoryID( context )
	gprint(string.format('apiBuildStoryID: uid=%s, sid=%s', 
		tostring(context.user_id),
		tostring(context.story_id)))
	-- TODO return a unique id
	return 1 
end

function Ghost.apiStoryContextDirtyProc( context )
	gprint(string.format('apiContextDirtyProc: uid=%s, sid=%s', 
		tostring(context.user_id),
		tostring(context.story_id)))
	-- TODO 
	-- put context into dirty table? 
	-- save it immediately? ...?
end

-- return a table with data(key-value)
function Ghost.apiLoadStoryContextData( user_id, story_id )
	gprint(string.format('apiLoadContextData: uid=%s, sid=%s', 
		tostring(user_id),
		tostring(story_id)))
	local data = nil-- TODO load data(cache? datebase?)
	if nil == data then
		-- TODO save as initialization(cache? datebase?)
	end
	return nil
end

-------------- public interface --------------<