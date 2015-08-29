---
layout: post
title: creating a maven project out of a lost package
---

This was a little bit of a salvage operation. What I wanted to do was
to at least provide a small example of how to "fix" a broken package,
in this particular instance, it was the
`code-structure-ixl-1.3.2-TEMP.jar` package.

Get the jar and expand it somewhere. I downloaded it from artifactory,
then just used `jar` to unpack it.

```
mkdir code-structure-ixl
cd code-structure-ixl
curl -O http://ares:8081/artifactory/jlib-release/ixl/code-structure-ixl/1.3.2-TEMP/code-structure-ixl-1.3.2-TEMP.jar
jar xvf code-structure-ixl-1.3.2-TEMP.jar
mkdir -p codestructure/src/main/java
mv ixl codestructure/src/main/java/
cd codestructure
```

Now we need to clean it up a little bit, remove all the `*.class`
files.

```
find . -name '*.class' -exec rm {} \;
```

And now we need a `pom.xml`. There are a few ways to do this, but I
like to use the `archetype:generate` command to make one quickly just
to use a template. There is an example of it being used [in another
article][1].

Also following the steps from that article by enabling `sources` and
`javadoc`, we get a template `pom.xml` like the following:

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.mycompany.app</groupId>
  <artifactId>my-app</artifactId>
  <packaging>jar</packaging>
  <version>1.0-SNAPSHOT</version>
  <name>my-app</name>
  <url>http://maven.apache.org</url>
  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>3.8.1</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-source-plugin</artifactId>
        <executions>
          <execution>
            <id>attach-sources</id>
            <goals>
              <goal>jar</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-javadoc-plugin</artifactId>
        <executions>
          <execution>
            <id>attach-javadocs</id>
            <goals>
              <goal>jar</goal>
            </goals>
          </execution>
        </executions>
      </plugin>
    </plugins>
  </build>
</project>
```

So now I need to fill out the correct information, and add
dependencies. Finding dependencies can be a bit of a chore, but there
were a few `import`s and so just searching the correct packages did
not take too long.

I ended up adding this to my `pom.xml`:

```diff
--- pom.xml 2015-03-12 11:12:07.955845667 -0700
+++ pom.xml 2015-03-12
12:43:08.885815234 -0700
@@ -1,23 +1,54 @@
 <project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
   <modelVersion>4.0.0</modelVersion>
-  <groupId>com.mycompany.app</groupId>
-  <artifactId>my-app</artifactId>
+  <groupId>com.ixl</groupId>
+  <artifactId>codestructure</artifactId>
   <packaging>jar</packaging>
-  <version>1.0-SNAPSHOT</version>
-  <name>my-app</name>
+  <version>1.3.2-rbruns</version>
+  <name>codestructure</name>
   <url>http://maven.apache.org</url>
   <dependencies>
     <dependency>
-      <groupId>junit</groupId>
-      <artifactId>junit</artifactId>
-      <version>3.8.1</version>
-      <scope>test</scope>
+      <groupId>javax.xml</groupId>
+      <artifactId>jaxp-api</artifactId>
+      <version>1.4</version>
+    </dependency>
+    <dependency>
+      <groupId>javax.xml.bind</groupId>
+      <artifactId>jaxb-api</artifactId>
+      <version>2.2.12</version>
+    </dependency>
+    <dependency>
+      <groupId>commons-io</groupId>
+      <artifactId>commons-io</artifactId>
+      <version>2.4</version>
+    </dependency>
+    <dependency>
+      <groupId>org.apache.commons</groupId>
+      <artifactId>commons-lang3</artifactId>
+      <version>3.3.2</version>
+    </dependency>
+    <dependency>
+      <groupId>com.google.guava</groupId>
+      <artifactId>guava</artifactId>
+      <version>17.0</version>
+    </dependency>
+    <dependency>
+      <groupId>org.json</groupId>
+      <artifactId>json</artifactId>
+      <version>1.0</version>
     </dependency>
   </dependencies>
   <build>
     <plugins>
       <plugin>
+        <artifactId>maven-compiler-plugin</artifactId>
+        <configuration>
+          <source>1.7</source>
+          <target>1.7</target>
+        </configuration>
+      </plugin>
+      <plugin>
         <groupId>org.apache.maven.plugins</groupId>
         <artifactId>maven-source-plugin</artifactId>
         <executions>
```

One thing that was special was setting the `source` and `target` to
`1.7` since there was a particular error that required this.

Building also required a change to the code as it was giving an
ambiguous function error:

```diff
--- a/src/main/java/ixl/codeStructure/metadata/MetadataUtils.java
+++ b/src/main/java/ixl/codeStructure/metadata/MetadataUtils.java
@@ -61,7 +61,7 @@ public final class MetadataUtils {
    * is recommended.
    */
   public static List<String> getModuleList(File modsList) throws IOException {
-    return FileUtils.readLines(modsList, null);
+    return FileUtils.readLines(modsList, (String)null);
   }
   
   /**
```

Now `mvn package` works! I installed it locally with `mvn install`.

When you look inside the `target/` directory, you'll see all three
jars correctly created.

Testing it out, I changed the main project `pom.xml` in the IXL code
base.

```diff
--- a/pom.xml
+++ b/pom.xml
@@ -1540,9 +1540,9 @@
       <scope>runtime</scope>
     </dependency>
     <dependency>
-      <groupId>ixl</groupId>
-      <artifactId>code-structure-ixl</artifactId>
-      <version>1.3.2-TEMP</version>
+      <groupId>com.ixl</groupId>
+      <artifactId>codestructure</artifactId>
+      <version>1.3.2-rbruns</version>
     </dependency>
     <dependency>
       <groupId>ixl</groupId>
```

Now intellij correctly takes you to the source file when you try to go
back to it.

All that remains left to do is to publish these jars to artifactory
for public consumption.

  [1]: /posts/2015-03-12-maven-publishing-sources-and-javadocs.html
