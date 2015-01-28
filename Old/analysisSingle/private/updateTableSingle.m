%updateTableSingle.m

%function to update the table values and plots in the gui

%ASM 6/21/12

function updateTableSingle(procData,tableInfo,guiObjects)
    
    %update table    
    set(guiObjects.table,'Data',cat(1,datestr(procData.sessionTimeVector,'HH:MM:SS'),num2cell(tableInfo.data)));
    set(guiObjects.table,'RowName',tableInfo.rowNames);
    set(guiObjects.table,'ColumnName',tableInfo.colNames);
    set(guiObjects.table,'ColumnWidth',{150});
 
end