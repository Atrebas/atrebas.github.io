var imgIndex = 0;

function showDivs(n, i) {
  var x = document.getElementsByClassName("imgshow");
  x[n].style.display = "none";
  n = n + i;
  if (n > x.length - 1) {n = 0};
  if (n < 0) {n = x.length - 1};
  x[n].style.display = "block";
  imgIndex = n;
  var counter = document.getElementById("counter");
  counter.innerHTML = ("0" + (imgIndex + 1)).slice(-2) + "/" + x.length;
}

$(document).ready(function(){
    showDivs(imgIndex, 0);
	$('#next').on('click', function(event) {        
         showDivs(imgIndex, 1);
	});
	$('#prev').on('click', function(event) {        
         showDivs(imgIndex, -1);
	});
});
