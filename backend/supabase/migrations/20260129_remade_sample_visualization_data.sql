-- This removes the old tables that i currently have as the one sample visauzalition
drop table if exists public.sample_visualization;

create table public.sample_visualization (

  -- This is the id that we currently gave sample as the sample csv that we received
  id int primary key,

  -- Archaeological site code sample
  site text not null,

  -- dikffereent units
  unit text not null,

  -- the analysis years throughout the time
  analysis_year int not null,

  -- Animal type for a sample data for now
  taxon text
);

insert into public.sample_visualization (id, site, unit, analysis_year, taxon) values
(1, 'DiRw-28', 'N84SW1', 2017, 'Deer'),
(2, 'DiRw-28', 'N85SE2', 2018, 'Unknown Mammal'),
(3, 'DjRx-6',  'C12',    2019, 'Fish'),
(4, 'DiRw-30', 'N90NE3', 2020, 'Bird'),
(5, 'DjRx-6',  'C13',    2021, 'Sea Mammal');