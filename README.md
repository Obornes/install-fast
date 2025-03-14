# Fast CLI Installer

These scripts install the **Fast CLI** on macOS and linux by downloading the latest or a specified version from **GitHub Releases**. It ensures the correct architecture (`arm64` or `amd64`) and sets up auto-completion.

##  Features
- Automatically detects **Mac or linux architecture** (`arm64` or `amd64`).
- Installs the **latest Fast release** or a **specified version**.
- Downloads Fast binaries directly from **[GitHub Releases](https://github.com/fastsh/interpreter/releases)**.
- **Sets up auto-completion** for Fast commands.
- Ensures installation is properly linked in **`/usr/local/bin`**.

##  Installation

### **Download the Script**
```sh
curl -fsSL -o install_fast_macos.sh https://your-script-host.com/install_fast_macoos.sh
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

##  Usage
After installation, you can verify the installation by running:

```sh
fast self:version
```

If the Fast CLI is installed correctly, it will display the installed version.


##  Troubleshooting

### **Fast version**
Check the Fast Releases page: **[GitHub Releases](https://github.com/fastsh/interpreter/releases)**
Verify the version: Ensure the requested version exists.


### **Auto-Completion Script**
#### Error: "Failed to download Fast auto-completion script!"
The auto-completion script URL might be incorrect or unavailable.

#### Try downloading it manually:


```sh
curl -fsSL -o ~/.fast/complete.sh https://releases.fast.sh/install/complete.sh
```