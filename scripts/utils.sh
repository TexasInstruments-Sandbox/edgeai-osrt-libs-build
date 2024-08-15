#!/bin/bash

# config file path
config_file="$WORK_DIR/scripts/config.yaml"

# Function to get a value from the YAML file
get_yaml_value() {
    local repo=$1
    local key=$2

    # Extract the value using yq
    value=$(yq e ".${repo}.${key}" "$config_file")
    echo "$value"
}

# Function to extract repository information from the YAML file
extract_repo_info() {
    local repo=$1

    repo_url=$(yq e ".${repo}.url" "$config_file")
    repo_tag=$(yq e ".${repo}.tag" "$config_file")
    repo_branch=$(yq e ".${repo}.branch" "$config_file")
    repo_commit=$(yq e ".${repo}.commit" "$config_file")

    echo "repo_url: $repo_url"
    echo "repo_tag: $repo_tag"
    echo "repo_branch: $repo_branch"
    echo "repo_commit: $repo_commit"
}

# Function to clone a repository based on the tag value
# Usage: clone_repo "$repo_url" "$tag" "$branch" "$commit" "$repo_name"
clone_repo() {
    local repo_url=$1
    local tag=$2
    local branch=$3
    local commit=$4
    local repo_name=$5

    if [[ "$tag" == "None" || -z "$tag" ]]; then
        # clone the repository with the specified branch and checkout the commit
        git clone --branch "$branch" --single-branch "$repo_url" "$repo_name"
        cd "$repo_name" || exit
        git checkout "$commit"
        cd -
    else
        # clone the repository with the specified tag
        git clone --branch "$tag" --depth 1 --single-branch "$repo_url" "$repo_name"
    fi
}
