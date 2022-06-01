-- Keep a log of any SQL queries you execute as you solve the mystery.

-- find the THEIF
-- find the report description of the crime
SELECT description FROM crime_scene_reports
WHERE year = 2020 AND month = 7 AND day = 28 AND street = 'Chamberlin Street';
-- find the interviews transcript of the day
SELECT name, transcript FROM interviews
WHERE year = 2020 AND month = 7 AND day = 28 AND transcript LIKE "%courthouse%";
-- 1st witness mentioned the security of courthouse, so I'll search in courthouse log
SELECT name FROM people
WHERE license_plate IN
(SELECT license_plate FROM courthouse_security_logs
WHERE year = 2020 AND month = 7 AND day = 28 AND activity = 'exit' AND hour = 10 AND (minute BETWEEN 15 AND 25))
-- 2nd witness mentioned ATM, so I'll search atm_transactions & in turn bank_accounts
INTERSECT
SELECT name FROM people
WHERE id IN
(SELECT person_id FROM bank_accounts
WHERE account_number IN
(SELECT account_number FROM atm_transactions
WHERE year = 2020 AND month = 7 AND day = 28
AND atm_location = 'Fifer Street' AND transaction_type = 'withdraw'))
-- 3rd witness mentioned flight& phone call, so I'll search flights, passengers, phone_calls
INTERSECT
SELECT name FROM people
WHERE phone_number IN
(SELECT caller from phone_calls
WHERE year = 2020 AND month = 7 AND day = 28 AND duration < 60)
INTERSECT
SELECT name FROM people
JOIN passengers ON people.passport_number = passengers.passport_number
JOIN flights ON flights.id = flight_id
JOIN airports ON airports.id = origin_airport_id
WHERE year = 2020 AND month = 7 AND day = 29 AND city = 'Fiftyville'
AND hour = (SELECT MIN(hour) FROM flights WHERE year = 2020
AND month = 7 AND day = 29 AND city = 'Fiftyville');

-- Find to where he escaped
SELECT city FROM airports
WHERE id =
(SELECT destination_airport_id FROM flights
WHERE id =
(SELECT flight_id FROM passengers
WHERE passport_number =
(SELECT passport_number FROM people
WHERE name = 'Ernest')));

-- Find the ACCOMPLICE
SELECT name FROM people
WHERE phone_number =
(SELECT receiver FROM phone_calls
WHERE caller =
(SELECT phone_number FROM people
WHERE name = 'Ernest') AND duration < 60);