from pyspark.sql import SparkSession
from pyspark.sql.functions import *

if __name__ == "__main__":
        spark = SparkSession.builder.appName("Shakespere").getOrCreate()
        df = spark.read.text("hdfs://hdfs-service:9000/data/raw/ds=shakespeare/*/*")
        df.count()
        wordCounts = df.select(explode(split(df.value,"\s+")).alias("word")).groupBy("word").count()
        print(wordCounts.filter("`count` >= 10").sort(col("count").desc()).show())
        spark.stop()
