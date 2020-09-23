<noscript><meta HTTP-EQUIV="REFRESH" CONTENT="{v.refreshtimer};URL=/"></noscript>
<script language="javascript" type="text/javascript">
var isRefresh = true;
function countdown() \{
	if (timeleft >= 0) \{
		timeleft--;
		document.getElementById("timer").innerHTML = "("+timeleft+")";
		t=setTimeout("countdown()", 1000);
	}
	if (timeleft == 0) window.location="/";
}

function setrefresh() \{
	if(isRefresh)\{
		clearTimeout(t);
		isRefresh = false;
	}else\{
		t=setTimeout("countdown()", 1000);
		isRefresh = true;
	}
}

function onPageLoad() \{
	timeleft = {v.refreshtimer+1};
	countdown();
}
</script>
<body onload="onPageLoad()">
<noscript>
 <center><span class="nojs">JavaScript must be enabled to view this site properly.</span></center><br>
</noscript>