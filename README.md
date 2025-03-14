# Fast CLI Installer
These scripts install the **Fast CLI** on macOS and Linux by downloading the latest or a specified version from **Fast Releases**. The installation automatically detects your architecture (`arm64` or `amd64`), configures auto-completion, and ensures the binary is properly linked for easy access.

##  Features
- Automatically detects **MacOS or Linux architecture** (`arm64` or `amd64`).
- Installs the **latest Fast release** or a **specified version**.
- Downloads Fast binaries directly from **[Fast Releases](https://releases.fast.sh/)**.
- **Sets up auto-completion** for Fast commands.
- Ensures installation is properly linked in **`/usr/local/bin`**.
- Can be used in CI/CD pipelines for automation.


##  Installation
### **macOS Installation**
### **Download the Script**
```sh
curl -fsSL -o install_fast_macos.sh https://raw.githubusercontent.com/Obornes/install-fast/main/install_fast_macos.sh
```

### **Make It Executable**
```sh
chmod +x install_fast_macos.sh
```

### **Run the Installer**
Install the Latest Version
```sh
/bin/bash install_fast_macos.sh
```

Install a Specific Version
```sh
/bin/bash install_fast_macos.sh 0.5.6-beta
```


### **Linux Installation**
### **Download the Script**
```sh
curl -fsSL -o install_fast_macos.sh https://raw.githubusercontent.com/Obornes/install-fast/main/install_fast_linux.sh
```

### **Make It Executable**
```sh
chmod +x install_fast_linux.sh
```

### **Run the Installer**
Install the Latest Version
```sh
/bin/bash install_fast_linux.sh
```

Install a Specific Version
```sh
/bin/bash install_fast_linux.sh 0.5.6-beta
```


##  Usage
After installation, you can verify the installation by running:

```sh
fast self:version
```

If the Fast CLI is installed correctly, it will display the installed version.


## CI/CD Integration
To use Fast CLI in a GitHub Actions CI/CD pipeline, update your workflow file as follows:

Example GitHub Actions Workflow

```sh
name: CI/CD

on:
  pull_request:
    branches:
      - 'main'

env:
  DOCKER_CLI_EXPERIMENTAL: enabled
  FAST_VERSION: "0.5.6-beta"  # Change this to the desired version or leave it empty or with word "latest" for the latest version

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Set Up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - uses: actions/checkout@v4

      - name: Download and Install Fast (Specific Version)
        run: |
          curl -fsSL -o /usr/local/bin/install_fast_linux.sh https://raw.githubusercontent.com/Obornes/install-fast/main/install_fast_linux.sh
          chmod +x /usr/local/bin/install_fast_linux.sh
          /bin/bash /usr/local/bin/install_fast_linux.sh $FAST_VERSION

      - name: Verify Fast Installation
        run: fast self:version  # Should print 0.5.5-beta

```

##  Troubleshooting

### **Fast version**
Check the Fast Releases page: **[GitHub Releases](https://github.com/fastsh/interpreter/releases)** or **[Fast Releases](https://releases.fast.sh/)**
Verify the version: Ensure the requested version exists.


### **Auto-Completion Script**
#### Error: "Failed to download Fast auto-completion script!"
The auto-completion script URL might be incorrect or unavailable.

#### Try downloading it manually:

```sh
curl -fsSL -o ~/.fast/complete.sh https://releases.fast.sh/install/complete.sh
```