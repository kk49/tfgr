function classGet()
    return "Object"
end

function classesGet(obj)
    obj = obj or self

    if obj.super and obj.super.classGet then
        tbl = classesGet(obj.super)
        tbl[#tbl+1] = obj.classGet()
        return tbl
    else
        return {obj.classGet()}
    end
end

function classIs(class)
    obj = self
    while obj do
        if obj.classGet and obj.classGet() == class then
            return true
        end
        obj = obj.super
    end
    return false
end

function onInit()
    if super and super.onInit then super.onInit() end
    Debug.console(classGet() .. "::onInit")
end

