#include <Timer.h>
#include "../../NodeA/src/Nodes.h"
#include "printf.h"

module NodeAC{
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as TimerProbe;
	uses interface Timer<TMilli> as TimerData;
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
implementation {
	bool busy = FALSE;
	message_t pkt;
 
	uint8_t probeCounter;
 
	uint8_t statRCounter = 0;
	uint8_t statSCounter = 0;
	uint16_t lqiCalculationCounter = 0; 
	static statTuple receivedStats[1000];
	static statTuple sentStats[1000];
 
	int dest = NODE_B_ADDR;
 
	event void Boot.booted() {
		call AMControl.start();
	}
 
	event void AMControl.startDone(error_t err){
		if(err == SUCCESS) {
			call TimerProbe.startPeriodic(SEND_PROBE_INTER_MS);
			call TimerData.startPeriodic(SEND_DATA_INTER_MS);
		}
		else
		{
			call AMControl.start();
		}
	}
 
	event void AMControl.stopDone(error_t err) {}
 
	event void TimerProbe.fired() {
		if (!busy)
		{
			NodeAProbeMsg* btrpkt = (NodeAProbeMsg*)(call Packet.getPayload(&pkt, sizeof (NodeAProbeMsg)));
			btrpkt->SeqCounter = probeCounter++;
			call CC2420Packet.setPower(&pkt, 1);
			call packAck.requestAck(&pkt);
			if(call ProbeSnd.send(dest, &pkt, sizeof (NodeAProbeMsg)) == SUCCESS)
			{
				call Leds.led0Toggle();
			}
			else
			{
				call Leds.led1Toggle();
			}
			busy = TRUE;
		}
	}
 
	event void ProbeSnd.sendDone(message_t* msg, error_t error) {
 
		if (call packAck.wasAcked(msg)) {
			sentStats[statSCounter++].rssi = call CC2420Packet.getRssi(msg);
			sentStats[statSCounter++].lqi = call CC2420Packet.getLqi(msg);
			printf("LQI: %u\nRSSI: %d\n\n", call CC2420Packet.getLqi(msg), call CC2420Packet.getRssi(msg));
			printfflush();
			
		}
		busy = FALSE;
	}

	event void TimerData.fired(){
		if (!busy) {
			NodeADataMsg* dataMsg = (NodeADataMsg*) (call Packet.getPayload(&pkt, sizeof (NodeADataMsg)));
			dataMsg->lo = 12;
			dataMsg->hi = 12;
			call CC2420Packet.setPower(&pkt, 1);
			call packAck.requestAck(&pkt);
			if(call DataSnd.send(dest, &pkt, sizeof (NodeADataMsg)) == SUCCESS)
			{
				call Leds.led2Toggle();
				
			}
			else
			{
				call Leds.led1Toggle();
			}
			busy = TRUE;
		}
		
	}

	event message_t * ProbeRcv.receive(message_t *msg, void *payload, uint8_t len){
		receivedStats[statRCounter++].rssi = call CC2420Packet.getRssi(msg);
		receivedStats[statRCounter++].lqi = call CC2420Packet.getLqi(msg);
		return msg;
	}

	event void DataSnd.sendDone(message_t *msg, error_t error){
 
		if (call packAck.wasAcked(msg)) {
			call Leds.led1Toggle();
			sentStats[statSCounter++].rssi = call CC2420Packet.getRssi(msg);
			sentStats[statSCounter++].lqi = call CC2420Packet.getLqi(msg);
		}
		busy = FALSE;
	}

	event message_t * DataRcv.receive(message_t *msg, void *payload, uint8_t len){
		return msg;
	}
}
