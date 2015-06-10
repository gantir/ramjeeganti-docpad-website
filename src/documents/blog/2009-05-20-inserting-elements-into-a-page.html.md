---
layout: post
title: Inserting elements into a page
description: Inserting elements into a page
date: 2009-05-20 01:06
tags:
	- javascript
	- programming
	- recycled-rganti
	- recycled-post
author: "Ramjee Ganti"
comments: true
sharing: true
footer: true
---
The following code snippet is to help insert a code snippet into a page without using document.write.
``` 
javascript Insert element without document.write
function insert() {
	var insertElement = getNewElement('div','ElementID', 'ElementName');
	var targetElement = document.getElementById('targetId');
	insertAfter(insertElement , targetElement);
}

/* insert a new element after the targetelement*/
function insertAfter(newElement, targetElement) {
	var parent = targetElement.parentNode;
	if (parent.lastChild == targetElement) {
		parent.appendChild(newElement);
	}
	else {
		parent.insertBefore(newElement, targetElement.nextSibling);
	}
}

/* Get new element of 1/1 pixel size*/
function getNewElement(elementTag,elementID,elementName) {
	var newElement = document.createElement(elementTag);
	newElement.id = elementID;
	newElement.name = elementName;
	newElement.width = '1';
	newElement.height = '1';
	newElement.frameborder = '1';
	newElement.marginwidth = '1';
	newElement.marginheight = '1';
	newElement.vspace = '1';
	newElement.hspace = '1';
	newElement.alltransparency = 'true';

	return newElement;
}
```
As a side we can also get the insert scripts by figuring out the script source:

``` 
javascript Get the last script tag in javascript
function getLastScriptElement(url) {
	var scripts = document.getElementsByTagName('script');
	var matchUrl = 'js/sample.js'.toLowerCase();
	for (var i = 0; i < scripts.length; i++) {
		var srcUrl = scripts[i].src.toLowerCase();
		var match = srcUrl.match(matchUrl);
		//if (scripts[i].src.toLowerCase() == url.toLowerCase() + 'js/sample.js'.toLowerCase())
		if (null != match) {
			break;
		}
	}
	if (undefined == scripts[i + 1]) {
		return scripts[i];
	} else {
		return scripts[i +1];
	}
}
```
This post was recyled from [Art of Software, Craft of Hardware](http://rganti.blogspot.in/2009/05/inserting-elements-into-page.html).
