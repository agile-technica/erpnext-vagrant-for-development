#!/usr/bin/env bash

TIMESTAMP="$(date +%s)"
mv mounted-space/app mounted-space/app-$TIMESTAMP
vagrant destroy