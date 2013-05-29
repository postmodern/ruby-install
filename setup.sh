#!/usr/bin/env bash

set -e

sudo make install
ruby-install ruby
ruby-install jruby
ruby-install rubinius
