# Airline Management System (Alloy Model) ✈️

This repository contains the **Alloy model for an Airline Management System**. The system models flight scheduling, pilot assignments, passenger bookings, airplane maintenance, and enforces structural, logical, and business rules using Alloy.

---

## Overview 🌐

The Airline Management System models airline operations, ensuring:

- Unique identifiers for flights and airplanes 
- Proper pilot assignments and certifications 
- Passenger eligibility and frequent flyer tracking 
- Airplane maintenance scheduling 
- Compliance with safety, operational, and business rules 

The Alloy model allows verification of system consistency through **predicates** and **assertions**.

---

## System Features 🚀

- **Flight Scheduling**: Schedule flights with assigned pilots and airplanes. 
- **Pilot Assignments**: Assign pilots while respecting rest periods and daily limits. 
- **Passenger Bookings**: Book passengers, track frequent flyers, and enforce passport rules for international flights. 
- **Airplane Maintenance**: Perform maintenance and validate flight schedules. 
- **System Queries**: Query international flights, certified pilots, and airplanes needing maintenance. 

---

## Alloy Model Structure 🏗️

### Core Signatures

- `Airplane` – Model, capacity, maintenance status. 
- `Pilot` – License number, experience, certifications. 
- `Flight` – Departure/arrival info, duration, passengers, pilot, airplane. 
- `Passenger` – Passport number, booked flights, special needs, frequent flyer status. 
- `Airport` – Code, location, international flag. 
- `Model` – Airplane specifications. 📏

### Basic Types

- `Boolean` – True, False. 
- `Location` – Domestic, International. 
- `Date` – Day, month, year. 

---

## Constraints and Assertions 📜

- **Structural Constraints**: Uniqueness, cardinality.
- **Moderate Logic Rules**: Valid dates, airport rules, pilot certification.
- **Complex/Dependent Constraints**: Pilot rest periods, max daily flights, maintenance scheduling.
- **Business Rules**: Max domestic flight duration, frequent flyer benefits.
- **Assertions**: Verify flight-pilot assignment consistency, non-negative airplane capacities, no self-loop flights.

---

## Predicates and Commands 🛠️

- `scheduleFlight` – Schedule a flight with constraints.
- `bookPassenger` – Book a passenger and update frequent flyer status.
- `assignPilot` – Assign a pilot ensuring no conflicts.
- `show`, `showInternationalFlights`, `showAirplanesNeedingMaintenance`, `showCertifiedPilots` – Generate instances.
- `check` commands to verify assertions and invariants.

---

## Getting Started 🚀

1. **Install Alloy Analyzer** 🔧:
   - Download from AlloyTools or use FM Playground.
2. **Open the Model** 📂:
   - Load `AirlineManagementSystem.als` in Alloy Analyzer.
3. **Run Predicates** ▶️:
   - Execute predicates to generate system instances.
4. **Verify Assertions** ✅:
   - Use `check` commands to validate system invariants.

---

## Project Structure 📁

```plaintext
.
├── AirlineManagementSystem.als  # Alloy model file
├── README.md                    # Project documentation
└── LICENSE                      # License file
```

---

## Contributors 👥

- **Abdullah Daoud** – 22I-2626
- **Usman Ali** – 22I-2725
- **Faizan Rasheed** – 22I-2734

---

## License 📜

This project is for **academic purposes** (Formal Methods in Software Engineering – FAST NUCES) and is not for commercial use. Licensed under the MIT License – see `LICENSE` for details.

---
