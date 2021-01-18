OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

MEMORY
{
    ram : ORIGIN = 0x402f0400, LENGTH = 0x1B400
}


SECTIONS
{
    .bss : { *(.bss) } > ram
    .text : { *(.text) } > ram
}