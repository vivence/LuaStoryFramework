
GAPIPost = Ghost.class("GAPIPost", GAPI)

function GAPIPost:ctor( func )
	GAPIPost.super.ctor(self)
	self.func = func
end

------ override function ----->
function GAPIPost:call( story, ... )
	return self:_doCall(story, ...)
end
------ override function -----<

------ virtual function ----->
function GAPIPost:_doCall( story, ... )
	return self.func(story, ...)
end
------ virtual function -----<