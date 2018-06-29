
------ private function ----->

local getEnum = {
}

------ private function -----<

-------------- public interface -------------->

function Ghost.apiGet(enum, context, ...)
	local api = getEnum[enum]
	gassert(nil ~= api, 'invalid get_enum')
	return api(context, ...)
end

-------------- public interface --------------<