/* kaiser_mapping.h */
#define ID_RADIO    16
#define ID_BUTTON_A 20

#define RADIO_BASE  0x40001000  /* This is the magic address from the PDF */
#define GPIO_BASE   0x50000000  /* This is also from the PDF */

int interrupt_handler(int irq_num){
    return 0;
}