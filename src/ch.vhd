------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- ch.vhd
--
-- This file contains a clock-less combinational logic implementation of the
-- Ch(x,y,z) function defined in FIPS 180-2.
--
-- As noted in section 4.1 of FIPS 180-2, the exclusive-OR operation in this
-- function may be replaced with a bitwise OR, as has been done here, and will
-- produce identical results.
--
-- The function is defined in FIPS 180-2 as:
--      Ch(x,y,z) = (x & y) ^ (~x & z);
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.shatypes.all;

entity ch is
	port (
		x	: in	word;
		y	: in	word;
		z	: in	word;

		q	: out	word
	);
end ch;

architecture rtl of ch is
begin
	q <= (x and y) xor ((not x) and z);
end rtl;
