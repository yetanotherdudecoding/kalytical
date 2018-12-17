from pyspark.sql import SparkSession

if __name__ == "__main__":
	spark = SparkSession.builder.appName("Shakespere").getOrCreate()
	df = spark.read.text("hdfs://10.110.34.48:9000/testdata/*")
	df.count()
	wordCounts = df.select(explose(split(df.value,"\s+")).alias("word")).groupBy("word").count()
	print("Word count statistics: " + wordCounts.collect())
	spark.stop()
