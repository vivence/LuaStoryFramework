GAPIPostParallel = Ghost.class("GAPIPostParallel", GAPIPost)

function GAPIPostParallel:ctor()
	GAPIPostParallel.super.ctor(self)
end

------ virtual function ----->
function GAPIPostParallel:_doCall( context, name, proc )
	Ghost.loadSubStory(context, name, proc)
	Ghost.awakeStory(context, name)
end
------ virtual function -----<