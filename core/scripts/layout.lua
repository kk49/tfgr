local _layout_type = nil
local _layout_h_spacing = nil
local _layout_v_spacing = nil

function onInit()
    --Debug.console('TypeLayout.onInit')
end

function setup()
    doLayout()
    -- maybe hook into other window events
end

function doLayout()
    Debug.console("TypeLayout.doLayout", window)

    controls = {}
    layout_stack = {}
    for k,v in ipairs(window.getControls()) do

        add_to_stack = true

        if v.getValue and v.getValue() then
            value = v.getValue()
            name = v.getName()
            if value == 'LayoutEnd' then
                add_to_stack = false
                if #layout_stack == 0 then
                    Debug.console("TypeLayout.doLayout: Unbalanced LayoutEnd in ", window.getName())
                else
                    tos = table.remove(layout_stack)
                    --Debug.console("TypeLayout.doLayout: LayoutEnd", tos)
                    tos[2](tos[1], tos[3])
                end
            elseif value == 'LayoutBeginHorizontal' then
                add_to_stack = false
                table.insert(layout_stack, {{}, layout_horizontal, {tonumber(name)}})
            elseif value == 'LayoutBeginForm' then
                add_to_stack = false
                params = {}
                for i in string.gmatch(name, "%S+") do
                    table.insert(params, i)
                end
                --Debug.console("TypeLayout.doLayout: LayoutBeginForm", params)
                table.insert(layout_stack, {{}, layout_form, {tonumber(params[1]), tonumber(params[2])}})
            end
        end

        if add_to_stack and #layout_stack > 0 then
            layout_controls = layout_stack[#layout_stack][1]
            table.insert(layout_controls, v)
        end
    end
end

-- a layout where everything is horizontal
function layout_horizontal(controls, params)
    --Debug.console("TypeLayout.layout_horizontal", window, controls, params)
    spacing = params[1]

    _layout_type = 'horizontal'
    _layout_h_spacing = spacing

    last = nil
    for k,v in ipairs(controls) do
        if last then
            v.setAnchor('left', last.getName(), 'right', 'relative', spacing)
            --last.setAnchor('right', v.getName(), 'left', 'relative')
        end
        last = v
    end

    if last then
        controls[1].setAnchor('left', '', 'left', 'relative', spacing)
        --last.setAnchor('right', '', 'right', 'relative', -spacing)

        for k,v in ipairs(controls) do
            v.setAnchor('top', '', 'top', 'relative')
            --v.setAnchor('bottom', '', 'bottom', 'relative')
        end
    end
end

--a layout with two columns, the first for labels, the second for values
function layout_form(controls, params)
    --Debug.console("TypeLayout.layout_form: window ", window)
    --Debug.console("TypeLayout.layout_form: controls ", controls)
    --Debug.console("TypeLayout.layout_form: params ", params)
    h_spacing = params[1]
    v_spacing = params[2]

    _layout_type = 'form'
    _layout_h_spacing = h_spacing
    _layout_v_spacing = v_spacing

    col1 = {}
    col2 = {}
    isCol1 = true
    for k,v in ipairs(controls) do
        if v.isVisible() then
            if isCol1 then
                table.insert(col1, v)
            else
                table.insert(col2, v)
            end
            isCol1 = not isCol1
        end
    end

    --Debug.console("TypeLayout.layout_form: columns", col1, col2)
    assert(#col1 == #col2)

    -- setup horizontal anchors
    if #col1 > 0 then
        for i = 1,#col1 do
            col1[i].setAnchor('left', '', 'left', 'relative', h_spacing)
            col2[i].setAnchor('left', col1[i].getName(), 'right', 'relative', h_spacing)
        end

        for i = 2,#col1 do
            col1[i].setAnchor('top', col1[i-1].getName(), 'bottom', 'relative', v_spacing)
            col2[i].setAnchor('top', col2[i-1].getName(), 'bottom', 'relative', v_spacing)
        end
        col1[1].setAnchor('top', '', 'top', 'relative', v_spacing)
        col2[1].setAnchor('top', '', 'top', 'relative', v_spacing)
    end
end

--
function onFirstLayout()
    --Debug.console("TypeLayout.onFirstLayout", window,  _layout_type, _layout_h_spacing)
    --Core.controlsList(window)
end