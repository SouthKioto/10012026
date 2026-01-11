library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_mem is
    port (
        clk      : in  std_logic;
        rd_en    : in  std_logic;
        wr_en    : in  std_logic;
        rd_addr  : in  integer range 0 to 7;
        wr_addr  : in  integer range 0 to 7;
        data_in  : in  std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0)
    );
end reg_mem;

architecture rtl of reg_mem is
    type mem_t is array (0 to 7) of std_logic_vector(7 downto 0);
    signal ram_block : mem_t := (others => (others => '0'));
    signal data_reg  : std_logic_vector(7 downto 0);

    attribute ram_init_file : string;
    attribute ram_init_file of ram_block : signal is "data.mif";
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                ram_block(wr_addr) <= data_in;
            end if;

            if rd_en = '1' then
                data_reg <= ram_block(rd_addr);
            end if;
        end if;
    end process;

    data_out <= data_reg;

end rtl;
end rtl;
