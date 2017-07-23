import urllib.request as urllib2
import json
import zlib
import sys
from pyspark import SparkConf,SparkContext

sc = SparkContext(conf=SparkConf().setAppName("Stack Analysis"))
args=sys.argv

def request_stack(page):
	response = urllib2.urlopen("https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow&key=kUWPjhe)IOOtX6rjLTodLg((&client_secret=57aMrxG78ubMk0pEkvSquA((&pagesize=50&page="+str(page)+"&tagged="+str(args[1]))
	content=zlib.decompress(response.read(),16+zlib.MAX_WBITS)
	dictpost=json.loads(content.decode('utf-8'))
	return dictpost

counter=0
l=list()
dictpost=request_stack(1)
while(dictpost['has_more']==True and counter<50):
	for d in dictpost['items']:
		if (counter<50):
			counter+=1
			l.append(d)
		else:
			break

mainRdd = sc.parallelize(l)
#Print the count of topics
mainRdd = mainRdd.map(lambda d:(d['owner']['display_name'],(d['title'],d['is_answered'],d['link'])))
for name,(title,is_ans,link) in mainRdd.collect():
	toPrint=name+":~:"+title+":~:"+str(is_ans)+":~:"+link;
	print(toPrint)

