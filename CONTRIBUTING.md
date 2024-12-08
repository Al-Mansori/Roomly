
---

# Contributing to Roomly

Thank you for considering contributing to Roomly! We're excited to work together to build an innovative workspace and learning center reservation platform. Please follow these guidelines to ensure a smooth collaboration.

---

## Table of Contents
1. [Getting Started](#getting-started)
2. [How to Contribute](#how-to-contribute)
   - [Reporting Bugs](#reporting-bugs)
   - [Suggesting Features](#suggesting-features)
   - [Code Contributions](#code-contributions)
3. [Branching Strategy](#branching-strategy)
4. [Coding Standards](#coding-standards)
5. [Pull Request Guidelines](#pull-request-guidelines)
6. [Code of Conduct](#code-of-conduct)

---

## Getting Started
Before contributing, ensure you have the following:
- Git installed and configured.
- Access to the repository.
- Familiarity with the tech stack:
  - **Backend**: Spring Boot
  - **Frontend**: Angular
  - **Mobile**: Flutter
- Required tools:
  - Java Development Kit (JDK 11+).
  - Node.js and npm for Angular.
  - Flutter SDK for mobile development.

---

## How to Contribute

### Reporting Bugs
- Search for existing issues to avoid duplicates.
- If none exist, create a new issue and include:
  - A clear title (e.g., "Bug: Login page throws an error on invalid input").
  - Steps to reproduce the bug.
  - Expected vs. actual behavior.
  - Screenshots or error logs (if applicable).

### Suggesting Features
- Use the issue tracker to propose new features.
- Include:
  - A clear title (e.g., "Feature: Add dark mode support").
  - A description of the problem solved by the feature.
  - Mockups or diagrams if relevant.

### Code Contributions
1. **Fork the Repository**:
   - Go to the repository page on GitHub and click the **Fork** button. This creates your own copy of the project.

2. **Clone the Repository**:
   - Clone your forked repository to your local machine:
     ```bash
     git clone https://github.com/your-username/roomly-graduation-project.git
     cd roomly-graduation-project
     ```

3. **Create a New Branch**:
   - Always work in a new branch specific to your task:
     ```bash
     git checkout -b feature/add-login-form
     ```
   - Use a descriptive branch name based on the type of work:
     - `feature/` for new features (e.g., `feature/add-payment-system`).
     - `bugfix/` for fixing bugs (e.g., `bugfix/fix-date-picker`).

4. **Make Changes**:
   - Write clear and concise code following the coding standards outlined below.
   - Ensure your changes are scoped to the task to avoid unrelated updates.

5. **Test Your Changes**:
   - Run the tests:
     - Backend: Use JUnit for testing services or endpoints.
       ```bash
       ./mvnw test
       ```
     - Frontend: Run Angular tests.
       ```bash
       ng test
       ```
     - Mobile: Test using the Flutter testing suite.
       ```bash
       flutter test
       ```

6. **Commit Changes**:
   - Write a meaningful commit message:
     ```bash
     git add .
     git commit -m "feat(login): add login form with validation"
     ```

7. **Push Changes**:
   - Push your branch to your forked repository:
     ```bash
     git push origin feature/add-login-form
     ```

8. **Submit a Pull Request**:
   - Navigate to the original repository and create a pull request from your branch.

---

## Branching Strategy

### Explanation
1. **Main Branch**:
   - Contains the production-ready code.
   - No direct commits; only merge tested and approved changes.

2. **Development Branch (`dev`)**:
   - Integration branch where new features and fixes are merged before going to `main`.

3. **Feature Branches**:
   - Used for developing specific features.
   - Created from `dev` and merged back into `dev`.

4. **Bugfix Branches**:
   - Used for fixing specific issues.
   - Created from `dev` or `main` depending on where the bug exists.

### Example Workflow
1. **Starting a Feature**:
   ```bash
   git checkout dev
   git pull origin dev
   git checkout -b feature/add-search-bar
   ```

2. **Working on the Feature**:
   - Make changes, commit regularly.
   ```bash
   git commit -m "feat(search): implement search bar UI"
   ```

3. **Merging Back**:
   - Push the branch and create a pull request to `dev`.

4. **Review and Merge**:
   - Get your code reviewed and merged to `dev`.

---

## Coding Standards

### Backend (Spring Boot)

1. **Java Naming Conventions**:
   - Classes: Use `PascalCase` (e.g., `UserService`).
   - Variables and methods: Use `camelCase` (e.g., `getUserData`).

2. **Document Classes and Methods**:
   ```java
   /**
    * Service class for managing users.
    */
   @Service
   public class UserService {
       /**
        * Retrieves user by ID.
        * @param userId the ID of the user
        * @return User object
        */
       public User getUserById(String userId) {
           // Implementation
       }
   }
   ```

3. **Logging**:
   - Use SLF4J for meaningful logs:
     ```java
     private static final Logger logger = LoggerFactory.getLogger(UserService.class);
     logger.info("Fetching user with ID {}", userId);
     ```

### Frontend (Angular)

1. **File Naming**:
   - Use `kebab-case`: `user-profile.component.ts`.

2. **Code Consistency**:
   - Always use `TypeScript` features like `interfaces`:
     ```typescript
     export interface User {
         id: number;
         name: string;
         email: string;
     }
     ```

3. **Best Practices**:
   - Keep components small:
     ```typescript
     @Component({
         selector: 'app-user-profile',
         templateUrl: './user-profile.component.html'
     })
     export class UserProfileComponent {
         @Input() user: User;
     }
     ```

### Mobile (Flutter)

1. **Widget Design**:
   - Keep widgets modular:
     ```dart
     class UserCard extends StatelessWidget {
       final String userName;

       UserCard({required this.userName});

       @override
       Widget build(BuildContext context) {
         return Card(
           child: ListTile(
             title: Text(userName),
           ),
         );
       }
     }
     ```

2. **Naming Conventions**:
   - Classes: `PascalCase` (e.g., `UserCard`).
   - Variables: `camelCase` (e.g., `userName`).

3. **Comments and Documentation**:
   - Document key widgets and methods:
     ```dart
     /// This widget displays a card for the user.
     class UserCard extends StatelessWidget {
       //...
     }
     ```

---

## Pull Request Guidelines
1. Ensure your branch is up-to-date with `dev`.
2. Write a clear pull request title and description.
3. Link related issues in the pull request description.
4. Ensure all tests pass before submitting.
5. Request a review from at least one team member.
6. Address all review comments promptly.

---

## Code of Conduct
We expect all contributors to adhere to our [Code of Conduct](CODE_OF_CONDUCT.md), which emphasizes:
- Respectful communication.
- A commitment to collaboration and inclusion.
- Professionalism in all interactions.

---

