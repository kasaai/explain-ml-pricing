library(rpart)
library(rpart.plot)

testing_data <- pins::pin_get("toy-model-testing-data", board = "cork")

set.seed(2020)
testing_data <- testing_data %>% 
  mutate_at(c("age_range", "sex", "vehicle_category"),
            ~ .x %>% 
              sub("Entre 18 e 25 anos", "18-25", .) %>% 
              sub("Entre 26 e 35 anos", "26-35", .) %>% 
              sub("Entre 36 e 45 anos", "36-45", .) %>% 
              sub("Entre 46 e 55 anos", "46-55", .) %>% 
              sub("Maior que 55 anos", "56+", .) %>% 
              sub("Não informada", "No information", .) %>% 
              sub("Feminino", "Female", .) %>% 
              sub("Masculino", "Male", .) %>% 
              sub("Passeio importado", "Passenger imported", .) %>% 
              sub("Passeio nacional", "Passenger domestic", .) %>% 
              sub("Pick-up (nacional e importado)", "Pick-up trucks", .)
            ) %>% 
  # sample_n(10000) %>% 
  mutate(make = factor(make))
tree_model1 <- rpart(loss_per_exposure ~ age_range + vehicle_age + sex, data = testing_data, 
                    weights = exposure, method = "anova",
                    control = rpart.control(minsplit = 2, minbucket = 1, cp = 0.0001,
                                            maxdepth = 2))

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
