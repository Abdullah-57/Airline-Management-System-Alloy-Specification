////////////////////////////////////////////
// Basic Definitions
////////////////////////////////////////////

// Boolean type with two values: True and False.
abstract sig Boolean {}
one sig True, False extends Boolean {} // Simple structural: Defines a Boolean type with two values, True and False.

// Date structure: day, month, and year fields.
sig Date {
  day: Int,
  month: Int,
  year: Int
} // Simple structural: Defines a Date type with three fields: day, month, and year.

// Flight locations: either Domestic or International.
abstract sig Location {}
one sig Domestic, International extends Location {} // Simple structural: Defines the Location type with two values (Domestic, International).

////////////////////////////////////////////
// Core Entities
////////////////////////////////////////////

// Airplane model: max range, fuel capacity, required pilots.
sig Model {
  maxRange: Int,
  fuelCapacity: Int,
  requiredPilots: Int
} // Simple structural: Defines an Airplane Model with three attributes: max range, fuel capacity, and required pilots.

// Airport with a unique code, location type, and international status.
sig Airport {
  code: one Int,
  location: one Location,
  isInternational: Boolean
} // Simple structural: Defines an Airport entity with a unique code, location type, and international status.

// Pilot with license number, experience, flights, international certification.
sig Pilot {
  licenseNumber: one Int,
  experienceYears: Int,
  assignedFlights: set Flight,
  isCertifiedInternational: Boolean,
  lastFlightDate: lone Date
} // Simple structural: Defines a Pilot entity with license number, experience, assigned flights, international certification, and last flight date.

// Airplane: model, capacity, maintenance status, registration, flights.
sig Airplane {
  model: one Model,
  capacity: Int,
  maintenanceStatus: Boolean,
  lastMaintenance: one Date,
  registrationNumber: one Int,
  flights: set Flight
} // Simple structural: Defines an Airplane entity with a model, capacity, maintenance status, last maintenance date, and registration number.

// Passenger with passport number, bookings, and special attributes.
sig Passenger {
  passportNumber: one Int,
  bookedFlights: set Flight,
  hasSpecialNeeds: Boolean,
  isFrequentFlyer: Boolean
} // Simple structural: Defines a Passenger entity with passport number, booked flights, special needs status, and frequent flyer status.

// Flight: flight number, airports, dates, duration, passengers, pilot, airplane.
sig Flight {
  flightNumber: one Int,
  departureAirport: one Airport,
  arrivalAirport: one Airport,
  departureDate: one Date,
  arrivalDate: one Date,
  duration: Int,
  isInternational: Boolean,
  passengers: set Passenger,
  pilot: one Pilot,
  airplane: one Airplane
} // Simple structural: Defines a Flight entity with flight number, departure and arrival airports, departure and arrival dates, flight duration, international status, passengers, pilot, and airplane.

////////////////////////////////////////////
// Constraints
////////////////////////////////////////////

// Unique registration numbers for airplanes and flight numbers.
fact UniqueIdentifiers {
  all disj a1, a2: Airplane | a1.registrationNumber != a2.registrationNumber
  and all disj f1, f2: Flight | f1.flightNumber != f2.flightNumber
} // Simple structural: Ensures uniqueness of airplane registration numbers and flight numbers (basic constraint ensuring no duplicates).

// Positive values for capacities, ranges, registration numbers, etc.
fact PositiveValues {
  all a: Airplane | a.capacity > 0 and a.registrationNumber > 0
  and all m: Model | m.maxRange > 0 and m.fuelCapacity > 0 and m.requiredPilots >= 1
  and all f: Flight | f.duration > 0 and f.flightNumber > 0
} // Simple structural: Ensures all numeric attributes have positive values and meet the required conditions (e.g., capacity > 0, required pilots >= 1).

// Arrival date must be strictly after departure date.
fact ValidFlightDates {
  all f: Flight |
    (f.arrivalDate.year > f.departureDate.year) or
    (f.arrivalDate.year = f.departureDate.year and (
      f.arrivalDate.month > f.departureDate.month or
      (f.arrivalDate.month = f.departureDate.month and f.arrivalDate.day > f.departureDate.day)
    ))
} // Moderate logic rule: Ensures that the arrival date is strictly after the departure date.


// Flight airport rules: no self-loop, international consistency.
fact FlightAirportRules {
  all f: Flight | {
    f.departureAirport != f.arrivalAirport
    and (f.isInternational = True implies (
      f.departureAirport.isInternational = True
      and f.arrivalAirport.isInternational = True
    ))
  }
} // Moderate logic rule: Ensures there are no self-loop flights (departure equals arrival) and ensures international flights are consistent (both departure and arrival airports must be international).

