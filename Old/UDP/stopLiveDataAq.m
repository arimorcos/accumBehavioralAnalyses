%function stopLiveDataAq.m

%function to stop live data acquisition from ViRMen engine on another
%computer

function stopLiveDataAq(src,evnt)
    global shouldAcquire;   
    global udpID;
    
    shouldAcquire = false;
    fclose(udpID);
    
    display('Data Acquisition Stopped');
    
end