--Sample data to show functionality of database

INSERT INTO "cities" ("id", "city_name", "country_name")
VALUES ('1', 'raleigh', 'usa'),
('2', 'miami', 'usa'),
('3', 'charleston', 'usa'),
('4', 'new york', 'usa');

INSERT INTO "travelers" ("id", "first_name", "last_name", "home_city_id")
VALUES ('1', 'bob', 'smith', '1'),
('2', 'jen', 'jenkins', '3'),
('3', 'scuba', 'steve', '3');

INSERT INTO "vacations" ("id", "traveler_id", "start_date", "end_date")
VALUES ('1', '1', '20260101', '20260115'),
('2', '2', '20260101', '20260115'),
('3', '3', '20260201', '20260207');

INSERT INTO "vacation_legs" ("id", "traveler_id", "vacation_id", "start_date", "end_date", "mode_of_transit", "destination_city_id", "hotel", "last_leg")
VALUES ('1', '1', '1', '20260101', '20260115', 'plane', '2', 'holiday inn', '0'),
('2', '1', '1', '20260115', '20260115', 'plane', '1', '', '1'),
('3', '2', '2', '20260101', '20260115', 'plane', '2', 'holiday inn', '0'),
('4', '2', '2', '20260115', '20260115', 'plane', '3', '', '1'),
('5', '3', '3', '20260201', '20260207', 'train', '4', 'hilton', '0'),
('6', '3', '3', '20260207', '20260207', 'train', '3', '', '1');

INSERT INTO "activities" ("id", "name_of_activity", "additional_notes")
VALUES ('1', 'snorkeling', ''),
('2', 'broadway', 'front row seats'),
('3', 'fancy dinner reservation', 'table for two');

INSERT INTO "planned_activity" ("id", "activity_id", "vacation_leg_id")
VALUES ('1', '1', '1'),
('2', '1', '3'),
('3', '2', '5'),
('4', '3', '3');


--Who was in Miami the same time as Bob Smith?
SELECT "first_name", "last_name"
FROM "travelers"
WHERE "id" = (
    SELECT "traveler_id"
    FROM "vacation_legs"
    WHERE "start_date" = '20260101' AND "end_date" = '20260115' AND "traveler_id" != (
        SELECT "id"
        FROM "travelers"
        WHERE "first_name" = 'bob' AND "last_name" = 'smith')
    )
;

--Queries to show functionality of database

--Total number of vacations booked by the agency
SELECT COUNT("id") AS "vacations booked"
FROM "vacations";

--Jen Jenkins would like to drive to Miami instead of take a plane
UPDATE "vacation_legs"
SET "mode_of_transit" = 'car'
WHERE "vacation_id" = (
    SELECT "id"
    FROM "vacations"
    WHERE "traveler_id" = (
        SELECT "id"
        FROM "travelers"
        WHERE "first_name" = 'jen' AND "last_name" = 'jenkins')
    )
;

--Scuba Steve wants to cancel his whole vacation.
DELETE FROM "vacations"
WHERE "id" = '3';


--Show all customers from Charleston.
SELECT *
FROM "travelers"
WHERE "home_city_id" = (
    SELECT "id"
    FROM "cities"
    WHERE "city_name" = 'charleston')
;

--What activity did Jen do without Bob?
SELECT "name_of_activity" AS "what is jen doing without bob?"
FROM "activities"
JOIN "planned_activity" ON "activities"."id" = "planned_activity"."activity_id"
WHERE "vacation_leg_id" = (
    SELECT "id"
    FROM "vacation_legs"
    WHERE "vacation_id" = (
        SELECT "id"
        FROM "vacations"
        WHERE "traveler_id" = (
            SELECT "id"
            FROM "travelers"
            WHERE "first_name" = 'jen' AND "last_name" = 'jenkins')
        )
    )
EXCEPT
SELECT "name_of_activity"
FROM "activities"
JOIN "planned_activity" ON "activities"."id" = "planned_activity"."activity_id"
WHERE "vacation_leg_id" = (
    SELECT "id"
    FROM "vacation_legs"
    WHERE "vacation_id" = (
        SELECT "id"
        FROM "vacations"
        WHERE "traveler_id" = (
            SELECT "id"
            FROM "travelers"
            WHERE "first_name" = 'bob' AND "last_name" = 'smith')
        )
    )
;
