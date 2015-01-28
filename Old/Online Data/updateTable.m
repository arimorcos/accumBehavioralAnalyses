%updateTable.m

%function to update the table values and plots in the gui

%ASM 6/13/12

function updateTable(procData,tableInfo,guiObjects)
    
    %update table    
    set(guiObjects.table,'Data',cat(1,{datestr(procData.sessionTimeVector,'HH:MM:SS')...
        datestr(procData.elapTimeLastXVector,'HH:MM:SS')},num2cell(tableInfo.data)));
    set(guiObjects.table,'RowName',tableInfo.rowNames);
    set(guiObjects.table,'ColumnName',tableInfo.colNames);
    set(guiObjects.table,'ColumnWidth',{150 150});
    
    
    
    %This code changes the width of the row names
%         %get the row header
%         jscroll=findjobj(guiObjects.table);
%         rowHeaderViewport=jscroll.getComponent(4);
%         rowHeader=rowHeaderViewport.getComponent(0);
%         height = rowHeader.getSize;
%         rowHeader.setSize(80,360);
% 
%         %resize the row header
%         newWidth = 300; %100 pixels.
%         rowHeaderViewport.setPreferredSize(java.awt.Dimension(newWidth,0));
%         height=rowHeader.getHeight;
%         rowHeader.setPreferredSize(java.awt.Dimension(newWidth,height));
%         rowHeader.setSize(newWidth,height);
%     
    %center text
%         table1 = get(jscroll,'Viewport');
%         jtable = get(table1,'View');
%         renderer = jtable.getCellRenderer(2,2);
%         renderer.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
%         renderer.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
    

end