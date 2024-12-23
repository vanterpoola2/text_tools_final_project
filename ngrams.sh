#!/bin/bash

insp_folder="newline_files/insp"
cosp_folder="newline_files/cosp"
output_folder="ngrams_output"

mkdir -p "$output_folder"

# Initialize temp files to store bigrams and trigrams for each language
> "$output_folder/combined_top_5_bigrams_trigrams.txt"

# Process files in insp folder
for file in "$insp_folder"/*.txt; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        output_prefix="$output_folder/insp_$filename"

        # Step 1: Create shifted versions of the file for bigrams and trigrams
        tail -n +2 "$file" > "${output_prefix}_shift1.txt"   # For bigrams
        tail -n +3 "$file" > "${output_prefix}_shift2.txt"   # For trigrams

        # Step 2: Create bigrams
        paste "$file" "${output_prefix}_shift1.txt" > "${output_prefix}_bigrams.txt"

        # Step 3: Create trigrams
        paste "$file" "${output_prefix}_shift1.txt" "${output_prefix}_shift2.txt" > "${output_prefix}_trigrams.txt"

        # Aggregate bigrams and trigrams by language
        if [[ "$filename" == BO* ]]; then
            cat "${output_prefix}_bigrams.txt" >> "$output_folder/insp_bigrams_BO.txt"
            cat "${output_prefix}_trigrams.txt" >> "$output_folder/insp_trigrams_BO.txt"
        elif [[ "$filename" == DK* ]]; then
	    cat "${output_prefix}_bigrams.txt" >> "$output_folder/insp_bigrams_DK.txt"
            cat "${output_prefix}_trigrams.txt" >> "$output_folder/insp_trigrams_DK.txt"
        elif [[ "$filename" == SP* ]]; then
            cat "${output_prefix}_bigrams.txt" >> "$output_folder/insp_bigrams_SP.txt"
            cat "${output_prefix}_trigrams.txt" >> "$output_folder/insp_trigrams_SP.txt"
        fi

        # Cleanup shifted files
        rm "${output_prefix}_shift1.txt" "${output_prefix}_shift2.txt"
    fi
done

# Process files in cosp folder
for file in "$cosp_folder"/*.txt; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        output_prefix="$output_folder/cosp_$filename"

        # Step 1: Create shifted versions of the file for bigrams and trigrams
        tail -n +2 "$file" > "${output_prefix}_shift1.txt"   # For bigrams
        tail -n +3 "$file" > "${output_prefix}_shift2.txt"   # For trigrams

        # Step 2: Create bigrams
        paste "$file" "${output_prefix}_shift1.txt" > "${output_prefix}_bigrams.txt"

        # Step 3: Create trigrams
	paste "$file" "${output_prefix}_shift1.txt" "${output_prefix}_shift2.txt" > "${output_prefix}_trigrams.txt"

        # Aggregate bigrams and trigrams by language
        if [[ "$filename" == BO* ]]; then
            cat "${output_prefix}_bigrams.txt" >> "$output_folder/cosp_bigrams_BO.txt"
            cat "${output_prefix}_trigrams.txt" >> "$output_folder/cosp_trigrams_BO.txt"
        elif [[ "$filename" == DK* ]]; then
            cat "${output_prefix}_bigrams.txt" >> "$output_folder/cosp_bigrams_DK.txt"
            cat "${output_prefix}_trigrams.txt" >> "$output_folder/cosp_trigrams_DK.txt"
        elif [[ "$filename" == SP* ]]; then
            cat "${output_prefix}_bigrams.txt" >> "$output_folder/cosp_bigrams_SP.txt"
            cat "${output_prefix}_trigrams.txt" >> "$output_folder/cosp_trigrams_SP.txt"
        fi

        # Cleanup shifted files
        rm "${output_prefix}_shift1.txt" "${output_prefix}_shift2.txt"
    fi
done

# Combine and find top 5 bigrams and trigrams for each language from both insp and cosp
for lang in BO DK SP; do
    # Print top 5 bigrams for the language from insp folder
    echo "Top 5 Bigrams for $lang (insp)" >> "$output_folder/combined_top_5_bigrams_trigrams.txt"
    cat "$output_folder/insp_bigrams_$lang.txt" | \
    sort | uniq -c | sort -nr | head -5 >> "$output_folder/combined_top_5_bigrams_trigrams.txt"

    # Print top 5 trigrams for the language from insp folder
    echo "Top 5 Trigrams for $lang (insp)" >> "$output_folder/combined_top_5_bigrams_trigrams.txt"
    cat "$output_folder/insp_trigrams_$lang.txt" | \
    sort | uniq -c | sort -nr | head -5 >> "$output_folder/combined_top_5_bigrams_trigrams.txt"

    # Add an empty line for separation
    echo "" >> "$output_folder/combined_top_5_bigrams_trigrams.txt"

    # Print top 5 bigrams for the language from cosp folder
    echo "Top 5 Bigrams for $lang (cosp)" >> "$output_folder/combined_top_5_bigrams_trigrams.txt"
    cat "$output_folder/cosp_bigrams_$lang.txt" | \
    sort | uniq -c | sort -nr | head -5 >> "$output_folder/combined_top_5_bigrams_trigrams.txt"

    # Print top 5 trigrams for the language from cosp folder
    echo "Top 5 Trigrams for $lang (cosp)" >> "$output_folder/combined_top_5_bigrams_trigrams.txt"
    cat "$output_folder/cosp_trigrams_$lang.txt" | \
    sort | uniq -c | sort -nr | head -5 >> "$output_folder/combined_top_5_bigrams_trigrams.txt"

# Add an empty line for separation
    echo "" >> "$output_folder/combined_top_5_bigrams_trigrams.txt"
done

# Final message
echo "Combined n-grams and counts in: $output_folder/combined_top_5_bigrams_trigrams.txt"
