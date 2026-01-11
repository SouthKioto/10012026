library ieee;
use ieee.std_logic_1164.all;

entity fsm_ctrl is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        start    : in  std_logic;
        mem_rd   : out std_logic;
        reg_load : out std_logic;
        reg_exec : out std_logic;
        mem_wr   : out std_logic;
        done     : out std_logic
    );
end fsm_ctrl;

architecture rtl of fsm_ctrl is
    type state_t is (IDLE, READ_ST, LOAD_ST, PROCESS_ST, WRITE_ST, DONE_ST);
    signal state, next_state : state_t;
begin

    -- rejestr stanu
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= IDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    -- logika przejść
    process(state, start)
    begin
        next_state <= state;
        case state is
            when IDLE =>
                if start = '1' then
                    next_state <= READ_ST;
                end if;

            when READ_ST    => next_state <= LOAD_ST;
            when LOAD_ST    => next_state <= PROCESS_ST;
            when PROCESS_ST => next_state <= WRITE_ST;
            when WRITE_ST   => next_state <= DONE_ST;
            when DONE_ST    => next_state <= IDLE;
        end case;
    end process;

    -- logika wyjść
    process(state)
    begin
        mem_rd   <= '0';
        reg_load<= '0';
        reg_exec<= '0';
        mem_wr  <= '0';
        done    <= '0';

        case state is
            when READ_ST    => mem_rd   <= '1';
            when LOAD_ST    => reg_load <= '1';
            when PROCESS_ST => reg_exec <= '1';
            when WRITE_ST   => mem_wr   <= '1';
            when DONE_ST    => done     <= '1';
            when others     => null;
        end case;
    end process;

end rtl;
