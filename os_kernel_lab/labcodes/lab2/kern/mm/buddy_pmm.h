#include <pmm.h>

#define MAX_BUDDY_ORDER 14
#define MAX_BUDDY_NUM 20
/* buddy system 的结构体 */

extern const struct pmm_manager buddy_pmm_manager;

typedef struct {
    unsigned int max_order;                           // 伙伴二叉树的层数
    list_entry_t free_array[MAX_BUDDY_ORDER + 1];     // 链表数组(现在默认有14层，即2^14 = 16384个可分配物理页)，每个数组元素都一个free_list头
    unsigned int nr_free;                              // 伙伴系统中剩余的空闲页总数
    unsigned int ppm_head_count;                           
} free_buddy_t;

typedef struct{
    ppn_t first_ppn;
    int order;
}PPN_head;