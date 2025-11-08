#!/bin/bash
set -e
shopt -s nullglob

for f in *.jpg; do
    convert "$f" "${f%.jpg}.png"
done

