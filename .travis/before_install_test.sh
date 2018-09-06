#!/usr/bin/env bash
set -ev

PHP_INI_DIR="$HOME/.phpenv/versions/$(phpenv version-name)/etc/conf.d/"
TRAVIS_INI_FILE="$PHP_INI_DIR/travis.ini"
echo "memory_limit=3072M" >> "$TRAVIS_INI_FILE"



sed --in-place "s/\"dev-master\":/\"dev-${TRAVIS_COMMIT}\":/" composer.json

# TODO: remove when drop PHP 5 support
# symfony/maker-bundle only works with PHP 7 and higher
if [ "${TRAVIS_PHP_VERSION:0:3}" != "5.6" ]; then
    # but only with Symfony 3.4 and higher
    if [ "$SYMFONY" != "" ]; then
        if [ "${SYMFONY:0:3}" != "2.8" ] && [ "${SYMFONY:0:3}" != "3.3" ] ; then
            composer require "symfony/maker-bundle:$" --no-update
        fi
    else
        composer require "symfony/maker-bundle:$" --no-update
    fi
fi
