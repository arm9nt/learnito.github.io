#!/bin/bash

# Clean up the directory (preserve only specified files)
echo "Cleaning up the directory..."
rm -rf $(ls -A | grep -v -E ".git|CNAME|fix-paths.sh")

# Copy over files from the Next.js build output
echo "Copying over files from ../learnito-src/out/ to ./"
cp -R ../learnito-src/out/* ./

export LC_ALL=C

# Define the source and target folder names
SRC_FOLDER="_next"
TARGET_FOLDER="scripts"

# Step 1: Replace all references to "/_next" with "/scripts" in all relevant files
echo "Updating references to '/_next'..."
find . -type f \( -name "*.html" -o -name "*.js" -o -name "*.css" -o -name "*.txt" \) \
  -exec sed -i.bak 's|"/_next|"/scripts|g' {} \;

# Step 2: Rename the _next folder to scripts
echo "Renaming _next folder to scripts..."
if [ -d "./$SRC_FOLDER" ]; then
  mv "./$SRC_FOLDER" "./$TARGET_FOLDER"
fi

# Step 3: Clean up backup files created by sed
echo "Cleaning up backup files..."
find . -type f -name "*.bak" -exec rm {} \;

echo "Fix applied. '_next' has been renamed to 'scripts', and references updated."

# Commit the changes
echo "Committing the changes..."
git add .
git commit -m "Release: $(date)"
git push upstream main