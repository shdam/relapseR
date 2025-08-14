# Load the ggplot2 library
library(ggplot2)
library(ggpubr)

# Create a data frame with the scores
data <- data.frame(
  Score = factor(c(
    "pLDDT",
    "pLDDT",
    "AbAg pLDDT",
    "AbAg pLDDT",
    "pseudo-perplexity",
    "pseudo-perplexity"
  ), levels = c("pLDDT", "AbAg pLDDT", "pseudo-perplexity")),
  Value = c(87.14, 80.68, 83.3, 76.6, 5.97, 4.06),
  Variant = c(
    "Canonical",
    "deltaexon2",
    "Canonical",
    "deltaexon2",
    "Canonical",
    "deltaexon2"
  )
)

# Create a bar plot using ggplot2
ggplot(data, aes(x = Score, y = Value, fill = Variant)) +
  geom_bar(stat = "identity", position = position_dodge(width = .93)) +
  labs(
    title = "",
    x = "",
    y = "Score"
  ) +
  ggpubr::fill_palette(palette = c("#95bdc6", "#d3888c")) +#c("#5e8d2a", "#4f78c3")) + #c("darkred", "darkblue")) +#c("#95bdc6", "#d3888c")) +#"uchicago") +
  ggpubr::theme_pubr() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))




library(ggplot2)
library(ggpubr)

# Create a data frame with the scores
data <- data.frame(
  Score = factor(c(
    "pLDDT",
    "pLDDT",
    "AbAg pLDDT",
    "AbAg pLDDT",
    "pseudo-perplexity (%)",
    "pseudo-perplexity (%)"
  ), levels = c("pLDDT", "AbAg pLDDT", "pseudo-perplexity (%)")),
  Value = c(87.14, 80.68, 83.3, 76.6, 5.97, 4.06),
  Variant = c(
    "Canonical",
    "Δexon2",
    "Canonical",
    "Δexon2",
    "Canonical",
    "Δexon2"
  )
)

# Adjust pseudo-perplexity values to be relative
data$Value[data$Score == "pseudo-perplexity (%)"] <- data$Value[data$Score == "pseudo-perplexity (%)"] / max(data$Value[data$Score == "pseudo-perplexity (%)"]) * 100

# Create a bar plot using ggplot2
AF_bar <- ggplot(data, aes(x = Score, y = Value, fill = Variant)) +
  geom_bar(stat = "identity", position = position_dodge(width = .93)) +
  geom_text(aes(label = round(Value, 1)), vjust = -0.5, position = position_dodge(width = .93)) +
  labs(
    title = "",
    x = "",
    y = "Score"
  ) +
  coord_cartesian(ylim = c(50, 105)) +
  # scale_y_continuous(limits = c(50, 105)) +
  ggpubr::fill_palette(palette = c("#95bdc6", "#d3888c")) +
  ggpubr::theme_pubr() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
AF_bar
ggsave(AF_bar, filename = "figs/AF_barchart.png")
