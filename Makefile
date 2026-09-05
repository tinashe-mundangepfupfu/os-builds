.PHONY: all clean build-iso test-iso

all: build-iso

build-iso:
	@echo "==> Building Oponn ISO..."
	@./scripts/build-iso.sh

clean:
	@echo "==> Cleaning build artifacts..."
	@rm -rf output work
	@echo "==> Clean complete!"

test-iso: build-iso
	@echo "==> Testing ISO in QEMU UEFI..."
	@qemu-system-x86_64 \
		-m 4G \
		-smp 4 \
		-drive if=pflash,format=raw,readonly=yes,file=/usr/share/edk2/x64/code.fd \
		-drive if=pflash,format=raw,file=/usr/share/edk2/x64/vars.fd \
		-boot d \
		-cdrom output/*.iso \
		-enable-kvm \
		-cpu host \
		-serial stdio

test-bios: build-iso
	@echo "==> Testing ISO in QEMU BIOS..."
	@qemu-system-x86_64 \
		-m 4G \
		-smp 4 \
		-boot d \
		-cdrom output/*.iso \
		-enable-kvm \
		-cpu host \
		-serial stdio

help:
	@echo "Oponn OS Build System"
	@echo ""
	@echo "Targets:"
	@echo "  all         - Build the ISO (default)"
	@echo "  build-iso   - Build the ISO"
	@echo "  clean       - Remove build artifacts"
	@echo "  test-iso    - Test ISO in QEMU UEFI"
	@echo "  test-bios   - Test ISO in QEMU BIOS"
	@echo "  help        - Show this help"
