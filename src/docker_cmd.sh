set -e

# run custom entrypoint commands
for CMD in $(compgen -v ENTRYPOINT_CMD); do
    if [ -n "${!CMD}" ] ; then
        eval "${!CMD}"
    fi
done

# update cacerts
if ls /usr/local/groundwork/config/cacerts/*.pem > /dev/null 2>&1; then
    for CACERT in /usr/local/groundwork/config/cacerts/*.pem ; do
        CACERT_FILENAME=$(basename $CACERT)
        CACERT_NAME=${CACERT_FILENAME%.pem}
        echo "Update CA certs: adding $CACERT_FILENAME"
        openssl x509 -in $CACERT -noout -text
        cp $CACERT /usr/local/share/ca-certificates/${CACERT_NAME}.crt
    done
    update-ca-certificates
fi

exec "$@"
