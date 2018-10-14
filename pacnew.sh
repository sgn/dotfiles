#!/bin/sh

pacman -Qqne |
	diff pacman.list - |
	sed -nE 's/^< (.+)$/\1/p'
