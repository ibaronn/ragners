# Contributing to AI Photo Enhancer Pro

We welcome contributions! Here's how to help.

## Getting Started

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Development Guidelines

### Code Style
- Follow Swift API Design Guidelines
- Use meaningful variable and function names
- Keep functions focused and small
- Document public APIs with documentation comments

### Architecture
- Follow MVVM + Clean Architecture patterns
- Use protocols for dependency inversion
- Keep views free of business logic
- ViewModels handle state and coordination

### Testing
- Write unit tests for all business logic
- Write UI tests for critical user flows
- Ensure all tests pass before submitting PR

### Performance
- Profile changes for memory and CPU impact
- Use async/await for all async operations
- Leverage GPU acceleration via Metal
- Cache expensive operations

## Pull Request Process

1. Update CHANGELOG.md with your changes
2. Ensure all tests pass
3. Get at least one code review approval
4. Squash commits before merging

## Code of Conduct

Be respectful and inclusive. We're all here to build something great.
