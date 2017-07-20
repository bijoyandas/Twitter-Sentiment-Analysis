<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="style.css" />
<script src="Chart.js"></script>
<script type="text/javascript">
var request;  
function sendInfo()  
{  
var progress="<div class='progress'><div class='indeterminate'></div></div>";
document.getElementById('contentContainer').innerHTML=progress;
document.getElementById('navLinks').innerHTML="";
var v=document.search.hashtag.value;  
var url="StoreTweets?hashtag="+v;  
  
if(window.XMLHttpRequest){  
request=new XMLHttpRequest();  
}  
else if(window.ActiveXObject){  
request=new ActiveXObject("Microsoft.XMLHTTP");  
}  
  
try  
{  
request.onreadystatechange=getInfo;  
request.open("GET",url,true);  
request.send();  
}  
catch(e)  
{  
alert("Unable to connect to server");  
}  
}  
  
function getInfo(){  
if(request.readyState==4){  
	var val=request.responseText; 
	var rows = val.split("<br>");
	var countPos=0;
	var countNeg=0;
	var countNeu=0;
	var i,value;
	var arr = [];
	for(i=0;i<rows.length-1;i++){
		value=parseFloat(rows[i]);
		if (value==0.0)
			countNeu++;
		else if (value > 0.0)
			countPos++;
		else
			countNeg++;
		arr.push(value);
	}
	var navs = "<ul><li class='itemLinks' data-pos='0px'></li><li class='itemLinks' data-pos='-800px'></li></ul>";
	var canv1="<canvas id='emotionChart' width='800' height='600'></canvas>";
	var canv2="<canvas id='emotionByTweet' width='800' height='800'></canvas>";
	var division="<div id='wrapper'><div id='chartEmotion' class='content'></div><div id='chartTweet' class='content'></div></div>";
	document.getElementById('contentContainer').innerHTML=division;
	document.getElementById('chartEmotion').innerHTML=canv1;
	document.getElementById('chartTweet').innerHTML=canv2;
	document.getElementById('navLinks').innerHTML=navs;
	emotionPrint(countPos,countNeu,countNeg);
	emotionByTweet(arr);
	addNavLinks();
	document.getElementById('chartPane').scrollIntoView();
}
}

function addNavLinks(){
	var links = document.querySelectorAll(".itemLinks");
	var wrapper = document.querySelector("#wrapper");
	// the activeLink provides a pointer to the currently displayed item
	var activeLink = 0;
	 
	// setup the event listeners
	for (var i = 0; i < links.length; i++) {
	    var link = links[i];
	    link.addEventListener('click', setClickedItem, false);
	 
	    // identify the item for the activeLink
	    link.itemID = i;
	}
	 
	// set first item as active
	links[activeLink].classList.add("active");
	 	 
	// Handle changing the slider position as well as ensure
	// the correct link is highlighted as being active
	function removeActiveLinks() {
    for (var i = 0; i < links.length; i++) {
        links[i].classList.remove("active");
    }
	}

function changePosition(link) {
    var position = link.getAttribute("data-pos");
 
    var translateValue = "translate3d(" + position + ", 0px, 0)";
    wrapper.style.transform = translateValue;
 
    link.classList.add("active");
}

function setClickedItem(e) {
    removeActiveLinks();
 
    var clickedLink = e.target;
    activeLink = clickedLink.itemID;
 
    changePosition(clickedLink);
}
}

function emotionPrint(cPos,cNeu,cNeg){
	var ctx = document.getElementById("emotionChart");
	var myChart = new Chart(ctx, {
	    type: 'horizontalBar',
	    data: {
	        labels: ["Positive", "Neutral", "Negative"],
	        datasets: [{
	            label: 'Sentiments Graph',
	            data: [cPos,cNeu,cNeg],
	            backgroundColor: [
	                'rgba(255, 99, 132, 0.2)',
	                'rgba(54, 162, 235, 0.2)',
	                'rgba(255, 206, 86, 0.2)'
	            ],
	            borderColor: [
	                'rgba(255,99,132,1)',
	                'rgba(54, 162, 235, 1)',
	                'rgba(255, 206, 86, 1)'
	            ],
	            borderWidth: 1
	        }]
	    },
	    options: {
	    	responsive:false,
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero:true
	                }
	            }]
	        }
	    }
	});

}  

function emotionByTweet(arr){
	var ctx = document.getElementById("emotionByTweet");
	var i;
	var k = []
	for(i=0;i<arr.length-1;i++){
		k.push((i+1)+"");
	}
	var myChart = new Chart(ctx, {
	    type: 'horizontalBar',
	    data: {
	        labels: k,
	        datasets: [{
	            label: 'Sentiment By Tweet',
	            data: arr,
	            backgroundColor: 'rgba(255, 99, 132, 0.2)',
	            borderColor: 'rgba(255,99,132,1)',
	            borderWidth: 1
	        }]
	    },
	    options: {
	    	responsive:false,
	        scales: {
	            yAxes: [{
	                ticks: {
	                    beginAtZero:true
	                }
	            }]
	        }
	    }
	});

}  

</script>
</head>
<body>
	<button onclick="topFunction()" id="myBtn" title="Go to top">^</button>
	<div style="padding-top:100px;text-align:center">
		<img src="img.png" height="150px" width="150px"><br>
			<div align="center"><a href="Twitter.jsp"><span id="head">sentiment </span><span id="head1">analysis</span></a></div>
	</div>
	<div id="placement">
		<form name="search" action="StoreTweets" method="get">
			<input  id="cricketerName" type="text" name="hashtag" placeholder="#example" style="color:black;padding-top:8px;padding-bottom:8px;font-size:20px;"> 
			<input id="buttonStyle" type="button" value="Analyse" onclick="sendInfo()" style="padding-top:7px;padding-bottom:7px;">
		</form>
	</div>
	<br><br>
	<div id="chartPane">
	<div id="navLinks"></div>
	<div id="contentContainer" align="center">
		
	</div>
	</div>
	<script type="text/javascript">
	window.onscroll = function() {scrollFunction()};

	function scrollFunction() {
	    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
	        document.getElementById("myBtn").style.display = "block";
	    } else {
	        document.getElementById("myBtn").style.display = "none";
	    }
	}

	// When the user clicks on the button, scroll to the top of the document
	function topFunction() {
	    document.body.scrollTop = 0;
	    document.documentElement.scrollTop = 0;
	}
	</script>
</body>
</html>