#!/usr/bin/env raku

use LibCurl::Easy;

my %pbf; # see BEGIN {}

my $key      = '';
my $scripts  = 0;
my $show     = 0;
my $all      = 0;
if !@*ARGS {
    print qq:to/HERE/;
    Usage: {$*PROGRAM.basename} <osm map choice> [...options...]
      where choices are (use first two chars):
    HERE
    say "    $_" for %pbf.keys.sort;
    say qq:to/HERE/;
    Options:
      show [choice] - show data about the choice
      scripts       - create bash scripts for downloading
                      and importing

    For example, create scripts for North American data:
      
      \$ {$*PROGRAM.basename} sc no

    HERE
    exit;
}

for @*ARGS {
    when /^ :i sh/ { $show = 1; $scripts = 0 }
    when /^ :i sc/ { $show = 0; $scripts = 1 }
    when /^ :i al/ { $all = 1 }

    when /^ :i wo/ { $key = 'world' }
    when /^ :i af/ { $key = 'africa' }
    when /^ :i an/ { $key = 'antarctica' }
    when /^ :i as/ { $key = 'asia' }
    when /^ :i au/ { $key = 'australia' }
    when /^ :i ce/ { $key = 'central-america' }
    when /^ :i eu/ { $key = 'europe' }
    when /^ :i no/ { $key = 'north-america' }
    when /^ :i sa/ { $key = 'south-america' }
    default {
        note "FATAL: Unknown arg '$_'";
        exit;
    }
}

if !$key {
    note "No country selected.";
}

if $show {
    if $key {
        say "Country: $key";
        for %pbf{$key}.keys.sort -> $k {
            my $v = %pbf{$key}{$k};
            say "  $k: '$v'";
        }
    }
    elsif $all {
        for %pbf.keys.sort -> $key {
            say "Country: $key";
            for %pbf{$key}.keys.sort -> $k {
                my $v = %pbf{$key}{$k};
                say "  $k: '$v'";
            }
        }
    }
    exit;
}

if $scripts && $key {
    # write bash scripts to do the work

    my $url1 = %pbf{$key}<pbf>;
    my $url2 = %pbf{$key}<md5>;
    my $url3 = %pbf{$key}<shape>;

    my $fil1 = get-file-from-url $url1;
    # name the scripts after the pbf file
    #   planet-latest.osm.pbf => planet-latest
    my $basename = get-basename $fil1;
    my $snam = 'get-' ~ $basename ~ '.sh';

    # the other files
    my $fil2 = get-file-from-url $url2;
    my $fil3 = get-file-from-url $url3;

    # build scripts
    # getter
    my $fh = open $snam, :w;
    $fh.say: qq:to/HERE/;
    #!/bin/bash
    if [[ -z \$1 ]] ; then
        echo "Usage: go"
        echo "  Gets pbf file and friends from:"
        echo "      $url1"
        exit
    fi
    echo "Downloading '$fil1'"
    curl --output $fil1 $url1
    echo "See local file: $fil1"
    echo "Downloading '$fil2'"
    curl --output $fil2 $url2
    echo "See local file: $fil2"
    HERE

    if $fil3 {
       $fh.say: qq:to/HERE/;
       echo "Downloading '$fil3'"
       curl --output $fil3 $url3
       echo "See local file: $fil3"
       HERE
    }

    $fh.close;
    shell "chmod +x $snam";
    say "See output file: $snam";

    # now build an import script =================
    build-import-script $basename;

}

sub build-import-script($basename) {
    # script name
    my $snam = 'import-' ~ $basename ~ '.sh';
    # file name
    my $fnam = $basename ~ '.osm.pbf';

    my $fh = open $snam, :w;
    $fh.say: qq:to/HERE/;
    #!/bin/bash
    if [[ -z \$1 ]] ; then
        echo "Usage: go"
        echo "  Imports pbf file:"
        echo "      $fnam"
        exit
    fi
    HERE

    # set run params
    my $cache-size = 3600; # Mb
    my $style-file = 'openstreetmap-carto-2.41.0/openstreetmap-carto.style';
    $fh.say: qq:to/HERE/;
    osm2pgsql --slim -d gis -C $cache-size  --hstore \\
        -S $style-file \\
        $fnam
    HERE

=begin comment
  osm2pgsql --slim -d gis -C 3600 --hstore \
     -S openstreetmap-carto-2.41.0/openstreetmap-carto.style \
     planet-latest.osm.pbf

osm2gpsql will run in slim mode which is recommended over the normal
mode. The '-d' is short for '--database'. The '-C' flag specifys the
cache size in MB. Bigger cache size results in faster import speed but
you need to have enough RAM to use cache. The '-S' flag specifies the
style file. And, finally, you need to specify the map data file.
=end comment

    $fh.close;
    shell "chmod +x $snam";
    say "See output file: $snam";
}

sub build-get-script() {
}

sub get-basename($s) {
    # $s is a file name formatted: 'some-area.osm.pbf'
    my $bnam = '';
    return $bnam if !$s;
    # strip off the end
    my $idx = rindex $s, '.osm.pbf';
    if $idx.defined {
        $bnam = $s.substr: 0, $idx;
    }
    return $bnam;
}

sub get-file-from-url($url) {
    my $fil = '';
    return $fil if !$url;
    my $idx = rindex $url, '/';
    if $idx.defined {
        $fil = $url.substr: $idx+1;
    }
    else {
        die "FATAL: URL '$url' format not recognized.";
    }
    return $fil;
}


=begin comment
    curl --output $PBFLOCAL $PBF
=end comment

BEGIN {
    %pbf = %(
        world => {
            pbf   => 'https://ftpmirror.your.org/pub/openstreetmap/pbf/planet-latest.osm.pbf',
            md5   => 'https://ftpmirror.your.org/pub/openstreetmap/pbf/planet-latest.osm.pbf.md5',
            shape => 'https://planet.openstreetmap.org/historical-shapefiles/processed_p.tar.bz2',
            size  => '52 Gb',
        },
        africa => {
            pbf   => 'http://download.geofabrik.de/africa-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/africa-latest.osm.pbf.md5',
            shape => '',
            size  => '3.9 Gb',
        },
        antarctica => {
            pbf   => 'http://download.geofabrik.de/antarctica-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/antarctica-latest.osm.pbf.md5',
            shape => '',
            size  => '0.29 Gb',
        },
        asia => {
            pbf   => 'http://download.geofabrik.de/asia-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/asia-latest.osm.pbf.md5',
            shape => '',
            size  => '8.2 Gb',
        },
        australia => {
            pbf   => 'http://download.geofabrik.de/australia-oceania-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/australia-oceania-latest.osm.pbf.md5',
            shape => '',
            size  => '0.788 Gb',
        },
        central-america => {
            pbf   => 'http://download.geofabrik.de/central-america-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/central-america-latest.osm.pbf.md5',
            shape => '',
            size  => '0.381 Gb',
        },
        europe => {
            pbf   => 'http://download.geofabrik.de/europe-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/europe-latest.osm.pbf.md5',
            shape => '',
            size  => '21.7 Gb',
        },
        north-america => {
            pbf   => 'http://download.geofabrik.de/north-america-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/north-america-latest.osm.pbf.md5',
            shape => '',
            size  => '9.3 Gb',
        },
        south-america => {
            pbf   => 'http://download.geofabrik.de/south-america-latest.osm.pbf',
            md5   => 'http://download.geofabrik.de/south-america-latest.osm.pbf.md5',
            shape => '',
            size  => '2.0 Gb',
        },

        # https://download.geofabrik.de/index-v1-nogeom.json

    );
}

=finish
