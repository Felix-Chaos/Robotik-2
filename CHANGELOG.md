# Changelog

All notable changes to the Robotik-2 project will be documented in this file.

## [1.0.0] - 2026-02-18

### Added
- Initial project structure with src/, utils/, examples/, and docs/ directories
- Core kinematics functions:
  - ForwardKinematics.m - DH parameter-based forward kinematics
  - InverseKinematics2Link.m - Analytical IK for 2-link planar robot
  - JacobianMatrix.m - Velocity analysis for 2-link robot
- Utility functions:
  - plotRobot2Link.m - Robot visualization
  - generateTrajectory.m - Linear trajectory generation
  - RotationMatrix.m - 3D rotation matrix utilities
- Four comprehensive example scripts:
  - example1_forward_kinematics.m - FK demonstration
  - example2_inverse_kinematics.m - IK demonstration
  - example3_trajectory.m - Trajectory planning and animation
  - example4_jacobian.m - Jacobian and velocity analysis
- Interactive main.m script with menu system
- Complete documentation:
  - README.md with installation and usage instructions
  - docs/API.md with detailed function reference
  - docs/GETTING_STARTED.md with tutorials
- .gitignore for MATLAB-specific files
- MIT License

### Changed
- N/A (initial release)

### Fixed
- N/A (initial release)

## [Unreleased]

### Planned Features
- Support for 3-link and higher DOF robots
- 3D robot visualization
- Workspace analysis
- Dynamic simulation capabilities
- Path planning algorithms (RRT, A*)
- Obstacle avoidance
- Additional trajectory types (polynomial, spline)
