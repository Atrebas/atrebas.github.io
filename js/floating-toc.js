function myFunction(x) {
  if (document.getElementById('TOC')) {
  if (x.matches) { // If media query matches
    //document.body.style.backgroundColor = "yellow";
	document.getElementById('TOC').classList.remove('floating');
  } else {
	//document.body.style.backgroundColor = "pink";
	document.getElementById('TOC').classList.add('floating');
  }
  }
}

$( document ).ready(function() {
var x = window.matchMedia("(max-width: 1200px)");
myFunction(x); // Call listener function at run time
x.addListener(myFunction) ;
});
