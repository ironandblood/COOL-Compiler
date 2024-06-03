-- class A inherits A {};

-- class B1 inherits B3 {};
-- class B2 inherits B1 {};
-- class B3 inherits B2 {};

-- class Main{};
-- class A inherits B{};

-- Class B{
--     fn() : SELF_TYPE{
--         1
--     };
-- };
-- Class A inherits B{
--     i : SELF_TYPE <- new B;
--     f() : B{
--         new A
--     };
-- };

-- Class Main{
--     main(): B {
--         new A
--     };
-- };

-- Class C inherits SELF_TYPE{};
Class C {
    f(x : Int) : Int {
        let y : Int <- 1 in{
            z + 1;
            let z : Int <- 2 in{
                2;
            };
        }
    };
};

Class Main {
    main() :Int {
        (new C).f(1)
    };
};