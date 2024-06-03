--let let let LET

class LLLLLLLET {
  a : Int <- let x : Int, value : Int <- x + 1 in let value : Int <- 1 in x + value;
  getA() : Int {a};
};

Class Main {
  main() : Int {
    (new LLLLLLLET).getA()
  };
};
