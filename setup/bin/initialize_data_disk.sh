#!/bin/bash
#Modified https://gist.github.com/trentmswanson/9c22bb71182e982bd36f to explicitly accept a disk and mount point.

usage() {
    echo "Usage: $(basename $0) <new disk> <mount point>"
    echo "Example: $(basename $0) /dev/sdc /hadoop"
    echo "(remember: lun:0->disk:sdc, 1->d, ...)"
}

add_to_fstab() {
    UUID=${1}
    MOUNTPOINT=${2}
    grep "${UUID}" /etc/fstab >/dev/null 2>&1
    if [ ${?} -eq 0 ];
    then
        echo "Not adding ${UUID} to fstab again (it's already there!)"
    else
        LINE="UUID=\"${UUID}\"\t${MOUNTPOINT}\text4\tnoatime,nodiratime,nodev,noexec,nosuid\t1 2"
        echo -e "${LINE}" >> /etc/fstab
    fi
}

is_partitioned() {
# Checks if there is a valid partition table on the
# specified disk
    OUTPUT=$(sfdisk -l ${1} 2>&1)
    grep "No partitions found" "${OUTPUT}" >/dev/null 2>&1
    return "${?}"       
}

has_filesystem() {
    DEVICE=${1}
    OUTPUT=$(file -L -s ${DEVICE})
    grep filesystem <<< "${OUTPUT}" > /dev/null 2>&1
    return ${?}
}

do_partition() {
# This function creates one (1) primary partition on the
# disk, using all available space
    DISK=${1}
    echo "n
p
1


w"| fdisk "${DISK}" > /dev/null 2>&1

#
# Use the bash-specific $PIPESTATUS to ensure we get the correct exit code
# from fdisk and not from echo
if [ ${PIPESTATUS[1]} -ne 0 ];
then
    echo "An error occurred partitioning ${DISK}" >&2
    echo "I cannot continue" >&2
    exit 2
fi
}

if [ -z "${1}" ];
then
    usage
    exit 1
else
    DISK=("${1}")
fi
if [ -z "${2}" ];
then
    usage
    exit 1
else
    MOUNTPOINT=("${2}")
fi

echo "Working on ${DISK}"
is_partitioned ${DISK}
if [ ${?} -ne 0 ]; then
    echo "${DISK} is not partitioned, partitioning"
    do_partition ${DISK}
fi
PARTITION=$(fdisk -l ${DISK}|grep -A 1 Device|tail -n 1|awk '{print $1}')
has_filesystem ${PARTITION}
if [ ${?} -ne 0 ]; then
    echo "Creating filesystem on ${PARTITION}."
    #echo "Press Ctrl-C if you don't want to destroy all data on ${PARTITION}"
    #sleep 5
    mkfs -j -t ext4 ${PARTITION}
fi
echo "Mount point appears to be ${MOUNTPOINT}"
[ -d "${MOUNTPOINT}" ] || mkdir "${MOUNTPOINT}"
read UUID FS_TYPE < <(blkid -u filesystem ${PARTITION}|awk -F "[= ]" '{print $3" "$5}'|tr -d "\"")
add_to_fstab "${UUID}" "${MOUNTPOINT}"
echo "Mounting disk ${PARTITION} on ${MOUNTPOINT}"
mount "${MOUNTPOINT}"
