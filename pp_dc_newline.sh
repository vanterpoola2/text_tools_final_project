#!/bin/bash

# Input Folders
insp_input_folder="cleaned_insp_files"
cosp_input_folder="cleaned_cosp_files"

# Output directories
output_base_folder="newline_files"
insp_output_folder="$output_base_folder/insp"
cosp_output_folder="$output_base_folder/cosp"

# Create output directories
mkdir -p "$insp_output_folder"
mkdir -p "$cosp_output_folder"

# Process files for insp folder
for file in "$insp_input_folder"/*.txt; do
  # Extract filename
  filename=$(basename "$file")

  # Remove "chi:" from the start of each line, split words into one per line
  sed 's/^chi: //' "$file" | tr -s '[:space:]' '\n' | sed '/^chi:/d' > "$insp_output_folder/$filename"
done

# Process files for cosp folder
for file in "$cosp_input_folder"/*.txt; do
  # Extract filename
  filename=$(basename "$file")

  # Remove "chi:" from the start of each line, split words into one per line
  sed 's/^chi: //' "$file" | tr -s '[:space:]' '\n' | sed '/^chi:/d' > "$cosp_output_folder/$filename"
done

echo "Output files are organized in $output_base_folder"
