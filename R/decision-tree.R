library(rpart)
library(rpart.plot)

testing_data <- pins::pin_get("toy-model-testing-data", board = "cork")

small_data <- testing_data %>% 
  sample_n(10000) %>% 
  mutate(make = factor(make))
tree_model1 <- rpart(loss_per_exposure ~ age_range + vehicle_age + sex, data = testing_data, 
                    weights = exposure, method = "anova",
                    control = rpart.control(minsplit = 2, minbucket = 1, cp = 0.0001,
                                            maxdepth = 2))

# tree_plot1 <- rpart.plot(tree_model1, type = 1, faclen = 10, tweak = 1.05, branch = 0)
# ggsave("manuscript/figures/tree-plot1.png", plot = tree_plot1)
png("manuscript/figures/tree-plot1.png", width = 400, height = 300)
rpart.plot(tree_model1, type = 1, faclen = 10, tweak = 1.05, branch = 0)
dev.off()

tree_model2 <- rpart(loss_per_exposure ~ age_range + vehicle_age + sex + vehicle_category,
                     data = testing_data, 
                     weights = exposure, method = "anova",
                     control = rpart.control(minsplit = 2, minbucket = 1, cp = 0.0001,
                                             maxdepth = 10))

png("manuscript/figures/tree-plot2.png", width = 700, height = 400)
rpart.plot(tree_model2, type = 1, faclen = 10, tweak = 1.05, branch = 0)
dev.off()
