<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="style.css" />
<style>
#toTop:hover {
  background-color: #555;
}
a {
	text-decoration:none;
	color:black;
}
a:hover {
	color:#FF5733;
	-webkit-transition: 0.2s ease-in-out;
}
#toTop {
  display: none;
  position: fixed;
  bottom: 20px;
  right: 30px;
  z-index: 99;
  border: none;
  outline: none;
  background-color: #FF5733;
  color: white;
  cursor: pointer;
  padding-right: 15px;
  padding-left: 15px;
  padding-top:10px;
  padding-bottom:10px;
  font-size:20px;
  border-radius: 30px;
}
#stackhead{
	font-family:Verdana;
	font-size:80px;
	text-align:center;
	color:#000000;
	padding-top:200px;
}
#stackhead1 {
	font-family:Verdana;
	font-size:80px;
	text-align:center;
	color:#FF5733;
	padding-top:200px;
}
a:hover #stackhead{
	color:#FF5733;
	-webkit-transition: 0.4s ease-in-out;
}
a:hover #stackhead1{
	color:black;
	-webkit-transition: 0.4s ease-in-out;
}
.progress {
  position: relative;
  height: 4px;
  display: block;
  width: 100%;
  background-color: #FF5733;
  border-radius: 2px;
  background-clip: padding-box;
  margin: 0.5rem 0 1rem 0;
  overflow: hidden; }
  .progress .determinate {
    position: absolute;
    background-color: inherit;
    top: 0;
    bottom: 0;
    background-color: #FF5733;
    transition: width .3s linear; }
  .progress .indeterminate {
    background-color: orange; }
    .progress .indeterminate:before {
      content: '';
      position: absolute;
      background-color: inherit;
      top: 0;
      left: 0;
      bottom: 0;
      will-change: left, right;
      -webkit-animation: indeterminate 2.1s cubic-bezier(0.65, 0.815, 0.735, 0.395) infinite;
              animation: indeterminate 2.1s cubic-bezier(0.65, 0.815, 0.735, 0.395) infinite; }
    .progress .indeterminate:after {
      content: '';
      position: absolute;
      background-color: inherit;
      top: 0;
      left: 0;
      bottom: 0;
      will-change: left, right;
      -webkit-animation: indeterminate-short 2.1s cubic-bezier(0.165, 0.84, 0.44, 1) infinite;
              animation: indeterminate-short 2.1s cubic-bezier(0.165, 0.84, 0.44, 1) infinite;
      -webkit-animation-delay: 1.15s;
              animation-delay: 1.15s; }

@-webkit-keyframes indeterminate {
  0% {
    left: -35%;
    right: 100%; }
  60% {
    left: 100%;
    right: -90%; }
  100% {
    left: 100%;
    right: -90%; } }
@keyframes indeterminate {
  0% {
    left: -35%;
    right: 100%; }
  60% {
    left: 100%;
    right: -90%; }
  100% {
    left: 100%;
    right: -90%; } }
@-webkit-keyframes indeterminate-short {
  0% {
    left: -200%;
    right: 100%; }
  60% {
    left: 107%;
    right: -8%; }
  100% {
    left: 107%;
    right: -8%; } }
@keyframes indeterminate-short {
  0% {
    left: -200%;
    right: 100%; }
  60% {
    left: 107%;
    right: -8%; }
  100% {
    left: 107%;
    right: -8%; } }
