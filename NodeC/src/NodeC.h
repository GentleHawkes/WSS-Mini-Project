#ifndef NODE_A_H
#define NODE_A_H
enum {
   AM_PROBE_RCV = 6,
   AM_DATA_RCV = 7
   
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
