#include <Timer.h>
#include "../../NodeA/src/Nodes.h"
#include "printf.h"
#include "math.h"

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
 
	uint8_t probeCounter = 0;
	uint8_t dataPacketCounter = 0;

	uint8_t statSCounter = 0;
	
	statTuple sentStats[20];
	
	int LQE_B = 0;
	int LQE_C = 0;
	
	int dest = NODE_B_ADDR;
 
 	double calcLQE(int startI, int endI) {
 		double sumLqi = 0;
 		double sumRssi = 0;
 		double constant = 1.66;
 		for (; startI < endI; startI++) {
 			sumLqi += sentStats[startI].lqi;
 			sumRssi += sentStats[startI].rssi;
 		}
 		printf("Mean_RSSI: %F\nMeanLQI: %F\n\n", sumRssi/10, sumLqi/10);
		printfflush();
 		return (sumLqi/10) * ((sumRssi/10)/60 + constant);
 	}
 	
 	void setDestination() {
 			if (LQE_B - LQE_C >= 10 && LQE_B != 0) {
 				dest = NODE_B_ADDR;
 			} else if (LQE_B - LQE_C < 10 && LQE_C != 0){
 				dest = NODE_C_ADDR;
 			} else {
 				dest = 0;
 			}
 		
 		printf("Current destination: %s\n\n", dest == NODE_B_ADDR ? "Node B" : "Node C");
 		printfflush();
 	}
 	
	event void Boot.booted() {
		call AMControl.start();
	}
 
	event void AMControl.startDone(error_t err){
		if (err == SUCCESS) {
			call TimerProbe.startPeriodic(SEND_PROBE_INTER_MS);
		} else {
			call AMControl.start();
		}
	}
 
	event void AMControl.stopDone(error_t err) {}
 
	event void TimerProbe.fired() {
		if (!busy) {
			NodeAProbeMsg* btrpkt = (NodeAProbeMsg*)(call Packet.getPayload(&pkt, sizeof (NodeAProbeMsg)));
			if (probeCounter == 10) {
				dest = NODE_C_ADDR;
			} else if(probeCounter == 0) {
				dest = NODE_B_ADDR;
			}
			btrpkt->SeqCounter = 10;
			probeCounter++;
			call CC2420Packet.setPower(&pkt, 1);
			call packAck.requestAck(&pkt);
			if (call ProbeSnd.send(dest, &pkt, sizeof (NodeAProbeMsg)) == SUCCESS) {
				call Leds.led0Toggle();
			} else {	
				call Leds.led1Toggle();
			}
			busy = TRUE;
		}
	}
 
	event void ProbeSnd.sendDone(message_t* msg, error_t error) { 
		if (call packAck.wasAcked(msg)) {
			if (statSCounter > 9) {
 				sentStats[statSCounter].rssi = call CC2420Packet.getRssi(msg) - 97;
				//printf("Rssi C: %d\n\n", sentStats[statSCounter].rssi);
 			} else {
 				sentStats[statSCounter].rssi = call CC2420Packet.getRssi(msg) - 45;
 				//printf("Rssi B: %d\n\n", sentStats[statSCounter].rssi);
 			}
 		
			sentStats[statSCounter++].lqi = call CC2420Packet.getLqi(msg);
			//printf("LQI: %u\nRSSI: %d\n\n", call CC2420Packet.getLqi(msg), call CC2420Packet.getRssi(msg) - 45);
			//printfflush();
		} else {
			sentStats[statSCounter].rssi = -100;
			sentStats[statSCounter++].lqi = 66;
		}
		if (probeCounter == 20) {
				probeCounter = 0;
				call TimerProbe.stop();
				LQE_B = (int)calcLQE(0, 10);
				LQE_C = (int)calcLQE(10, 20);
				printf("LQE_B: %d\nLQE_C: %d\n\n", LQE_B, LQE_C);
				printfflush();
				statSCounter = 0;
				setDestination();
				call TimerData.startPeriodic(SEND_DATA_INTER_MS);		
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
				dataPacketCounter++;
				
			}
			else
			{
				call Leds.led1Toggle();
			}
			busy = TRUE;
		}
	}

	event message_t * ProbeRcv.receive(message_t *msg, void *payload, uint8_t len){
		return msg;
	}

	event void DataSnd.sendDone(message_t *msg, error_t error){
 
		if (call packAck.wasAcked(msg)) {
			call Leds.led1Toggle();
		}
		busy = FALSE;
		if (dataPacketCounter == 100) {
			dataPacketCounter = 0;
			call TimerData.stop();
			call TimerProbe.startPeriodic(SEND_PROBE_INTER_MS);
		}
	}

	event message_t * DataRcv.receive(message_t *msg, void *payload, uint8_t len){
		return msg;
	}
}