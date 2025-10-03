#!/bin/bash

# Default values
num_dirs=10
num_files=100
target_dir="test"
data_percentage=50
identical_percentage=20
file_size="1M"

while getopts ":d:f:t:p:u:s:" opt; do
  case $opt in
    d) num_dirs="$OPTARG"
      ;;
    f) num_files="$OPTARG"
      ;;
    t) target_dir="$OPTARG"
      ;;
    p) data_percentage="$OPTARG"
      ;;
    u) identical_percentage="$OPTARG"
      ;;
    s) file_size="$OPTARG"
      ;;
    h) echo "Usage: $0 [-d num_dirs] [-f num_files] [-t target_dir] [-p data_percentage] [-u identical_percentage] [-s file_size]"
       echo "-d: Number of directories to create (default 10)"
       echo "-f: Number of files per directory (default 100)"
       echo "-t: Target directory where the directories will be created (default 'test')"
       echo "-p: Percentage of files that should contain data (default 50)"
       echo "-u: Percentage of identical files in each directory (default 20)"
       echo "-s: Size of each file (default '1M'). Use K, M or G for kilobytes, megabytes and gigabytes respectively."
       exit 0
      ;;
    \?) echo "Invalid option -$OPTARG" >&2
        exit 1
      ;;
  esac
done

# Calculate the number of files with identical data
num_identical=$(( num_files * identical_percentage / 100 ))

# Calculate the number of files with data
num_data=$(( num_files * data_percentage / 100 ))

echo "This will create $num_dirs directories inside '$target_dir', each containing $num_files files."
read -p "Type 'execute' to proceed: " confirmation

if [[ "$confirmation" != "execute" ]]; then
    echo "Operation cancelled."
    exit 1
fi

# Create the base directory
mkdir -p "$target_dir"

# Create directories efficiently
eval mkdir -p "$target_dir"/f{1.."$num_dirs"}

# Use xargs to parallelize file creation
export num_files
find "$target_dir" -mindepth 1 -maxdepth 1 -type d | parallel -j10 bash -c '
    for ((i=1; i<='"$num_files"'; i++)); do
        if (( i <= '"$num_identical"' )); then
            fallocate -l $(( '"${file_size%?}"' * 1024 * 1024 )) {}/file$i
        elif (( i <= '"$num_data"' )); then
            openssl rand -out {}/file$i $(( '"${file_size%?}"' * 1024 * 1024 ))
        fi
    done
'

echo "Created $num_dirs directories in '$target_dir', each containing $num_files files."
