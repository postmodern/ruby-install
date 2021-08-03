---
name: Bug Report
about: Report a bug
title: ''
labels: bug
assignees: ''

---

<!--
**Double Check**

- Did you update to the latest ruby-install version? (ex: `brew upgrade ruby-install`)
- Are attempting to install an older unmaintained version of Ruby?
  - ruby-install makes no guarantees that older unmaintained versions ruby versions will still compile or work with the current versions of `gcc`/`clang`, `libopenssl`, etc.
- Are you attempting to install the most recent version of Ruby on an old system?
  - Newer ruby versions may require newer versions of `gcc`/`clang`, `libopenssl`, etc. Double check the ruby's requirements.
- Is this a ruby compilation bug?
  - Can you reproduce the issue by compiling ruby manually?
    - If so, than it is the upstream ruby's issue and should be reported to the ruby's bug tracker.
    - If the issue only occurs with ruby-install, proceed.
-->

## Description

<!-- A clear and concise description of what the bug is. -->

## Steps To Reproduce

Steps to reproduce the bug:
1. `$ ruby-install ...`
2. ???

## Expected Behavior

<!-- What should happen. -->

## Actual Behavior

<!-- The error message. -->

## Environment

    $ ruby-install --version
    ...
    $ uname -a
    ...
    $ cc --version
    ...
    $ openssl --version
    ...
