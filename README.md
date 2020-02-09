# word_practice
A script for creating Morse Code practice audio files, by Bill Mitchell AE0EE

## Requirements
* R
* [ebook2cw](https://fkurz.net/ham/ebook2cw.html "ebook2cw page")

## Usage
Enter your callsign, name, city, state/province, any club callsign(s), mentor callsign(s), or other words specific to your situation in callsign_specific.txt, with one word per line.  Spaces within a line are okay for multi-word cities/states, _etc_.

With R open in this directory (and as a user with write permission), use `source("word_practice.R")` to create the practice files (mp3).  

## Details
The script will randomly draw words from the combined pool from the three default files, without replacement.  Each word will be replicated five times.  Once each word has been used, the words will be redrawn without replacement, and replicated four times.  This repeats for three, two, and finally one replication.

Once the practice text has been determined, the script invokes `ebook2cw` to generate mp3 files from the text.  Characters have a minimum speed of 20 wpm, but the character spacing is increased for slower speeds.  By default, files are made from 15 to 30 wpm, with alternating increases of 3 and 2 wpm (i.e. 15 wpm, 18 wpm, 20 wpm, 23 wpm...).

This file can also be sourced in R, which will not cause the files to be generated immediately.  To generate files from an interactive/sourced environment, the function `make_practice_audio_files` must be invoked (all arguments are optional).
