MEMORY
{
  FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 512K
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 128K
}

SECTIONS
{
  /* The vector table must sit at the absolute start of Flash memory */
  .vector_table :
  {
    . = ALIGN(4);
    KEEP(*(.vector_table))
    . = ALIGN(4);
  } > FLASH

  /* The actual execution code follows right after */
  .text :
  {
    . = ALIGN(4);
    *(.text)
    *(.text*)
    . = ALIGN(4);
  } > FLASH
}