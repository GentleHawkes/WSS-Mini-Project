#include <Timer.h>
#include "../../NodeA/src/Nodes.h"
configuration NodeCAppC{
}
implementation{
  components MainC;
  components LedsC;
  components NodeCC as App;
  components ActiveMessageC;
  components new AMReceiverC(AM_PROBE) as AMReceiverProbe;
  components new AMReceiverC(AM_DATA) as AMReceiverData;
  
  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.AMControl -> ActiveMessageC;
  App.ProbeRcv -> AMReceiverProbe;
  App.DataRcv -> AMReceiverData;
  }