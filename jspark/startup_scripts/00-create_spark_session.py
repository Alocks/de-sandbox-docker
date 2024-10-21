from pyspark.sql import SparkSession

spark = SparkSession.builder.master("local").getOrCreate()
sc = spark.sparkContext