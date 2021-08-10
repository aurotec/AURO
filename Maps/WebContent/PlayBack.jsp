<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script
    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBNON2VqBvbORzpz9CPXgEPIFAhmMe7c4Q">
 </script> 
 <script
  src="https://code.jquery.com/jquery-3.6.0.js"
  integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
  crossorigin="anonymous"></script>
  <script
  src="https://code.jquery.com/jquery-2.2.4.js"
  integrity="sha256-iT6Q9iMJYuQiMWNd9lDyBUStIq/8PuOW33aOqmvFpqI="
  crossorigin="anonymous"></script>
 <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
<title>Replay</title>
<style type="text/css">

 #map {
        height: 100%;
      }
      /* Optional: Makes the sample page fill the window. */
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      #floating-panel {
        position: absolute;
        top: 10px;
        left: 15%;
        z-index: 5;
        background-color: #fff;
        padding: 5px;
        border: 1px solid #999;
        text-align: center;
        font-family: 'Roboto','sans-serif';
        line-height: 30px;
        padding-left: 10px;
      }
      .button1
       {
       background-color: #555555;
        color: white;
       } /* Black */
       
</style>


</head>
<!-- onload = "loadMap()" -->
<body onload="loadMap()">
<div id = "map" style = "width:100%; height:1000px;"></div>
<div id="floating-panel">
 <b>Device id:</b>
   <label for="meeting"></label><input id="deviceid"  type="text"/>
    <b>From date:</b>
   <label for="meeting"></label><input id="fromdate" type="date" />
   
       <b>TO date: </b>
    <label for="meeting"></label><input id="todate" type="date" />
    <b>From Time: </b>
    <label for="appt"></label>
  <input type="time" id="fromtime" name="appt"step="2">
        <b>To Time: </b>
     <label for="appt"></label>
  <input type="time" id="totime" name="appt"step="2">
  <button class="button1"onclick="My_Date()">Submit</button>
  <button class="button1"onclick="location.reload();">clear</button>
 <span id="error"style="color:green;"></span> 

      </div>
        
<script>


function loadMap() {
	
      mapOptions = {
    center:new google.maps.LatLng(12.953882, 77.585717),
    zoom: 16,
    zoomControl: false,
    scaleControl: true,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }  
   map= new google.maps.Map(document.getElementById("map"),mapOptions );     
}


function My_Date() {
	var count=0;
	 var sdsd=[];
	
	var deviceid=document.getElementById("deviceid").value
   var fromdate= document.getElementById("fromdate").value;
   var todate= document.getElementById("todate").value;
   var fromtime= document.getElementById("fromtime").value;
   var totime= document.getElementById("totime").value;

   var xmlhttp=new XMLHttpRequest();
	xmlhttp.onreadystatechange= function()
	{
	if(xmlhttp.readyState==4 && xmlhttp.status==200)
		{
		console.log("the output length is "+xmlhttp.responseText.length);
		console.log("the output from the main in ajax is "+xmlhttp.responseText);

		loadMaps(xmlhttp.responseText,deviceid,fromdate,todate,fromtime,totime);
		}
		};
		try{
			xmlhttp.open("post","Historybuses.jsp?deviceid="+deviceid+"&fromdate="+fromdate+"&todate="+todate+"&fromtime="+fromtime+"&totime="+totime,true);
	        xmlhttp.send();
		}
		catch(e)
		{
			alert("Somthing went wrong");
		}
}




