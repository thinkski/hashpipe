------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- little_sigma_0.vhd
--
-- This file contains a clock-less combinational logic implementation of the
-- small sigma_0^{256}(x) function defined in FIPS 180-2 section 4.1.2 as:
--      sigma_0^{256}(x) = ROTR^7(x) xor ROTR^18(x) xor SHR^3(x)
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.shatypes.all;

entity little_sigma_0 is
	port (
		x	: in	word;
		q	: out	word
	);
end little_sigma_0;

architecture rtl of little_sigma_0 is
begin
	q <= (x( 6 downto 0)  & x(31 downto  7)) xor
	     (x(17 downto 0)  & x(31 downto 18)) xor
	     ("000"           & x(31 downto  3));
end rtl;
