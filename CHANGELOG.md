All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)  
and this project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.3.5] - 2025-07-30
### Added
- Supports `--debug` to enable debug mode and print outputs for each command, run again to disable.
- Gateway and DNS resolver status 

### Removed
- User Notes due to persistance issues

## [0.2.8] - 2025-07-30
### Added
- Updated summary note template to include information about VM/lxc OS update availability

### Fixed
- Fixed notes and issues not being preserver when running again

## [0.2.7] - 2025-07-30
### Added
- Refined SSH scraping
- Prompt when running if the notes file already contains data
- check if notes was previously populated by nodeinfo that it will not replace user notes 

## [0.2.5] - 2025-07-30
### Added
- Updated `update` to check for new version, confirm if user wishes to download.
  
    1.	Checks for latest version from GitHub Releases.
	2.	Compares with the current version (VERSION constant).
	3.	Asks the user for confirmation before proceeding.
	4.	Downloads the .deb file into /tmp.
	5.	Backs up /etc/nodeinfo/vlan.conf only if it exists and is non-empty.
	6.	Installs the new .deb using dpkg -i.
	7.	Restores the backup of vlan.conf if it was backed up.
	8.	Handles errors gracefully and provides clear output.

## [0.2.3] - 2025-07-30
### Added
- Supports `--remove` to fully remove package and components.

## [0.2.2] - 2025-07-30
### Fixed
- template for vlans

## [0.2.1] - 2025-07-30
### Added
-  Changelog
-  template.md file added for future segregation of notes template
-  Option to configure vlan names on install using `--vlan`

## [0.1.6] - 2025-07-30
### Added
-  Version check and GitHub update feature (`nodeinfo update`)
-  Auto-updates README with correct .deb version
-  Release notes support in `make release NOTES="..."`

## [0.1.4] - 2025-07-30
### Fixed
-  Corrected `--version` handling
-  Cleaned up README formatting and usage examples

## [0.1.3] - 2025-07-30
### Added
-  VLAN/subnet name resolution
-  Markdown formatting improvements for Proxmox Notes

---

## [0.1.0] - 2025-07-29
### Initial Release
-  Basic VM/LXC inspection
-  Auto-write system info to Notes field
-  Supports `--help`, `--version`, `nodeinfo <vmid>`
