---
layout: post
title: "Category Theory for Programmers Chapter 6: Simple Algebraic Data Types"
category:
tags:
- Category Theory
- Category Theory for Programmers
---

1. Show the isomorphism between `Maybe a` and `Either () a`.

   ```haskell
   maybeToEither :: Maybe a -> Either () a
   maybeToEither None = Left ()
   maybeToEither Just x = Right x

   eitherToMaybe :: Either () a -> Maybe a
   eitherToMaybe Left _ = None
   eitherToMaybe Right x = Just x
   ```

2. Implement `Shape` in C++ or Java as an interface and create two
   classes: `Circle` and `Rect`. Implement `area` as a virtual
   function.

   ```java
   public class HelloWorld {
     interface Shape {
       double area();
     }
     static class Circle implements Shape {
       final double radius;
       Circle(double radius) {
         this.radius = radius;
       }
       @Override
       public double area() {
         return Math.PI * radius * radius;
       }
     }
     static class Rect implements Shape {
       final double height;
       final double width;
       Rect(double height, double width) {
         this.height = height;
         this.width = width;
       }
       @Override
       public double area() {
         return height * width;
       }
     }
     public static void printShape(Shape shape) {
       System.out.println(shape.area());
     }
     public static void main(String[] args) {
       printShape(new Circle(5.0));
       printShape(new Rect(5.0, 5.0));
     }
   }
   ```

3. Add `circ` to your C++ or Java implementation. What parts of the
   original code did you have to touch?

   Add `double circ();` to the interface, then implement it in both
   the subclasses.

4. Adding `Square` in Java is just creating a new subclass.

5. `a + a` is represented by `Either a a` and `2 * a` can be
   represented by `(Bool, a)`. This works because you can assign
   either `Left` or `Right` one of the two values of `Bool` so then
   you create the mappings `Left a => (true, a)` and `Right a =>
   (false, a)`.
