#!/bin/bash

# Check if the user provided a zip file path
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/zipfile.zip [optional/output/path]"
  exit 1
fi

# Define the zip file path
zip_file_path="$1"

# Check if the zip file exists
if [ ! -f "$zip_file_path" ]; then
  echo "Error: Zip file not found!"
  exit 1
fi

echo "Zip file found: $zip_file_path"

# Create a temporary directory for extraction
temp_dir=$(mktemp -d)

# Check if the temporary directory was created successfully
if [ ! -d "$temp_dir" ]; then
  echo "Error: Failed to create temporary directory!"
  exit 1
fi

echo "Temporary directory created: $temp_dir"

# Unzip only the files/mobile directory into the temporary directory
unzip -q -j "$zip_file_path" "files/mobile/*" -d "$temp_dir"

# Check if unzip was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to unzip files!"
  rm -rf "$temp_dir"
  exit 1
fi

echo "Files unzipped successfully."

# Define the target directory containing the images
directory_path="$temp_dir"

# Check if the target directory exists and contains jpg files
if [ ! -d "$directory_path" ] || [ -z "$(ls -A "$directory_path"/*.jpg 2>/dev/null)" ]; then
  echo "Error: No jpg files found in the extracted directory!"
  rm -rf "$temp_dir"
  exit 1
fi

echo "JPG files found in the directory."

# Define the output PDF file name and path
if [ -n "$2" ]; then
  if [[ "$2" == *.pdf ]]; then
    output_file="$2"
  else
    output_file="$2/file.pdf"
  fi
else
  output_file="file.pdf"
fi

echo "Output PDF will be created at: $output_file"

# Create an array to hold the image file names
image_files=()

# Loop through all jpg files in the specified directory, sort them and add them to the array
for file in $(ls "$directory_path"/*.jpg | sort -V); do
  image_files+=("$file")
done

echo "Image files sorted and added to the array."

# Convert the image files to a single PDF
img2pdf "${image_files[@]}" -o "$output_file"

# Check if img2pdf was successful
if [ $? -ne 0 ]; then
  echo "Error: Failed to create PDF!"
  rm -rf "$temp_dir"
  exit 1
fi

echo "PDF created successfully: $output_file"

# Clean up by deleting the temporary directory
rm -rf "$temp_dir"

echo "Temporary directory deleted."
