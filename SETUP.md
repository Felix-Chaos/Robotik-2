# Detailed Setup Instructions

This guide provides step-by-step instructions for setting up the MATLAB Robotics Workspace with Peter Corke's Robotics Toolbox.

## Table of Contents

1. [System Requirements](#system-requirements)
2. [Installing MATLAB](#installing-matlab)
3. [Installing Robotics Toolbox](#installing-robotics-toolbox)
4. [Configuring the Workspace](#configuring-the-workspace)
5. [Verification Steps](#verification-steps)
6. [Common Issues](#common-issues)

## System Requirements

### Minimum Requirements

- **Operating System:** Windows 7+, macOS 10.14+, or Linux (Ubuntu 18.04+)
- **RAM:** 4 GB (8 GB recommended)
- **Disk Space:** 10 GB free space
- **Display:** 1024x768 resolution or higher

### Recommended Requirements

- **Operating System:** Windows 10/11, macOS 11+, or Linux (Ubuntu 20.04+)
- **RAM:** 16 GB or more
- **Disk Space:** 20 GB free space
- **Display:** 1920x1080 resolution or higher
- **GPU:** Dedicated graphics card (for better visualization)

## Installing MATLAB

### For Windows

1. **Download MATLAB:**
   - Visit [MathWorks Download Center](https://www.mathworks.com/downloads/)
   - Sign in with your MathWorks account
   - Select the latest MATLAB version
   - Download the installer

2. **Run the Installer:**
   - Double-click the downloaded installer
   - Follow the installation wizard
   - Select products to install (at minimum: MATLAB, Optimization Toolbox)
   - Choose installation location
   - Complete the installation

3. **Activate MATLAB:**
   - Launch MATLAB
   - Follow activation prompts
   - Enter license information

### For macOS

1. **Download MATLAB:**
   - Visit [MathWorks Download Center](https://www.mathworks.com/downloads/)
   - Download the macOS installer (.dmg file)

2. **Install:**
   - Open the .dmg file
   - Drag MATLAB to Applications folder
   - Run the installer from Applications
   - Select products and complete installation

3. **Activate:**
   - Launch MATLAB from Applications
   - Complete activation process

### For Linux

1. **Download MATLAB:**
   ```bash
   # Download from MathWorks website
   wget https://www.mathworks.com/downloads/...
   ```

2. **Extract and Install:**
   ```bash
   # Extract the archive
   unzip matlab_R20XXx_glnxa64.zip -d matlab_installer
   
   # Run installer
   cd matlab_installer
   sudo ./install
   ```

3. **Follow Installation Wizard:**
   - Select products
   - Choose installation directory (e.g., /usr/local/MATLAB/R20XXx)
   - Complete installation

4. **Create Symbolic Link (Optional):**
   ```bash
   sudo ln -s /usr/local/MATLAB/R20XXx/bin/matlab /usr/local/bin/matlab
   ```

## Installing Robotics Toolbox

### Method 1: GitHub Installation (Recommended for Latest Features)

#### Step 1: Clone the Repository

```bash
# Navigate to desired installation directory
cd ~/Documents/MATLAB

# Clone the repository
git clone https://github.com/petercorke/robotics-toolbox-matlab.git

# Alternatively, download specific version
git clone --branch 10.4.1 https://github.com/petercorke/robotics-toolbox-matlab.git
```

#### Step 2: Configure MATLAB Path

Open MATLAB and run:

```matlab
% Navigate to toolbox directory
cd ~/Documents/MATLAB/robotics-toolbox-matlab

% Run startup script (this adds paths automatically)
startup_rvc

% Save the path for future sessions
savepath
```

#### Step 3: Verify Installation

```matlab
% Check version
ver

% Test basic functionality
L = Link([0, 0, 1, 0]);
robot = SerialLink(L, 'name', 'Test');
disp('Installation successful!');
```

### Method 2: MATLAB Add-On Explorer

#### Step 1: Open Add-On Explorer

1. Launch MATLAB
2. Click on **Home** tab
3. Click **Add-Ons** → **Get Add-Ons**

#### Step 2: Search and Install

1. In the search box, type "Robotics Toolbox"
2. Look for "Robotics Toolbox for MATLAB" by Peter Corke
3. Click on the toolbox
4. Click **Install** or **Add**
5. Wait for installation to complete

#### Step 3: Verify Installation

```matlab
% Check installed add-ons
matlab.addons.installedAddons

% Verify toolbox functions are available
which SerialLink
```

### Method 3: Manual ZIP Installation

#### Step 1: Download

1. Visit [Peter Corke's Toolbox Page](https://petercorke.com/toolboxes/robotics-toolbox/)
2. Download the latest ZIP file

#### Step 2: Extract

```bash
# Linux/macOS
unzip robotics-toolbox-matlab-10.x.x.zip -d ~/Documents/MATLAB/

# Windows: Use File Explorer to extract to Documents\MATLAB\
```

#### Step 3: Add to MATLAB Path

```matlab
% In MATLAB
addpath(genpath('~/Documents/MATLAB/robotics-toolbox-matlab'));
savepath;
```

## Configuring the Workspace

### Step 1: Clone This Workspace

```bash
# Navigate to your projects directory
cd ~/Projects

# Clone the workspace
git clone https://github.com/Felix-Chaos/Robotik-2.git

# Enter the directory
cd Robotik-2
```

### Step 2: Initialize Workspace

Open MATLAB and run:

```matlab
% Navigate to workspace
cd ~/Projects/Robotik-2

% Run startup script
startup

% This will:
% - Add necessary directories to path
% - Check for Robotics Toolbox
% - Display available examples
```

### Step 3: Configure Preferences (Optional)

```matlab
% Set default figure position and size
set(0, 'DefaultFigurePosition', [100, 100, 800, 600]);

% Set default line width
set(0, 'DefaultLineLineWidth', 1.5);

% Set default font size
set(0, 'DefaultAxesFontSize', 12);

% Save preferences
savepath;
```

## Verification Steps

### Test 1: Basic Robot Creation

```matlab
% Create a simple robot
L = Link([0, 0, 1, 0], 'standard');
robot = SerialLink(L, 'name', 'TestRobot');

% Plot it
figure;
robot.plot(0);

% If plot appears, basic functionality is working
```

### Test 2: Forward Kinematics

```matlab
% Create 2-link robot
L(1) = Link([0, 0, 1, 0], 'standard');
L(2) = Link([0, 0, 1, 0], 'standard');
robot = SerialLink(L, 'name', '2-Link');

% Compute FK
q = [pi/4, pi/4];
T = robot.fkine(q);

% Display result
disp('Forward Kinematics Result:');
disp(T);

% Expected: T should be a 4x4 transformation matrix
```

### Test 3: Standard Robot Models

```matlab
try
    % Try loading a standard model
    puma = mdl_puma560();
    disp('Puma 560 model loaded successfully!');
    
    % Plot it
    figure;
    puma.plot(zeros(1,6));
catch
    warning('Could not load standard models. May need full toolbox installation.');
end
```

### Test 4: Run Example Scripts

```matlab
% Navigate to examples
cd examples

% Run basic demo
basic_robot_demo

% If examples run without errors, installation is complete!
```

## Common Issues

### Issue 1: "Undefined function or variable 'SerialLink'"

**Cause:** Robotics Toolbox not in MATLAB path.

**Solution:**
```matlab
% Check if toolbox is installed
which SerialLink

% If returns empty, add toolbox to path
addpath(genpath('/path/to/robotics-toolbox-matlab'));
savepath;
```

### Issue 2: "Error using plot"

**Cause:** Graphics issues or missing dependencies.

**Solution:**
```matlab
% Try software rendering
opengl software

% Update graphics drivers on your system
% Restart MATLAB
```

### Issue 3: "Warning: Name is nonexistent or not a directory"

**Cause:** Incorrect path or missing directories.

**Solution:**
```matlab
% Clean up path
restoredefaultpath;

% Re-add necessary paths
cd /path/to/Robotik-2
startup
```

### Issue 4: License Issues

**Cause:** MATLAB license not activated or expired.

**Solution:**
1. Check license status in MATLAB
2. Contact your organization's license administrator
3. Or visit [MathWorks License Center](https://www.mathworks.com/licensecenter/)

### Issue 5: Out of Memory Errors

**Cause:** Insufficient memory for large computations.

**Solution:**
```matlab
% Increase Java heap memory
% Edit java.opts file in MATLAB preferences directory
% Add line: -Xmx4096m (for 4GB heap)

% Or reduce problem size
% Use fewer samples in workspace analysis
```

### Issue 6: "Function jtraj not found"

**Cause:** Incomplete toolbox installation.

**Solution:**
1. Verify full toolbox installation
2. Check for missing dependencies
3. Reinstall toolbox from GitHub
4. Ensure startup script was run

## Advanced Configuration

### Custom Startup Script

Create a custom startup script in your MATLAB preferences directory:

1. Find userpath:
   ```matlab
   userpath
   ```

2. Create `startup.m` in that directory:
   ```matlab
   % Custom startup.m
   disp('Loading custom MATLAB environment...');
   
   % Add Robotik-2 workspace
   addpath('~/Projects/Robotik-2');
   
   % Run workspace startup
   run('~/Projects/Robotik-2/startup.m');
   
   % Set preferences
   format compact;
   set(0, 'DefaultFigureWindowStyle', 'docked');
   ```

### Environment Variables (Linux/macOS)

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# MATLAB environment
export MATLAB_HOME=/usr/local/MATLAB/R20XXx
export PATH=$MATLAB_HOME/bin:$PATH

# Robotics workspace
export ROBOTIK2_HOME=~/Projects/Robotik-2
```

## Getting Help

### Documentation

- MATLAB Help Browser: Type `doc` in MATLAB command window
- Robotics Toolbox Help: Type `doc SerialLink` for specific functions

### Online Resources

- [MATLAB Answers](https://www.mathworks.com/matlabcentral/answers/)
- [GitHub Issues](https://github.com/petercorke/robotics-toolbox-matlab/issues)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/matlab)

### Community

- MATLAB User Community
- Robotics Stack Exchange
- Peter Corke's Forum

---

**Setup Complete! You're ready to start working with robotics in MATLAB.**
