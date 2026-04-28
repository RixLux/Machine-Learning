#!/bin/bash

# 1. Build the nav list
NEW_NAV="nav:"
[[ -f "docs/index.md" ]] && NEW_NAV="$NEW_NAV\n  - Home: index.md"

while read -r file; do
    rel="${file#docs/}"
    name="$(basename "$rel" .md)"
    # Title Case conversion
    title=$(echo "$name" | sed 's/[-_]/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')
    NEW_NAV="$NEW_NAV\n  - $title: $rel"
done < <(find docs -type f -name "*.md" ! -name "index.md" | sort -V)

# 2. Update mkdocs.yml safely
# This searches for the line starting with 'nav:' and replaces everything
# from there to the end of the file with our new list.
sed -i -e '/^nav:/,$d' mkdocs.yml
echo -e "$NEW_NAV" >> mkdocs.yml
