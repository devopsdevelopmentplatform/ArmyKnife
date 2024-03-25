# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Feature Automate All: Created "all" make target to run everything at once.
- Created Prerequisites list and added to README.md.
- Added credential helper settings for git in Makefile.Git.mk.
- Created make target ingest secrets to ingest .env into vault.
- Created Makefile to build docker images with docker buildx bake to build multiple architectures.
- Added Multi-Stage Docker Build demo app called mygoapp.
- Added a few security scans to test image.

### Changed
- Changed KubeSpray from host-only network to bridged. 
- Updated subnet to mine 192.168.1 yours might be different Line 53 in Vagrantfile
- Changed from ubuntu 20.04 to 22.04
- Disabled IPV6 in the Vagrantfile

### Fixed
- Bug in KubeSpray make target where the script does not have permission on .venv.
- Line 213 in Vagrantfile for KubeSpray updated host network interface name.



