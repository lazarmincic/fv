library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity zadaci is

    port (
    
        clk : in std_logic;
		rst : in std_logic;
		-- zadatak 1.
        rt_1  : out std_logic;
        rdy_1   : out std_logic;
        start_1   : out std_logic;
		endd_1   : out std_logic;
		-- zadatak 2.
		er_2 : out std_logic;
		-- zadatak 3.
		er_3 : out std_logic;
		rdy_3 : out std_logic;
		-- zadatak 4.
		rdy_4 : out std_logic;
		start_4 : out std_logic;
		-- zadatak 5.
		endd_5 : out std_logic;
		stop_5 : out std_logic;
		er_5 : out std_logic;
		rdy_5 : out std_logic;
		start_5 : out std_logic;
		-- zadatak 6.
		endd_6 : out std_logic;
		stop_6 : out std_logic;
		er_6 : out std_logic;
		rdy_6 : out std_logic;
		-- zadatak 7.
		endd_7 : out std_logic;
		start_7 : out std_logic;
		status_valid_7 : out std_logic;
		instartsv_7 : out std_logic;
		-- zadatak 8.
		rt_8 : out std_logic;
		enable_8 : out std_logic;
		-- zadatak 9.
		rdy_9 : out std_logic;
		start_9 : out std_logic;
		interrupt_9 : out std_logic;
		-- zadatak 10.
		ack_10 : out std_logic;
		req_10 : out std_logic
        );

end entity zadaci;

architecture beh of zadaci is

signal cnt_s: unsigned (3 downto 0) := X"0";  -- da li moze bez x i navodnika?

begin

    process(clk, rst)  --brojac broji
	begin
	if rising_edge(clk) then
	   if rst = '1' then
	       cnt_s <= X"0";
	   else if cnt_s /= X"B" then -- a 10 b11
	       cnt_s <= cnt_s + 1;
	   else    
	       cnt_s <= X"B";
	   end if;
	   end if;
	end if;
    end process;
	
	-- zadatak 1.
	with cnt_s select
		rt_1 <= '1' when X"0"|X"1"|X"2"|X"3"|X"8",
		'0' when others;

	with cnt_s select --rdy_1
	    rdy_1 <= '1' when X"5",
	    '0'
	when others;

	with cnt_s select --start_1
	    start_1 <= '1' when X"8",
	    '0'
	when others;

	with cnt_s select --endd_1
	    endd_1 <= '1' when X"6",
	    '0'
	when others;
	
	-- zadatak 2.
	with cnt_s select
		er_2 <= '1' when X"1"|X"2"|X"6"|X"7"|X"8"|X"9",
		'0' when others;
	
	-- zadatak 3.
	with cnt_s select
		er_3 <= '1' when X"1"|X"5"|X"6"|X"9",
		'0' when others;
		
	with cnt_s select
		rdy_3 <= '1' when X"1"|X"2"|X"5"|X"9",
		'0' when others;
		
	-- zadatak 4.
	with cnt_s select
		rdy_4 <= '1' when X"6",
		'0' when others;
		
	with cnt_s select
		start_4 <= '1' when X"2",
		'0' when others;
	
	-- zadatak 5.
	with cnt_s select
		endd_5 <= '1' when X"2",
		'0' when others;
		
	stop_5 <= '0';
	
	with cnt_s select
		er_5 <= '1' when X"A", --10
		'0' when others;
		
	with cnt_s select
		rdy_5 <= '1' when X"1"|X"2"|X"8"|X"9"|X"A", 
		'0' when others;
		
	with cnt_s select
		start_5 <= '1' when X"8", 
		'0' when others;
	
	-- zadatak 6.
	with cnt_s select
		endd_6 <= '1' when X"2", 
		'0' when others;
		
	with cnt_s select
		stop_6 <= '1' when X"5", 
		'0' when others;
		
	with cnt_s select
		er_6 <= '1' when X"A", 
		'0' when others;
		
	with cnt_s select
		rdy_6 <= '1' when X"1"|X"2"|X"4"|X"5"|X"6"|X"9"|X"A", 
		'0' when others;
	
	-- zadatak 7.
	with cnt_s select
		endd_7 <= '1' when X"3",
		'0' when others;
		
	with cnt_s select
		start_7 <= '1' when X"5", 
		'0' when others;
		
	with cnt_s select
		status_valid_7 <= '1' when X"A", 
		'0' when others;
		
	with cnt_s select
		instartsv_7 <= '1' when X"3"|X"4"|X"5"|X"6"|X"7", 
		'0' when others;
		
	-- zadatak 8.
	with cnt_s select
		rt_8 <= '1' when X"0"|X"1"|X"2", 
		'0' when others;
		
	with cnt_s select
		enable_8 <= '1' when X"7", 
		'0' when others;
		
	-- zadatak 9.
	with cnt_s select
		rdy_9 <= '1' when X"2"|X"3"|X"4"|X"5"|X"6"|X"7", 
		'0' when others;
		
	with cnt_s select
		start_9 <= '1' when X"5"|X"6"|X"7", 
		'0' when others;
		
	with cnt_s select
		interrupt_9 <= '1' when X"7", 
		'0' when others;
		
	-- zadatak 10.
	with cnt_s select
		ack_10 <= '1' when X"6", 
		'0' when others;
		
	with cnt_s select
		req_10 <= '1' when X"1", 
		'0' when others;
	
    
   
end architecture beh;
