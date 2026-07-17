.PHONY: build push all
BUILD_DIR := build
BIN_DIR := bin
build:
	arm-none-eabi-as -o $(BUILD_DIR)/boot.o src/bootloader/boot.asm
	arm-none-eabi-ld -T src/bootloader/link.ld -o $(BUILD_DIR)/kernel.elf $(BUILD_DIR)/boot.o
	arm-none-eabi-objcopy -O ihex $(BUILD_DIR)/kernel.elf $(BIN_DIR)/kernel.hex
push:
	@echo "Checking for micro:bit hardware..."
	@if [ -b /dev/sdb ]; then \
		echo "Mounting device partition..."; \
		sudo mount /dev/sdb /mnt/microbit; \
		echo "Pushing kernel.hex to flash memory..."; \
		sudo cp bin/kernel.hex /mnt/microbit/; \
		sync; \
		echo "Unmounting cleanly..."; \
		sudo umount /mnt/microbit; \
		echo "Flash process successful!"; \
	else \
		echo "ERROR: micro:bit (/dev/sdb) not detected! Is it plugged in?"; \
		exit 1; \
	fi
all: build push