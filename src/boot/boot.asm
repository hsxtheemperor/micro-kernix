/* boot/boot.asm */

.syntax unified
.cpu cortex-m4
.thumb

.section .vector_table, "a"
.align 2

/* ========================================================================== */
/*                   ARM CORTEX-M4 CORE SYSTEM EXCEPTIONS                     */
/* ========================================================================== */
.word 0x20020000            ; 0: Initial Stack Pointer
.word start_handler         ; 1: Reset Vector (Execution Starts Here)
.word nmi_handler           ; 2: Non-Maskable Interrupt
.word hard_fault            ; 3: HardFault Handler
.word mem_manage            ; 4: Memory Management Fault
.word bus_fault             ; 5: Bus Fault
.word usage_fault           ; 6: Usage Fault
.word 0                     ; 7: Reserved
.word 0                     ; 8: Reserved
.word 0                     ; 9: Reserved
.word 0                     ; 10: Reserved
.word svc_handler           ; 11: SVCall (System Call gateway)
.word debug_mon             ; 12: Debug Monitor
.word 0                     ; 13: Reserved
.word pendsv_handler        ; 14: PendSV (Context switching helper)
.word sys_tick              ; 15: SysTick Timer (OS Tick)

/* ========================================================================== */
/*                   nRF52833 PERIPHERAL INTERRUPT VECTORS                     */
/* ========================================================================== */
.word power_clock_irq       ; 16 (IRQ 0): Power and Clock Control
.word radio_irq             ; 17 (IRQ 1): 2.4 GHz Radio
.word uarte0_uart0_irq      ; 18 (IRQ 2): UART / UARTE 0 (Your Serial Line!)
.word twim0_twis0_irq   ; 19 (IRQ 3): I2C / TWI 0
.word spim0_spis0_irq       ; 20 (IRQ 4): SPI 0
.word 0                     ; 21 (IRQ 5): Reserved
.word gpiote_irq            ; 22 (IRQ 6): GPIO Tasks and Events
.word saadc_irq             ; 23 (IRQ 7): Analog to Digital Converter
.word timer0_irq            ; 24 (IRQ 8): Timer 0
.word timer1_irq            ; 25 (IRQ 9): Timer 1
.word timer2_irq            ; 26 (IRQ 10): Timer 2
.word rtc0_irq              ; 27 (IRQ 11): Real-Time Counter 0
.word temp_irq              ; 28 (IRQ 12): Die Temperature Sensor
.word rng_irq               ; 29 (IRQ 13): Random Number Generator
.word ecb_irq               ; 30 (IRQ 14): AES Electronic Codebook Encryption
.word ccm_aar_irq           ; 31 (IRQ 15): AES CCM Mode / Address Resolution
.word wdt_irq               ; 32 (IRQ 16): Watchdog Timer
.word rtc1_irq              ; 33 (IRQ 17): Real-Time Counter 1
.word qdec_irq              ; 34 (IRQ 18): Quadrature Decoder
.word comp_lpcomp_irq       ; 35 (IRQ 19): Analog Comparator
.word swi0_egu0_irq         ; 36 (IRQ 20): Software Interrupt / Event Gen Unit 0
.word swi1_egu1_irq         ; 37 (IRQ 21): Software Interrupt / Event Gen Unit 1
.word swi2_egu2_irq         ; 38 (IRQ 22): Software Interrupt / Event Gen Unit 2
.word swi3_egu3_irq         ; 39 (IRQ 23): Software Interrupt / Event Gen Unit 3
.word swi4_egu4_irq         ; 40 (IRQ 24): Software Interrupt / Event Gen Unit 4
.word swi5_egu5_irq         ; 41 (IRQ 25): Software Interrupt / Event Gen Unit 5
.word timer3_irq            ; 42 (IRQ 26): Timer 3
.word timer4_irq            ; 43 (IRQ 27): Timer 4
.word pwm0_irq              ; 44 (IRQ 28): Pulse Width Modulation 0
.word pdm_irq               ; 45 (IRQ 29): Pulse Density Modulation (Microphone)
.word 0                     ; 46 (IRQ 30): Reserved
.word 0                     ; 47 (IRQ 31): Reserved
.word mwu_irq               ; 48 (IRQ 32): Memory Watch Unit
.word pwm1_irq              ; 49 (IRQ 33): Pulse Width Modulation 1
.word pwm2_irq              ; 50 (IRQ 34): Pulse Width Modulation 2
.word spi3_irq              ; 51 (IRQ 35): SPI 3
.word rtc2_irq              ; 52 (IRQ 36): Real-Time Counter 2
.word i2s_irq               ; 53 (IRQ 37): Inter-IC Sound
.word fpu_irq               ; 54 (IRQ 38): Floating Point Unit Fault
.word usbd_irq              ; 55 (IRQ 39): USB Device Controller


/* ========================================================================== */
/*           ARM CORTEX-M4 SYSTEM CONTROL BLOCK (SCB) FAULT REGISTERS         */
/* ========================================================================== */

; System Handler Control and State Register (Enables individual faults)
.equ SCB_SHCSR,     0xE000ED24  

.section text
.global start_handler
.global _exit

/* ========================================================================== */
/*           ARM CORTEX-M4 SYSTEM CONTROL BLOCK (SCB) EXECUTION START         */
/* ========================================================================== */

/* START HANDLER */
.thumb_func
start_handler:
    ; To enable separate fault tracking in your reset handler:
    LDR r0, =SCB_SHCSR             ; Address of SCB->SHCSR
    LDR r1, [r0]
    ORR r1, r1, #0x00070000        ; Set bits 16 (USGFAULTENA), 17 (BUSFAULTENA), 18 (MEMFAULTENA)
    STR r1, [r0]

    /* Add Other Enables */

    B _kernel                      ; BYE BOOT PROCESS!


/* ========================================================================== */
/*           ARM CORTEX-M4 SYSTEM CONTROL BLOCK (SCB) EXIT LOOP               */
/* ========================================================================== */

/* EXIT METHOD */
_exit:
    B _exit