#!/bin/bash

# Output file for the summary
output_file="summary_compared_metrics.txt"

# Initialize the output file
echo "Speech Metrics Summary" > "$output_file"
echo "                      " >> "$output_file"

# Languages and file patterns
languages=("BO" "DK" "SP")
language_names=("Bosnian (BO)" "Danish (DK)" "Spanish (SP)")

# Loop through each language
for i in "${!languages[@]}"; do
    lang="${languages[$i]}"
    language_name="${language_names[$i]}"

    # Find all files for the current language, divided by cleaned_insp_files and cleaned_cosp_files
    insp_files=(calculated_metrics_cleaned/cleaned_insp_files_"$lang"*.txt)
    cosp_files=(calculated_metrics_cleaned/cleaned_cosp_files_"$lang"*.txt)

    # Initialize sums and counts for metrics for cleaned_insp_files
    unique_words_sum_insp=0
    utterances_sum_insp=0
    tokens_sum_insp=0
    mlu_sum_insp=0
    file_count_insp=0

    # Process each file for cleaned_insp_files
    for file in "${insp_files[@]}"; do
        echo "Processing file: $file"
	while read -r line; do
            # Skip lines that start with "File:"
            if [[ "$line" == File:* ]]; then
                continue
            fi

            # Extract metrics using awk, ensuring that only numbers are extracted
            unique_words=$(echo "$line" | awk '/Unique Words/ {print $NF}')
            utterances=$(echo "$line" | awk '/Number of Utterances/ {print $NF}')
            tokens=$(echo "$line" | awk '/Number of Tokens/ {print $NF}')
            mlu=$(echo "$line" | awk '/Mean Length of Utterance/ {print $NF}')

            # Update sums if valid numbers are extracted
            if [[ "$unique_words" =~ ^[0-9]+$ ]]; then
                unique_words_sum_insp=$((unique_words_sum_insp + unique_words))
            fi
            if [[ "$utterances" =~ ^[0-9]+$ ]]; then
                utterances_sum_insp=$((utterances_sum_insp + utterances))
            fi
            if [[ "$tokens" =~ ^[0-9]+$ ]]; then
                tokens_sum_insp=$((tokens_sum_insp + tokens))
            fi
            if [[ "$mlu" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                mlu_sum_insp=$(awk -v sum="$mlu_sum_insp" -v val="$mlu" 'BEGIN {print sum + val}')
            fi

            file_count_insp=$((file_count_insp + 1))
        done < "$file"
    done

    # Calculate averages for cleaned_insp_files if at least one file was processed
    if [[ $file_count_insp -gt 0 ]]; then
        avg_unique_words_insp=$(awk -v sum="$unique_words_sum_insp" -v count="$file_count_insp" 'BEGIN {print sum / count}')
        avg_utterances_insp=$(awk -v sum="$utterances_sum_insp" -v count="$file_count_insp" 'BEGIN {print sum / count}')
        avg_tokens_insp=$(awk -v sum="$tokens_sum_insp" -v count="$file_count_insp" 'BEGIN {print sum / count}')
        avg_mlu_insp=$(awk -v sum="$mlu_sum_insp" -v count="$file_count_insp" 'BEGIN {print sum / count}')
    else
        avg_unique_words_insp=0
        avg_utterances_insp=0
        avg_tokens_insp=0
        avg_mlu_insp=0
    fi

    # Initialize sums and counts for metrics for cleaned_cosp_files
    unique_words_sum_cosp=0
    utterances_sum_cosp=0
    tokens_sum_cosp=0
    mlu_sum_cosp=0
    file_count_cosp=0

    # Process each file for cleaned_cosp_files
    for file in "${cosp_files[@]}"; do
        echo "Processing file: $file"
        while read -r line; do
            # Skip lines that start with "File:"
            if [[ "$line" == File:* ]]; then
                continue
            fi

            # Extract metrics using awk, ensuring that only numbers are extracted
            unique_words=$(echo "$line" | awk '/Unique Words/ {print $NF}')
            utterances=$(echo "$line" | awk '/Number of Utterances/ {print $NF}')
            tokens=$(echo "$line" | awk '/Number of Tokens/ {print $NF}')
            mlu=$(echo "$line" | awk '/Mean Length of Utterance/ {print $NF}')

            # Update sums if valid numbers are extracted
            if [[ "$unique_words" =~ ^[0-9]+$ ]]; then
                unique_words_sum_cosp=$((unique_words_sum_cosp + unique_words))
            fi
            if [[ "$utterances" =~ ^[0-9]+$ ]]; then
                utterances_sum_cosp=$((utterances_sum_cosp + utterances))
            fi
            if [[ "$tokens" =~ ^[0-9]+$ ]]; then
                tokens_sum_cosp=$((tokens_sum_cosp + tokens))
            fi
            if [[ "$mlu" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
                mlu_sum_cosp=$(awk -v sum="$mlu_sum_cosp" -v val="$mlu" 'BEGIN {print sum + val}')
            fi

            file_count_cosp=$((file_count_cosp + 1))
        done < "$file"
    done

    # Calculate averages for cleaned_cosp_files if at least one file was processed
    if [[ $file_count_cosp -gt 0 ]]; then
        avg_unique_words_cosp=$(awk -v sum="$unique_words_sum_cosp" -v count="$file_count_cosp" 'BEGIN {print sum / count}')
	avg_utterances_cosp=$(awk -v sum="$utterances_sum_cosp" -v count="$file_count_cosp" 'BEGIN {print sum / count}')
        avg_tokens_cosp=$(awk -v sum="$tokens_sum_cosp" -v count="$file_count_cosp" 'BEGIN {print sum / count}')
        avg_mlu_cosp=$(awk -v sum="$mlu_sum_cosp" -v count="$file_count_cosp" 'BEGIN {print sum / count}')
    else
        avg_unique_words_cosp=0
        avg_utterances_cosp=0
        avg_tokens_cosp=0
        avg_mlu_cosp=0
    fi

    # Write results to output file
    {
        echo "$language_name - cleaned_insp_files:"
        echo "Average Unique Words: $avg_unique_words_insp"
        echo "Average Utterances: $avg_utterances_insp"
        echo "Average Tokens: $avg_tokens_insp"
        echo "Average MLU: $avg_mlu_insp"
        echo
        echo "$language_name - cleaned_cosp_files:"
        echo "Average Unique Words: $avg_unique_words_cosp"
        echo "Average Utterances: $avg_utterances_cosp"
        echo "Average Tokens: $avg_tokens_cosp"
        echo "Average MLU: $avg_mlu_cosp"
        echo
    } >> "$output_file"
done

echo "Summary written to $output_file"
