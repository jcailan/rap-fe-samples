sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
	'use strict';

	var CustomPageDefinitions = {
		actions: {},
		assertions: {}
	};

	return new ObjectPage(
		{
			appId: 'com.jcailan.rap.products',
			componentId: 'ReviewsObjectPage',
			entitySet: 'Reviews'
		},
		CustomPageDefinitions
	);
});