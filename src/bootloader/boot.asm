.syntax unified
.cpu cortex-m4
.thumb

.section .vector_table, "a"
.align 2

/* 1. Initial Stack Pointer */
.word 0x20020000 

/* 2. Reset Vector */
.word reset_handler + 1

.section .text
.global reset_handler

/* Physical Memory Register Addresses from the nRF52833 Datasheet */
.equ UART_BASE,       0x40002000
.equ UART_PSELTXD,    0x4000250C  @ Pin select for Transmit
.equ UART_BAUDRATE,   0x40002524  @ Baud rate configuration
.equ UART_ENABLE,     0x40002500  @ Enable register
.equ UART_STARTTX,    0x40002008  @ Task to start transmitter
.equ UART_TXD,        0x4000251C  @ Transmit data register
.equ UART_TXDRDY,     0x4000211C  @ Event: TX byte sent status
.equ DELAY_COUNT,     5000000     @ Arbitrary delay count for crude timing

MESSAGE: 
    .asciz "HARSHIT"   @ The 'z' automatically appends the '\0' null terminator


reset_handler:
    @ On the micro:bit v2, the interface chip connects to Port 0, Pin 6 for TX data.
    LDR r0, =UART_PSELTXD
    MOV r1, #0x6                   @ Pin 6, Port 0 (Bit 31 = 0 means Connected)
    STR r1, [r0]

    @ The datasheet value for 115200 baud rate is exactly 0x01D7E000
    LDR r0, =UART_BAUDRATE
    LDR r1, =0x01D7E000
    STR r1, [r0]

    LDR r0, =UART_ENABLE
    MOV r1, #0x4                   @ Value 4 explicitly enables standard UART
    STR r1, [r0]

    LDR r0, =UART_STARTTX
    MOV r1, #0x1
    STR r1, [r0]

_main:
    LDR r5, =UART_TXDRDY

    MOV r10, #0x10
    MOV r11, #0x00

    MOV r12, #0x01                  @ EXIT CODE -> 0x01
    BL _loop

print:
    LDRB r1, [r4], #0x1             @ Load byte from MESSAGE and increment pointer
    CMP r1, #0x0                    @ Check for null terminator
    BEQ _loop                       @ If null terminator, exit
    BL print_char                   @ Call print_char to send the character
    BL _poll
    B print                         @ Repeat for next character

print_char:
    LDR r0, =UART_TXD
    STR r1, [r0]
    BX lr

_poll:
    LDR r6, [r5]
    CMP r6, #0x1
    BNE _poll
    MOV r6, #0x0
    STR r6, [r5]
    BX lr

_loop:
    CMP r10, r11
    BEQ _exit

    ADD r11, #0x01
    LDR r4, =MESSAGE
    B print

_exit:
    MOV r12, #0x0                   @ EXIT CODE
    B _exit                         @ Trap the CPU here forever so it doesn't crash!