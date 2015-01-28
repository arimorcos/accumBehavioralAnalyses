%receiveLiveData.m
   global udpID;
   [remoteIP remotePort localPort guiID] = textread('info.txt','%s %d %d %d',1); %#ok<REMFF1>
   
   udpID = udp(remoteIP,remotePort,'LocalPort',localPort);
   
   udpReceiveLiveDataGUI(guiID);
