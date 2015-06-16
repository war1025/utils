#!/bin/bash

gdbus call --session \
   --dest "org.wrowclif.AreaScreencast" \
   --object-path "/org/wrowclif/AreaScreencast" \
   --method "org.wrowclif.AreaScreencast.StopScreencast"
