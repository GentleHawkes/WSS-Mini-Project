#ifndef NODE_A_H
#define NODE_A_H
enum {
   AM_PROBE_SND = 6,
   AM_PROBE_ACK = 12,
   TIMER_PERIOD_MILLI = 250,
   SEND_PROBE_INTER_MS = 1000,
   SEND_DATA_INTER_MS = 2000,
   DATA_TIMEOUT_MS = 1000,
   PROBE_TIMEOUT_MS = 750
   
 };

enum {
	NODE_A_ADDR = 1,
	NODE_B_ADDR = 2,
	NODE_C_ADDR = 3
};

typedef nx_struct NodeAProbeMsg {
  nx_uint16_t nodeid;
  nx_uint16_t SeqCounter;
} NodeAProbeMsg;

typedef nx_struct NodeADataMsg{
  
} NodeADataMsg;

typedef struct {
	uint8_t rssi;
	uint8_t lqi;
} statTuple;


#endif /* NODE_A_H */
