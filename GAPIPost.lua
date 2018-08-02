
GAPIPost = Ghost.class("GAPIPost", GAPI)

function GAPIPost:ctor( func )
	GAPIPost.super.ctor(self)
	self.func = func
end

------ override function ----->
function GAPIPost:call( context, ... )
	return self:_doCall(context, ...)
end
------ override function -----<

------ virtual function ----->
function GAPIPost:_doCall( context, ... )
	return self.func(context, ...)
end
------ virtual function -----<