library ieee;
use ieee.std_logic_1164.all;

entity lab8 is
    port (
        clk         : in  std_logic;
        rst         : in  std_logic;                         
        mode        : in  std_logic_vector(1 downto 0);
        serial_in   : in  std_logic;                       
        parallel_in : in  std_logic_vector(7 downto 0);      
        q           : out std_logic_vector(7 downto 0)        
    );
end lab8;

architecture rtl of lab8 is
    signal reg : std_logic_vector(7 downto 0);
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                reg <= (others => '0');
            else
                case mode is
                    when "00" =>
                        reg <= reg;
                        
                    when "01" =>
                        reg <= reg(6 downto 0) & serial_in;
                        
                    when "10" =>
                        reg <= serial_in & reg(7 downto 1);
                        
                    when "11" =>
                        reg <= parallel_in;
                        
                    when others =>
                        reg <= reg;
                end case;
            end if;
        end if;
    end process;

    q <= reg;

end rtl;
