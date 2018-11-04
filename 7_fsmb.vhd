-- finite state machine implementation
-- next-state logic and outputs are merged into one process

library ieee;
use ieee.std_logic_1164.all;

entity fsmb is
    port(
        clk, rst : in std_logic;
        a, b : in std_logic;
        mealy, moore : out std_logic
    );
end fsmb;

architecture rtl of fsmb is
    -- define custom type for states
    type state_type is (s0, s1, s2);
    signal state, state_next : state_type := s0;
begin

    -- state registers
    process(clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= s0;
            else
                state <= state_next;
            end if;
        end if;
    end process;

    -- next-state and output logic
    -- susceptible to short input changes for mealy outputs
    process(state, a, b) is
    begin
        -- default values for all the outputs
        -- used to avoid any accidental unintentional memory generation
        state_next <= state;
        mealy <= '0';
        moore <= '0';

        case state is
            when s0 =>
                if a = '1' then
                    if b = '1' then
                        state_next <= s2;
                        mealy <= '1';
                    else
                        state_next <= s1;
                    end if;
                else
                    state_next <= s0;
                end if;
            when s1 =>
                moore <= '1';

                if a = '1' then
                    state_next <= s0;
                else
                    state_next <= s1;
                end if;
            when s2 =>
                state_next <= s0;
        end case;
    end process;

end rtl;