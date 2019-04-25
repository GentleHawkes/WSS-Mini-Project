#ifndef NODE_A_H
#define NODE_A_H
enum {
	SEND_PROBE_INTER_MS = 2000,
	SEND_DATA_INTER_MS = 1050,
	
	TIMER_PERIOD_MILLI = 250,
   	DATA_TIMEOUT_MS = 100,
   	PROBE_TIMEOUT_MS = 750,
   	LED_TIMEOUT_MS = 100,
	
	AM_PROBE = 219,
   	AM_DATA = 169,
   	
   	TRANSMITTING_POWER = 1
};


enum {
	NODE_A_ADDR = 690,
	NODE_B_ADDR = 691,
	NODE_C_ADDR = 692
};

typedef nx_struct NodeAProbeMsg {
	nx_uint16_t SeqCounter;
} NodeAProbeMsg;

typedef nx_struct {
	nx_uint64_t lo, hi; 
} NodeADataMsg;

typedef struct {
	uint8_t rssi;
	uint8_t lqi;
} statTuple;


#endif /* NODE_A_H */
