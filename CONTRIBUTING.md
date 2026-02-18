# Contributing to MATLAB Robotics Workspace

Thank you for your interest in contributing to this project! This document provides guidelines for contributions.

## 🎯 How Can I Contribute?

### 1. Reporting Bugs

If you find a bug, please create an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- MATLAB version and Robotics Toolbox version
- Error messages (if any)

### 2. Suggesting Enhancements

Enhancement suggestions are welcome! Please:
- Check if the feature already exists
- Clearly describe the enhancement
- Explain why it would be useful
- Provide examples if possible

### 3. Adding Example Scripts

We love new examples! When adding examples:
- Follow the existing code style
- Add clear comments and documentation
- Include example usage
- Test thoroughly before submitting

### 4. Improving Documentation

Documentation improvements are always appreciated:
- Fix typos and grammar
- Add clarifications
- Improve examples
- Add missing information

## 📝 Coding Guidelines

### MATLAB Code Style

```matlab
% Use clear, descriptive function names
function result = computeForwardKinematics(robot, q)

% Add function header with description
%COMPUTEFORWARDKINEMATICS Compute forward kinematics
%
% RESULT = COMPUTEFORWARDKINEMATICS(ROBOT, Q) computes...
%
% Inputs:
%   ROBOT - SerialLink robot object
%   Q     - Joint configuration
%
% Output:
%   RESULT - Transformation matrix

% Use meaningful variable names
end_effector_pose = robot.fkine(q);

% Add comments for complex logic
% Compute Jacobian at current configuration
J = robot.jacob0(q);

% Use proper spacing
if condition
    % Code here
end

% Avoid magic numbers, use constants
MAX_ITERATIONS = 100;
TOLERANCE = 1e-6;
```

### Documentation Style

- Use Markdown for documentation files
- Include code examples where appropriate
- Keep language simple and clear
- Use headings to organize content

### File Naming

- Use descriptive names: `forward_kinematics.m` not `fk.m`
- Use lowercase with underscores for scripts: `my_example.m`
- Use camelCase for functions: `createCustomRobot.m`
- Model files should start with `mdl_`: `mdl_my_robot.m`

## 🔄 Pull Request Process

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/Robotik-2.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/my-new-feature
   # or
   git checkout -b fix/bug-description
   ```

3. **Make your changes**
   - Write clear, commented code
   - Follow coding guidelines
   - Test your changes

4. **Commit with clear messages**
   ```bash
   git commit -m "Add: new trajectory planning example"
   git commit -m "Fix: IK convergence issue in utility function"
   git commit -m "Docs: improve setup instructions"
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/my-new-feature
   ```

6. **Create a Pull Request**
   - Provide clear description
   - Reference any related issues
   - Explain what you changed and why

## 🧪 Testing

Before submitting:

1. **Test your code**
   ```matlab
   % Run your script/function
   your_function()
   
   % Check for errors
   % Verify output is correct
   ```

2. **Test with different inputs**
   - Edge cases
   - Invalid inputs
   - Different robot configurations

3. **Check compatibility**
   - Test with different MATLAB versions (if possible)
   - Ensure no toolbox-specific features (unless documented)

## 📂 Directory Structure

When adding files, follow this structure:

```
Robotik-2/
├── examples/          # Example scripts (educational)
├── utils/            # Utility functions (reusable tools)
├── models/           # Robot model definitions (mdl_*.m)
├── data/             # Data files (configurations, results)
└── docs/             # Additional documentation (if needed)
```

## 🎨 Example Contributions

### Adding a New Example

```matlab
%% My New Example
% Brief description of what this example demonstrates
%
% Topics covered:
%   - Topic 1
%   - Topic 2
%   - Topic 3

%% Clear workspace
clear;
clc;
close all;

fprintf('=== My New Example ===\n\n');

%% Example 1: First Concept
fprintf('1. Demonstrating first concept...\n');

% Your code here with clear comments

fprintf('Complete\n\n');

%% Example 2: Second Concept
% Continue with additional examples...

fprintf('=== Examples Complete ===\n');
```

### Adding a New Utility Function

```matlab
function output = myUtilityFunction(input1, input2, options)
%MYUTILITYFUNCTION Brief one-line description
%
% OUTPUT = MYUTILITYFUNCTION(INPUT1, INPUT2) detailed description
%
% OUTPUT = MYUTILITYFUNCTION(INPUT1, INPUT2, OPTIONS) with options
%
% Inputs:
%   INPUT1  - Description
%   INPUT2  - Description
%   OPTIONS - Optional struct with fields:
%             'field1' - Description (default: value)
%             'field2' - Description (default: value)
%
% Output:
%   OUTPUT - Description
%
% Example:
%   result = myUtilityFunction(1, 2);
%   result = myUtilityFunction(1, 2, struct('field1', 10));

% Validate inputs
if nargin < 2
    error('At least 2 inputs required');
end

if nargin < 3
    options = struct();
end

% Set defaults
if ~isfield(options, 'field1'), options.field1 = default_value; end

% Your implementation here

end
```

### Adding a New Robot Model

```matlab
function robot = mdl_my_robot()
%MDL_MY_ROBOT Create my custom robot model
%
% ROBOT = MDL_MY_ROBOT() creates a SerialLink object representing
% [brief description of the robot]
%
% Robot specifications:
%   - Number of joints: X
%   - Type: [manipulator/mobile/etc]
%   - Characteristics: [key features]
%
% Example:
%   robot = mdl_my_robot();
%   robot.plot(robot.qz);

% Define DH parameters
L(1) = Link([0, 0, a1, alpha1], 'standard');
% ... more links

% Set properties
L(1).m = mass;
% ... more properties

% Create robot
robot = SerialLink(L, 'name', 'My Robot');

% Define configurations
robot.qz = [0, 0, ...];  % Zero position
% ... more configurations

end
```

## 🐛 Bug Report Template

When reporting bugs, use this template:

```markdown
**Describe the bug**
A clear description of the bug.

**To Reproduce**
Steps to reproduce:
1. Run script '...'
2. With configuration '...'
3. See error

**Expected behavior**
What you expected to happen.

**Error messages**
```
[paste error message here]
```

**Environment:**
- MATLAB Version: [e.g., R2022b]
- Robotics Toolbox Version: [e.g., 10.4]
- OS: [e.g., Windows 11]

**Additional context**
Any other relevant information.
```

## 💡 Feature Request Template

```markdown
**Feature description**
Clear description of the feature.

**Use case**
Explain when and why this would be useful.

**Proposed solution**
How you think it should work.

**Alternatives**
Other approaches you've considered.

**Examples**
Code examples showing usage (if applicable).
```

## 📜 Code of Conduct

### Our Standards

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Accept criticism gracefully
- Prioritize community benefit

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

## ❓ Questions?

If you have questions:
1. Check existing documentation
2. Search closed issues
3. Ask in a new issue with "Question" label

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🎉
