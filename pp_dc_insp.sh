#!/bin/bash

# The output of this code contains text with incorrect spelling (insp), excluding the annotated corrections

# Define the folder paths
input_folders=(
    "soraUVALAL/BO/written/4"
    "soraUVALAL/DK/written/4"
    "soraUVALAL/SP/written/4"
)

# Create output directory
output_folder="cleaned_insp_files/"
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
        cleaned_insp_text=$(grep -A1 '^\*CHI:' "$file" | \
            # Convert all text to lowercase
            tr 'A-Z' 'a-z' | \
            # Remove square brackets and their contents
	    sed -E 's/\[[^][]*\]//g' | \
            # Remove parentheses but keep the words inside
            sed 's/[()]//g' | \
            # Remove specific special characters
            sed 's/[=*.]//g' | \
            # Collapse all tabs and multiple spaces into a single space
            tr -s '[:space:]' ' ' | \
            # Remove leading and trailing spaces
            sed 's/^ *//;s/ *$//')

        # Ensure cleaned_insp_text retains proper line separation
        cleaned_insp_text=$(echo "$cleaned_insp_text" | sed 's/ chi:/\nchi:/g' | sed 's/ @end$//g')

        # Check if cleaned insp text is non-empty
        if [[ -n "$cleaned_insp_text" ]]; then
            # Save cleaned insp text where each *CHI line is preserved
            echo "$cleaned_insp_text" > "$output_file_same_line"
            echo "Saved cleaned *CHI lines to $output_file_same_line"
        else
            echo "No *CHI content found in $file"
        fi
    done
done
