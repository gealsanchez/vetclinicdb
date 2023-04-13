SELECT
  *
FROM
  animals
WHERE
  name LIKE '%mon%';

SELECT
  name
FROM
  animals
WHERE
  date_of_birth BETWEEN '2016-01-01'
  AND '2019-12-31';

SELECT
  name
FROM
  animals
WHERE
  neutered IS TRUE
  AND escape_attempts < 3;

SELECT
  date_of_birth
FROM
  animals
WHERE
  name IN ('Agumon', 'Pikachu');

SELECT
  name,
  escape_attempts
FROM
  animals
WHERE
  weight_kg > 10.5;

SELECT
  *
FROM
  animals
WHERE
  neutered IS TRUE;

SELECT
  *
FROM
  animals
WHERE
  name <> 'Gabumon';

SELECT
  *
FROM
  animals
WHERE
  weight_kg BETWEEN 10.4
  and 17.3;

/*TRANSACTIONS:
 /*TRANSACTION 1: Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.*/
BEGIN;

UPDATE
  animals
SET
  species = 'unspecified';

SELECT
  *
FROM
  animals;

ROLLBACK;

SELECT
  *
FROM
  animals;

/*TRANSACTION 2: 
 Inside a transaction:
 Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
 Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
 Commit the transaction.
 Verify that change was made and persists after commit.*/
BEGIN;

UPDATE
  animals
SET
  species = 'digimon'
WHERE
  name LIKE '%mon%';

SELECT
  *
FROM
  animals;

UPDATE
  animals
SET
  species = 'pokemon'
WHERE
  species IS NULL;

SELECT
  *
FROM
  animals;

COMMIT;

SELECT
  *
FROM
  animals;

/*TRANSACTION 3:
 Inside a transaction delete all records in the animals table, then roll back the transaction.After the rollback verify if all records in the animals table still exists.*/
BEGIN;

DELETE FROM
  animals;

SELECT
  *
FROM
  animals;

ROLLBACK;

SELECT
  *
FROM
  animals;

/*TRANSACTION 4:
 Inside a transaction:
 Delete all animals born after Jan 1st, 2022.
 Create a savepoint for the transaction.
 Update all animals' weight to be their weight multiplied by -1.
 Rollback to the savepoint
 Update all animals' weights that are negative to be their weight multiplied by -1.
 Commit transaction*/
BEGIN;

DELETE FROM
  animals
WHERE
  date_of_birth > '2022-01-01';

SELECT
  *
FROM
  animals;

SAVEPOINT savepoint1;

UPDATE
  animals
SET
  weight_kg = weight_kg * -1;

SELECT
  *
FROM
  animals;

ROLLBACK TO savepoint1;

SELECT
  *
FROM
  animals;

UPDATE
  animals
SET
  weight_kg = weight_kg * -1
WHERE
  weight_kg < 0;

SELECT
  *
FROM
  animals;

COMMIT;

SELECT
  *
FROM
  animals;

/*Write queries to answer the following questions:
 1. How many animals are there?
 2. How many animals have never tried to escape?
 3. What is the average weight of animals?
 4. Who escapes the most, neutered or not neutered animals?
 5 What is the minimum and maximum weight of each type of animal?
 6. What is the average number of escape attempts per animal type of those born between 1990 and 2000?*/
SELECT
  COUNT(*)
FROM
  animals;

SELECT
  COUNT(*)
FROM
  animals
WHERE
  escape_attempts = 0;

SELECT
  AVG(weight_kg)
FROM
  animals;

SELECT
  neutered,
  MAX(escape_attempts)
FROM
  animals
GROUP BY
  neutered;

SELECT
  species,
  MIN(weight_kg),
  MAX(weight_kg)
FROM
  animals
GROUP BY
  species;

SELECT
  species,
  AVG(escape_attempts)
FROM
  animals
WHERE
  date_of_birth BETWEEN '1990-01-01'
  AND '2000-12-31'
GROUP BY
  species;

/*Write queries (using JOIN) to answer the following questions:
 1. What animals belong to Melody Pond?
 2. List of all animals that are pokemon (their type is Pokemon).
 3. List all owners and their animals, remember to include those that don't own any animal.
 4. How many animals are there per species?
 5. List all Digimon owned by Jennifer Orwell.
 6. List all animals owned by Dean Winchester that haven't tried to escape.
 7. Who owns the most animals?*/
