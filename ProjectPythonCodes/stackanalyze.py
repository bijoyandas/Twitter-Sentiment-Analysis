import urllib.request as urllib2
import json
import zlib
from pyspark import SparkConf,SparkContext

sc = SparkContext(conf=SparkConf().setAppName("Stack Analysis"))

def request_stack(page):
	response = urllib2.urlopen("https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&key=kUWPjhe)IOOtX6rjLTodLg((&client_secret=57aMrxG78ubMk0pEkvSquA((&pagesize=100&page="+str(page))
	content=zlib.decompress(response.read(),16+zlib.MAX_WBITS)
	dictpost=json.loads(content.decode('utf-8'))
	return dictpost

counter=0
l=list()
dictpost=request_stack(1)
while(dictpost['has_more']==True and counter<100):
	if (counter==100):
		dictpost=request_stack(2)
	elif (counter==200):
		dictpost=request_stack(3)
	elif (counter==300):
		dictpost=request_stack(4)
	elif (counter==400):
		dictpost=request_stack(5)
	elif (counter==500):
		dictpost=request_stack(6)
	elif (counter==600):
		dictpost=request_stack(7)
	elif (counter==700):
		dictpost=request_stack(8)
	elif (counter==800):
		dictpost=request_stack(9)
	elif (counter==900):
		dictpost=request_stack(10)
	for d in dictpost['items']:
		if (counter<1000):
			counter+=1
			l.append(d)
		else:
			break

mainRdd = sc.parallelize(l)
#Print the count of topics
mainRdd = mainRdd.flatMap(lambda d:d['tags'])
mainRdd = mainRdd.map(lambda tag:(tag,1))
mainRdd = mainRdd.reduceByKey(lambda acc,b:acc+b)
for tag,count in mainRdd.collect():
	toPrint=tag+":"+str(count)
	print(toPrint)

