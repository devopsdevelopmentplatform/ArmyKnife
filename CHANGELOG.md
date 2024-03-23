# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Feature Automate All: Created "all" make target to run everything at once.
- Created Prerequisites list and added to README.md

### Changed
- Changed KubeSpray from host-only network to bridged. 
- Updated subnet to mine 192.168.1 yours might be different
- Changed from ubuntu 20.04 to 22.04

### Fixed
- Bug in KubeSpray make target where the script does not have permission on .venv.
- Line 213 in Vagrantfile for KubeSpray updated host network interface name.



