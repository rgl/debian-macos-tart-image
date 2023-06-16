# About

**WARNING This not yet working due to [#71](https://github.com/cirruslabs/packer-plugin-tart/issues/71).**

**WARNING This branch will be rebased once the above is working.**

This builds the Debian 12 (bookworm) macOS ARM64 [tart VM image](https://github.com/cirruslabs/tart).

# Usage

Install Packer.

Build the image:

```bash
make
```

Try the image:

```bash
tart clone debian-12 debian-12-test
tart run debian-12-test
tart delete debian-12-test
```
