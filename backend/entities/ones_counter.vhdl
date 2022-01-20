LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.fixed_pkg.ALL;

ENTITY ones_counter IS

    GENERIC (
        INPUT_WIDTH  : INTEGER := 8;
        OUTPUT_WIDTH : INTEGER := 4
    );

    PORT (
        input  : IN STD_LOGIC_VECTOR(INPUT_WIDTH - 1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(OUTPUT_WIDTH - 1 DOWNTO 0)
    );
END ENTITY ones_counter;

ARCHITECTURE rtl OF ones_counter IS
BEGIN

    compute : PROCESS (input)
        VARIABLE count : INTEGER := 0;
    BEGIN
        count := 0;
        FOR i IN 0 TO input'LENGTH - 1 LOOP
            IF input(i) = '1' THEN
                count := count + 1;
            END IF;
        END LOOP;
        output <= STD_LOGIC_VECTOR(to_unsigned(count, output'length));
    END PROCESS;
END ARCHITECTURE;
