# WSS-Mini-Project

In order to write the LQI values to a file execute the following command:

```java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:telosb > rssiLqiStats.txt```

#### Location of the PrintfClient.java
  support/sdk/java/net/tinyos/tools/

#### Use Printf in the project
  java net.tinyos.tools.PrintfClient -comm serial@/dev/ttyUSB0:telosb
  
##### Mounting the folder on your VM
mount -t vboxsf WSS-Mini-Project /mnt/  <br />
*Note that sharename might be different for you
