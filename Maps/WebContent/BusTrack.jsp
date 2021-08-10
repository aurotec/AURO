
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>bus locations</title>
<script  
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBNON2VqBvbORzpz9CPXgEPIFAhmMe7c4Q">
 </script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>

</head>
<body onload="loadMap()" >
<div id = "map" style = "width:100%; height:1000px;"></div>
<script>
 setInterval("callJqueryAjax()",6000); 
function callJqueryAjax(){
	var xmlhttp = new XMLHttpRequest();
    var url = "getbuses.jsp";
    xmlhttp.onreadystatechange = function(){
        if(xmlhttp.readyState == 4 && xmlhttp.status == 200){    
         load(xmlhttp.responseText);
        }
    };
    try{
    xmlhttp.open("post",url,true);
    xmlhttp.send();
}catch(e){
	alert("unable to connect to server");
}
}
  var mapOptions={}; 
 var map; 
 var busMarkers;  
 var markersArray = [];
/*  var marker = "" */
function loadMap() {
	

		    mapOptions = {
		    center:new google.maps.LatLng(12.953882, 77.585717),
		    zoom: 7,
		    zoomControl: false,
		    scaleControl: true,
		    mapTypeId:google.maps.MapTypeId.ROADMAP
		  }
		   map= new google.maps.Map(document.getElementById("map"), mapOptions);   
		    
		  
			  callJqueryAjax();
			  
		}

function load(buslocations){
	console.log("called");
	  busMarkers = JSON.parse(buslocations);
	       	
	   clearOverlays(); 
	  function clearOverlays() {
		  for (var i = 0; i < markersArray.length; i++ ) {
		        markersArray[i].setMap(null);
		      }
		      markersArray = [];
		      console.log("markers removed");
		    } 
	  for(bus of busMarkers) {
		
	
		  var angleDegrees = bus.location[3]; 
		 

		 
		   marker = new google.maps.Marker({
	    	
	     
	    	 map: map,
	      position: new google.maps.LatLng(bus.location[0], bus.location[1]),  
	     
	        title: bus.location[2]+"",  
	      icon: {
	          path: google.maps.SymbolPath.FORWARD_CLOSED_ARROW,
	          scale: 4,
	          fillColor: "blue",
	          fillOpacity: 0.8,
	          strokeWeight: 2,
	          rotation:angleDegrees,
	        
	      }   
	   

	    });
		   markersArray.push(marker);
	
	    console.log("markers added");
	  }
	   
	 
	 
		
	 
		
	  
	  
}
</script>
 
 
</body>

</html>