SELECT
  name
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
WHERE
  owners.full_name = 'Melody Pond';

SELECT
  animals.name
FROM
  animals
  JOIN species ON animals.species_id = species.id
WHERE
  species.name = 'Pokemon';

SELECT
  owners.full_name,
  animals.name
FROM
  owners
  LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT
  species.name,
  COUNT(animals.name)
FROM
  animals
  JOIN species ON animals.species_id = species.id
GROUP BY
  species.id;

SELECT
  animals.name
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
  JOIN species ON animals.species_id = species.id
WHERE
  species.name = 'Digimon'
  AND owners.full_name = 'Jennifer Orwell';

SELECT
  animals.name
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
WHERE
  owners.full_name = 'Dean Winchester'
  AND animals.escape_attempts = 0;

SELECT
  owners.full_name,
  COUNT(animals.name)
FROM
  animals
  JOIN owners ON animals.owner_id = owners.id
GROUP BY
  owners.full_name
ORDER BY
  COUNT DESC
LIMIT
  1;

/*Write queries to answer the following:
 1. Who was the last animal seen by William Tatcher?
 2. How many different animals did Stephanie Mendez see?
 3. List all vets and their specialties, including vets with no specialties.
 4. List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
 5. What animal has the most visits to vets?
 6. Who was Maisy Smith's first visit?
 7. Details for most recent visit: animal information, vet information, and date of visit.
 8. How many visits were with a vet that did not specialize in that animal's species?
 9. What specialty should Maisy Smith consider getting? Look for the species she gets the most.*/
SELECT
  animals.name
FROM
  visits
  JOIN animals ON visits.animals_id = animals.id
  JOIN vets ON visits.vets_id = vets.id
WHERE
  vets.name = 'William Tatcher'
ORDER BY
  visits.date_of_visit DESC
LIMIT
  1;

SELECT
  COUNT(DISTINCT animals.name)
FROM
  visits
  JOIN animals ON visits.animals_id = animals.id
  JOIN vets ON visits.vets_id = vets.id
WHERE
  vets.name = 'Stephanie Mendez';

SELECT
  vets.name,
  species.name
FROM
  vets
  LEFT JOIN specializations ON vets.id = specializations.vets_id
  LEFT JOIN species ON species.id = specializations.species_id;

SELECT
  animals.name
FROM
  visits
  JOIN animals ON visits.animals_id = animals.id
  JOIN vets ON visits.vets_id = vets.id
WHERE
  vets.name = 'Stephanie Mendez'
  AND visits.date_of_visit BETWEEN '2020-04-01'
  AND '2020-08-30';

SELECT
  animals.name
FROM
  visits
  JOIN animals ON visits.animals_id = animals.id
GROUP BY
  animals.name
ORDER BY
  COUNT(animals.name) DESC
LIMIT
  1;

SELECT
  animals.name
FROM
  visits
  JOIN animals ON visits.animals_id = animals.id
  JOIN vets ON visits.vets_id = vets.id
WHERE
  vets.name = 'Maisy Smith'
ORDER BY
  visits.date_of_visit
LIMIT
  1;

SELECT
  animals.name,
  vets.name,
  visits.date_of_visit
FROM
  visits
  JOIN animals ON visits.animals_id = animals.id
  JOIN vets ON visits.vets_id = vets.id
ORDER BY
  visits.date_of_visit DESC
LIMIT
  1;

SELECT
  COUNT(*)
FROM
  visits
  JOIN animals ON visits.animals_id = animals.id
  JOIN vets ON visits.vets_id = vets.id
  JOIN specializations ON vets.id = specializations.vets_id
WHERE
  specializations.species_id <> animals.species_id;

SELECT
  species.name
FROM
  visits
  JOIN vets ON visits.vets_id = vets.id
  JOIN animals ON visits.animals_id = animals.id
  JOIN species ON animals.species_id = species.id
WHERE
  vets.name = 'Maisy Smith'
GROUP BY
  species.name
ORDER BY
  COUNT(species.name) DESC
LIMIT
  1;

explain analyze
SELECT
  COUNT(*)
FROM
  visits
where
  animals_id = 4;

explain analyze
SELECT
  *
FROM
  visits
where
  vets_id = 2;

explain analyze
SELECT
  *
FROM
  owners
where
  email = 'owner_18327@mail.com';