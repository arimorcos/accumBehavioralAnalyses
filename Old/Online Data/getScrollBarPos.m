%getScrollBarPos.m

%function to get scroll bar location and return variables

function [vscroll vscrollPos] = getScrollBarPos(guiObjects)

    jScrollPane = findjobj(guiObjects.table);
    vscroll = jScrollPane.getVerticalScrollBar();
    vscrollPos = vscroll.getValue();
end