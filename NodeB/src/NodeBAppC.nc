#include <Timer.h>
#include "NodeB.h"
configuration NodeBAppC{
}
implementation{
  components MainC;
  components LedsC;
  components NodeBC as App;
  components new TimerMilliC() as Timer0;
  components new TimerMilliC() as Timer1;
  components new TimerMilliC() as Timer2;
  components new TimerMilliC() as Timer3;
  components ActiveMessageC;
  components new AMSenderC(AM_PROBE_SND);
  components new AMReceiverC(AM_PROBE_SND);
  components CC2420PacketC;


  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.TimerProbe -> Timer0;
  App.TimerData -> Timer1;
  App.TimeOutData -> Timer2;
  App.TimeOutProbe -> Timer3;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.ProbeSnd -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.ProbeRcv -> AMReceiverC;
  App.packAck -> AMSenderC;
  App.CC2420Packet -> CC2420PacketC;
  }