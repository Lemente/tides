# minetest-tides

## About the fork

This fork is a personal experiment to improve the tides mod.

The current version uses a mix of ABMs and LBMs.
ABMs for nodes in loaded mapblocks.
LBMs to "catch-up" on the tide level when mapblocks are loaded.

Current goal : differentiate between nodes which have access to "the ocean", and small pools of water which should not be affected by tides.

defining "the ocean"?
- a mapblock full of water source
- a column of water source deeper than X
- a volume of water larger than X
- a surface of water larger than X


other idea :
- run tides simulation once, and when an air node is filled from the tops, it means it doesn't have access to the main body of water at that specific tide level.
-- create different types of water nodes with a "tide limit"
