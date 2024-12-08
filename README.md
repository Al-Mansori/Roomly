

# **Roomly: Workspace and Learning Center Reservation Platform**

Roomly is a cutting-edge platform that simplifies the process of reserving workspaces, gaming zones, and learning centers. By integrating AI-powered recommendations, real-time booking, and advanced analytics, Roomly provides a seamless user experience for individuals and businesses while empowering venue owners with actionable insights.
 
---

## **Table of Contents**
1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Project Structure](#project-structure)
7. [Contributing](#contributing)
8. [License](#license)
9. [Acknowledgments](#acknowledgments)

---

## **Project Overview**

With the growing demand for flexible workspaces and shared facilities, Roomly addresses the inefficiencies in the current booking systems by providing:
- Real-time booking capabilities.
- Personalized AI-driven recommendations.
- Analytics for venue operators to optimize their resources.

**Mission**: To transform the workspace booking landscape with an intuitive, all-encompassing platform that fosters inclusivity, transparency, and sustainability.

**Repository Link**: [Roomly GitHub Repository](https://github.com/Al-Mansori/Roomly)

---

## **Features**

### **For Users**
- **Search & Book**: Find and reserve workspaces, gaming zones, or educational rooms with advanced filters.
- **AI Recommendations**: Get personalized suggestions based on preferences, budget, and location.
- **Seamless Experience**: Enjoy multi-language support, smart check-ins, and a loyalty rewards system.

### **For Venue Operators**
- **Management Tools**: Add and manage rooms with customizable options.
- **Analytics Dashboard**: Gain actionable insights to optimize occupancy and revenue.
- **Predictive Model**: Forecast booking cancellations and plan resources accordingly.

---

## **Tech Stack**

- **Backend**: Spring Boot
- **Frontend**: Angular
- **Mobile App**: Flutter
- **Database**: MySQL
- **AI/ML**: Python (for AI-powered recommendations and predictive models)
- **Tools**: Docker, Jenkins (CI/CD), JUnit (testing)

---

## **Installation**

### Prerequisites
- [Java Development Kit (JDK)](https://www.oracle.com/java/technologies/javase-downloads.html) 11+
- [Node.js and npm](https://nodejs.org/)
- [Flutter SDK](https://flutter.dev/)
- [MySQL](https://www.mysql.com/)

### Steps
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/Al-Mansori/Roomly.git
   cd Roomly
   ```

2. **Backend**:
   - Navigate to the `src/backend/` directory.
   - Build and run the Spring Boot application:
     ```bash
     ./mvnw spring-boot:run
     ```

3. **Frontend**:
   - Navigate to the `src/frontend/` directory.
   - Install dependencies and run the development server:
     ```bash
     npm install
     ng serve
     ```

4. **Mobile App**:
   - Navigate to the `src/mobile/` directory.
   - Run the Flutter app:
     ```bash
     flutter pub get
     flutter run
     ```

5. **Database**:
   - Import the provided database schema and seed data from `data/` into MySQL.

---

## **Usage**

1. **User Flow**:
   - Sign up or log in to explore available workspaces.
   - Use filters to search for spaces based on your preferences.
   - Book your workspace and manage reservations from the dashboard.

2. **Venue Owner Flow**:
   - Log in to manage your venue’s rooms, bookings, and analytics dashboard.

---

## **Project Structure**

```plaintext
Roomly/
│
├── src/               # Source code
│   ├── backend/       # Spring Boot backend
│   ├── frontend/      # Angular frontend
│   ├── mobile/        # Flutter mobile app
│   └── scripts/       # Supporting scripts
│
├── data/              # Data-related files (e.g., SQL schemas, datasets)
│
├── docs/              # Documentation (e.g., reports, UML diagrams)
│
├── tests/             # Unit and integration tests
│
├── .gitignore         # Git ignored files
├── LICENSE            # License file
├── README.md          # Project overview
└── CONTRIBUTING.md    # Contribution guidelines
```

---

## **Contributing**

We welcome contributions to Roomly! Please check out the [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on how to report issues, suggest features, and make code contributions.

---

## **License**

This project is licensed under the [GNU AFFERO GENERAL PUBLIC LICENSE
](LICENSE.md).

---

## **Acknowledgments**

We extend our gratitude to:
- **Dr. Ehab Ezzat** (Supervisor) and **TA Mohamed Ramadan** for their guidance and support.
- Cairo University, Faculty of Computers and Artificial Intelligence, for providing the resources and environment to develop this project.
- Our teammates and contributors who worked tirelessly to bring Roomly to life.

---

