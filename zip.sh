#!/bin/bash

# Function to handle copying and zipping
copy_and_zip() {
    local files_to_copy=("$@")
    local anykernel_files=("$anykernel/Image" "$anykernel/dtbo.img" "$anykernel/dtb.img")

    # Remove existing files if they exist
    for file in "${anykernel_files[@]}"; do
        if [[ -f $file ]]; then
            rm -f "$file"
        fi
    done

    # Copy new files
    echo "Copying files to $anykernel dir..."
    cp -f "${files_to_copy[@]}" $anykernel
    echo -e ${LGR}"Successful copying files..." ${NC}

    # Create zip file
    echo "Making zip file..."
    cd "$anykernel" && zip -r "$kernel_name-$(date +"%Y%m%d").zip" *
    echo -e ${LGR}"Success! output is on $anykernel" ${NC}
}

kernel_name="GrimoireKernel" # Change to your kernel name.
anykernel="../AnyKernel3" # Change this based on your AnyKernel directory.
out="out/arch/arm64/boot"

NC='\033[0m'
LRD='\033[1;31m'
LGR='\033[1;32m'

# Check for necessary files and call the function accordingly
if [[ -f $out/Image && -f $out/dtbo.img && -f $out/dtb.img ]]; then
    copy_and_zip "$out/Image" "$out/dtbo.img" "$out/dtb.img"
elif [[ -f $out/Image && -f $out/dtbo.img ]]; then
    copy_and_zip "$out/Image" "$out/dtbo.img"
else
    echo ${LRD}"Images not found, Aborting..." ${NC}
fi