LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;

PACKAGE types IS
    TYPE SIGNAL_MATRIX_TYPE IS ARRAY (INTEGER RANGE <>, INTEGER RANGE <>) OF STD_LOGIC;
END PACKAGE;
--
LIBRARY work;
USE work.types.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;

ENTITY world IS
    GENERIC (
        SIZE_X : INTEGER := 10;
        SIZE_Y : INTEGER := 10
    );
    PORT (
        clk    : IN STD_LOGIC;
        load   : IN STD_LOGIC;
        input  : IN SIGNAL_MATRIX_TYPE(0 TO SIZE_X - 1, 0 TO SIZE_Y - 1);
        output : OUT SIGNAL_MATRIX_TYPE(0 TO SIZE_X - 1, 0 TO SIZE_Y - 1)
    );
END ENTITY world;

ARCHITECTURE rtl OF world IS

    COMPONENT cell IS
        PORT (
            clk       : IN STD_LOGIC;
            set       : IN STD_LOGIC;
            rst       : IN STD_LOGIC;
            neighbors : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            output    : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Completely borders the world
    SIGNAL status : SIGNAL_MATRIX_TYPE (-1 TO SIZE_X + 1, -1 TO SIZE_Y + 1);

BEGIN

    -- Generate a grid of cells
    row : FOR i IN 0 TO SIZE_X - 1 GENERATE
        col : FOR j IN 0 TO SIZE_Y - 1 GENERATE

            -- Cell instantiation
            cell_inst : cell
            PORT MAP(
                clk       => clk,
                set       => load AND input(i, j),
                rst       => load AND NOT input(i, j),
                -- neighbors => status(i - 1, j - 1) & status(i, j - 1) & status(i + 1, j - 1) &
                --              status(i - 1, j)     &                    status(i + 1, j)     &
                --              status(i - 1, j + 1) & status(i, j + 1) & status(i + 1, j + 1),
                neighbors => status(i - 1, j - 1) & status(i, j - 1) & status(i + 1, j - 1) &
                status(i - 1, j) & status(i + 1, j) &
                status(i - 1, j + 1) & status(i, j + 1) & status(i + 1, j + 1),
                output => status(i, j)
            );

        END GENERATE;
    END GENERATE;

    row_out : FOR i IN 0 TO SIZE_X - 1 GENERATE
        col_out : FOR j IN 0 TO SIZE_Y - 1 GENERATE
            output(i, j) <= status(i, j);
        END GENERATE;
    END GENERATE;

END ARCHITECTURE;
