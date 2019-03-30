window.onload = function () {
    var linkList = document.querySelectorAll('.post a');
    for (var i in linkList) {
        linkList[i].target = '_blank';
    }
}
