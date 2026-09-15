# Tech Sales Representative Performance Analysis
# Portfolio project using R
#
# Purpose:
# Explore characteristics associated with Net Promoter Score (NPS)
# among technology sales representatives.
#
# Data:
# This script expects BigDataFiles.xlsx to be stored locally in the
# same folder as this script. The workbook itself does not need to be
# published to GitHub if redistribution is not permitted.

library(readxl)

# ------------------------------------------------------------
# 1. Import data
# ------------------------------------------------------------

data_file <- "BigDataFiles.xlsx"

if (!file.exists(data_file)) {
  stop("BigDataFiles.xlsx was not found. Place the workbook in the same folder as this R script.")
}

TechSales <- read_excel(data_file, sheet = "TechSales_Reps")

# Review structure
str(TechSales)
summary(TechSales)

# ------------------------------------------------------------
# 2. Data quality checks
# ------------------------------------------------------------

# Dataset dimensions
dim(TechSales)

# Missing values by variable
colSums(is.na(TechSales))

# Check categorical variables
table(TechSales$Business, useNA = "ifany")
table(TechSales$Female, useNA = "ifany")
table(TechSales$College, useNA = "ifany")
table(TechSales$Personality, useNA = "ifany")

# Note:
# The source workbook spells the variable "Certficates".
# The original spelling is retained here so the code matches the data.

# ------------------------------------------------------------
# 3. Descriptive statistics
# ------------------------------------------------------------

numeric_vars <- c("Age", "Years", "Certficates", "Feedback", "Salary", "NPS")

descriptive_stats <- data.frame(
  Variable = numeric_vars,
  Mean = sapply(TechSales[numeric_vars], mean, na.rm = TRUE),
  Median = sapply(TechSales[numeric_vars], median, na.rm = TRUE),
  SD = sapply(TechSales[numeric_vars], sd, na.rm = TRUE)
)

print(descriptive_stats)

# Category proportions
prop.table(table(TechSales$Business)) * 100
prop.table(table(TechSales$Female)) * 100
prop.table(table(TechSales$College)) * 100
prop.table(table(TechSales$Personality)) * 100

# ------------------------------------------------------------
# 4. Distribution visualizations
# ------------------------------------------------------------

hist(
  TechSales$Age,
  main = "Distribution of Sales Representative Age",
  xlab = "Age",
  ylab = "Frequency"
)

hist(
  TechSales$Years,
  main = "Distribution of Years of Experience",
  xlab = "Years of Experience",
  ylab = "Frequency"
)

hist(
  TechSales$Salary,
  main = "Distribution of Salary",
  xlab = "Salary",
  ylab = "Frequency"
)

hist(
  TechSales$NPS,
  main = "Distribution of NPS",
  xlab = "NPS",
  ylab = "Frequency"
)

barplot(
  table(TechSales$Business),
  main = "Sales Representatives by Business Type",
  xlab = "Business Type",
  ylab = "Number of Representatives"
)

barplot(
  table(TechSales$Personality),
  main = "Sales Representatives by Personality Type",
  xlab = "Personality Type",
  ylab = "Number of Representatives"
)

# ------------------------------------------------------------
# 5. Relationships with NPS
# ------------------------------------------------------------

plot(
  TechSales$Age,
  TechSales$NPS,
  xlab = "Age",
  ylab = "NPS",
  main = "NPS vs. Age"
)

plot(
  TechSales$Years,
  TechSales$NPS,
  xlab = "Years of Experience",
  ylab = "NPS",
  main = "NPS vs. Experience"
)

plot(
  TechSales$Certficates,
  TechSales$NPS,
  xlab = "Number of Certificates",
  ylab = "NPS",
  main = "NPS vs. Certificates"
)

plot(
  TechSales$Feedback,
  TechSales$NPS,
  xlab = "Feedback Score",
  ylab = "NPS",
  main = "NPS vs. Feedback"
)

plot(
  TechSales$Salary,
  TechSales$NPS,
  xlab = "Salary",
  ylab = "NPS",
  main = "NPS vs. Salary"
)

# ------------------------------------------------------------
# 6. Correlation analysis
# ------------------------------------------------------------

correlation_matrix <- cor(
  TechSales[, numeric_vars],
  use = "complete.obs"
)

