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

/* String */
MESSAGE: 
    .asciz "HARSHIT SAHA\r\n"   @ The 'z' automatically appends the '\0' null terminator
.align 2

/* Reset Handler */

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

