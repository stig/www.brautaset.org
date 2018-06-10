#!/usr/local/bin/fish

set -gx AWS_PROFILE stig

set TTL   86400    # 1 day

aws s3 sync \
    --delete \
    --exclude '*' \
    --include '*.png' \
    --include '*.pdf' \
    --include '*.jpg' \
    --include '*.html' \
    --include '*.css' \
    --include '*.xml' \
    --acl public-read \
    --cache-control "max-age=$TTL" \
    ~/public_html/ s3://www.brautaset.org

# Invalidate CloudFront cache when uploading new files
aws cloudfront create-invalidation \
    --distribution-id E2HQ2C8QF1FXUZ \
    --paths '/*'
