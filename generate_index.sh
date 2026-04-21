#!/bin/bash
set -e

ROOT="."
OUT="index.html"

cat > "$OUT" <<'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Index</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      max-width: 900px;
      margin: 40px auto;
      padding: 0 20px;
      background: #f7f7f7;
      color: #222;
    }
    h1 {
      margin-bottom: 8px;
    }
    p {
      color: #666;
    }
    .grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
      gap: 14px;
      margin-top: 24px;
    }
    a.card {
      display: block;
      padding: 16px;
      border-radius: 12px;
      text-decoration: none;
      background: white;
      color: #222;
      box-shadow: 0 1px 4px rgba(0,0,0,0.08);
      transition: transform 0.12s ease, box-shadow 0.12s ease;
    }
    a.card:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 14px rgba(0,0,0,0.12);
    }
    .name {
      font-size: 18px;
      font-weight: 600;
      margin-bottom: 6px;
    }
    .path {
      font-size: 13px;
      color: #777;
      word-break: break-all;
    }
  </style>
</head>
<body>
  <h1>Site Index</h1>
  <p>Automatically generated from folders in this repository.</p>
  <div class="grid">
HTML

find "$ROOT" -mindepth 1 -maxdepth 1 -type d \
  ! -name ".git" \
  ! -name ".github" \
  | sort | while read -r dir; do
    name=$(basename "$dir")

    target=""
    if [ -f "$dir/index.html" ]; then
      target="$name/"
    else
      first_html=$(find "$dir" -maxdepth 1 -type f \( -name "*.html" -o -name "*.htm" \) | sort | head -n 1)
      if [ -n "$first_html" ]; then
        file=$(basename "$first_html")
        target="$name/$file"
      fi
    fi

    if [ -n "$target" ]; then
      cat >> "$OUT" <<HTML
    <a class="card" href="$target">
      <div class="name">$name</div>
      <div class="path">$target</div>
    </a>
HTML
    fi
done

cat >> "$OUT" <<'HTML'
  </div>
</body>
</html>
HTML

echo "Generated $OUT"