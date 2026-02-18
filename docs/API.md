# API Documentation

## Core Functions

### Forward Kinematics

#### `ForwardKinematics(theta, a, alpha, d)`

Computes the homogeneous transformation matrix using Denavit-Hartenberg parameters.

**Parameters:**
- `theta` - Joint angle (radians)
- `a` - Link length (meters)
- `alpha` - Link twist (radians)
- `d` - Link offset (meters)

**Returns:**
- `T` - 4×4 homogeneous transformation matrix

**Example:**
```matlab
T = ForwardKinematics(pi/4, 1.0, 0, 0);
```

---

### Inverse Kinematics

#### `InverseKinematics2Link(x, y, L1, L2)`

Computes joint angles for a 2-link planar robot to reach a target position.

**Parameters:**
- `x` - Target x-coordinate (meters)
- `y` - Target y-coordinate (meters)
- `L1` - Length of first link (meters)
- `L2` - Length of second link (meters)

**Returns:**
- `theta1` - Joint angle 1 (radians)
- `theta2` - Joint angle 2 (radians)

**Throws:**
- Error if target position is out of reach

**Example:**
```matlab
[theta1, theta2] = InverseKinematics2Link(1.5, 0.5, 1.0, 1.0);
```

---

### Jacobian Matrix

#### `JacobianMatrix(theta1, theta2, L1, L2)`

Calculates the Jacobian matrix for velocity analysis of a 2-link planar robot.

**Parameters:**
- `theta1` - Joint angle 1 (radians)
- `theta2` - Joint angle 2 (radians)
- `L1` - Length of first link (meters)
- `L2` - Length of second link (meters)

**Returns:**
- `J` - 2×2 Jacobian matrix

**Example:**
```matlab
J = JacobianMatrix(pi/4, pi/4, 1.0, 1.0);
v = J * [omega1; omega2];  % Calculate end-effector velocity
```

---

## Utility Functions

### Visualization

#### `plotRobot2Link(theta1, theta2, L1, L2)`

Visualizes a 2-link planar robot arm in a figure window.

**Parameters:**
- `theta1` - Joint angle 1 (radians)
- `theta2` - Joint angle 2 (radians)
- `L1` - Length of first link (meters)
- `L2` - Length of second link (meters)

**Example:**
```matlab
plotRobot2Link(pi/4, pi/4, 1.0, 1.0);
```

---

### Trajectory Generation

#### `generateTrajectory(startPos, endPos, numPoints)`

Generates a linear trajectory between two points.

**Parameters:**
- `startPos` - Starting position [x, y] (meters)
- `endPos` - Ending position [x, y] (meters)
- `numPoints` - Number of interpolation points (default: 50)

**Returns:**
- `trajectory` - Matrix of trajectory points (numPoints × 2)

**Example:**
```matlab
trajectory = generateTrajectory([0, 0], [1, 1], 50);
```

---

### Rotation Matrices

#### `RotationMatrix(axis, angle)`

Creates a 3D rotation matrix around a specified axis.

**Parameters:**
- `axis` - Rotation axis: 'x', 'y', or 'z'
- `angle` - Rotation angle (radians)

**Returns:**
- `R` - 3×3 rotation matrix

**Example:**
```matlab
R = RotationMatrix('z', pi/4);
```

---

## Mathematical Background

### Denavit-Hartenberg Parameters

The DH convention uses four parameters to describe the transformation from one link to the next:

1. **θ (theta)** - Joint angle about z-axis
2. **d** - Link offset along z-axis
3. **a** - Link length along x-axis
4. **α (alpha)** - Link twist about x-axis

The transformation matrix is:
```
T = [cos(θ)  -sin(θ)cos(α)   sin(θ)sin(α)   a·cos(θ)]
    [sin(θ)   cos(θ)cos(α)  -cos(θ)sin(α)   a·sin(θ)]
    [  0         sin(α)         cos(α)          d    ]
    [  0           0               0            1    ]
```

### Jacobian Matrix

The Jacobian relates joint velocities to end-effector velocities:

```
v = J · ω
```

Where:
- **v** - End-effector velocity [vx, vy]ᵀ
- **J** - Jacobian matrix
- **ω** - Joint velocities [ω₁, ω₂]ᵀ

For a 2-link planar robot:
```
J = [-L₁sin(θ₁) - L₂sin(θ₁+θ₂)    -L₂sin(θ₁+θ₂) ]
    [ L₁cos(θ₁) + L₂cos(θ₁+θ₂)     L₂cos(θ₁+θ₂) ]
```

### Manipulability

The manipulability index measures how well a robot can move in different directions:

```
μ = √det(J·Jᵀ)
```

A higher value indicates better manipulability. Near singularities, this value approaches zero.
