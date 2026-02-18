# Getting Started Guide

## Introduction

This guide will help you get started with the Robotik-2 MATLAB project. By the end of this guide, you'll understand how to use the basic functions and run the example scripts.

## What You'll Learn

1. How to set up the project
2. Understanding the project structure
3. Running your first example
4. Using core functions
5. Creating your own robot simulation

## Step 1: Setup

### Check MATLAB Installation

Make sure you have MATLAB R2019a or later installed. To check your version:

```matlab
version
```

### Clone and Navigate

1. Clone the repository (if you haven't already)
2. Open MATLAB
3. Navigate to the project directory:

```matlab
cd /path/to/Robotik-2
```

### Add Paths

Add the necessary directories to your MATLAB path:

```matlab
addpath('src');
addpath('utils');
addpath('examples');
```

## Step 2: Run Your First Example

Let's start with the forward kinematics example:

```matlab
cd examples
example1_forward_kinematics
```

This will:
1. Define a 2-link robot with each link 1 meter long
2. Set joint angles (45° and 60°)
3. Calculate the end-effector position
4. Display the robot configuration

You should see a figure showing the robot arm and printed output with the position.

## Step 3: Understanding the Output

The example prints:
```
=== Forward Kinematics Example ===
Link 1 Length: 1.00 m
Link 2 Length: 1.00 m
Joint 1 Angle: 45.00 deg
Joint 2 Angle: 60.00 deg
End Effector Position: (0.707, 1.707)
```

The visualization shows:
- Blue line: First link
- Red line: Second link
- Circles: Joints and end-effector

## Step 4: Try Inverse Kinematics

Now let's solve the reverse problem - finding joint angles for a desired position:

```matlab
example2_inverse_kinematics
```

This example:
1. Specifies a target position (1.5, 0.5)
2. Calculates the required joint angles
3. Verifies the solution
4. Shows the robot reaching the target

## Step 5: Create Your Own Simulation

Create a new file `my_robot.m`:

```matlab
%% My First Robot Simulation
clear; clc; close all;

% Add paths
addpath('../src');
addpath('../utils');

% Define robot
L1 = 0.8;  % First link: 0.8 meters
L2 = 0.6;  % Second link: 0.6 meters

% Define target
x_target = 1.0;
y_target = 0.8;

% Calculate angles
[theta1, theta2] = InverseKinematics2Link(x_target, y_target, L1, L2);

% Display results
fprintf('Joint angles to reach (%.1f, %.1f):\n', x_target, y_target);
fprintf('  theta1 = %.2f degrees\n', rad2deg(theta1));
fprintf('  theta2 = %.2f degrees\n', rad2deg(theta2));

% Visualize
plotRobot2Link(theta1, theta2, L1, L2);
plot(x_target, y_target, 'mx', 'MarkerSize', 15, 'LineWidth', 3);
legend('Link 1', 'Link 2', 'Base', 'Joint 1', 'End Effector', 'Target');
```

## Step 6: Explore Trajectory Planning

The trajectory example shows how to move the robot smoothly:

```matlab
example3_trajectory
```

This demonstrates:
- Generating a linear path
- Computing inverse kinematics for each point
- Plotting joint angles over time
- Animating the robot motion

## Step 7: Analyze Velocities

The Jacobian example helps understand velocity relationships:

```matlab
example4_jacobian
```

This shows:
- How joint velocities affect end-effector velocity
- The Jacobian matrix
- Manipulability analysis
- Velocity visualization

## Common Tasks

### Changing Robot Dimensions

To use different link lengths, modify the L1 and L2 values:

```matlab
L1 = 1.5;  % Longer first link
L2 = 0.5;  % Shorter second link
```

### Moving to Different Positions

Specify any reachable position:

```matlab
x_target = 1.2;
y_target = 0.3;
[theta1, theta2] = InverseKinematics2Link(x_target, y_target, L1, L2);
```

### Creating Custom Trajectories

Generate any trajectory you want:

```matlab
% Circular trajectory
theta = linspace(0, 2*pi, 100);
radius = 0.5;
center = [1.0, 0.5];
trajectory = [center(1) + radius*cos(theta)', center(2) + radius*sin(theta)'];
```

## Troubleshooting

### "Target position is out of reach"

This error occurs when the target is too far. The maximum reach is L1 + L2:

```matlab
max_reach = L1 + L2;
distance = sqrt(x^2 + y^2);
if distance > max_reach
    fprintf('Target too far! Max reach: %.2f m\n', max_reach);
end
```

### "Undefined function or variable"

Make sure you've added the paths:

```matlab
addpath('src');
addpath('utils');
```

### Figures Not Displaying

Check if MATLAB is in the correct mode:

```matlab
set(0, 'DefaultFigureVisible', 'on');
```

## Next Steps

1. **Experiment**: Modify the examples with different parameters
2. **Extend**: Add new functions for 3-link robots or 3D motion
3. **Learn**: Read the API documentation in `docs/API.md`
4. **Create**: Build your own robot applications

## Additional Resources

- **API Documentation**: See `docs/API.md` for detailed function references
- **Examples**: All examples are in the `examples/` directory
- **Source Code**: Core algorithms are in `src/` with inline documentation

## Getting Help

If you encounter issues:
1. Check the function documentation using `help function_name`
2. Review the examples for usage patterns
3. Read the error messages carefully
4. Make sure all paths are added correctly

Happy coding! 🤖
