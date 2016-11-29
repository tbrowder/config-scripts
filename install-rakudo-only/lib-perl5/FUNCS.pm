package FUNCS;

use LWP;

sub strip_comment {
  my $line                  = shift @_;
  my $check_first_char_only = shift @_;
  $check_first_char_only = 0 if (! defined $check_first_char_only);

  if ($check_first_char_only) {
    if ((substr $line, 0, 1) eq '#') {
      $line = '';
    }
  }
  else {
    $line =~ s{\A ([^\#]*) \# [\s\S]* \z}{$1}x;
  }

  return $line;
} # strip_comment

sub get_latest_release {
}
