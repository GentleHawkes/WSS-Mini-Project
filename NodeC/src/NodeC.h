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
typedef nx_struct NodeProbeMsg {
  nx_uint16_t nodeid;
  nx_uint16_t SeqCounter;
} NodeProbeMsg;

typedef nx_struct NodeDataMsg{
  nx_uint16_t nodeid;
  nx_uint16_t SeqCounter;
} NodeDataMsg;

#endif /* NODE_A_H */
