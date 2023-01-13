library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2 is
    port(
        clk : in std_logic := '0';
        reset : in std_logic :='0';
		  pio_0 : out std_logic_vector(23 downto 0) := (others => '0')
		  );
end entity;

architecture rtl of lab2 is
    component lab2_qsys is
        port (
				clk_clk        						: in  std_logic                    := 'X'; -- clk
            reset_reset_n  						: in  std_logic                    := 'X'; -- reset_n
            pio_0_external_connection_export : out std_logic_vector(11 downto 0)         -- export
        );
    end component lab2_qsys;
	 
	 component bin_to_7seg is
			port (
					input: in std_logic_vector(3 downto 0) := (others => 'X');
					output : out std_logic_vector(7 downto 0)
			);
	end component bin_to_7seg;
	
signal tempo : std_logic_vector(11 downto 0);
begin
	
		unit : component bin_to_7seg
			port map (input => tempo(3 downto 0),output => pio_0(7 downto 0));
		
		decimal : component bin_to_7seg
			port map (input => tempo(7 downto 4),output => pio_0(15 downto 8));
		
		centaine : component bin_to_7seg
			port map (input => tempo(11 downto 8),output => pio_0(23 downto 16));
				
		u1 : component lab2_qsys
			port map (clk_clk=>clk,
						reset_reset_n=>reset,
						pio_0_external_connection_export=>tempo);  
end architecture;