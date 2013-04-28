------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- big_sigma_1.vhd
--
-- This file contains a clock-less combinational logic implementation of the
-- large Sigma_1^{256}(x) function defined in FIPS 180-2 section 4.1.2 as:
--      Sigma_1^{256}(x) = ROTR^6(x) xor ROTR^11(x) xor ROTR^25(x)
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.shatypes.all;

entity big_sigma_1 is
	port (
		x	: in	word;
		q	: out	word
	);
end big_sigma_1;

architecture rtl of big_sigma_1 is
begin
	q <= (x( 5 downto 0) & x(31 downto  6)) xor
	     (x(10 downto 0) & x(31 downto 11)) xor
	     (x(24 downto 0) & x(31 downto 25));
end rtl;
