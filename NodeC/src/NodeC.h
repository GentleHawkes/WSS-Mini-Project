#ifndef NODE_A_H
#define NODE_A_H
enum {
   AM_PROBE_RCV = 6,
   AM_DATA_RCV = 7,
   AM_PROBE_ACK = 12,
   AM_DATA_ACK = 14,
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
typedef nx_struct NodeProbeMsg {
  nx_uint16_t nodeid;
  nx_uint16_t SeqCounter;
} NodeProbeMsg;

typedef nx_struct NodeDataMsg{
  nx_uint16_t nodeid;
  nx_uint16_t SeqCounter;
} NodeDataMsg;

#endif /* NODE_A_H */
