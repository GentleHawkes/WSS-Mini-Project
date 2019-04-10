#include <Timer.h>
#include "NodeB.h"
module NodeBC{
  uses interface Boot;
  uses interface Leds;
  //uses interface Timer<TMilli> as TimerProbe;
  uses interface Timer<TMilli> as TimerData;
  uses interface Timer<TMilli> as TimeOutLED1;
  uses interface Timer<TMilli> as TimeOutLED2;
  uses interface Packet;
  uses interface AMPacket as AMPack;
  uses interface AMSend as ProbeSnd;
  uses interface Receive as ProbeRcv;
  uses interface AMSend as DataSnd;
  uses interface Receive as DataRcv;
  uses interface SplitControl as AMControl;
  uses interface CC2420Packet as radioPack;
  uses interface PacketAcknowledgements as packAck;
}
implementation{
  bool busy = FALSE;
  message_t pkt;
  
  int dest = NODE_C_ADDR; //Node C address
  
  event void Boot.booted() {
    call AMControl.start();
  }
  
  event void AMControl.startDone(error_t err){
  	if(err == SUCCESS) {
  		call TimerData.startPeriodic(TIMER_PERIOD_MILLI);
  		}
  		else
  		{
  			call AMControl.start();
  		}
  	}
  
  event void AMControl.stopDone(error_t err){
  	}
  
  /*event void TimerProbe.fired() {
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
  	*/
   
  event void ProbeSnd.sendDone(message_t* msg, error_t error) {
    
  }

	event void TimerData.fired(){
		// TODO Auto-generated method stub
	}

	event void TimeOutLED1.fired(){
		// TODO Auto-generated method stub
		call Leds.led1Off();
	}

	event void TimeOutLED2.fired(){
		// TODO Auto-generated method stub
		call Leds.led2Off();
	}

	event message_t * ProbeRcv.receive(message_t *msg, void *payload, uint8_t len){
		// TODO Auto-generated method stub
		
		return msg;
	}

	event void DataSnd.sendDone(message_t *msg, error_t error){
		// TODO Auto-generated method stub
		
    if(call packAck.wasAcked(msg))
    {
    	call Leds.led1On();	
    	call TimeOutLED1.startOneShot(LED_TIMEOUT_MS);
    }
    busy = FALSE;
	}

	event message_t * DataRcv.receive(message_t *msg, void *payload, uint8_t len){
		// TODO Auto-generated method stub
			call Leds.led0Toggle();
			call radioPack.setPower(msg,TRANSMITTING_POWER);
			call packAck.requestAck(msg);
			if(call DataSnd.send(dest, msg, sizeof (NodeAProbeMsg)) == SUCCESS)
    		{
    			call Leds.led2On();
    			call TimeOutLED2.startOneShot(LED_TIMEOUT_MS);
    			busy = TRUE;
			}
		
		
		
		return msg;
	}
}