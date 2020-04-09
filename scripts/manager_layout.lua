function horizontal(window, spacing)
    Debug.console("Layout.horizontal", window)
    controls = window.getControls()

    last = nil
    for k,v in ipairs(controls) do
        Debug.console(k,v, v.getName(), string.find(v.getName(),'bttn'))
        --if string.find(v.getName(),'bttn') then
        --    v.setAnchoredWidth(15)
        --    v.setAnchoredHeight(15)
        --end
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

function horizontal_first_layout(window, spacing)
    Debug.console("Layout.horizontal_first_layout", window)
    controls = window.getControls()

    last = nil
    for k,v in ipairs(controls) do
        Debug.console(k,v, v.getName(), string.find(v.getName(),'bttn'))
    end
end