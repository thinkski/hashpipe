------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- shapipe.vhd
--
-- Sixty-four stage systolic SHA pipeline.
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;
use work.shatypes.all;

entity shapipe is
	port (
		clk		: in	std_logic;
		
		-- 512-bit input message
		message	: in	word_vector(0 to 15);
		
		-- sha 256-bit hash
		hash	: out	word_vector(0 to 7)
	);
end shapipe;

architecture rtl of shapipe is

	-- single stage of pipeline
	component shastage is
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
	end component shastage;
	
	-- working variable buses
	signal a	: word_vector(0 to 64);
	signal b	: word_vector(0 to 64);
	signal c	: word_vector(0 to 64);
	signal d	: word_vector(0 to 64);
	signal e	: word_vector(0 to 64);
	signal f	: word_vector(0 to 64);
	signal g	: word_vector(0 to 64);
	signal h	: word_vector(0 to 64);
	
	subtype schedule is word_vector(0 to 63);
	type schedule_vector is array (natural range <>) of schedule;
	
	signal w	: schedule_vector(0 to 64);

begin

	-- initial message schedule
	message_schedule: for i in 0 to 15 generate
		w(0)(i) <= message(i);
	end generate;
	schedule_filler: for i in 16 to 63 generate
		w(0)(i) <= x"00000000";
	end generate;


	-- initial working variables 
	a(0) <= x"6a09e667";
	b(0) <= x"bb67ae85";
	c(0) <= x"3c6ef372";
	d(0) <= x"a54ff53a";
	e(0) <= x"510e527f";
	f(0) <= x"9b05688c";
	g(0) <= x"1f83d9ab";
	h(0) <= x"5be0cd19";

	-- systolic array
	pipeline: for i in 0 to 63 generate
		stage: shastage generic map (i) port map (
			clk,
			w(i),
			a(i), b(i), c(i), d(i), e(i), f(i), g(i), h(i),
			w(i+1),
			a(i+1), b(i+1), c(i+1), d(i+1), e(i+1), f(i+1), g(i+1), h(i+1)
		);
	end generate;
	
	-- drive output hash
	hash(0) <= a(0) + a(64);
	hash(1) <= b(0) + b(64);
	hash(2) <= c(0) + c(64);
	hash(3) <= d(0) + d(64);
	hash(4) <= e(0) + e(64);
	hash(5) <= f(0) + f(64);
	hash(6) <= g(0) + g(64);
	hash(7) <= h(0) + h(64);

end rtl;

