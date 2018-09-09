---
layout: post
title: "Setting Up Processing with Intellij"
category:
tags: []
---

Processing is really cool. It's a super simple library that helps visual designers write code to create amazing art. I, however, am not a visual designer and am a programmer. So when I started up the Processing app, I was kind of bummed to see that it was just Java but in an inferior IDE. I wanted to use it in Intellij IDEA.

First step, was creating a new project in Intellij. This is a simple step, but the thing that tripped me up here was that Processing requires JDK 1.8. At the point of writing this, I had JDK 10 by default, so I had to install it and add it to Intellij. After that, I was able to set the Project SDK to 1.8. I also selected Maven.

Once everything came up, I added a new dependency (cmd-N, Generate Dependency Template) and added `org.processing:core:3.3.7`.

My `pom.xml` looked like this after adding the `org.processing:core:3.3.7` dependency.

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>io.github.nullren</groupId>
    <artifactId>art</artifactId>
    <version>1.0-SNAPSHOT</version>
    <dependencies>
        <dependency>
            <groupId>org.processing</groupId>
            <artifactId>core</artifactId>
            <version>3.3.7</version>
        </dependency></dependencies>


</project>
```

Next step was creating a really quick way to run sketches. Created a new class in `src/main/java` called `io.github.nullren.art.Hello`. I extended the class with `PApplet` and added a `settings` and `main` methods. The class then looked like this.

```
package io.github.nullren.art;

import processing.core.PApplet;
import processing.core.PFont;

public class Hello extends PApplet {
  public void settings() {
    printArray(PFont.list());
  }
  
  public static void main(String[] args) {
    PApplet.runSketch(new String[]{"Hello"}, new Hello());
  }
}
```

Right-click in that file to `Create 'Hello.main()'...`, click `OK`, then ran the file. I was able to see my fonts and a little Processing window came up. Now I can do all the processing stuff and it comes up in that little window.

