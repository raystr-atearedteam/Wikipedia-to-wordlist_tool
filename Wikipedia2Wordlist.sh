#!/bin/bash

# Check if Lynx is installed
check_lynx() {
    if ! command -v lynx &> /dev/null; then
        echo "Lynx is not installed. Please install Lynx before running this script."
        exit 1
    fi
}

# Check if Lynx is installed
check_lynx

# Download the .tar.z7 file
# Grabbing the static html dumps, in this case the Norwegian one
# Get the full list of availible dumps here: https://dumps.wikimedia.org/other/static_html_dumps/current/
wget https://dumps.wikimedia.org/other/static_html_dumps/current/no/wikipedia-no-html.tar.7z

# Extract the .tar.z7 file
tar -xf file.tar.z7

# Find all HTML files and extract text
find . -name "*.html" -exec cat {} + | \
    # Convert HTML to plain text
    lynx -dump -stdin | \
    # Convert text to lowercase
    tr '[:upper:]' '[:lower:]' | \
    # Remove punctuation and special characters
    tr -cd '[:alnum:] \n' | \
    # Split words by space
    tr ' ' '\n' | \
    # Filter words with length greater than 8 characters
    awk 'length($0) > 8' | \
    # Get unique words
    sort -u > wordlist.txt

echo "Wordlist created successfully."
