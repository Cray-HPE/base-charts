See the CASM PET team's [contributing guide](https://connect.us.cray.com/confluence/display/CASMPET/CONTRIBUTING).

# When making changes

Please update the CHANGELOG.md: https://keepachangelog.com/en/1.0.0/

# When releasing

Picking the version:
- if this is the first release targeting a new version of CSM,
  increase the MAJOR version regardless of what semver says to do.
- if this is for an older released of CSM,
  never increase the MAJOR version regardless of what semver says to do.
- Otherwise just follow semver as normal.

Update the CHANGELOG.md: https://keepachangelog.com/en/1.0.0/

Update the PET wiki page with the current version number:
https://connect.us.cray.com/confluence/display/CASMPET/Base+Charts+by+Release

You'll probably want to send out an announcement telling consumers to pick up a new version:
https://connect.us.cray.com/confluence/display/CASMPET/Announcements
