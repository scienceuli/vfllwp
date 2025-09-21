#!/usr/bin/env bash
set -euo pipefail

# Load variables from .env
set -a
source .env
set +a

old_url="https://${old_domain}"
new_url="https://${domain}"

echo "replace $old_url with $new_url"

# Name of your WordPress container (adjust if different)
WP_CONTAINER="wordpress"

echo "🔄 Replacing URLs in database..."
docker exec -it "$WP_CONTAINER" wp search-replace "$old_url" "$new_url" --skip-columns=guid --allow-root

echo "✅ Database replacement done."

echo "🔍 Searching for hardcoded URLs in wp-content..."
grep -R "$old_url" wordpress/wp-content || true

echo "⚠️ If matches are found above, we can replace them automatically."
read -p "Do you want to replace in files too? (y/N): " confirm
if [[ "$confirm" =~ ^[Yy]$ ]]; then
  echo "🔄 Replacing URLs in wp-content files..."
  grep -rl "$old_url" wordpress/wp-content | xargs sed -i "s|$old_url|$new_url|g"
  echo "✅ Filesystem replacement done."
else
  echo "⏭️ Skipped filesystem replacement."
fi
