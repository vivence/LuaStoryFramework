GAPIWaitInput = Ghost.class("GAPIWaitInput", GAPIWait)

function GAPIWaitInput:ctor()
	GAPIWaitInput.super.ctor(self)
end

function GAPIWaitInput:getOptions()
	if 0 < #self.story_infos then
		return self.story_infos[1].options
	end
	return nil
end

------ override function ----->
function GAPIWaitInput:_setArgs( info, options )
	gassert(nil ~= options and 0 < #options, 'options is nil')
	info.options = options
end
------ override function ----->