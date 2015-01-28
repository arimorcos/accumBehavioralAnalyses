%receiveLiveData.m

function receiveLiveDataStandalone(remoteIP, remotePort, localPort, id)
   global udpID;
   
   remotePort = num2str(remotePort);
   localPort = num2str(localPort);
   id = num2str(id);
   
   udpID = udp(remoteIP, remotePort,'LocalPort',localPort);
   
   udpReceiveLiveDataGUI(id);

end
