# Contributing to Robotik-2

Thank you for your interest in contributing to Robotik-2! This document provides guidelines for contributing to the project.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the GitHub Issues
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs. actual behavior
   - MATLAB version and operating system
   - Sample code if applicable

### Contributing Code

1. **Fork the Repository**
   ```bash
   git clone https://github.com/Felix-Chaos/Robotik-2.git
   cd Robotik-2
   ```

2. **Create a Branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make Your Changes**
   - Follow the existing code style
   - Add comments and documentation
   - Include examples for new functions

4. **Test Your Changes**
   - Verify all existing examples still work
   - Test your new functionality
   - Check for MATLAB errors and warnings

5. **Commit Your Changes**
   ```bash
   git add .
   git commit -m "Add feature: description of changes"
   ```

6. **Push and Create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a pull request on GitHub.

## Code Style Guidelines

### MATLAB Code Style

1. **Function Documentation**
   ```matlab
   function output = FunctionName(input1, input2)
   % FunctionName - Brief description
   %
   % Syntax: output = FunctionName(input1, input2)
   %
   % Inputs:
   %    input1 - Description
   %    input2 - Description
   %
   % Outputs:
   %    output - Description
   %
   % Example:
   %    result = FunctionName(1, 2)
   %
   % Author: Your Name
   ```

2. **Variable Naming**
   - Use descriptive names: `theta1`, `linkLength`, not `t1`, `l`
   - Use camelCase for variables and functions
   - Use UPPER_CASE for constants

3. **Code Structure**
   - Keep functions focused and concise
   - Use meaningful variable names
   - Add comments for complex logic
   - Include error checking

4. **File Organization**
   - One function per file (except nested functions)
   - File name must match function name
   - Place in appropriate directory (src/, utils/)

### Example Structure

```matlab
function result = ExampleFunction(param1, param2)
% Function documentation here

    % Validate inputs
    if nargin < 2
        error('Not enough input arguments');
    end
    
    % Main computation
    intermediate = param1 * param2;
    result = sqrt(intermediate);
    
    % Validate output
    if isnan(result) || isinf(result)
        warning('Result is NaN or Inf');
    end
end
```

## Types of Contributions

### Priority Areas

1. **New Robot Models**
   - 3-link robots
   - 3D manipulators
   - Different robot configurations

2. **Additional Algorithms**
   - Numerical IK methods
   - Trajectory optimization
   - Collision detection
   - Path planning

3. **Visualization Improvements**
   - 3D plotting
   - Better animation
   - Interactive controls

4. **Documentation**
   - Tutorial improvements
   - More examples
   - Video tutorials
   - Translation to other languages

5. **Testing**
   - Unit tests
   - Integration tests
   - Performance benchmarks

### Good First Issues

- Add input validation to existing functions
- Improve error messages
- Add more examples
- Enhance documentation
- Fix typos

## Development Setup

1. **Required Software**
   - MATLAB R2019a or later
   - Git for version control

2. **Optional Tools**
   - MATLAB toolboxes (none required for basic functionality)

## Testing

Before submitting a pull request:

1. Run all example scripts
2. Verify no errors or warnings
3. Test edge cases
4. Check documentation accuracy

## Questions?

If you have questions about contributing:

- Open a GitHub issue with the "question" label
- Check existing documentation
- Review closed issues for similar questions

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Focus on education and learning
- Provide helpful feedback

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for helping make Robotik-2 better! 🤖
