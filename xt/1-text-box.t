use Test;

use PDF::API6; # <== required for $page
use PDF::Content;	
use PDF::Font::Loader :load-font;
use PDF::Lite;
use PDF::Content::Text::Box;

use Font::Utils;
use Font::Utils::Misc;

my $debug = 0;

my $file = "/usr/share/fonts/opentype/freefont/FreeSerif.otf";
my PDF::Lite $pdf .= new;
my $page = $pdf.add-page;

my ($width, $font, $text, $font-size);

$font-size = 12;
$width     = 8.5*72;
$font      = load-font :$file;

# a reusable text box:  with filled text
my PDF::Content::Text::Box $tb .= new(
    :text(""), 
    # <== note font information is rw
    :$font, :$font-size,
    :align<left>, 
    :$width);

isa-ok $tb, PDF::Content::Text::Box;
is $tb.width, 8.5*72;
is $tb.height, 13.2;
is $tb.leading, 1.1, "leading: {$tb.leading}";
is $tb.font-height, 17.844, "font-height: {$tb.font-height}";

#$tb = text-box $text, :$font, :width(6.5*72);

#=begin comment
# render
my $g = $page.gfx;
$g.Save;
$g.BeginText;
$g.text-position = [72, 10*72];
#$g.set-text("Good night!");
$g.print: $tb;
$g.say();

my @c = @(%uni<L-chars>);
my $c = hex2string @c;
$c ~= $c;
# break the string into individual chars
$c = $c.comb.join("| ");

#:$o = text-box $c, :$font, :width(6.5*72);
$g.print: $tb;
$g.EndText;
$g.Restore;
say "text: ", $c;
say "text-box width: ", $tb.width;
say "text-box content-width: ", $tb.content-width;
say "text-box height: ", $tb.height;
say "text-box content-height: ", $tb.content-height;
#my @lines = @($o.Str.lines);
my @lines = @($tb.lines);
#my @lines = @($tb.lines.Str); #.text;
say "text-box lines:";
say " {$_.text}" for @lines;
#say "text box:", $o;

$pdf.save-as: "xt-test1.pdf";

my $para1 = qq:to/HERE/;
HERE

my $para2 = qq:to/HERE/;
HERE


#say $o.content-width;
#say $o.content-height;
#=end comment

done-testing;
