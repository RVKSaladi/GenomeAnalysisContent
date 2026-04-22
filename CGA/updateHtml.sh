#grep -o '<a name="[0-9]*"' CG.html | sed 's/[^0-9]//g' | \
#awk '{printf "<a href=\"#%s\">%s</a>\n",$1,$1}'



PAGES=$(grep -o '<a name="[0-9]*"' CG.html | sed 's/[^0-9]//g' | sort -n | uniq)

NAV="<div class=\"nav\">"
for p in $PAGES; do
  NAV="$NAV<a href=\"#$p\">$p</a>"
done
NAV="$NAV</div>"

awk -v nav="$NAV" '
/<body/ {
  print;
  print nav;
  next;
}
{ print }
' CG.html > new.html

