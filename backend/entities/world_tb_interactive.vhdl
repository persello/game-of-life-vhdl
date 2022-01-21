LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

LIBRARY std;
USE std.textio.ALL;

LIBRARY src_lib;
USE src_lib.types.ALL;

ENTITY world_tb_interactive IS
END;

ARCHITECTURE bench OF world_tb_interactive IS
    -- Clock period
    CONSTANT clk_period : TIME    := 5 ns;

    -- Generics
    CONSTANT size_x     : INTEGER := 10;
    CONSTANT size_y     : INTEGER := 10;

    -- Ports
    SIGNAL clk          : STD_LOGIC;
    SIGNAL load         : STD_LOGIC;
    SIGNAL world_input  : SIGNAL_MATRIX_TYPE(0 TO size_x - 1, 0 TO size_y - 1);
    SIGNAL world_output : SIGNAL_MATRIX_TYPE(0 TO size_x - 1, 0 TO size_y - 1);

    -- Internal signals
    SIGNAL tb_clock     : STD_LOGIC;

BEGIN

    world_inst : ENTITY src_lib.world
        GENERIC MAP(
            size_x => size_x,
            size_y => size_y
        )
        PORT MAP(
            clk    => clk,
            load   => load,
            input  => world_input,
            output => world_output
        );

    main : PROCESS
        VARIABLE l : LINE;
    BEGIN

        -- Print ready message
        write(l, string'("READY"));
        writeline(output, l);

        WHILE TRUE LOOP
            -- Read from stdin.
            -- The first character tells the command.
            --   'l' = load, followed by a 2D array of zeros and ones.
            --   's' = step, prints the current world.
            --   'x' = get the width of the world.
            --   'y' = get the height of the world.
            readline(input, l);

            -- Process the command.
            IF l.ALL = "l" THEN
                -- Confirm command.
                writeline(output, l);

                -- Load the world.
                FOR i IN 0 TO size_x - 1 LOOP
                    readline(input, l);
                    FOR j IN 0 TO size_y - 1 LOOP
                        world_input(i, j) <= '1' WHEN l(j + 1) = '1' ELSE
                        '0';
                    END LOOP;
                END LOOP;

                WAIT FOR clk_period / 2;
                load <= '1';
                WAIT FOR clk_period / 2;
                load <= '0';

                write(l, '*');
                writeline(output, l);
            ELSIF l.ALL = "s" THEN
                -- Confirm command.
                writeline(output, l);

                -- Print the world.
                FOR i IN 0 TO size_x - 1 LOOP
                    FOR j IN 0 TO size_y - 1 LOOP
                        write(l, world_output(i, j));
                    END LOOP;
                    writeline(output, l);
                END LOOP;

                -- Step the world.
                WAIT FOR clk_period / 2;
                clk <= '1';
                WAIT FOR clk_period / 2;
                clk <= '0';
            ELSIF l.ALL = "x" THEN
                -- Confirm command.
                writeline(output, l);

                -- Print the width.
                write(l, size_x);
                writeline(output, l);
            ELSIF l.ALL = "y" THEN
                -- Confirm command.
                writeline(output, l);

                -- Print the height.
                write(l, size_y);
                writeline(output, l);

            ELSE
                -- Invalid command.
                write(l, '!');
                writeline(output, l);
            END IF;
        END LOOP;
    END PROCESS;

    -- tb_clock_generator : PROCESS
    -- BEGIN
    --     -- Clock generation.
    --     tb_clock <= '0';
    --     WAIT FOR clk_period;
    --     tb_clock <= '1';
    --     WAIT FOR clk_period;
    -- END PROCESS;
END;
