DROP TABLE IF EXISTS data_analytics.yelp;
CREATE TABLE public.yelp 
(
  business_id   VARCHAR(255),
  review_date     TIMESTAMP,
  review_id       VARCHAR(255),
  stars           VARCHAR(5),
  review_text     VARCHAR(10000),
  review_type			Varchar(255),
  user_id					varchar(255),
  cool            INT,
  funny           INT,
  useful          INT
);
COMMIT;

-- Update the file path to the yelp.csv file before running code below
-- If you're using Windows, the / needs to be replaced with \ in the file path
WbImport 
-file='/Users/Craig_Sakuma/Desktop/Intermediate_SQL/yelp.csv'
-type=text
-table=public.yelp
-delimiter=|
-timestampFormat='yyyy-MM-dd'
-filecolumns=business_id, review_date,review_id, stars, review_text, review_type, user_id, cool, funny, useful
-batchsize=1000;
COMMIT;
