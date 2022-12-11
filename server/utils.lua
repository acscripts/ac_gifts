function getSize(type)
	return ac.sizes[type] or ac.sizes[ac.defaultSize] or {3, 5000}
end

function sizesMatches(size1, size2)
	return size1[1] == size2[1] and size1[2] == size2[2]
end

-- check for neweset version
if ac.versionCheck and GetResourceState('ox_lib') == 'started' then
	exports.ox_lib:versionCheck('acscripts/ac_gifts')
end
