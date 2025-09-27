#!/bin/bash

set -ev

perl -0777 -Mutf8 -Mopen=:std,:utf8 -pi.bak -e '
  # nedeliteľné medzery
  # - jednopísmenové predložky
  s/[ (]([svzoukSVZOUKAI]) +/ $1~/g;
  s/~ +/~/g;
  # - jednopísmenová skratka mena a priezvisko
  s/\b(\p{Uppercase}\.) (\p{Uppercase}\w+)/$1~$2/g;
  # - dátumy
  s/\b([0-9]{1,2}\.) ?([0-9]{1,2}\.) ?(2[0-9]{3})\b/$1~$2~$3/g;

  # pomlčka
  s/ - / -- /g;
  s/ – / -- /g;

  # čas do formátu 10.00~hod.
  s/\b(hod)\b([^.])/$1.$2/g;
  s/(\d)\s+(hod\.)/$1~$2/g;
  s/(\d\d?)[:,](\d\d~hod.)/$1.$2/g;

  # finančné obnosy do formátu 1~234,65~€
  s/(\d+(,\d\d?)?) eur/$1~€/gi;
  s/(\d) €/$1~€/g;
  s/([^\~])€/$1~€/g;

  # úvodzovky a apostrofy
  my $toggle = 0;
  s/"/($toggle = !$toggle) ? "„" : "“"/ge;
  my $toggle = 0;
  s/'\''/($toggle = !$toggle) ? "‚" : "‘"/ge;

  # normalizácia prázdnych riadkov a medzier
  s/(\n*)(\\clanok\s*\{)/\n\n\n\\clanok\{/gs;
  s/(\n*)(\\autor\s*\{)/\n\\autor\{/gs;
' $1
