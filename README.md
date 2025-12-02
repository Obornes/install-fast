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

#### **1. Download the Script**
```sh
curl -fsSL -o install_fast_macos.sh https://raw.githubusercontent.com/Obornes/install-fast/main/install_fast_macos.sh
```

#### **2. Make It Executable**
```sh
chmod +x install_fast_macos.sh
```

#### **3. Run the Installer**

Install the Latest Version:
```sh
/bin/bash install_fast_macos.sh
```

Install a Specific Version:
```sh
/bin/bash install_fast_macos.sh 0.5.6-beta
```

#### **4. Add Fast to PATH**
```sh
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
```

#### **5. Fix zsh Auto-completion**

Since macOS uses **zsh** by default and the completion script is for **bash**, you need to enable bash completion compatibility.

Open your `~/.zshrc` file:
```sh
nano ~/.zshrc
```

Add these lines **before** the `source ~/.fast/complete.sh` line:
```sh
# Enable bash completion compatibility in zsh
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

# Now source the Fast completion script
source ~/.fast/complete.sh
```

Save and reload your shell configuration:
```sh
source ~/.zshrc
```

### **Linux Installation**

#### **1. Download the Script**
```sh
curl -fsSL -o install_fast_linux.sh https://raw.githubusercontent.com/Obornes/install-fast/main/install_fast_linux.sh
```

#### **2. Make It Executable**
```sh
chmod +x install_fast_linux.sh
```

#### **3. Run the Installer**

Install the Latest Version:
```sh
/bin/bash install_fast_linux.sh
```

Install a Specific Version:
```sh
/bin/bash install_fast_linux.sh 0.5.6-beta
```

#### **4. Add Fast to PATH** (if needed)
```sh
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

##  GitHub Configuration

To use Fast with private repositories, you need to configure GitHub access.

### **1. Create a GitHub Personal Access Token (PAT)**

1. Go to **GitHub → Settings → Developer Settings → Personal Access Tokens → Tokens (classic)**
2. Click **"Generate new token (classic)"**
3. Give it a name (e.g., "Fast CLI")
4. Select the following scopes:
   - **`repo`** (Full control of private repositories)
   - **`admin:org`** (Read and write org and team membership)
5. Click **"Generate token"** and **copy the token** (you won't see it again!)

### **2. Configure Fast with Your GitHub Token**

Create the Fast configuration directory and file:
```sh
mkdir -p ~/.fast/config
cd ~/.fast/config
touch fast.yaml
nano fast.yaml
```

Add the following configuration (replace `XXXXXXXXXXXXXXXX` with your actual PAT):
```yaml
store:
  sources:
    - type: github
      url: https://github.com
      credentials:
        personal_access_token: XXXXXXXXXXXXXXXX
```

Save and exit (`Ctrl+O`, `Enter`, `Ctrl+X` in nano).

### **3. Install Fast Packages**

In a repository with a `Fastfile` in its root, run:
```sh
fast self:install
```

### **4. SSO Authorization (for Organization Repositories)**

If you're accessing repositories in an organization (e.g., **obornes**):

1. Go to **GitHub → Settings → Developer Settings → Personal Access Tokens**
2. Find your token and click **"Configure SSO"**
3. Click **"Authorize"** next to the organization (e.g., **obornes**)

**Note:** You need to reconfigure SSO authorization after creating or regenerating your PAT to grant your Personal Access Token access to the organization.

##  Usage

After installation, you can verify the installation by running:
```sh
fast self:version
```

If the Fast CLI is installed correctly, it will display the installed version.

##  Updating Packages

After modifying a source package, you need to reinstall it:
```sh
fast self:install
```

This command will update all packages from the configured sources.

## CI/CD Integration

To use Fast CLI in a GitHub Actions CI/CD pipeline, update your workflow file as follows:

### Example GitHub Actions Workflow
```yaml
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
        run: fast self:version  # Should print the installed version
```

##  Troubleshooting

### **Fast Version**
- Check the Fast Releases page: **[GitHub Releases](https://github.com/fastsh/interpreter/releases)** or **[Fast Releases](https://releases.fast.sh/)**
- Verify the version: Ensure the requested version exists.

### **Auto-Completion Issues on macOS**

#### Error: "command not found: complete"
This happens because macOS uses **zsh** by default, but the completion script is for **bash**.

**Solution:** Add bash completion compatibility to your `~/.zshrc`:
```sh
# Enable bash completion compatibility in zsh
autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

# Now source the Fast completion script
source ~/.fast/complete.sh
```

Then reload:
```sh
source ~/.zshrc
```

### **Auto-Completion Script Download Error**

#### Error: "Failed to download Fast auto-completion script!"
The auto-completion script URL might be incorrect or unavailable.

Try downloading it manually:
```sh
curl -fsSL -o ~/.fast/complete.sh https://releases.fast.sh/install/complete.sh
```

### **Fast Command Not Found**

If the `fast` command isn't working:

1. Check if the binary exists:
```sh
ls -la ~/bin/fast
```

2. Ensure `~/bin` is in your PATH:
```sh
echo $PATH
```

3. Add it to PATH if missing:
```sh
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc  # For macOS
source ~/.zshrc
```

Or for Linux:
```sh
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### **GitHub Authentication Issues**
- Ensure your PAT has the correct scopes (`repo` and `admin:org`)
- For organization repositories, authorize SSO for your token
- Check that `~/.fast/config/fast.yaml` is properly formatted (correct indentation)
- Verify your token hasn't expired