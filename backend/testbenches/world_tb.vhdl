LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY src_lib;
USE src_lib.types.ALL;
--
LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY world_tb IS
    GENERIC (runner_cfg : STRING);
END;

ARCHITECTURE bench OF world_tb IS
    -- Clock period
    CONSTANT clk_period : TIME    := 5 ns;

    -- Generics
    CONSTANT size_x     : INTEGER := 10;
    CONSTANT size_y     : INTEGER := 10;

    -- Ports
    SIGNAL clk          : STD_LOGIC;
    SIGNAL load         : STD_LOGIC;
    SIGNAL input        : SIGNAL_MATRIX_TYPE(0 TO size_x - 1, 0 TO size_y - 1);
    SIGNAL world_output : SIGNAL_MATRIX_TYPE(0 TO size_x - 1, 0 TO size_y - 1);

BEGIN

    world_inst : ENTITY src_lib.world
        GENERIC MAP(
            size_x => size_x,
            size_y => size_y
        )
        PORT MAP(
            clk    => clk,
            load   => load,
            input  => input,
            output => world_output
        );

    main : PROCESS
        VARIABLE l : LINE;
    BEGIN
        test_runner_setup(runner, runner_cfg);
        WHILE test_suite LOOP
            IF run("test_glider") THEN

                -- Load a glider
                input <= (others=> (others=>'0'));
                input(1, 2) <= '1';
                input(2, 3) <= '1';
                input(3, 1) <= '1';
                input(3, 2) <= '1';
                input(3, 3) <= '1';

                load        <= '1';

                WAIT FOR clk_period;

                load <= '0';

                WAIT FOR clk_period;

                FOR a IN 0 TO 100 LOOP
                    -- Print the matrix
                    FOR i IN 0 TO size_x - 1 LOOP
                        FOR j IN 0 TO size_y - 1 LOOP
                            write(l, world_output(i, j));
                        END LOOP;

                        write(l, LF);

                    END LOOP;

                    writeline(output, l);

                    -- Wait for the next clock cycle
                    WAIT FOR clk_period;
                END LOOP;

                test_runner_cleanup(runner);
            END IF;
        END LOOP;
    END PROCESS main;

    clk_process : PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR clk_period/2;
        clk <= '0';
        WAIT FOR clk_period/2;
    END PROCESS clk_process;

END;