print(round(correlation_matrix, 3))

# Correlations specifically with NPS
nps_correlations <- sort(
  correlation_matrix[, "NPS"],
  decreasing = TRUE
)

print(round(nps_correlations, 3))

# ------------------------------------------------------------
# 7. NPS comparisons across groups
# ------------------------------------------------------------

boxplot(
  NPS ~ Business,
  data = TechSales,
  xlab = "Business Type",
  ylab = "NPS",
  main = "NPS by Business Type"
)

boxplot(
  NPS ~ Female,
  data = TechSales,
  xlab = "Female",
  ylab = "NPS",
  main = "NPS by Gender Indicator"
)

boxplot(
  NPS ~ College,
  data = TechSales,
  xlab = "College",
  ylab = "NPS",
  main = "NPS by College Indicator"
)

boxplot(
  NPS ~ Personality,
  data = TechSales,
  xlab = "Personality Type",
  ylab = "NPS",
  main = "NPS by Personality Type"
)

# Average NPS by group
aggregate(NPS ~ Business, data = TechSales, FUN = mean)
aggregate(NPS ~ Female, data = TechSales, FUN = mean)
aggregate(NPS ~ College, data = TechSales, FUN = mean)
aggregate(NPS ~ Personality, data = TechSales, FUN = mean)

# ------------------------------------------------------------
# 8. Key portfolio findings
# ------------------------------------------------------------

cat("\nKEY FINDINGS\n")
cat("------------\n")
cat("Rows analyzed:", nrow(TechSales), "\n")
cat("Missing values:", sum(is.na(TechSales)), "\n")
cat(
  "Correlation between Salary and NPS:",
  round(cor(TechSales$Salary, TechSales$NPS, use = "complete.obs"), 3),
  "\n"
)
cat(
  "Correlation between Certificates and NPS:",
  round(cor(TechSales$Certficates, TechSales$NPS, use = "complete.obs"), 3),
  "\n"
)
cat(
  "Correlation between Feedback and NPS:",
  round(cor(TechSales$Feedback, TechSales$NPS, use = "complete.obs"), 3),
  "\n"
)
cat(
  "Correlation between Years of Experience and NPS:",
  round(cor(TechSales$Years, TechSales$NPS, use = "complete.obs"), 3),
  "\n"
)
cat(
  "Correlation between Age and NPS:",
  round(cor(TechSales$Age, TechSales$NPS, use = "complete.obs"), 3),
  "\n"
)

cat("\nAverage NPS by personality type:\n")
print(
  aggregate(
    NPS ~ Personality,
    data = TechSales,
    FUN = mean
  )
)

# ------------------------------------------------------------
# 9. Portfolio visualizations
# ------------------------------------------------------------

# Create a folder for portfolio charts
if (!dir.exists("figures")) {
  dir.create("figures")
}

# Chart 1: Salary vs. NPS
png("figures/salary_vs_nps.png", width = 900, height = 600)
plot(
  TechSales$Salary,
  TechSales$NPS,
  xlab = "Salary",
  ylab = "NPS",
  main = "Salary vs. NPS",
  pch = 16,
  cex = 0.5
)
abline(
  lm(NPS ~ Salary, data = TechSales),
  lwd = 2
)
dev.off()

# Chart 2: Certificates vs. NPS
png("figures/certificates_vs_nps.png", width = 900, height = 600)
plot(
  TechSales$Certficates,
  TechSales$NPS,
  xlab = "Number of Certificates",
  ylab = "NPS",
  main = "Certificates vs. NPS",
  pch = 16,
  cex = 0.5
)
abline(
  lm(NPS ~ Certficates, data = TechSales),
  lwd = 2
)
dev.off()

# Chart 3: Average NPS by Personality
personality_nps <- aggregate(
  NPS ~ Personality,
  data = TechSales,
  FUN = mean
)

png("figures/nps_by_personality.png", width = 900, height = 600)
barplot(
  personality_nps$NPS,
  names.arg = personality_nps$Personality,
  xlab = "Personality Type",
  ylab = "Average NPS",
  main = "Average NPS by Personality Type",
  ylim = c(0, 10)
)
dev.off()

# End of analysis

