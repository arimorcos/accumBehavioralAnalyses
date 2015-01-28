%receiveLiveData.m

function receiveLiveData(remoteIP, remotePort, localPort, id)
   global udpID;
    
   udpID = udp(remoteIP, remotePort,'LocalPort',localPort);
   
   udpReceiveLiveDataGUI(id);

end
