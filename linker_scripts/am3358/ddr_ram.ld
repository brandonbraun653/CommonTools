OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

MEMORY
{
    ram : ORIGIN = 0x10000000, LENGTH = 0x1B400
}

SECTIONS
{
    .bss : { *(.bss) } > ram
    .text : { *(.text) } > ram
}