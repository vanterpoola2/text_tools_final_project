#!/bin/bash

# The output of this code contains text with annotated corrected spelling (cosp), excluding the incorrect spelling of words

# Define the folder paths
input_folders=(
    "soraUVALAL/BO/written/4"
    "soraUVALAL/DK/written/4"
    "soraUVALAL/SP/written/4"
)

# Create output directory
output_folder="cleaned_cosp_files/"
mkdir -p "$output_folder"

# Loop through all the input directories
for folder in "${input_folders[@]}"; do
    echo "Processing files in $folder..."

    # Loop through all .cha files in the current folder
    find "$folder" -type f -name "*.cha" | while read -r file; do
        echo "Cleaning file: $file"

        # Get unique output filenames
        base_name=$(basename "$file")
        grandparent_dir_name=$(basename "$(dirname "$(dirname "$(dirname "$file")")")")
        output_file_same_line="${output_folder}${grandparent_dir_name}_${base_name}_same_line.txt"

        # Process only lines starting with "*CHI:"
	cleaned_cosp_text=$(grep '^\*CHI:' "$file" | \
    	# Convert all text to lowercase
    	tr 'A-Z' 'a-z' | \
    	# Remove the word to the left of the brackets (incorrect spelling), remove brackets but keep the correctly spelled word inside, and remove non-words inside the brackets
    	perl -pE 's/(\S+)\s*\[\s*([^\]]+)\s*\]/\2/g' | \
    	# Remove parentheses and other unwanted characters
    	perl -pE 's/[()\/\[\]]//g' | \
    	# Remove specific special characters
    	sed 's/[=*.]//g' | \
    	# Remove any leading or trailing spaces from lines
    	sed 's/^ *//;s/ *$//' | \
    	# Normalize multiple spaces between words to a single space
    	sed 's/  */ /g'
)

        # Ensure cleaned_cosp_text retains proper line separation
        cleaned_cosp_text=$(echo "$cleaned_cosp_text" | sed '/@end$/d')

        # Check if cleaned cosp text is non-empty
        if [[ -n "$cleaned_cosp_text" ]]; then
            # Save cleaned cosp text where each *CHI line is preserved
            echo "$cleaned_cosp_text" > "$output_file_same_line"
            echo "Saved cleaned *CHI lines to $output_file_same_line"
        else
            echo "No *CHI content found in $file"
        fi
    done
done
