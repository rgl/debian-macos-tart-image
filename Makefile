ISO_URL=https://cdimage.debian.org/debian-cd/12.0.0/arm64/iso-cd/debian-12.0.0-arm64-netinst.iso

build: tmp/debian-12.0.0-arm64-netinst.iso tmp/preseed.iso
	CHECKPOINT_DISABLE=1 PACKER_LOG=1 PACKER_LOG_PATH=$@.init.log \
		packer init debian.pkr.hcl
	CHECKPOINT_DISABLE=1 PACKER_LOG=1 PACKER_LOG_PATH=$@.log \
		packer build \
			-only=tart-cli.debian \
			-on-error=abort \
			-timestamp-ui \
			debian.pkr.hcl

tmp/debian-12.0.0-arm64-netinst.iso:
	install -d tmp
	curl -fsSL -o $@ ${ISO_URL}

tmp/preseed.iso: preseed.txt
	rm -rf tmp/preseed
	install -d tmp/preseed
	install preseed.txt tmp/preseed
	hdiutil makehybrid -o $@ -joliet -iso -iso-volume-name PRESEED tmp/preseed
	file $@

.PHONY: build
