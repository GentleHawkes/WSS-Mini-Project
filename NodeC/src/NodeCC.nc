#include <Timer.h>
#include "NodeC.h"
module NodeCC{
  uses interface Boot;
  uses interface Leds;
  uses interface Packet;
  uses interface AMPacket;
  uses interface Receive as ProbeRcv;
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
  		
  		}
  		else
  		{
  			call AMControl.start();
  		}
  	}
  
  event void AMControl.stopDone(error_t err){
  	}

	event message_t * ProbeRcv.receive(message_t *msg, void *payload, uint8_t len){
		// TODO Auto-generated method stub
		//if(len == sizeof(NodeAProbeMsg)){
			call Leds.led1Toggle();
		//NodeProbeMsg* prbptr = (NodeProbeMsg*)payload;
		//prbptr->SeqCounter++;
		//}
		return msg;
	}

	event message_t * DataRcv.receive(message_t *msg, void *payload, uint8_t len){
		// TODO Auto-generated method stub
		//if(len == sizeof(NodeADataMsg)){
			call Leds.led2Toggle();
		//NodeDataMsg *dtaptr = (NodeDataMsg*)payload;
		//}
		return msg;
	}
}