---------------------------------------------------------------------------------------------
-- More detailed description of each config option can be found here: https://docs.dejv.it/ac_gifts
---------------------------------------------------------------------------------------------

ac = {
	-- Predefined gift sizes - {slots, weight}
	sizes = {
		small = {1, 1000},
		medium = {3, 5000},
		large = {5, 15000},
	},

	-- Default gift size if no size is specified (one of the above)
	defaultSize = 'medium',

	-- Item names used for gifts
	items = {
		gift = 'gift',
		emptyGift = 'empty_gift',
		openedGift = 'opened_gift',
	},

	-- Checks for latest version (recommended)
	checkVersion = true,
}
