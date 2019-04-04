#include <Timer.h>
#include "NodeA.h"
module NodeAC{
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as TimerProbe;
  uses interface Timer<TMilli> as TimerData;
  uses interface Timer<TMilli> as TimeOutData;
  uses interface Timer<TMilli> as TimeOutProbe;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend as ProbeSnd;
  uses interface Receive as ProbeRcv;
  uses interface AMSend as DataSnd;
  uses interface Receive as DataRcv;
  uses interface SplitControl as AMControl;
  
  uses interface CC2420Packet;
  uses interface PacketAcknowledgements as packAck;
}
implementation{
  uint16_t BPropeCounter = 0;
  uint16_t CPropeCounter = 0;
  bool busy = FALSE;
  message_t pkt;
  
  int dest = NODE_A_ADDR; //Node C address
  
  event void Boot.booted() {
    call AMControl.start();
  }
  
  event void AMControl.startDone(error_t err){
  	if(err == SUCCESS) {
  		call TimerProbe.startPeriodic(TIMER_PERIOD_MILLI);
  		}
  		else
  		{
  			call AMControl.start();
  		}
  	}
  
  event void AMControl.stopDone(error_t err){
  	}
  
  event void TimerProbe.fired() {
    if(!busy)
    {
    	
    	NodeAProbeMsg *btrpkt = (NodeAProbeMsg*)(call Packet.getPayload(&pkt, sizeof (NodeAProbeMsg)));
    	btrpkt->nodeid = TOS_NODE_ID;
    	/*
    	if(dest == 2){
    		dest = NODE_C_ADDR;
    		btrpkt->SeqCounter = CPropeCounter++;
    	}
    	else{
    		dest = NODE_B_ADDR;
    		btrpkt->SeqCounter = BPropeCounter++;
    	}
    	*/
    	call packAck.requestAck(&pkt);
    	if(call ProbeSnd.send(dest, &pkt, sizeof (NodeAProbeMsg)) == SUCCESS)
    	{
    	call Leds.led0Toggle();
    	busy = TRUE;
    	}
    	else
    	{
    		call Leds.led2Toggle();
    	}
    		
    }
  }
   
  event void ProbeSnd.sendDone(message_t* msg, error_t error) {
    call TimeOutProbe.startOneShot(PROBE_TIMEOUT_MS);
    if(call packAck.wasAcked(&pkt))
    {
    	NodeAProbeMsg* btrpkt = (NodeAProbeMsg*)(call Packet.getPayload(&pkt, sizeof (NodeAProbeMsg)));
    	btrpkt->nodeid = TOS_NODE_ID;
    	call Leds.led1Toggle();	
    }
    busy = FALSE;
  }

	event void TimerData.fired(){
		// TODO Auto-generated method stub
	}

	event void TimeOutData.fired(){
		// TODO Auto-generated method stub
	}

	event void TimeOutProbe.fired(){
		// TODO Auto-generated method stub
	}

	event message_t * ProbeRcv.receive(message_t *msg, void *payload, uint8_t len){
		// TODO Auto-generated method stub
		call Leds.led2Toggle();
		return msg;
	}

	event void DataSnd.sendDone(message_t *msg, error_t error){
		// TODO Auto-generated method stub
	}

	event message_t * DataRcv.receive(message_t *msg, void *payload, uint8_t len){
		// TODO Auto-generated method stub
		
		return msg;
	}
}