# not really needed but i want to outline my own rules to follow for when this gets really large

## server/src/ holds all of the seperate production branch repos & are listed in .gitignore seperately.

default.nix -> list which sites to actively serve.

## naming format
server/subdom-site-tld.nix -> domain name (where nginx config is stored)
    example: server/search-google-com.nix

server/src/foo (src named same as on github)

