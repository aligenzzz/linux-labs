#!/bin/bash

if [ $# -ne 2 ]; then
    echo "$0 <input_file> <output_file>"
    exit 1
fi

input_file=$1
if [ ! -f "$input_file" ]; then
    echo "Input file $input_file doesn't exist!"
    exit 1
fi

output_file=$2
if [ ! -f "$output_file" ]; then
    echo "Output file $output_file doesn't exist!"
    exit 1
fi

corrected_text=$(sed -E 's/(^|[.!?]\s+)([a-zA-Zа-яА-ЯёЁ])/\1\U\2/g' "$input_file")

echo "$corrected_text" > "$output_file"
echo "Correction successfully completed..."