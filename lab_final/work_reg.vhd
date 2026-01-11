library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity work_reg is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        load      : in  std_logic; 
        exec      : in  std_logic;
        op        : in  std_logic;
        dir       : in  std_logic;
        data_in   : in  std_logic_vector(7 downto 0);
        q         : out std_logic_vector(7 downto 0)
    );
end work_reg;

architecture rtl of work_reg is
    signal reg : std_logic_vector(7 downto 0);

    -- Instancja rejestru (reg_inst)
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    reg <= (others => '0');
                elsif load = '1' then
                    reg <= data_in;
                elsif exec = '1' then
                    -- Operacje w zależności od op i dir
                    if op = '0' then
                        if dir = '0' then
                            reg <= reg(6 downto 0) & '0';  -- Rotacja w lewo
                        else
                            reg <= '0' & reg(7 downto 1);  -- Rotacja w prawo
                        end if;
                    else
                        -- Inne operacje mogą być dodane tutaj
                    end if;
                end if;
            end if;
        end process;

        q <= reg; -- Wyjście z rejestru
end rtl;
