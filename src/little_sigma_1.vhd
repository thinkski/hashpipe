------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- little_sigma_1.vhd
--
-- This file contains a clock-less combinational logic implementation of the
-- small sigma_1^{256}(x) function defined in FIPS 180-2 section 4.1.2 as:
--      sigma_1^{256}(x) = ROTR^17(x) xor ROTR^19(x) xor SHR^10(x)
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.shatypes.all;

entity little_sigma_1 is
	port (
		x	: in	word;
		q	: out	word
	);
end little_sigma_1;

architecture rtl of little_sigma_1 is
begin
	q <= (x(16 downto 0) & x(31 downto 17)) xor
	     (x(18 downto 0) & x(31 downto 19)) xor
	     ("0000000000"   & x(31 downto 10));
end rtl;
