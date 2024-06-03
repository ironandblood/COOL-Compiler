(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Stack{
   isNil() : Bool { true };
   head()  : StackCommand { { abort(); new StackCommand; } };
   tail()  : Stack { { abort(); self; } };
   stacko(i : StackCommand) : Stack {
      (new StackO).init(i, self)
   };
};

class StackO inherits Stack {
   top : StackCommand;
   cdr : Stack;
   isNil() : Bool { false };
   head() : StackCommand { top };
   tail() : Stack { cdr };
   init(i : StackCommand, s : Stack) : Stack {
      {
	 top <- i;
	 cdr <- s;
	 self;
      }
   };
};

class StackCommand inherits IO{
   str : String;
   
   init(i : String) : StackCommand {
      {
         str <- i;
         self;
      }
   };
   
   content() : String {
      str
   };
   
   value() : Int {
      {
         abort();
         0;
      }
   };
   
   pushCommand(s : Stack) : Stack {
      s.stacko(self)
   };
   
   executeCommand(s : Stack) : Stack {
      s
   };
};

class IntCommand inherits StackCommand {
   num : Int;
   
   init(i : String) : StackCommand {
      {
         str <- i;
         num <- (new A2I).a2i(i);
         self;
      }
   };
   
   init_int(i : Int) : IntCommand {
      {
         num <- i;
         str <- (new A2I).i2a(i);
         self;
      }
   };
   
   value() : Int {
      num
   };
};

class AddCommand inherits StackCommand{
   a : Int;
   b : Int;
   ic : IntCommand;
   
   executeCommand(s : Stack) : Stack {
      {
         s <- s.tail();
         a <- s.head().value();
         s <- s.tail();
         b <- s.head().value();
         s <- s.tail();
         ic <- (new IntCommand).init_int(a + b);
         s.stacko(ic);
      }
   };
};

class SwapCommand inherits StackCommand{
   a : StackCommand;
   b : StackCommand;
   
   executeCommand(s : Stack) : Stack {
      {
         s <- s.tail();
         a <- s.head();
         s <- s.tail();
         b <- s.head();
         s <- s.tail();
         s <- s.stacko(a);
         s.stacko(b);
      }
   };
};

class EvaluateCommand inherits StackCommand{
   pushCommand(s : Stack) : Stack {
      if s.isNil() then s else
      s.head().executeCommand(s)
      fi
   };
};

class DisplayCommand inherits StackCommand{
   temp : Stack;
   pushCommand(s : Stack) : Stack {
      {
         temp <- s;
         while not temp.isNil() loop
            {
               out_string(temp.head().content());
               out_string("\n");
               temp <- temp.tail();
            }
         pool;
         s;
      }
   };
};

class XCommand inherits StackCommand{
   pushCommand(s : Stack) : Stack {
      {
         abort();
         s;
      }
   };
};

class Main inherits IO {
   str : String;
   s : Stack;
   
   command() : Stack {
      if str = "x" then (new XCommand).init(str).pushCommand(s) else
      if str = "d" then (new DisplayCommand).init(str).pushCommand(s) else
      if str = "e" then (new EvaluateCommand).init(str).pushCommand(s) else
      if str = "s" then (new SwapCommand).init(str).pushCommand(s) else
      if str = "+" then (new AddCommand).init(str).pushCommand(s) else
      (new IntCommand).init(str).pushCommand(s)
      fi fi fi fi fi
   };

   main() : Object {
      {
         s <- new Stack;
         while true loop
            {
                out_string(">");
                str <- in_string();
                out_string(str);
                out_string("\n");
                s <- command();
            }
         pool;
      }
   };

};
