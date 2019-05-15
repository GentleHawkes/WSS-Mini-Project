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
	uint8_t packetCounter;
 
	uint8_t statRCounter = 0;
	uint8_t statSCounter = 0;
	uint16_t lqiCalculationCounter = 0; 
	static statTuple receivedStats[40];
	static statTuple sentStats[40];
	
	int LQE_B=0;
	int LQE_C=0;
	
 
	int dest = NODE_B_ADDR;
 
 	int calcLQE(int startI, int endI) {
 		int sumLqi;
 		int sumRssi;
 		for (startI; startI < endI; startI++) {
 			sumLqi += sentStats[startI].lqi;
 			sumRssi += sentStats[startI].rssi;
 			
 		}
 		printf("Mean_RSSI: %d\nmeanLQI_C: %d\n\n", sumRssi/10,sumLqi/10);
				printfflush();
 		return (sumLqi/10)/100 *((sumRssi/10)/60 + 100/60);
 	}
 	
	event void Boot.booted() {
		call AMControl.start();
	}
 
	event void AMControl.startDone(error_t err){
		if(err == SUCCESS) {
			call TimerProbe.startPeriodic(SEND_PROBE_INTER_MS);
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
			if (probeCounter == 10) {
				dest = NODE_C_ADDR;
			} else if(probeCounter == 0) {
				dest = NODE_B_ADDR;
			}
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
			sentStats[statSCounter].rssi = call CC2420Packet.getRssi(msg) - 45;
			sentStats[statSCounter++].lqi = call CC2420Packet.getLqi(msg);
			//printf("LQI: %u\nRSSI: %d\n\n", call CC2420Packet.getLqi(msg), call CC2420Packet.getRssi(msg) - 45);
			//printfflush();
		} else {
			sentStats[statSCounter].rssi = -92;
			sentStats[statSCounter++].lqi = 66;
		}
		if (probeCounter == 20) {
				probeCounter = 0;
				//call TimerProbe.stop();
	
				LQE_B = calcLQE(0, 10);
				LQE_C = calcLQE(10, 20);
				printf("LQE_B: %d\nLQE_C: %d\n\n", LQE_B,LQE_C);
				printfflush();
				statSCounter=0;
				//call TimerData.startPeriodic(SEND_DATA_INTER_MS);
				
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
		receivedStats[statRCounter].rssi = call CC2420Packet.getRssi(msg) - 45;
		receivedStats[statRCounter++].lqi = call CC2420Packet.getLqi(msg);
		return msg;
	}

	event void DataSnd.sendDone(message_t *msg, error_t error){
 
		if (call packAck.wasAcked(msg)) {
			call Leds.led1Toggle();
		}
		busy = FALSE;
	}

	event message_t * DataRcv.receive(message_t *msg, void *payload, uint8_t len){
		return msg;
	}
}