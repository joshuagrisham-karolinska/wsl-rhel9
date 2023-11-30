# Maven environment variables will be set if /opt/apache-maven exists
if [ -d "/opt/apache-maven" ]; then
    export MAVEN_HOME=/opt/apache-maven
    export M2_HOME=$MAVEN_HOME
    export M2=$M2_HOME/bin
fi

# If this is a WSL environment and MAVEN_SETTINGS is set, then try to use it
if [ -n "${WSLENV-}" ]; then # If WSL
    if [ -n "${MAVEN_SETTINGS-}" ]; then # If MAVEN_SETTINGS has been set
        if [ -f "${MAVEN_SETTINGS}" ]; then # If the value of MAVEN_SETTINGS actually resolves to a file
            # Set MAVEN_ARGS to always use the file indicated at MAVEN_SETTINGS
            MAVEN_ARGS="--settings $MAVEN_SETTINGS"
            export MAVEN_ARGS
            # always try to copy the mounted file to our local home for use in other scenarios (mount to dev containers, etc)
            mkdir -p ~/.m2 && /bin/cp --force $MAVEN_SETTINGS ~/.m2/settings.xml
        fi
    fi
fi
