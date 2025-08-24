# Airline Management System (Alloy Model)

This repository contains the **Alloy model for an Airline Management System**. The system models flight scheduling, pilot assignments, passenger bookings, airplane maintenance, and enforces a set of structural, logical, and business rules using Alloy.

## Overview
The Airline Management System models airline operations, ensuring:

- Unique identifiers for flights and airplanes
- Proper pilot assignments and certifications
- Passenger eligibility and frequent flyer tracking
- Airplane maintenance scheduling
- Compliance with safety, operational, and business rules

The Alloy model allows verification of system consistency through **predicates** and **assertions**.

## System Features
- Schedule flights with assigned pilots and airplanes
- Assign pilots to flights while respecting rest periods and daily limits
- Book passengers, track frequent flyers, and enforce passport rules for international flights
- Perform airplane maintenance and validate flight schedules
- Query system state (e.g., international flights, certified pilots, airplanes needing maintenance)

## Alloy Model Structure
**Core Signatures:**
- `Airplane` – with model, capacity, maintenance status
- `Pilot` – with license number, experience, certifications
- `Flight` – with departure/arrival info, duration, passengers, pilot, airplane
- `Passenger` – with passport number, booked flights, special needs, frequent flyer status
- `Airport` – with code, location, and international flag
- `Model` – airplane specifications

**Basic Types:**
- `Boolean` (True, False)
- `Location` (Domestic, International)
- `Date` (day, month, year)

## Constraints and Assertions
The model includes:
- **Structural Constraints** – uniqueness, cardinality
- **Moderate Logic Rules** – valid dates, airport rules, pilot certification
- **Complex/Dependent Constraints** – pilot rest periods, max daily flights, maintenance scheduling
- **Business Rules** – max domestic flight duration, frequent flyer benefits
- **Assertions** – verify flight-pilot assignment consistency, non-negative airplane capacities, and no self-loop flights

## Predicates and Commands
- `scheduleFlight` – schedule a flight with constraints
- `bookPassenger` – book a passenger and update frequent flyer status
- `assignPilot` – assign a pilot ensuring no conflicts
- `show`, `showInternationalFlights`, `showAirplanesNeedingMaintenance`, `showCertifiedPilots` – generate instances
- `check` commands to verify assertions

## Getting Started
1. Install [Alloy Analyzer](http://alloytools.org/) or go to FM Playground (https://play.formal-methods.net).
2. Open `AirlineManagementSystem.als`.
3. Run predicates to generate system instances.
4. Use `check` commands to verify assertions and invariants.

## Contributors
- Abdullah Daoud – 22I-2626  
- Usman Ali – 22I-2725  
- Faizan Rasheed – 22I-2734  

## License
This project is for academic purposes (Formal Methods in Software Engineering – FAST NUCES) and is not for commercial use.
