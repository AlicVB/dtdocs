---
title: overview
id: overview
weight: 10
draft: false
author: "people"
---

 darktable employs a fully color managed workflow:

- Input color specifications are taken from embedded or user-supplied ICC profiles or -- in the case of raw files -- from a library of camera-specific color matrices.

- darktable automatically reads the display profile of your monitor (if properly configured) for accurate on-screen color rendition. Multi-screen setups are fully supported as long as a system service like colord is in place and properly set up to inform darktable of the correct monitor profile.

- Output files can be encoded in one of darktable's built-in profiles, including sRGB and Adobe RGB, or into a color space supplied by the user as an ICC profile.
