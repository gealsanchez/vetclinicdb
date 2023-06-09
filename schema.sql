CREATE TABLE animals (
  id integer GENERATED ALWAYS AS IDENTITY,
  name varchar(40) not null,
  date_of_birth date not null,
  escape_attempts integer not null,
  neutered boolean not null,
  weight_kg decimal not null,
  PRIMARY KEY(id)
);

ALTER TABLE
  animals
ADD
  species varchar(40);

CREATE TABLE owners (
  id integer GENERATED ALWAYS AS IDENTITY,
  full_name VARCHAR(40),
  age integer,
  PRIMARY KEY(id)
);

CREATE TABLE species (
  id integer GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(40),
  PRIMARY KEY(id)
);

ALTER TABLE
  animals DROP COLUMN species;

ALTER TABLE
  animals
ADD
  species_id integer;

ALTER TABLE
  animals
ADD
  FOREIGN KEY (species_id) REFERENCES species(id);

SELECT
  *
FROM
  information_schema.columns
WHERE
  table_name = 'animals';

ALTER TABLE
  animals
ADD
  owner_id integer;

ALTER TABLE
  animals
ADD
  FOREIGN KEY (owner_id) REFERENCES owners(id);

CREATE TABLE vets (
  id integer GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(40),
  age integer,
  date_of_graduation date,
  PRIMARY KEY(id)
);

CREATE TABLE specializations (
  species_id integer REFERENCES species(id),
  vets_id integer REFERENCES vets(id)
);

CREATE TABLE visits (
  animals_id integer REFERENCES animals(id),
  vets_id integer REFERENCES vets(id),
  date_of_visit date
);

ALTER TABLE
  owners
ADD
  COLUMN email VARCHAR(120);

CREATE INDEX ind_animals_id ON visits (animals_id);

CREATE INDEX ind_vets_id ON visits (vets_id);

CREATE INDEX ind_email ON owners (email);