</style>
<script type="text/javascript">
var request;  
function sendInfo()  
{  
var progress="<div class='progress'><div class='indeterminate'></div></div>";
document.getElementById('contentContainer').innerHTML=progress;
var url="StackAnalysis";  
  
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

function sendTag(val)  
{  
var progress="<div class='progress'><div class='indeterminate'></div></div>";
document.getElementById('contentContainer').innerHTML=progress;
var url="StackAnalysis?query="+val;  

if(window.XMLHttpRequest){  
request=new XMLHttpRequest();  
}  
else if(window.ActiveXObject){  
request=new ActiveXObject("Microsoft.XMLHTTP");  
}  
  
try  
{  
request.onreadystatechange=getQuestion;  
request.open("GET",url,true);  
request.send();  
}
catch(e)  
{  
alert("Unable to connect to server");  
}  
} 

function getQuestion(){
	if(request.readyState==4){
		var val=request.responseText;
		var rows = val.split("<br>");
		var table="<table width='100%' style='border:2px solid #FF5733;border-collapse:collapse'>";
		var i;
		table+="<tr style='background-color:#FF5733;color:white;font-size:20px;padding:10px'><td style='border:1px solid #FF5733;padding:5px'>Username</td><td style='border:1px solid #FF5733;padding:5px'>Question</td><td style='border:1px solid #FF5733;padding:5px'>Answered</td><td style='border:1px solid #FF5733;padding:5px'>View</td></tr>";
		for(i=0;i<rows.length-1;i++){
			if (i%2!=0)
				table+="<tr style='background-color:#DAD5D4'>";
			else
				table+="<tr>";	
			var cols=rows[i].split(":~:");
			table+="<td style='border:1px solid #FF5733;padding:10px'>"+cols[0]+"</td><td style='border:1px solid #FF5733;padding:10px'>"+cols[1]+"</td><td style='border:1px solid #FF5733;padding:10px'>"+cols[2]+"</td><td style='border:1px solid #FF5733;padding:10px'><a href='"+cols[3]+"' target='_blank'>Here</a></td>";
			table+="</tr>";
		}
		
		table+="</table>";
		document.getElementById('contentContainer').innerHTML = table;
	}
}

function getInfo(){
if(request.readyState==4){
	var table="<div width='100%' height='100px' style='text-align:center;font-size:24px;color:#FF5733;padding-top:10px;padding-bottom:10px;border-radius:30px;border:2px solid #FF5733'>Tag Cloud</div><br><table width='100%'>";
	var val=request.responseText; 
	var rows = val.split("<br>");
	var i,j;
	count=rows.length;
	for(i=0;i<count-1;i++){
		if (i%6==0){
			table+="<tr>";
		}
		//count++;
		var cols=rows[i].split(":");
		table+="<td><button id='tagBtn"+i.toString()+"'"+" style='width:130px;height:60px;background-color:#FF5733;color:white;border:2px solid #FF5733;font-size:16px;border-radius:30px;'>"+cols[0]+"("+cols[1]+")</button></td>";
		if ((i+1)%6==0 || (i+1)%6==count-1)
			table+="</tr>";
		}
	table+="</table>";
	document.getElementById('contentContainer').innerHTML=table;
	document.getElementById('chartPane').scrollIntoView();
	for(i=0;i<count-1;i++){
		document.getElementById('tagBtn'+i.toString()).addEventListener('click',function(){
			sendTag(this.innerHTML.split('(')[0]);
		});	
	}
}
	
}

</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>StackOverflow Question Analysis</title>
</head>
<body>
	<a href="index.html"><img src="home-icon.png" height="50px" width="50px" style="float:left|top;padding-left:20px;padding-top:20px"></a>
	<button onclick="topFunction()" id="toTop">^</button>
	<div style="padding-top:80px;text-align:center">
		<img src="so-logo.png" height="150px" width="600px"><br>
			<div align="center"><a href="StackOverflow.jsp"><span id="stackhead">question </span><span id="stackhead1">analysis</span></a></div>
	</div>
	<div id="placement">
		<form name="search" action="StackAnalysis" method="get"> 
			<input id="buttonStyle" type="button" value="Get Tag Cloud" onclick="sendInfo()" style="padding-top:7px;padding-bottom:7px;background-color:#FF5733;border-radius:30px;font-size:22px;padding-left:25px;padding-right:25px;padding-top:15px;padding-bottom:15px">
		</form>
	</div>
	<br><br>
	<div id="chartPane">
	<div id="contentContainer" style="width:830px" align="center">
		
	</div>
	</div>
	<script type="text/javascript">
	window.onscroll = function() {scrollFunction()};

	function scrollFunction() {
	    if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
	        document.getElementById("toTop").style.display = "block";
	    } else {
	        document.getElementById("toTop").style.display = "none";
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