if __name__ == "__main__":
	spark = SparkSession.builder.appName("Shakespere").getOrCreate()

	df = spark.read.text("hdfs://10.244.0.13:9000/testdata/*")

	df.count()

	wordCounts = df.select(explose(split(df.value,"\s+")).alias("word")).groupBy("word").count()

	print("Word count statistics: " + wordCounts.collect())
	
	spark.stop()
