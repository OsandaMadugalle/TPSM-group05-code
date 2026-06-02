###############################################
# EMPLOYEE ENGAGEMENT & ATTRITION ANALYSIS
# IBM HR Analytics Dataset - Full R Script
###############################################

library(dplyr)
library(ggplot2)
library(car)

###############################################
# 1. DATA IMPORT & BASIC CLEANING
###############################################

# Load dataset
df <- read.csv("HR-Employee-Attrition.csv", stringsAsFactors = FALSE)

# Inspect structure
str(df)
summary(df)

# Standardize column names
names(df) <- tolower(trimws(names(df)))7
names(df) <- gsub(" ", "_", names(df))

# Quick check
head(names(df))

###############################################
# 2. DEFINE ENGAGEMENT VARIABLES
###############################################

engage_cols <- c(
  "job_satisfaction",
  "environment_satisfaction",
  "relationship_satisfaction",
  "job_involvement",
  "work_life_balance"
)

# Ensure they exist
engage_cols[!engage_cols %in% names(df)]

# Create EngagementScore (composite)
df$engagement_score <- rowMeans(df[, engage_cols], na.rm = TRUE)

# Create engagement level (Low / Medium / High)
df$engagement_level <- cut(
  df$engagement_score,
  breaks = 3,
  labels = c("Low", "Medium", "High")
)

###############################################
# 3. TARGET ENCODING & DATA QUALITY CHECKS
###############################################

# Encode attrition as numeric (1 = Yes, 0 = No)
df$attritionnum <- ifelse(df$attrition == "Yes", 1, 0)

# Check duplicates
sum(duplicated(df))  # should be 0

# Check missing values
colSums(is.na(df))

###############################################
# 4. DESCRIPTIVE ANALYSIS
###############################################

# 4.1 Histogram - Engagement Score Distribution
ggplot(df, aes(x = engagement_score)) +
  geom_histogram(binwidth = 0.25, fill = "steelblue", color = "black") +
  labs(
    title = "Employee Engagement Score Distribution",
    x = "Engagement Score",
    y = "Number of Employees"
  ) +
  theme_minimal()

# 4.2 Boxplot - Engagement by Attrition
ggplot(df, aes(x = attrition, y = engagement_score, fill = attrition)) +
  geom_boxplot() +
  labs(
    title = "Engagement Score by Attrition Group",
    x = "Attrition (No / Yes)",
    y = "Engagement Score"
  ) +
  scale_fill_manual(values = c("No" = "skyblue", "Yes" = "salmon")) +
  theme_minimal()

# 4.3 Bar Chart - Average Engagement by Department
bar_data <- df %>%
  group_by(department) %>%
  summarise(mean_engagement = mean(engagement_score, na.rm = TRUE))

ggplot(bar_data, aes(x = department, y = mean_engagement, fill = department)) +
  geom_col(color = "black") +
  labs(
    title = "Average Engagement Score by Department",
    x = "Department",
    y = "Average Engagement Score"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# 4.4 Average Comparison - Stayed vs Left
avg_eng <- df %>%
  group_by(attrition) %>%
  summarise(mean_engagement = mean(engagement_score, na.rm = TRUE))

print(avg_eng)

###############################################
# 5. INFERENTIAL ANALYSIS
###############################################

###############################################
# 5.1 ONE-WAY ANOVA: JobLevel -> EngagementScore
###############################################

df$job_level <- df$joblevel
df$job_level_factor <- as.factor(df$job_level)

anova_result <- aov(engagement_score ~ job_level_factor, data = df)
summary(anova_result)

# Group means
df %>%
  group_by(job_level) %>%
  summarise(
    Count = n(),
    Mean_Engagement = round(mean(engagement_score, na.rm = TRUE), 4)
  )

###############################################
# 5.2 INDEPENDENT SAMPLES t-TEST:
#     Attrition (Yes/No) -> EngagementScore
###############################################

# Levene's Test for homogeneity of variance
leveneTest(engagement_score ~ attrition, data = df)

# t-test 
t_result <- t.test(engagement_score ~ attrition, data = df, var.equal = TRUE)
print(t_result)

###############################################
# 5.3 CHI-SQUARE TEST:
#     JobSatisfaction x Attrition
###############################################

# Contingency table
cont_table <- table(df$job_satisfaction, df$attrition)
print(cont_table)

# Chi-square test
chi_result <- chisq.test(cont_table)
print(chi_result)

# Expected frequencies
chi_result$expected

###############################################
# 6. PREDICTIVE MODEL - LOGISTIC REGRESSION
###############################################

# Ensure binary target
df$attritionnum <- ifelse(df$attrition == "Yes", 1, 0)

# Train-test split (80/20)
set.seed(42)
train_index <- sample(seq_len(nrow(df)), size = 0.8 * nrow(df))
train_data <- df[train_index, ]
test_data  <- df[-train_index, ]

cat("Training rows:", nrow(train_data), "\n")
cat("Testing rows :", nrow(test_data), "\n")

# Fit logistic regression model
logit_model <- glm(
  attritionnum ~ engagement_score,
  data = train_data,
  family = binomial()
)

summary(logit_model)

# Coefficients & odds ratio
coef(logit_model)
exp(coef(logit_model))

# Example predictions
example <- data.frame(engagement_score = c(1.0, 2.5, 4.0))
predict(logit_model, newdata = example, type = "response")

###############################################
# 7. MODEL EVALUATION - CONFUSION MATRIX & METRICS
###############################################

# Predict on test set
predicted_probs  <- predict(logit_model, newdata = test_data, type = "response")
predicted_class  <- ifelse(predicted_probs > 0.5, 1, 0)

conf_matrix <- table(
  Predicted = predicted_class,
  Actual    = test_data$attritionnum
)
print(conf_matrix)

TP <- conf_matrix["1", "1"]
TN <- conf_matrix["0", "0"]
FP <- conf_matrix["1", "0"]
FN <- conf_matrix["0", "1"]

accuracy  <- (TP + TN) / sum(conf_matrix)
precision <- TP / (TP + FP)
recall    <- TP / (TP + FN)

cat("Accuracy:", round(accuracy, 4), "\n")
cat("Precision:", round(precision, 4), "\n")
cat("Recall   :", round(recall, 4), "\n")

# Pseudo R²
null_model <- glm(attritionnum ~ 1, data = train_data, family = binomial())
pseudo_r2  <- 1 - (logLik(logit_model) / logLik(null_model))
cat("Pseudo R^2:", round(as.numeric(pseudo_r2), 5), "\n")

###############################################
# 8. VISUALS FOR MODEL
###############################################

# Probability curve
ggplot(df, aes(x = engagement_score, y = attritionnum)) +
  stat_smooth(
    method = "glm",
    method.args = list(family = "binomial"),
    se = FALSE,
    color = "red"
  ) +
  labs(
    title = "Logistic Regression: EngagementScore -> Attrition",
    x = "Engagement Score",
    y = "Probability of Attrition"
  ) +
  theme_minimal()

# Distribution of predicted probabilities
prob_df <- data.frame(
  prob = predicted_probs,
  actual = factor(test_data$attritionnum, labels = c("Stayed", "Left"))
)

ggplot(prob_df, aes(x = prob, fill = actual)) +
  geom_histogram(position = "identity", alpha = 0.6, bins = 30) +
  labs(
    title = "Distribution of Predicted Attrition Probabilities",
    x = "Predicted Probability of Attrition",
    y = "Count",
    fill = "Actual"
  ) +
  theme_minimal()