// International flights require certified pilots with experience.
fact PilotCertification {
  all f: Flight |
    f.isInternational = True implies (
      f.pilot.experienceYears >= 5
      and f.pilot.isCertifiedInternational = True
    )
} // Moderate logic rule: Ensures that pilots assigned to international flights have at least 5 years of experience and international certification.


// International flights require passengers with positive passport numbers.
fact PassengerPassportForInternational {
  all f: Flight | all p: f.passengers |
    (f.isInternational = True implies p.passportNumber > 0)
} // Moderate logic rule: Ensures that passengers on international flights have positive passport numbers.

// Flight duration must not exceed the airplane's max range.
fact FlightDurationWithinRange {
  all f: Flight | f.duration <= f.airplane.model.maxRange
} // Moderate logic rule: Ensures that the flight duration does not exceed the maximum range of the airplane's model.


// Special needs passengers require extra documentation.
fact SpecialNeedsDocumentation {
  all p: Passenger | p.hasSpecialNeeds = True implies p.passportNumber > 0
} // Moderate logic rule: Ensures that passengers with special needs have valid passport numbers (for international flights).


// Airplanes must have a minimum capacity for international flights.
fact InternationalFlightCapacity {
  all f: Flight | f.isInternational = True implies f.airplane.capacity >= 100
} // Moderate logic rule: Ensures that airplanes used for international flights have a minimum capacity of 100 passengers.


// Maintenance logic for airplanes and flight scheduling.
fact MaintenanceLogic {
  all a: Airplane | {
    (a.maintenanceStatus = True implies some f: a.flights |
      f.departureDate.year >= a.lastMaintenance.year)
    and (all f: a.flights | f.departureDate.year <= a.lastMaintenance.year + 1)
  }
} // Complex/dependent constraint: Ensures that an airplane that is marked for maintenance is only used for flights scheduled after its last maintenance and within the next year.


// Pilot rest period: At least 1 day between flights.
fact PilotRestPeriod {
  all p: Pilot | all disj f1, f2: p.assignedFlights | {
    f1.departureDate.year = f2.departureDate.year and
    f1.departureDate.month = f2.departureDate.month and
    f1.departureDate.day < f2.departureDate.day implies
      f2.departureDate.day >= f1.departureDate.day + 1
  }
} // Complex/dependent constraint: Ensures pilots have at least 1 day of rest between flights on the same date.


// No overlapping flights assigned to pilots.
fact NoFlightOverlapForPilots {
  all p: Pilot | all disj f1, f2: p.assignedFlights |
    (f1.departureDate.year != f2.departureDate.year)
    or (f1.departureDate.month != f2.departureDate.month)
    or (f1.departureDate.day != f2.departureDate.day)
} // Complex/dependent constraint: Ensures that no pilot is assigned overlapping flights on the same day.


// Pilots meet the model's pilot requirement (simplified to 1).
fact PilotMeetsModelRequirement {
  all p: Pilot | all f: p.assignedFlights |
    f.airplane.model.requiredPilots <= 1
} // Moderate logic rule: Ensures that the number of pilots assigned to a flight does not exceed the model's required pilot count (in this case, 1).


// Maximum daily flights for a pilot.
fact MaxDailyFlightsForPilot {
  all p: Pilot | all d: Date | {
    let dailyFlights = {f: p.assignedFlights | f.departureDate.year = d.year and f.departureDate.month = d.month and f.departureDate.day = d.day} |
    #dailyFlights <= 2
  }
} // Business rule: Ensures that a pilot is not assigned more than two flights on the same day.


// Maximum flight duration for domestic flights.
fact MaxDomesticFlightDuration {
  all f: Flight | f.isInternational = False implies f.duration <= 5
} // Business rule: Ensures that the duration of domestic flights does not exceed 5 hours.


