# text_tools_final_project
## Topic
**Natural Language Identification**

### Goal
The goal of the project is to find out if linguistic patterns found in text data of L2 English children learners help to determine the L1 of the speaker.


Folder of Corpus Data: soraUVALAL


Script 1: pp_dc_insp.sh 

This script takes all the folders with written files from the soraUVALAL corpus and finds all the lines in the text that start with '*CHI:', converts all text to lowercase, removes parentheses and specific special characters, collapses all tabs and multiple spaces into a single space, and removes leading and trailing spaces. 

Output of Script 1: cleaned_insp_files/

The output of this script contains text with incorrect spelling (insp), excluing the annotated corrections


Script 2: pp_dc_cosp.sh

This script takes all the folders with written files from the soraUVALAL corpus and finds all the lines in the text that start with '*CHI:', converts all text to lowercase, removes words to the left of the brackets (incorrectly spelled words), removes brackets but keeps the correctly spelled word inside, removes non-words inside the brackets, removes paretheses and other unwanted characters, removes specific characters, removes any leading or trailing spaces from lines, and normalizes mutliple spaces between words to a single space.

Output of Script 2: cleaned_cosp_files/

The output of this script contains text with annotated corrected spelling (cosp), excluding the incorrect spelling of words


Script 3: pp_calculate_metrics.sh

This script calculates the number of unique words, utterances, tokens, and mean length of utterances (MLU) of both the insp file and cosp file.

Output of Script 3: calculated_metrics_cleaned/


Script 4: comparing_metrics.sh

This script sums up the number of unique words, utterances, tokens, and mean length of utterances (from Script 3) of each language (BO for Bosnian, DK for Danish, and SP for Spanish) in each file (insp and cosp) and calculates the averages.

Output of Script 4: summary_compared_metrics.txt


Script 5: pp_dc_newline.sh

This script takes all the files created in Script 1 and Script 2 and removes 'chi:' from the start of the line and splits words into one word per line.

Output of Script 5: newline_files/ 


Script 6: ngrams.sh

This script creates bigrams and trigrams of each file (with respect to L1) from both folders created in Script 5 (insp and cosp) and creates txt files for each file as well as a separate file pertaining to the results of the top 5 ngrams of each language. The script also combines the bigrams and trigrams of every file (with respect to L1) to find the top 5 bigrams of each language.

Output of Script 6: ngrams_output
