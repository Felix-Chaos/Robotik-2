# MATLAB Robotics Workspace

A comprehensive MATLAB workspace configured for robotics research and development using **Peter Corke's Robotics Toolbox**.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Getting Started](#getting-started)
- [Directory Structure](#directory-structure)
- [Example Scripts](#example-scripts)
- [Usage Guide](#usage-guide)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## 🎯 Overview

This workspace provides a ready-to-use MATLAB environment for:
- Robot kinematics (forward and inverse)
- Trajectory planning and generation
- Robot visualization and animation
- Workspace analysis
- Custom robot modeling

## 📦 Prerequisites

### Required Software

1. **MATLAB** (R2018b or later recommended)
   - Core MATLAB installation
   - Optimization Toolbox (recommended for advanced IK)

2. **Peter Corke's Robotics Toolbox for MATLAB**
   - Version 10.x or later recommended

### Optional Tools

- Symbolic Math Toolbox (for symbolic kinematics)
- Computer Vision Toolbox (for vision-based robotics)
- Image Processing Toolbox (for image manipulation)

## 🚀 Installation

### Step 1: Install MATLAB

Download and install MATLAB from [MathWorks](https://www.mathworks.com/products/matlab.html).

### Step 2: Install Robotics Toolbox

There are several ways to install Peter Corke's Robotics Toolbox:

#### Option A: From GitHub (Recommended)

```bash
# Clone the toolbox repository
git clone https://github.com/petercorke/robotics-toolbox-matlab.git

# Or download the latest release from:
# https://github.com/petercorke/robotics-toolbox-matlab/releases
```

Then in MATLAB:
```matlab
% Navigate to the downloaded toolbox directory
cd /path/to/robotics-toolbox-matlab

% Run the installation script
startup_rvc
```

#### Option B: Using MATLAB Add-On Explorer

1. Open MATLAB
2. Go to **Home** → **Add-Ons** → **Get Add-Ons**
3. Search for "Robotics Toolbox"
4. Click **Install**

#### Option C: Manual Installation

1. Download from [Peter Corke's website](https://petercorke.com/toolboxes/robotics-toolbox/)
2. Extract the archive
3. Add to MATLAB path:
   ```matlab
   addpath('/path/to/robotics-toolbox');
   savepath;
   ```

### Step 3: Clone This Workspace

```bash
git clone https://github.com/Felix-Chaos/Robotik-2.git
cd Robotik-2
```

### Step 4: Initialize the Workspace

Open MATLAB and run:

```matlab
cd /path/to/Robotik-2
startup
```

## 🏁 Getting Started

### Quick Start

1. Open MATLAB
2. Navigate to the workspace directory:
   ```matlab
   cd /path/to/Robotik-2
   ```
3. Run the startup script:
   ```matlab
   startup
   ```
4. Try an example script:
   ```matlab
   cd examples
   basic_robot_demo
   ```

### Verifying Installation

Run this in MATLAB to verify the Robotics Toolbox is installed:

```matlab
% Try to create a simple robot
L = Link([0, 0, 1, 0]);
robot = SerialLink(L, 'name', 'TestRobot');
disp('Robotics Toolbox is working!');
```

## 📁 Directory Structure

```
Robotik-2/
├── startup.m              # Workspace initialization script
├── README.md              # This file
├── SETUP.md              # Detailed setup instructions
├── .gitignore            # Git ignore rules for MATLAB
│
├── examples/             # Example scripts
│   ├── basic_robot_demo.m
│   ├── forward_kinematics.m
│   ├── inverse_kinematics.m
│   ├── trajectory_planning.m
│   └── robot_visualization.m
│
├── utils/                # Utility functions
│   └── (custom helper functions)
│
├── models/               # Robot model definitions
│   └── (custom robot models)
│
└── data/                 # Data files
    └── (experimental data, configurations)
```

## 📚 Example Scripts

### 1. `basic_robot_demo.m`

Demonstrates basic robot creation and manipulation.

**Features:**
- Creating simple robots
- Loading standard robot models (Puma 560, UR5)
- Basic forward kinematics
- Robot visualization

**Run:**
```matlab
cd examples
basic_robot_demo
```

### 2. `forward_kinematics.m`

Forward kinematics examples and applications.

**Features:**
- Computing end-effector pose from joint angles
- Working with homogeneous transformations
- Jacobian calculation
- Workspace visualization

**Run:**
```matlab
cd examples
forward_kinematics
```

### 3. `inverse_kinematics.m`

Inverse kinematics examples and solutions.

**Features:**
- Numerical IK solutions
- Multiple target positions
- Reachability analysis
- Handling singularities

**Run:**
```matlab
cd examples
inverse_kinematics
```

### 4. `trajectory_planning.m`

Trajectory generation and planning.

**Features:**
- Joint space trajectories
- Cartesian space trajectories
- Multi-waypoint paths
- Velocity and acceleration profiles

**Run:**
```matlab
cd examples
trajectory_planning
```

### 5. `robot_visualization.m`

Robot visualization techniques.

**Features:**
- Static robot plots
- Animated trajectories
- Workspace mapping
- Configuration space visualization

**Run:**
```matlab
cd examples
robot_visualization
```

## 📖 Usage Guide

### Creating a Custom Robot

```matlab
% Define DH parameters: [theta, d, a, alpha]
L(1) = Link([0, 0, 0.5, pi/2], 'standard');
L(2) = Link([0, 0, 0.5, 0], 'standard');
L(3) = Link([0, 0, 0.3, 0], 'standard');

% Create robot
myRobot = SerialLink(L, 'name', 'MyRobot');

% Set joint limits
myRobot.qlim = [-pi, pi; -pi/2, pi/2; -pi/2, pi/2];
```

### Computing Forward Kinematics

```matlab
% Define joint configuration
q = [pi/4, pi/3, pi/6];

% Compute forward kinematics
T = myRobot.fkine(q);

% Extract position
position = T.t;  % [x, y, z]

% Extract rotation matrix
rotation = T.R;  % 3x3 rotation matrix
```

### Solving Inverse Kinematics

```matlab
% Define desired position
desired_pos = [0.7, 0.2, 0.3];

% Create transformation matrix
T_desired = transl(desired_pos);

% Solve IK (position only)
q_solution = myRobot.ikine(T_desired, 'mask', [1 1 1 0 0 0]);

% Verify solution
T_verify = myRobot.fkine(q_solution);
error = norm(T_verify.t - desired_pos');
```

### Generating Trajectories

```matlab
% Define start and end configurations
q_start = [0, 0, 0];
q_end = [pi/2, pi/3, pi/4];

% Time vector
t = 0:0.05:2.0;

% Generate trajectory
[q_traj, qd_traj, qdd_traj] = jtraj(q_start, q_end, t);

% Animate
myRobot.plot(q_traj, 'fps', 30);
```

### Visualizing the Robot

```matlab
% Plot robot at specific configuration
q = [pi/6, pi/4, pi/3];
myRobot.plot(q);

% Plot with trail
myRobot.plot(q_trajectory, 'trail', 'r-');

% Customize plot
myRobot.plot(q, 'workspace', [-1 1 -1 1 0 2]);
```

## 🔧 Troubleshooting

### Robotics Toolbox Not Found

**Problem:** Error messages about missing `SerialLink`, `Link`, or toolbox functions.

**Solution:**
1. Verify toolbox installation:
   ```matlab
   ver('RTB')
   ```
2. Check MATLAB path:
   ```matlab
   path
   ```
3. Re-run toolbox startup script
4. Reinstall if necessary

### Graphics Issues

**Problem:** Plots not displaying or errors during visualization.

**Solution:**
1. Update graphics drivers
2. Try software rendering:
   ```matlab
   opengl software
   ```
3. Check MATLAB graphics settings

### IK Not Converging

**Problem:** Inverse kinematics fails to find solution.

**Solution:**
1. Provide a good initial guess
2. Check if target is within workspace
3. Adjust IK solver options:
   ```matlab
   q = robot.ikine(T, q0, 'mask', [1 1 1 0 0 0], ...
                   'ilimit', 1000, 'tol', 1e-6);
   ```

### Memory Issues

**Problem:** Out of memory errors during workspace analysis.

**Solution:**
1. Reduce number of samples
2. Clear workspace regularly:
   ```matlab
   clear; clc; close all;
   ```
3. Increase MATLAB memory:
   ```matlab
   feature('DefaultCharacterSet', 'windows-1252');
   ```

## 📚 Resources

### Documentation

- [Robotics Toolbox Documentation](https://petercorke.github.io/robotics-toolbox-matlab/)
- [MATLAB Documentation](https://www.mathworks.com/help/matlab/)

### Books

- **Robotics, Vision and Control** by Peter Corke
  - Fundamental textbook for the toolbox
  - Available at: https://petercorke.com/rvc/

### Online Resources

- [GitHub Repository - Robotics Toolbox](https://github.com/petercorke/robotics-toolbox-matlab)
- [Peter Corke's Website](https://petercorke.com/)
- [MATLAB Central - Robotics](https://www.mathworks.com/matlabcentral/fileexchange/?q=robotics)

### Video Tutorials

- [QUT Robot Academy](https://robotacademy.net.au/)
- MATLAB YouTube Channel - Robotics playlist

### Community

- [MATLAB Answers - Robotics](https://www.mathworks.com/matlabcentral/answers/)
- [Stack Overflow - MATLAB Robotics](https://stackoverflow.com/questions/tagged/matlab+robotics)

## 🤝 Contributing

Contributions are welcome! Please feel free to:
- Add new example scripts
- Improve documentation
- Report issues
- Suggest enhancements

## 📄 License

This workspace is provided as-is for educational and research purposes.

The Robotics Toolbox by Peter Corke has its own license - please refer to the [toolbox repository](https://github.com/petercorke/robotics-toolbox-matlab) for details.

## ✨ Acknowledgments

- **Peter Corke** for the excellent Robotics Toolbox
- **MathWorks** for MATLAB
- The robotics community for continuous support and improvements

---

**Happy Robot Programming! 🤖**