--Class inherit and method

class A {
  compute(a:Int, b:Int) : Int {a+b};
  foo() : A {new A};
};

class A1 inherits A {
  i : Int <- 1;
  getI() : Int {i};
  foo() : A {new A1};
};

class A2 inherits A {
};

class A11 inherits A1 {
  compute(x:Int, y:Int) : Int {x-y+i};
};

class A12 inherits A1 {
  b : Bool;
  compute(b:Int, i:Int) : Int {b*i};
};

class A111 inherits A11 {
  j : Int <- 9;
  getJ() : Int {j};
};

class A121 inherits A12 {
  foo() : A {new A122};
};

class A122 inherits A12 {
  compute2(a:Bool) : Bool {a = b};
};

Class Main {
  a : A111;
  main() : Int{
    (new A121).foo().compute(a.getJ(), (new A121).getI())
  };
};
