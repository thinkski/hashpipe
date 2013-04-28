------------------------------------------------------------------------------
--
-- SHA-256 Systolic Hashing Engine
-- shatypes.vhd
--
-- Custom types used throughout the project.
--
-- Copyright 2011 Chris Hiszpanski. All rights reserved.
--
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package shatypes is
	-- define word as 32-bit standard logic vector
	subtype word is std_logic_vector(31 downto 0);
	
	-- define word vector as array of 32-bit words
	type word_vector is array (natural range <>) of word;
end shatypes;
