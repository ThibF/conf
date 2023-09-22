#!/bin/sh -eu
#

pr_error()
{
    echo "\e[31m${*}\e[0m" 1>&2
}

pr_note()
{
    echo "\e[32m${*}\e[0m"
}

pr_info()
{
    echo "\e[33m${*}\e[0m"
}

usage()
{
    cat <<EOF
Usage: setup_services.sh [-u|-s] SERVICE_NAME


Positional arguments:
  SERVICE_NAME  Name of the systemd service to create

Optional arguments:
  -u, --user               Create user service.
  -s, --system             Create system service.
  -h, --help               Show this help message and exit.

Examples:
  TODODO

EOF
    exit 2
}

dry_run=""
type="system"
path=

while [ "${#}" -gt 0 ] ; do
        case "${1}" in
                -s|--system)
                    type="system"
                  ;;
                -u|--dry-run)
                    type="user"
                    ;;
                -h|--help)
                    usage
                    ;;
                *)
                    if [ -n "${path:-}" ] ; then
                            usage
                    fi
                    path=${1}
                    ;;
        esac
        shift
done

if [ -z "${path}" ] ; then
    usage
fi

name="$(basename $path)"
tmp="$(mktemp -p /tmp $name.service.XXXX)"

if [ $type = "system" ]; then
    cat << EOF > $tmp
[Unit]
Description=HERE

[Service]
ExecStart=${path}

[Install]
WantedBy=multi-user.target
EOF

    nano $tmp


    echo "To finish installation, do:"
    echo "sudo cp $tmp /lib/systemd/system/$name.service"
    echo "sudo systemctl daemon-reload"
    echo "sudo systemctl enable $name.service"
    echo "sudo systemctl start $name.service"
else 
    cat << EOF > $tmp
[Unit]
Description=HERE

[Service]
ExecStart=${path}

[Install]
WantedBy=default.target
EOF

    nano $tmp
    mkdir -p /home/${USER}/.config/systemd/user

    echo "To finish installation, do:"
    echo "cp $tmp /home/${USER}/.config/systemd/user/$name.service"
    echo "systemctl --user daemon-reload"
    echo "systemctl --user enable $name.service"
    echo "systemctl --user start $name.service"
fi

