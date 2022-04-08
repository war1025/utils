#!/bin/bash

gdbus call --session \
   --dest "org.wrowclif.AreaScreenshot" \
   --object-path "/org/wrowclif/AreaScreenshot" \
   --method "org.wrowclif.AreaScreenshot.Screenshot"
