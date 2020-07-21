#!/bin/bash

rm -f mho.zip && zip -r mho.zip . -x@.gitignore -x "./bin/zip.sh" -x ".git*" -x "*.zip"