library ieee;
use ieee.std_logic_1164.all;

entity lab8 is
    port (
        clk       : in  std_logic;                  
        rst       : in  std_logic;          
        enable    : in  std_logic;              
        dir       : in  std_logic;                    
        serial_in : in  std_logic;
        switch    : in  std_logic_vector(7 downto 0);
        q         : out std_logic_vector(7 downto 0)
    );
end lab8;

architecture rtl of lab8 is
    signal reg : std_logic_vector(7 downto 0);
begin

    process(clk, rst)
    begin
        if rst = '0' then
            reg <= (others => '0');               
        elsif rising_edge(clk) then
            if enable = '1' then
                reg <= switch;
            else
               if reg = "00000000" then
                    reg <= "00000001";
                else
                    if dir = '0' then
                        reg <= reg(6 downto 0) & serial_in;
                    else
                        reg <= serial_in & reg(7 downto 1);
                    end if;
                end if;
            end if;
        end if;
    end process;

    q <= reg;

end rtl;
