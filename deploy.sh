#!/bin/bash

SSH_ALIAS=beats

mix deps.get --only prod
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix release

rsync -rv _build/prod beats:~/

ssh $SSH_ALIAS '
  export DATABASE_URL=ecto://postgres:postgres@localhost/channeled_beats_v1_prod &&
  export SECRET_KEY_BASE=`openssl rand -base64 256` &&
  (cd ~/prod/rel/channeled_beats/bin/ && ./migrate && ./channeled_beats stop; sleep 1; ./channeled_beats daemon)'
