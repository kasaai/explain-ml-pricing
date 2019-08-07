# Towards Explainability of Machine Learning Models in Insurance Pricing

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/kasaai/explain-ml-pricing.svg?branch=master)](https://travis-ci.org/kasaai/explain-ml-pricing)
<!-- badges: end -->

Risk classification for insurance rating has traditionally been done with one-way, or univariate, analysis techniques. In recent years, many insurers have moved towards using generalized linear models (GLM), a multivariate predictive modeling technique, which addresses many shortcomings of univariate approaches, and is currently considered the state of the art in insurance risk classification. At the same time, machine learning (ML) techniques such as random forests and deep neural networks have gained popularity in many industries due to their superior predictive performance over linear models. However, these ML techniques, often considered to be completely “black box”, have been less successful in gaining adoption in insurance pricing, which is a regulated discipline and requires a certain amount of transparency in models. While recent efforts in ML research have attempted to provide mechanisms for explaining or interpreting these complex models, to the best of our knowledge none has focused on the insurance pricing use case, which we plan to address in this project. We envision that this work will be a step in enabling insurers to use and file more accurate predictive models, which lead to fairer prices. In addition, it is our intent that this work will assist practitioners in complying with relevant Actuarial Standards of Practice related to ratemaking, modeling, and clear communication of relevant assumptions. This will have additional benefits to regulators and other stakeholders tasked with reviewing actuarial work products.

The main goal of this project is to describe and demonstrate model explanation techniques for machine learning models in the context of insurance pricing. To that end, this project will involve

- Building predictive models for pricing (e.g. a GLM and a random forest.)
- Surveying the ML model explanation literature and identifying relevant techniques (e.g. partial dependence plots, locally interpretable model-agnostic explanations.)
- Applying the techniques to the models built.
- Discussing how to communicate the artifacts of these techniques.
- Discussing potential recommendations to regulators who will review ML models.

-----

Repository for the paper "Towards Explainability of Machine Learning Models in Insurance Pricing." This work is supported by the Casualty Actuarial Society.

-----

Please note that this project is released with a [Contributor Code of
Conduct](https://github.com/kasaai/quests/blob/master/CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.
