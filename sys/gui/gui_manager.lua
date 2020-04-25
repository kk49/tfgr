function onInit()
	Debug.console("manager_gui: onInit")
    Interface.onWindowOpened = onWindowOpened_handle
    Interface.onWindowClosed = onWindowClosed_handle
end

function onWindowOpened_handle(wi)
    Debug.console('onWindowOpenedHandler', wi)
end

function onWindowClosed_handle(wi)
    Debug.console('onWindowClosedHandler', wi)
end

function onInit_handle(obj)
     Debug.console(obj.getClass() .. '.onInit', obj)
    if 'windowinstance' == type(obj) then
        doLayout(obj)
    end

    onLockStateChanged_handle(obj)
end

function onFirstLayout_handle(obj)
    Debug.console(obj.getClass() .. '.onFirstLayout', obj)
    if 'windowinstance' == type(obj) then
        doAdjustLayout(obj)
    end
end

function onLockStateChanged_handle(obj)
    if obj and obj.window_resize then
        obj.window_resize.setVisible(not obj.getLockState());
    end
end

-- utils
function controlsList(window)
    controls = window.getControls()
    for k,v in pairs(controls) do
        Debug.console(k,v, v.getName())
    end
end

function doAdjustLayout(win)
    -- do nothing right now
end

function doLayout(win)

    -- find layouts, find controls connected to layouts
    local layouts = {}
    local layout_controls = {}
    local controls = win.getControls()
    for k,v in pairs(controls) do
        --Debug.console(k,v, v.getName(), v._class, v._layout)

        if v._class and v._class[1] then
            local class = v._class[1]
            local name = v.getName()
            local layout = v.layout and v.layout[1]

            if class == 'Layout' then
                layouts[name] = v
            elseif layout and v.isEnabled() then
                cs = layout_controls[layout]
                if not cs then
                    cs = {}
                end
                table.insert(cs, v)
                layout_controls[layout] = cs
            end
        end
    end

    for layout_name, controls in pairs(layout_controls) do
        layout = layouts[layout_name]
        if layout then
            parent = layout.layout
            if parent then
                Core.error('Nested Layouts not handled, yet. Layout %s in window %s is nested in %s', layout_name, win.getClass(), parent)
            else
                if win.getFrame() == 'frame_window' then
                    layout.setAnchor('left', '', 'left', 'absolute', 4)
                    layout.setAnchor('right', '', 'right', 'absolute', -4)
                    layout.setAnchor('top', '', 'top', 'absolute', 20)
                    layout.setAnchor('bottom', '', 'bottom', 'absolute', -4)
                    --layout.setVisible(true)
                    --layout.setFrame('frame_single_pixel')
                else
                    layout.setAnchor('left', '', 'left', 'absolute', 0)
                    layout.setAnchor('right', '', 'right', 'absolute', 0)
                    layout.setAnchor('top', '', 'top', 'absolute', 0)
                    layout.setAnchor('bottom', '', 'bottom', 'absolute', 0)
                end
            end

            params = {}
            --Debug.console('layout', layout)
            --Debug.console('layout.h_spacing ', layout.h_spacing )
            --Debug.console('layout.v_spacing ', layout.v_spacing )
            --Debug.console('layout.h_margin ', layout.h_margin )
            --Debug.console('layout.v_margin ', layout.v_margin )
            --Debug.console('layout.col_widths ', layout.col_widths )

            layout_type = layout.type and layout.type[1]

            if layout.h_spacing then params.h_spacing = tonumber(layout.h_spacing[1]) end
            if layout.v_spacing then params.v_spacing = tonumber(layout.v_spacing[1]) end
            if layout.h_margin then params.h_margin = tonumber(layout.h_margin[1]) end
            if layout.v_margin then params.v_margin = tonumber(layout.v_margin[1]) end
            if layout.col_widths then
                params.col_widths = {}
                for v in string.gmatch(layout.col_widths[1], '([^,]+)') do
                    table.insert(params.col_widths, tonumber(v))
                end
            end

            if layout_type == 'form' then
                layout_form(layout_name, controls, params)
            elseif layout_type == 'horz' or layout_type =='horizontal' then
                layout_horizontal(layout_name, controls, params)
            end

        else
            Core.error('Layout %s does not exist in window %s', layout_name, win.getClass())
        end
    end
end

-- a layout where everything is horizontal
function layout_horizontal(layout, controls, params)
    h_spacing = params.h_spacing or 0
    h_margin = params.h_margin or 0
    v_margin = params.v_margin or 0

    last = nil
    for k,v in ipairs(controls) do
        if last then
            v.setAnchor('left', last.getName(), 'right', 'absolute', h_spacing)
            --last.setAnchor('right', v.getName(), 'left', 'relative')
        else
            v.setAnchor('left', layout, 'left', 'absolute', h_margin)
        end
        last = v
    end

    if last then
        controls[1].setAnchor('left', layout, 'left', 'absolute', h_spacing)
        --last.setAnchor('right', '', 'right', 'relative', -spacing)

        for k,v in ipairs(controls) do
            v.setAnchor('top', layout, 'top', 'relative', v_margin)
            --v.setAnchor('bottom', '', 'bottom', 'relative')
        end
    end
end

--a layout with two columns, the first for labels, the second for values
function layout_form(layout, controls, params)
    h_spacing = params.h_spacing or 0
    v_spacing = params.v_spacing or 0
    h_margin = params.h_margin or 0
    v_margin = params.v_margin or 0
    col_widths = params.col_widths

    cols = {}
    for k,v in ipairs(col_widths) do
        cols[k] = {}
    end

    col_index = 0
    for k,v in ipairs(controls) do
        if v.isVisible() then
            table.insert(cols[col_index + 1], v)
            col_index = (col_index + 1) % #cols
        end
    end

    if #cols > 0 and #cols[1] > 0 then
        for i = 1,#cols do
            for j = 1,#cols[i] do
                if i == 1 then
                    cols[i][j].setAnchor('left', layout, 'left', 'absolute', h_margin)
                else
                    --Debug.console('i-1, j', cols[i][j].getName(), cols[i][j].getValue(), cols[i-1][j].getName(), cols[i-1][j].getValue())
                    cols[i][j].setAnchor('left', cols[i-1][j].getName(), 'right', 'absolute', h_spacing)
                end

                if j == 1 then
                    cols[i][j].setAnchor('top', layout, 'top', 'absolute', v_margin)
                else
                    --Debug.console('i, j-1', cols[i][j].getName(), cols[i][j].getValue(), cols[i][j-1].getName(), cols[i][j-1].getValue())
                    cols[i][j].setAnchor('top', cols[i][j-1].getName(), 'bottom', 'absolute', v_spacing)
                end

                if col_widths[i] > 0 then
                    cols[i][j].setAnchoredWidth(col_widths[i])
                end
            end
        end
    end
end

