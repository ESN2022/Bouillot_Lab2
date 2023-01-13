library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab2 is
    port(
        clk 		: in std_logic := '0';
        reset 	: in std_logic :='0';
		  pio_0 		: out std_logic_vector(7 downto 0);
		  pio_1 		: out std_logic_vector(7 downto 0);
		  pio_2 		: out std_logic_vector(7 downto 0)
		  );
end entity;

architecture rtl of lab2 is
    component lab2_qsys is
        port (
				clk_clk        						: in  std_logic                    := 'X'; -- clk
            reset_reset_n  						: in  std_logic                    := 'X'; -- reset_n
            pio_0_external_connection_export : out std_logic_vector(3 downto 0);         -- export
				pio_1_external_connection_export : out std_logic_vector(3 downto 0);         -- export
				pio_2_external_connection_export : out std_logic_vector(3 downto 0)         -- export
        );
    end component lab2_qsys;
	 
	 component bin_to_7seg is
			port (
					input: in std_logic_vector(3 downto 0) := (others => 'X');
					output : out std_logic_vector(7 downto 0)
			);
	end component bin_to_7seg;
	
signal tempo_u : std_logic_vector(3 downto 0);
signal tempo_d : std_logic_vector(3 downto 0);
signal tempo_c : std_logic_vector(3 downto 0);
begin
	
		u0 : component bin_to_7seg
			port map (input => tempo_u,output => pio_0);
			
		u1 : component bin_to_7seg
			port map (input => tempo_d,output => pio_1);
			
		u2 : component bin_to_7seg
			port map (input => tempo_c,output => pio_2);
				
		u3 : component lab2_qsys
			port map (clk_clk=>clk,
						reset_reset_n=>reset,
						pio_0_external_connection_export=>tempo_u,
						pio_1_external_connection_export=>tempo_d,
						pio_2_external_connection_export=>tempo_c
						);  
end architecture;