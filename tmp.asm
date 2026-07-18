/* 
   This macro acts as a template. It maps a weak reference from an IRQ name
   to the default hang handler. If you define the name later in your code,
   the compiler will automatically drop the default handler and use yours!
*/
.macro def_irq_handler name
    .weak \name
    .set \name, default_handler
.endm

/* Map all handlers dynamically using the macro */
def_irq_handler nmi_handler
def_irq_handler hard_fault
def_irq_handler mem_manage
def_irq_handler bus_fault
def_irq_handler usage_fault
def_irq_handler svc_handler
def_irq_handler debug_mon
def_irq_handler pendsv_handler
def_irq_handler sys_tick
def_irq_handler power_clock_irq
def_irq_handler radio_irq
def_irq_handler uarte0_uart0_irq
def_irq_handler twim0_twis0_irq
def_irq_handler spim0_spis0_irq
def_irq_handler gpiote_irq
def_irq_handler saadc_irq
def_irq_handler timer0_irq
def_irq_handler timer1_irq
def_irq_handler timer2_irq
def_irq_handler rtc0_irq
def_irq_handler temp_irq
def_irq_handler rng_irq
def_irq_handler ecb_irq
def_irq_handler ccm_aar_irq
def_irq_handler wdt_irq
def_irq_handler rtc1_irq
def_irq_handler qdec_irq
def_irq_handler comp_lpcomp_irq
def_irq_handler swi0_egu0_irq
def_irq_handler swi1_egu1_irq
def_irq_handler swi2_egu2_irq
def_irq_handler swi3_egu3_irq
def_irq_handler swi4_egu4_irq
def_irq_handler swi5_egu5_irq
def_irq_handler timer3_irq
def_irq_handler timer4_irq
def_irq_handler pwm0_irq
def_irq_handler pdm_irq
def_irq_handler mwu_irq
def_irq_handler pwm1_irq
def_irq_handler pwm2_irq
def_irq_handler spi3_irq
def_irq_handler rtc2_irq
def_irq_handler i2s_irq
def_irq_handler fpu_irq
def_irq_handler usbd_irq