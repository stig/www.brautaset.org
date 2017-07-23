#!/usr/local/bin/fish

set -gx AWS_PROFILE stig
aws s3 sync \
    --acl public-read \
    --exclude '.DS_Store' \
    ~/public_html/ s3://www.superloopy.io
