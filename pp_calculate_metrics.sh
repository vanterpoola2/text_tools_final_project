#!/bin/bash

# Define the folder paths
input_folders=(
    "cleaned_insp_files"
    "cleaned_cosp_files"
)

# Create output directory
output_folder="calculated_metrics_cleaned/"
mkdir -p "$output_folder"

# Loop through all the input directories
for folder in "${input_folders[@]}"; do
    echo "Processing files in $folder..."

    # Get the folder name ("cleaned_insp_files" or "cleaned_cosp_files")
    folder_name=$(basename "$folder")

    # Loop through all .txt files in the current folder
    find "$folder" -type f -name "*.txt" | while read -r file; do
        echo "Processing file: $file"

        # Get unique output filenames
        base_name=$(basename "$file")
        output_file_speech_metrics="${output_folder}${folder_name}_${base_name}_speech_metrics.txt"

        # Initialize variables
        unique_words=0
        utterances=0
        tokens=0
        mlu=0

        # Process chi: lines
        chi_lines=$(grep '^chi:' "$file")
        if [[ -n "$chi_lines" ]]; then
            # Calculate unique words
            unique_words=$(echo "$chi_lines" | sed 's/^chi: //g' | tr ' ' '\n' | sort -u | wc -l)

            # Calculate utterances
            utterances=$(echo "$chi_lines" | wc -l)

            # Calculate tokens
            tokens=$(echo "$chi_lines" | sed 's/^chi: //g' | wc -w)

            # Calculate Mean Length of Utterance (MLU)
            if [[ $utterances -gt 0 ]]; then
                mlu=$(awk -v tokens="$tokens" -v utterances="$utterances" 'BEGIN {print tokens / utterances}')
            fi

            # Save metrics to output file
            {
                echo "File: $file"
                echo "Unique Words: $unique_words"
                echo "Number of Utterances: $utterances"
                echo "Number of Tokens: $tokens"
                echo "Mean Length of Utterance (MLU): $mlu"
            } > "$output_file_speech_metrics"

            echo "Metrics saved to $output_file_speech_metrics"
        else
            echo "No chi: content found in $file"
        fi
    done
done

# Rename files to remove "._" prefix if present
for file in "$output_folder"/._*; do
    if [[ -f "$file" ]]; then
        new_name="${file/._/}"
        mv "$file" "$new_name"
        echo "Renamed file: $file to $new_name"
    fi
done

echo "File processing and renaming completed."
