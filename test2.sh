#!/bin/bash

xinput test-xi2 --root | perl -lne '
  BEGIN{$"=",";
    open X, "-|", "xmodmap -pke";
    while (<X>) {$k{$1}=$2 if /^keycode\s+(\d+) = (\w+)/}
    open X, "-|", "xmodmap -pm"; <X>;<X>;
    while (<X>) {if (/^(\w+)\s+(\w*)/){($k=$2)=~s/_[LR]$//;$m[$i++]=$k||$1}}
    close X;
  }
  if (/^EVENT type.*\((.*)\)/) {$e = $1}
  elsif (/detail: (\d+)/) {$d=$1}
  elsif (/modifiers:.*effective: (.*)/) {
    $m=$1;
    if ($e =~ /^KeyPress/){
      my @mods;
      for (0..$#m) {push @mods, $m[$_] if (hex($m) & (1<<$_))}
      print "$e $d [$k{$d}] $m [@mods]"
    }
  }' 
