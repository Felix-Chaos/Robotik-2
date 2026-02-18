# Robotik-2

A MATLAB-based robotics project focused on kinematics, dynamics, and trajectory planning for robotic manipulators.

## Project Structure

```
Robotik-2/
├── src/              # Core algorithms and functions
├── utils/            # Utility functions for visualization and helpers
├── examples/         # Example scripts demonstrating functionality
├── docs/             # Documentation files
└── README.md         # This file
```

## Features

- **Forward Kinematics**: Calculate end-effector position from joint angles using DH parameters
- **Inverse Kinematics**: Compute joint angles to reach desired positions
- **Jacobian Matrix**: Analyze velocity relationships and manipulability
- **Trajectory Planning**: Generate and follow smooth trajectories
- **Visualization**: Tools for plotting robot configurations and motion

## Getting Started

### Prerequisites

- MATLAB R2019a or later (recommended)
- No additional toolboxes required for basic functionality

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Felix-Chaos/Robotik-2.git
   cd Robotik-2
   ```

2. Open MATLAB and navigate to the project directory

3. Add the project paths to MATLAB:
   ```matlab
   addpath('src');
   addpath('utils');
   ```

## Usage

### Running Examples

The `examples/` directory contains several demonstration scripts:

1. **Forward Kinematics Example**:
   ```matlab
   cd examples
   example1_forward_kinematics
   ```
   Demonstrates calculation of end-effector position from joint angles.

2. **Inverse Kinematics Example**:
   ```matlab
   cd examples
   example2_inverse_kinematics
   ```
   Shows how to compute joint angles for a desired position.

3. **Trajectory Following**:
   ```matlab
   cd examples
   example3_trajectory
   ```
   Generates and follows a linear trajectory with animation.

4. **Jacobian Analysis**:
   ```matlab
   cd examples
   example4_jacobian
   ```
   Calculates Jacobian matrix and analyzes velocity relationships.

### Basic Usage

#### Forward Kinematics
```matlab
% Define DH parameters
theta = pi/4;  % Joint angle
a = 1.0;       % Link length
alpha = 0;     % Link twist
d = 0;         % Link offset

% Calculate transformation matrix
T = ForwardKinematics(theta, a, alpha, d);
```

#### Inverse Kinematics (2-Link Robot)
```matlab
% Robot parameters
L1 = 1.0;  % Link 1 length
L2 = 1.0;  % Link 2 length

% Target position
x_target = 1.5;
y_target = 0.5;

% Compute joint angles
[theta1, theta2] = InverseKinematics2Link(x_target, y_target, L1, L2);
```

#### Visualization
```matlab
% Visualize robot configuration
plotRobot2Link(theta1, theta2, L1, L2);
```

## Core Functions

### src/
- `ForwardKinematics.m` - Forward kinematics using DH parameters
- `InverseKinematics2Link.m` - Inverse kinematics for 2-link planar robot
- `JacobianMatrix.m` - Jacobian matrix calculation

### utils/
- `plotRobot2Link.m` - Visualize 2-link planar robot
- `generateTrajectory.m` - Generate linear trajectories
- `RotationMatrix.m` - Create rotation matrices

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is open source and available for educational purposes.

## Authors

- Robotik-2 Team

## Acknowledgments

- Inspired by classic robotics textbooks and courses
- Built for educational purposes in robotics and control systems