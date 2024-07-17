#!/bin/sh

## Download dependencies
./download-dependencies.sh

## Generate project
tuist clean && tuist install && tuist generate --no-open && rm -rf TuistTestLibrary.xcworkspace
