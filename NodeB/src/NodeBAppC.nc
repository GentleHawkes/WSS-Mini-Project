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
  components new AMSenderC(AM_PROBE) as probSend;
  components new AMReceiverC(AM_PROBE) as probRCV;
  components new AMReceiverC(AM_DATA) as dataRCV;
  components new AMSenderC(AM_DATA) as dataSend;
  components CC2420PacketC;
  components CC2420RadioC as powerController;


  App.Boot -> MainC;
  App.Leds -> LedsC;
  //App.TimerProbe -> Timer0;
  App.TimerData -> Timer1;
  App.TimeOutLED1 -> Timer2;
  App.TimeOutLED2 -> Timer3;
  App.Packet -> dataSend;
  App.AMPack -> dataSend;
  App.ProbeSnd -> probSend;
  App.AMControl -> ActiveMessageC;
  App.ProbeRcv -> probRCV;
  App.packAck -> dataSend;
  App.radioPack -> CC2420PacketC;
  App.DataSnd -> dataSend;
  App.DataRcv ->dataRCV;
  }