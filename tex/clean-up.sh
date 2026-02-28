#!/bin/bash

set -ev

perl -0777 -Mutf8 -Mopen=:std,:utf8 -pi.bak -e '
  # nedeliteľné medzery
  # - jednopísmenové predložky
  s/\b([svzoukSVZOUKAI]) +/$1~/g;
  s/ *~[ ~]*/~/g;
  # - jednopísmenová skratka/skratky mena/mien a priezvisko
  s/\b(\p{Uppercase}\.) (?=\p{Uppercase}(\w+|\.))/$1~/g;
  # - dátumy
  s/\b([0-9]{1,2}\.) ?([0-9]{1,2}\.) ?(2[0-9]{3})\b/$1~$2~$3/g;
  # - roky
  s/\b((štvrť|pol)?rok([ayu]|om)?)\s+([12]\d{3})\b/$1~$4/g;
  s/\b(Rok)\s+([12]\d{3})\b/$1~$2/g;

  # pomlčka
  s/ - / -- /g;
  s/ – / -- /g;

  # čas do formátu 10.00~hod.
  s/\b(hod)\b([^.])/$1.$2/g;
  s/(\d)\s+(hod\.)/$1~$2/g;
  s/(\d\d?)[:,](\d\d~hod.)/$1.$2/g;

  # finančné obnosy do formátu 1~234,65~€
  s/\b(\d+) +(eur(o?)\b|€)/$1~€/gi;
  s/\b(\d+)€/$1~€/g;

  # úvodzovky a apostrofy
  my $toggle = 0;
  s/"/($toggle = !$toggle) ? "„" : "“"/ge;
  my $toggle = 0;
  s/'\''/($toggle = !$toggle) ? "‚" : "‘"/ge;

  # normalizácia prázdnych riadkov a medzier
  s/(\n*)(\\clanok\s*\{)/\n\n\n\\clanok\{/gs;
  s/(\n*)(\\autor\s*\{)/\n\\autor\{/gs;
' "$1"
