#include <Timer.h>
#include "Nodes.h"
configuration NodeAAppC{
}
implementation{
  components MainC;
  components LedsC;
  components NodeAC as App;
  components new TimerMilliC() as Timer0;
  components new TimerMilliC() as Timer1;
  components new TimerMilliC() as Timer2;
  components ActiveMessageC;
  components new AMSenderC(AM_PROBE);
  components new AMReceiverC(AM_PROBE);
  components CC2420PacketC;
  components new AMSenderC(AM_DATA) as DataSnd;
  components new AMReceiverC(AM_DATA) as DataRcv;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.TimerProbe -> Timer0;
  App.TimerData -> Timer1;
  App.WaitTimer -> Timer2;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.ProbeSnd -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.ProbeRcv -> AMReceiverC;
  App.CC2420Packet -> CC2420PacketC;
  App.packAck -> AMSenderC;
  
  App.DataSnd -> DataSnd;
  App.DataRcv -> DataRcv;
}