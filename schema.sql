--This file shows the schema used by the database

--Table for travelers
CREATE TABLE "travelers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "home_city_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("home_city_id") REFERENCES "cities"("id")
);

--Table for vacations
CREATE TABLE "vacations" (
    "id" INTEGER,
    "traveler_id" INTEGER NOT NULL,
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("traveler_id") REFERENCES "travelers"("id")
);

--Table for vacation legs within each vacation.  Last leg indicates a return home.
CREATE TABLE "vacation_legs" (
    "id" INTEGER,
    "traveler_id" INTEGER NOT NULL,
    "vacation_id" INTEGER NOT NULL,
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC NOT NULL,
    "mode_of_transit" TEXT NOT NULL,
    "destination_city_id" INTEGER NOT NULL,
    "hotel" TEXT,
    "last_leg" INTEGER NOT NULL CHECK ("last_leg" IN (0, 1)),
    PRIMARY KEY("id"),
    FOREIGN KEY("traveler_id") REFERENCES "travelers"("id"),
    FOREIGN KEY("vacation_id") REFERENCES "vacations"("id") ON DELETE CASCADE,
    FOREIGN KEY("destination_city_id") REFERENCES "cities"("id")
);

--Table for cities
CREATE TABLE "cities" (
    "id" INTEGER,
    "city_name" TEXT NOT NULL,
    "country_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

--Table for activities
CREATE TABLE "activities" (
    "id" INTEGER,
    "name_of_activity" TEXT NOT NULL,
    "additional_notes" TEXT,
    PRIMARY KEY("id")
);

--Junction table for activites and vacation legs
CREATE TABLE "planned_activity" (
    "id" INTEGER,
    "activity_id" INTEGER NOT NULL,
    "vacation_leg_id" INTEGER NOT NULL,
    PRIMARY KEY("id"),
    FOREIGN KEY("activity_id") REFERENCES "activities"("id"),
    FOREIGN KEY("vacation_leg_id") REFERENCES "vacation_legs"("id") ON DELETE CASCADE
);

--Indexes to speed up searches relating to the travelers table and vacation legs table
CREATE INDEX "traveler_name_search" ON "travelers" ("last_name", "first_name");
CREATE INDEX "vacation_legs_by_traveler" ON "vacation_legs" ("traveler_id");
CREATE INDEX "vacation_legs_by_vacation" ON "vacation_legs" ("vacation_id");

--View to show most popular destinations for customers
CREATE VIEW "most_popular" AS
SELECT "city_name", "country_name", COUNT("vacation_legs"."destination_city_id") AS "visits"
FROM "cities"
JOIN "vacation_legs" ON "cities"."id" = "vacation_legs"."destination_city_id"
WHERE "last_leg" = 0
GROUP BY "vacation_legs"."destination_city_id"
ORDER BY "visits" DESC
LIMIT 10;

