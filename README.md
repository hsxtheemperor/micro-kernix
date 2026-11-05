# micro-kernix

[Repository](https://github.com/hsxtheemperor/micro-kernix)

micro-kernix is an Assembly kernel/OS experiment for the BBC micro:bit v2, based on the board's Cortex-M4 / nRF52833 platform. The tracked sources include an exception and interrupt vector table, reset entry code, kernel entry and idle-path scaffolding, system-call stubs, fault handlers, and a linker script describing the device's flash and RAM layout.

The source is an in-progress low-level experiment, not a finished general-purpose operating system. Some handlers and kernel services are still stubs or scaffolding.

## Build status

The current Makefile refers to `src/bootloader/boot.asm` and `src/bootloader/link.ld`, which are not present in the current repository tree. The tracked files instead include `src/boot/boot.asm` and `src/kernel.ld`. As a result, the documented Makefile build path does not currently match the checked-in source layout; verify and align those paths before relying on a build or flashing workflow.

## License

GNU General Public License v3.0 (GPL-3.0). See the [repository LICENSE](https://github.com/hsxtheemperor/micro-kernix/blob/main/LICENSE).
