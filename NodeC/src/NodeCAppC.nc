#include <Timer.h>
#include "NodeC.h"
configuration NodeCAppC{
}
implementation{
  components MainC;
  components LedsC;
  components NodeCC as App;
  components new TimerMilliC() as Timer0;
  components new TimerMilliC() as Timer1;
  components new TimerMilliC() as Timer2;
  components new TimerMilliC() as Timer3;
  components ActiveMessageC;
  components new AMSenderC(AM_PROBE_SND);
  components new AMReceiverC(AM_PROBE_SND);


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
  }