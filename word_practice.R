#!/usr/bin/Rscript

# word_practice.R
# by Bill Mitchell
# 9/17/13
# R functions for putting together text files for cw word practice

nInit <- 5 # Number of repetitions for each word at the beginning
nFinal <- 1 # Number of repetitions for each word at the end
word_files_default = c("100words.txt", "radio_words.txt", "call_specific.txt")

change_n <- function(nCurrent){
	# Edit this function for different increase/decrease models
  nNew <- nCurrent - 1 # Simple model: decrease linearly by 1
	return(nNew)
}

get_word_files <- function(customFiles=list(), useDefault=TRUE){
# Get a list of the dictionary files (which exist)
# customFiles: list/vector of custom files to use
# useDefault: use (or do not use) the default word files
# returns: list of filenames

	existingFiles <- vector()

	for(f in customFiles){ # Append any existing custom files
		if (file.exists(f)){
			existingFiles <- append(existingFiles, f)
		} else {
			print(paste0("File not found: ", f))
		}
	}

	for (f in word_files_default){ # Append any existing default files, if used
		if (file.exists(f) & useDefault){
			existingFiles <- append(existingFiles, f)
		} else {
			print(paste0("File not found: ", f))
		}
	}

  return(existingFiles)
}

make_practice_text_file <- function(){
	# Creates a file for cw practice
	# starts with nInit repetitions of a word, ends with nFinal repetitions
	# outputs a text file of words in random order
	
	wordFiles <- get_word_files() # Get list of input files

	# Create the dictionary
	myDict <- c()
	for(myFile in wordFiles){
		temp <- read.table(myFile, header=FALSE)
	  myDict <- append(myDict, as.vector(temp[,1]))
	}

	n <- nInit
	while(n>=nFinal){
	  myLine <- paste(rep(sample(myDict), each=n), sep=" ")
		sink("practice_output.txt", append=TRUE)
		cat(myLine)
		cat("\n")
		sink()
		n <- change_n(n)
	}
}

make_practice_audio_files <- function(low_wpm=15, high_wpm=30, my_text="practice_output.txt"){
	# Function to create Morse audio files from a text, in a range of speeds
	# low_wpm: minimum WPM
	# high_wpm: maximum WPM
	# my_text: file to ebookify

	if (!file.exists(my_text)){
		make_practice_text_file()
	}
	if(low_wpm<5){
		low_wpm=5
	}
	if(low_wpm>high_wpm){
		temp_wpm <- high_wpm
		high_wpm <- low_wpm
		low_wpm <- temp_wpm
	}
	speed_seq <- seq(low_wpm, high_wpm)
	speeds <- speed_seq[speed_seq%%5==3 | speed_seq%%5==0]
	for (my_speed in speeds) {
		command_string <- ":"
		if(my_speed<20){
			command_string <- sprintf("ebook2cw -w 20 -e %d -o 100_words_%dwpm_ -t 100_words_%dwpm %s", my_speed, my_speed, my_speed, my_text)
		} else {
			command_string <- sprintf("ebook2cw -w %d -o 100_words_%dwpm_ -t 100_words_%dwpm %s", my_speed, my_speed, my_speed, my_text)
		}
		system(command_string)
	}
}

if (sys.nframe()==0){
  make_practice_audio_files()
}
