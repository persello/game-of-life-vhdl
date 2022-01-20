LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;

LIBRARY src_lib;
--
LIBRARY vunit_lib;
CONTEXT vunit_lib.vunit_context;

ENTITY cell_tb IS
    GENERIC (runner_cfg : STRING);
END;

ARCHITECTURE bench OF cell_tb IS
    -- Clock period
    CONSTANT clk_period : TIME := 5 ns;
    -- Generics

    -- Ports
    SIGNAL clk          : STD_LOGIC;
    SIGNAL set          : STD_LOGIC;
    SIGNAL rst          : STD_LOGIC;
    SIGNAL neighbors    : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL output       : STD_LOGIC;

BEGIN

    cell_inst : ENTITY src_lib.cell
        PORT MAP(
            clk       => clk,
            set       => set,
            rst       => rst,
            neighbors => neighbors,
            output    => output
        );

    main : PROCESS
    BEGIN
        test_runner_setup(runner, runner_cfg);
        WHILE test_suite LOOP
            IF run("test_cell_birth") THEN

                -- Test cell birth
                -- Set three of its neighbors to one
                neighbors    <= (OTHERS => '0');
                neighbors(0) <= '1';
                neighbors(1) <= '1';
                neighbors(2) <= '1';

                -- Set cell to be dead
                rst          <= '1';
                set          <= '0';

                WAIT FOR clk_period;

                rst <= '0';

                WAIT FOR clk_period;

                -- Check that cell is alive
                ASSERT(output = '1') REPORT "Cell should be alive, but it is not.";

                test_runner_cleanup(runner);
            ELSIF run("test_cell_death_underpopulation") THEN

                -- Test cell death for underpopulation
                -- Set one of its neighbors to one
                neighbors    <= (OTHERS => '0');
                neighbors(0) <= '1';

                -- Set cell to be alive
                rst          <= '0';
                set          <= '1';

                WAIT FOR clk_period;

                set <= '0';

                WAIT FOR clk_period;

                -- Check that cell is dead
                ASSERT(output = '0') REPORT "Cell should be dead, but it is not.";

                test_runner_cleanup(runner);

            ELSIF run ("test_cell_death_overpopulation") THEN

                -- Test cell death for overpopulation
                -- Set four of its neighbors to one
                neighbors    <= (OTHERS => '0');
                neighbors(0) <= '1';
                neighbors(1) <= '1';
                neighbors(2) <= '1';
                neighbors(3) <= '1';

                -- Set cell to be alive
                rst          <= '0';
                set          <= '1';

                WAIT FOR clk_period;

                set <= '0';

                WAIT FOR clk_period;

                -- Check that cell is dead
                ASSERT(output = '0') REPORT "Cell should be dead, but it is not.";

                test_runner_cleanup(runner);

            ELSIF run ("test_cell_survival") THEN

                -- Test cell survival
                -- Set two of its neighbors to one
                neighbors    <= (OTHERS => '0');
                neighbors(0) <= '1';
                neighbors(1) <= '1';
  

                -- Set cell to be alive
                rst          <= '0';
                set          <= '1';

                WAIT FOR clk_period;

                set <= '0';

                WAIT FOR clk_period;

                -- Check that cell is alive
                ASSERT(output = '1') REPORT "Cell should be alive, but it is not.";
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
