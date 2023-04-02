sap.ui.require(
	[
		'sap/fe/test/JourneyRunner',
		'com/jcailan/rap/products/test/integration/FirstJourney',
		'com/jcailan/rap/products/test/integration/pages/ProductsList',
		'com/jcailan/rap/products/test/integration/pages/ProductsObjectPage',
		'com/jcailan/rap/products/test/integration/pages/ReviewsObjectPage'
	],
	function(JourneyRunner, opaJourney, ProductsList, ProductsObjectPage, ReviewsObjectPage) {
		'use strict';
		var JourneyRunner = new JourneyRunner({
			// start index.html in web folder
			launchUrl: sap.ui.require.toUrl('com/jcailan/rap/products') + '/index.html'
		});


		JourneyRunner.run(
			{
				pages: {
					onTheProductsList: ProductsList,
					onTheProductsObjectPage: ProductsObjectPage,
					onTheReviewsObjectPage: ReviewsObjectPage
				}
			},
			opaJourney.run
		);
	}
);