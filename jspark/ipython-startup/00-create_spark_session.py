from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession


builder = SparkSession.builder \
    .master("local") \
    .appName("jupyter-lab") \
    .config("spark.sql.repl.eagerEval.enabled", True)

spark = configure_spark_with_delta_pip(builder).getOrCreate()
sc = spark.sparkContext
