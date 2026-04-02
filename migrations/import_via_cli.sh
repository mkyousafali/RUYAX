#!/bin/bash
# Import SQL files one by one via Supabase CLI

cd "$(dirname "$0")/sql_final_v2" || exit 1

files=(
  "01_sets.sql"
  "02_schemas.sql"
  "03_types.sql"
  "04_tables.sql"
  "05_sequences.sql"
  "06_indexes.sql"
  "07_foreign_keys.sql"
  "08_triggers.sql"
  "09_functions.sql"
  "10_comments.sql"
  "11_acl.sql"
  "12_other.sql"
)

echo "🚀 Starting sequential SQL import via Supabase CLI"
echo "   Each file will be imported to the linked RUYAX project"
echo ""

success=0
failed=0

for i in "${!files[@]}"; do
  file="${files[$i]}"
  num=$((i + 1))
  total=${#files[@]}
  
  if [ ! -f "$file" ]; then
    echo "⏭️  [$num/$total] $file - NOT FOUND"
    continue
  fi
  
  filesize=$(du -h "$file" | cut -f1)
  echo "📝 [$num/$total] $file ($filesize)"
  
  if npx supabase db query -f "$file" --linked -o json > /dev/null 2>&1; then
    echo "    ✅ Success"
    ((success++))
  else
    echo "    ❌ Failed"
    ((failed++))
  fi
  echo ""
done

echo "📊 Summary:"
echo "   ✅ Successful: $success/${#files[@]}"
echo "   ❌ Failed: $failed/${#files[@]}"

if [ $failed -eq 0 ]; then
  echo ""
  echo "🎉 ALL FILES IMPORTED SUCCESSFULLY!"
  exit 0
else
  echo ""
  echo "⚠️  Some files failed"
  exit 1
fi
