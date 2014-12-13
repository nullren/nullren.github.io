---
layout: post
title: created aep score image thingy
tags:
- aep
- fixed it
- last.fm
- music
- something i made
- web
- win
status: publish
type: post
published: true
meta:
  _edit_last: '1'
---
i was looking at [my profile](http://last.fm/user/urble) today on
[last.fm](http://last.fm) and noticed that the image i had from
[davethemoonman](http://last.fm/user/davethemoonman) was no longer
working. i found out in the [last.fm
forums](http://www.last.fm/group/We+Don%27t+Have+Exponential+Profiles/forum/32066/_/1010482/1#f16050270)
that he had dns trouble or something. knowing the aep was pretty simple,
i decided to make my own because i thought it was neat.

all the info i needed to replicate it was [documented
here](http://www.last.fm/group/We%2BDon%2527t%2BHave%2BExponential%2BProfiles/journal/2006/05/4/129052)
by [C26000](http://last.fm/user/C26000).

------------------------------

###### aep image link generator

<script type="text/javascript">
function make_link(){
  var username = document.getElementById("username");
  var imgurl = "http://aep.omgren.com/" + escape(username.value) + ".png";
  document.getElementById("textbox").value = "[url=http://aep.omgren.com/][img]"+imgurl+"[/img][/url]";
  document.getElementById("aep").src = imgurl;
  document.getElementById("derp").style.display = "block";
}
</script>
<form action="#">
<p>last.fm username: <input type="text" id="username" /><input type="submit" value="make bbcode" onclick="make_link(); return false" /></p>
<p><textarea id="textbox" rows="3" cols="50">bbcode will appear here</textarea></p>
<p id="derp" style="display:none">aep image: <img id="aep" /></p>
</form>

------------------------------

the source for my thing can be found on [my
bitbucket](https://bitbucket.org/nullren/aep). sharing is caring.
