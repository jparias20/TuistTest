#!/bin/bash

# Define paths for repositories and frameworks
repoPath="./Tuist/Dependencies/repositories"
frameworkPath="./Tuist/Dependencies/frameworks"

# Read dependencies.yml and loop through each dependency
yq e '.dependencies[]' dependencies.yml -o=json | jq -c . | while read i; do
    targetName=$(jq -r '.targetName' <<< "$i")
    repositoryURL=$(jq -r '.repositoryURL' <<< "$i")
    tag=$(jq -r '.tag' <<< "$i")

    # Define the directory to clone into and the framework directory
    cloneDir="${repoPath}/${targetName}/${tag}"
    frameworkDir="${frameworkPath}/${targetName}"

    echo "Processing ${targetName} from ${repositoryURL} at tag ${tag}"

    # Remove directories if they exist
    if [ -d "${cloneDir}" ]; then
        echo "Removing existing directory ${cloneDir}"
        rm -rf "${cloneDir}"
    fi

    if [ -d "${frameworkDir}" ]; then
        echo "Removing existing directory ${frameworkDir}"
        rm -rf "${frameworkDir}"
    fi

    # Create directories
    mkdir -p "${cloneDir}"
    mkdir -p "${frameworkDir}"

    # Clone the specific tag into the clone directory
    echo "Cloning ${repositoryURL} at tag ${tag} into ${cloneDir}"
    git clone --depth 1 --branch "${tag}" "${repositoryURL}" "${cloneDir}"

    # Assuming the repository's structure has a zipped .xcframework at the root
    zipFileName="${targetName}-${tag}.zip"

    # Check if zip file exists and unzip it into the framework directory
    if [ -f "${cloneDir}/${zipFileName}" ]; then
        echo "Unzipping ${zipFileName} into ${frameworkDir}"
        unzip -o "${cloneDir}/${zipFileName}" -d "${frameworkDir}"
        mv "${frameworkDir}/${targetName}-${tag}/${targetName}.xcframework" "${frameworkDir}"
        rm -rf "${frameworkDir}/${targetName}-${tag}"
    else
        echo "No zip file (${zipFileName}) found in the cloned repository"
    fi

    echo "${targetName} processed successfully"
done

echo "All dependencies have been processed."

rm -rf "$repoPath"