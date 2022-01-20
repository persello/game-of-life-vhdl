LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;

ENTITY cell IS
    PORT (
        clk       : IN STD_LOGIC;
        set       : IN STD_LOGIC;
        rst       : IN STD_LOGIC;
        neighbors : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        output    : OUT STD_LOGIC
    );
END ENTITY cell;

ARCHITECTURE rtl OF cell IS

    COMPONENT ones_counter IS
        GENERIC (
            INPUT_WIDTH  : INTEGER := 8;
            OUTPUT_WIDTH : INTEGER := 4
        );

        PORT (
            input  : IN STD_LOGIC_VECTOR(INPUT_WIDTH - 1 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR(OUTPUT_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL counter_output        : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL alive_neighbors_count : INTEGER;

BEGIN

    oc1 : ones_counter
    GENERIC MAP(
        INPUT_WIDTH  => 8,
        OUTPUT_WIDTH => 4
    )
    PORT MAP(
        input  => neighbors,
        output => counter_output
    );

    alive_neighbors_count <= to_integer(unsigned(counter_output));

    next_state : PROCESS (ALL) IS
    BEGIN
        IF rst = '1' THEN
            -- Reset (highest priority)
            output <= '0';
        ELSIF set = '1' THEN
            -- Set
            output <= '1';
        ELSIF rising_edge(clk) THEN

            -- Cell transitions from dead to alive if it has exactly 3 alive neighbors
            IF (output = '0') AND (alive_neighbors_count = 3) THEN
                output <= '1';
            END IF;

            -- Cell transitions from alive to dead if it has less than 2 alive neighbors
            IF (alive_neighbors_count < 2) THEN
                output <= '0';
            END IF;

            -- Cell transitions from alive to dead if it has more than 3 alive neighbors
            IF (alive_neighbors_count > 3) THEN
                output <= '0';
            END IF;

        END IF;
    END PROCESS;

END ARCHITECTURE;
