#ifndef NODE_A_H
#define NODE_A_H
enum {
	AM_PROBE_SND = 6,
	AM_PROBE_ACK = 12,
	AM_DATA_SND = 7,
	
	SEND_PROBE_INTER_MS = 5000,
	SEND_DATA_INTER_MS = 1000
};

enum {
	NODE_A_ADDR = 691,
	NODE_B_ADDR = 692,
	NODE_C_ADDR = 693
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
