MEMORY
{
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 512K
    RAM  (rwx) : ORIGIN = 0x20000000, LENGTH = 128K
}

/* Dynamic Top of RAM for Initial Main Stack Pointer (MSP) */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    /* 1. ARM Vector Table (Must sit at 0x00000000 in FLASH) */
    .vector_table :
    {
        . = ALIGN(4);
        KEEP(*(.vector_table))
        . = ALIGN(4);
    } > FLASH

    /* 2. Executable Code */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        . = ALIGN(4);
    } > FLASH

    /* 3. Read-Only Data (Constants, _mkprintf strings) */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    /* 4. Initialized Data (Stored in FLASH, copied to RAM on boot) */
    _sidata = LOADADDR(.data);
    .data :
    {
        . = ALIGN(4);
        _sdata = .;        /* Start of .data in RAM */
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;        /* End of .data in RAM */
    } > RAM AT > FLASH

    /* 5. Zero-Initialized Data (RAM only) */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;        /* Start of .bss */
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;        /* End of .bss */
    } > RAM

    /* 
     * KERNEL MEMORY BOUNDARY 
     * _ekernel marks the absolute end of static kernel RAM allocation.
     * Your _mkpidtable array begins dynamically right here!
     */
    . = ALIGN(4);
    _ekernel = .;
}