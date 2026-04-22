#!/usr/bin/perl
use strict;
use warnings;

my $file = shift or die "Usage: perl add_chapter_index.pl yourfile.html\n";

open my $fh, "<", $file or die "Cannot open $file: $!";
local $/;
my $html = <$fh>;
close $fh;

# Find each page anchor and remember chapter headings that appear after it.
my @chapters;

while (
    $html =~ m{
        <a\s+name="(\d+)"></a>     # page anchor
        (.*?)                      # content until next page anchor
        (?=<a\s+name="\d+"></a>|$)
    }gxs
) {
    my ($page, $chunk) = ($1, $2);

    while (
        $chunk =~ m{
            <p\s+style="position:absolute;top:143px;left:80px;white-space:nowrap"
            \s+class="ft\d+"><b>(.*?)</b></p>
        }gxs
    ) {
        my $chapter = $1;
        push @chapters, { chapter => $chapter, page => $page };
    }
}

# Build the index HTML
my $index = qq{\n<div id="chapter-index" style="position:fixed;top:20px;right:20px;background:#fff;padding:12px 16px;border:1px solid #ccc;border-radius:8px;z-index:9999;max-height:80vh;overflow:auto;box-shadow:0 2px 8px rgba(0,0,0,0.2);">\n};
$index .= qq{<div style="font-weight:bold;margin-bottom:8px;">Chapters</div>\n};

for my $c (@chapters) {
    my $chapter = $c->{chapter};
    my $page    = $c->{page};
    $index .= qq{<div><a href="#$page">Chapter $chapter</a></div>\n};
}

$index .= qq{</div>\n};

# Insert right after <body ...>
if ($html =~ s{(<body\b[^>]*>)}{$1$index}i) {
    open my $out, ">", $file or die "Cannot write $file: $!";
    print $out $html;
    close $out;
    print "Added chapter index to $file\n";
} else {
    die "Could not find <body> tag in $file\n";
}
