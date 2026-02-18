# Quick Start Guide

Get up and running with the MATLAB Robotics Workspace in 5 minutes!

## ⚡ Prerequisites

Before you start, ensure you have:
- ✅ MATLAB R2018b or later installed
- ✅ Peter Corke's Robotics Toolbox installed
- ✅ This repository cloned to your machine

## 🚀 5-Minute Setup

### 1. Open MATLAB

Launch MATLAB on your computer.

### 2. Navigate to Workspace

```matlab
cd /path/to/Robotik-2
```

### 3. Run Startup Script

```matlab
startup
```

You should see:
```
========================================
  Robotics Workspace Initialization
========================================

Adding project directories to path...
  - Added examples directory
  - Added utils directory
  - Added models directory

Checking for Robotics Toolbox...
  ✓ Robotics Toolbox detected

========================================
  Workspace Ready!
========================================
```

### 4. Try Your First Example

```matlab
cd examples
basic_robot_demo
```

## 🎯 Common Tasks

### Create a Simple Robot

```matlab
% 2-link planar robot
L(1) = Link([0, 0, 1, 0]);
L(2) = Link([0, 0, 0.8, 0]);
robot = SerialLink(L, 'name', 'My2Link');

% Plot it
robot.plot([pi/4, pi/3]);
```

### Compute Forward Kinematics

```matlab
q = [pi/4, pi/3];
T = robot.fkine(q);
disp(T.t);  % Display position
```

### Generate a Trajectory

```matlab
q_start = [0, 0];
q_end = [pi/2, pi/2];
t = 0:0.05:2;
q_traj = jtraj(q_start, q_end, t);
robot.plot(q_traj);
```

## 📚 Example Scripts

All examples are in the `examples/` directory:

| Script | Description | Run Command |
|--------|-------------|-------------|
| `basic_robot_demo.m` | Create and visualize robots | `basic_robot_demo` |
| `forward_kinematics.m` | FK calculations | `forward_kinematics` |
| `inverse_kinematics.m` | IK solutions | `inverse_kinematics` |
| `trajectory_planning.m` | Path planning | `trajectory_planning` |
| `robot_visualization.m` | Visualization techniques | `robot_visualization` |

## 🛠️ Utility Functions

Helpful functions in the `utils/` directory:

### Plot 3D Workspace

```matlab
robot = createCustomRobot([0,0,1,0; 0,0,1,0], 'Test');
plotWorkspace3D(robot, 'nsamples', 2000);
```

### Verify IK Solution

```matlab
T_desired = transl(0.5, 0.2, 0.3);
q = robot.ikine(T_desired);
success = verifyIK(robot, T_desired, q);
```

### Animate Trajectory

```matlab
q_traj = jtraj([0,0], [pi/2,pi/2], 0:0.05:2);
animateTrajectory(robot, q_traj, 'fps', 30, 'trail', 'on');
```

### Create Custom Robot

```matlab
dh = [0, 0, 0.5, pi/2;
      0, 0, 0.5, 0;
      0, 0, 0.3, 0];
robot = createCustomRobot(dh, 'My3Link');
```

## 🐛 Troubleshooting

### "SerialLink not found"

```matlab
% Check if Robotics Toolbox is installed
which SerialLink

% If empty, install or add to path
addpath(genpath('/path/to/robotics-toolbox'));
savepath;
```

### "Plot not showing"

```matlab
% Try software rendering
opengl software

% Restart MATLAB
```

### "Out of memory"

Reduce sample sizes in workspace analysis or clear workspace:

```matlab
clear; clc; close all;
```

## 📖 Learn More

- **Full Documentation**: See [README.md](README.md)
- **Detailed Setup**: See [SETUP.md](SETUP.md)
- **Robotics Toolbox Docs**: https://petercorke.github.io/robotics-toolbox-matlab/
- **Book**: "Robotics, Vision and Control" by Peter Corke

## 💡 Tips

1. **Save Your Work**: Save robot definitions for reuse
   ```matlab
   save('my_robot.mat', 'robot');
   ```

2. **Load Saved Robots**: 
   ```matlab
   load('my_robot.mat');
   ```

3. **Close All Figures**: 
   ```matlab
   close all;
   ```

4. **Clear Workspace**: 
   ```matlab
   clear; clc;
   ```

5. **Get Help**: 
   ```matlab
   help SerialLink
   doc Link
   ```

## 🎓 Next Steps

1. ✅ Run all example scripts to learn different features
2. ✅ Modify examples to experiment with different parameters
3. ✅ Create your own custom robot models
4. ✅ Explore the Robotics Toolbox documentation
5. ✅ Try implementing a real robot project

---

**Need Help?** Check the [full README](README.md) or [detailed setup guide](SETUP.md).

**Happy Coding! 🤖**
