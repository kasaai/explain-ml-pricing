library(tidyverse)
library(DALEX)
library(ggplot2)
library(scales)

pins::board_register_github(name = "cork", repo = "kasaai/cork")
testing_data <- pins::pin_get("toy-model-testing-data", board = "cork")
piggyback::pb_download(file = "model_artifacts/toy-model.tar.gz", repo = "kasaai/cork")
untar("model_artifacts/toy-model.tar.gz", exdir = "model_artifacts")
toy_model <- keras::load_model_tf("model_artifacts/toy-model")

predictors <- c(
  "sex", "age_range", "vehicle_age", "make", 
  "vehicle_category", "region"
)

custom_predict <- function(model, newdata) {
  predict(model, newdata, batch_size = 10000)
}

explainer_nn <- DALEX::explain(
  model = toy_model,
  data = testing_data,
  y = testing_data$loss_per_exposure,
  predict_function = custom_predict,
  label = "neural_net"
)

pdp_vehicle_age <- ingredients::partial_dependency(
  explainer_nn, 
  "vehicle_age",
  N = 1500
)

pdp_plot <- as.data.frame(pdp_vehicle_age) %>% 
  ggplot(aes(x = `_x_`, y = `_yhat_`)) + 
  geom_line() +
  xlab("Vehicle Age") +
  ylab("Average Predicted Loss Cost") +
  theme_bw() +
  geom_rug(sides = "b")

ggsave("manuscript/figures/pdp-plot.png", plot = pdp_plot)

fi <- ingredients::feature_importance(
  explainer_nn,
  loss_function = function(observed, predicted, weights) {
    sqrt(
      sum(((observed - predicted) ^ 2 * weights) /sum(weights))
    )
  },
  weights = testing_data$exposure,
  variables = predictors,
  B = 10,
  n_sample = 50000
)

fi_plot <- fi %>% 
  as.data.frame() %>% 
  (function(df) {
    full_model_loss <- df %>% 
      filter(variable == "_full_model_") %>% 
      pull(dropout_loss)
    df %>% 
      filter(!variable %in% c("_full_model_", "_baseline_")) %>% 
      ggplot(aes(x = reorder(variable, dropout_loss), y = dropout_loss)) +
      geom_bar(stat = "identity") +
      geom_hline(yintercept = full_model_loss, col = "red", linetype = "dashed")+
      scale_y_continuous(limits = c(full_model_loss, NA),
                         oob = rescale_none
      ) +
      xlab("Variable") +
      ylab("Dropout Loss (RMSE)") +
      coord_flip() +
      theme_bw() +
      NULL
  })

ggsave("manuscript/figures/fi-plot.png", plot = fi_plot)

sample_row <- testing_data[1,] %>% 
  select(predictors)
breakdown <- iBreakDown::break_down(explainer_nn, sample_row)

df <- breakdown %>% 
  as.data.frame() %>% 
  mutate(start = lag(cummulative, default = first(contribution)),
         label = formatC(contribution, digits = 2, format = "f")) %>% 
  mutate_at("label", 
            ~ ifelse(!variable %in% c("intercept", "prediction") & .x > 0,
                     paste0("+", .x),
                     .x))

breakdown_plot <- df %>% 
  ggplot(aes(reorder(variable, position), fill = sign,
             xmin = position - 0.40, 
             xmax = position + 0.40, 
             ymin = start, 
             ymax = cummulative)) +
  geom_rect(alpha = 0.4) +
  geom_errorbarh(data = df %>% filter(variable_value != ""),
                 mapping = aes(xmax = position - 1.40,
                               xmin = position + 0.40,
                               y = cummulative), height = 0,
                 linetype = "dotted",
                 color = "blue") +
  geom_rect(
    data = df %>% filter(variable %in% c("intercept", "prediction")),
    mapping = aes(xmin = position - 0.4,
                  xmax = position + 0.4,
                  ymin = start,
                  ymax = cummulative),
    color = "black") +
  scale_fill_manual(values = c("blue", "orange", NA)) +
  coord_flip() +
  theme_bw() +
  theme(legend.position = "none") + 
  geom_text(
    aes(label = label, 
        y = pmax(df$cummulative,  df$cummulative - df$contribution)), 
    nudge_y = 10,
    hjust = "inward", 
    color = "black"
  ) +
  xlab("Variable") +
  ylab("Contribution") +
  theme(axis.text.y = element_text(size = 10))

ggsave("manuscript/figures/breakdown-plot.png", plot = breakdown_plot)
