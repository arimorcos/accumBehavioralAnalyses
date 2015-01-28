%receiveLiveData.m
   global udpID;
   
   udpID = udp('10.11.149.172',49152,'LocalPort',135);
   
   udpReceiveLiveDataGUI(1);