// Frequent flyers are defined based on booking 5 or more flights.
fact FrequentFlyerBenefits {
  all p: Passenger |
    (p.isFrequentFlyer = True implies #p.bookedFlights >= 5)
} // Business rule: Defines frequent flyers as passengers who have booked 5 or more flights.


// Emergency equipment requirement for international flights.
fact EmergencyEquipmentForInternational {
  all f: Flight | f.isInternational = True implies f.airplane.capacity > 0
} // Business rule: Ensures that international flights have sufficient emergency equipment (implied by airplane capacity).

////////////////////////////////////////////
// Functional Predicates (Operations)
////////////////////////////////////////////

// Predicate to schedule a new flight.
pred scheduleFlight[f: Flight, a: Airplane, p: Pilot, dep: Airport, arr: Airport, depDate: Date, arrDate: Date] {
  f.airplane = a
  and f.pilot = p
  and f.departureAirport = dep
  and f.arrivalAirport = arr
  and f.departureDate = depDate
  and f.arrivalDate = arrDate
  and f in p.assignedFlights
  and f in a.flights
  // Ensure constraints are satisfied
  and f.departureAirport != f.arrivalAirport
  and (f.isInternational = True implies (
    f.departureAirport.isInternational = True and
    f.arrivalAirport.isInternational = True
  ))
  and (f.isInternational = True implies (
    f.pilot.experienceYears >= 5 and
    f.pilot.isCertifiedInternational = True
  ))
} // Complex/dependent constraint: Schedules a new flight by assigning an airplane and pilot, ensuring the flight satisfies various constraints (e.g., no self-loop, international rules, pilot certification).


// Predicate to book a passenger on a flight.
pred bookPassenger[p: Passenger, f: Flight] {
  f.passengers' = f.passengers + p
  and p.bookedFlights' = p.bookedFlights + f
  // Ensure passport requirement for international flights
  and (f.isInternational = True implies p.passportNumber > 0)
  // Update frequent flyer status
  and (p.isFrequentFlyer' = True iff #p.bookedFlights' >= 5)
} // Complex/dependent constraint: Books a passenger on a flight, ensuring the passport requirement for international flights and updating frequent flyer status.

// Fixes the inconsistency
fact PilotFlightAssignmentConsistencyFact {
  all f: Flight | f in f.pilot.assignedFlights
}

// Predicate to assign a pilot to a flight.
pred assignPilot[f: Flight, p: Pilot] {
  f.pilot' = p
  and p.assignedFlights' = p.assignedFlights + f
  // Ensure no overlapping flights
  and (all f2: p.assignedFlights | f2 != f implies (
    f.departureDate.year != f2.departureDate.year or
    f.departureDate.month != f2.departureDate.month or
    f.departureDate.day != f2.departureDate.day
  ))
  // Ensure pilot meets model requirement
  and f.airplane.model.requiredPilots <= 1
} // Complex/dependent constraint: Assigns a pilot to a flight, ensuring no overlapping flights and that the pilot meets the airplane model's requirement.

////////////////////////////////////////////
// Commands
////////////////////////////////////////////

// Show basic instance generation ensuring some entities exist.
pred show() {
  #Airplane > 0
  and #Flight > 0
  and #Pilot > 0
  and #Passenger > 0
} // Simple structural: Generates a basic instance ensuring that airplanes, flights, pilots, and passengers exist.


// Additional Predicates
pred showInternationalFlights() {
  all f: Flight | f.isInternational = True
} // Simple structural: Lists all international flights.

pred showAirplanesNeedingMaintenance() {
  all a: Airplane | a.maintenanceStatus = True
} // Simple structural: Lists all airplanes that require maintenance.

pred showCertifiedPilots() {
  all p: Pilot | p.isCertifiedInternational = True
} // Simple structural: Lists all pilots who are internationally certified.

////////////////////////////////////////////
// Assertions
////////////////////////////////////////////

assert NoNegativeAirplaneCapacity {
  all a: Airplane | a.capacity >= 0
} // Assertion: Ensures no airplane has a negative capacity.

assert FlightAssignedProperly {
  all f: Flight | one f.airplane and one f.pilot
} // Assertion: Ensures that every flight is properly assigned an airplane and a pilot.

assert PilotFlightAssignmentConsistency {
  all f: Flight | f in f.pilot.assignedFlights
} // Assertion: Ensures that each flight is included in the assigned flights of its respective pilot.

assert DifferentDepartureAndArrivalAirports {
  all f: Flight | f.departureAirport != f.arrivalAirport
} // Assertion: Ensures that no flight has the same departure and arrival airports.

////////////////////////////////////////////
// Commands to Check Assertions and Run Predicates
////////////////////////////////////////////

run show for 5 // Runs the 'show' predicate with 5 instances.
run showInternationalFlights for 5 // Runs the 'showInternationalFlights' predicate with 5 instances.
run showAirplanesNeedingMaintenance for 5 // Runs the 'showAirplanesNeedingMaintenance' predicate with 5 instances.
run showCertifiedPilots for 5 // Runs the 'showCertifiedPilots' predicate with 5 instances.

check NoNegativeAirplaneCapacity for 5 // Checks the 'NoNegativeAirplaneCapacity' assertion for 5 instances.
check FlightAssignedProperly for 5 // Checks the 'FlightAssignedProperly' assertion for 5 instances.
check PilotFlightAssignmentConsistency for 5 // Checks the 'PilotFlightAssignmentConsistency' assertion for 5 instances.
check DifferentDepartureAndArrivalAirports for 5 // Checks the 'DifferentDepartureAndArrivalAirports' assertion for 5 instances.