function loadMaps(x,did,fdate,tdate,ftime,ttime) {
	 var latitudes=[];
	 var longitudes=[];
	 var flightPlanCoordinates3=[];
	
	  
	 var flightPlanCoordinates2=[];
	var directionsDisplay;
	var directionsService = new google.maps.DirectionsService();
	var map;
	var count=0;
	var j=0;
	   var date1 = new Date(fdate);
       var date2 = new Date(tdate);
	var coordinatepoints=[];
	var startpoint=[];
       jsonarray=JSON.parse(x);
  	 console.log("json array is "+jsonarray.lat)
       var jsonarraylength = jsonarray.length;
   	if(jsonarraylength=0)
	{
	document.getElementById("error").innerHTML = "Undefined";

	} 
       var en={};
  
       for (var i = 0; i < jsonarray.length; i++) {
    	   const st=new google.maps.LatLng(jsonarray[i].lat, jsonarray[i].lon);//this constant is for the starting point
    	   latitudes[i]=jsonarray[i].lat;
    	   longitudes[i]=jsonarray[i].lon;
    	   
    	   flightPlanCoordinates3[i] = new google.maps.LatLng(latitudes[i], longitudes[i]);
    	   count++;
    	   if(i==0)
    		   {
    		   var busid=jsonarray[i].cid;

  	    	 var map_options = {
  	   			  center: new google.maps.LatLng(jsonarray[i].lat, jsonarray[i].lon),
  	   	          zoom: 18,
  	   	          mapTypeId: google.maps.MapTypeId.ROADMAP
  	   	        };

  	   			map = new google.maps.Map(document.getElementById('map'),
  	   		  map_options);
  	   			var icons = {
  	   					path:"M17.402,0H5.643C2.526,0,0,3.467,0,6.584v34.804c0,3.116,2.526,5.644,5.643,5.644h11.759c3.116,0,5.644-2.527,5.644-5.644 V6.584C23.044,3.467,20.518,0,17.402,0z M22.057,14.188v11.665l-2.729,0.351v-4.806L22.057,14.188z M20.625,10.773 c-1.016,3.9-2.219,8.51-2.219,8.51H4.638l-2.222-8.51C2.417,10.773,11.3,7.755,20.625,10.773z M3.748,21.713v4.492l-2.73-0.349 V14.502L3.748,21.713z M1.018,37.938V27.579l2.73,0.343v8.196L1.018,37.938z M2.575,40.882l2.218-3.336h13.771l2.219,3.336H2.575z M19.328,35.805v-7.872l2.729-0.355v10.048L19.328,35.805z",
  	   				    scaledSize: new google.maps.Size(25,30),
  	   		  fillColor: '#ff0000',
  	   		fillOpacity: 1.0,
  	   	    strokeColor:'#800000'
  	   		           
  	   				} 
  	   		     marker = new google.maps.Marker({
  	   	    	    position: st,
  	   	    	    map: map,
  	   	    	 icon:icons
  	   	    	  }); 
  		   }
 	 
    	   window.setTimeout(() => {
    		   var lineSymbol = {
   	    		    path: google.maps.SymbolPath.CIRCLE,
   	    		    fillOpacity: 1,
   	    		    strokeOpacity: 1,
   	    		    strokeWeight: 2,
   	    		    fillColor: 'white',
   	    		    strokeColor: 'orange',
   	    		    scale: 5
   	    		  };
   
   	   var polyOptions4 = {
   				  path: flightPlanCoordinates3,
   				    geodesic: true, 
   		  strokeColor: '#FF0000',
   		  strokeOpacity: 1.0,
   		  strokeWeight: 4
   	   };
 
   
   	   var flightPath = new google.maps.Polyline(polyOptions4);
     	  flightPath.setMap(map);
	  
		   marker.setPosition( new google.maps.LatLng(latitudes[i],longitudes[i]));
		   var angle= parseInt(jsonarray[i].dirs);

  	     var icon1 = marker.getIcon();
  	     icon1.rotation = angle;
  	     marker.setIcon(icon1);

   	   	   map.panTo( new google.maps.LatLng(jsonarray[i].lat,jsonarray[i].lon) );
    	   },i *1000);
  
 
	   directionsDisplay = new google.maps.DirectionsRenderer();
 	  directionsDisplay.setMap(map);
 	  var request = {
     origin: st,
     destination: en,

     travelMode: 'DRIVING'
 };
 	  
 	  directionsService.route(request, function (response, status) {
           if (status == google.maps.DirectionsStatus.OK) {
               directionsDisplay.setDirections(response);
               directionsDisplay.setMap(map);
           } else {
               alert("Directions Request from " + start.toUrlValue(6) + " to " + end.toUrlValue(6) + " failed: " + status);
           }
       });
;          }

 
}

    </script>
    

</body>
</html>