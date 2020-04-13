local _layout_type = nil
local _layout_h_spacing = nil
local _layout_v_spacing = nil
local _layout_top_spacing = 0
local _layout_right_spacing = 0

--<LayoutBeginHorizontal name="8">
--	<layout>
--		<h_spacing>8</h_spacing>
--	</layout>
--</LayoutBeginHorizontal>


function onInit()
    --Debug.console('TypeLayout.onInit')
end

--
--function onFirstLayout()
--    doAdjustLayout() -- adjust form layout to get labels aligned
--end

function setup()
    doLayout()
end

function printControls()
    for k,v in ipairs(window.getControls()) do
        Debug.console(k, v)
    end
end

function doLayout()
    --Debug.console("TypeLayout.doLayout", window)
    --printControls()

    controls = {}
    layout_stack = {}
    for k,v in ipairs(window.getControls()) do

        add_to_stack = true

        if v._class and v._class[1] then
            value = v._class[1]
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
                    table.insert(params, tonumber(i))
                end
                --Debug.console("TypeLayout.doLayout: LayoutBeginForm", params)
                table.insert(layout_stack, {{}, layout_form, params})
            end
        end

        if add_to_stack and #layout_stack > 0 then
            layout_controls = layout_stack[#layout_stack][1]
            table.insert(layout_controls, v)
        end
    end
end

-- adjust form layout to get labels aligned
function doAdjustLayout()
    --Debug.console("TypeLayout.doAdjustLayoutHandler", window,  _layout_type)
    --printControls()
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
            v.setAnchor('top', '', 'top', 'relative', _layout_top_spacing)
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
    col1_width = params[3]
    col2_width = params[4]

    if col1_width == 0 then
        col1_width = nil
    end

    if col2_width == 0 then
        col2_width = nil
    end

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
            if col1_width then
                col1[i].setAnchoredWidth(col1_width)
            end
            if col2_width then
                col2[i].setAnchoredWidth(col2_width)
            end
        end

        for i = 2,#col1 do
            col1[i].setAnchor('top', col1[i-1].getName(), 'bottom', 'relative', v_spacing)
            col2[i].setAnchor('top', col2[i-1].getName(), 'bottom', 'relative', v_spacing)
        end
        col1[1].setAnchor('top', '', 'top', 'relative', v_spacing)
        col2[1].setAnchor('top', '', 'top', 'relative', v_spacing)
    end
end

