#!/usr/local/bin/fish

set -gx AWS_PROFILE stig

set HTML_TTL 1800       # 30 minutes
set ASSETS_TTL 31536000 # 1 year

# Copy non-HTML; assets, images, etc, that don't change often
aws s3 sync \
    --delete \
    --exclude '.DS_Store' \
    --exclude '*.html' \
    --exclude '.venv' \
    --acl public-read \
    --cache-control "max-age=$ASSETS_TTL" \
    ~/public_html/ s3://www.superloopy.io

# Copy HTML; this changes often, so use shorter TTL
aws s3 sync \
    --delete \
    --exclude '*' \
    --include '*.html' \
    --acl public-read \
    --cache-control "max-age=$HTML_TTL" \
    ~/public_html/ s3://www.superloopy.io
