-- Data Combining

DROP TABLE IF EXISTS `raw_files.combined_data`;

CREATE TABLE IF NOT EXISTS `raw_files.combined_data` AS (
  SELECT * FROM `raw_files.202301-tripdata`
  UNION ALL
  SELECT * FROM `raw_files.202302-tripdata`
  UNION ALL
  SELECT * FROM `raw_files.202303-tripdata`
  UNION ALL
  SELECT * FROM `raw_files.202304-tripdata`
  UNION ALL
  SELECT * FROM `raw_files.202305-tripdata`
  UNION ALL
  SELECT * FROM `raw_files.202306-tripdata`
  UNION ALL
  SELECT * FROM `raw_files.202307-tripdata`
);

