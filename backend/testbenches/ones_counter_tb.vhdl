LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;

LIBRARY src_lib;
--
LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY ones_counter_tb IS
    GENERIC (runner_cfg : STRING);
END;

ARCHITECTURE bench OF ones_counter_tb IS
    -- Clock period
    CONSTANT clk_period   : TIME    := 5 ns;

    -- Generics
    CONSTANT INPUT_WIDTH  : INTEGER := 8;
    CONSTANT OUTPUT_WIDTH : INTEGER := 4;

    -- Ports
    SIGNAL input          : STD_LOGIC_VECTOR(INPUT_WIDTH - 1 DOWNTO 0);
    SIGNAL output         : STD_LOGIC_VECTOR(OUTPUT_WIDTH - 1 DOWNTO 0);

    -- Array of results
    CONSTANT TEST_LENGTH : INTEGER := 15;
    TYPE RESULTS_ARRAY IS ARRAY (0 TO TEST_LENGTH) OF INTEGER;
    CONSTANT RESULTS : RESULTS_ARRAY := (0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4);

BEGIN

    ones_counter_inst : ENTITY src_lib.ones_counter
        GENERIC MAP(
            INPUT_WIDTH  => INPUT_WIDTH,
            OUTPUT_WIDTH => OUTPUT_WIDTH
        )
        PORT MAP(
            input  => input,
            output => output
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);
        WHILE test_suite LOOP
            IF run("test_count") THEN
                -- Run test
                FOR i IN 0 TO TEST_LENGTH LOOP

                    input <= STD_LOGIC_VECTOR(to_unsigned(i, input'length));

                    WAIT FOR 5 ns;
                    ASSERT output = STD_LOGIC_VECTOR(to_unsigned(RESULTS(i), output'length)) REPORT "Wrong result at iteration " & to_string(i) & ", got " & to_string(to_integer(unsigned(output))) & ", expected " & to_string(RESULTS(i)) & ".";
                END LOOP;

                test_runner_cleanup(runner);
            END IF;
        END LOOP;
    END PROCESS main;
END;
