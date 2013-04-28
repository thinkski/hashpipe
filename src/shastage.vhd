------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- shastage.vhd
--
-- Computes one stage (i.e. round) of a SHA-256 hash, as defined in step 3 of
-- FIPS 180-2. Sixty-four stages should be pipelined together to complete
-- step 3.
--
-- The output is latched with clocked delay flip-flops to allow for a systolic
-- array.
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.shatypes.all;

entity shastage is
	generic (
		-- stage number (0 to 63 inclusive)
		t	: natural range 0 to 63
	);
	port (
		-- systolic clock
		clk	: in	std_logic;
		
		-- message in (for computing W_t)
		w	: in	word_vector(0 to 63);

		-- working variables in
		a	: in	word;
		b	: in	word;
		c	: in	word;
		d	: in	word;
		e	: in	word;
		f	: in	word;
		g	: in	word;
		h	: in	word;

		-- message out (latched)
		qw	: out	word_vector(0 to 63);

		-- working variables out (latched)
		qa	: out	word;
		qb	: out	word;
		qc	: out	word;
		qd	: out	word;
		qe	: out	word;
		qf	: out	word;
		qg	: out	word;
		qh	: out	word
	);
end shastage;

architecture rtl of shastage is

	-- K_t constants as defined in Section 4.2.2 of FIPS 180-2
	constant k: word_vector(0 to 63) := ( 
		x"428a2f98", x"71374491", x"b5c0fbcf", x"e9b5dba5",
		x"3956c25b", x"59f111f1", x"923f82a4", x"ab1c5ed5",
		x"d807aa98", x"12835b01", x"243185be", x"550c7dc3",
		x"72be5d74", x"80deb1fe", x"9bdc06a7", x"c19bf174",
		x"e49b69c1", x"efbe4786", x"0fc19dc6", x"240ca1cc",
		x"2de92c6f", x"4a7484aa", x"5cb0a9dc", x"76f988da",
		x"983e5152", x"a831c66d", x"b00327c8", x"bf597fc7",
		x"c6e00bf3", x"d5a79147", x"06ca6351", x"14292967",
		x"27b70a85", x"2e1b2138", x"4d2c6dfc", x"53380d13",
		x"650a7354", x"766a0abb", x"81c2c92e", x"92722c85",
		x"a2bfe8a1", x"a81a664b", x"c24b8b70", x"c76c51a3",
		x"d192e819", x"d6990624", x"f40e3585", x"106aa070",
		x"19a4c116", x"1e376c08", x"2748774c", x"34b0bcb5",
		x"391c0cb3", x"4ed8aa4a", x"5b9cca4f", x"682e6ff3",
		x"748f82ee", x"78a5636f", x"84c87814", x"8cc70208",
		x"90befffa", x"a4506ceb", x"bef9a3f7", x"c67178f2"
	);

	component ch is
		port (
			x	: in	word;
			y	: in	word;
			z	: in	word;
			q	: out	word
		);
	end component ch;

	component maj is
		port (
			x	: in	word;
			y	: in	word;
			z	: in	word;
			q	: out	word
		);
	end component maj;

	component big_sigma_0 is
		port (
			x	: in	word;
			q	: out	word
		);
	end component big_sigma_0;

	component big_sigma_1 is
		port (
			x	: in	word;
			q	: out	word
		);
	end component big_sigma_1;
	
	component little_sigma_0 is
		port (
			x	: in	word;
			q	: out	word
		);
	end component little_sigma_0;
	
	component little_sigma_1 is
		port (
			x	: in	word;
			q	: out	word
		);
	end component little_sigma_1;

	signal majout	: word;
	signal chout	: word;
	signal bs0out	: word;
	signal bs1out	: word;
	signal ls0out	: word;
	signal ls1out	: word;

	signal T1	: word;
	signal T2	: word;
	signal Wt	: word;
	
	signal ls0in	: word;
	signal ls1in	: word;
	
begin

	test0: if (t >= 16) generate
		ls0in <= w(t-15);
		ls1in <= w(t-2);
		Wt    <= ls1out + w(t-7) + ls0out + w(t-16);
	end generate;
	
	test1: if (t < 16) generate
		ls0in <= x"00000000";
		ls1in <= x"00000000";
		Wt    <= w(t);	
	end generate;

--	ls0in <= w(t-15)                            when t >= 16 else x"00000000";
--	ls1in <= w(t-2)                             when t >= 16 else x"00000000";
--	Wt    <= ls1out + w(t-7) + ls0out + w(t-16) when t >= 16 else w(t);

	ch_func: ch              port map (e, f, g, chout);
	maj_func: maj            port map (a, b, c, majout);
	bs0_func: big_sigma_0    port map (a,       bs0out);
	bs1_func: big_sigma_1    port map (e,       bs1out);
	ls0_func: little_sigma_0 port map (ls0in,   ls0out);
	ls1_func: little_sigma_1 port map (ls1in,   ls1out);

	T1 <= h + bs1out + chout + k(t) + Wt;
	T2 <=     bs0out + majout;

	-- rising clock edge
	process (clk)
	begin
		if (clk'event and clk = '1') then
			qh <= g;
			qg <= f;
			qf <= e;
			qe <= d + T1;
			qd <= c;
			qc <= b;
			qb <= a;
			qa <= T1 + T2;
			
			message_schedule: for i in 0 to 63 loop
				if (i = t) then
					qw(i) <= Wt;
				else
					qw(i) <= w(i);
				end if;
			end loop;
			
		end if;
	end process;

end rtl;
