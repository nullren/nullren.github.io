---
layout: post
title: "Category Theory for Programmers Chapter 4"
category:
tags: []
---

Solutions for the challenges in this chapter were basically done as a C++11 file.

```cpp
#include <iostream>
#include <cmath>
using namespace std;

template<class A>
class optional {
  bool _isValid;
  A _value;
public:
  optional(): _isValid(false) {}
  optional(A v): _isValid(true), _value(v) {}
  bool isValid() const { return _isValid; }
  A value() const { return _value; }
};

optional<double> safe_root(double x) {
  if (x >= 0) return optional<double>(sqrt(x));
  else return optional<double>();
}

// Exercise 1
//
template<class A, class B, class C>
function<optional<C>(A)> compose(
    function<optional<B>(A)> f1,
    function<optional<C>(B)> f2)
{
  return [f1, f2](A x) {
    auto r = f1(x);
    if (r.isValid()) return f2(r.value());
    else return r;
  };
}
template<class A> optional<A> identity(A x) {
  return optional<A>(x);
}

// Exercise 2
//
optional<double> safe_reciprocal(double x) {
  if (x == 0) return optional<double>();
  else return optional<double>(1/x);
}

// Exercise 3
//
optional<double> safe_root_reciprocal(double x) {
  return compose<double,double,double>(safe_root, safe_reciprocal)(x);
}

void test(function<optional<double>(double)> f, double x) {
  cout << "Testing value (" << x << "): ";
  auto r = f(x);
  if (r.isValid()) cout << "Valid (" << r.value() << ")\n";
  else cout << "Not valid\n";
}

int main() 
{
  test(safe_root_reciprocal, -2);
  test(safe_root_reciprocal, 2);
  return 0;
}
```
