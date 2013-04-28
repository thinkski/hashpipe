------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- big_sigma_0.vhd
--
-- This file contains a clock-less combinational logic implementation of the
-- large Sigma_0^{256}(x) function defined in FIPS 180-2 section 4.1.2 as:
--      Sigma_0^{256}(x) = ROTR^2(x) xor ROTR^13(x) xor ROTR^22(x)
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.shatypes.all;

entity big_sigma_0 is
	port (
		x	: in	word;
		q	: out	word
	);
end big_sigma_0;

architecture rtl of big_sigma_0 is
begin
	q <= (x( 1 downto 0) & x(31 downto  2)) xor
             (x(12 downto 0) & x(31 downto 13)) xor
	     (x(21 downto 0) & x(31 downto 22));
end rtl;
