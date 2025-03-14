#!/bin/bash

set -u

abort() {
  printf "%s\n" "$@" >&2
  exit 1
}

ACCEPTED_OS="Linux"
TARGET_DIR="${HOME}/bin"
PATH_LINK_DIR="/usr/local/bin"

# ================================================= Set OS and Architecture
# Check OS
OS="$(uname)"
if [[ "${OS}" != "${ACCEPTED_OS}" ]]
then
  abort "Install failed: this script runs on ${ACCEPTED_OS}. Please download the script for ${OS}."
fi
OS="linux"

# Check architecture
ARCH="$(/usr/bin/uname -m)"
if [[ "${ARCH}" == "aarch64" ]]
then
  echo "Arch: ARM 64"
  ARCH="arm64"
elif [[ "${ARCH}" == "amd64"  ]]
then
    echo "Arch: AMD 64"
elif [[ "${ARCH}" == "x86_64"  ]]
then
    echo "Arch: X86 64"
    ARCH="amd64"
else
  abort "Install failed: ${ARCH} architecture is not supported."
fi
# ================================================= Get Fast Version
VERSION="${1:-latest}"  # Default to latest if no version is provided

if [[ "$VERSION" == "latest" ]]; then
  # Fetch the latest Fast release from releases.fast.sh
  echo "Fetching latest Fast release..."
  VERSION=$(curl -s https://releases.fast.sh/fast/latest)

  if [[ -z "$VERSION" ]]; then
    abort "Failed to fetch the latest Fast version from releases.fast.sh."
  fi
fi

echo "Installing Fast version: $VERSION"

# ================================================= Fetch the Correct Binary from GitHub Releases
TARGET="${TARGET_DIR}/fast"
PATH_LINK="${PATH_LINK_DIR}/fast"

# Construct the new download URL
DOWNLOAD_URL="https://releases.fast.sh/fast/${VERSION}/fast-${OS}-${ARCH}"

echo "Download archive ${DOWNLOAD_URL}"
echo "Install Fast in folder: ${TARGET_DIR}"

mkdir -p "${TARGET_DIR}"
curl -L -o "${TARGET}" "${DOWNLOAD_URL}"
chmod +x "${TARGET}"

echo "----------------------------------------------------------------------------"
echo "'sudo' command is required to add Fast to path ${TARGET_DIR}"
echo "Please enter your machine password to link"
sudo ln -sf ${TARGET} ${PATH_LINK}

echo "----------------------------------------------------------------------------"
echo "Setup auto-complete"

# Create ~/.fast directory if not exists
mkdir -p ~/.fast/
rm -f ~/.fast/complete.sh
# Correct URL for downloading the completion script
COMPLETE_URL="https://releases.fast.sh/install/complete.sh"
curl -fsSL -o ~/.fast/complete.sh "${COMPLETE_URL}"

# Ensure file was downloaded successfully
if [[ ! -s ~/.fast/complete.sh ]]; then
  abort "Failed to download Fast auto-completion script!"
fi

# Add to shell configuration if not already added
grep -qxF 'source ~/.fast/complete.sh' ~/.zshrc || echo 'source ~/.fast/complete.sh' >> ~/.zshrc
grep -qxF 'source ~/.fast/complete.sh' ~/.bashrc || echo 'source ~/.fast/complete.sh' >> ~/.bashrc
source ~/.fast/complete.sh

echo "----------------------------------------------------------------------------"
echo "Fast version $VERSION is installed. Run 'fast help' for usage."
