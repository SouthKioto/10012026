library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity final_lab is
    port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    start    : in  std_logic;
    addr_sw  : in  std_logic_vector(2 downto 0); 
    done     : out std_logic;
    hex0     : out std_logic_vector(6 downto 0);
    hex1     : out std_logic_vector(6 downto 0);
    key0     : in  std_logic;
    key1     : in  std_logic
);
end final_lab;

architecture rtl of final_lab is
    signal mem_rd, mem_wr     : std_logic;
    signal reg_load, reg_exec : std_logic;
    signal mem_to_reg         : std_logic_vector(7 downto 0);
    signal reg_to_mem         : std_logic_vector(7 downto 0);

    signal rd_addr, wr_addr : integer range 0 to 7;

    function to_hex(val : std_logic_vector(3 downto 0))
        return std_logic_vector is
    begin
        case val is
            when "0000" => return "1000000";
            when "0001" => return "1111001";
            when "0010" => return "0100100";
            when "0011" => return "0110000";
            when "0100" => return "0011001";
            when "0101" => return "0010010";
            when "0110" => return "0000010";
            when "0111" => return "1111000";
            when "1000" => return "0000000";
            when "1001" => return "0010000";
            when others => return "1111111";
        end case;
    end function;
begin

    rd_addr <= to_integer(unsigned(addr_sw));
    wr_addr <= (rd_addr + 1) mod 8;

    fsm : entity work.fsm_ctrl
        port map (
            clk      => clk,
            rst      => rst,
            start    => start,
            mem_rd   => mem_rd,
            reg_load => reg_load,
            reg_exec => reg_exec,
            mem_wr   => mem_wr,
            done     => done
        );

    reg0 : entity work.work_reg
        port map (
            clk     => clk,
            rst     => rst,
            load    => reg_load,
            exec    => reg_exec,
            op      => '1',
            dir     => '0',
            data_in => mem_to_reg,
            q       => reg_to_mem
        );

    ram : entity work.reg_mem
        port map (
            clk      => clk,
            rd_en    => mem_rd,
            wr_en    => mem_wr,
            rd_addr  => rd_addr,
            wr_addr  => wr_addr,
            data_in  => reg_to_mem,
            data_out => mem_to_reg
        );

    hex0 <= to_hex(reg_to_mem(3 downto 0));
    hex1 <= to_hex(reg_to_mem(7 downto 4));

end rtl;
