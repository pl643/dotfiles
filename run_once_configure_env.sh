#!/bin/env bash

shell=$(basename $SHELL)

if ! grep -q "source ~/.config/${shell}rc" ~/.${shell}rc; then
  echo "source ~/.config/${shell}rc" >>~/.${shell}rc
fi
