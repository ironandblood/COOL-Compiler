--method

class A {
  compute(a:Int, b:Int) : Int {a+b};
  foo() : A {new A};
};

class A1 inherits A {
  i : Int;
  get() : Int {i};
  foo() : A1 {new A1};
};

class A2 inherits A {
};

class A11 inherits A1 {
  compute(x:A1, y:A1) : Int {x.get() + y.get()};
};

class A12 inherits A1 {
  b : Bool;
  compute(a:Int, b:Int): Int {c * i};
};

class A111 inherits A11 {
  i : Int <- 9;
};

class A121 inherits A12 {
  foo() : A122 {new A122};
};

class A122 inherits A12 {
  compute(a:Bool) : Bool {a = b};
};

Class Main {
  main() : Int{1};
  a() : Bool {(new A).compute(1,0)};
  b() : Int {(new A).compute(1)};
  c() : Int {(new A).compute(1,2,3)};
  d() : Int {(new A).compute(true, nothing)};
};
