Warning: This is a experimental overlay, it can hurt your cow…
Commits are now(2016-01-08 22:00 UTC) *all* signed.

# How to add this overlay
layman -a lanodanOverlay

# What’s mostly in here
* Early version-bump
* Compatibility with:
	* UID 0 != root
	* Clang/LLVM
	* LibreSSL
* Very unstable stuff I want to stabilize

# What’s not here
* Compatibility with SystemD(I’m compatible with rc script, sys V init+rc, openrc)

# Goals
* Gentoo on smartphones (I currently have a OnePlus One and LCD-less Nexus 4)
* GNU-less full-blown desktop
* Provide good crypto, remove broken one
* Prepare for deprecation
* Try to respect only mandatory standards, flex/break the others(i.e. LFsH, UID0=root)
