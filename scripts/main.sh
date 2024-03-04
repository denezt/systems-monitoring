#!/bin/bash -x

# Update
# Iterate all scripts
system_monitoring(){
    SCRIPT_DIR="./scripts"
    SCRIPT_LIST=($(find "${SCRIPT_DIR}" -type f -name '*.sh' | egrep -v 'main.sh' ))
    for script in ${SCRIPT_LIST[*]};
    do
        printf "Execute: ${script}\n"
        source ${script}
    done
}

# Main Method
main(){
    echo "PWD: $(pwd)"
    printf "Starting, System Monitoring...\n"
    # system_monitoring
}

main