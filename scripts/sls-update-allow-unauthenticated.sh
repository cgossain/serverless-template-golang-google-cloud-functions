#!/bin/bash

# Get a list of functions in the serverless.yml file and format as args
functions=$(sls print --path functions --transform keys --format text | xargs)

# Sort functions as public and private
pub=()
prv=()
for fn in ${functions[@]}; do
    # if the `allowUnauthenticated: true` flag is defined for the function flag it to be made public
    if [[ "$(sls print --path functions."$fn" --format yaml | xargs)" == *"allowUnauthenticated: true"* ]]; then
        pub+=($fn)
    else
        prv+=($fn)
    fi
done

# Run the mkfunc-pub command for each public function
for fn in ${pub[@]}; do
    echo "Making function \""$fn"\" public..."
    npx sls mkfunc-pub --function="$fn"
done

# Run the mkfunc-pvt command for each private function
for fn in ${prv[@]}; do
    echo "Making function \""$fn"\" private..."
    npx sls mkfunc-pvt --function="$fn"
done