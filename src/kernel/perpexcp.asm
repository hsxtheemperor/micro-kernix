/* kernel/perpexcep.asm */
.syntax unified
.cpu cortex-m4
.thumb

; nRF52833 UARTE0 Memory Mapped IO Offsets
.equ UARTE0_BASE,         0x40002000
.equ UARTE_INTENCLR,      0x40002308
.equ UARTE_EVENTS_RXDRDY, 0x40002108  ; Event: New data received

.section .text
.global uarte0_uart0_irq
.global power_clock_irq
.global radio_irq
.global twim0_twis0_irq
.global spim0_spis0_irq
.global gpiote_irq
.global saadc_irq
.global timer0_irq

/* SERIAL LINE INTERRUPT HANDLER */
.thumb_func
uarte0_uart0_irq:
    PUSH {r4, lr}
    LDR r0, =UARTE0_BASE
    
    ; Check if RX Data Ready Event generated the interrupt
    LDR r1, [r0, #0x108]         ; Offset of EVENTS_RXDRDY
    CMP r1, #1
    BNE irq_exit
    
    ; Clear the hardware event register (Crucial: prevents immediate re-triggering)
    MOV r2, #0
    STR r2, [r0, #0x108]
    
    ; Kernel-side ring buffer injection or processing goes here

irq_exit:
    POP {r4, pc}

/* UNHANDLED EXCEPTION TRAPS */
.thumb_func
power_clock_irq:
.thumb_func
radio_irq:
.thumb_func
twim0_twis0_irq:
.thumb_func
spim0_spis0_irq:
.thumb_func
gpiote_irq:
.thumb_func
saadc_irq:
.thumb_func
timer0_irq:
    B .                          ; Infinite loop trap for unhandled drivers